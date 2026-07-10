package org.jackfruit.keliri.model;

/**
 * Token validation response DTO
 */
public class TokenValidationResponse {
    private boolean valid;
    private String message;
    private String email;
    private String role;
    private long remainingMs;
    private double remainingHours;
    private long expirationTimeMs;
    private boolean expiringSoon; // true if expiring within 1 hour

    public TokenValidationResponse() {
    }

    public TokenValidationResponse(boolean valid, String message) {
        this.valid = valid;
        this.message = message;
    }

    // Getters and Setters
    public boolean isValid() {
        return valid;
    }

    public void setValid(boolean valid) {
        this.valid = valid;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public long getRemainingMs() {
        return remainingMs;
    }

    public void setRemainingMs(long remainingMs) {
        this.remainingMs = remainingMs;
    }

    public double getRemainingHours() {
        return remainingHours;
    }

    public void setRemainingHours(double remainingHours) {
        this.remainingHours = remainingHours;
    }

    public long getExpirationTimeMs() {
        return expirationTimeMs;
    }

    public void setExpirationTimeMs(long expirationTimeMs) {
        this.expirationTimeMs = expirationTimeMs;
    }

    public boolean isExpiringSoon() {
        return expiringSoon;
    }

    public void setExpiringSoon(boolean expiringSoon) {
        this.expiringSoon = expiringSoon;
    }
}
