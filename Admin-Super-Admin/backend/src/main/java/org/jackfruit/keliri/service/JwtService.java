package org.jackfruit.keliri.service;

import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Map;

import javax.crypto.SecretKey;

import org.jackfruit.keliri.model.SuperAdmin;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Service
public class JwtService {
    public static final String MASTER_SUPER_ADMIN = "MASTER_SUPER_ADMIN";
    public static final String SUB_SUPER_ADMIN = "SUB_SUPER_ADMIN";

    private final SecretKey signingKey;
    private final long expirationMs;

    public JwtService(
            @Value("${security.jwt.secret}") String secret,
            @Value("${security.jwt.expiration-ms}") long expirationMs) {
        this.signingKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.expirationMs = expirationMs;
    }

    public String generateToken(SuperAdmin admin) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + expirationMs);
        String normalizedRole = normalizeRole(admin.getRole());

        return Jwts.builder()
                .subject(admin.getEmail())
                .claim("role", normalizedRole)
                .claim("adminId", admin.getId())
                .claim("type", "SUPER_ADMIN")
                .claim("permissions", admin.getPermissions() == null ? Map.of() : admin.getPermissions())
                .issuedAt(now)
                .expiration(expiry)
                .signWith(signingKey)
                .compact();
    }

    public String generateToken(org.jackfruit.keliri.model.users user) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + expirationMs);

        return Jwts.builder()
                .subject(user.getEmailAddress() != null ? user.getEmailAddress() : user.getPhoneNumber().getDialNumber())
                .claim("userId", user.getId())
                .claim("role", user.getUserType())
                .claim("type", "ADMIN")
                .claim("name", user.getFullName())
                .issuedAt(now)
                .expiration(expiry)
                .signWith(signingKey)
                .compact();
    }

    public Claims parseToken(String token) {
        return Jwts.parser()
                .verifyWith(signingKey)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public String normalizeRole(String role) {
        if (role == null || role.isBlank()) {
            return MASTER_SUPER_ADMIN;
        }

        if (MASTER_SUPER_ADMIN.equalsIgnoreCase(role) || "SUPER_ADMIN".equalsIgnoreCase(role)) {
            return MASTER_SUPER_ADMIN;
        }

        if (SUB_SUPER_ADMIN.equalsIgnoreCase(role)) {
            return SUB_SUPER_ADMIN;
        }

        return role.trim().toUpperCase();
    }
}
