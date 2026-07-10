package org.jackfruit.keliri.controller;

import org.jackfruit.keliri.model.SuperAdminAnalyticsResponse;
import org.jackfruit.keliri.model.SuperAdminRevenueResponse;
import org.jackfruit.keliri.service.SuperAdminAnalyticsService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/superadmin/analytics")
public class SuperAdminAnalyticsController {
    private final SuperAdminAnalyticsService analyticsService;

    public SuperAdminAnalyticsController(SuperAdminAnalyticsService analyticsService) {
        this.analyticsService = analyticsService;
    }

    @GetMapping
    public ResponseEntity<SuperAdminAnalyticsResponse> getAnalytics(
            @RequestParam(defaultValue = "LAST_30_DAYS") String range,
            @RequestParam(required = false) String adType) {
        return ResponseEntity.ok(analyticsService.getAnalytics(range, adType));
    }

    @GetMapping("/summary")
    public ResponseEntity<SuperAdminAnalyticsResponse> getAnalyticsSummary() {
        return ResponseEntity.ok(analyticsService.getAnalyticsSummary());
    }

    @GetMapping("/revenue")
    public ResponseEntity<SuperAdminRevenueResponse> getRevenueAnalytics() {
        return ResponseEntity.ok(analyticsService.getRevenueAnalytics());
    }
}
