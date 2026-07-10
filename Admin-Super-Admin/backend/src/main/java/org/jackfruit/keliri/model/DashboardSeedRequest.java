package org.jackfruit.keliri.model;

import java.util.List;

public class DashboardSeedRequest {
    private List<PublisherSeed> publishers;
    private List<CampaignSeed> campaigns;

    public List<PublisherSeed> getPublishers() {
        return publishers;
    }

    public void setPublishers(List<PublisherSeed> publishers) {
        this.publishers = publishers;
    }

    public List<CampaignSeed> getCampaigns() {
        return campaigns;
    }

    public void setCampaigns(List<CampaignSeed> campaigns) {
        this.campaigns = campaigns;
    }

    public static class PublisherSeed {
        private String name;
        private String email;
        private String countryCode;
        private String phone;
        private double latitude;
        private double longitude;

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

        public String getCountryCode() {
            return countryCode;
        }

        public void setCountryCode(String countryCode) {
            this.countryCode = countryCode;
        }

        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }

        public double getLatitude() {
            return latitude;
        }

        public void setLatitude(double latitude) {
            this.latitude = latitude;
        }

        public double getLongitude() {
            return longitude;
        }

        public void setLongitude(double longitude) {
            this.longitude = longitude;
        }
    }

    public static class CampaignSeed {
        private String creatorName;
        private String creatorEmail;
        private String creatorPhone;
        private String creatorCountryCode;
        private String title;
        private String description;
        private String company;
        private String adType;
        private String status;
        private String locationName;
        private double latitude;
        private double longitude;
        private double radiusKm;
        private String startDate;
        private String endDate;

        public String getCreatorName() {
            return creatorName;
        }

        public void setCreatorName(String creatorName) {
            this.creatorName = creatorName;
        }

        public String getCreatorEmail() {
            return creatorEmail;
        }

        public void setCreatorEmail(String creatorEmail) {
            this.creatorEmail = creatorEmail;
        }

        public String getCreatorPhone() {
            return creatorPhone;
        }

        public void setCreatorPhone(String creatorPhone) {
            this.creatorPhone = creatorPhone;
        }

        public String getCreatorCountryCode() {
            return creatorCountryCode;
        }

        public void setCreatorCountryCode(String creatorCountryCode) {
            this.creatorCountryCode = creatorCountryCode;
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

        public String getCompany() {
            return company;
        }

        public void setCompany(String company) {
            this.company = company;
        }

        public String getAdType() {
            return adType;
        }

        public void setAdType(String adType) {
            this.adType = adType;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getLocationName() {
            return locationName;
        }

        public void setLocationName(String locationName) {
            this.locationName = locationName;
        }

        public double getLatitude() {
            return latitude;
        }

        public void setLatitude(double latitude) {
            this.latitude = latitude;
        }

        public double getLongitude() {
            return longitude;
        }

        public void setLongitude(double longitude) {
            this.longitude = longitude;
        }

        public double getRadiusKm() {
            return radiusKm;
        }

        public void setRadiusKm(double radiusKm) {
            this.radiusKm = radiusKm;
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
    }
}
