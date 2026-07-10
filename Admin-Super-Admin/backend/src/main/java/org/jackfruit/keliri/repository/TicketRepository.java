package org.jackfruit.keliri.repository;

import org.jackfruit.keliri.model.Ticket;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TicketRepository extends MongoRepository<Ticket, String> {
    List<Ticket> findByAdminIdOrderByUpdatedAtDesc(String adminId);
}
