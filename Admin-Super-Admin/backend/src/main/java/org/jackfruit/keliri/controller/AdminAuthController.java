package org.jackfruit.keliri.controller;

import java.util.Map;

import org.jackfruit.keliri.service.AdminAuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import jakarta.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/api/admin")
public class AdminAuthController {

    @Autowired
    private AdminAuthService authService;

@PostMapping("/login")
public ResponseEntity<?> login(
        @RequestBody Map<String, String> credentials,
        HttpServletRequest request) {
        try {
            String identifier = credentials.get("identifier");
            String password = credentials.get("password");
            
            if (identifier == null || password == null) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Identifier and password required"));
            }

            Map<String, Object> result = authService.login(identifier, password, request);
            return ResponseEntity.ok(result);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "message", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("success", false, "message", "Internal server error"));
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout() {
        return ResponseEntity.ok(Map.of("success", true, "message", "Logged out successfully"));
    }
}
