package org.jackfruit.keliri.model;

import java.util.List;

public class SuperAdminAnalyticsResponse {
    private List<MetricCard> kpis;
    private List<NamedCount> topCampaigns;
    private List<NamedCount> adTypeBreakdown;
    private List<LocationRow> locationRows;
    private List<NamedValue> radiusBreakdown;
    private String topLocation;
    private List<CreatorRow> creatorRows;
    private List<NamedValue> campaignsPerCreator;
    private List<PublisherRow> publisherRows;
    private List<NamedValue> monthlyTrend;
    private List<NamedValue> weeklyTrend;
    private List<NamedValue> monthlyAdminsTrend;
    private List<NamedValue> monthlyUsersTrend;
    private List<NamedValue> durationBreakdown;
    private List<NamedValue> monthlyTransactionsTrend;
    private List<DataCheckpoint> dataCheckpoint;

    public List<MetricCard> getKpis() {
        return kpis;
    }

    public void setKpis(List<MetricCard> kpis) {
        this.kpis = kpis;
    }

    public List<NamedCount> getTopCampaigns() {
        return topCampaigns;
    }

    public void setTopCampaigns(List<NamedCount> topCampaigns) {
        this.topCampaigns = topCampaigns;
    }

    public List<NamedCount> getAdTypeBreakdown() {
        return adTypeBreakdown;
    }

    public void setAdTypeBreakdown(List<NamedCount> adTypeBreakdown) {
        this.adTypeBreakdown = adTypeBreakdown;
    }

    public List<LocationRow> getLocationRows() {
        return locationRows;
    }

    public void setLocationRows(List<LocationRow> locationRows) {
        this.locationRows = locationRows;
    }

    public List<NamedValue> getRadiusBreakdown() {
        return radiusBreakdown;
    }

    public void setRadiusBreakdown(List<NamedValue> radiusBreakdown) {
        this.radiusBreakdown = radiusBreakdown;
    }

    public String getTopLocation() {
        return topLocation;
    }

    public void setTopLocation(String topLocation) {
        this.topLocation = topLocation;
    }

    public List<CreatorRow> getCreatorRows() {
        return creatorRows;
    }

    public void setCreatorRows(List<CreatorRow> creatorRows) {
        this.creatorRows = creatorRows;
    }

    public List<NamedValue> getCampaignsPerCreator() {
        return campaignsPerCreator;
    }

    public void setCampaignsPerCreator(List<NamedValue> campaignsPerCreator) {
        this.campaignsPerCreator = campaignsPerCreator;
    }

    public List<PublisherRow> getPublisherRows() {
        return publisherRows;
    }

    public void setPublisherRows(List<PublisherRow> publisherRows) {
        this.publisherRows = publisherRows;
    }

    public List<NamedValue> getMonthlyTrend() {
        return monthlyTrend;
    }

    public void setMonthlyTrend(List<NamedValue> monthlyTrend) {
        this.monthlyTrend = monthlyTrend;
    }

    public List<NamedValue> getWeeklyTrend() {
        return weeklyTrend;
    }

    public void setWeeklyTrend(List<NamedValue> weeklyTrend) {
        this.weeklyTrend = weeklyTrend;
    }

    public List<NamedValue> getMonthlyAdminsTrend() {
        return monthlyAdminsTrend;
    }

    public void setMonthlyAdminsTrend(List<NamedValue> monthlyAdminsTrend) {
        this.monthlyAdminsTrend = monthlyAdminsTrend;
    }

    public List<NamedValue> getMonthlyUsersTrend() {
        return monthlyUsersTrend;
    }

    public void setMonthlyUsersTrend(List<NamedValue> monthlyUsersTrend) {
        this.monthlyUsersTrend = monthlyUsersTrend;
    }

    public List<NamedValue> getDurationBreakdown() {
        return durationBreakdown;
    }

    public void setDurationBreakdown(List<NamedValue> durationBreakdown) {
        this.durationBreakdown = durationBreakdown;
    }

    public List<NamedValue> getMonthlyTransactionsTrend() {
        return monthlyTransactionsTrend;
    }

    public void setMonthlyTransactionsTrend(List<NamedValue> monthlyTransactionsTrend) {
        this.monthlyTransactionsTrend = monthlyTransactionsTrend;
    }

    public List<DataCheckpoint> getDataCheckpoint() {
        return dataCheckpoint;
    }

    public void setDataCheckpoint(List<DataCheckpoint> dataCheckpoint) {
        this.dataCheckpoint = dataCheckpoint;
    }

    public static class MetricCard {
        private String title;
        private String value;
        private double change;

        public MetricCard() {
        }

        public MetricCard(String title, String value, double change) {
            this.title = title;
            this.value = value;
            this.change = change;
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
    }

    public static class NamedCount {
        private String name;
        private long count;

        public NamedCount() {
        }

        public NamedCount(String name, long count) {
            this.name = name;
            this.count = count;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public long getCount() {
            return count;
        }

        public void setCount(long count) {
            this.count = count;
        }
    }

    public static class NamedValue {
        private String name;
        private double value;

        public NamedValue() {
        }

        public NamedValue(String name, double value) {
            this.name = name;
            this.value = value;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public double getValue() {
            return value;
        }

        public void setValue(double value) {
            this.value = value;
        }
    }

    public static class DataCheckpoint {
        private String label;
        private long value;
        private String source;

        public DataCheckpoint() {
        }

        public DataCheckpoint(String label, long value, String source) {
            this.label = label;
            this.value = value;
            this.source = source;
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

        public String getSource() {
            return source;
        }

        public void setSource(String source) {
            this.source = source;
        }
    }

    public static class LocationRow {
        private String city;
        private long campaigns;
        private long activeCampaigns;
        private double averageRadiusKm;
        private String status;
        private Double latitude;
        private Double longitude;
        private long admins;
        private long users;
        private long adTypes;

        public String getCity() {
            return city;
        }

        public void setCity(String city) {
            this.city = city;
        }

        public long getCampaigns() {
            return campaigns;
        }

        public void setCampaigns(long campaigns) {
            this.campaigns = campaigns;
        }

        public long getActiveCampaigns() {
            return activeCampaigns;
        }

        public void setActiveCampaigns(long activeCampaigns) {
            this.activeCampaigns = activeCampaigns;
        }

        public double getAverageRadiusKm() {
            return averageRadiusKm;
        }

        public void setAverageRadiusKm(double averageRadiusKm) {
            this.averageRadiusKm = averageRadiusKm;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

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

        public long getAdmins() {
            return admins;
        }

        public void setAdmins(long admins) {
            this.admins = admins;
        }

        public long getUsers() {
            return users;
        }

        public void setUsers(long users) {
            this.users = users;
        }

        public long getAdTypes() {
            return adTypes;
        }

        public void setAdTypes(long adTypes) {
            this.adTypes = adTypes;
        }
    }

    public static class CreatorRow {
        private String name;
        private long campaigns;
        private long activeCampaigns;
        private long targetedLocations;
        private int rank;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public long getCampaigns() {
            return campaigns;
        }

        public void setCampaigns(long campaigns) {
            this.campaigns = campaigns;
        }

        public long getActiveCampaigns() {
            return activeCampaigns;
        }

        public void setActiveCampaigns(long activeCampaigns) {
            this.activeCampaigns = activeCampaigns;
        }

        public long getTargetedLocations() {
            return targetedLocations;
        }

        public void setTargetedLocations(long targetedLocations) {
            this.targetedLocations = targetedLocations;
        }

        public int getRank() {
            return rank;
        }

        public void setRank(int rank) {
            this.rank = rank;
        }
    }

    public static class PublisherRow {
        private String name;
        private String location;
        private long campaignsNearby;
        private long activeCampaignsNearby;
        private String status;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getLocation() {
            return location;
        }

        public void setLocation(String location) {
            this.location = location;
        }

        public long getCampaignsNearby() {
            return campaignsNearby;
        }

        public void setCampaignsNearby(long campaignsNearby) {
            this.campaignsNearby = campaignsNearby;
        }

        public long getActiveCampaignsNearby() {
            return activeCampaignsNearby;
        }

        public void setActiveCampaignsNearby(long activeCampaignsNearby) {
            this.activeCampaignsNearby = activeCampaignsNearby;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }
    }
}
