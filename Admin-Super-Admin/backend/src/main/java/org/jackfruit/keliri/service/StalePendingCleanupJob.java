package org.jackfruit.keliri.service;

import com.razorpay.Order;
import com.razorpay.Payment;
import com.razorpay.RazorpayClient;
import org.jackfruit.keliri.model.PaymentTransaction;
import org.jackfruit.keliri.repository.PaymentTransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Scheduled job that polls for stale PENDING payment transactions and
 * reconciles
 * them against the Razorpay Orders API.
 *
 * For each PENDING transaction older than the configured threshold:
 * - If Razorpay says "paid" → finalize as SUCCESS via PaymentService
 * - If Razorpay says "created"
 * or "attempted" → mark as FAILED via PaymentService
 * - On Razorpay API error → skip and log (don't fail the whole batch)
 */
@Component
public class StalePendingCleanupJob {

    @Autowired
    private PaymentTransactionRepository paymentRepo;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private RazorpayClient razorpayClient;

    /**
     * How old a PENDING transaction must be (in minutes) before we consider it
     * stale.
     * Defaults to 20 minutes.
     */
    @Value("${payment.stale.threshold-minutes:20}")
    private int staleThresholdMinutes;

    /**
     * Runs every 5 minutes (300000 ms).
     */
    @Scheduled(fixedDelayString = "${payment.stale.fixed-delay-ms:300000}")
    public void reconcileStalePendingTransactions() {
        Instant cutoff = Instant.now().minus(staleThresholdMinutes, ChronoUnit.MINUTES);
        List<PaymentTransaction> stalePending = paymentRepo.findByStatusAndCreatedAtBefore("PENDING", cutoff);

        if (stalePending.isEmpty()) {
            return;
        }

        System.out.println("[StalePendingCleanup] Found " + stalePending.size()
                + " stale PENDING transaction(s) older than " + staleThresholdMinutes + " min.");

        for (PaymentTransaction txn : stalePending) {
            String orderId = txn.getRazorpayOrderId();
            if (orderId == null || orderId.isBlank()) {
                System.err.println("[StalePendingCleanup] Skipping txn with null/blank orderId: " + txn.getId());
                continue;
            }

            try {
                // Query Razorpay Orders API for the authoritative status
                Order order = razorpayClient.orders.fetch(orderId);
                String rzpStatus = order.get("status") != null ? order.get("status").toString() : "";

                System.out.println("[StalePendingCleanup] orderId=" + orderId
                        + " razorpayStatus=" + rzpStatus);

                switch (rzpStatus) {
                    case "paid":
                        // Payment was captured on Razorpay side but our backend missed the callback.
                        // Try to extract the payment ID from the order's associated payments.
                        String paymentId = null;
                        try {
                            List<Payment> payments = razorpayClient.orders.fetchPayments(orderId);
                            if (payments != null && !payments.isEmpty()) {
                                // Find the first captured payment
                                for (Payment p : payments) {
                                    String pStatus = p.get("status") != null ? p.get("status").toString() : "";
                                    if ("captured".equals(pStatus)) {
                                        paymentId = p.get("id") != null ? p.get("id").toString() : null;
                                        break;
                                    }
                                }
                                // Fallback: use the first payment regardless of status
                                if (paymentId == null) {
                                    Payment first = payments.get(0);
                                    paymentId = first.get("id") != null ? first.get("id").toString() : null;
                                }
                            }
                        } catch (Exception e) {
                            System.err.println("[StalePendingCleanup] Could not fetch payments for orderId="
                                    + orderId + ": " + e.getMessage());
                        }

                        paymentService.fulfillPayment(orderId, paymentId, null);
                        break;

                    case "created":
                    case "attempted":
                        // Order was created but never paid, or payment was attempted but failed.
                        paymentService.failPayment(orderId);
                        break;

                    default:
                        System.out.println("[StalePendingCleanup] Unknown status '" + rzpStatus
                                + "' for orderId=" + orderId + ". Skipping.");
                        break;
                }

            } catch (Exception e) {
                // Don't let one failure kill the whole batch
                System.err.println("[StalePendingCleanup] Error reconciling orderId=" + orderId
                        + ": " + e.getMessage());
            }
        }

        System.out.println("[StalePendingCleanup] Reconciliation pass complete.");
    }
}
