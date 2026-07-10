package org.jackfruit.keliri.model;

import java.util.List;

public class AdminAnalyticsResponse {
    private KpiData kpis;
    private List<TrendData> trends;
    private Breakdowns breakdowns;
    private List<String> insights;

    public KpiData getKpis() { return kpis; }
    public void setKpis(KpiData kpis) { this.kpis = kpis; }

    public List<TrendData> getTrends() { return trends; }
    public void setTrends(List<TrendData> trends) { this.trends = trends; }

    public Breakdowns getBreakdowns() { return breakdowns; }
    public void setBreakdowns(Breakdowns breakdowns) { this.breakdowns = breakdowns; }

    public List<String> getInsights() { return insights; }
    public void setInsights(List<String> insights) { this.insights = insights; }

    public static class KpiData {
        private long impressions;
        private long clicks;
        private double ctr;
        private long spend;
        private long activeCampaigns;
        private ComparisonTrends trends;

        public long getImpressions() { return impressions; }
        public void setImpressions(long impressions) { this.impressions = impressions; }

        public long getClicks() { return clicks; }
        public void setClicks(long clicks) { this.clicks = clicks; }

        public double getCtr() { return ctr; }
        public void setCtr(double ctr) { this.ctr = ctr; }

        public long getSpend() { return spend; }
        public void setSpend(long spend) { this.spend = spend; }

        public long getActiveCampaigns() { return activeCampaigns; }
        public void setActiveCampaigns(long activeCampaigns) { this.activeCampaigns = activeCampaigns; }

        public ComparisonTrends getTrends() { return trends; }
        public void setTrends(ComparisonTrends trends) { this.trends = trends; }
    }

    public static class ComparisonTrends {
        private double impressions;
        private double clicks;
        private double ctr;
        private double spend;

        public double getImpressions() { return impressions; }
        public void setImpressions(double impressions) { this.impressions = impressions; }

        public double getClicks() { return clicks; }
        public void setClicks(double clicks) { this.clicks = clicks; }

        public double getCtr() { return ctr; }
        public void setCtr(double ctr) { this.ctr = ctr; }

        public double getSpend() { return spend; }
        public void setSpend(double spend) { this.spend = spend; }
    }

    public static class TrendData {
        private String time;
        private long impressions;
        private long clicks;
        private long spend;

        public String getTime() { return time; }
        public void setTime(String time) { this.time = time; }

        public long getImpressions() { return impressions; }
        public void setImpressions(long impressions) { this.impressions = impressions; }

        public long getClicks() { return clicks; }
        public void setClicks(long clicks) { this.clicks = clicks; }

        public long getSpend() { return spend; }
        public void setSpend(long spend) { this.spend = spend; }
    }

    public static class Breakdowns {
        private List<BreakdownItem> byAd;
        private List<BreakdownItem> byPublisher;
        private List<BreakdownItem> byLocation;

        public List<BreakdownItem> getByAd() { return byAd; }
        public void setByAd(List<BreakdownItem> byAd) { this.byAd = byAd; }

        public List<BreakdownItem> getByPublisher() { return byPublisher; }
        public void setByPublisher(List<BreakdownItem> byPublisher) { this.byPublisher = byPublisher; }

        public List<BreakdownItem> getByLocation() { return byLocation; }
        public void setByLocation(List<BreakdownItem> byLocation) { this.byLocation = byLocation; }
    }

    public static class BreakdownItem {
        private String name;
        private long value;
        private double percentage;

        public String getName() { return name; }
        public void setName(String name) { this.name = name; }

        public long getValue() { return value; }
        public void setValue(long value) { this.value = value; }

        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }
    }
}
