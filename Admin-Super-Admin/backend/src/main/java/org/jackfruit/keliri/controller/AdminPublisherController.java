package org.jackfruit.keliri.controller;

import io.jsonwebtoken.Claims;
import org.jackfruit.keliri.model.Publisher;
import org.jackfruit.keliri.model.PublisherAnalyticsResponse;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.model.hitRecord;
import org.jackfruit.keliri.repository.PublisherRepository;
import org.jackfruit.keliri.repository.companiesRepository;
import org.jackfruit.keliri.model.companies;
import org.jackfruit.keliri.repository.ad_campaignsRepository;
import org.jackfruit.keliri.repository.hitRecordRepository;
import org.jackfruit.keliri.service.JwtService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin/publishers")
public class AdminPublisherController {

    @Autowired
    private PublisherRepository publisherRepository;
    @Autowired
    private companiesRepository companiesRepo;

    @Autowired
    private ad_campaignsRepository campaignsRepository;

    @Autowired
    private hitRecordRepository hitRecordRepository;

    @Autowired
    private JwtService jwtService;

    private static final ZoneId ZONE_ID = ZoneId.systemDefault();
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd");

    // ──────────────────────────────────────────────
    // GET All Publishers for Logged-In Admin
    // ──────────────────────────────────────────────
   @GetMapping
public ResponseEntity<?> getPublishersForAdmin(
    
        @RequestHeader(value = "Authorization", required = false) String authHeader,
        @RequestParam(required = false) String adminId) {
    System.out.println("JWT Admin ID = " + extractAdminId(authHeader));
    System.out.println("Publishers found = " + companiesRepo.findByAdminId(extractAdminId(authHeader)).size());
    try {

        if (adminId != null && !adminId.isBlank()) {
            return ResponseEntity.ok(
                    Map.of(
                            "success", true,
                            "publishers", companiesRepo.findByAdminId(adminId)
                    )
            );
        }

        String loggedInAdminId = extractAdminId(authHeader);
        if (loggedInAdminId == null) return unauthorized();

        return ResponseEntity.ok(
                Map.of(
                        "success", true,
                        "publishers", companiesRepo.findByAdminId(loggedInAdminId)
                )
        );

    } catch (Exception e) {
        return serverError(e);
    }
}

    // ──────────────────────────────────────────────
    // GET Single Publisher by ID
    // ──────────────────────────────────────────────
    @GetMapping("/{publisherId}")
    public ResponseEntity<?> getPublisherById(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @PathVariable String publisherId) {
        try {
            String adminId = extractAdminId(authHeader);
            if (adminId == null) return unauthorized();

            Optional<companies> opt = companiesRepo.findById(publisherId);
            if (opt.isEmpty()) return notFound("Publisher not found");
            if (!opt.get().getAdminId().equals(adminId)) return unauthorized();

            return ResponseEntity.ok(Map.of("success", true, "publisher", opt.get()));
        } catch (Exception e) {
            return serverError(e);
        }
    }

    // ──────────────────────────────────────────────
    // POST Create Publisher
    // ──────────────────────────────────────────────
    @PostMapping
    public ResponseEntity<?> createPublisher(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestBody Publisher publisherRequest) {
        try {
            String adminId = extractAdminId(authHeader);
            if (adminId == null) return unauthorized();

            if (publisherRequest.getName() == null || publisherRequest.getName().trim().isEmpty())
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Publisher Name is required"));
            if (publisherRequest.getEmail() == null || publisherRequest.getEmail().trim().isEmpty())
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Email ID is required"));
            if (publisherRequest.getMobile() == null || publisherRequest.getMobile().trim().isEmpty())
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "Mobile Number is required"));

            Optional<companies> existingEmail = companiesRepo.findByEmail(publisherRequest.getEmail());
            if (existingEmail.isPresent())
                return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of("success", false, "message", "Publisher with this email already exists"));

            Optional<companies> existingMobile = companiesRepo.findByMobile(publisherRequest.getMobile());
            if (existingMobile.isPresent())
                return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of("success", false, "message", "Publisher with this mobile already exists"));

            Publisher publisher = new Publisher();
            publisher.setName(publisherRequest.getName());
            publisher.setContactPerson(publisherRequest.getContactPerson());
            publisher.setMobile(publisherRequest.getMobile());
            publisher.setEmail(publisherRequest.getEmail());
            publisher.setAddress(publisherRequest.getAddress());
            publisher.setLocation(publisherRequest.getLocation());
            publisher.setAdminId(adminId);
            publisher.setStatus("ACTIVE");
            publisher.setCreatedAt(Instant.now());

            // No need to save to publisherRepository, we just save to companiesRepo
            // Also persist to companies collection
            companies company = new companies();
            company.setName(publisher.getName());
            company.setEmail(publisher.getEmail());
            company.setMobile(publisher.getMobile());
            company.setAddress(publisher.getAddress());
            company.setLocation(publisher.getLocation());
            company.setAdminId(adminId);
            company.setStatus(publisher.getStatus());
            company.setCreatedAt(publisher.getCreatedAt());
            company.setContactPerson(publisher.getContactPerson());
            companiesRepo.save(company);
            return ResponseEntity.ok(Map.of("success", true, "message", "Publisher created successfully", "publisher", company));
        } catch (Exception e) {
            return serverError(e);
        }
    }

    // ──────────────────────────────────────────────
    // PUT Update Publisher
    // ──────────────────────────────────────────────
    @PutMapping("/{publisherId}")
    public ResponseEntity<?> updatePublisher(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @PathVariable String publisherId,
            @RequestBody Publisher updateRequest) {
        try {
            String adminId = extractAdminId(authHeader);
            if (adminId == null) return unauthorized();

            Optional<companies> opt = companiesRepo.findById(publisherId);
            if (opt.isEmpty()) return notFound("Publisher not found");

            companies publisher = opt.get();
            if (!publisher.getAdminId().equals(adminId)) return unauthorized();

            // Update only the allowed fields
            if (updateRequest.getName() != null && !updateRequest.getName().trim().isEmpty())
                publisher.setName(updateRequest.getName());
            if (updateRequest.getContactPerson() != null)
                publisher.setContactPerson(updateRequest.getContactPerson());
            if (updateRequest.getMobile() != null && !updateRequest.getMobile().trim().isEmpty())
                publisher.setMobile(updateRequest.getMobile());
            if (updateRequest.getEmail() != null && !updateRequest.getEmail().trim().isEmpty())
                publisher.setEmail(updateRequest.getEmail());
            if (updateRequest.getAddress() != null)
                publisher.setAddress(updateRequest.getAddress());
            if (updateRequest.getLocation() != null)
                publisher.setLocation(updateRequest.getLocation());

            companiesRepo.save(publisher);
            return ResponseEntity.ok(Map.of("success", true, "message", "Publisher updated successfully", "publisher", publisher));
        } catch (Exception e) {
            return serverError(e);
        }
    }

    // ──────────────────────────────────────────────
    // PATCH Toggle Publisher Status
    // ──────────────────────────────────────────────
    @PatchMapping("/{publisherId}/status")
    public ResponseEntity<?> togglePublisherStatus(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @PathVariable String publisherId) {
        try {
            String adminId = extractAdminId(authHeader);
            if (adminId == null) return unauthorized();

            Optional<companies> opt = companiesRepo.findById(publisherId);
            if (opt.isEmpty()) return notFound("Publisher not found");

            companies publisher = opt.get();
            if (!publisher.getAdminId().equals(adminId)) return unauthorized();

            String newStatus = "ACTIVE".equalsIgnoreCase(publisher.getStatus()) ? "INACTIVE" : "ACTIVE";
            publisher.setStatus(newStatus);
            companiesRepo.save(publisher);

            String displayStatus = "ACTIVE".equals(newStatus) ? "Active" : "Inactive";
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Publisher is now " + displayStatus,
                    "status", newStatus,
                    "publisher", publisher));
        } catch (Exception e) {
            return serverError(e);
        }
    }

    // ──────────────────────────────────────────────
    // GET Publisher Analytics (Performance Data)
    // ──────────────────────────────────────────────
    @GetMapping("/{publisherId}/analytics")
    public ResponseEntity<?> getPublisherAnalytics(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @PathVariable String publisherId) {
        try {
            String adminId = extractAdminId(authHeader);
            if (adminId == null) return unauthorized();

            Optional<companies> opt = companiesRepo.findById(publisherId);
            if (opt.isEmpty()) return notFound("Publisher not found");

            companies publisher = opt.get();
            if (!publisher.getAdminId().equals(adminId)) return unauthorized();

            // Get all campaigns for this admin
            List<ad_campaigns> allCampaigns = campaignsRepository.findByCreatedByObjectId(new org.bson.types.ObjectId(adminId));
            long totalAds = allCampaigns.size();
            long activeCampaigns = allCampaigns.stream()
                    .filter(c -> "ACTIVE".equalsIgnoreCase(c.getCompaignsStatus()))
                    .count();

            List<String> campaignIds = allCampaigns.stream()
                    .map(ad_campaigns::getId)
                    .collect(Collectors.toList());

            // Fetch hits from last 14 days
            Date fourteenDaysAgo = Date.from(Instant.now().minusSeconds(14L * 24 * 60 * 60));
            List<hitRecord> hits = new ArrayList<>();
            if (!campaignIds.isEmpty()) {
                hits = hitRecordRepository.findByCampaignIdInAndTimestampAfter(campaignIds, fourteenDaysAgo);
            }

            // Filter hits near publisher's location (5km radius)
            List<hitRecord> nearbyHits = filterHitsNearPublisher(hits, publisher);

            long impressions = nearbyHits.stream()
                    .filter(h -> "AD_VIEW".equalsIgnoreCase(h.getEventType()) || "PAGE_HIT".equalsIgnoreCase(h.getEventType()))
                    .count();
            long clicks = nearbyHits.stream()
                    .filter(h -> "AD_CLICK".equalsIgnoreCase(h.getEventType()))
                    .count();
            double ctr = impressions > 0 ? Math.round((double) clicks / impressions * 10000.0) / 100.0 : 0;

            // Build 14-day trend
            Map<String, PublisherAnalyticsResponse.TrendData> trendMap = new LinkedHashMap<>();
            LocalDate today = LocalDate.now(ZONE_ID);
            for (int i = 13; i >= 0; i--) {
                LocalDate date = today.minusDays(i);
                String dateKey = date.toString();
                PublisherAnalyticsResponse.TrendData td = new PublisherAnalyticsResponse.TrendData();
                td.setDate(date.format(DATE_FORMATTER));
                td.setImpressions(0);
                td.setClicks(0);
                trendMap.put(dateKey, td);
            }

            for (hitRecord hit : nearbyHits) {
                String hitDate = hit.getTimestamp().toInstant().atZone(ZONE_ID).toLocalDate().toString();
                if (trendMap.containsKey(hitDate)) {
                    PublisherAnalyticsResponse.TrendData td = trendMap.get(hitDate);
                    if ("AD_CLICK".equalsIgnoreCase(hit.getEventType())) {
                        td.setClicks(td.getClicks() + 1);
                    } else {
                        td.setImpressions(td.getImpressions() + 1);
                    }
                }
            }

            // Build campaign list
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            List<PublisherAnalyticsResponse.CampaignData> campaignDataList = allCampaigns.stream()
                    .limit(10)
                    .map(c -> {
                        PublisherAnalyticsResponse.CampaignData cd = new PublisherAnalyticsResponse.CampaignData();
                        cd.setId(c.getId());
                        cd.setTitle(c.getA() != null && c.getA().getTitle() != null ? c.getA().getTitle() : "Campaign " + c.getId().substring(Math.max(0, c.getId().length() - 6)));
                        cd.setStatus(c.getCompaignsStatus() != null ? c.getCompaignsStatus() : "UNKNOWN");

                        if (c.getDateRange() != null) {
                            cd.setStartDate(c.getDateRange().getFromDate() != null ? c.getDateRange().getFromDate().toInstant().atZone(ZONE_ID).toLocalDate().format(dtf) : "-");
                            cd.setEndDate(c.getDateRange().getToDate() != null ? c.getDateRange().getToDate().toInstant().atZone(ZONE_ID).toLocalDate().format(dtf) : "-");
                        } else {
                            cd.setStartDate("-");
                            cd.setEndDate("-");
                        }

                        // Count hits for this specific campaign
                        long campImpressions = nearbyHits.stream()
                                .filter(h -> c.getId().equals(h.getCampaignId()))
                                .filter(h -> !"AD_CLICK".equalsIgnoreCase(h.getEventType()))
                                .count();
                        long campClicks = nearbyHits.stream()
                                .filter(h -> c.getId().equals(h.getCampaignId()) && "AD_CLICK".equalsIgnoreCase(h.getEventType()))
                                .count();
                        double campCtr = campImpressions > 0 ? Math.round((double) campClicks / campImpressions * 10000.0) / 100.0 : 0;

                        cd.setImpressions(campImpressions);
                        cd.setClicks(campClicks);
                        cd.setCtr(campCtr);
                        return cd;
                    })
                    .collect(Collectors.toList());

            // Assemble response
            PublisherAnalyticsResponse.Stats stats = new PublisherAnalyticsResponse.Stats();
            stats.setTotalAds(totalAds);
            stats.setActiveCampaigns(activeCampaigns);
            stats.setImpressions(impressions);
            stats.setClicks(clicks);
            stats.setCtr(ctr);

            PublisherAnalyticsResponse analytics = new PublisherAnalyticsResponse();
            analytics.setStats(stats);
            analytics.setTrends(new ArrayList<>(trendMap.values()));
            analytics.setCampaigns(campaignDataList);

            return ResponseEntity.ok(Map.of("success", true, "analytics", analytics, "publisher", publisher));
        } catch (Exception e) {
            e.printStackTrace();
            return serverError(e);
        }
    }

    // ──────────────────────────────────────────────
    // Helpers
    // ──────────────────────────────────────────────
    private List<hitRecord> filterHitsNearPublisher(List<hitRecord> hits, companies publisher) {
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
                    return haversineKm(pLat, pLng, hLat, hLng) <= 5.0;
                } catch (Exception e) { return false; }
            }).collect(Collectors.toList());
        } catch (NumberFormatException e) {
            return hits;
        }
    }

    private double haversineKm(double lat1, double lon1, double lat2, double lon2) {
        final double R = 6371.0;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    }

    private String extractAdminId(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) return null;
        try {
            Claims claims = jwtService.parseToken(authHeader.substring(7));
            return claims.get("userId", String.class);
        } catch (Exception e) { return null; }
    }

    private ResponseEntity<?> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(Map.of("success", false, "message", "Unauthorized"));
    }

    private ResponseEntity<?> notFound(String message) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(Map.of("success", false, "message", message));
    }

    private ResponseEntity<?> serverError(Exception e) {
        e.printStackTrace();
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", "Internal server error: " + e.getMessage()));
    }
}
