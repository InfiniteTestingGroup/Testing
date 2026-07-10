package org.jackfruit.keliri.repository;

import org.jackfruit.keliri.model.Publisher;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PublisherRepository extends MongoRepository<Publisher, String> {

    List<Publisher> findByAdminId(String adminId);

    long countByAdminId(String adminId);

    Optional<Publisher> findByEmail(String email);

    Optional<Publisher> findByMobile(String mobile);
}