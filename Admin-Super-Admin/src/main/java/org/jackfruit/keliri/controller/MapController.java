package org.jackfruit.keliri.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;


@RestController
	public class MapController {

    @Value("${google.maps.api.key}")
    private String googleMapsApiKey;
	 @GetMapping("/searchPlaceAjax")
	    public Map<String, Object> searchPlace(@RequestParam("place") String place) {
	        try {
	        //	System.out.println("Place : "+place);
	            String encoded = URLEncoder.encode(place, StandardCharsets.UTF_8);
	            String url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + encoded + "&key=" + googleMapsApiKey;

	            RestTemplate rest = new RestTemplate();
	            Map response = rest.getForObject(url, Map.class);

	            if (!"OK".equals(response.get("status"))) {
	                return Map.of("status", "NOT_FOUND");
	            }

	            Map location = (Map) ((Map) ((Map)
	                    ((List) response.get("results")).get(0))
	                    .get("geometry")).get("location");

	            return Map.of(
	                    "status", "OK",
	                    "lat", location.get("lat"),
	                    "lng", location.get("lng")
	            );

	        } catch (Exception e) {
	            return Map.of("status", "ERROR", "message", e.getMessage());
	        }
	    }


}
