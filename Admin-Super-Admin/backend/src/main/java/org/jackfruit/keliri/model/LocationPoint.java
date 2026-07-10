package org.jackfruit.keliri.model;

import java.time.Instant;

import org.springframework.data.annotation.Id;

public class LocationPoint {
	
	@Id
	private String id;
	private String sessionId;
	private String userId;
	private double lat;
	private double lng;
	private float accuracy;
	private Float speed;
	private Float bearing;
	private Instant timestamp;

}
