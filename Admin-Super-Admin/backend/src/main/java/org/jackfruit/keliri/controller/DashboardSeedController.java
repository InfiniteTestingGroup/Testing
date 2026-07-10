package org.jackfruit.keliri.controller;

import java.util.Map;

import org.jackfruit.keliri.model.DashboardSeedRequest;
import org.jackfruit.keliri.service.DashboardSeedService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/superadmin/test")
public class DashboardSeedController {
    private final DashboardSeedService dashboardSeedService;

    public DashboardSeedController(DashboardSeedService dashboardSeedService) {
        this.dashboardSeedService = dashboardSeedService;
    }

    @PostMapping("/seed-dashboard")
    public ResponseEntity<Map<String, Object>> seedDashboard(@RequestBody DashboardSeedRequest request) {
        return ResponseEntity.ok(dashboardSeedService.seed(request));
    }
}
