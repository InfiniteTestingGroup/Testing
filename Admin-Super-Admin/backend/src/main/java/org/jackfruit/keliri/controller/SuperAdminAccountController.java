package org.jackfruit.keliri.controller;

import java.util.List;

import org.jackfruit.keliri.model.PasswordSetupRequest;
import org.jackfruit.keliri.model.SuperAdminAccountDto;
import org.jackfruit.keliri.service.JwtService;
import org.jackfruit.keliri.service.SuperAdminAccountService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import io.jsonwebtoken.Claims;

@RestController
@RequestMapping("/api/superadmin/sub-admins")
public class SuperAdminAccountController {
    private final SuperAdminAccountService accountService;
    private final JwtService jwtService;

    public SuperAdminAccountController(SuperAdminAccountService accountService, JwtService jwtService) {
        this.accountService = accountService;
        this.jwtService = jwtService;
    }

    @GetMapping
    public ResponseEntity<List<SuperAdminAccountDto.SubAdminSummary>> listSubAdmins(
            @RequestHeader(value = "Authorization", required = false) String authorization) {
        requireMaster(authorization);
        return ResponseEntity.ok(accountService.listSubAdmins());
    }

    @PostMapping
    public ResponseEntity<SuperAdminAccountDto.SubAdminSummary> createSubAdmin(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @RequestBody SuperAdminAccountDto.CreateSubAdminRequest request) {
        requireMaster(authorization);
        return ResponseEntity.ok(accountService.createSubAdmin(request));
    }

    @PostMapping("/setup-password")
    public ResponseEntity<SuperAdminAccountDto.SubAdminSummary> setupPassword(
            @RequestBody PasswordSetupRequest request) {
        // This endpoint doesn't require authorization - it uses a token instead
        if (request.getSetupToken() == null || request.getSetupToken().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Setup token is required");
        }
        return ResponseEntity.ok(accountService.setPasswordWithToken(request.getSetupToken(), request.getNewPassword()));
    }

    @PutMapping("/{id}")
    public ResponseEntity<SuperAdminAccountDto.SubAdminSummary> updateSubAdmin(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @PathVariable String id,
            @RequestBody SuperAdminAccountDto.UpdateSubAdminRequest request) {
        requireMaster(authorization);
        return ResponseEntity.ok(accountService.updateSubAdmin(id, request));
    }

    @PostMapping("/{id}/lock")
    public ResponseEntity<SuperAdminAccountDto.SubAdminSummary> lockSubAdmin(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @PathVariable String id) {
        requireMaster(authorization);
        return ResponseEntity.ok(accountService.lockSubAdmin(id));
    }

    @PostMapping("/{id}/unlock")
    public ResponseEntity<SuperAdminAccountDto.SubAdminSummary> unlockSubAdmin(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @PathVariable String id) {
        requireMaster(authorization);
        return ResponseEntity.ok(accountService.unlockSubAdmin(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSubAdmin(
            @RequestHeader(value = "Authorization", required = false) String authorization,
            @PathVariable String id) {
        requireMaster(authorization);
        accountService.deleteSubAdmin(id);
        return ResponseEntity.noContent().build();
    }

    private void requireMaster(String authorization) {
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Authorization token is required");
        }

        String token = authorization.substring(7).trim();
        try {
            Claims claims = jwtService.parseToken(token);
            String role = jwtService.normalizeRole(claims.get("role", String.class));
            if (!JwtService.MASTER_SUPER_ADMIN.equalsIgnoreCase(role)) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Only Master Super Admin can manage Sub-Super Admins");
            }
        } catch (ResponseStatusException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid or expired token");
        }
    }
}
