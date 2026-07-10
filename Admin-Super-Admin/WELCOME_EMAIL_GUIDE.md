# Welcome Email System - Complete Guide

## Overview
When a Master Super Admin creates a new Sub-Admin account, an automated welcome email is sent to the sub-admin's registered email address with:
1. **Temporary Password** - A reference password for their records
2. **Setup Link** - A one-time link to set their own secure password
3. **Login Instructions** - Step-by-step guide to access the platform

## Email Components

### 1. **Credentials Box**
Contains:
- Sub-admin's registered email address
- Temporary password (auto-generated, unique UUID)
- Note that they'll set their own secure password

### 2. **Setup Link**
- Format: `http://localhost:5175/setup-password?token={setupToken}`
- Valid for: 24 hours
- One-time use only (token is consumed after password is set)

### 3. **Next Steps**
Clear instructions on:
1. Clicking the setup link
2. Creating a strong password (8+ characters)
3. Logging in with email and new password

### 4. **Security Reminders**
- Never share credentials
- Use unique, strong passwords
- Be cautious of phishing emails
- Always verify URLs

## API Endpoints

### Create Sub-Admin
```
POST /api/superadmin/sub-admins
Authorization: Bearer {masterAdminToken}

Request:
{
  "name": "John Manager",
  "email": "john@company.com",
  "phone": "+91-9999999999",
  "permissions": {
    "dashboard": true,
    "analytics": true,
    "publishers": true,
    "ads": true,
    "tickets": true
  }
}

Response:
{
  "id": "sub-admin-id-123",
  "name": "John Manager",
  "email": "john@company.com",
  "phone": "+91-9999999999",
  "role": "SUB_SUPER_ADMIN",
  "locked": false,
  "permissions": { ... }
}
```

**Important:** The welcome email is automatically sent during this request with:
- Temporary password (UUID format)
- Setup link with unique token
- HTML formatted professional email

### Set Password (Sub-Admin)
```
POST /api/superadmin/sub-admins/setup-password
No Authorization Required (uses token instead)

Request:
{
  "setupToken": "{tokenFromEmail}",
  "newPassword": "MySecure@Pass123"
}

Response:
{
  "id": "sub-admin-id-123",
  "name": "John Manager",
  "email": "john@company.com",
  "role": "SUB_SUPER_ADMIN",
  "locked": false
}
```

## Email Flow Diagram

```
1. Master Super Admin creates Sub-Admin
   ↓
2. SuperAdminAccountService.createSubAdmin() called
   ↓
3. Generate random temporary password (UUID)
   ↓
4. Generate one-time setup token (TokenService)
   ↓
5. Build HTML email with:
   - Email address
   - Temporary password
   - Setup link (with token)
   - Instructions
   ↓
6. Send email via Gmail SMTP
   ↓
7. Sub-Admin receives email
   ↓
8. Sub-Admin clicks setup link
   ↓
9. Frontend prompts for new password
   ↓
10. POST /api/superadmin/sub-admins/setup-password
    with setupToken + newPassword
    ↓
11. Backend validates token
    ↓
12. Token is consumed (one-time use)
    ↓
13. Password is hashed and saved
    ↓
14. Sub-Admin can now login with email + new password
```

## Configuration

### Gmail SMTP Settings
In `application.properties`:
```properties
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=${EMAIL_USER:sonuayadavsk@gmail.com}
spring.mail.password=${EMAIL_PASS:your-app-password}
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true

app.mail.from=${EMAIL_USER:sonuayadavsk@gmail.com}
app.mail.from-name=Keliri Platform
app.superadmin.portal-url=${SUPERADMIN_PORTAL_URL:http://localhost:5175}
```

### Environment Variables to Set
```bash
EMAIL_USER=your-gmail@gmail.com
EMAIL_PASS=your-16-digit-app-password  # NOT your regular Gmail password
SUPERADMIN_PORTAL_URL=http://localhost:5175
```

## Testing the Welcome Email System

### Step 1: Create a Sub-Admin Account
```bash
# Use Postman or curl
POST http://localhost:9090/api/superadmin/sub-admins
Authorization: Bearer {master-admin-token}

Body:
{
  "name": "Test Manager",
  "email": "test.manager@example.com",
  "phone": "+91-1234567890",
  "permissions": {
    "dashboard": true,
    "analytics": true,
    "publishers": true,
    "ads": true,
    "tickets": true,
    "admin": true,
    "payment": true,
    "invoice": true
  }
}
```

### Step 2: Check Email Inbox
- Look for email from: `Keliri Platform <sonuayadavsk@gmail.com>`
- Subject: `Welcome to Keliri Admin Platform - Setup Your Password`

### Step 3: Verify Email Contents
The email should contain:
- ✅ Professional HTML formatting
- ✅ Sub-admin's email address
- ✅ **Temporary Password** (UUID format, ~12 characters)
- ✅ **Setup Link** with secure token
- ✅ Step-by-step instructions
- ✅ Security reminders
- ✅ 24-hour expiration notice

### Step 4: Test Setup Link
1. Copy the setup link from email
2. Open in browser: `http://localhost:5175/setup-password?token=abc123...`
3. Frontend should show password setup form
4. Enter new secure password (min 8 characters)
5. Submit form

### Step 5: Test Login
After password setup:
```bash
POST http://localhost:9090/api/auth/superadmin/login

Body:
{
  "email": "test.manager@example.com",
  "password": "your-new-password"
}

Response:
{
  "token": "eyJhbGc...",
  "message": "Login Successful",
  "expiresInHours": 24,
  "email": "test.manager@example.com",
  "name": "Test Manager",
  "role": "SUB_SUPER_ADMIN"
}
```

## Troubleshooting

### Email Not Received
1. **Check spam/junk folder** - Gmail SMTP emails sometimes get filtered
2. **Verify email configuration**:
   - Correct Gmail address and app-specific password
   - `spring.mail.properties.mail.smtp.starttls.enable=true` is set
3. **Check logs** for email sending errors:
   ```
   SEVERE: Failed to send welcome email to test@example.com
   ```

### Setup Link Expired
- Error: "Token has expired"
- Solution: Ask Master Super Admin to resend invitation or create new sub-admin

### Can't Set New Password
1. Verify token is correct (from email link)
2. Check that token hasn't been used already (one-time use)
3. Verify password meets requirements (min 8 characters)

### Account Already Locked After Failed Setup
- If 5 failed setup attempts occur, account gets locked
- Wait 15 minutes or ask Master Super Admin to unlock

## Email Template Features

### Dynamic Content
- Sub-admin's actual name
- Sub-admin's actual email address
- Unique temporary password per creation
- Unique setup token per creation

### Security Features
- One-time use tokens
- 24-hour expiration
- BCrypt password hashing (after new password is set)
- Temporary password never used for login (only shown for reference)

### Professional Styling
- Branded header with company colors (#2c3e50)
- Color-coded sections (blue for normal, yellow for warnings, red for security)
- Mobile-responsive layout
- Clear call-to-action button
- Helpful icons and formatting

## API Response Examples

### Successful Sub-Admin Creation + Email Sent
```json
{
  "id": "507f1f77bcf86cd799439011",
  "name": "Test Manager",
  "email": "test.manager@example.com",
  "phone": "+91-1234567890",
  "role": "SUB_SUPER_ADMIN",
  "locked": false,
  "permissions": {
    "dashboard": true,
    "analytics": true,
    "publishers": true,
    "ads": true,
    "tickets": true,
    "admin": true,
    "payment": true,
    "invoice": true
  }
}
```

## Advanced Features

### Custom Portal URL
Change where the setup link points to in `application.properties`:
```properties
app.superadmin.portal-url=https://your-domain.com
```
The setup link will then be: `https://your-domain.com/setup-password?token=...`

### Token Expiration
Modify setup token expiration in `TokenService`:
```java
// Default: 24 hours (86400000 ms)
long expiryTime = System.currentTimeMillis() + tokenExpirationMs;
```

### Email Template Customization
Edit `EmailService.buildWelcomeEmailHtml()` to customize:
- Colors and branding
- Text and messaging
- HTML structure and layout
- Security warnings and tips

## Security Considerations

✅ **Implemented**
- One-time use setup tokens
- 24-hour token expiration
- BCrypt password hashing
- Account locking after failed attempts
- Email verification (admin creates account with known email)
- Temporary password never stored (only shown in email)

🔒 **Best Practices**
- Never share email credentials with sub-admins
- Use app-specific passwords for Gmail (not main password)
- Regularly audit who has permission to create sub-admins
- Monitor email sending for security anomalies
- Implement rate limiting on password setup endpoint (optional)

## Summary

The welcome email system provides:
1. ✅ **Professional Communication** - HTML formatted, branded emails
2. ✅ **Secure Setup** - One-time tokens, 24-hour expiration
3. ✅ **Complete Instructions** - Step-by-step guidance for new admins
4. ✅ **Temporary Reference** - Password shown for their records
5. ✅ **Easy Access** - Simple click-to-setup link
6. ✅ **Security First** - Tokens consumed after use, proper hashing

The feature is now fully implemented and ready for production use!
