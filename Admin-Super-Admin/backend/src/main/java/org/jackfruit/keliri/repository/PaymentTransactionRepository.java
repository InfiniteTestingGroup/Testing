package org.jackfruit.keliri.repository;

import org.jackfruit.keliri.model.PaymentTransaction;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.List;

@Repository
public interface PaymentTransactionRepository extends MongoRepository<PaymentTransaction, String> {
    Optional<PaymentTransaction> findByRazorpayOrderId(String razorpayOrderId);
    Optional<PaymentTransaction> findByRazorpayPaymentId(String razorpayPaymentId);

    List<PaymentTransaction> findByAdminId(String adminId);

    List<PaymentTransaction> findByAdminIdAndStatus(String adminId, String status);

    List<PaymentTransaction> findAllByOrderByCreatedAtDesc();

    /**
     * Find all transactions with a given status that were created before the cutoff
     * time.
     * Used by StalePendingCleanupJob to find PENDING transactions older than N
     * minutes.
     */
    List<PaymentTransaction> findByStatusAndCreatedAtBefore(String status, java.time.Instant cutoff);
}
