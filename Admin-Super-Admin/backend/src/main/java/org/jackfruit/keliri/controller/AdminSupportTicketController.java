package org.jackfruit.keliri.controller;

import io.jsonwebtoken.Claims;
import org.jackfruit.keliri.model.Ticket;
import org.jackfruit.keliri.service.JwtService;
import org.jackfruit.keliri.service.SupportTicketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/admin/tickets")
public class AdminSupportTicketController {

    @Autowired
    private SupportTicketService ticketService;

    @Autowired
    private JwtService jwtService;

    private String getAdminIdFromAuth(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) return null;
        try {
            String token = authHeader.substring(7);
            Claims claims = jwtService.parseToken(token);
            return claims.get("userId", String.class);
        } catch (Exception e) {
            return null;
        }
    }

    @PostMapping
    public ResponseEntity<?> createTicket(@RequestHeader(value = "Authorization", required = false) String auth, @RequestBody Map<String, String> body) {
        String adminId = getAdminIdFromAuth(auth);
        if (adminId == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "message", "Unauthorized"));
        
        String subject = body.get("subject");
        String category = body.get("category");
        String message = body.get("message");
        
        if (subject == null || message == null) {
             return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Subject and message are required"));
        }

        Ticket ticket = ticketService.createTicket(adminId, subject, category, message);
        return ResponseEntity.ok(Map.of("success", true, "ticket", ticket));
    }

    @GetMapping
    public ResponseEntity<?> getTickets(@RequestHeader(value = "Authorization", required = false) String auth) {
        String adminId = getAdminIdFromAuth(auth);
        if (adminId == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "message", "Unauthorized"));
        
        return ResponseEntity.ok(Map.of("success", true, "tickets", ticketService.getTicketsForAdmin(adminId)));
    }

    @GetMapping("/{ticketId}")
    public ResponseEntity<?> getTicketDetail(@RequestHeader(value = "Authorization", required = false) String auth, @PathVariable String ticketId) {
        String adminId = getAdminIdFromAuth(auth);
        if (adminId == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "message", "Unauthorized"));
        
        Map<String, Object> detail = ticketService.getTicketDetail(ticketId);
        if (detail == null) return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("success", false, "message", "Ticket not found"));
        
        Ticket t = (Ticket) detail.get("ticket");
        if (!t.getAdminId().equals(adminId)) return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("success", false, "message", "Forbidden"));

        return ResponseEntity.ok(Map.of("success", true, "data", detail));
    }

    @PostMapping("/{ticketId}/reply")
    public ResponseEntity<?> replyTicket(@RequestHeader(value = "Authorization", required = false) String auth, @PathVariable String ticketId, @RequestBody Map<String, String> body) {
        String adminId = getAdminIdFromAuth(auth);
        if (adminId == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "message", "Unauthorized"));
        
        Map<String, Object> detail = ticketService.getTicketDetail(ticketId);
        if (detail == null) return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("success", false, "message", "Ticket not found"));
        
        Ticket t = (Ticket) detail.get("ticket");
        if (!t.getAdminId().equals(adminId)) return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("success", false, "message", "Forbidden"));

        String message = body.get("message");
        if (message == null || message.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Message is required"));
        }

        return ResponseEntity.ok(Map.of("success", true, "message", ticketService.replyToTicket(ticketId, "ADMIN", message)));
    }

    @PatchMapping("/{ticketId}/reopen")
    public ResponseEntity<?> reopenTicket(@RequestHeader(value = "Authorization", required = false) String auth, @PathVariable String ticketId) {
        String adminId = getAdminIdFromAuth(auth);
        if (adminId == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "message", "Unauthorized"));
        
        Map<String, Object> detail = ticketService.getTicketDetail(ticketId);
        if (detail == null) return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("success", false, "message", "Ticket not found"));
        
        Ticket t = (Ticket) detail.get("ticket");
        if (!t.getAdminId().equals(adminId)) return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("success", false, "message", "Forbidden"));

        return ResponseEntity.ok(Map.of("success", true, "ticket", ticketService.updateTicketStatus(ticketId, "OPEN")));
    }
}
