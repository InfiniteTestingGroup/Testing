# MOBILIZE API - COMPLETE ANALYSIS SUMMARY

## 📋 Documentation Files Created

1. **API_DOCUMENTATION.md** - Complete markdown documentation with all endpoints, purposes, and authentication details
2. **API_ENDPOINTS.json** - Machine-readable JSON format with all 86+ endpoints across 15 modules
3. **API_QUICK_REFERENCE.md** - Ready-to-use code examples and integration patterns

---

## 🎯 API OVERVIEW

### Total Endpoints: 86+
### Total Modules: 15
### API Version: v1
### Base URL: `http://localhost:3000/v1`

---

## 📦 MODULES BREAKDOWN

| Module | Path | Endpoints | Purpose |
|--------|------|-----------|---------|
| **User Management** | `/user` | 17 | Authentication, profile, user CRUD |
| **Company** | `/company` | 5 | Company management and listings |
| **Roles** | `/roles` | 5 | Role and permission management |
| **Masters** | `/masters` | 18 | Master data: categories, ad types, CTAs |
| **Media** | `/media` | 3 | File upload and retrieval |
| **User Profile** | `/user-profile` | 3 | Profile customization and preferences |
| **Advertisements** | `/advertisements` | 8 | Ad creation, update, copy, listing |
| **Ad Campaigns** | `/ad-campaigns` | 9 | Campaign management and analytics |
| **Search** | `/search` | 4 | Category, company, and advanced search |
| **Saved Ads** | `/mapping-user-ads` | 2 | Save/bookmark ads |
| **Following** | `/mapping-user` | 5 | Follow publishers/companies |
| **Publishing** | `/user-publishing` | 8 | Feed, analytics, CTA tracking |
| **Notifications** | `/notification-subscripton` | 1 | FCM token registration |
| **Banners** | `/banners` | 3 | Banner management |
| **Queue Control** | `/queue-control` | 1 | Redis and job scheduling |

---

## 🔐 AUTHENTICATION PATTERNS

### Two Guard Types:
- **JwtGuard** - Validates JWT token for authenticated endpoints
- **UserGuard** - Validates user type (PUBLISHER/CONSUMER/ADMIN)

### Login Flow:
1. User login with email/phone
2. OTP verification
3. JWT token returned
4. Use token in `Authorization: Bearer <token>` header

---

## 🚀 KEY FEATURES & APIs

### User Management
- ✅ Registration (email/phone)
- ✅ Login with OTP
- ✅ Profile management
- ✅ Password reset
- ✅ User creation by admin
- ✅ Dashboard statistics

### Advertisements
- ✅ Create ads (IMAGE/VIDEO/TEXT)
- ✅ Update and publish ads
- ✅ Copy ad templates
- ✅ Ad analytics
- ✅ Get ads by publisher

### Campaigns
- ✅ Create campaigns from ads
- ✅ Campaign status management
- ✅ Date-range analytics
- ✅ Daywise performance tracking
- ✅ Campaign reach analytics

### Search & Discovery
- ✅ Search by categories
- ✅ Search companies
- ✅ Advanced filter search
- ✅ Publisher discovery

### Social Features
- ✅ Follow publishers/companies
- ✅ Get follower statistics
- ✅ Following users' campaigns
- ✅ Save favorite ads

### Analytics
- ✅ Ad view tracking
- ✅ CTA click tracking
- ✅ Campaign reach metrics
- ✅ Engagement analytics
- ✅ Impression counting

### Media
- ✅ File upload (any format)
- ✅ Get media by UIDs
- ✅ Get media URLs only
- ✅ Cloudinary integration

### Notifications
- ✅ FCM token registration
- ✅ Push notification system
- ✅ RabbitMQ integration
- ✅ User location tracking

---

## 💾 DATA MODELS & TYPES

### User Types
- `PUBLISHER` - Content creators
- `CONSUMER` - Ad viewers
- `ADMIN` - Platform administrators

### Ad Types
- `IMAGE` - Static image ads
- `VIDEO` - Video advertisements
- `TEXT` - Text-based ads
- `CAROUSEL` - Multiple images

### Campaign Status
- `ACTIVE` - Running campaigns
- `PAUSED` - Temporarily stopped
- `COMPLETED` - Finished campaigns

### Entity Types
- `PUBLISHER` - Individual publishers
- `COMPANY` - Company accounts

### Device Types
- `ANDROID` - Android devices
- `IOS` - iPhone/iPad
- `WEB` - Web browsers

---

## 🛠️ TECHNOLOGY STACK

### Framework
- **NestJS** v10.3.0 - TypeScript-based backend framework

### Database
- **MongoDB** - NoSQL database with Mongoose ODM

### Caching & Queue
- **Redis** (ioredis) - Caching and session management
- **Bull** v4.12.0 - Job queue management

### Message Broker
- **RabbitMQ** - Message queuing (AMQP)

### Cloud Services
- **Firebase Admin** - Push notifications
- **AWS SDK** - Cloud storage and services
- **Google Maps** - Location services
- **Cloudinary** - Media storage

### Additional Libraries
- **JWT** - JSON Web Token authentication
- **Bcrypt** - Password hashing
- **OTP Generator** - One-time passwords
- **Passport** - Authentication middleware

---

## 📊 API STATISTICS

| Category | Count |
|----------|-------|
| GET Endpoints | 42 |
| POST Endpoints | 28 |
| PUT Endpoints | 14 |
| DELETE Endpoints | 1 |
| **Total** | **86+** |

---

## 🔄 REQUEST/RESPONSE PATTERN

### Success Response
```json
{
  "statusCode": 200,
  "message": "Success message",
  "data": { /* response data */ }
}
```

### Error Response
```json
{
  "statusCode": 400,
  "message": "Error message",
  "error": "Detailed error information"
}
```

---

## 🎓 USAGE GUIDELINES

### For Integration into Your Projects:

1. **Reference the Documentation**
   - Use `API_DOCUMENTATION.md` for detailed endpoint info
   - Use `API_ENDPOINTS.json` for programmatic access
   - Use `API_QUICK_REFERENCE.md` for code examples

2. **Authentication Setup**
   - Login via `/user/login`
   - Store JWT token securely
   - Include in all subsequent requests

3. **Common Patterns**
   - Pagination: Use `page` and `limit` query params
   - Filtering: Use `filter` query or request body
   - Sorting: Use `sort` and `order` params

4. **Error Handling**
   - Handle 401 (token expired) - re-authenticate
   - Handle 403 (forbidden) - check permissions
   - Handle 404 (not found) - verify resource exists
   - Handle 500 (server error) - retry or contact support

5. **Pagination Example**
   ```
   GET /advertisements?page=1&limit=20&sort=-createdAt
   ```

---

## 🔗 IMPORTANT ENDPOINTS FOR QUICK START

### Essential Endpoints:
1. `POST /user/login` - Get JWT token
2. `GET /user/me` - Verify authentication
3. `GET /masters/import` - Load master data
4. `POST /advertisements/create` - Create ad
5. `POST /ad-campaigns/create` - Create campaign
6. `GET /advertisements` - List ads
7. `POST /media/upload` - Upload media

---

## 📁 PROJECT STRUCTURE

```
mobilize_api/
├── dist/app/v1/
│   ├── users/              (User management)
│   ├── companies/          (Company management)
│   ├── roles/              (Role management)
│   ├── masters/            (Master data)
│   ├── media/              (Media handling)
│   ├── user-profile/       (Profile management)
│   ├── advertisements/     (Ad management)
│   ├── ad_campaigns/       (Campaign management)
│   ├── search/             (Search functionality)
│   ├── mapping-user-ads/   (Saved ads)
│   ├── mapping_user_following/ (Following users)
│   ├── txn/user_publishing/ (Publishing & analytics)
│   ├── notification_subscription/ (Notifications)
│   ├── banners/            (Banners)
│   └── queue-control/      (Queue management)
```

---

## 🚨 IMPORTANT NOTES

1. **Base URL** - All endpoints are under `/v1` for versioning
2. **JWT Token** - Required for most endpoints (except login/verify-otp)
3. **User Types** - Different endpoints for PUBLISHER vs CONSUMER vs ADMIN
4. **File Upload** - Use `multipart/form-data` for media upload
5. **Pagination** - Default limit varies; check documentation
6. **Date Format** - Use ISO 8601 format (YYYY-MM-DD)
7. **UIDs** - Auto-generated UUIDs for all resources

---

## ✅ VALIDATION CHECKLIST BEFORE USE

- [ ] Review `API_DOCUMENTATION.md` for your specific use case
- [ ] Check authentication requirements (JWT token needed?)
- [ ] Verify required query/body parameters
- [ ] Ensure correct HTTP method (GET, POST, PUT, DELETE)
- [ ] Add proper error handling for your implementation
- [ ] Test with sample data first
- [ ] Configure timeout appropriately
- [ ] Handle pagination for list endpoints
- [ ] Store JWT securely in your application
- [ ] Implement rate limiting if needed

---

## 📞 NEXT STEPS FOR YOUR PROJECT

1. **Copy the documentation files** to your project
2. **Study the API flows** that match your requirements
3. **Create client SDK** if needed (optional wrapper around HTTP calls)
4. **Implement authentication** flow first
5. **Map out your endpoints** usage based on features
6. **Test with cURL/Postman** before integrating
7. **Add error handling** and logging
8. **Implement retry logic** for failed requests

---

## 📚 QUICK COMMAND REFERENCE

### Test Authentication
```bash
curl -X POST http://localhost:3000/v1/user/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"123456"}'
```

### Get Current User
```bash
curl -X GET http://localhost:3000/v1/user/me \
  -H "Authorization: Bearer JWT_TOKEN"
```

### List Ads
```bash
curl -X GET "http://localhost:3000/v1/advertisements?page=1&limit=20" \
  -H "Authorization: Bearer JWT_TOKEN"
```

### Create Advertisement
```bash
curl -X POST http://localhost:3000/v1/advertisements/create \
  -H "Authorization: Bearer JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My Ad",
    "description": "Ad description",
    "adType": "IMAGE"
  }'
```

---

## 🎯 FINAL SUMMARY

You now have:
- ✅ **Complete API documentation** with 86+ endpoints
- ✅ **JSON endpoint reference** for programmatic use
- ✅ **Code examples** ready to copy and adapt
- ✅ **Authentication flows** and patterns
- ✅ **Error handling** guidelines
- ✅ **Integration checklist** for your project

**All 3 documentation files are in your project root directory and ready to use!**

---

*Generated: April 27, 2026*
*API Version: v1*
*Documentation Version: 1.0*
