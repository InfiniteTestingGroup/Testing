package org.jackfruit.keliri.model;

import java.util.List;

public class AdminDashboardResponse {

    private long totalAds;
    private long activeAds;
    private long expiredAds;
    private long totalCampaigns;
    private long totalPublishers;
    private long totalSpend;
    private long totalClicks;

    public static class ChartData {
        private String date;
        private long clicks;
        private long impressions;
        private long spend;

        public ChartData() {}

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public long getClicks() {
            return clicks;
        }

        public void setClicks(long clicks) {
            this.clicks = clicks;
        }

        public long getImpressions() {
            return impressions;
        }

        public void setImpressions(long impressions) {
            this.impressions = impressions;
        }

        public long getSpend() {
            return spend;
        }

        public void setSpend(long spend) {
            this.spend = spend;
        }
    }

    private List<ChartData> performanceTrend;
    private List<ChartData> engagementTrend;
    private List<ChartData> spendVsPerformance;

    public long getTotalAds() {
        return totalAds;
    }

    public void setTotalAds(long totalAds) {
        this.totalAds = totalAds;
    }

    public long getActiveAds() {
        return activeAds;
    }

    public void setActiveAds(long activeAds) {
        this.activeAds = activeAds;
    }

    public long getExpiredAds() {
        return expiredAds;
    }

    public void setExpiredAds(long expiredAds) {
        this.expiredAds = expiredAds;
    }

    public long getTotalPublishers() {
        return totalPublishers;
    }

    public void setTotalPublishers(long totalPublishers) {
        this.totalPublishers = totalPublishers;
    }

    public long getTotalSpend() {
        return totalSpend;
    }

    public void setTotalSpend(long totalSpend) {
        this.totalSpend = totalSpend;
    }

    public long getTotalClicks() {
        return totalClicks;
    }

    public long getTotalCampaigns() {
        return totalCampaigns;
    }

    public void setTotalCampaigns(long totalCampaigns) {
        this.totalCampaigns = totalCampaigns;
    }

    public void setTotalClicks(long totalClicks) {
        this.totalClicks = totalClicks;
    }

    public List<ChartData> getPerformanceTrend() {
        return performanceTrend;
    }

    public void setPerformanceTrend(List<ChartData> performanceTrend) {
        this.performanceTrend = performanceTrend;
    }

    public List<ChartData> getEngagementTrend() {
        return engagementTrend;
    }

    public void setEngagementTrend(List<ChartData> engagementTrend) {
        this.engagementTrend = engagementTrend;
    }

    public List<ChartData> getSpendVsPerformance() {
        return spendVsPerformance;
    }

    public void setSpendVsPerformance(List<ChartData> spendVsPerformance) {
        this.spendVsPerformance = spendVsPerformance;
    }
}
