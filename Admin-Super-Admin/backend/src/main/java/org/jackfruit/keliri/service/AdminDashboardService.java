package org.jackfruit.keliri.service;

import org.jackfruit.keliri.model.AdminDashboardResponse;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.model.hitRecord;
import org.jackfruit.keliri.repository.PublisherRepository;
import org.jackfruit.keliri.repository.ad_campaignsRepository;
import org.jackfruit.keliri.repository.hitRecordRepository;
import org.jackfruit.keliri.repository.usersRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class AdminDashboardService {

    @Autowired
    private ad_campaignsRepository campaignsRepository;

    @Autowired
    private hitRecordRepository hitRecordRepository;

    @Autowired
    private PublisherRepository publisherRepository;

    @Autowired
    private usersRepository usersRepository;

    @Autowired
    private MongoTemplate mongoTemplate;

    private static final ZoneId ZONE_ID = ZoneId.systemDefault();
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ISO_LOCAL_DATE;

    /**
     * Retrieves dashboard data for an admin within a date range.
     * If companyUID is supplied it scopes the data to that company; otherwise it is resolved from the admin user.
     */
    public AdminDashboardResponse getDashboardData(String adminId, LocalDate startDate, LocalDate endDate, String companyUID) {
        // Resolve company ID
        String resolvedCompanyId = companyUID;
        if (resolvedCompanyId == null || resolvedCompanyId.isBlank()) {
            var adminUser = usersRepository.findById(adminId).orElse(null);
            if (adminUser != null) {
                resolvedCompanyId = adminUser.getCompanyUID();
            }
        }

        // Fetch advertisements scoped to company or fallback to adminId
        List<org.bson.Document> advertisements;
        if (resolvedCompanyId != null && !resolvedCompanyId.isBlank()) {
            Criteria companyCriteria = new Criteria();
            if (org.bson.types.ObjectId.isValid(resolvedCompanyId)) {
                companyCriteria.orOperator(
                    Criteria.where("company").is(new org.bson.types.ObjectId(resolvedCompanyId)),
                    Criteria.where("company").is(resolvedCompanyId)
                );
            } else {
                companyCriteria = Criteria.where("company").is(resolvedCompanyId);
            }
            Query adQuery = new Query(companyCriteria);
            advertisements = mongoTemplate.find(adQuery, org.bson.Document.class, "advertisements");
        } else {
            Criteria createdByCriteria = new Criteria();
            if (org.bson.types.ObjectId.isValid(adminId)) {
                createdByCriteria.orOperator(
                    Criteria.where("createdBy").is(new org.bson.types.ObjectId(adminId)),
                    Criteria.where("createdBy").is(adminId)
                );
            } else {
                createdByCriteria = Criteria.where("createdBy").is(adminId);
            }
            Query adQuery = new Query(createdByCriteria);
            advertisements = mongoTemplate.find(adQuery, org.bson.Document.class, "advertisements");
        }

        // Fetch campaigns for these advertisements supporting both ObjectId and String formats
        List<Object> adIdsForQuery = new java.util.ArrayList<>();
        for (org.bson.Document ad : advertisements) {
            Object idVal = ad.get("_id");
            if (idVal != null) {
                adIdsForQuery.add(idVal);
                if (idVal instanceof org.bson.types.ObjectId) {
                    adIdsForQuery.add(idVal.toString());
                } else if (idVal instanceof String && org.bson.types.ObjectId.isValid((String) idVal)) {
                    adIdsForQuery.add(new org.bson.types.ObjectId((String) idVal));
                }
            }
        }

        System.out.println("🔍 [AdminDashboardService] Scoped adIdsForQuery: " + adIdsForQuery);

        List<ad_campaigns> campaigns = Collections.emptyList();
        if (!adIdsForQuery.isEmpty()) {
            Query campQuery = new Query(Criteria.where("advertisementId").in(adIdsForQuery));
            campaigns = mongoTemplate.find(campQuery, ad_campaigns.class);
        }
        System.out.println("🔍 [AdminDashboardService] Found campaigns size: " + campaigns.size());

        // Gather campaign IDs for hit lookup
        List<String> campaignIds = campaigns.stream().map(ad_campaigns::getId).collect(Collectors.toList());

        // Fetch hit records for the requested date window
        Date start = Date.from(startDate.atStartOfDay(ZONE_ID).toInstant());
        Date end = Date.from(endDate.plusDays(1).atStartOfDay(ZONE_ID).toInstant());
        List<hitRecord> hits = Collections.emptyList();
        if (!campaignIds.isEmpty()) {
            hits = hitRecordRepository.findByCampaignIdInAndTimestampBetween(campaignIds, start, end);
        }

        // Compute KPIs
        long totalAds = advertisements.size();
        java.util.Date now = new java.util.Date();
        long activeAds = campaigns.stream()
                .filter(c -> "ACTIVE".equalsIgnoreCase(c.getCompaignsStatus()))
                .filter(c -> c.getDateRange() == null || c.getDateRange().getToDate() == null || !c.getDateRange().getToDate().before(now))
                .count();
        long expiredAds = campaigns.stream()
                .filter(c -> "EXPIRED".equalsIgnoreCase(c.getCompaignsStatus()) ||
                             (c.getDateRange() != null && c.getDateRange().getToDate() != null && c.getDateRange().getToDate().before(now)))
                .count();
        long totalCampaigns = campaigns.size();
        long totalPublishers = publisherRepository.countByAdminId(adminId);
        
        // Sum the actual payment transactions with status "SUCCESS" for this admin
        Query paymentQuery = new Query(Criteria.where("adminId").is(adminId).and("status").is("SUCCESS"));
        List<org.bson.Document> payments = mongoTemplate.find(paymentQuery, org.bson.Document.class, "payment_transactions");
        long totalSpend = 0;
        for (org.bson.Document p : payments) {
            Object amt = p.get("amount");
            if (amt instanceof Number) {
                totalSpend += ((Number) amt).longValue();
            }
        }
        
        long totalClicks = hits.stream().filter(h -> "AD_CLICK".equalsIgnoreCase(h.getEventType())).count();

        // Build time‑series chart data
        Map<String, AdminDashboardResponse.ChartData> dayDataMap = new LinkedHashMap<>();
        LocalDate cursor = startDate;
        while (!cursor.isAfter(endDate)) {
            String dateStr = cursor.format(DATE_FORMATTER);
            AdminDashboardResponse.ChartData chartData = new AdminDashboardResponse.ChartData();
            chartData.setDate(dateStr);
            chartData.setClicks(0);
            chartData.setImpressions(0);
            chartData.setSpend(0);
            dayDataMap.put(dateStr, chartData);
            cursor = cursor.plusDays(1);
        }
        for (hitRecord hit : hits) {
            String hitDate = hit.getTimestamp().toInstant().atZone(ZONE_ID).toLocalDate().format(DATE_FORMATTER);
            var dayData = dayDataMap.get(hitDate);
            if (dayData == null) continue;
            if ("AD_CLICK".equalsIgnoreCase(hit.getEventType())) {
                dayData.setClicks(dayData.getClicks() + 1);
            } else if ("AD_VIEW".equalsIgnoreCase(hit.getEventType())) {
                dayData.setImpressions(dayData.getImpressions() + 1);
            }
        }
        for (AdminDashboardResponse.ChartData dayData : dayDataMap.values()) {
            if (dayData.getImpressions() > 0) {
                long dailySpend = Math.round(dayData.getImpressions() * 1.5 + dayData.getClicks() * 5);
                dayData.setSpend(dailySpend);
            }
        }

        // Assemble response
        AdminDashboardResponse response = new AdminDashboardResponse();
        response.setTotalAds(totalAds);
        response.setActiveAds(activeAds);
        response.setExpiredAds(expiredAds);
        response.setTotalCampaigns(totalCampaigns);
        response.setTotalPublishers(totalPublishers);
        response.setTotalSpend(totalSpend);
        response.setTotalClicks(totalClicks);
        response.setPerformanceTrend(new ArrayList<>(dayDataMap.values()));
        response.setEngagementTrend(new ArrayList<>(dayDataMap.values()));
        response.setSpendVsPerformance(new ArrayList<>(dayDataMap.values()));
        return response;
    }
}