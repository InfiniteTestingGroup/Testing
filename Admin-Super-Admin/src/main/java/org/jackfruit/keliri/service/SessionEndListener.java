package org.jackfruit.keliri.service;

import java.time.ZoneId;
import java.time.ZonedDateTime;

import org.jackfruit.keliri.model.SessionData;
import org.springframework.stereotype.Component;

import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

@Component
public class SessionEndListener implements HttpSessionListener {

    private final SessionActivityService activity;
    private final SessionCSVLogger logger;

    public SessionEndListener(SessionActivityService activity, SessionCSVLogger logger) {
        this.activity = activity;
        this.logger = logger;
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // nothing needed here
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        String sessionId = se.getSession().getId();
        SessionData data = activity.get(sessionId);
        if (data != null) {
         //   data.endTime = java.time.Instant.now();
        	 data.endTime =ZonedDateTime.now(ZoneId.of("Asia/Kolkata"));
            data.sessionId = sessionId;
            logger.write(data);
            activity.remove(sessionId);
        }
    }

}
