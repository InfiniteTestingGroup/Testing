package org.jackfruit.keliri.controller;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.razorpay.Utils;
import io.jsonwebtoken.Claims;
import org.jackfruit.keliri.model.PaymentTransaction;
import org.jackfruit.keliri.repository.PaymentTransactionRepository;
import org.jackfruit.keliri.repository.SuperAdminRepository;
import org.jackfruit.keliri.service.JwtService;
import org.jackfruit.keliri.service.PaymentService;
import org.jackfruit.keliri.model.SuperAdmin;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/admin/payments")
public class AdminPaymentController {

    @Autowired
    private RazorpayClient razorpayClient;

    @Autowired
    private PaymentTransactionRepository paymentRepo;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private SuperAdminRepository superAdminRepo;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private org.jackfruit.keliri.repository.AdminRegistrationRepository adminRegistrationRepo;

    @Value("${razorpay.key.id}")
    private String keyId;

    @Value("${razorpay.key.secret}")
    private String keySecret;

    @Value("${razorpay.currency}")
    private String currency;

    @PostMapping("/create-order")
    public ResponseEntity<?> createOrder(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestBody Map<String, Object> data) {
        try {
            String adminId = extractAdminId(authHeader);
            if (adminId == null)
                return unauthorized();

            String adId = (String) data.get("adId");
            double amount = Double.parseDouble(data.get("amount").toString());

            int amountInPaise = (int) (amount * 100);

            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amountInPaise);
            orderRequest.put("currency", currency);
            orderRequest.put("receipt", "txn_" + System.currentTimeMillis());

            Order order = razorpayClient.orders.create(orderRequest);

            // Resolve admin name for display in superadmin UI
            String adminName = "System";
            try {
                Optional<SuperAdmin> saOpt = superAdminRepo.findById(adminId);
                if (saOpt.isPresent() && saOpt.get().getName() != null
                        && !saOpt.get().getName().isBlank()) {
                    adminName = saOpt.get().getName();
                } else {
                    Optional<org.jackfruit.keliri.model.AdminRegistration> regOpt = adminRegistrationRepo
                            .findById(adminId);
                    if (regOpt.isPresent() && regOpt.get().getAuthorizedPerson() != null) {
                        adminName = regOpt.get().getAuthorizedPerson();
                    }
                }
            } catch (Exception ignored) {
            }

            // Save transaction as PENDING
            PaymentTransaction transaction = new PaymentTransaction();
            transaction.setAdminId(adminId);
            transaction.setAdId(adId);
            transaction.setAmount(amount);
            transaction.setCurrency(currency);
            transaction.setRazorpayOrderId(order.get("id"));
            transaction.setStatus("PENDING");
            transaction.setAdminName(adminName);
            transaction.setIncoming(true);
            transaction.setType("Ad Payment");
            transaction.setCreatedAt(Instant.now());
            transaction.setUpdatedAt(Instant.now());
            paymentRepo.save(transaction);

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "id", order.get("id"),
                    "amount", order.get("amount"),
                    "currency", order.get("currency"),
                    "keyId", keyId));

        } catch (RazorpayException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("success", false, "message", "Razorpay error: " + e.getMessage()));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Internal server error"));
        }
    }

    @PostMapping("/verify")
    public ResponseEntity<?> verifyPayment(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestBody Map<String, String> data) {
        try {
            String razorpayOrderId = data.get("razorpay_order_id");
            String razorpayPaymentId = data.get("razorpay_payment_id");
            String razorpaySignature = data.get("razorpay_signature");

            JSONObject options = new JSONObject();
            options.put("razorpay_order_id", razorpayOrderId);
            options.put("razorpay_payment_id", razorpayPaymentId);
            options.put("razorpay_signature", razorpaySignature);

            boolean isValid = Utils.verifyPaymentSignature(options, keySecret);

            if (isValid) {
                paymentService.fulfillPayment(razorpayOrderId, razorpayPaymentId, razorpaySignature);
                return ResponseEntity.ok(Map.of("success", true, "message", "Payment verified successfully"));
            } else {
                // Invalid signature — mark as FAILED
                try {
                    paymentService.failPayment(razorpayOrderId);
                } catch (Exception ex) {
                    System.err.println("Failed to mark transaction as FAILED: " + ex.getMessage());
                }
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Map.of("success", false, "message", "Invalid signature"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Internal server error"));
        }
    }

    /**
     * Allows the frontend to notify the backend when the user dismisses/cancels
     * the Razorpay payment modal. Looks up the transaction by orderId, verifies
     * it belongs to the authenticated admin, and if still PENDING, marks it as
     * FAILED.
     */
    @PostMapping("/mark-failed")
    public ResponseEntity<?> markFailed(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestBody Map<String, String> data) {
        try {
            String adminId = extractAdminId(authHeader);
            if (adminId == null)
                return unauthorized();

            String orderId = data.get("orderId");
            if (orderId == null || orderId.isBlank()) {
                return ResponseEntity.badRequest()
                        .body(Map.of("success", false, "message", "orderId is required"));
            }

            Optional<PaymentTransaction> optTxn = paymentRepo.findByRazorpayOrderId(orderId);
            if (optTxn.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("success", false, "message", "Transaction not found"));
            }

            PaymentTransaction txn = optTxn.get();

            // Verify this transaction belongs to the authenticated admin
            if (!adminId.equals(txn.getAdminId())) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("success", false, "message", "Not authorized for this transaction"));
            }

            // Only mark as failed if still pending
            if ("PENDING".equals(txn.getStatus())) {
                paymentService.failPayment(orderId);
                return ResponseEntity.ok(Map.of("success", true, "message", "Payment marked as failed"));
            } else {
                return ResponseEntity.ok(Map.of("success", true,
                        "message", "Transaction already finalized as " + txn.getStatus()));
            }

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Internal server error"));
        }
    }

    @GetMapping
    public ResponseEntity<?> getTransactions(
            @RequestHeader(value = "Authorization", required = false) String authHeader) {
        try {
            String adminId = extractAdminId(authHeader);
            if (adminId == null)
                return unauthorized();

            java.util.List<PaymentTransaction> transactions = paymentRepo.findByAdminId(adminId);
            return ResponseEntity.ok(Map.of("success", true, "data", transactions));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Internal server error"));
        }
    }

    @GetMapping("/paid-ads")
    public ResponseEntity<?> getPaidAdIds(
            @RequestHeader(value = "Authorization", required = false) String authHeader) {
        try {
            String adminId = extractAdminId(authHeader);
            if (adminId == null)
                return unauthorized();

            java.util.List<PaymentTransaction> successTxns = paymentRepo.findByAdminIdAndStatus(adminId, "SUCCESS");
            java.util.List<String> paidAdIds = successTxns.stream()
                    .map(PaymentTransaction::getAdId)
                    .filter(id -> id != null)
                    .distinct()
                    .collect(java.util.stream.Collectors.toList());

            return ResponseEntity.ok(Map.of("success", true, "paidAdIds", paidAdIds));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Internal server error"));
        }
    }

    private String extractAdminId(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer "))
            return null;
        try {
            Claims claims = jwtService.parseToken(authHeader.substring(7));
            return claims.get("userId", String.class);
        } catch (Exception e) {
            return null;
        }
    }

    private ResponseEntity<?> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(Map.of("success", false, "message", "Unauthorized"));
    }
}
