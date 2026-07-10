package org.jackfruit.keliri.controller;

import java.util.Map;

import org.springframework.core.env.Environment;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/config")
public class FrontendConfigController {
    private final Environment environment;

    public FrontendConfigController(Environment environment) {
        this.environment = environment;
    }

    @GetMapping("/maps")
    public ResponseEntity<Map<String, String>> getMapsConfig() {
        String apiKey = firstConfigured(
                "google.maps.api-key",
                "google.maps.apiKey",
                "maps.google.api-key",
                "GOOGLE_MAPS_API_KEY");

        return ResponseEntity.ok(Map.of("apiKey", apiKey == null ? "" : apiKey));
    }

    private String firstConfigured(String... keys) {
        for (String key : keys) {
            String value = environment.getProperty(key);
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return "";
    }
}
