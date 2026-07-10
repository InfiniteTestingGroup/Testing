package org.jackfruit.keliri.model;

import java.time.Instant;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

public class SessionData {
	public String sessionId;
    public String ip;
    public String userAgent;
    /*public Instant startTime ;
    public Instant endTime;*/
    
    public ZonedDateTime startTime ;
    public ZonedDateTime endTime;
    
    public int hitCount = 0;
    public List<String> ads = new ArrayList<>();
    public List<String> keywords = new ArrayList<>();
    public String lat;
    public String lng;
	
}
