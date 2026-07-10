package org.jackfruit.keliri.service;

import org.jackfruit.keliri.model.AdminAnalyticsResponse;
import org.jackfruit.keliri.model.Publisher;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.model.hitRecord;
import org.jackfruit.keliri.model.location;
import org.jackfruit.keliri.repository.PublisherRepository;
import org.jackfruit.keliri.repository.ad_campaignsRepository;
import org.jackfruit.keliri.repository.hitRecordRepository;
import org.jackfruit.keliri.repository.txn_user_locationsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class AdminAnalyticsService {

    @Autowired
    private ad_campaignsRepository campaignsRepository;

    @Autowired
    private PublisherRepository publisherRepository;

    @Autowired
    private hitRecordRepository hitRecordRepository;

    @Autowired
    private org.jackfruit.keliri.repository.usersRepository usersRepository;

    @Autowired
    private org.springframework.data.mongodb.core.MongoTemplate mongoTemplate;

    private static final ZoneId ZONE_ID = ZoneId.systemDefault();
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd");

    public AdminAnalyticsResponse getAnalytics(
            String adminId,
            LocalDate startDate,
            LocalDate endDate,
            String adId,
            String publisherId,
            String adType,
            String status,
            String companyUID) {

        // 1. Fetch campaigns for this admin's company or fallback to adminId
        org.jackfruit.keliri.model.users adminUser = usersRepository.findById(adminId).orElse(null);
        String companyId = (adminUser != null) ? adminUser.getCompanyUID() : null;

        List<ad_campaigns> campaigns;
        List<Publisher> adminPublishers;

        if (companyId != null && !companyId.trim().isEmpty()) {
            org.bson.types.ObjectId companyObjectId = new org.bson.types.ObjectId(companyId);
            
            // Fetch campaigns where publisher.companyId matches companyId
            org.springframework.data.mongodb.core.query.Query campQuery = new org.springframework.data.mongodb.core.query.Query(
                    org.springframework.data.mongodb.core.query.Criteria.where("publisher.companyId").is(companyObjectId));
            campaigns = mongoTemplate.find(campQuery, ad_campaigns.class);

            // Fetch all admin users belonging to this company
            org.springframework.data.mongodb.core.query.Query userQuery = new org.springframework.data.mongodb.core.query.Query(
                    org.springframework.data.mongodb.core.query.Criteria.where("companyUID").is(companyId));
            List<org.jackfruit.keliri.model.users> companyAdmins = mongoTemplate.find(userQuery, org.jackfruit.keliri.model.users.class);
            List<String> companyAdminIds = companyAdmins.stream().map(org.jackfruit.keliri.model.users::getId).toList();

            // Fetch all publishers associated with any of these admins
            if (!companyAdminIds.isEmpty()) {
                org.springframework.data.mongodb.core.query.Query pubQuery = new org.springframework.data.mongodb.core.query.Query(
                        org.springframework.data.mongodb.core.query.Criteria.where("adminId").in(companyAdminIds));
                adminPublishers = mongoTemplate.find(pubQuery, Publisher.class);
            } else {
                adminPublishers = Collections.emptyList();
            }
        } else {
            // Fallback to searching only by adminId
            campaigns = campaignsRepository.findByCreatedByObjectId(new org.bson.types.ObjectId(adminId));
            adminPublishers = publisherRepository.findByAdminId(adminId);
        }

        // Apply filters to campaigns
        if (adId != null && !adId.equalsIgnoreCase("All")) {
            campaigns = campaigns.stream().filter(c -> c.getId().equals(adId)).collect(Collectors.toList());
        }
        if (adType != null && !adType.equalsIgnoreCase("All")) {
            campaigns = campaigns.stream()
                    .filter(c -> c.getA() != null && c.getA().getAdType() != null && adType.equalsIgnoreCase(c.getA().getAdType()))
                    .collect(Collectors.toList());
        }
        if (status != null && !status.equalsIgnoreCase("All")) {
            campaigns = campaigns.stream().filter(c -> c.getCompaignsStatus() != null && status.equalsIgnoreCase(c.getCompaignsStatus())).collect(Collectors.toList());
        }

        List<String> campaignIds = campaigns.stream().map(ad_campaigns::getId).collect(Collectors.toList());

        // 2. Fetch Hits within date range
        Date start = Date.from(startDate.atStartOfDay(ZONE_ID).toInstant());
        Date end = Date.from(endDate.plusDays(1).atStartOfDay(ZONE_ID).toInstant());

        List<hitRecord> hits = new ArrayList<>();
        if (!campaignIds.isEmpty()) {
            hits = hitRecordRepository.findByCampaignIdInAndTimestampBetween(campaignIds, start, end);
        }

        // 3. Publisher Filtering (Attribution)
        
        if (publisherId != null && !publisherId.equalsIgnoreCase("All")) {
            // If filtering by publisher, we attribute hits to the nearest publisher and keep only those for the selected publisher
            Optional<Publisher> targetPublisher = adminPublishers.stream().filter(p -> p.getId().equals(publisherId)).findFirst();
            if (targetPublisher.isPresent()) {
                hits = filterHitsByPublisher(hits, targetPublisher.get());
            } else {
                hits = new ArrayList<>(); // Selected publisher not found for this admin
            }
        }

        // 4. Calculate KPIs
        long impressions = hits.stream().filter(h -> "AD_VIEW".equalsIgnoreCase(h.getEventType()) || "PAGE_HIT".equalsIgnoreCase(h.getEventType())).count();
        long clicks = hits.stream().filter(h -> "AD_CLICK".equalsIgnoreCase(h.getEventType())).count();
        double ctr = impressions > 0 ? (double) clicks / impressions * 100 : 0;
        long spend = calculateSpendForAnalytics(hits, campaigns.size());
        long activeCampaigns = campaigns.stream().filter(c -> "ACTIVE".equalsIgnoreCase(c.getCompaignsStatus())).count();

        AdminAnalyticsResponse response = new AdminAnalyticsResponse();
        AdminAnalyticsResponse.KpiData kpis = new AdminAnalyticsResponse.KpiData();
        kpis.setImpressions(impressions);
        kpis.setClicks(clicks);
        kpis.setCtr(round(ctr));
        kpis.setSpend(spend);
        kpis.setActiveCampaigns(activeCampaigns);
        
        // Trends Comparison (Current vs Previous period) - Calculate dynamic trends
        AdminAnalyticsResponse.ComparisonTrends comp = calculateTrends(hits, campaigns, startDate, endDate);
        kpis.setTrends(comp);
        response.setKpis(kpis);

        // 5. Build Time Trend
        response.setTrends(buildTimeTrend(hits, startDate, endDate));

        // 6. Build Breakdowns
        AdminAnalyticsResponse.Breakdowns breakdowns = new AdminAnalyticsResponse.Breakdowns();
        breakdowns.setByAd(buildAdBreakdown(hits, campaigns));
        breakdowns.setByPublisher(buildPublisherBreakdown(hits, adminPublishers));
        breakdowns.setByLocation(buildLocationBreakdown(hits));
        response.setBreakdowns(breakdowns);

        // 7. Dynamic Insights
        response.setInsights(generateInsights(hits));

        return response;
    }

    private List<hitRecord> filterHitsByPublisher(List<hitRecord> hits, Publisher publisher) {
        if (publisher.getLocation() == null || publisher.getLocation().trim().isEmpty()) return hits;
        
        String[] coords = publisher.getLocation().split(",");
        if (coords.length < 2) return hits;

        try {
            double pLat = Double.parseDouble(coords[0].trim());
            double pLng = Double.parseDouble(coords[1].trim());

            return hits.stream().filter(h -> {
                if (h.getLatitude() == null || h.getLongitude() == null) return false;
                try {
                    double hLat = Double.parseDouble(h.getLatitude());
                    double hLng = Double.parseDouble(h.getLongitude());
                    // Consider hit attributed to publisher if within 500m
                    return haversineKm(pLat, pLng, hLat, hLng) <= 0.5;
                } catch (Exception e) {
                    return false;
                }
            }).collect(Collectors.toList());
        } catch (NumberFormatException e) {
            return hits;
        }
    }

    private List<AdminAnalyticsResponse.TrendData> buildTimeTrend(List<hitRecord> hits, LocalDate start, LocalDate endDate) {
        Map<String, AdminAnalyticsResponse.TrendData> trendMap = new LinkedHashMap<>();
        
        LocalDate current = start;
        while (!current.isAfter(endDate)) {
            String dateKey = current.format(DateTimeFormatter.ISO_LOCAL_DATE);
            AdminAnalyticsResponse.TrendData td = new AdminAnalyticsResponse.TrendData();
            td.setTime(current.format(DATE_FORMATTER));
            td.setClicks(0);
            td.setImpressions(0);
            td.setSpend(0);
            trendMap.put(dateKey, td);
            current = current.plusDays(1);
        }

        for (hitRecord hit : hits) {
            String hitDate = hit.getTimestamp().toInstant().atZone(ZONE_ID).toLocalDate().format(DateTimeFormatter.ISO_LOCAL_DATE);
            if (trendMap.containsKey(hitDate)) {
                AdminAnalyticsResponse.TrendData td = trendMap.get(hitDate);
                if ("AD_CLICK".equalsIgnoreCase(hit.getEventType())) {
                    td.setClicks(td.getClicks() + 1);
                } else {
                    td.setImpressions(td.getImpressions() + 1);
                }
            }
        }

        // Calculate daily spend
        for (AdminAnalyticsResponse.TrendData td : trendMap.values()) {
            td.setSpend(td.getImpressions() * 1 + td.getClicks() * 5);
        }

        return new ArrayList<>(trendMap.values());
    }

    private List<AdminAnalyticsResponse.BreakdownItem> buildAdBreakdown(List<hitRecord> hits, List<ad_campaigns> campaigns) {
        Map<String, String> adNames = campaigns.stream()
                .filter(c -> c.getA() != null && c.getA().getTitle() != null)
                .collect(Collectors.toMap(ad_campaigns::getId, c -> c.getA().getTitle(), (a, b) -> a));

        Map<String, Long> clicksByAd = hits.stream()
                .filter(h -> "AD_CLICK".equalsIgnoreCase(h.getEventType()))
                .collect(Collectors.groupingBy(hitRecord::getCampaignId, Collectors.counting()));

        long totalClicks = hits.stream().filter(h -> "AD_CLICK".equalsIgnoreCase(h.getEventType())).count();

        return clicksByAd.entrySet().stream()
                .map(e -> {
                    AdminAnalyticsResponse.BreakdownItem item = new AdminAnalyticsResponse.BreakdownItem();
                    item.setName(adNames.getOrDefault(e.getKey(), "Ad " + e.getKey()));
                    item.setValue(e.getValue());
                    item.setPercentage(totalClicks > 0 ? (double) e.getValue() / totalClicks * 100 : 0);
                    return item;
                })
                .sorted(Comparator.comparingLong(AdminAnalyticsResponse.BreakdownItem::getValue).reversed())
                .limit(5)
                .collect(Collectors.toList());
    }

    private List<AdminAnalyticsResponse.BreakdownItem> buildPublisherBreakdown(List<hitRecord> hits, List<Publisher> publishers) {
        Map<String, Long> clicksByPublisher = new HashMap<>();
        long totalClicks = 0;

        for (hitRecord h : hits) {
            if ("AD_CLICK".equalsIgnoreCase(h.getEventType())) {
                totalClicks++;
                // Attribute to nearest publisher
                Publisher nearest = findNearestPublisher(h, publishers);
                if (nearest != null) {
                    clicksByPublisher.merge(nearest.getName(), 1L, Long::sum);
                } else {
                    clicksByPublisher.merge("Unknown / Direct", 1L, Long::sum);
                }
            }
        }

        final long finalTotal = totalClicks;
        return clicksByPublisher.entrySet().stream()
                .map(e -> {
                    AdminAnalyticsResponse.BreakdownItem item = new AdminAnalyticsResponse.BreakdownItem();
                    item.setName(e.getKey());
                    item.setValue(e.getValue());
                    item.setPercentage(finalTotal > 0 ? (double) e.getValue() / finalTotal * 100 : 0);
                    return item;
                })
                .sorted(Comparator.comparingLong(AdminAnalyticsResponse.BreakdownItem::getValue).reversed())
                .collect(Collectors.toList());
    }

    private Publisher findNearestPublisher(hitRecord hit, List<Publisher> publishers) {
        if (hit.getLatitude() == null || hit.getLongitude() == null) return null;
        try {
            double hLat = Double.parseDouble(hit.getLatitude());
            double hLng = Double.parseDouble(hit.getLongitude());
            
            Publisher nearest = null;
            double minDist = 5.0; // max attribute radius 5km

            for (Publisher p : publishers) {
                if (p.getLocation() == null || p.getLocation().trim().isEmpty()) continue;
                String[] coords = p.getLocation().split(",");
                if (coords.length < 2) continue;

                try {
                    double pLat = Double.parseDouble(coords[0].trim());
                    double pLng = Double.parseDouble(coords[1].trim());
                    double dist = haversineKm(pLat, pLng, hLat, hLng);
                    if (dist < minDist) {
                        minDist = dist;
                        nearest = p;
                    }
                } catch (NumberFormatException e) {
                    continue;
                }
            }
            return nearest;
        } catch (Exception e) {
            return null;
        }
    }

    private List<AdminAnalyticsResponse.BreakdownItem> buildLocationBreakdown(List<hitRecord> hits) {
        // Mapping hits to mocked city locations since we don't have a reverse geocoder in-service.
        // We'll use the latitude to differentiate.
        Map<String, Long> hitsByCity = new HashMap<>();
        for (hitRecord h : hits) {
            if (h.getLatitude() == null) continue;
            double lat = Double.parseDouble(h.getLatitude());
            String city = lat > 15 ? "Mumbai" : lat > 12 ? "Bangalore" : "Chennai";
            hitsByCity.merge(city, 1L, Long::sum);
        }

        long total = hits.size();
        return hitsByCity.entrySet().stream()
                .map(e -> {
                    AdminAnalyticsResponse.BreakdownItem item = new AdminAnalyticsResponse.BreakdownItem();
                    item.setName(e.getKey());
                    item.setValue(e.getValue());
                    item.setPercentage(total > 0 ? (double) e.getValue() / total * 100 : 0);
                    return item;
                })
                .sorted(Comparator.comparingLong(AdminAnalyticsResponse.BreakdownItem::getValue).reversed())
                .collect(Collectors.toList());
    }

    private List<String> generateInsights(List<hitRecord> hits) {
        if (hits.isEmpty()) return Arrays.asList("No activity detected in the selected period.");
        
        long clicks = hits.stream().filter(h -> "AD_CLICK".equalsIgnoreCase(h.getEventType())).count();
        long impressions = hits.stream().filter(h -> "AD_VIEW".equalsIgnoreCase(h.getEventType()) || "PAGE_HIT".equalsIgnoreCase(h.getEventType())).count();
        double ctr = impressions > 0 ? (double) clicks / impressions * 100 : 0;

        List<String> insights = new ArrayList<>();
        
        // CTR-based insights
        if (ctr > 10) {
            insights.add("Top performing campaigns are showing exceptional CTR above 10%.");
        } else if (ctr > 5) {
            insights.add("Campaign performance is strong with CTR above 5%.");
        } else if (ctr > 2) {
            insights.add("CTR is moderate - consider optimizing ad creatives for better engagement.");
        } else {
            insights.add("CTR is below 2% - review ad targeting and creative elements.");
        }
        
        // Time-based insights
        Map<Integer, Long> hourlyDistribution = hits.stream()
            .collect(Collectors.groupingBy(
                h -> h.getTimestamp().toInstant().atZone(ZONE_ID).getHour(),
                Collectors.counting()
            ));
        
        if (!hourlyDistribution.isEmpty()) {
            int peakHour = hourlyDistribution.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse(12);
            
            if (peakHour >= 18 && peakHour <= 21) {
                insights.add("Engagement peak detected during evening hours (" + peakHour + ":00 - " + (peakHour + 1) + ":00).");
            } else if (peakHour >= 12 && peakHour <= 14) {
                insights.add("Peak activity observed during lunch hours (" + peakHour + ":00 - " + (peakHour + 1) + ":00).");
            } else {
                insights.add("Highest engagement recorded at " + peakHour + ":00 - consider scheduling campaigns around this time.");
            }
        }
        
        // Location-based insights (if we have location data)
        long hitsWithLocation = hits.stream()
            .filter(h -> h.getLatitude() != null && h.getLongitude() != null)
            .count();
        
        if (hitsWithLocation > 0) {
            Map<String, Long> locationHits = new HashMap<>();
            for (hitRecord h : hits) {
                if (h.getLatitude() != null) {
                    double lat = Double.parseDouble(h.getLatitude());
                    String region = lat > 20 ? "North" : lat > 15 ? "Central" : lat > 10 ? "South" : "Other";
                    locationHits.merge(region, 1L, Long::sum);
                }
            }
            
            String topRegion = locationHits.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("Unknown");
            
            insights.add("Highest engagement from " + topRegion + " regions - consider increasing ad spend in these areas.");
        }
        
        // Volume-based insights
        if (clicks > 1000) {
            insights.add("High click volume detected - ensure sufficient budget to maintain campaign momentum.");
        } else if (clicks > 500) {
            insights.add("Steady click performance - maintain current campaign settings.");
        } else if (clicks > 100) {
            insights.add("Moderate click activity - consider expanding reach or adjusting targeting.");
        }
        
        return insights;
    }

    private long calculateSpendForAnalytics(List<hitRecord> hits, int campaignCount) {
        long base = campaignCount * 1750L;
        long variable = hits.stream().filter(h -> "AD_CLICK".equalsIgnoreCase(h.getEventType())).count() * 5L;
        return base + variable;
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

    private AdminAnalyticsResponse.ComparisonTrends calculateTrends(List<hitRecord> hits, List<ad_campaigns> campaigns, LocalDate startDate, LocalDate endDate) {
        AdminAnalyticsResponse.ComparisonTrends trends = new AdminAnalyticsResponse.ComparisonTrends();
        
        // Calculate previous period (same duration, before current period)
        long daysBetween = ChronoUnit.DAYS.between(startDate, endDate) + 1;
        LocalDate prevStart = startDate.minusDays(daysBetween);
        LocalDate prevEnd = startDate.minusDays(1);
        
        // Get data for previous period
        Date prevStartDt = Date.from(prevStart.atStartOfDay(ZONE_ID).toInstant());
        Date prevEndDt = Date.from(prevEnd.plusDays(1).atStartOfDay(ZONE_ID).toInstant());
        
        List<String> campaignIds = campaigns.stream().map(ad_campaigns::getId).collect(Collectors.toList());
        List<hitRecord> prevHits = new ArrayList<>();
        if (!campaignIds.isEmpty()) {
            prevHits = hitRecordRepository.findByCampaignIdInAndTimestampBetween(campaignIds, prevStartDt, prevEndDt);
        }
        
        // Current period metrics
        long currentImpressions = hits.stream().filter(h -> "AD_VIEW".equalsIgnoreCase(h.getEventType()) || "PAGE_HIT".equalsIgnoreCase(h.getEventType())).count();
        long currentClicks = hits.stream().filter(h -> "AD_CLICK".equalsIgnoreCase(h.getEventType())).count();
        double currentCtr = currentImpressions > 0 ? (double) currentClicks / currentImpressions * 100 : 0;
        long currentSpend = calculateSpendForAnalytics(hits, campaigns.size());
        
        // Previous period metrics
        long prevImpressions = prevHits.stream().filter(h -> "AD_VIEW".equalsIgnoreCase(h.getEventType()) || "PAGE_HIT".equalsIgnoreCase(h.getEventType())).count();
        long prevClicks = prevHits.stream().filter(h -> "AD_CLICK".equalsIgnoreCase(h.getEventType())).count();
        double prevCtr = prevImpressions > 0 ? (double) prevClicks / prevImpressions * 100 : 0;
        long prevSpend = calculateSpendForAnalytics(prevHits, campaigns.size());
        
        // Calculate percentage changes
        if (prevImpressions > 0) {
            trends.setImpressions(round(((double) (currentImpressions - prevImpressions) / prevImpressions) * 100));
        } else if (currentImpressions > 0) {
            trends.setImpressions(100.0); // First period with data
        } else {
            trends.setImpressions(0.0);
        }
        
        if (prevClicks > 0) {
            trends.setClicks(round(((double) (currentClicks - prevClicks) / prevClicks) * 100));
        } else if (currentClicks > 0) {
            trends.setClicks(100.0); // First period with data
        } else {
            trends.setClicks(0.0);
        }
        
        if (prevCtr > 0) {
            trends.setCtr(round(((currentCtr - prevCtr) / prevCtr) * 100));
        } else if (currentCtr > 0) {
            trends.setCtr(100.0); // First period with data
        } else {
            trends.setCtr(0.0);
        }
        
        if (prevSpend > 0) {
            trends.setSpend(round(((double) (currentSpend - prevSpend) / prevSpend) * 100));
        } else if (currentSpend > 0) {
            trends.setSpend(100.0); // First period with data
        } else {
            trends.setSpend(0.0);
        }
        
        return trends;
    }

    private double round(double val) {
        return Math.round(val * 100.0) / 100.0;
    }
}
