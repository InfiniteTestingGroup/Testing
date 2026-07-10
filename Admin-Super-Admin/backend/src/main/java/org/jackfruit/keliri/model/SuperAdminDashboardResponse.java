package org.jackfruit.keliri.model;

import java.util.List;

public class SuperAdminDashboardResponse {
    private DashboardSummary summary;
    private List<KpiMetric> kpis;
    private List<TrendPoint> publishingTrend;
    private List<TopCreator> topCreators;
    private List<RecentActivity> recentActivities;
    private List<BreakdownItem> adTypeBreakdown;
    private List<BreakdownItem> locationBreakdown;

    public DashboardSummary getSummary() {
        return summary;
    }

    public void setSummary(DashboardSummary summary) {
        this.summary = summary;
    }

    public List<KpiMetric> getKpis() {
        return kpis;
    }

    public void setKpis(List<KpiMetric> kpis) {
        this.kpis = kpis;
    }

    public List<TrendPoint> getPublishingTrend() {
        return publishingTrend;
    }

    public void setPublishingTrend(List<TrendPoint> publishingTrend) {
        this.publishingTrend = publishingTrend;
    }

    public List<TopCreator> getTopCreators() {
        return topCreators;
    }

    public void setTopCreators(List<TopCreator> topCreators) {
        this.topCreators = topCreators;
    }

    public List<RecentActivity> getRecentActivities() {
        return recentActivities;
    }

    public void setRecentActivities(List<RecentActivity> recentActivities) {
        this.recentActivities = recentActivities;
    }

    public List<BreakdownItem> getAdTypeBreakdown() {
        return adTypeBreakdown;
    }

    public void setAdTypeBreakdown(List<BreakdownItem> adTypeBreakdown) {
        this.adTypeBreakdown = adTypeBreakdown;
    }

    public List<BreakdownItem> getLocationBreakdown() {
        return locationBreakdown;
    }

    public void setLocationBreakdown(List<BreakdownItem> locationBreakdown) {
        this.locationBreakdown = locationBreakdown;
    }

    public static class DashboardSummary {
        private long totalAds;
        private long totalCampaigns;
        private long activeCampaigns;
        private long totalPublishers;
        private long totalUsers;
        private long geoTargetedCampaigns;
        private long uniqueTargetLocations;
        private double averageTargetRadiusKm;

        public long getTotalAds() {
            return totalAds;
        }

        public void setTotalAds(long totalAds) {
            this.totalAds = totalAds;
        }

        public long getTotalCampaigns() {
            return totalCampaigns;
        }

        public void setTotalCampaigns(long totalCampaigns) {
            this.totalCampaigns = totalCampaigns;
        }

        public long getActiveCampaigns() {
            return activeCampaigns;
        }

        public void setActiveCampaigns(long activeCampaigns) {
            this.activeCampaigns = activeCampaigns;
        }

        public long getTotalPublishers() {
            return totalPublishers;
        }

        public void setTotalPublishers(long totalPublishers) {
            this.totalPublishers = totalPublishers;
        }

        public long getTotalUsers() {
            return totalUsers;
        }

        public void setTotalUsers(long totalUsers) {
            this.totalUsers = totalUsers;
        }

        public long getGeoTargetedCampaigns() {
            return geoTargetedCampaigns;
        }

        public void setGeoTargetedCampaigns(long geoTargetedCampaigns) {
            this.geoTargetedCampaigns = geoTargetedCampaigns;
        }

        public long getUniqueTargetLocations() {
            return uniqueTargetLocations;
        }

        public void setUniqueTargetLocations(long uniqueTargetLocations) {
            this.uniqueTargetLocations = uniqueTargetLocations;
        }

        public double getAverageTargetRadiusKm() {
            return averageTargetRadiusKm;
        }

        public void setAverageTargetRadiusKm(double averageTargetRadiusKm) {
            this.averageTargetRadiusKm = averageTargetRadiusKm;
        }
    }

    public static class KpiMetric {
        private String id;
        private String title;
        private String value;
        private double change;
        private String changeLabel;
        private String prefix;

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

        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }

        public double getChange() {
            return change;
        }

        public void setChange(double change) {
            this.change = change;
        }

        public String getChangeLabel() {
            return changeLabel;
        }

        public void setChangeLabel(String changeLabel) {
            this.changeLabel = changeLabel;
        }

        public String getPrefix() {
            return prefix;
        }

        public void setPrefix(String prefix) {
            this.prefix = prefix;
        }
    }

    public static class TrendPoint {
        private String label;
        private long value;

        public TrendPoint() {
        }

        public TrendPoint(String label, long value) {
            this.label = label;
            this.value = value;
        }

        public String getLabel() {
            return label;
        }

        public void setLabel(String label) {
            this.label = label;
        }

        public long getValue() {
            return value;
        }

        public void setValue(long value) {
            this.value = value;
        }
    }

    public static class TopCreator {
        private int rank;
        private String name;
        private String email;
        private long campaignCount;
        private long activeCampaignCount;
        private long locationCount;
        private double change;

        public int getRank() {
            return rank;
        }

        public void setRank(int rank) {
            this.rank = rank;
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

        public long getCampaignCount() {
            return campaignCount;
        }

        public void setCampaignCount(long campaignCount) {
            this.campaignCount = campaignCount;
        }

        public long getActiveCampaignCount() {
            return activeCampaignCount;
        }

        public void setActiveCampaignCount(long activeCampaignCount) {
            this.activeCampaignCount = activeCampaignCount;
        }

        public long getLocationCount() {
            return locationCount;
        }

        public void setLocationCount(long locationCount) {
            this.locationCount = locationCount;
        }

        public double getChange() {
            return change;
        }

        public void setChange(double change) {
            this.change = change;
        }
    }

    public static class RecentActivity {
        private String id;
        private String action;
        private String status;
        private String locationName;
        private String occurredAt;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getAction() {
            return action;
        }

        public void setAction(String action) {
            this.action = action;
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

        public String getOccurredAt() {
            return occurredAt;
        }

        public void setOccurredAt(String occurredAt) {
            this.occurredAt = occurredAt;
        }
    }

    public static class BreakdownItem {
        private String label;
        private long count;
        private long percentage;

        public BreakdownItem() {
        }

        public BreakdownItem(String label, long count, long percentage) {
            this.label = label;
            this.count = count;
            this.percentage = percentage;
        }

        public String getLabel() {
            return label;
        }

        public void setLabel(String label) {
            this.label = label;
        }

        public long getCount() {
            return count;
        }

        public void setCount(long count) {
            this.count = count;
        }

        public long getPercentage() {
            return percentage;
        }

        public void setPercentage(long percentage) {
            this.percentage = percentage;
        }
    }
}
