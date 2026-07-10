package org.jackfruit.keliri.service;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * Service for managing one-time setup and password reset tokens
 */
@Service
public class TokenService {

    @Value("${security.jwt.expiration-ms:86400000}")
    private long tokenExpirationMs;

    // In-memory storage for tokens (in production, use database)
    // Map<token, Map<userId, expiryTime>>
    private final Map<String, TokenData> tokenStore = new HashMap<>();

    /**
     * Generate a one-time setup token for sub-admin password initialization
     */
    public String generateSetupToken(String subAdminId) {
        String token = UUID.randomUUID().toString();
        long expiryTime = System.currentTimeMillis() + tokenExpirationMs; // 24 hours by default
        tokenStore.put(token, new TokenData(subAdminId, TokenType.SETUP, expiryTime));
        return token;
    }

    /**
     * Generate a password reset token
     */
    public String generatePasswordResetToken(String subAdminId) {
        String token = UUID.randomUUID().toString();
        long expiryTime = System.currentTimeMillis() + (60 * 60 * 1000); // 1 hour for password reset
        tokenStore.put(token, new TokenData(subAdminId, TokenType.PASSWORD_RESET, expiryTime));
        return token;
    }

    /**
     * Generate an account unlock token
     */
    public String generateUnlockToken(String subAdminId) {
        String token = UUID.randomUUID().toString();
        long expiryTime = System.currentTimeMillis() + (15 * 60 * 1000); // 15 minutes for unlock
        tokenStore.put(token, new TokenData(subAdminId, TokenType.ACCOUNT_UNLOCK, expiryTime));
        return token;
    }

    /**
     * Validate and retrieve token data
     */
    public TokenData validateToken(String token, TokenType expectedType) {
        TokenData data = tokenStore.get(token);

        if (data == null) {
            throw new IllegalArgumentException("Invalid token");
        }

        if (System.currentTimeMillis() > data.expiryTime) {
            tokenStore.remove(token);
            throw new IllegalArgumentException("Token has expired");
        }

        if (!data.type.equals(expectedType)) {
            throw new IllegalArgumentException("Invalid token type");
        }

        return data;
    }

    /**
     * Consume token (mark as used)
     */
    public void consumeToken(String token) {
        tokenStore.remove(token);
    }

    /**
     * Remove all tokens for a specific user ID
     */
    public void cleanupTokensForUser(String subAdminId) {
        tokenStore.entrySet().removeIf(entry -> subAdminId.equals(entry.getValue().subAdminId));
    }

    /**
     * Token data holder
     */
    public static class TokenData {
        public String subAdminId;
        public TokenType type;
        public long expiryTime;

        public TokenData(String subAdminId, TokenType type, long expiryTime) {
            this.subAdminId = subAdminId;
            this.type = type;
            this.expiryTime = expiryTime;
        }
    }

    /**
     * Token types
     */
    public enum TokenType {
        SETUP,
        PASSWORD_RESET,
        ACCOUNT_UNLOCK
    }
}
