package org.jackfruit.keliri.service;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import org.jackfruit.keliri.model.SuperAdmin;
import org.jackfruit.keliri.repository.SuperAdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import io.jsonwebtoken.Claims;

@Service
public class SuperAdminAuthService {
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Autowired
    private SuperAdminRepository adminRepo;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private FirebaseJwtService firebaseJwtService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private TokenService tokenService;

    @Value("${security.superadmin.lock-duration-ms}")
    private long lockDurationMs;

    @Value("${security.superadmin.max-failed-attempts:5}")
    private int maxFailedAttempts;

    public Map<String, Object> login(String emailOrPhone, String password) {
        // Support login by phone number OR email
        boolean looksLikePhone = emailOrPhone != null && emailOrPhone.matches("[+]?[0-9]{7,15}");
        SuperAdmin admin;
        if (looksLikePhone) {
            admin = adminRepo.findByPhone(emailOrPhone)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials"));
        } else {
            admin = adminRepo.findByEmail(emailOrPhone)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid credentials"));
        }

        // Auto-unlock if lock duration has expired
        if (admin.isLocked() && admin.getLockUntil() != null && admin.getLockUntil().isBefore(Instant.now())) {
            admin.setLocked(false);
            admin.setLockUntil(null);
            admin.setFailedAttempts(0);
            adminRepo.save(admin);
        }

        // Check if account is locked
        if (admin.isLocked()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "Account temporarily locked due to multiple failed attempts. Please try again later.");
        }

        // Validate password
        if (admin.getPassword() != null && passwordEncoder.matches(password, admin.getPassword())) {
            admin.setRole(jwtService.normalizeRole(admin.getRole()));
            admin.setFailedAttempts(0);
            admin.setLocked(false);
            admin.setLockUntil(null);
            adminRepo.save(admin);

            Map<String, Boolean> permissions = normalizePermissions(admin);
            admin.setPermissions(permissions);
            adminRepo.save(admin);

            // Generate Firebase JWT token (24 hours validity)
            String firebaseToken = firebaseJwtService.generateJwtToken(admin);
            long expirationMs = 24 * 60 * 60 * 1000; // 24 hours

            Map<String, Object> payload = new LinkedHashMap<>();
            payload.put("token", firebaseToken);
            payload.put("message", "Login Successful");
            payload.put("expiresInMs", expirationMs);
            payload.put("expiresInHours", 24);
            payload.put("email", admin.getEmail());
            payload.put("name", admin.getName());
            payload.put("phone", admin.getPhone());
            payload.put("role", admin.getRole());
            payload.put("permissions", permissions);
            payload.put("issuedAtMs", System.currentTimeMillis());
            payload.put("expirationTimeMs", System.currentTimeMillis() + expirationMs);
            return payload;
        }

        // Invalid credentials - increment failed attempts
        admin.setFailedAttempts(admin.getFailedAttempts() + 1);

        // Lock account if max failed attempts reached
        if (admin.getFailedAttempts() >= maxFailedAttempts) {
            admin.setLocked(true);
            admin.setLockUntil(Instant.now().plusMillis(lockDurationMs));
            adminRepo.save(admin);

            // Send account locked email notification with unlock and reset links
            try {
                String unlockToken = tokenService.generateUnlockToken(admin.getId());
                String resetToken = tokenService.generatePasswordResetToken(admin.getId());
                emailService.sendAccountLockedEmail(admin.getEmail(), admin.getName(), unlockToken, resetToken);
            } catch (Exception e) {
                System.err.println("Failed to send account locked email: " + e.getMessage());
            }

            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "Invalid credentials. Account temporarily locked after " + maxFailedAttempts + " failed attempts.");
        } else {
            adminRepo.save(admin);
            int remainingAttempts = maxFailedAttempts - admin.getFailedAttempts();
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED,
                    "Invalid credentials. " + remainingAttempts + " attempt(s) remaining before account lock.");
        }
    }

    public Map<String, Object> loginWithFirebaseOtp(String firebaseIdToken) {
        try {
            // 1. Verify token and get phone number
            String phoneNumber = firebaseJwtService.verifyFirebaseIdToken(firebaseIdToken);
            if (phoneNumber == null || phoneNumber.isBlank()) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Phone number missing in Firebase token");
            }

            // 2. Find admin by phone
            SuperAdmin admin = adminRepo.findByPhone(phoneNumber)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED,
                            "Account not found for phone number: " + phoneNumber));

            // 3. Check lock status
            if (admin.isLocked()) {
                if (admin.getLockUntil() != null && admin.getLockUntil().isBefore(Instant.now())) {
                    admin.setLocked(false);
                    admin.setLockUntil(null);
                    admin.setFailedAttempts(0);
                    adminRepo.save(admin);
                } else {
                    throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                            "Account is temporarily locked. Please try again later.");
                }
            }

            // 4. Success - Reset attempts and generate token
            admin.setRole(jwtService.normalizeRole(admin.getRole()));
            admin.setFailedAttempts(0);
            admin.setLocked(false);
            admin.setLockUntil(null);

            Map<String, Boolean> permissions = normalizePermissions(admin);
            admin.setPermissions(permissions);
            adminRepo.save(admin);

            String token = firebaseJwtService.generateJwtToken(admin);
            long expirationMs = 24 * 60 * 60 * 1000;

            Map<String, Object> payload = new java.util.LinkedHashMap<>();
            payload.put("token", token);
            payload.put("message", "OTP Login Successful");
            payload.put("expiresInMs", expirationMs);
            payload.put("expiresInHours", 24);
            payload.put("email", admin.getEmail());
            payload.put("name", admin.getName());
            payload.put("phone", admin.getPhone());
            payload.put("role", admin.getRole());
            payload.put("permissions", permissions);
            payload.put("issuedAtMs", System.currentTimeMillis());
            payload.put("expirationTimeMs", System.currentTimeMillis() + expirationMs);
            return payload;

        } catch (com.google.firebase.auth.FirebaseAuthException e) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid OTP token: " + e.getMessage());
        } catch (ResponseStatusException e) {
            throw e;
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "OTP Login failed: " + e.getMessage());
        }
    }

    public Map<String, Object> getCurrentSession(String authorization) {
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            throw new ResponseStatusException(org.springframework.http.HttpStatus.UNAUTHORIZED,
                    "Authorization token is required");
        }

        String token = authorization.substring(7).trim();

        try {
            Claims claims = jwtService.parseToken(token);
            String adminId = claims.get("adminId", String.class);
            String email = claims.getSubject();

            SuperAdmin admin = adminId != null && !adminId.isBlank()
                    ? adminRepo.findById(adminId).orElse(null)
                    : null;

            if (admin == null && email != null && !email.isBlank()) {
                admin = adminRepo.findByEmail(email).orElse(null);
            }

            if (admin == null) {
                throw new ResponseStatusException(org.springframework.http.HttpStatus.UNAUTHORIZED,
                        "Account not found");
            }

            admin.setRole(jwtService.normalizeRole(admin.getRole()));
            Map<String, Boolean> permissions = normalizePermissions(admin);
            admin.setPermissions(permissions);
            adminRepo.save(admin);

            // Generate new Firebase JWT token
            String refreshedToken = firebaseJwtService.generateJwtToken(admin);
            long expirationMs = 24 * 60 * 60 * 1000; // 24 hours

            Map<String, Object> payload = new LinkedHashMap<>();
            payload.put("token", refreshedToken);
            payload.put("message", "Session refreshed");
            payload.put("expiresInMs", expirationMs);
            payload.put("expiresInHours", 24);
            payload.put("email", admin.getEmail());
            payload.put("name", admin.getName());
            payload.put("phone", admin.getPhone());
            payload.put("role", admin.getRole());
            payload.put("permissions", permissions);
            payload.put("issuedAtMs", System.currentTimeMillis());
            payload.put("expirationTimeMs", System.currentTimeMillis() + expirationMs);
            return payload;
        } catch (ResponseStatusException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ResponseStatusException(org.springframework.http.HttpStatus.UNAUTHORIZED,
                    "Invalid or expired token");
        }
    }

    /**
     * Validate token and return details
     */
    public Map<String, Object> validateToken(String token) {
        try {
            if (token == null || token.isBlank()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Token is required");
            }

            Claims claims = firebaseJwtService.validateAndParseToken(token);

            double remainingHours = firebaseJwtService.getRemainingHours(token);
            boolean isValid = firebaseJwtService.isTokenValid(token);
            boolean expiringSoon = firebaseJwtService.isTokenExpiringSoon(token);

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("valid", isValid);
            result.put("email", claims.getSubject());
            result.put("role", claims.get("role"));
            result.put("adminId", claims.get("adminId"));
            result.put("issuedAt", claims.getIssuedAt());
            result.put("expiration", claims.getExpiration());
            result.put("remainingHours", Math.round(remainingHours * 100.0) / 100.0);
            result.put("remainingMs", claims.getExpiration().getTime() - System.currentTimeMillis());
            result.put("expiringSoon", expiringSoon);
            result.put("message", isValid ? "Token is valid" : "Token is invalid");

            return result;
        } catch (Exception e) {
            Map<String, Object> result = new LinkedHashMap<>();
            result.put("valid", false);
            result.put("message", "Invalid or expired token: " + e.getMessage());
            return result;
        }
    }

    /**
     * Unlock an account using an unlock token
     */
    public Map<String, Object> unlockAccountByToken(String token) {
        if (token == null || token.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Unlock token is required");
        }

        // Validate token
        TokenService.TokenData tokenData = tokenService.validateToken(token, TokenService.TokenType.ACCOUNT_UNLOCK);

        SuperAdmin admin = adminRepo.findById(tokenData.subAdminId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Account not found"));

        if (!admin.isLocked()) {
            // Already unlocked
            tokenService.consumeToken(token);
            return Map.of("message", "Account is already unlocked. You can now login.", "email", admin.getEmail());
        }

        // Unlock account
        admin.setLocked(false);
        admin.setLockUntil(null);
        admin.setFailedAttempts(0);
        adminRepo.save(admin);

        // Consume token
        tokenService.consumeToken(token);

        return Map.of("message", "Account unlocked successfully. You can now login.", "email", admin.getEmail());
    }

    public Map<String, Boolean> normalizePermissions(SuperAdmin admin) {
        Map<String, Boolean> allModules = new LinkedHashMap<>();
        allModules.put("dashboard", true);
        allModules.put("analytics", true);
        allModules.put("admins", true);
        allModules.put("publishers", true);
        allModules.put("ads", true);
        allModules.put("revenue", true);
        allModules.put("transactions", true);
        allModules.put("tickets", true);
        allModules.put("auditLogs", true);
        allModules.put("profile", true);
        allModules.put("settings", true);
        allModules.put("subAdmins", true);

        if (JwtService.MASTER_SUPER_ADMIN.equalsIgnoreCase(jwtService.normalizeRole(admin.getRole()))) {
            return allModules;
        }

        Map<String, Boolean> custom = new LinkedHashMap<>();
        if (admin.getPermissions() != null) {
            custom.putAll(admin.getPermissions());
        }

        Map<String, Boolean> merged = new LinkedHashMap<>();
        for (Map.Entry<String, Boolean> entry : allModules.entrySet()) {
            merged.put(entry.getKey(), Boolean.TRUE.equals(custom.get(entry.getKey())));
        }
        merged.put("subAdmins", false);
        return merged;
    }
}
