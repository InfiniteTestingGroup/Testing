package org.jackfruit.keliri.repository;

import org.jackfruit.keliri.model.companies;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.Optional;
import java.util.List;
public interface CompanyRepository extends MongoRepository<companies, String> {
    Optional<companies> findByEmail(String email);
    Optional<companies> findByMobile(String mobile);
}
