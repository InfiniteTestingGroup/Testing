package org.jackfruit.keliri.model;

import java.time.Instant;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.web.bind.support.SessionStatus;

@Document(collection = "tracking_sessions")
public class TrackingSession {

	@Id
	private String id;
	private String userId;
	private TrackingMode mode;
	private Instant startedAt;
	private Instant endedAt;
	private SessionStatus status;
	private long totalPoints;
}
