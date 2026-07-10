package org.jackfruit.keliri.service;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.jackfruit.keliri.model.SessionData;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;

@Service
public class SessionCSVLogger {

	
	 private static final String FILE = "session_analytics.csv";

	    private Path getPath() {
	        return Paths.get(System.getProperty("user.dir"), FILE);
	    }

	    @PostConstruct
	    public void init() throws IOException {
	        Path path = getPath();
	        if (!Files.exists(path)) {
	            Files.writeString(path,
	                "SessionID,IP,StartTime,EndTime,HitCount,Lat,Lng,AdsClicked,SearchKeywords,UserAgent\n"
	            );
	        }
	    }

	    public synchronized void write(SessionData s) {
	        String ads = String.join("|", s.ads);
	        String keywords = String.join("|", s.keywords);

	        String line = String.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%d\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"\n",
	            s.sessionId,
	            s.ip,
	            s.startTime,
	            s.endTime,
	            s.hitCount,
	            s.lat,
	            s.lng,
	            ads,
	            keywords,
	            s.userAgent.replace("\"", "'")
	        );

	        try (BufferedWriter writer = new BufferedWriter(
	                new FileWriter(getPath().toFile(), true))) {
	            writer.write(line);
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }
}
