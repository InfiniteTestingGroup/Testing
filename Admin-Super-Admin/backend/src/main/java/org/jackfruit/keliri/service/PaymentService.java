package org.jackfruit.keliri.service;

import org.jackfruit.keliri.model.PaymentTransaction;
import org.jackfruit.keliri.model.SuperAdmin;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.repository.PaymentTransactionRepository;
import org.jackfruit.keliri.repository.SuperAdminRepository;
import org.jackfruit.keliri.repository.ad_campaignsRepository;
import org.jackfruit.keliri.repository.advertisementsRepository;
import org.jackfruit.keliri.repository.companiesRepository;
import org.jackfruit.keliri.repository.AdminRegistrationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

/**
 * Centralized service for finalizing payment transactions.
 * Used by AdminPaymentController (/verify, /mark-failed) and
 * StalePendingCleanupJob.
 */
@Service
public class PaymentService {

  @Autowired
  private PaymentTransactionRepository paymentRepo;

  @Autowired
  private ad_campaignsRepository campaignRepo;

  @Autowired
  private advertisementsRepository adsRepo;

  @Autowired
  private SuperAdminRepository superAdminRepo;

  @Autowired
  private companiesRepository companiesRepo;

  @Autowired
  private AdminRegistrationRepository adminRegistrationRepo;

  @Autowired
  private EmailService emailService;

  @Autowired
  private InvoiceService invoiceService;

  /**
   * Marks a payment transaction as SUCCESS, activates the associated ad/campaign,
   * generates a PDF invoice, and sends an invoice email.
   * Idempotent: skips if the transaction is already SUCCESS.
   *
   * @param razorpayOrderId   The Razorpay order ID.
   * @param razorpayPaymentId The Razorpay payment ID (may be null if called from
   *                          stale job).
   * @param razorpaySignature The Razorpay payment signature (may be null if
   *                          called from stale job).
   * @return true if the transaction was found and updated, false otherwise.
   */
  public boolean fulfillPayment(String razorpayOrderId, String razorpayPaymentId, String razorpaySignature) {
    Optional<PaymentTransaction> optTxn = paymentRepo.findByRazorpayOrderId(razorpayOrderId);
    if (optTxn.isEmpty()) {
      System.err.println("[PaymentService] fulfillPayment: No transaction found for orderId=" + razorpayOrderId);
      return false;
    }

    PaymentTransaction txn = optTxn.get();

    // Idempotency: skip if already finalized
    if ("SUCCESS".equals(txn.getStatus())) {
      System.out
          .println("[PaymentService] fulfillPayment: Already SUCCESS, skipping. orderId=" + razorpayOrderId);
      return true;
    }

    txn.setStatus("SUCCESS");
    txn.setUpdatedAt(Instant.now());

    if (razorpayPaymentId != null && !razorpayPaymentId.isBlank()) {
      txn.setRazorpayPaymentId(razorpayPaymentId);
    }
    if (razorpaySignature != null && !razorpaySignature.isBlank()) {
      txn.setRazorpaySignature(razorpaySignature);
    }

    // Enrich publisher name if missing
    if (txn.getPublisherName() == null && txn.getAdminId() != null) {
      try {
        List<org.jackfruit.keliri.model.companies> comps = companiesRepo.findByAdminId(txn.getAdminId());
        if (!comps.isEmpty() && comps.get(0).getName() != null) {
          txn.setPublisherName(comps.get(0).getName());
        }
      } catch (Exception ignored) {
      }
    }

    // Enrich lat/lng from AdminRegistration if missing
    if (txn.getLatitude() == null && txn.getAdminId() != null) {
      try {
        Optional<org.jackfruit.keliri.model.AdminRegistration> regOpt = adminRegistrationRepo
            .findById(txn.getAdminId());
        if (regOpt.isPresent()) {
          org.jackfruit.keliri.model.AdminRegistration reg = regOpt.get();
          if (reg.getLatitude() != null)
            txn.setLatitude(String.valueOf(reg.getLatitude()));
          if (reg.getLongitude() != null)
            txn.setLongitude(String.valueOf(reg.getLongitude()));
        }
      } catch (Exception ignored) {
      }
    }

    paymentRepo.save(txn);

    // Activate campaign and mark ad as Paid
    updateCampaignStatus(txn.getAdId());
    updateAdPaymentStatus(txn.getAdId());

    // Generate PDF invoice and send email (non-blocking failure)
    try {
      if (txn.getAdminId() != null) {
        Optional<SuperAdmin> adminOpt = superAdminRepo.findById(txn.getAdminId());
        if (adminOpt.isPresent()) {
          SuperAdmin admin = adminOpt.get();
          String adminName = (admin.getName() != null && !admin.getName().isEmpty())
              ? admin.getName()
              : "Admin";

          String invoiceRef = (razorpayPaymentId != null && !razorpayPaymentId.isBlank())
              ? razorpayPaymentId
              : razorpayOrderId;

          byte[] invoicePdf = invoiceService.generatePdfInvoice(
              invoiceRef, txn.getAdId(), txn.getAmount(), adminName);

          if (admin.getEmail() != null) {
            emailService.sendInvoiceEmail(
                admin.getEmail(), adminName, txn.getAdId(),
                txn.getAmount(), invoicePdf);
          }
        }
      }
    } catch (Exception e) {
      System.err.println("[PaymentService] Invoice generation/email failed for orderId="
          + razorpayOrderId + ": " + e.getMessage());
    }

    System.out.println("[PaymentService] fulfillPayment: SUCCESS. orderId=" + razorpayOrderId);
    return true;
  }

  /**
   * Marks a payment transaction as FAILED.
   * Idempotent: skips if the transaction is already SUCCESS or FAILED.
   *
   * @param razorpayOrderId The Razorpay order ID.
   * @return true if found (and updated or already finalized), false if not found.
   */
  public boolean failPayment(String razorpayOrderId) {
    Optional<PaymentTransaction> optTxn = paymentRepo.findByRazorpayOrderId(razorpayOrderId);
    if (optTxn.isEmpty()) {
      System.err.println("[PaymentService] failPayment: No transaction found for orderId=" + razorpayOrderId);
      return false;
    }

    PaymentTransaction txn = optTxn.get();

    // Idempotency: skip if already finalized
    if ("SUCCESS".equals(txn.getStatus()) || "FAILED".equals(txn.getStatus())) {
      System.out.println("[PaymentService] failPayment: Already " + txn.getStatus()
          + ", skipping. orderId=" + razorpayOrderId);
      return true;
    }

    txn.setStatus("FAILED");
    txn.setUpdatedAt(Instant.now());
    paymentRepo.save(txn);

    System.out.println("[PaymentService] failPayment: FAILED. orderId=" + razorpayOrderId);
    return true;
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  private void updateAdPaymentStatus(String adId) {
    if (adId == null)
      return;
    try {
      Optional<org.jackfruit.keliri.model.advertisements> adOpt = adsRepo.findByUid(adId);
      if (adOpt.isPresent()) {
        org.jackfruit.keliri.model.advertisements ad = adOpt.get();
        ad.setPaymentStatus("Paid");
        adsRepo.save(ad);
      }
    } catch (Exception e) {
      System.err.println("[PaymentService] updateAdPaymentStatus failed: " + e.getMessage());
    }
  }

  private void updateCampaignStatus(String adId) {
    if (adId == null)
      return;
    try {
      List<ad_campaigns> campaigns = campaignRepo.findByAdvertisementId(adId);
      for (ad_campaigns campaign : campaigns) {
        if ("PENDING".equalsIgnoreCase(campaign.getCompaignsStatus())
            || "INACTIVE".equalsIgnoreCase(campaign.getCompaignsStatus())) {
          campaign.setCompaignsStatus("ACTIVE");
          campaignRepo.save(campaign);
        }
      }
    } catch (Exception e) {
      System.err.println("[PaymentService] updateCampaignStatus failed: " + e.getMessage());
    }
  }
}
