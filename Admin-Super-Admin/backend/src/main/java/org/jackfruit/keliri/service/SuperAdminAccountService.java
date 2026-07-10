package org.jackfruit.keliri.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.jackfruit.keliri.model.SuperAdmin;
import org.jackfruit.keliri.model.SuperAdminAccountDto;
import org.jackfruit.keliri.repository.SuperAdminRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class SuperAdminAccountService {
    private final SuperAdminRepository superAdminRepository;
    private final SuperAdminAuthService authService;
    private final EmailService emailService;
    private final TokenService tokenService;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public SuperAdminAccountService(SuperAdminRepository superAdminRepository, SuperAdminAuthService authService,
            EmailService emailService, TokenService tokenService) {
        this.superAdminRepository = superAdminRepository;
        this.authService = authService;
        this.emailService = emailService;
        this.tokenService = tokenService;
    }

    public List<SuperAdminAccountDto.SubAdminSummary> listSubAdmins() {
        List<SuperAdminAccountDto.SubAdminSummary> records = new ArrayList<>();
        for (SuperAdmin account : superAdminRepository.findByRole("SUB_SUPER_ADMIN")) {
            records.add(toSummary(account));
        }
        records.sort((a, b) -> a.getEmail().compareToIgnoreCase(b.getEmail()));
        return records;
    }

    public SuperAdminAccountDto.SubAdminSummary createSubAdmin(SuperAdminAccountDto.CreateSubAdminRequest request) {
        if (request.getEmail() == null || request.getEmail().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email is required");
        }

        if (superAdminRepository.findByEmail(request.getEmail().trim()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already exists");
        }

        SuperAdmin account = new SuperAdmin();
        account.setName(request.getName() == null || request.getName().isBlank() ? "Sub Super Admin"
                : request.getName().trim());
        account.setEmail(request.getEmail().trim().toLowerCase());
        account.setPhone(request.getPhone());

        // Use the password provided in the request
        String plainPassword = request.getPassword() != null && !request.getPassword().isBlank()
                ? request.getPassword()
                : java.util.UUID.randomUUID().toString().substring(0, 12);

        account.setPassword(passwordEncoder.encode(plainPassword));
        account.setLocked(false);
        account.setFailedAttempts(0);
        account.setLockUntil(null);
        account.setRole("SUB_SUPER_ADMIN");
        account.setPermissions(normalizeSubPermissions(request.getPermissions()));
        superAdminRepository.save(account);

        // Generate setup token and send welcome email
        try {
            String setupToken = tokenService.generateSetupToken(account.getId());
            emailService.sendSubAdminWelcomeEmail(account.getEmail(), account.getName(), setupToken, plainPassword);
        } catch (Exception e) {
            // Log error but don't fail the account creation
            System.err.println("Failed to send welcome email to " + account.getEmail() + ": " + e.getMessage());
        }

        return toSummary(account);
    }

    public SuperAdminAccountDto.SubAdminSummary updateSubAdmin(String id,
            SuperAdminAccountDto.UpdateSubAdminRequest request) {
        SuperAdmin account = superAdminRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Sub admin not found"));

        if (!"SUB_SUPER_ADMIN".equalsIgnoreCase(account.getRole())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Only sub admins can be updated here");
        }

        if (request.getName() != null && !request.getName().isBlank()) {
            account.setName(request.getName().trim());
        }

        if (request.getPhone() != null) {
            account.setPhone(request.getPhone().trim());
        }

        if (request.getPermissions() != null) {
            account.setPermissions(normalizeSubPermissions(request.getPermissions()));
        }

        superAdminRepository.save(account);
        return toSummary(account);
    }

    public SuperAdminAccountDto.SubAdminSummary lockSubAdmin(String id) {
        SuperAdmin account = findSubAdmin(id);
        account.setLocked(true);
        superAdminRepository.save(account);

        // Send account locked notification email with unlock and reset links
        try {
            String unlockToken = tokenService.generateUnlockToken(account.getId());
            String resetToken = tokenService.generatePasswordResetToken(account.getId());
            emailService.sendAccountLockedEmail(account.getEmail(), account.getName(), unlockToken, resetToken);
        } catch (Exception e) {
            System.err.println("Failed to send account locked email to " + account.getEmail() + ": " + e.getMessage());
        }

        return toSummary(account);
    }

    public SuperAdminAccountDto.SubAdminSummary unlockSubAdmin(String id) {
        SuperAdmin account = findSubAdmin(id);
        account.setLocked(false);
        account.setFailedAttempts(0);
        account.setLockUntil(null);
        superAdminRepository.save(account);
        return toSummary(account);
    }

    public void deleteSubAdmin(String id) {
        SuperAdmin account = superAdminRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Sub admin not found"));

        if (!"SUB_SUPER_ADMIN".equalsIgnoreCase(account.getRole())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Only sub admins can be deleted here");
        }

        System.out.println("Deleting Sub-Admin: " + account.getEmail() + " (ID: " + id + ")");
        superAdminRepository.delete(account);

        // Also cleanup any associated tokens in memory
        tokenService.cleanupTokensForUser(id);
    }

    private SuperAdmin findSubAdmin(String id) {
        SuperAdmin account = superAdminRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Sub admin not found"));

        if (!"SUB_SUPER_ADMIN".equalsIgnoreCase(account.getRole())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Only sub admins can be managed here");
        }
        return account;
    }

    private Map<String, Boolean> normalizeSubPermissions(Map<String, Boolean> requested) {
        SuperAdmin dummy = new SuperAdmin();
        dummy.setRole("SUB_SUPER_ADMIN");
        dummy.setPermissions(requested == null ? Map.of() : requested);

        Map<String, Boolean> normalized = new LinkedHashMap<>(authService.normalizePermissions(dummy));
        normalized.put("subAdmins", false);
        return normalized;
    }

    /**
     * Set password for sub-admin using setup token (called from frontend after user
     * enters new password)
     */
    public SuperAdminAccountDto.SubAdminSummary setPasswordWithToken(String setupToken, String newPassword) {
        if (newPassword == null || newPassword.length() < 6) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Password must be at least 6 characters");
        }

        // Validate token
        TokenService.TokenData tokenData = tokenService.validateToken(setupToken, TokenService.TokenType.SETUP);

        SuperAdmin account = superAdminRepository.findById(tokenData.subAdminId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Sub admin not found"));

        // Update password
        account.setPassword(passwordEncoder.encode(newPassword));
        superAdminRepository.save(account);

        // Consume token
        tokenService.consumeToken(setupToken);

        return toSummary(account);
    }

    private SuperAdminAccountDto.SubAdminSummary toSummary(SuperAdmin account) {
        SuperAdminAccountDto.SubAdminSummary summary = new SuperAdminAccountDto.SubAdminSummary();
        summary.setId(account.getId());
        summary.setName(account.getName());
        summary.setEmail(account.getEmail());
        summary.setPhone(account.getPhone());
        summary.setRole(account.getRole());
        summary.setLocked(account.isLocked());
        summary.setPermissions(account.getPermissions());
        return summary;
    }
}
