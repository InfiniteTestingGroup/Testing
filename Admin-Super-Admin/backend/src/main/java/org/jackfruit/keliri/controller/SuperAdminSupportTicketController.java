package org.jackfruit.keliri.controller;

import org.jackfruit.keliri.model.Ticket;
import org.jackfruit.keliri.service.SupportTicketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/superadmin/tickets")
public class SuperAdminSupportTicketController {

    @Autowired
    private SupportTicketService ticketService;

    @GetMapping
    public ResponseEntity<?> getAllTickets(@RequestParam(required = false) String status, 
                                           @RequestParam(required = false) String adminId) {
        // Super admin auth filtering is generically scoped at routing level per user architectural patterns
        return ResponseEntity.ok(Map.of("success", true, "tickets", ticketService.getAllTickets(status, adminId)));
    }

    @GetMapping("/{ticketId}")
    public ResponseEntity<?> getTicketDetail(@PathVariable String ticketId) {
        Map<String, Object> detail = ticketService.getTicketDetail(ticketId);
        if (detail == null) return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("success", false, "message", "Ticket not found"));
        
        return ResponseEntity.ok(Map.of("success", true, "data", detail));
    }

    @PostMapping("/{ticketId}/reply")
    public ResponseEntity<?> replyTicket(@PathVariable String ticketId, @RequestBody Map<String, String> body) {
        String message = body.get("message");
        if (message == null || message.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Message is required"));
        }

        return ResponseEntity.ok(Map.of("success", true, "message", ticketService.replyToTicket(ticketId, "SUPER_ADMIN", message)));
    }

    @PatchMapping("/{ticketId}/status")
    public ResponseEntity<?> updateStatus(@PathVariable String ticketId, @RequestBody Map<String, String> body) {
        String newStatus = body.get("status");
        if (newStatus == null || newStatus.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Status is required"));
        }

        return ResponseEntity.ok(Map.of("success", true, "ticket", ticketService.updateTicketStatus(ticketId, newStatus)));
    }
}
