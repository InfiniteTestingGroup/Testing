package org.jackfruit.keliri.service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.jackfruit.keliri.model.SessionData;
import org.springframework.stereotype.Service;

@Service
public class SessionActivityService {
	  private final Map<String, SessionData> sessions = new ConcurrentHashMap<>();

	    public SessionData get(String sessionId) {
	        return sessions.computeIfAbsent(sessionId, id -> new SessionData());
	    }

	    public void remove(String sessionId) {
	        sessions.remove(sessionId);
	    }

}
