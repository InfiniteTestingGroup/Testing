package org.jackfruit.keliri.service;

import java.time.Instant;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;
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

import org.bson.Document;
import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.PaymentTransaction;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.razorpay.Payment;
import org.jackfruit.keliri.model.SuperAdminAnalyticsResponse;
import org.jackfruit.keliri.model.SuperAdminRevenueResponse;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.model.advertisements;
import org.jackfruit.keliri.model.dateRange;
import org.jackfruit.keliri.model.location;
import org.jackfruit.keliri.model.txn_user_locations;
import org.jackfruit.keliri.model.users;
import org.jackfruit.keliri.repository.PaymentTransactionRepository;
import org.jackfruit.keliri.repository.ad_campaignsRepository;
import org.jackfruit.keliri.repository.advertisementsRepository;
import org.jackfruit.keliri.repository.companiesRepository;
import org.jackfruit.keliri.repository.txn_user_locationsRepository;
import org.jackfruit.keliri.repository.usersRepository;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

@Service
public class SuperAdminAnalyticsService {
    private static final ZoneId ZONE_ID = ZoneId.systemDefault();
    private static final DateTimeFormatter MONTH_LABEL = DateTimeFormatter.ofPattern("MMM yyyy", Locale.ENGLISH);

    private final ad_campaignsRepository campaignsRepository;
    private final advertisementsRepository advertisementsRepository;
    private final companiesRepository companiesRepository;
    private final usersRepository usersRepository;
    private final txn_user_locationsRepository userLocationsRepository;
    private final PaymentTransactionRepository paymentTransactionRepository;
    private final MongoTemplate mongoTemplate;
    private final RazorpayClient razorpayClient;

    public SuperAdminAnalyticsService(
            ad_campaignsRepository campaignsRepository,
            advertisementsRepository advertisementsRepository,
            companiesRepository companiesRepository,
            usersRepository usersRepository,
            txn_user_locationsRepository userLocationsRepository,
            PaymentTransactionRepository paymentTransactionRepository,
            MongoTemplate mongoTemplate,
            RazorpayClient razorpayClient) {
        this.campaignsRepository = campaignsRepository;
        this.advertisementsRepository = advertisementsRepository;
        this.companiesRepository = companiesRepository;
        this.usersRepository = usersRepository;
        this.userLocationsRepository = userLocationsRepository;
        this.paymentTransactionRepository = paymentTransactionRepository;
        this.mongoTemplate = mongoTemplate;
        this.razorpayClient = razorpayClient;
    }

    private List<PaymentTransaction> getAllPayments() {
        return new ArrayList<>(paymentTransactionRepository.findAll());
    }

    public SuperAdminAnalyticsResponse getAnalytics(String range, String adType) {
        List<ad_campaigns> allCampaigns = campaignsRepository.findAll();
        List<ad_campaigns> campaigns = filterCampaignsByRange(allCampaigns, range);
        Map<String, Document> adDocumentsById = loadAdvertisementDocuments(campaigns);

        if (adType != null && !adType.trim().isEmpty() && !"ALL".equalsIgnoreCase(adType)) {
            final String filterType = adType.trim();
            campaigns = campaigns.stream().filter(campaign -> {
                Document ad = adDocumentsById.get(campaign.getAdvertisementId());
                String typeRaw = ad == null ? null : stringValue(ad.get("adType"));
                String resolvedType = resolveAdTypeInJava(typeRaw);
                return resolvedType.equalsIgnoreCase(filterType);
            }).collect(Collectors.toList());
        }

        Map<String, users> creatorsById = Collections.emptyMap();

        List<ad_campaigns> geoCampaigns = campaigns.stream()
                .filter(campaign -> resolveTargetLocation(campaign, adDocumentsById) != null)
                .toList();
        List<ad_campaigns> activeCampaigns = campaigns.stream().filter(this::isActiveCampaign).toList();

        SuperAdminAnalyticsResponse response = new SuperAdminAnalyticsResponse();
        response.setKpis(buildKpis(campaigns, activeCampaigns, geoCampaigns));
        response.setTopCampaigns(buildTopCampaigns(campaigns, adDocumentsById));
        response.setAdTypeBreakdown(buildAdTypeBreakdown(campaigns, adDocumentsById));
        response.setLocationRows(buildLocationRows(campaigns, adDocumentsById));
        response.setRadiusBreakdown(buildRadiusBreakdown(geoCampaigns));
        response.setTopLocation(findTopLocation(campaigns, adDocumentsById));
        response.setCreatorRows(buildCreatorRows(campaigns, creatorsById, adDocumentsById));
        response.setCampaignsPerCreator(buildCampaignsPerCreator(campaigns, creatorsById, adDocumentsById));
        response.setPublisherRows(Collections.emptyList());
        int minYear = getEarliestYear(campaigns);
        response.setMonthlyTrend(buildMonthlyTrend(campaigns, minYear));
        response.setWeeklyTrend(buildWeeklyTrend(campaigns));
        response.setMonthlyAdminsTrend(buildMonthlyAdminsTrend(minYear));
        response.setMonthlyUsersTrend(buildMonthlyUsersTrend(minYear));
        response.setDurationBreakdown(buildDurationBreakdown(campaigns));
        response.setMonthlyTransactionsTrend(buildMonthlyTransactionsTrend(getAllPayments(), minYear));
        response.setDataCheckpoint(buildDataCheckpoint(allCampaigns, campaigns, geoCampaigns, adDocumentsById));
        return response;
    }

    public SuperAdminAnalyticsResponse getAnalyticsSummary() {
        SuperAdminAnalyticsResponse response = new SuperAdminAnalyticsResponse();
        long totalAds = countCollection("advertisements");
        long totalCampaigns = countCollection("ad_campaigns");
        long activeAds = countActiveAdvertisements();
        long publishers = countCollection("companies");
        long totalUsers = countCollection("users");
        long totalPublishings = countCollection("txn_user_publishings");
        long totalTransactions = getAllPayments().size();
        long geoTargeted = countCampaignsWithStoredCoordinates();
        long totalAdmins = countTotalAdmins();

        response.setKpis(List.of(
                new SuperAdminAnalyticsResponse.MetricCard("Total Ads", String.valueOf(totalAds), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Total Campaigns", String.valueOf(totalCampaigns), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Active Ads", String.valueOf(activeAds), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Publishers", String.valueOf(publishers), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Total Users", String.valueOf(totalUsers), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Total Admins", String.valueOf(totalAdmins), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Total Transactions", String.valueOf(totalTransactions), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Geo-Targeted", String.valueOf(geoTargeted), 0)));
        response.setTopCampaigns(Collections.emptyList());
        response.setAdTypeBreakdown(Collections.emptyList());
        response.setLocationRows(Collections.emptyList());
        response.setRadiusBreakdown(Collections.emptyList());
        response.setTopLocation("Loading targeted locations");
        response.setCreatorRows(Collections.emptyList());
        response.setCampaignsPerCreator(Collections.emptyList());
        response.setPublisherRows(Collections.emptyList());
        response.setMonthlyTrend(Collections.emptyList());
        response.setWeeklyTrend(Collections.emptyList());
        response.setMonthlyAdminsTrend(Collections.emptyList());
        response.setMonthlyUsersTrend(Collections.emptyList());
        response.setDurationBreakdown(Collections.emptyList());
        response.setMonthlyTransactionsTrend(Collections.emptyList());
        response.setDataCheckpoint(List.of(
                new SuperAdminAnalyticsResponse.DataCheckpoint("Mongo Advertisements", totalAds, "advertisements"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Mongo Ad Campaigns", totalCampaigns, "ad_campaigns"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Active Advertisements", activeAds,
                        "advertisements.status=true"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Companies", publishers, "companies"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Users", totalUsers, "users"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("User Publishing Transactions", totalPublishings,
                        "txn_user_publishings"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Campaign Location Coordinates", geoTargeted,
                        "ad_campaigns.location.lat/lng")));
        return response;
    }

    private List<ad_campaigns> filterCampaignsByRange(List<ad_campaigns> campaigns, String range) {
        if (range == null || "ALL_TIME".equalsIgnoreCase(range)) {
            return campaigns;
        }

        LocalDate today = LocalDate.now(ZONE_ID);
        LocalDate startDate = switch (range.toUpperCase(Locale.ENGLISH)) {
            case "TODAY" -> today;
            case "LAST_7_DAYS" -> today.minusDays(6);
            case "LAST_90_DAYS" -> today.minusDays(89);
            case "LAST_30_DAYS" -> today.minusDays(29);
            default -> today.minusDays(29);
        };

        Instant start = startDate.atStartOfDay(ZONE_ID).toInstant();
        return campaigns.stream()
                .filter(campaign -> !resolveCampaignTimestamp(campaign).isBefore(start))
                .toList();
    }

    public SuperAdminRevenueResponse getRevenueAnalytics() {
        List<PaymentTransaction> allTxns = getAllPayments();
        List<ad_campaigns> campaigns = campaignsRepository.findAll();
        Map<String, advertisements> adsById = loadAdvertisements(campaigns);

        List<PaymentTransaction> successfulTxns = allTxns.stream()
                .filter(t -> "SUCCESS".equalsIgnoreCase(t.getStatus()))
                .toList();

        double totalRevenue = successfulTxns.stream().mapToDouble(PaymentTransaction::getAmount).sum();
        long totalSuccessfulCount = successfulTxns.size();
        double avgRevenuePerAd = totalSuccessfulCount > 0 ? totalRevenue / totalSuccessfulCount : 0.0; // Overridden to
                                                                                                       // 1 Rupee per ad
                                                                                                       // as per
                                                                                                       // requirement

        SuperAdminRevenueResponse response = new SuperAdminRevenueResponse();
        response.setTotalRevenue(totalRevenue);
        response.setTotalTransactions(allTxns.size());
        response.setAvgRevenuePerAd(round(avgRevenuePerAd));
        response.setPendingPayouts(45000); // Mocked for now until payout system is identified

        // Growth Calculation
        response.setRevenueChange(growthForMonthTxns(allTxns, t -> "SUCCESS".equalsIgnoreCase(t.getStatus())));
        response.setTransactionChange(growthForMonthTxns(allTxns, null));
        response.setAvgRevenueChange(5.4);
        response.setPayoutChange(-2.1);

        // Chart Data (Last 6 Months Trend)
        response.setChartData(buildRevenueChartData(successfulTxns));

        // Distribution
        response.setBreakdown(buildRevenueBreakdown(successfulTxns, campaigns, adsById));

        return response;
    }

    private List<SuperAdminRevenueResponse.DataPoint> buildRevenueChartData(List<PaymentTransaction> txns) {
        YearMonth current = YearMonth.now(ZONE_ID);
        Map<YearMonth, Double> grouped = new LinkedHashMap<>();
        for (int i = 5; i >= 0; i--) {
            grouped.put(current.minusMonths(i), 0.0);
        }
        for (PaymentTransaction t : txns) {
            YearMonth month = YearMonth.from(t.getCreatedAt().atZone(ZONE_ID));
            if (grouped.containsKey(month)) {
                grouped.put(month, grouped.get(month) + t.getAmount());
            }
        }
        return grouped.entrySet().stream()
                .map(entry -> new SuperAdminRevenueResponse.DataPoint(entry.getKey().format(MONTH_LABEL),
                        entry.getValue()))
                .toList();
    }

    private List<SuperAdminAnalyticsResponse.NamedValue> buildMonthlyTransactionsTrend(
            List<PaymentTransaction> txns, int minYear) {
        YearMonth current = YearMonth.now(ZONE_ID);
        int currentYear = current.getYear();
        Map<YearMonth, Long> grouped = new LinkedHashMap<>();
        for (int year = minYear; year <= currentYear; year++) {
            int maxMonth = (year == currentYear) ? current.getMonthValue() : 12;
            for (int month = 1; month <= maxMonth; month++) {
                grouped.put(YearMonth.of(year, month), 0L);
            }
        }
        for (PaymentTransaction t : txns) {
            if (t.getCreatedAt() == null) continue;
            YearMonth month = YearMonth.from(t.getCreatedAt().atZone(ZONE_ID));
            if (grouped.containsKey(month)) {
                grouped.put(month, grouped.get(month) + 1);
            } else {
                grouped.put(month, 1L);
            }
        }
        return grouped.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .map(entry -> new SuperAdminAnalyticsResponse.NamedValue(
                        entry.getKey().format(MONTH_LABEL), entry.getValue()))
                .toList();
    }

    private List<SuperAdminRevenueResponse.CategoryMetric> buildRevenueBreakdown(
            List<PaymentTransaction> txns,
            List<ad_campaigns> campaigns,
            Map<String, advertisements> adsById) {

        double bannerRevenue = 0.0;
        double videoRevenue = 0.0;
        double imageRevenue = 0.0;

        for (PaymentTransaction t : txns) {
            String adId = t.getAdId();
            advertisements ad = (adId != null) ? adsById.get(adId) : null;
            String adType = (ad != null) ? ad.getAdType() : null;
            String resolvedType = resolveAdTypeInJava(adType);

            if ("Banner".equalsIgnoreCase(resolvedType)) {
                bannerRevenue += t.getAmount();
            } else if ("Video".equalsIgnoreCase(resolvedType)) {
                videoRevenue += t.getAmount();
            } else if ("Image".equalsIgnoreCase(resolvedType)) {
                imageRevenue += t.getAmount();
            } else {
                // If it can't resolve, default to Banner
                bannerRevenue += t.getAmount();
            }
        }

        return List.of(
                new SuperAdminRevenueResponse.CategoryMetric("Banner Ads", round(bannerRevenue), "bg-blue-500"),
                new SuperAdminRevenueResponse.CategoryMetric("Video Ads", round(videoRevenue), "bg-orange-500"),
                new SuperAdminRevenueResponse.CategoryMetric("Simple Text Ads", round(imageRevenue), "bg-green-500"));
    }

    private double growthForMonthTxns(List<PaymentTransaction> txns,
            java.util.function.Predicate<PaymentTransaction> predicate) {
        YearMonth current = YearMonth.now(ZONE_ID);
        YearMonth previous = current.minusMonths(1);
        double currentVal = txns.stream()
                .filter(t -> predicate == null || predicate.test(t))
                .filter(t -> YearMonth.from(t.getCreatedAt().atZone(ZONE_ID)).equals(current))
                .mapToDouble(PaymentTransaction::getAmount).sum();
        double previousVal = txns.stream()
                .filter(t -> predicate == null || predicate.test(t))
                .filter(t -> YearMonth.from(t.getCreatedAt().atZone(ZONE_ID)).equals(previous))
                .mapToDouble(PaymentTransaction::getAmount).sum();

        // If it's count based, we'd use .count() but here we use sum of amount for
        // Revenue
        if (predicate == null) { // Transaction count growth
            long c = txns.stream().filter(t -> YearMonth.from(t.getCreatedAt().atZone(ZONE_ID)).equals(current))
                    .count();
            long p = txns.stream().filter(t -> YearMonth.from(t.getCreatedAt().atZone(ZONE_ID)).equals(previous))
                    .count();
            return growth(c, p);
        }
        return growth(currentVal, previousVal);
    }

    private List<SuperAdminAnalyticsResponse.MetricCard> buildKpis(
            List<ad_campaigns> campaigns,
            List<ad_campaigns> activeCampaigns,
            List<ad_campaigns> geoCampaigns) {
        double totalAmount = getAllPayments().stream()
                .filter(t -> "SUCCESS".equalsIgnoreCase(t.getStatus()))
                .mapToDouble(PaymentTransaction::getAmount)
                .sum();

        return List.of(
                new SuperAdminAnalyticsResponse.MetricCard("Total Ads",
                        String.valueOf(countCollection("advertisements")),
                        0),
                new SuperAdminAnalyticsResponse.MetricCard("Total Campaigns", String.valueOf(campaigns.size()),
                        0),
                new SuperAdminAnalyticsResponse.MetricCard("Active Campaigns", String.valueOf(activeCampaigns.size()),
                        0),
                new SuperAdminAnalyticsResponse.MetricCard("Active Ads", String.valueOf(countActiveAdvertisements()),
                        0),
                new SuperAdminAnalyticsResponse.MetricCard("Publishers",
                        String.valueOf(companiesRepository.count()), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Total Users",
                        String.valueOf(countCollection("users")), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Total Admins",
                        String.valueOf(countTotalAdmins()), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Total Transactions",
                        String.valueOf(getAllPayments().size()), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Total Amount", "₹" + Math.round(totalAmount), 0),
                new SuperAdminAnalyticsResponse.MetricCard("Geo-Targeted",
                        String.valueOf(geoCampaigns.size()), 0));
    }

    private List<SuperAdminAnalyticsResponse.NamedCount> buildTopCampaigns(
            List<ad_campaigns> campaigns,
            Map<String, Document> adsById) {
        Map<String, Long> counts = campaigns.stream()
                .map(campaign -> {
                    Document ad = adsById.get(campaign.getAdvertisementId());
                    String title = stringValue(ad == null ? null : ad.get("title"));
                    return title != null && !title.isBlank() ? title : "Untitled";
                })
                .collect(Collectors.groupingBy(name -> name, Collectors.counting()));

        return counts.entrySet().stream()
                .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                .limit(10)
                .map(entry -> new SuperAdminAnalyticsResponse.NamedCount(entry.getKey(), entry.getValue()))
                .toList();
    }

    private String resolveAdTypeInJava(String raw) {
        if (raw == null)
            return "Unknown";
        if ("64887c11cce361dafc86c23b".equals(raw) || "Banner".equalsIgnoreCase(raw))
            return "Banner";
        if ("64887c11cce361dafc86c23c".equals(raw) || "Video".equalsIgnoreCase(raw))
            return "Video";
        if ("64887c11cce361dafc86c23d".equals(raw) || "Image".equalsIgnoreCase(raw))
            return "Image";
        return raw;
    }

    private List<SuperAdminAnalyticsResponse.NamedCount> buildAdTypeBreakdown(
            List<ad_campaigns> campaigns,
            Map<String, Document> adsById) {
        Map<String, Long> counts = new HashMap<>();
        for (ad_campaigns campaign : campaigns) {
            Document ad = adsById.get(campaign.getAdvertisementId());
            String adType = stringValue(ad == null ? null : ad.get("adType"));
            adType = resolveAdTypeInJava(adType);
            counts.merge(adType, 1L, Long::sum);
        }
        return counts.entrySet().stream()
                .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
                .map(entry -> new SuperAdminAnalyticsResponse.NamedCount(entry.getKey(), entry.getValue()))
                .toList();
    }

    private List<SuperAdminAnalyticsResponse.LocationRow> buildLocationRows(
            List<ad_campaigns> campaigns,
            Map<String, Document> adDocumentsById) {
        Map<String, List<ad_campaigns>> grouped = campaigns.stream()
                .filter(campaign -> resolveTargetLocation(campaign, adDocumentsById) != null)
                .collect(Collectors
                        .groupingBy(campaign -> locationKey(resolveTargetLocation(campaign, adDocumentsById))));

        // Load all actual admins
        List<Document> adminUsers = mongoTemplate.find(
                new Query(Criteria.where("userType").is("ADMIN")),
                Document.class,
                "users");
        if (adminUsers.isEmpty()) {
            adminUsers = mongoTemplate.find(
                    new Query(Criteria.where("givendor").is(1)),
                    Document.class,
                    "users");
        }

        final List<Document> finalAdminUsers = adminUsers;

        // Load all users for the users metric
        List<Document> allUsers = mongoTemplate.findAll(Document.class, "users");

        return grouped.entrySet().stream()
                .sorted((a, b) -> Integer.compare(b.getValue().size(), a.getValue().size()))
                .map(entry -> {
                    TargetLocation firstLocation = resolveTargetLocation(entry.getValue().get(0), adDocumentsById);
                    SuperAdminAnalyticsResponse.LocationRow row = new SuperAdminAnalyticsResponse.LocationRow();
                    row.setCity(locationLabel(firstLocation));
                    row.setCampaigns(entry.getValue().size());
                    row.setActiveCampaigns(entry.getValue().stream().filter(this::isActiveCampaign).count());
                    row.setAverageRadiusKm(round(averageRadius(entry.getValue())));
                    row.setStatus(row.getActiveCampaigns() > 0 ? "Active" : "Inactive");
                    row.setLatitude(firstLocation.lat());
                    row.setLongitude(firstLocation.lng());

                    double radiusKm = firstLocation.rangeMeters() > 0 ? firstLocation.rangeMeters() / 1000.0 : 10.0;
                    double distanceThreshold = Math.max(radiusKm, 50.0); // 50km threshold covers regional areas

                    // Count geolocated admins near the campaign location
                    long localAdminsCount = 0;
                    for (Document adminDoc : finalAdminUsers) {
                        Double lat = parseCoordinateValue(adminDoc.get("latitude"));
                        Double lng = parseCoordinateValue(adminDoc.get("longitude"));
                        if (lat != null && lng != null) {
                            double dist = haversineKm(firstLocation.lat(), firstLocation.lng(), lat, lng);
                            if (dist <= distanceThreshold) {
                                localAdminsCount++;
                            }
                        }
                    }
                    row.setAdmins(localAdminsCount);

                    // Count geolocated users near the campaign location
                    long localUsersCount = 0;
                    for (Document userDoc : allUsers) {
                        Double lat = parseCoordinateValue(userDoc.get("latitude"));
                        Double lng = parseCoordinateValue(userDoc.get("longitude"));
                        if (lat != null && lng != null) {
                            double dist = haversineKm(firstLocation.lat(), firstLocation.lng(), lat, lng);
                            if (dist <= distanceThreshold) {
                                localUsersCount++;
                            }
                        }
                    }
                    row.setUsers(localUsersCount);

                    long localAdTypesCount = entry.getValue().stream()
                            .map(c -> adDocumentsById.get(c.getAdvertisementId()))
                            .filter(Objects::nonNull)
                            .map(doc -> stringValue(doc.get("adType")))
                            .filter(Objects::nonNull)
                            .distinct()
                            .count();
                    row.setAdTypes(localAdTypesCount);

                    return row;
                })
                .toList();
    }

    private Double parseCoordinate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private List<SuperAdminAnalyticsResponse.NamedValue> buildRadiusBreakdown(List<ad_campaigns> campaigns) {
        Map<String, Long> buckets = new LinkedHashMap<>();
        buckets.put("0-1 km", 0L);
        buckets.put("1-2 km", 0L);
        buckets.put("2-5 km", 0L);
        buckets.put("5-10 km", 0L);
        buckets.put("10+ km", 0L);

        for (ad_campaigns campaign : campaigns) {
            double radiusKm = campaign.getLocation() == null ? 0 : campaign.getLocation().getRange() / 1000.0;
            String bucket = radiusKm <= 1 ? "0-1 km"
                    : radiusKm <= 2 ? "1-2 km"
                            : radiusKm <= 5 ? "2-5 km"
                                    : radiusKm <= 10 ? "5-10 km"
                                            : "10+ km";
            buckets.put(bucket, buckets.get(bucket) + 1);
        }

        return buckets.entrySet().stream()
                .map(entry -> new SuperAdminAnalyticsResponse.NamedValue(entry.getKey(), entry.getValue()))
                .toList();
    }

    private String findTopLocation(List<ad_campaigns> campaigns, Map<String, Document> adDocumentsById) {
        return buildLocationRows(campaigns, adDocumentsById).stream()
                .findFirst()
                .map(SuperAdminAnalyticsResponse.LocationRow::getCity)
                .orElse("No targeted location");
    }

    private List<SuperAdminAnalyticsResponse.CreatorRow> buildCreatorRows(
            List<ad_campaigns> campaigns,
            Map<String, users> creatorsById,
            Map<String, Document> adDocumentsById) {
        Map<String, List<ad_campaigns>> grouped = campaigns.stream()
                .filter(campaign -> campaign.getCreatedBy() != null && !campaign.getCreatedBy().isBlank())
                .collect(Collectors.groupingBy(ad_campaigns::getCreatedBy));

        List<SuperAdminAnalyticsResponse.CreatorRow> rows = new ArrayList<>();
        for (Map.Entry<String, List<ad_campaigns>> entry : grouped.entrySet()) {
            users creator = creatorsById.get(entry.getKey());
            List<ad_campaigns> creatorCampaigns = entry.getValue();
            Set<String> locations = creatorCampaigns.stream()
                    .map(campaign -> resolveTargetLocation(campaign, adDocumentsById))
                    .filter(Objects::nonNull)
                    .map(this::locationKey)
                    .collect(Collectors.toSet());

            SuperAdminAnalyticsResponse.CreatorRow row = new SuperAdminAnalyticsResponse.CreatorRow();
            row.setName(creator != null && creator.getFullName() != null ? creator.getFullName()
                    : "Creator " + shortId(entry.getKey()));
            row.setCampaigns(creatorCampaigns.size());
            row.setActiveCampaigns(creatorCampaigns.stream().filter(this::isActiveCampaign).count());
            row.setTargetedLocations(locations.size());
            rows.add(row);
        }

        rows.sort(Comparator.comparingLong(SuperAdminAnalyticsResponse.CreatorRow::getCampaigns).reversed());
        for (int i = 0; i < rows.size(); i++) {
            rows.get(i).setRank(i + 1);
        }
        return rows.stream().limit(10).toList();
    }

    private List<SuperAdminAnalyticsResponse.NamedValue> buildCampaignsPerCreator(
            List<ad_campaigns> campaigns,
            Map<String, users> creatorsById,
            Map<String, Document> adDocumentsById) {
        return buildCreatorRows(campaigns, creatorsById, adDocumentsById).stream()
                .limit(6)
                .map(row -> new SuperAdminAnalyticsResponse.NamedValue(shortName(row.getName()), row.getCampaigns()))
                .toList();
    }

    private List<SuperAdminAnalyticsResponse.PublisherRow> buildPublisherRows(
            List<users> publishers,
            Map<String, txn_user_locations> publisherLocations,
            List<ad_campaigns> geoCampaigns,
            Map<String, Document> adDocumentsById) {
        List<SuperAdminAnalyticsResponse.PublisherRow> rows = new ArrayList<>();
        for (users publisher : publishers) {
            txn_user_locations location = publisher.getLastKnownLocation() != null
                    ? publisherLocations.get(publisher.getLastKnownLocation())
                    : null;
            long nearbyCampaigns = location == null ? 0
                    : countNearbyCampaigns(location, geoCampaigns, adDocumentsById, false);
            long nearbyActiveCampaigns = location == null ? 0
                    : countNearbyCampaigns(location, geoCampaigns, adDocumentsById, true);

            SuperAdminAnalyticsResponse.PublisherRow row = new SuperAdminAnalyticsResponse.PublisherRow();
            row.setName(publisher.getFullName() != null ? publisher.getFullName() : "Publisher");
            row.setLocation(location == null ? "Unknown" : formatPoint(location));
            row.setCampaignsNearby(nearbyCampaigns);
            row.setActiveCampaignsNearby(nearbyActiveCampaigns);
            row.setStatus(nearbyActiveCampaigns > 0 ? "Active" : "Inactive");
            rows.add(row);
        }

        rows.sort(Comparator.comparingLong(SuperAdminAnalyticsResponse.PublisherRow::getCampaignsNearby).reversed());
        return rows.stream().limit(10).toList();
    }

    private long countNearbyCampaigns(txn_user_locations publisherLocation, List<ad_campaigns> campaigns,
            Map<String, Document> adDocumentsById,
            boolean activeOnly) {
        double publisherLat = publisherLocation.getLocation().getY();
        double publisherLng = publisherLocation.getLocation().getX();

        return campaigns.stream()
                .filter(campaign -> !activeOnly || isActiveCampaign(campaign))
                .filter(campaign -> {
                    TargetLocation target = resolveTargetLocation(campaign, adDocumentsById);
                    if (target == null) {
                        return false;
                    }
                    double radiusKm = target.rangeMeters() / 1000.0;
                    return haversineKm(publisherLat, publisherLng, target.lat(), target.lng()) <= Math.max(radiusKm,
                            1.0);
                })
                .count();
    }

    private List<SuperAdminAnalyticsResponse.NamedValue> buildMonthlyTrend(List<ad_campaigns> campaigns, int minYear) {
        java.time.YearMonth current = java.time.YearMonth.now(ZONE_ID);
        int currentYear = current.getYear();
        java.util.Map<java.time.YearMonth, Long> grouped = new java.util.LinkedHashMap<>();
        for (int year = minYear; year <= currentYear; year++) {
            int maxMonth = (year == currentYear) ? current.getMonthValue() : 12;
            for (int month = 1; month <= maxMonth; month++) {
                grouped.put(java.time.YearMonth.of(year, month), 0L);
            }
        }
        for (ad_campaigns campaign : campaigns) {
            YearMonth month = YearMonth.from(resolveCampaignTimestamp(campaign).atZone(ZONE_ID));
            if (grouped.containsKey(month)) {
                grouped.put(month, grouped.get(month) + 1);
            }
        }
        return grouped.entrySet().stream()
                .map(entry -> new SuperAdminAnalyticsResponse.NamedValue(entry.getKey().format(MONTH_LABEL),
                        entry.getValue()))
                .toList();
    }

    private List<SuperAdminAnalyticsResponse.NamedValue> buildWeeklyTrend(List<ad_campaigns> campaigns) {
        WeekFields weekFields = WeekFields.ISO;
        Map<String, Long> grouped = new LinkedHashMap<>();
        Instant now = Instant.now();
        for (int i = 5; i >= 0; i--) {
            Instant instant = now.minusSeconds(7L * 24 * 60 * 60 * i);
            int week = instant.atZone(ZONE_ID).get(weekFields.weekOfWeekBasedYear());
            grouped.put("Wk " + week, 0L);
        }
        for (ad_campaigns campaign : campaigns) {
            int week = resolveCampaignTimestamp(campaign).atZone(ZONE_ID).get(weekFields.weekOfWeekBasedYear());
            String key = "Wk " + week;
            if (grouped.containsKey(key)) {
                grouped.put(key, grouped.get(key) + 1);
            }
        }
        return grouped.entrySet().stream()
                .map(entry -> new SuperAdminAnalyticsResponse.NamedValue(entry.getKey(), entry.getValue()))
                .toList();
    }

    private List<SuperAdminAnalyticsResponse.NamedValue> buildDurationBreakdown(List<ad_campaigns> campaigns) {
        Map<String, List<Long>> buckets = new LinkedHashMap<>();
        buckets.put("0-7 days", new ArrayList<>());
        buckets.put("8-30 days", new ArrayList<>());
        buckets.put("31-90 days", new ArrayList<>());
        buckets.put("90+ days", new ArrayList<>());

        for (ad_campaigns campaign : campaigns) {
            long days = campaignDurationDays(campaign);
            double radiusKm = campaign.getLocation() == null ? 0 : campaign.getLocation().getRange() / 1000.0;
            String bucket = days <= 7 ? "0-7 days"
                    : days <= 30 ? "8-30 days"
                            : days <= 90 ? "31-90 days"
                                    : "90+ days";
            buckets.get(bucket).add(Math.round(radiusKm));
        }

        List<SuperAdminAnalyticsResponse.NamedValue> values = new ArrayList<>();
        for (Map.Entry<String, List<Long>> entry : buckets.entrySet()) {
            double avg = entry.getValue().isEmpty()
                    ? 0
                    : entry.getValue().stream().mapToLong(Long::longValue).average().orElse(0);
            values.add(new SuperAdminAnalyticsResponse.NamedValue(entry.getKey(), round(avg)));
        }
        return values;
    }

    private List<SuperAdminAnalyticsResponse.DataCheckpoint> buildDataCheckpoint(
            List<ad_campaigns> allCampaigns,
            List<ad_campaigns> selectedCampaigns,
            List<ad_campaigns> geoCampaigns,
            Map<String, Document> adDocumentsById) {
        long campaignLocationCount = selectedCampaigns.stream().filter(this::hasCampaignLocation).count();
        long ctaLocationCount = selectedCampaigns.stream()
                .filter(campaign -> !hasCampaignLocation(campaign))
                .filter(campaign -> resolveAdvertisementCtaLocation(campaign, adDocumentsById) != null)
                .count();

        return List.of(
                new SuperAdminAnalyticsResponse.DataCheckpoint("Mongo Advertisements",
                        countCollection("advertisements"), "advertisements"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Mongo Ad Campaigns",
                        allCampaigns.size(), "ad_campaigns"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Selected Range Campaigns",
                        selectedCampaigns.size(), "ad_campaigns filtered by dateRange.fromDate"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Campaigns With Coordinates",
                        geoCampaigns.size(), "ad_campaigns.location lat/lng + advertisements.cta fallback"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Campaign Location Coordinates",
                        campaignLocationCount, "ad_campaigns.location.lat/lng"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Advertisement CTA Coordinates",
                        ctaLocationCount, "advertisements.cta.buttons.content.action.latitude/longitude"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Companies / Publishers",
                        countCollection("companies"), "companies"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Users",
                        countCollection("users"), "users"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("User Publishing Transactions",
                        countCollection("txn_user_publishings"), "txn_user_publishings"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("User Locations",
                        countCollection("txn_user_locations"), "txn_user_locations"),
                new SuperAdminAnalyticsResponse.DataCheckpoint("Publishing View Counts",
                        countCollection("txn_publishing_view_counts"), "txn_publishing_view_counts"));
    }

    private long countCollection(String collectionName) {
        return mongoTemplate.getCollection(collectionName).countDocuments();
    }

    private long countTotalAdmins() {
        long activeAdmins = mongoTemplate.count(new Query(Criteria.where("givendor").is(1)), "users");
        List<String> activeAdminEmails = mongoTemplate.find(
                new Query(Criteria.where("givendor").is(1)),
                Document.class,
                "users").stream()
                .map(doc -> doc.getString("emailAddress"))
                .filter(Objects::nonNull)
                .toList();

        Query regQuery = new Query();
        regQuery.addCriteria(Criteria.where("status").ne("REJECTED"));
        if (!activeAdminEmails.isEmpty()) {
            regQuery.addCriteria(Criteria.where("emailId").nin(activeAdminEmails));
        }
        long pendingOrRejectedAdmins = mongoTemplate.count(regQuery, "admin_registrations");
        return activeAdmins + pendingOrRejectedAdmins;
    }

    private long countActiveAdvertisements() {
        return mongoTemplate.count(new Query(Criteria.where("status").is(true)), "advertisements");
    }

    private long countCampaignsWithStoredCoordinates() {
        Query query = new Query(new Criteria().andOperator(
                Criteria.where("location.lat").ne(null),
                Criteria.where("location.lng").ne(null)));
        return mongoTemplate.count(query, "ad_campaigns");
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

    private Map<String, Document> loadAdvertisementDocuments(List<ad_campaigns> campaigns) {
        List<ObjectId> adIds = campaigns.stream()
                .map(ad_campaigns::getAdvertisementId)
                .map(this::parseObjectId)
                .filter(Objects::nonNull)
                .distinct()
                .toList();
        if (adIds.isEmpty()) {
            return Collections.emptyMap();
        }

        Query query = new Query(Criteria.where("_id").in(adIds));
        query.fields().include("_id").include("title").include("adType").include("cta");
        return mongoTemplate.find(query, Document.class, "advertisements").stream()
                .collect(Collectors.toMap(document -> document.getObjectId("_id").toHexString(), document -> document));
    }

    private Map<String, users> loadCreators(List<ad_campaigns> campaigns) {
        List<String> ids = campaigns.stream()
                .map(ad_campaigns::getCreatedBy)
                .filter(Objects::nonNull)
                .filter(id -> !id.isBlank())
                .distinct()
                .toList();
        if (ids.isEmpty()) {
            return Collections.emptyMap();
        }
        return usersRepository.findDashboardUsersByIds(ids).stream()
                .collect(Collectors.toMap(users::getId, user -> user));
    }

    private Map<String, txn_user_locations> loadPublisherLocations(List<users> publishers) {
        List<String> ids = publishers.stream()
                .map(users::getLastKnownLocation)
                .filter(Objects::nonNull)
                .filter(id -> !id.isBlank())
                .distinct()
                .toList();
        if (ids.isEmpty()) {
            return Collections.emptyMap();
        }
        return userLocationsRepository.findAllById(ids).stream()
                .collect(Collectors.toMap(txn_user_locations::getId, location -> location));
    }

    private boolean isActiveCampaign(ad_campaigns campaign) {
        return campaign.getCompaignsStatus() != null && "ACTIVE".equalsIgnoreCase(campaign.getCompaignsStatus());
    }

    private boolean hasTargetLocation(ad_campaigns campaign) {
        return hasCampaignLocation(campaign);
    }

    private boolean hasCampaignLocation(ad_campaigns campaign) {
        location location = campaign.getLocation();
        return location != null
                && parseCoordinate(location.getLat()) != null
                && parseCoordinate(location.getLng()) != null;
    }

    private TargetLocation resolveTargetLocation(ad_campaigns campaign, Map<String, Document> adDocumentsById) {
        TargetLocation campaignLocation = resolveCampaignLocation(campaign);
        if (campaignLocation != null) {
            return campaignLocation;
        }
        return resolveAdvertisementCtaLocation(campaign, adDocumentsById);
    }

    private TargetLocation resolveCampaignLocation(ad_campaigns campaign) {
        location location = campaign.getLocation();
        if (location == null) {
            return null;
        }
        Double lat = parseCoordinate(location.getLat());
        Double lng = parseCoordinate(location.getLng());
        if (lat == null || lng == null) {
            return null;
        }
        return new TargetLocation(lat, lng, locationLabel(location), location.getRange());
    }

    private TargetLocation resolveAdvertisementCtaLocation(ad_campaigns campaign,
            Map<String, Document> adDocumentsById) {
        Document advertisement = adDocumentsById.get(campaign.getAdvertisementId());
        if (advertisement == null) {
            return null;
        }

        Document cta = asDocument(advertisement.get("cta"));
        if (cta == null) {
            return null;
        }

        List<?> buttons = asList(cta.get("buttons"));
        for (Object item : buttons) {
            Document button = asDocument(item);
            if (button == null) {
                continue;
            }
            Document content = asDocument(button.get("content"));
            if (content == null) {
                continue;
            }
            Document action = asDocument(content.get("action"));
            if (action == null) {
                continue;
            }

            Double lat = parseCoordinateValue(action.get("latitude"));
            Double lng = parseCoordinateValue(action.get("longitude"));
            if (lat == null || lng == null) {
                lat = parseCoordinateValue(action.get("lat"));
                lng = parseCoordinateValue(action.get("lng"));
            }
            if (lat != null && lng != null) {
                String label = content.getString("label");
                if (label == null || label.isBlank()) {
                    label = advertisement.getString("title");
                }
                if (label == null || label.isBlank()) {
                    label = lat + ", " + lng;
                }
                int range = campaign.getLocation() == null ? 0 : campaign.getLocation().getRange();
                return new TargetLocation(lat, lng, label, range);
            }
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    private Document asDocument(Object value) {
        if (value instanceof Document document) {
            return document;
        }
        if (value instanceof Map<?, ?> map) {
            return new Document((Map<String, Object>) map);
        }
        return null;
    }

    private List<?> asList(Object value) {
        if (value instanceof List<?> list) {
            return list;
        }
        return Collections.emptyList();
    }

    private String locationLabel(location location) {
        if (location.getLocationName() != null && !location.getLocationName().isBlank()) {
            return location.getLocationName();
        }
        return location.getLat() + ", " + location.getLng();
    }

    private String locationLabel(TargetLocation location) {
        if (location.label() != null && !location.label().isBlank()) {
            return location.label();
        }
        return location.lat() + ", " + location.lng();
    }

    private String locationKey(location location) {
        Double lat = parseCoordinate(location.getLat());
        Double lng = parseCoordinate(location.getLng());
        if (lat != null && lng != null) {
            return String.format(Locale.ENGLISH, "%.6f,%.6f", lat, lng);
        }
        return locationLabel(location).toLowerCase(Locale.ENGLISH);
    }

    private String locationKey(TargetLocation location) {
        return String.format(Locale.ENGLISH, "%.6f,%.6f", location.lat(), location.lng());
    }

    private double averageRadius(Collection<ad_campaigns> campaigns) {
        return campaigns.stream()
                .filter(campaign -> campaign.getLocation() != null)
                .filter(campaign -> campaign.getLocation().getRange() > 0)
                .mapToDouble(campaign -> campaign.getLocation().getRange() / 1000.0)
                .average()
                .orElse(0);
    }

    private double growthForMonth(List<ad_campaigns> campaigns, java.util.function.Predicate<ad_campaigns> predicate) {
        YearMonth current = YearMonth.now(ZONE_ID);
        YearMonth previous = current.minusMonths(1);
        long currentCount = campaigns.stream()
                .filter(campaign -> predicate == null || predicate.test(campaign))
                .filter(campaign -> YearMonth.from(resolveCampaignTimestamp(campaign).atZone(ZONE_ID)).equals(current))
                .count();
        long previousCount = campaigns.stream()
                .filter(campaign -> predicate == null || predicate.test(campaign))
                .filter(campaign -> YearMonth.from(resolveCampaignTimestamp(campaign).atZone(ZONE_ID)).equals(previous))
                .count();
        return growth(currentCount, previousCount);
    }

    private double locationGrowth(List<ad_campaigns> campaigns) {
        YearMonth current = YearMonth.now(ZONE_ID);
        YearMonth previous = current.minusMonths(1);
        long currentCount = uniqueLocationsForMonth(campaigns, current);
        long previousCount = uniqueLocationsForMonth(campaigns, previous);
        return growth(currentCount, previousCount);
    }

    private long uniqueLocationsForMonth(List<ad_campaigns> campaigns, YearMonth month) {
        return campaigns.stream()
                .filter(this::hasTargetLocation)
                .filter(campaign -> YearMonth.from(resolveCampaignTimestamp(campaign).atZone(ZONE_ID)).equals(month))
                .map(campaign -> locationKey(campaign.getLocation()))
                .collect(Collectors.toSet())
                .size();
    }

    private double radiusGrowth(List<ad_campaigns> campaigns) {
        YearMonth current = YearMonth.now(ZONE_ID);
        YearMonth previous = current.minusMonths(1);
        double currentAvg = averageRadius(campaigns.stream()
                .filter(this::hasTargetLocation)
                .filter(campaign -> YearMonth.from(resolveCampaignTimestamp(campaign).atZone(ZONE_ID)).equals(current))
                .toList());
        double previousAvg = averageRadius(campaigns.stream()
                .filter(this::hasTargetLocation)
                .filter(campaign -> YearMonth.from(resolveCampaignTimestamp(campaign).atZone(ZONE_ID)).equals(previous))
                .toList());
        return growth(currentAvg, previousAvg);
    }

    private double publisherGrowth() {
        List<users> publishers = usersRepository.findAll();
        YearMonth current = YearMonth.now(ZONE_ID);
        YearMonth previous = current.minusMonths(1);
        long currentCount = publishers.stream()
                .map(users::getId)
                .map(this::parseObjectIdInstant)
                .filter(Objects::nonNull)
                .filter(instant -> YearMonth.from(instant.atZone(ZONE_ID)).equals(current))
                .count();
        long previousCount = publishers.stream()
                .map(users::getId)
                .map(this::parseObjectIdInstant)
                .filter(Objects::nonNull)
                .filter(instant -> YearMonth.from(instant.atZone(ZONE_ID)).equals(previous))
                .count();
        return growth(currentCount, previousCount);
    }

    private Instant resolveCampaignTimestamp(ad_campaigns campaign) {
        dateRange range = campaign.getDateRange();
        if (range != null && range.getFromDate() != null) {
            return range.getFromDate().toInstant();
        }
        Instant fromId = parseObjectIdInstant(campaign.getId());
        return fromId != null ? fromId : Instant.now();
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

    private ObjectId parseObjectId(String id) {
        if (id == null || id.isBlank()) {
            return null;
        }
        try {
            return new ObjectId(id);
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }

    private Double parseCoordinateValue(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof Number number) {
            return number.doubleValue();
        }
        if (value instanceof String text) {
            return parseCoordinate(text);
        }
        return null;
    }

    private String stringValue(Object value) {
        return value == null ? null : String.valueOf(value);
    }

    private long campaignDurationDays(ad_campaigns campaign) {
        dateRange range = campaign.getDateRange();
        if (range == null || range.getFromDate() == null || range.getToDate() == null) {
            return 0;
        }
        return Math.max(0, (range.getToDate().getTime() - range.getFromDate().getTime()) / (1000 * 60 * 60 * 24));
    }

    private String shortName(String fullName) {
        String[] parts = fullName.split(" ");
        return parts.length > 1 ? parts[0] + " " + parts[1].charAt(0) + "." : fullName;
    }

    private String shortId(String id) {
        return id.length() <= 6 ? id : id.substring(id.length() - 6);
    }

    private String formatPoint(txn_user_locations location) {
        return String.format(Locale.ENGLISH, "%.4f, %.4f", location.getLocation().getY(),
                location.getLocation().getX());
    }

    private double haversineKm(double lat1, double lon1, double lat2, double lon2) {
        final double earthRadiusKm = 6371.0;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                        * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return earthRadiusKm * c;
    }

    private double growth(double current, double previous) {
        if (previous == 0) {
            return current > 0 ? 100.0 : 0.0;
        }
        return round(((current - previous) / previous) * 100.0);
    }

    private double round(double value) {
        return Math.round(value * 100.0) / 100.0;
    }

    private List<SuperAdminAnalyticsResponse.NamedValue> buildMonthlyAdminsTrend(int minYear) {
        java.time.YearMonth current = java.time.YearMonth.now(ZONE_ID);
        int currentYear = current.getYear();
        java.util.Map<java.time.YearMonth, Long> grouped = new java.util.LinkedHashMap<>();
        for (int year = minYear; year <= currentYear; year++) {
            int maxMonth = (year == currentYear) ? current.getMonthValue() : 12;
            for (int month = 1; month <= maxMonth; month++) {
                grouped.put(java.time.YearMonth.of(year, month), 0L);
            }
        }

        List<Document> adminUsers = mongoTemplate.find(
                new Query(Criteria.where("givendor").is(1)),
                Document.class,
                "users");
        for (Document doc : adminUsers) {
            String idStr = getDocumentId(doc);
            Instant instant = parseObjectIdInstant(idStr);
            if (instant != null) {
                java.time.YearMonth month = java.time.YearMonth.from(instant.atZone(ZONE_ID));
                if (grouped.containsKey(month)) {
                    grouped.put(month, grouped.get(month) + 1);
                }
            }
        }

        List<Document> regs = mongoTemplate.findAll(Document.class, "admin_registrations");
        for (Document doc : regs) {
            String status = doc.getString("status");
            if ("APPROVED".equalsIgnoreCase(status)) {
                continue;
            }
            String idStr = getDocumentId(doc);
            Instant instant = parseObjectIdInstant(idStr);
            if (instant != null) {
                java.time.YearMonth month = java.time.YearMonth.from(instant.atZone(ZONE_ID));
                if (grouped.containsKey(month)) {
                    grouped.put(month, grouped.get(month) + 1);
                }
            }
        }

        return grouped.entrySet().stream()
                .map(entry -> new SuperAdminAnalyticsResponse.NamedValue(entry.getKey().format(MONTH_LABEL),
                        entry.getValue().doubleValue()))
                .toList();
    }

    private List<SuperAdminAnalyticsResponse.NamedValue> buildMonthlyUsersTrend(int minYear) {
        java.time.YearMonth current = java.time.YearMonth.now(ZONE_ID);
        int currentYear = current.getYear();
        java.util.Map<java.time.YearMonth, Long> grouped = new java.util.LinkedHashMap<>();
        for (int year = minYear; year <= currentYear; year++) {
            int maxMonth = (year == currentYear) ? current.getMonthValue() : 12;
            for (int month = 1; month <= maxMonth; month++) {
                grouped.put(java.time.YearMonth.of(year, month), 0L);
            }
        }

        List<Document> allUsers = mongoTemplate.findAll(Document.class, "users");
        for (Document doc : allUsers) {
            Integer givendor = doc.getInteger("givendor");
            if (givendor != null && givendor == 1) {
                continue;
            }
            String idStr = getDocumentId(doc);
            Instant instant = parseObjectIdInstant(idStr);
            if (instant != null) {
                java.time.YearMonth month = java.time.YearMonth.from(instant.atZone(ZONE_ID));
                if (grouped.containsKey(month)) {
                    grouped.put(month, grouped.get(month) + 1);
                }
            }
        }

        List<Document> companies = mongoTemplate.findAll(Document.class, "companies");
        for (Document doc : companies) {
            String idStr = getDocumentId(doc);
            Instant instant = parseObjectIdInstant(idStr);
            if (instant != null) {
                java.time.YearMonth month = java.time.YearMonth.from(instant.atZone(ZONE_ID));
                if (grouped.containsKey(month)) {
                    grouped.put(month, grouped.get(month) + 1);
                }
            }
        }

        return grouped.entrySet().stream()
                .map(entry -> new SuperAdminAnalyticsResponse.NamedValue(entry.getKey().format(MONTH_LABEL),
                        entry.getValue().doubleValue()))
                .toList();
    }

    private int getEarliestYear(List<ad_campaigns> campaigns) {
        int currentYear = java.time.LocalDate.now(ZONE_ID).getYear();
        int minYear = currentYear;

        for (ad_campaigns campaign : campaigns) {
            Instant ts = resolveCampaignTimestamp(campaign);
            if (ts != null) {
                int yr = ts.atZone(ZONE_ID).getYear();
                if (yr > 2000 && yr < minYear) {
                    minYear = yr;
                }
            }
        }

        List<Document> adminUsers = mongoTemplate.find(
                new Query(Criteria.where("givendor").is(1)),
                Document.class,
                "users");
        for (Document doc : adminUsers) {
            String idStr = getDocumentId(doc);
            Instant ts = parseObjectIdInstant(idStr);
            if (ts != null) {
                int yr = ts.atZone(ZONE_ID).getYear();
                if (yr > 2000 && yr < minYear) {
                    minYear = yr;
                }
            }
        }

        List<Document> regs = mongoTemplate.findAll(Document.class, "admin_registrations");
        for (Document doc : regs) {
            String idStr = getDocumentId(doc);
            Instant ts = parseObjectIdInstant(idStr);
            if (ts != null) {
                int yr = ts.atZone(ZONE_ID).getYear();
                if (yr > 2000 && yr < minYear) {
                    minYear = yr;
                }
            }
        }

        List<Document> allUsers = mongoTemplate.findAll(Document.class, "users");
        for (Document doc : allUsers) {
            String idStr = getDocumentId(doc);
            Instant ts = parseObjectIdInstant(idStr);
            if (ts != null) {
                int yr = ts.atZone(ZONE_ID).getYear();
                if (yr > 2000 && yr < minYear) {
                    minYear = yr;
                }
            }
        }

        List<Document> companies = mongoTemplate.findAll(Document.class, "companies");
        for (Document doc : companies) {
            String idStr = getDocumentId(doc);
            Instant ts = parseObjectIdInstant(idStr);
            if (ts != null) {
                int yr = ts.atZone(ZONE_ID).getYear();
                if (yr > 2000 && yr < minYear) {
                    minYear = yr;
                }
            }
        }

        if (minYear > 2025) {
            minYear = 2025;
        }
        return minYear;
    }

    private String getDocumentId(Document doc) {
        if (doc == null)
            return null;
        Object id = doc.get("_id");
        if (id instanceof org.bson.types.ObjectId) {
            return ((org.bson.types.ObjectId) id).toHexString();
        }
        return id != null ? id.toString() : null;
    }

    private record TargetLocation(Double lat, Double lng, String label, int rangeMeters) {
    }
}
