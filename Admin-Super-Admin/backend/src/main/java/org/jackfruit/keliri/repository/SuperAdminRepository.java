package org.jackfruit.keliri.repository;

import org.jackfruit.keliri.model.SuperAdmin;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;
import java.util.Optional;

public interface SuperAdminRepository extends MongoRepository<SuperAdmin, String> {
    Optional<SuperAdmin> findByEmail(String email);

    Optional<SuperAdmin> findByPhone(String phone);

    List<SuperAdmin> findByRole(String role);
}
