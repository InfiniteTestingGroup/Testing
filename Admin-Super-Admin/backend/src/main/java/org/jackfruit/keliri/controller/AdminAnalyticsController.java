package org.jackfruit.keliri.controller;

import io.jsonwebtoken.Claims;
import org.jackfruit.keliri.model.AdminAnalyticsResponse;
import org.jackfruit.keliri.service.AdminAnalyticsService;
import org.jackfruit.keliri.service.JwtService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/analytics")
public class AdminAnalyticsController {

    @Autowired
    private AdminAnalyticsService analyticsService;

    @Autowired
    private JwtService jwtService;

    @GetMapping
    public ResponseEntity<?> getAnalytics(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(defaultValue = "All") String adId,
            @RequestParam(defaultValue = "All") String publisherId,
            @RequestParam(defaultValue = "All") String adType,
            @RequestParam(defaultValue = "All") String status,
            @RequestParam(required = false) String companyUID) {

        try {
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("success", false, "message", "Missing or invalid Authorization header"));
            }

            String token = authHeader.substring(7);
            Claims claims = jwtService.parseToken(token);
            String adminId = claims.get("userId", String.class);

            if (adminId == null || adminId.isEmpty()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("success", false, "message", "Invalid token: missing userId"));
            }

            // Default date range if not provided: Last 30 days
            if (endDate == null) endDate = LocalDate.now();
            if (startDate == null) startDate = endDate.minusDays(30);

            AdminAnalyticsResponse analytics = analyticsService.getAnalytics(
                    adminId, startDate, endDate, adId, publisherId, adType, status, companyUID);

            return ResponseEntity.ok(analytics);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Internal server error: " + e.getMessage()));
        }
    }
}
