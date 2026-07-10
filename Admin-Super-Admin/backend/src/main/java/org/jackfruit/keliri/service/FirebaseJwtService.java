package org.jackfruit.keliri.service;

import com.google.auth.oauth2.ServiceAccountCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.google.firebase.auth.SessionCookieOptions;
import com.google.firebase.auth.UserRecord;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.jackfruit.keliri.model.SuperAdmin;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct;

import javax.crypto.SecretKey;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * Firebase JWT Token Service
 * Generates and validates JWT tokens using Firebase Admin SDK
 * Tokens are valid for 24 hours
 */
@Service
public class FirebaseJwtService {

    @Value("${firebase.project-id}")
    private String projectId;

    @Value("${firebase.client-email}")
    private String clientEmail;

    @Value("${firebase.private-key}")
    private String privateKey;

    @Value("${security.jwt.expiration-ms:86400000}")
    private long tokenExpirationMs; // 24 hours in milliseconds

    private FirebaseAuth firebaseAuth;
    private SecretKey signingKey;

    public FirebaseJwtService(@Value("${security.jwt.secret}") String secret) {
        this.signingKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    @PostConstruct
    public void init() {
        initializeFirebase();
    }

    /**
     * Initialize Firebase with service account credentials
     */
    private void initializeFirebase() {
        try {
            if (FirebaseApp.getApps().isEmpty()) {
                // Create Firebase options from service account credentials
                String serviceAccountJson = buildServiceAccountJson();
                ByteArrayInputStream serviceAccount = new ByteArrayInputStream(serviceAccountJson.getBytes(java.nio.charset.StandardCharsets.UTF_8));

                FirebaseOptions options = FirebaseOptions.builder()
                        .setCredentials(ServiceAccountCredentials.fromStream(serviceAccount))
                        .setProjectId(projectId)
                        .build();
                FirebaseApp.initializeApp(options);
            }
            firebaseAuth = FirebaseAuth.getInstance();
            System.out.println("Firebase initialized successfully with project: " + projectId);
        } catch (IOException e) {
            System.err.println("Failed to initialize Firebase: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Build service account JSON from configuration
     */
    private String buildServiceAccountJson() {
        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            Map<String, Object> map = new HashMap<>();
            map.put("type", "service_account");
            map.put("project_id", projectId);
            map.put("private_key_id", "key1");
            map.put("private_key", privateKey);
            map.put("client_email", clientEmail);
            map.put("client_id", "123456789");
            map.put("auth_uri", "https://accounts.google.com/o/oauth2/auth");
            map.put("token_uri", "https://oauth2.googleapis.com/token");
            map.put("auth_provider_x509_cert_url", "https://www.googleapis.com/oauth2/v1/certs");
            return mapper.writeValueAsString(map);
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate service account JSON using Jackson", e);
        }
    }

    /**
     * Generate Firebase Custom Token for Super Admin
     * Token is valid for 24 hours
     */
    public String generateFirebaseToken(SuperAdmin admin) {
        try {
            Map<String, Object> claims = new HashMap<>();
            claims.put("role", admin.getRole());
            claims.put("adminId", admin.getId());
            claims.put("email", admin.getEmail());
            claims.put("name", admin.getName());
            claims.put("phone", admin.getPhone());
            claims.put("permissions", admin.getPermissions() == null ? Map.of() : admin.getPermissions());
            claims.put("type", "SUPER_ADMIN");

            // Create custom token using Firebase Admin SDK
            String customToken = firebaseAuth.createCustomToken(admin.getEmail(), claims);
            System.out.println("Firebase custom token generated for: " + admin.getEmail());
            return customToken;
        } catch (FirebaseAuthException e) {
            System.err.println("Failed to generate Firebase token: " + e.getMessage());
            throw new RuntimeException("Failed to generate authentication token", e);
        }
    }

    /**
     * Verify Firebase ID Token from client
     * Returns the phone number associated with the token if valid
     */
    public String verifyFirebaseIdToken(String idToken) throws FirebaseAuthException {
        FirebaseToken decodedToken = firebaseAuth.verifyIdToken(idToken);
        return (String) decodedToken.getClaims().get("phone_number");
    }

    /**
     * Generate JWT Token (alternative to Firebase token)
     * Using HMAC-SHA256 algorithm
     */
    public String generateJwtToken(SuperAdmin admin) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + tokenExpirationMs);

        return Jwts.builder()
                .subject(admin.getEmail())
                .claim("role", admin.getRole())
                .claim("adminId", admin.getId())
                .claim("name", admin.getName())
                .claim("phone", admin.getPhone())
                .claim("type", "SUPER_ADMIN")
                .claim("permissions", admin.getPermissions() == null ? Map.of() : admin.getPermissions())
                .issuedAt(now)
                .expiration(expiry)
                .signWith(signingKey, SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Validate and parse JWT Token
     */
    public Claims validateAndParseToken(String token) {
        try {
            return Jwts.parser()
                    .verifyWith(signingKey)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (Exception e) {
            System.err.println("Token validation failed: " + e.getMessage());
            throw new RuntimeException("Invalid or expired token", e);
        }
    }

    /**
     * Check if token is valid
     */
    public boolean isTokenValid(String token) {
        try {
            Claims claims = validateAndParseToken(token);
            return claims.getExpiration().after(new Date());
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Get token expiration time
     */
    public Date getTokenExpiration(String token) {
        try {
            Claims claims = validateAndParseToken(token);
            return claims.getExpiration();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Get remaining time in hours
     */
    public double getRemainingHours(String token) {
        Date expiration = getTokenExpiration(token);
        if (expiration == null) {
            return 0;
        }
        long remainingMs = expiration.getTime() - System.currentTimeMillis();
        return remainingMs / (1000.0 * 60 * 60); // Convert milliseconds to hours
    }

    /**
     * Get token claim
     */
    public Object getTokenClaim(String token, String claimName) {
        try {
            Claims claims = validateAndParseToken(token);
            return claims.get(claimName);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Check if token is about to expire (within 1 hour)
     */
    public boolean isTokenExpiringSoon(String token) {
        return getRemainingHours(token) < 1.0;
    }
}
