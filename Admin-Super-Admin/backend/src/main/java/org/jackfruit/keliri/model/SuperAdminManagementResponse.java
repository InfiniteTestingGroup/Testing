package org.jackfruit.keliri.model;

import java.util.ArrayList;
import java.util.List;

public class SuperAdminManagementResponse {
    public static class AdminRecord {
        private String id;
        private String name;
        private String email;
        private String company;
        private String registeredDate;
        private String status;
        private String phone;
        private Double latitude;
        private Double longitude;
        private String location;

        public Double getLatitude() {
            return latitude;
        }

        public void setLatitude(Double latitude) {
            this.latitude = latitude;
        }

        public Double getLongitude() {
            return longitude;
        }

        public void setLongitude(Double longitude) {
            this.longitude = longitude;
        }

        public String getLocation() {
            return location;
        }

        public void setLocation(String location) {
            this.location = location;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getCompany() {
            return company;
        }

        public void setCompany(String company) {
            this.company = company;
        }

        public String getRegisteredDate() {
            return registeredDate;
        }

        public void setRegisteredDate(String registeredDate) {
            this.registeredDate = registeredDate;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }
    }

    public static class AdminDetail extends AdminRecord {
        private PerformanceSummary performance;
        private List<DocumentItem> documents = new ArrayList<>();
        private List<PublisherMini> publishers = new ArrayList<>();
        private RegistrationInfo registration;

        public PerformanceSummary getPerformance() {
            return performance;
        }

        public void setPerformance(PerformanceSummary performance) {
            this.performance = performance;
        }

        public List<DocumentItem> getDocuments() {
            return documents;
        }

        public void setDocuments(List<DocumentItem> documents) {
            this.documents = documents;
        }

        public List<PublisherMini> getPublishers() {
            return publishers;
        }

        public void setPublishers(List<PublisherMini> publishers) {
            this.publishers = publishers;
        }

        public RegistrationInfo getRegistration() {
            return registration;
        }

        public void setRegistration(RegistrationInfo registration) {
            this.registration = registration;
        }
    }

    public static class RegistrationInfo {
        private String authorizedPerson;
        private String businessAddress;
        private String addressLine2;
        private String city;
        private String state;
        private String zipCode;
        private String country;
        private String gstNumber;
        private String companyType;
        private String countryCode;
        private String mobileNumber;
        private String submittedAt;

        public String getAuthorizedPerson() {
            return authorizedPerson;
        }

        public void setAuthorizedPerson(String authorizedPerson) {
            this.authorizedPerson = authorizedPerson;
        }

        public String getBusinessAddress() {
            return businessAddress;
        }

        public void setBusinessAddress(String businessAddress) {
            this.businessAddress = businessAddress;
        }

        public String getAddressLine2() {
            return addressLine2;
        }

        public void setAddressLine2(String addressLine2) {
            this.addressLine2 = addressLine2;
        }

        public String getCity() {
            return city;
        }

        public void setCity(String city) {
            this.city = city;
        }

        public String getState() {
            return state;
        }

        public void setState(String state) {
            this.state = state;
        }

        public String getZipCode() {
            return zipCode;
        }

        public void setZipCode(String zipCode) {
            this.zipCode = zipCode;
        }

        public String getCountry() {
            return country;
        }

        public void setCountry(String country) {
            this.country = country;
        }

        public String getGstNumber() {
            return gstNumber;
        }

        public void setGstNumber(String gstNumber) {
            this.gstNumber = gstNumber;
        }

        public String getCompanyType() {
            return companyType;
        }

        public void setCompanyType(String companyType) {
            this.companyType = companyType;
        }

        public String getCountryCode() {
            return countryCode;
        }

        public void setCountryCode(String countryCode) {
            this.countryCode = countryCode;
        }

        public String getMobileNumber() {
            return mobileNumber;
        }

        public void setMobileNumber(String mobileNumber) {
            this.mobileNumber = mobileNumber;
        }

        public String getSubmittedAt() {
            return submittedAt;
        }

        public void setSubmittedAt(String submittedAt) {
            this.submittedAt = submittedAt;
        }
    }

    public static class PerformanceSummary {
        private long totalAds;
        private long revenue;
        private double avgCtr;

        public long getTotalAds() {
            return totalAds;
        }

        public void setTotalAds(long totalAds) {
            this.totalAds = totalAds;
        }

        public long getRevenue() {
            return revenue;
        }

        public void setRevenue(long revenue) {
            this.revenue = revenue;
        }

        public double getAvgCtr() {
            return avgCtr;
        }

        public void setAvgCtr(double avgCtr) {
            this.avgCtr = avgCtr;
        }
    }

    public static class DocumentItem {
        private String name;
        private String type;
        private String url;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }
    }

    public static class PublisherMini {
        private String id;
        private String name;
        private String status;
        private long adsPosted;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public long getAdsPosted() {
            return adsPosted;
        }

        public void setAdsPosted(long adsPosted) {
            this.adsPosted = adsPosted;
        }
    }

    public static class AdminActionRequest {
        private String reason;

        public String getReason() {
            return reason;
        }

        public void setReason(String reason) {
            this.reason = reason;
        }
    }

    public static class AdminActionResponse {
        private AdminRecord admin;
        private EmailNotificationRecord emailNotification;

        public AdminRecord getAdmin() {
            return admin;
        }

        public void setAdmin(AdminRecord admin) {
            this.admin = admin;
        }

        public EmailNotificationRecord getEmailNotification() {
            return emailNotification;
        }

        public void setEmailNotification(EmailNotificationRecord emailNotification) {
            this.emailNotification = emailNotification;
        }
    }

    public static class EmailNotificationRecord {
        private String id;
        private String trigger;
        private String to;
        private String content;
        private String timestamp;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getTrigger() {
            return trigger;
        }

        public void setTrigger(String trigger) {
            this.trigger = trigger;
        }

        public String getTo() {
            return to;
        }

        public void setTo(String to) {
            this.to = to;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public String getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(String timestamp) {
            this.timestamp = timestamp;
        }
    }

    public static class PublisherRecord {
        private String id;
        private String name;
        private String adminId;
        private String adminName;
        private String location;
        private long adsPosted;
        private long impressions;
        private long clicks;
        private double engagement;
        private String status;
        private String email;
        private String phone;
        private String joinDate;
        private Double latitude;
        private Double longitude;

        public Double getLatitude() {
            return latitude;
        }

        public void setLatitude(Double latitude) {
            this.latitude = latitude;
        }

        public Double getLongitude() {
            return longitude;
        }

        public void setLongitude(Double longitude) {
            this.longitude = longitude;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getAdminId() {
            return adminId;
        }

        public void setAdminId(String adminId) {
            this.adminId = adminId;
        }

        public String getAdminName() {
            return adminName;
        }

        public void setAdminName(String adminName) {
            this.adminName = adminName;
        }

        public String getLocation() {
            return location;
        }

        public void setLocation(String location) {
            this.location = location;
        }

        public long getAdsPosted() {
            return adsPosted;
        }

        public void setAdsPosted(long adsPosted) {
            this.adsPosted = adsPosted;
        }

        public long getImpressions() {
            return impressions;
        }

        public void setImpressions(long impressions) {
            this.impressions = impressions;
        }

        public long getClicks() {
            return clicks;
        }

        public void setClicks(long clicks) {
            this.clicks = clicks;
        }

        public double getEngagement() {
            return engagement;
        }

        public void setEngagement(double engagement) {
            this.engagement = engagement;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }

        public String getJoinDate() {
            return joinDate;
        }

        public void setJoinDate(String joinDate) {
            this.joinDate = joinDate;
        }
    }

    public static class PublisherDetail extends PublisherRecord {
        private List<PublisherAdRecord> ads = new ArrayList<>();

        public List<PublisherAdRecord> getAds() {
            return ads;
        }

        public void setAds(List<PublisherAdRecord> ads) {
            this.ads = ads;
        }
    }

    public static class PublisherAdRecord {
        private String id;
        private String title;
        private String type;
        private String status;
        private double ctr;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public double getCtr() {
            return ctr;
        }

        public void setCtr(double ctr) {
            this.ctr = ctr;
        }
    }

    public static class AdvertisementRecord {
        private String id;
        private String title;
        private String description;
        private String type;
        private String adminId;
        private String adminName;
        private String publisherId;
        private String publisherName;
        private String createdDate;
        private String createdAt;
        private String status;
        private Long impressions;
        private Long clicks;
        private Double ctr;
        private String startDate;
        private String endDate;
        private String location;
        private String radius;
        private String image;
        private Double lat;
        private Double lng;
        private Integer locationRange;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getAdminId() {
            return adminId;
        }

        public void setAdminId(String adminId) {
            this.adminId = adminId;
        }

        public String getAdminName() {
            return adminName;
        }

        public void setAdminName(String adminName) {
            this.adminName = adminName;
        }

        public String getPublisherId() {
            return publisherId;
        }

        public void setPublisherId(String publisherId) {
            this.publisherId = publisherId;
        }

        public String getPublisherName() {
            return publisherName;
        }

        public void setPublisherName(String publisherName) {
            this.publisherName = publisherName;
        }

        public String getCreatedDate() {
            return createdDate;
        }

        public void setCreatedDate(String createdDate) {
            this.createdDate = createdDate;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public Long getImpressions() {
            return impressions;
        }

        public void setImpressions(Long impressions) {
            this.impressions = impressions;
        }

        public Long getClicks() {
            return clicks;
        }

        public void setClicks(Long clicks) {
            this.clicks = clicks;
        }

        public Double getCtr() {
            return ctr;
        }

        public void setCtr(Double ctr) {
            this.ctr = ctr;
        }

        public String getStartDate() {
            return startDate;
        }

        public void setStartDate(String startDate) {
            this.startDate = startDate;
        }

        public String getEndDate() {
            return endDate;
        }

        public void setEndDate(String endDate) {
            this.endDate = endDate;
        }

        public String getLocation() {
            return location;
        }

        public void setLocation(String location) {
            this.location = location;
        }

        public String getRadius() {
            return radius;
        }

        public void setRadius(String radius) {
            this.radius = radius;
        }

        public String getImage() {
            return image;
        }

        public void setImage(String image) {
            this.image = image;
        }

        public String getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(String createdAt) {
            this.createdAt = createdAt;
        }

        public Double getLat() {
            return lat;
        }

        public void setLat(Double lat) {
            this.lat = lat;
        }

        public Double getLng() {
            return lng;
        }

        public void setLng(Double lng) {
            this.lng = lng;
        }

        public Integer getLocationRange() {
            return locationRange;
        }

        public void setLocationRange(Integer locationRange) {
            this.locationRange = locationRange;
        }
    }

    public static class AuditLogRecord {
        private String id;
        private String timestamp;
        private String actorName;
        private String actorRole;
        private String actionType;
        private String entityType;
        private String entityId;
        private String action;
        private String ip;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(String timestamp) {
            this.timestamp = timestamp;
        }

        public String getActorName() {
            return actorName;
        }

        public void setActorName(String actorName) {
            this.actorName = actorName;
        }

        public String getActorRole() {
            return actorRole;
        }

        public void setActorRole(String actorRole) {
            this.actorRole = actorRole;
        }

        public String getActionType() {
            return actionType;
        }

        public void setActionType(String actionType) {
            this.actionType = actionType;
        }

        public String getEntityType() {
            return entityType;
        }

        public void setEntityType(String entityType) {
            this.entityType = entityType;
        }

        public String getEntityId() {
            return entityId;
        }

        public void setEntityId(String entityId) {
            this.entityId = entityId;
        }

        public String getAction() {
            return action;
        }

        public void setAction(String action) {
            this.action = action;
        }

        public String getIp() {
            return ip;
        }

        public void setIp(String ip) {
            this.ip = ip;
        }
    }

    public static class TransactionRecord {
        private String id;
        private String date;
        private String adminId;
        private String adminName;
        private String reference;
        private double amount;
        private String status;
        private boolean incoming;
        private String publisherName;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public String getAdminId() {
            return adminId;
        }

        public void setAdminId(String adminId) {
            this.adminId = adminId;
        }

        public String getAdminName() {
            return adminName;
        }

        public void setAdminName(String adminName) {
            this.adminName = adminName;
        }

        public String getReference() {
            return reference;
        }

        public void setReference(String reference) {
            this.reference = reference;
        }

        public double getAmount() {
            return amount;
        }

        public void setAmount(double amount) {
            this.amount = amount;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public boolean isIncoming() {
            return incoming;
        }

        public void setIncoming(boolean incoming) {
            this.incoming = incoming;
        }

        public String getPublisherName() {
            return publisherName;
        }

        public void setPublisherName(String publisherName) {
            this.publisherName = publisherName;
        }

        private String latitude;
        private String longitude;

        public String getLatitude() {
            return latitude;
        }

        public void setLatitude(String latitude) {
            this.latitude = latitude;
        }

        public String getLongitude() {
            return longitude;
        }

        public void setLongitude(String longitude) {
            this.longitude = longitude;
        }
    }
}
