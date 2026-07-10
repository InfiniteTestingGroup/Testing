package org.jackfruit.keliri.controller;

import java.util.HashMap;
import java.util.Map;

import org.jackfruit.keliri.service.FirebaseJwtService;
import org.jackfruit.keliri.service.SuperAdminAuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * Test Controller for JWT Token Generation and Validation
 * Endpoints to test Firebase JWT token functionality
 */
@RestController
@RequestMapping("/api/test/jwt")
public class JwtTestController {

    @Autowired
    private FirebaseJwtService firebaseJwtService;

    @Autowired
    private SuperAdminAuthService authService;

    /**
     * Test endpoint: Validate a JWT token
     * Tests: Token validity, expiration, remaining time
     */
    @PostMapping("/test-validate")
    public ResponseEntity<?> testValidateToken(@RequestBody Map<String, String> request) {
        try {
            String token = request.get("token");
            if (token == null || token.isBlank()) {
                return ResponseEntity.badRequest()
                    .body(Map.of("error", "Token is required"));
            }

            Map<String, Object> result = new HashMap<>();
            
            // Test 1: Check if token is valid
            boolean isValid = firebaseJwtService.isTokenValid(token);
            result.put("test_1_is_valid", isValid);

            // Test 2: Get remaining hours
            double remainingHours = firebaseJwtService.getRemainingHours(token);
            result.put("test_2_remaining_hours", Math.round(remainingHours * 100.0) / 100.0);
            result.put("test_2_is_24_hour_token", remainingHours >= 23.5); // Allow 30 min tolerance

            // Test 3: Check if expiring soon (within 1 hour)
            boolean expiringSoon = firebaseJwtService.isTokenExpiringSoon(token);
            result.put("test_3_expiring_soon", expiringSoon);

            // Test 4: Get expiration time
            long expirationMs = firebaseJwtService.getTokenExpiration(token).getTime();
            long currentTimeMs = System.currentTimeMillis();
            long diffMs = expirationMs - currentTimeMs;
            result.put("test_4_expiration_time_ms", expirationMs);
            result.put("test_4_current_time_ms", currentTimeMs);
            result.put("test_4_remaining_ms", diffMs);
            result.put("test_4_remaining_hours_calc", diffMs / (1000.0 * 60 * 60));

            // Test 5: Get token claims
            try {
                String email = (String) firebaseJwtService.getTokenClaim(token, "email");
                String role = (String) firebaseJwtService.getTokenClaim(token, "role");
                result.put("test_5_email", email);
                result.put("test_5_role", role);
            } catch (Exception e) {
                result.put("test_5_error", e.getMessage());
            }

            result.put("status", "success");
            result.put("message", "All token validation tests completed");
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(Map.of("error", "Token validation failed", "message", e.getMessage()));
        }
    }

    /**
     * Test endpoint: Check 24-hour validity
     * Specifically tests if token is valid for exactly 24 hours
     */
    @PostMapping("/test-24h-validity")
    public ResponseEntity<?> test24HourValidity(@RequestBody Map<String, String> request) {
        try {
            String token = request.get("token");
            if (token == null || token.isBlank()) {
                return ResponseEntity.badRequest()
                    .body(Map.of("error", "Token is required"));
            }

            Map<String, Object> result = new HashMap<>();
            
            double remainingHours = firebaseJwtService.getRemainingHours(token);
            long remainingMs = firebaseJwtService.getTokenExpiration(token).getTime() - System.currentTimeMillis();
            
            // Expected 24 hours in milliseconds
            long expected24HoursMs = 24 * 60 * 60 * 1000;
            double expectedHours = 24.0;
            
            // Allow 30 seconds tolerance
            long tolerance = 30 * 1000;
            boolean isValid24Hour = Math.abs(remainingMs - expected24HoursMs) <= tolerance;

            result.put("expected_expiration_hours", expectedHours);
            result.put("actual_remaining_hours", Math.round(remainingHours * 100.0) / 100.0);
            result.put("expected_expiration_ms", expected24HoursMs);
            result.put("actual_remaining_ms", remainingMs);
            result.put("tolerance_ms", tolerance);
            result.put("is_24_hour_token", isValid24Hour);
            result.put("message", isValid24Hour ? "✓ Token is valid for 24 hours" : "✗ Token expiration does not match 24 hours");
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(Map.of("error", "24-hour validity test failed", "message", e.getMessage()));
        }
    }

    /**
     * Test endpoint: Verify token generation
     * Tests that tokens are correctly generated with all required claims
     */
    @PostMapping("/test-token-claims")
    public ResponseEntity<?> testTokenClaims(@RequestBody Map<String, String> request) {
        try {
            String token = request.get("token");
            if (token == null || token.isBlank()) {
                return ResponseEntity.badRequest()
                    .body(Map.of("error", "Token is required"));
            }

            Map<String, Object> result = new HashMap<>();
            
            // Extract all claims
            String email = (String) firebaseJwtService.getTokenClaim(token, "email");
            String role = (String) firebaseJwtService.getTokenClaim(token, "role");
            String adminId = (String) firebaseJwtService.getTokenClaim(token, "adminId");
            String type = (String) firebaseJwtService.getTokenClaim(token, "type");

            result.put("email", email);
            result.put("role", role);
            result.put("adminId", adminId);
            result.put("type", type);
            result.put("email_present", email != null && !email.isEmpty());
            result.put("role_present", role != null && !role.isEmpty());
            result.put("adminId_present", adminId != null && !adminId.isEmpty());
            result.put("type_correct", "SUPER_ADMIN".equals(type));
            
            boolean allClaimsPresent = email != null && role != null && adminId != null && type != null;
            result.put("all_required_claims_present", allClaimsPresent);
            result.put("message", allClaimsPresent ? "✓ All required claims are present" : "✗ Some required claims are missing");
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(Map.of("error", "Token claims test failed", "message", e.getMessage()));
        }
    }

    /**
     * Test endpoint: Complete JWT flow
     * 1. Generate token
     * 2. Validate token
     * 3. Check 24-hour validity
     * Note: Requires admin account to exist in database
     */
    @GetMapping("/test-info")
    public ResponseEntity<?> getTestInfo() {
        Map<String, Object> info = new HashMap<>();
        info.put("description", "JWT Token Testing Endpoints");
        info.put("endpoints", new HashMap<String, Object>() {{
            put("POST /api/test/jwt/test-validate", "Validate a JWT token and check all properties");
            put("POST /api/test/jwt/test-24h-validity", "Test if token is valid for exactly 24 hours");
            put("POST /api/test/jwt/test-token-claims", "Verify all required claims in token");
        }});
        info.put("request_body_format", new HashMap<String, Object>() {{
            put("field", "token");
            put("type", "string");
            put("description", "The JWT token to test (obtained from login endpoint)");
        }});
        info.put("usage_example", new HashMap<String, Object>() {{
            put("step_1", "Login: POST /api/auth/superadmin/login with email and password");
            put("step_2", "Copy the token from response");
            put("step_3", "Test token: POST /api/test/jwt/test-validate with token in body");
        }});
        
        return ResponseEntity.ok(info);
    }
}
