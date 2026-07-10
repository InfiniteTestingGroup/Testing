package org.jackfruit.keliri.repository;

import org.jackfruit.keliri.model.AdminRegistration;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.Optional;

public interface AdminRegistrationRepository extends MongoRepository<AdminRegistration, String> {
    Optional<AdminRegistration> findByEmailId(String emailId);
    
}
