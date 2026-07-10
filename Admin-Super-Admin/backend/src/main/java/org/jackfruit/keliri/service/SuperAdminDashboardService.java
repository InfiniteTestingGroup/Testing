package org.jackfruit.keliri.service;

import java.time.Instant;
import java.time.YearMonth;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.SuperAdminDashboardResponse;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.model.advertisements;
import org.jackfruit.keliri.model.dateRange;
import org.jackfruit.keliri.model.location;
import org.jackfruit.keliri.model.users;
import org.jackfruit.keliri.repository.ad_campaignsRepository;
import org.jackfruit.keliri.repository.advertisementsRepository;
import org.jackfruit.keliri.repository.usersRepository;
import org.springframework.stereotype.Service;

@Service
public class SuperAdminDashboardService {
    private static final ZoneId ZONE_ID = ZoneId.systemDefault();
    private static final DateTimeFormatter MONTH_LABEL = DateTimeFormatter.ofPattern("MMM", Locale.ENGLISH);

    private final ad_campaignsRepository campaignsRepository;
    private final advertisementsRepository advertisementsRepository;
    private final usersRepository usersRepository;

    public SuperAdminDashboardService(
            ad_campaignsRepository campaignsRepository,
            advertisementsRepository advertisementsRepository,
            usersRepository usersRepository) {
        this.campaignsRepository = campaignsRepository;
        this.advertisementsRepository = advertisementsRepository;
        this.usersRepository = usersRepository;
    }

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(SuperAdminDashboardService.class);

    public SuperAdminDashboardResponse getDashboard() {
        log.info("Count API Start - SuperAdminDashboardService.getDashboard");
        long startTime = System.currentTimeMillis();

        try {
            java.util.concurrent.CompletableFuture<SuperAdminDashboardResponse> future = java.util.concurrent.CompletableFuture.supplyAsync(() -> {
                List<ad_campaigns> campaigns = campaignsRepository.findAll();
                List<users> publishers = usersRepository.findAll();
                long totalUsers = usersRepository.count();

                Map<String, advertisements> adsById = loadAdvertisements(campaigns);
                Map<String, users> usersById = loadUsers(campaigns);

                List<ad_campaigns> activeCampaigns = campaigns.stream()
                        .filter(this::isActiveCampaign)
                        .toList();

                List<ad_campaigns> geoCampaigns = campaigns.stream()
                        .filter(this::hasTargetLocation)
                        .toList();

                SuperAdminDashboardResponse response = new SuperAdminDashboardResponse();
                response.setSummary(buildSummary(campaigns, activeCampaigns, geoCampaigns, adsById.size(), publishers.size(), totalUsers));
                response.setKpis(buildKpis(campaigns, activeCampaigns, geoCampaigns, adsById.size(), publishers.size(), totalUsers));
                response.setPublishingTrend(buildPublishingTrend(campaigns));
                response.setTopCreators(buildTopCreators(campaigns, usersById));
                response.setRecentActivities(buildRecentActivities(campaigns, adsById));
                response.setAdTypeBreakdown(buildAdTypeBreakdown(activeCampaigns, adsById));
                response.setLocationBreakdown(buildLocationBreakdown(activeCampaigns));
                return response;
            });

            SuperAdminDashboardResponse response = future.get(8, java.util.concurrent.TimeUnit.SECONDS);
            long duration = System.currentTimeMillis() - startTime;
            log.info("Count API Done - execution duration: {} ms", duration);
            return response;

        } catch (java.util.concurrent.TimeoutException e) {
            long duration = System.currentTimeMillis() - startTime;
            log.error("Count API Timeout - execution duration exceeded 8 seconds (took {} ms)", duration);
            throw new org.springframework.web.server.ResponseStatusException(
                    org.springframework.http.HttpStatus.GATEWAY_TIMEOUT, "Dashboard count aggregation timed out");
        } catch (Exception e) {
            long duration = System.currentTimeMillis() - startTime;
            log.error("Count API Error - execution failed after {} ms", duration, e);
            throw new org.springframework.web.server.ResponseStatusException(
                    org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR, "Dashboard count aggregation failed");
        }
    }

    private SuperAdminDashboardResponse.DashboardSummary buildSummary(
            List<ad_campaigns> campaigns,
            List<ad_campaigns> activeCampaigns,
            List<ad_campaigns> geoCampaigns,
            int totalAds,
            int totalPublishers,
            long totalUsers) {
        SuperAdminDashboardResponse.DashboardSummary summary = new SuperAdminDashboardResponse.DashboardSummary();
        summary.setTotalAds(totalAds);
        summary.setTotalCampaigns(campaigns.size());
        summary.setActiveCampaigns(activeCampaigns.size());
        summary.setTotalPublishers(totalPublishers);
        summary.setTotalUsers(totalUsers);
        summary.setGeoTargetedCampaigns(geoCampaigns.size());
        summary.setUniqueTargetLocations(countUniqueLocations(geoCampaigns));
        summary.setAverageTargetRadiusKm(roundToTwoDecimals(averageRadiusKm(geoCampaigns)));
        return summary;
    }

    private List<SuperAdminDashboardResponse.KpiMetric> buildKpis(
            List<ad_campaigns> campaigns,
            List<ad_campaigns> activeCampaigns,
            List<ad_campaigns> geoCampaigns,
            int totalAds,
            int totalPublishers,
            long totalUsers) {
        long uniqueLocations = countUniqueLocations(geoCampaigns);
        double averageRadiusKm = roundToTwoDecimals(averageRadiusKm(geoCampaigns));

        return List.of(
                createKpi("ads", "Total Ads", totalAds, growthForCurrentMonth(loadAdvertisementsCreatedAt(campaigns)), "all published creatives"),
                createKpi("campaigns", "Total Campaigns", campaigns.size(), growthForCurrentMonth(campaigns, null), "all campaign records"),
                createKpi("activeCampaigns", "Active Campaigns", activeCampaigns.size(), growthForCurrentMonth(campaigns, this::isActiveCampaign), "currently targeting users"),
                createKpi("publishers", "Total Publishers", totalPublishers, growthForCurrentMonthUsers(usersRepository.findAll()), "accounts that can publish"),
                createKpi("geoTargeted", "Geo-Targeted", geoCampaigns.size(), growthForCurrentMonth(campaigns, this::hasTargetLocation), "campaigns with map targeting"),
                createKpi("locations", "Target Locations", uniqueLocations, locationGrowthForCurrentMonth(campaigns), "unique places targeted"),
                createKpi("users", "Total Users", totalUsers, growthForCurrentMonthAllUsers(), "registered accounts"),
                createTextKpi("avgRadius", "Avg Radius", String.format(Locale.ENGLISH, "%.2f", averageRadiusKm), radiusGrowthForCurrentMonth(campaigns), "km around selected location")
        );
    }

    private SuperAdminDashboardResponse.KpiMetric createKpi(String id, String title, long value, double change, String label) {
        return createTextKpi(id, title, Long.toString(value), change, label);
    }

    private SuperAdminDashboardResponse.KpiMetric createTextKpi(String id, String title, String value, double change, String label) {
        SuperAdminDashboardResponse.KpiMetric metric = new SuperAdminDashboardResponse.KpiMetric();
        metric.setId(id);
        metric.setTitle(title);
        metric.setValue(value);
        metric.setChange(change);
        metric.setChangeLabel(label);
        metric.setPrefix("");
        return metric;
    }

    private List<SuperAdminDashboardResponse.TrendPoint> buildPublishingTrend(List<ad_campaigns> campaigns) {
        YearMonth currentMonth = YearMonth.now(ZONE_ID);
        Map<YearMonth, Long> counts = new LinkedHashMap<>();
        for (int offset = 5; offset >= 0; offset--) {
            counts.put(currentMonth.minusMonths(offset), 0L);
        }

        for (ad_campaigns campaign : campaigns) {
            Instant createdAt = resolveCampaignTimestamp(campaign);
            YearMonth month = YearMonth.from(createdAt.atZone(ZONE_ID));
            if (counts.containsKey(month)) {
                counts.put(month, counts.get(month) + 1);
            }
        }

        List<SuperAdminDashboardResponse.TrendPoint> points = new ArrayList<>();
        for (Map.Entry<YearMonth, Long> entry : counts.entrySet()) {
            points.add(new SuperAdminDashboardResponse.TrendPoint(entry.getKey().format(MONTH_LABEL), entry.getValue()));
        }
        return points;
    }

    private List<SuperAdminDashboardResponse.TopCreator> buildTopCreators(List<ad_campaigns> campaigns, Map<String, users> usersById) {
        Map<String, List<ad_campaigns>> grouped = campaigns.stream()
                .filter(campaign -> campaign.getCreatedBy() != null && !campaign.getCreatedBy().isBlank())
                .collect(Collectors.groupingBy(ad_campaigns::getCreatedBy));

        List<SuperAdminDashboardResponse.TopCreator> creators = new ArrayList<>();
        for (Map.Entry<String, List<ad_campaigns>> entry : grouped.entrySet()) {
            String creatorId = entry.getKey();
            List<ad_campaigns> creatorCampaigns = entry.getValue();
            users user = usersById.get(creatorId);

            SuperAdminDashboardResponse.TopCreator creator = new SuperAdminDashboardResponse.TopCreator();
            creator.setName(user != null && user.getFullName() != null ? user.getFullName() : "Creator " + shortId(creatorId));
            creator.setEmail(user != null && user.getEmailAddress() != null ? user.getEmailAddress() : "Not available");
            creator.setCampaignCount(creatorCampaigns.size());
            creator.setActiveCampaignCount(creatorCampaigns.stream().filter(this::isActiveCampaign).count());
            creator.setLocationCount(countUniqueLocations(creatorCampaigns.stream().filter(this::hasTargetLocation).toList()));
            creator.setChange(growthForCurrentMonth(creatorCampaigns, null));
            creators.add(creator);
        }

        creators.sort(Comparator.comparingLong(SuperAdminDashboardResponse.TopCreator::getCampaignCount).reversed());
        for (int i = 0; i < creators.size(); i++) {
            creators.get(i).setRank(i + 1);
        }
        return creators.stream().limit(5).toList();
    }

    private List<SuperAdminDashboardResponse.RecentActivity> buildRecentActivities(
            List<ad_campaigns> campaigns,
            Map<String, advertisements> adsById) {
        return campaigns.stream()
                .sorted(Comparator.comparing(this::resolveCampaignTimestamp).reversed())
                .limit(5)
                .map(campaign -> {
                    advertisements ad = adsById.get(campaign.getAdvertisementId());
                    String title = ad != null && ad.getTitle() != null ? ad.getTitle() : "Untitled campaign";
                    String locationName = resolveLocationLabel(campaign.getLocation());

                    SuperAdminDashboardResponse.RecentActivity activity = new SuperAdminDashboardResponse.RecentActivity();
                    activity.setId(campaign.getId());
                    activity.setStatus(normalizeStatus(campaign.getCompaignsStatus()));
                    activity.setLocationName(locationName);
                    activity.setOccurredAt(resolveCampaignTimestamp(campaign).toString());
                    activity.setAction(buildActivityText(title, locationName, activity.getStatus()));
                    return activity;
                })
                .toList();
    }

    private List<SuperAdminDashboardResponse.BreakdownItem> buildAdTypeBreakdown(
            List<ad_campaigns> activeCampaigns,
            Map<String, advertisements> adsById) {
        Map<String, Long> counts = new HashMap<>();
        for (ad_campaigns campaign : activeCampaigns) {
            advertisements ad = adsById.get(campaign.getAdvertisementId());
            String adType = ad != null && ad.getAdType() != null && !ad.getAdType().isBlank()
                    ? ad.getAdType()
                    : "Unknown";
            counts.merge(adType, 1L, Long::sum);
        }
        return toBreakdown(counts, activeCampaigns.size(), 4);
    }

    private List<SuperAdminDashboardResponse.BreakdownItem> buildLocationBreakdown(List<ad_campaigns> activeCampaigns) {
        Map<String, Long> counts = new HashMap<>();
        for (ad_campaigns campaign : activeCampaigns) {
            if (!hasTargetLocation(campaign)) {
                continue;
            }
            String label = resolveLocationLabel(campaign.getLocation());
            counts.merge(label, 1L, Long::sum);
        }
        return toBreakdown(counts, activeCampaigns.size(), 5);
    }

    private List<SuperAdminDashboardResponse.BreakdownItem> toBreakdown(Map<String, Long> counts, int total, int limit) {
        if (counts.isEmpty() || total == 0) {
            return Collections.emptyList();
        }

        return counts.entrySet().stream()
                .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                .limit(limit)
                .map(entry -> new SuperAdminDashboardResponse.BreakdownItem(
                        entry.getKey(),
                        entry.getValue(),
                        Math.round((entry.getValue() * 100f) / total)))
                .toList();
    }

    private Map<String, advertisements> loadAdvertisements(List<ad_campaigns> campaigns) {
        List<String> adIds = campaigns.stream()
                .map(ad_campaigns::getAdvertisementId)
                .filter(Objects::nonNull)
                .distinct()
                .toList();

        if (adIds.isEmpty()) {
            return Collections.emptyMap();
        }

        return advertisementsRepository.findDashboardAdsByIds(adIds).stream()
                .collect(Collectors.toMap(advertisements::getId, ad -> ad));
    }

    private Map<String, users> loadUsers(List<ad_campaigns> campaigns) {
        List<String> creatorIds = campaigns.stream()
                .map(ad_campaigns::getCreatedBy)
                .filter(Objects::nonNull)
                .filter(id -> !id.isBlank())
                .distinct()
                .toList();

        if (creatorIds.isEmpty()) {
            return Collections.emptyMap();
        }

        return usersRepository.findDashboardUsersByIds(creatorIds).stream()
                .collect(Collectors.toMap(users::getId, user -> user));
    }

    private List<Instant> loadAdvertisementsCreatedAt(List<ad_campaigns> campaigns) {
        return campaigns.stream()
                .map(ad_campaigns::getAdvertisementId)
                .filter(Objects::nonNull)
                .distinct()
                .map(this::parseObjectIdInstant)
                .filter(Objects::nonNull)
                .toList();
    }

    private boolean isActiveCampaign(ad_campaigns campaign) {
        return "ACTIVE".equalsIgnoreCase(normalizeStatus(campaign.getCompaignsStatus()));
    }

    private boolean hasTargetLocation(ad_campaigns campaign) {
        location location = campaign.getLocation();
        return location != null
                && ((location.getLat() != null && !location.getLat().isBlank() && location.getLng() != null && !location.getLng().isBlank())
                || (location.getLocationName() != null && !location.getLocationName().isBlank()));
    }

    private String normalizeStatus(String status) {
        return status == null || status.isBlank() ? "UNKNOWN" : status.trim().toUpperCase(Locale.ENGLISH);
    }

    private long countUniqueLocations(Collection<ad_campaigns> campaigns) {
        Set<String> unique = new HashSet<>();
        for (ad_campaigns campaign : campaigns) {
            if (hasTargetLocation(campaign)) {
                unique.add(resolveLocationKey(campaign.getLocation()));
            }
        }
        return unique.size();
    }

    private double averageRadiusKm(Collection<ad_campaigns> campaigns) {
        double totalRangeKm = 0;
        long count = 0;
        for (ad_campaigns campaign : campaigns) {
            location location = campaign.getLocation();
            if (location == null || location.getRange() <= 0) {
                continue;
            }
            totalRangeKm += location.getRange() / 1000.0;
            count++;
        }
        return count == 0 ? 0 : totalRangeKm / count;
    }

    private double growthForCurrentMonth(Collection<Instant> instants) {
        YearMonth currentMonth = YearMonth.now(ZONE_ID);
        YearMonth previousMonth = currentMonth.minusMonths(1);
        long currentCount = instants.stream()
                .filter(Objects::nonNull)
                .filter(instant -> YearMonth.from(instant.atZone(ZONE_ID)).equals(currentMonth))
                .count();
        long previousCount = instants.stream()
                .filter(Objects::nonNull)
                .filter(instant -> YearMonth.from(instant.atZone(ZONE_ID)).equals(previousMonth))
                .count();
        return computeGrowth(currentCount, previousCount);
    }

    private double growthForCurrentMonth(Collection<ad_campaigns> campaigns, java.util.function.Predicate<ad_campaigns> predicate) {
        List<Instant> instants = campaigns.stream()
                .filter(campaign -> predicate == null || predicate.test(campaign))
                .map(this::resolveCampaignTimestamp)
                .toList();
        return growthForCurrentMonth(instants);
    }

    private double growthForCurrentMonthUsers(Collection<users> users) {
        List<Instant> instants = users.stream()
                .map(user -> user.getId())
                .map(this::parseObjectIdInstant)
                .filter(Objects::nonNull)
                .toList();
        return growthForCurrentMonth(instants);
    }

    private double growthForCurrentMonthAllUsers() {
        List<Instant> instants = usersRepository.findAll().stream()
                .map(user -> user.getId())
                .map(this::parseObjectIdInstant)
                .filter(Objects::nonNull)
                .toList();
        return growthForCurrentMonth(instants);
    }

    private double locationGrowthForCurrentMonth(List<ad_campaigns> campaigns) {
        YearMonth currentMonth = YearMonth.now(ZONE_ID);
        YearMonth previousMonth = currentMonth.minusMonths(1);

        long currentCount = countUniqueLocationsForMonth(campaigns, currentMonth);
        long previousCount = countUniqueLocationsForMonth(campaigns, previousMonth);
        return computeGrowth(currentCount, previousCount);
    }

    private long countUniqueLocationsForMonth(List<ad_campaigns> campaigns, YearMonth month) {
        Set<String> locations = new HashSet<>();
        for (ad_campaigns campaign : campaigns) {
            if (!hasTargetLocation(campaign)) {
                continue;
            }
            Instant createdAt = resolveCampaignTimestamp(campaign);
            if (YearMonth.from(createdAt.atZone(ZONE_ID)).equals(month)) {
                locations.add(resolveLocationKey(campaign.getLocation()));
            }
        }
        return locations.size();
    }

    private double radiusGrowthForCurrentMonth(List<ad_campaigns> campaigns) {
        YearMonth currentMonth = YearMonth.now(ZONE_ID);
        YearMonth previousMonth = currentMonth.minusMonths(1);
        double current = averageRadiusKm(campaignsForMonth(campaigns, currentMonth));
        double previous = averageRadiusKm(campaignsForMonth(campaigns, previousMonth));
        return computeGrowth(current, previous);
    }

    private List<ad_campaigns> campaignsForMonth(List<ad_campaigns> campaigns, YearMonth month) {
        return campaigns.stream()
                .filter(this::hasTargetLocation)
                .filter(campaign -> YearMonth.from(resolveCampaignTimestamp(campaign).atZone(ZONE_ID)).equals(month))
                .toList();
    }

    private double computeGrowth(double current, double previous) {
        if (previous == 0) {
            return current > 0 ? 100.0 : 0.0;
        }
        return roundToTwoDecimals(((current - previous) / previous) * 100.0);
    }

    private Instant resolveCampaignTimestamp(ad_campaigns campaign) {
        dateRange range = campaign.getDateRange();
        if (range != null && range.getFromDate() != null) {
            return range.getFromDate().toInstant();
        }

        Instant objectIdInstant = parseObjectIdInstant(campaign.getId());
        if (objectIdInstant != null) {
            return objectIdInstant;
        }

        return Instant.now().minus(365, ChronoUnit.DAYS);
    }

    private Instant parseObjectIdInstant(String id) {
        if (id == null || id.isBlank()) {
            return null;
        }
        try {
            return new ObjectId(id).getDate().toInstant();
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }

    private String resolveLocationLabel(location location) {
        if (location == null) {
            return "Unspecified";
        }
        if (location.getLocationName() != null && !location.getLocationName().isBlank()) {
            return location.getLocationName().trim();
        }
        if (location.getLat() != null && location.getLng() != null
                && !location.getLat().isBlank() && !location.getLng().isBlank()) {
            return location.getLat() + ", " + location.getLng();
        }
        return "Unspecified";
    }

    private String resolveLocationKey(location location) {
        return resolveLocationLabel(location).toLowerCase(Locale.ENGLISH);
    }

    private String buildActivityText(String title, String locationName, String status) {
        if ("ACTIVE".equals(status)) {
            return "Campaign \"" + title + "\" is targeting " + locationName;
        }
        if ("COMPLETED".equals(status)) {
            return "Campaign \"" + title + "\" completed for " + locationName;
        }
        return "Campaign \"" + title + "\" updated with status " + status;
    }

    private String shortId(String id) {
        return id.length() <= 6 ? id : id.substring(id.length() - 6);
    }

    private double roundToTwoDecimals(double value) {
        return Math.round(value * 100.0) / 100.0;
    }
}
