# Mobilize API - Complete API Documentation

## Base URL
```
http://localhost:3000/v1
```

---

## Authentication
- Most endpoints require **JWT Token** via `Authorization: Bearer <JWT_TOKEN>` header
- Some endpoints may require additional guards like `UserGuard` for specific user types

---

## 1. USER MANAGEMENT APIs (`/user`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| GET | `/user/import` | No | Import users data (admin function) |
| POST | `/user/login` | No | User login (email/phone + password or OTP) |
| POST | `/user/verify-otp` | No | Verify OTP for login/registration |
| POST | `/user/resend-otp` | No | Resend OTP to user |
| GET | `/user/me` | JWT | Get current authenticated user profile |
| PUT | `/user/update` | JWT + UserGuard | Complete/update current user profile |
| POST | `/user/invite` | JWT | Invite new users (send invitations) |
| PUT | `/user/update/:uid` | JWT + UserGuard | Update specific user by admin (use UID) |
| GET | `/user/:userType` | JWT | Get all active users of specific type (PUBLISHER/CONSUMER/ADMIN) |
| POST | `/user/reset-password` | JWT | Reset/change password for current user |
| GET | `/user/forgot-password/:email` | No | Send forgot password link/OTP to email |
| PUT | `/user/profile/update/:uid` | JWT | Update user profile details by admin |
| POST | `/user/create/:userType` | JWT | Create new user (PUBLISHER/CONSUMER/ADMIN) |
| GET | `/user/uid/:uid` | JWT | Get specific user details by UID with location |
| GET | `/user/count/dashboard` | JWT + UserGuard | Get dashboard count statistics |
| GET | `/user/following/ads` | JWT + UserGuard | Get ads from users being followed |
| POST | `/user/microservice/auth` | No | Microservice authentication (internal) |

---

## 2. COMPANY MANAGEMENT APIs (`/company`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| POST | `/company` | JWT | Create new company |
| PUT | `/company/update/:uid` | JWT | Update company details |
| GET | `/company/:companyType` | JWT + UserGuard | List companies by type with filters |
| GET | `/company/all/list` | JWT + UserGuard | Get all companies list |
| GET | `/company/uid/:uid` | JWT | Get specific company details by UID |

---

## 3. ROLES & ACCESS MANAGEMENT APIs (`/roles`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| GET | `/roles/import` | No | Import default roles data |
| GET | `/roles/roles/list` | JWT | List all available roles |
| POST | `/roles/create` | JWT | Create new role |
| PUT | `/roles/update/:uid` | JWT | Update role details |
| GET | `/roles/:uid` | JWT | Get role details by UID |

---

## 4. MASTERS DATA APIs (`/masters`)

### Master Data Management
| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| GET | `/masters/import` | No | Import all default master data (Initial setup) |
| GET | `/masters/modules/list` | No | List all available modules |
| GET | `/masters/accesses/list` | No | List all access types |

### Ad Types Management
| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| GET | `/masters/ad-types/list` | No | List all ad types |
| PUT | `/masters/ad-types/update/:uid` | JWT | Update ad type details |

### Ad CTA (Call To Action) Management
| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| GET | `/masters/ad-cta/list` | No | List all CTA options |
| GET | `/masters/ad-cta/:uid` | JWT | Get CTA details by UID |
| PUT | `/masters/ad-cta/update/:uid` | JWT | Update CTA details |

### Product Categories Management
| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| GET | `/masters/import` | No | Import product categories (Initial setup) |
| POST | `/masters` | JWT | Create new product category |
| GET | `/masters/all` | JWT | Get all product categories |
| GET | `/masters/:parentUid` | JWT | Get subcategories by parent UID |
| DELETE | `/masters/:uid` | JWT | Delete/disable product category |
| PUT | `/masters/:uid` | JWT | Update product category |
| GET | `/masters/:uid` | JWT | Get category details by UID |
| POST | `/masters` | JWT | Get categories by multiple IDs |

---

## 5. MEDIA MANAGEMENT APIs (`/media`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| POST | `/media/upload` | JWT | Upload file/image (multipart/form-data) |
| POST | `/media/uids` | JWT | Get media details by list of UIDs |
| POST | `/media/urls/uids` | JWT | Get only media URLs by list of UIDs |

**Request Body for POST `/media/uids` & `/media/urls/uids`:**
```json
{
  "uids": ["uid1", "uid2", "uid3"]
}
```

---

## 6. USER PROFILE MANAGEMENT APIs (`/user-profile`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| PUT | `/user-profile/me` | JWT | Update my profile/preferences |
| GET | `/user-profile/preference-ads` | JWT + UserGuard | Get timeline with ad preferences |
| POST | `/user-profile/microservice/auth` | No | Microservice auth for user profile |

---

## 7. ADVERTISEMENTS MANAGEMENT APIs (`/advertisements`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| POST | `/advertisements/create` | JWT | Create new advertisement |
| PUT | `/advertisements/update/:uid` | JWT | Update existing advertisement |
| GET | `/advertisements/copy-ad/:uid` | JWT | Copy advertisement template (create duplicate) |
| GET | `/advertisements` | JWT + UserGuard | List all ads for current user |
| GET | `/advertisements/:uid` | JWT | Get specific ad details by UID |
| GET | `/advertisements/user/me` | JWT + UserGuard | Get ads published by current user |
| GET | `/advertisements/user-uid/:uid` | JWT + UserGuard | Get ads published by specific user (admin view) |
| GET | `/advertisements/push-test/abcd` | No | Test push notification |

---

## 8. AD CAMPAIGNS MANAGEMENT APIs (`/ad-campaigns`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| POST | `/ad-campaigns/create` | JWT | Create new ad campaign |
| PUT | `/ad-campaigns/update/:uid` | JWT + UserGuard | Update campaign details |
| GET | `/ad-campaigns` | JWT + UserGuard | List all campaigns for user |
| GET | `/ad-campaigns/status/:campaignStatus` | JWT + UserGuard | List campaigns by status (ACTIVE/PAUSED/COMPLETED) |
| GET | `/ad-campaigns/:uid` | JWT | Get campaign details by UID |
| POST | `/ad-campaigns/count/dateRange` | JWT | Get analytics for date range |
| GET | `/ad-campaigns/user/me` | JWT + UserGuard | Get campaigns created by current user |
| GET | `/ad-campaigns/user-uid/:uid` | JWT | Get campaigns by specific user (admin view) |
| GET | `/ad-campaigns/following-user-campaigns/:uid` | JWT + UserGuard | Get campaigns from followed users |

---

## 9. SEARCH APIs (`/search`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| GET | `/search/category/:keyword` | JWT | Search product categories by keyword |
| GET | `/search/comapny/:keyword` | JWT | Search companies by keyword |
| POST | `/search` | JWT + UserGuard | Search all companies and publishers |
| POST | `/search/filters` | JWT + UserGuard | Search with advanced filters |

**Request Body for POST `/search`:**
```json
{
  "keyword": "search term",
  "filters": {}
}
```

---

## 10. MAPPING USER SAVED ADS APIs (`/mapping-user-ads`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| POST | `/mapping-user-ads/save` | JWT | Save/bookmark advertisement |
| GET | `/mapping-user-ads/saved-list` | JWT + UserGuard | Get list of all saved ads |

**Request Body for POST `/mapping-user-ads/save`:**
```json
{
  "adUid": "ad-uid-here",
  "action": "save" or "unsave"
}
```

---

## 11. MAPPING USER FOLLOWING APIs (`/mapping-user`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| POST | `/mapping-user/follow` | JWT | Follow publisher/company |
| GET | `/mapping-user/followings/:entityType` | JWT | List followed entities (PUBLISHER/COMPANY) |
| GET | `/mapping-user/statistics/:uid` | JWT + UserGuard | Get publisher statistics (followers, engagement) |
| GET | `/mapping-user/check-following/:uid` | JWT + UserGuard | Check if following specific user/company |
| POST | `/mapping-user/following-users-campaigns` | JWT + UserGuard | Get campaigns from following users |

**Request Body for POST `/mapping-user/follow`:**
```json
{
  "entityUid": "user-or-company-uid",
  "entityType": "PUBLISHER" or "COMPANY"
}
```

---

## 12. USER PUBLISHING TRANSACTION APIs (`/user-publishing`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| POST | `/user-publishing/:limit` | JWT + UserGuard | Get txn publishings with limit (paginated ads) |
| GET | `/user-publishing/seen-status/:uid` | JWT + UserGuard | Mark ad as seen/viewed |
| POST | `/user-publishing/action/click-cta` | JWT + UserGuard | Track CTA button clicks |
| GET | `/user-publishing/count/unread` | JWT + UserGuard | Get count of unread/unseen publishings |
| POST | `/user-publishing/view-count/publishing-view-count` | JWT + UserGuard | Create/track publishing view count |
| GET | `/user-publishing/camapign-reached-count/:campaignUid` | JWT + UserGuard | Get reached count for campaign |
| GET | `/user-publishing/txn-publishing-uid/:txnPublishingUid` | JWT + UserGuard | Get specific txn publishing details |
| GET | `/user-publishing/analytics/:publishingUid` | JWT + UserGuard | Get analytics for campaign publishing |

**Request Body for POST `/user-publishing/:limit`:**
```json
{
  "filters": {},
  "pagination": "limit"
}
```

---

## 13. NOTIFICATION SUBSCRIPTION APIs (`/notification-subscripton`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| POST | `/notification-subscripton` | JWT + UserGuard | Create/register notification subscription (FCM token) |

**Request Body for POST `/notification-subscripton`:**
```json
{
  "fcmToken": "firebase-token-here",
  "deviceType": "ANDROID/IOS/WEB"
}
```

---

## 14. BANNERS MANAGEMENT APIs (`/banners`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| POST | `/banners/import` | JWT + UserGuard | Import banner data |
| POST | `/banners/create` | JWT + UserGuard | Create new banner |
| GET | `/banners/list` | JWT + UserGuard | Get all banners list |

---

## 15. QUEUE CONTROL APIs (`/queue-control`)

| Method | Endpoint | Auth Required | Purpose |
|--------|----------|---------------|---------|
| GET | `/queue-control/delete-reschedule` | JWT + UserGuard | Clear Redis cache and reschedule all jobs |

---

## 16. WALLET MANAGEMENT APIs (`/wallet`)

*Currently not implemented but controller exists for future use.*

---

## 17. ADDRESS MANAGEMENT APIs (`/`)

*Currently not implemented but controller exists for future use.*

---

## Authentication Flow

### 1. User Registration/Login
```
POST /user/login
```

### 2. OTP Verification
```
POST /user/verify-otp
```

### 3. Get JWT Token
- Token returned after successful login/OTP verification
- Use token in all subsequent requests: `Authorization: Bearer <token>`

### 4. JWT Payload
```json
{
  "uid": "user-unique-id",
  "_id": "mongodb-id"
}
```

---

## Response Format

### Success Response
```json
{
  "statusCode": 200,
  "message": "Success message",
  "data": {
    // Response data
  }
}
```

### Error Response
```json
{
  "statusCode": 400,
  "message": "Error message",
  "error": "Error details"
}
```

---

## Key Features Summary

| Feature | Module | Key APIs |
|---------|--------|----------|
| User Management | Users | Login, Profile, Create, Update |
| Company Management | Company | Create, Update, List, Get |
| Advertisements | Advertisements | Create, Update, Copy, List |
| Campaigns | Ad Campaigns | Create, Update, List, Analytics |
| Following/Followers | Mapping User | Follow, List, Statistics |
| Saved Ads | Mapping User Saved | Save, List Saved |
| Search | Search | Category Search, Company Search, Advanced Filters |
| Notifications | Notification Subscription | FCM Registration |
| Analytics | User Publishing | View Count, CTA Clicks, Campaign Reached |
| Master Data | Masters | Categories, Ad Types, CTAs, Modules |
| Media | Media | Upload, Get, Get URLs |

---

## Environment Requirements

- **Node Version**: v18.13.0
- **Database**: MongoDB
- **Cache**: Redis (ioredis)
- **Message Queue**: RabbitMQ (amqp-connection-manager)
- **Cloud Services**: Firebase Admin, AWS SDK, Google Maps
- **External Services**: Cloudinary (media storage)

---

## Guards & Security

1. **JwtGuard** - Validates JWT token
2. **UserGuard** - Validates user type/permissions (for CONSUMER/PUBLISHER specific endpoints)

---

## Dependencies

- NestJS 10.3.0
- MongoDB with Mongoose
- Bull (Job Queue)
- Firebase Admin
- AWS SDK
- Google Maps Services

---

## Notes

- Base path includes `/v1` versioning
- Some endpoints may require specific user types (PUBLISHER, CONSUMER, ADMIN)
- File uploads use multipart/form-data
- All timestamps are stored in MongoDB format
- UIDs are auto-generated UUIDs in database schema

---

**Last Updated**: 2026
**API Version**: v1
