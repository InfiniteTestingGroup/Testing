package org.jackfruit.keliri.repository;

import org.jackfruit.keliri.model.TicketMessage;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TicketMessageRepository extends MongoRepository<TicketMessage, String> {
    List<TicketMessage> findByTicketIdOrderByCreatedAtAsc(String ticketId);
}
