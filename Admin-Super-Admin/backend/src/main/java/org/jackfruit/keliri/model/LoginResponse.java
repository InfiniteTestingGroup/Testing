package org.jackfruit.keliri.model;

import java.util.Map;

/**
 * Login response DTO
 */
public class LoginResponse {
    private String token;
    private String message;
    private long expiresInMs;
    private int expiresInHours;
    private String email;
    private String name;
    private String phone;
    private String role;
    private Map<String, Boolean> permissions;
    private long issuedAtMs;
    private long expirationTimeMs;

    public LoginResponse() {
    }

    public LoginResponse(String token, String message, long expiresInMs) {
        this.token = token;
        this.message = message;
        this.expiresInMs = expiresInMs;
        this.expiresInHours = (int) (expiresInMs / (1000 * 60 * 60));
        this.issuedAtMs = System.currentTimeMillis();
        this.expirationTimeMs = this.issuedAtMs + expiresInMs;
    }

    // Getters and Setters
    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public long getExpiresInMs() {
        return expiresInMs;
    }

    public void setExpiresInMs(long expiresInMs) {
        this.expiresInMs = expiresInMs;
        this.expiresInHours = (int) (expiresInMs / (1000 * 60 * 60));
        this.expirationTimeMs = System.currentTimeMillis() + expiresInMs;
    }

    public int getExpiresInHours() {
        return expiresInHours;
    }

    public void setExpiresInHours(int expiresInHours) {
        this.expiresInHours = expiresInHours;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Map<String, Boolean> getPermissions() {
        return permissions;
    }

    public void setPermissions(Map<String, Boolean> permissions) {
        this.permissions = permissions;
    }

    public long getIssuedAtMs() {
        return issuedAtMs;
    }

    public void setIssuedAtMs(long issuedAtMs) {
        this.issuedAtMs = issuedAtMs;
    }

    public long getExpirationTimeMs() {
        return expirationTimeMs;
    }

    public void setExpirationTimeMs(long expirationTimeMs) {
        this.expirationTimeMs = expirationTimeMs;
    }
}
