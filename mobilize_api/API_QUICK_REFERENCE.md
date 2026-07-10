# Mobilize API - Quick Reference & Usage Examples

## Base Configuration

```javascript
// Environment Setup
const API_BASE_URL = 'http://localhost:3000/v1';
const JWT_TOKEN = 'your_jwt_token_here';

// Common Headers
const headers = {
  'Content-Type': 'application/json',
  'Authorization': `Bearer ${JWT_TOKEN}`
};
```

---

## 1. USER AUTHENTICATION FLOW

### Login User
```bash
POST http://localhost:3000/v1/user/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
  // OR for phone login:
  // "phone": "+1234567890",
  // "otp": "123456"
}

# Response: { token: "jwt_token", user: {...} }
```

### Verify OTP
```bash
POST http://localhost:3000/v1/user/verify-otp
Content-Type: application/json

{
  "phone": "+1234567890",
  "otp": "123456"
}
```

### Get Current User Profile
```bash
GET http://localhost:3000/v1/user/me
Authorization: Bearer JWT_TOKEN

# Returns: Current user details
```

---

## 2. USER MANAGEMENT

### Create New User
```bash
POST http://localhost:3000/v1/user/create/PUBLISHER
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "userType": "PUBLISHER"
}
```

### Update User Profile
```bash
PUT http://localhost:3000/v1/user/update
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "name": "Updated Name",
  "bio": "User bio",
  "avatar": "avatar_uid",
  "preferences": {}
}
```

### Get User by UID
```bash
GET http://localhost:3000/v1/user/uid/user-uid-123
Authorization: Bearer JWT_TOKEN

# Returns: User details with location
```

### Reset Password
```bash
POST http://localhost:3000/v1/user/reset-password
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "oldPassword": "current_password",
  "newPassword": "new_password"
}
```

---

## 3. COMPANY MANAGEMENT

### Create Company
```bash
POST http://localhost:3000/v1/company
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "name": "Company Name",
  "description": "Company description",
  "companyType": "ADVERTISING_AGENCY",
  "location": "City, Country",
  "contact": "+1234567890"
}
```

### Get All Companies
```bash
GET http://localhost:3000/v1/company/all/list
Authorization: Bearer JWT_TOKEN

# Query parameters: 
# ?all=true - Get all companies
```

### Get Company by Type
```bash
GET http://localhost:3000/v1/company/ADVERTISING_AGENCY
Authorization: Bearer JWT_TOKEN
```

---

## 4. MEDIA UPLOAD

### Upload File
```bash
POST http://localhost:3000/v1/media/upload
Authorization: Bearer JWT_TOKEN
Content-Type: multipart/form-data

[Form Data]
file: <file_to_upload>

# Response: { mediaUid: "uid", url: "https://..." }
```

### Get Media by UIDs
```bash
POST http://localhost:3000/v1/media/uids
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "uids": ["uid1", "uid2", "uid3"]
}

# Response: Array of media objects with full details
```

### Get Media URLs Only
```bash
POST http://localhost:3000/v1/media/urls/uids
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "uids": ["uid1", "uid2", "uid3"]
}

# Response: { uid1: "https://...", uid2: "https://..." }
```

---

## 5. ADVERTISEMENTS

### Create Advertisement
```bash
POST http://localhost:3000/v1/advertisements/create
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "title": "Ad Title",
  "description": "Ad Description",
  "adType": "IMAGE/VIDEO/TEXT",
  "mediaUids": ["media_uid_1", "media_uid_2"],
  "categories": ["category_uid_1"],
  "targetAudience": "EVERYONE/PUBLISHERS/CONSUMERS",
  "budget": 5000,
  "startDate": "2024-01-01",
  "endDate": "2024-01-31"
}
```

### Update Advertisement
```bash
PUT http://localhost:3000/v1/advertisements/update/ad-uid-123
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "title": "Updated Title",
  "description": "Updated Description",
  "status": "ACTIVE/PAUSED"
}
```

### Get My Ads
```bash
GET http://localhost:3000/v1/advertisements
Authorization: Bearer JWT_TOKEN

# Returns: List of ads created by current user
```

### Get Ad Details
```bash
GET http://localhost:3000/v1/advertisements/ad-uid-123
Authorization: Bearer JWT_TOKEN
```

### Copy Advertisement
```bash
GET http://localhost:3000/v1/advertisements/copy-ad/original-ad-uid
Authorization: Bearer JWT_TOKEN

# Creates duplicate of existing ad
```

---

## 6. AD CAMPAIGNS

### Create Campaign
```bash
POST http://localhost:3000/v1/ad-campaigns/create
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "name": "Campaign Name",
  "adUids": ["ad-uid-1", "ad-uid-2"],
  "budget": 10000,
  "startDate": "2024-01-01",
  "endDate": "2024-01-31",
  "targetLocations": ["Location 1", "Location 2"],
  "status": "ACTIVE"
}
```

### Get Campaigns by Status
```bash
GET http://localhost:3000/v1/ad-campaigns/status/ACTIVE
Authorization: Bearer JWT_TOKEN

# Status: ACTIVE, PAUSED, COMPLETED
```

### Get Campaign Analytics
```bash
POST http://localhost:3000/v1/ad-campaigns/count/dateRange
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "campaignUid": "campaign-uid",
  "startDate": "2024-01-01",
  "endDate": "2024-01-31"
}

# Returns: Analytics data (impressions, clicks, conversions)
```

---

## 7. SEARCH APIs

### Search Categories
```bash
GET http://localhost:3000/v1/search/category/electronics
Authorization: Bearer JWT_TOKEN

# Returns: List of matching product categories
```

### Search Companies
```bash
GET http://localhost:3000/v1/search/comapny/acme
Authorization: Bearer JWT_TOKEN

# Returns: List of matching companies
```

### Advanced Search
```bash
POST http://localhost:3000/v1/search/filters
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "keyword": "search term",
  "filters": {
    "category": ["category_uid"],
    "location": ["city"],
    "priceRange": { "min": 100, "max": 5000 }
  },
  "sort": "relevance",
  "page": 1,
  "limit": 20
}
```

---

## 8. FOLLOWING & PUBLISHERS

### Follow Publisher
```bash
POST http://localhost:3000/v1/mapping-user/follow
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "entityUid": "publisher-uid",
  "entityType": "PUBLISHER"
  // or COMPANY
}
```

### Get Followings
```bash
GET http://localhost:3000/v1/mapping-user/followings/PUBLISHER
Authorization: Bearer JWT_TOKEN

# Returns: List of publishers being followed
```

### Get Publisher Statistics
```bash
GET http://localhost:3000/v1/mapping-user/statistics/publisher-uid
Authorization: Bearer JWT_TOKEN

# Returns: Followers count, engagement metrics, etc.
```

### Get Following Users Campaigns
```bash
POST http://localhost:3000/v1/mapping-user/following-users-campaigns
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "limit": 10,
  "offset": 0
}

# Returns: Campaigns from users being followed
```

---

## 9. SAVED ADS

### Save Advertisement
```bash
POST http://localhost:3000/v1/mapping-user-ads/save
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "adUid": "ad-uid-123"
}

# Toggles save/unsave
```

### Get Saved Ads List
```bash
GET http://localhost:3000/v1/mapping-user-ads/saved-list
Authorization: Bearer JWT_TOKEN

# Returns: List of all saved ads
```

---

## 10. USER PUBLISHING (ADS FEED)

### Get Feed Ads
```bash
POST http://localhost:3000/v1/user-publishing/20
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "lastPublishingUid": "previous-uid",
  "filters": {
    "categories": ["category_uid"]
  }
}

# Parameter "20" = limit per page
# Returns: 20 ads for user feed
```

### Mark Ad as Seen
```bash
GET http://localhost:3000/v1/user-publishing/seen-status/publishing-uid-123
Authorization: Bearer JWT_TOKEN

# Marks ad as viewed
```

### Track CTA Click
```bash
POST http://localhost:3000/v1/user-publishing/action/click-cta
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "publishingUid": "publishing-uid",
  "ctaUid": "cta-uid",
  "ctaType": "VISIT_WEBSITE/CALL/DOWNLOAD"
}

# Tracks user action on ad CTA
```

### Get Unread Count
```bash
GET http://localhost:3000/v1/user-publishing/count/unread
Authorization: Bearer JWT_TOKEN

# Returns: { count: 5 }
```

### Get Campaign Analytics
```bash
GET http://localhost:3000/v1/user-publishing/analytics/publishing-uid
Authorization: Bearer JWT_TOKEN

# Returns: Views, clicks, conversions for publishing
```

---

## 11. MASTER DATA

### Import Master Data (Initial Setup)
```bash
GET http://localhost:3000/v1/masters/import

# One-time call to load all master data
```

### Get Ad Types
```bash
GET http://localhost:3000/v1/masters/ad-types/list

# Returns: IMAGE, VIDEO, TEXT, CAROUSEL, etc.
```

### Get Ad CTAs
```bash
GET http://localhost:3000/v1/masters/ad-cta/list

# Returns: VISIT_WEBSITE, CALL, DOWNLOAD, SHARE, etc.
```

### Get Product Categories
```bash
GET http://localhost:3000/v1/masters/all
Authorization: Bearer JWT_TOKEN

# Returns: All product categories
```

### Get Subcategories
```bash
GET http://localhost:3000/v1/masters/parent-category-uid
Authorization: Bearer JWT_TOKEN

# Returns: Subcategories for parent
```

---

## 12. NOTIFICATION SETUP

### Register FCM Token
```bash
POST http://localhost:3000/v1/notification-subscripton
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "fcmToken": "firebase_token_from_client",
  "deviceType": "ANDROID",
  "deviceId": "unique_device_id"
}
```

---

## 13. ROLES MANAGEMENT

### Get All Roles
```bash
GET http://localhost:3000/v1/roles/roles/list
Authorization: Bearer JWT_TOKEN

# Returns: All available roles
```

### Create Role
```bash
POST http://localhost:3000/v1/roles/create
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "name": "Role Name",
  "permissions": ["read", "write", "delete"],
  "description": "Role description"
}
```

---

## 14. BANNERS

### Get Banners List
```bash
GET http://localhost:3000/v1/banners/list
Authorization: Bearer JWT_TOKEN

# Returns: All active banners for display
```

### Create Banner
```bash
POST http://localhost:3000/v1/banners/create
Authorization: Bearer JWT_TOKEN
Content-Type: application/json

{
  "title": "Banner Title",
  "image": "media_uid",
  "link": "https://link.com",
  "position": "TOP/BOTTOM/MIDDLE",
  "startDate": "2024-01-01",
  "endDate": "2024-01-31"
}
```

---

## COMMON ERROR RESPONSES

```json
{
  "statusCode": 400,
  "message": "Bad Request",
  "error": "Detailed error message"
}
```

### Common HTTP Status Codes
- **200** - Success
- **201** - Created
- **400** - Bad Request
- **401** - Unauthorized (invalid/missing JWT)
- **403** - Forbidden (insufficient permissions)
- **404** - Not Found
- **409** - Conflict (duplicate entry)
- **500** - Server Error

---

## PAGINATION PATTERN

Most list endpoints support pagination:

```bash
GET http://localhost:3000/v1/advertisements?page=1&limit=20

# Query Parameters:
# page: Page number (default: 1)
# limit: Items per page (default: 10, max: 100)
# sort: Sort field (default: createdAt)
# order: ASC or DESC (default: DESC)
```

---

## FILTERING PATTERN

Most endpoints support filtering:

```javascript
// Query String Filters
GET /api/endpoint?filter[status]=ACTIVE&filter[category]=tech&sort=-createdAt

// Request Body Filters (POST methods)
{
  "filters": {
    "status": "ACTIVE",
    "category": "tech",
    "dateRange": {
      "startDate": "2024-01-01",
      "endDate": "2024-01-31"
    }
  }
}
```

---

## ENVIRONMENT CONFIGURATION

```env
# API Configuration
API_BASE_URL=http://localhost:3000
API_VERSION=v1

# Authentication
JWT_SECRET=your_secret_key
JWT_EXPIRY=7d

# Firebase (for notifications)
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_API_KEY=your_api_key

# AWS Configuration
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret

# Database
MONGODB_URI=mongodb://localhost:27017/mobilize_db

# Redis
REDIS_URL=redis://localhost:6379

# RabbitMQ
RABBITMQ_URL=amqp://localhost:5672
```

---

## QUICK INTEGRATION CHECKLIST

- [ ] Get JWT token via login endpoint
- [ ] Store JWT in secure storage (local storage/secure cookies)
- [ ] Add JWT to all authenticated requests
- [ ] Handle 401/403 errors (token refresh/re-login)
- [ ] Implement pagination for list endpoints
- [ ] Add error handling and user feedback
- [ ] Set up media upload with proper multipart headers
- [ ] Configure notification handling (FCM)
- [ ] Implement analytics tracking
- [ ] Add caching where appropriate

---

## USEFUL LINKS

- **API Documentation**: API_DOCUMENTATION.md
- **API Endpoints JSON**: API_ENDPOINTS.json
- **NestJS Docs**: https://docs.nestjs.com
- **MongoDB**: https://www.mongodb.com/docs
- **Firebase**: https://firebase.google.com/docs
