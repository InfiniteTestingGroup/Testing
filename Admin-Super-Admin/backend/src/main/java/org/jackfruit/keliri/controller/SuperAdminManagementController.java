package org.jackfruit.keliri.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.jackfruit.keliri.model.SuperAdminManagementResponse;
import org.jackfruit.keliri.service.SuperAdminManagementService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/superadmin")
public class SuperAdminManagementController {
    private final SuperAdminManagementService managementService;

    public SuperAdminManagementController(SuperAdminManagementService managementService) {
        this.managementService = managementService;
    }

    @GetMapping("/admins")
    public ResponseEntity<List<SuperAdminManagementResponse.AdminRecord>> getAdmins(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "status", required = false) String status) {
        return ResponseEntity.ok(managementService.getAdmins(search, status));
    }

    @GetMapping("/admins/{adminId}")
    public ResponseEntity<SuperAdminManagementResponse.AdminDetail> getAdminDetail(@PathVariable String adminId) {
        return ResponseEntity.ok(managementService.getAdminDetail(adminId));
    }

    @PostMapping("/admins/{adminId}/approve")
    public ResponseEntity<SuperAdminManagementResponse.AdminActionResponse> approveAdmin(@PathVariable String adminId) {
        return ResponseEntity.ok(managementService.approveAdmin(adminId));
    }

    @PostMapping("/admins/{adminId}/reject")
    public ResponseEntity<SuperAdminManagementResponse.AdminActionResponse> rejectAdmin(
            @PathVariable String adminId,
            @RequestBody(required = false) SuperAdminManagementResponse.AdminActionRequest request) {
        String reason = request != null ? request.getReason() : null;
        return ResponseEntity.ok(managementService.rejectAdmin(adminId, reason));
    }

    @PostMapping("/admins/{adminId}/suspend")
    public ResponseEntity<SuperAdminManagementResponse.AdminActionResponse> suspendAdmin(
            @PathVariable String adminId,
            @RequestBody(required = false) SuperAdminManagementResponse.AdminActionRequest request) {
        String reason = request != null ? request.getReason() : null;
        return ResponseEntity.ok(managementService.suspendAdmin(adminId, reason));
    }

    @PostMapping("/admins/{adminId}/reinstate")
    public ResponseEntity<SuperAdminManagementResponse.AdminActionResponse> reinstateAdmin(
            @PathVariable String adminId) {
        return ResponseEntity.ok(managementService.reinstateAdmin(adminId));
    }

    @org.springframework.web.bind.annotation.DeleteMapping("/admins/{adminId}")
    public ResponseEntity<Void> deleteAdmin(@PathVariable String adminId) {
        managementService.deleteAdmin(adminId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/admin-notifications")
    public ResponseEntity<List<SuperAdminManagementResponse.EmailNotificationRecord>> getEmailNotifications() {
        return ResponseEntity.ok(managementService.getEmailNotifications());
    }

    @GetMapping("/publishers")
    public ResponseEntity<List<SuperAdminManagementResponse.PublisherRecord>> getPublishers(
            @RequestParam(value = "adminId", required = false) String adminId,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "location", required = false) String location,
            @RequestParam(value = "search", required = false) String search) {

        System.out.println("Received adminId = " + adminId);

        List<SuperAdminManagementResponse.PublisherRecord> result = managementService.getPublishers(adminId, status,
                location, search);

        System.out.println("Publishers found = " + result.size());

        return ResponseEntity.ok(result);
    }

    @GetMapping("/publishers/{publisherId}")
    public ResponseEntity<SuperAdminManagementResponse.PublisherDetail> getPublisherDetail(
            @PathVariable String publisherId) {
        return ResponseEntity.ok(managementService.getPublisherDetail(publisherId));
    }

    @GetMapping("/ads")
    public ResponseEntity<List<SuperAdminManagementResponse.AdvertisementRecord>> getAdvertisements() {
        return ResponseEntity.ok(managementService.getAdvertisements());
    }

    @PostMapping("/ads/{campaignId}/suspend")
    public ResponseEntity<SuperAdminManagementResponse.AdvertisementRecord> suspendAdvertisement(
            @PathVariable String campaignId) {
        return ResponseEntity.ok(managementService.suspendAdvertisement(campaignId));
    }

    @GetMapping("/audit-logs")
    public ResponseEntity<List<SuperAdminManagementResponse.AuditLogRecord>> getAuditLogs(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "actionType", required = false) String actionType,
            @RequestParam(value = "actorRole", required = false) String actorRole,
            @RequestParam(value = "entityType", required = false) String entityType,
            @RequestParam(value = "fromDate", required = false) String fromDate,
            @RequestParam(value = "toDate", required = false) String toDate,
            @org.springframework.data.web.PageableDefault(size = 100, sort = "createdAt", direction = org.springframework.data.domain.Sort.Direction.DESC) org.springframework.data.domain.Pageable pageable) {
        return ResponseEntity
                .ok(managementService
                        .getAuditLogs(search, actionType, actorRole, entityType, fromDate, toDate, pageable)
                        .getContent());
    }

    @GetMapping("/payments")
    public ResponseEntity<List<SuperAdminManagementResponse.TransactionRecord>> getTransactions() {
        return ResponseEntity.ok(managementService.getTransactions());
    }

    @GetMapping("/payments/transaction/{transactionId}")
    public ResponseEntity<?> getTransactionById(@PathVariable String transactionId) {
        try {
            Optional<SuperAdminManagementResponse.TransactionRecord> txnOpt = 
                managementService.getTransactionById(transactionId);

            if (txnOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("success", false, "message", "Transaction not found"));
            }

            return ResponseEntity.ok(Map.of("success", true, "data", txnOpt.get()));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Internal server error"));
        }
    }

    @PostMapping("/publishers")
    public ResponseEntity<org.jackfruit.keliri.model.companies> createPublisher(
            @RequestBody org.jackfruit.keliri.model.Publisher publisher) {
        return ResponseEntity.ok(managementService.createPublisher(publisher));
    }
}
