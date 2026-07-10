package org.jackfruit.keliri.model;

/**
 * DTO for password setup request
 */
public class PasswordSetupRequest {
    private String setupToken;
    private String newPassword;

    public PasswordSetupRequest() {
    }

    public PasswordSetupRequest(String setupToken, String newPassword) {
        this.setupToken = setupToken;
        this.newPassword = newPassword;
    }

    public String getSetupToken() {
        return setupToken;
    }

    public void setSetupToken(String setupToken) {
        this.setupToken = setupToken;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }
}
