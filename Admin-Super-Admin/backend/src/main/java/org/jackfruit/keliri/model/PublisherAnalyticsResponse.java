package org.jackfruit.keliri.model;

import java.util.List;

public class PublisherAnalyticsResponse {

    private Stats stats;
    private List<TrendData> trends;
    private List<CampaignData> campaigns;

    public Stats getStats() { return stats; }
    public void setStats(Stats stats) { this.stats = stats; }

    public List<TrendData> getTrends() { return trends; }
    public void setTrends(List<TrendData> trends) { this.trends = trends; }

    public List<CampaignData> getCampaigns() { return campaigns; }
    public void setCampaigns(List<CampaignData> campaigns) { this.campaigns = campaigns; }

    public static class Stats {
        private long totalAds;
        private long activeCampaigns;
        private long impressions;
        private long clicks;
        private double ctr;

        public long getTotalAds() { return totalAds; }
        public void setTotalAds(long totalAds) { this.totalAds = totalAds; }

        public long getActiveCampaigns() { return activeCampaigns; }
        public void setActiveCampaigns(long activeCampaigns) { this.activeCampaigns = activeCampaigns; }

        public long getImpressions() { return impressions; }
        public void setImpressions(long impressions) { this.impressions = impressions; }

        public long getClicks() { return clicks; }
        public void setClicks(long clicks) { this.clicks = clicks; }

        public double getCtr() { return ctr; }
        public void setCtr(double ctr) { this.ctr = ctr; }
    }

    public static class TrendData {
        private String date;
        private long impressions;
        private long clicks;

        public String getDate() { return date; }
        public void setDate(String date) { this.date = date; }

        public long getImpressions() { return impressions; }
        public void setImpressions(long impressions) { this.impressions = impressions; }

        public long getClicks() { return clicks; }
        public void setClicks(long clicks) { this.clicks = clicks; }
    }

    public static class CampaignData {
        private String id;
        private String title;
        private String status;
        private String startDate;
        private String endDate;
        private long impressions;
        private long clicks;
        private double ctr;

        public String getId() { return id; }
        public void setId(String id) { this.id = id; }

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public String getStartDate() { return startDate; }
        public void setStartDate(String startDate) { this.startDate = startDate; }

        public String getEndDate() { return endDate; }
        public void setEndDate(String endDate) { this.endDate = endDate; }

        public long getImpressions() { return impressions; }
        public void setImpressions(long impressions) { this.impressions = impressions; }

        public long getClicks() { return clicks; }
        public void setClicks(long clicks) { this.clicks = clicks; }

        public double getCtr() { return ctr; }
        public void setCtr(double ctr) { this.ctr = ctr; }
    }
}
