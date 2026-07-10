package org.jackfruit.keliri.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/health")
public class healthController {
	 @Autowired
	    private MongoTemplate mongoTemplate;

	    @GetMapping("/ping")
	    public String ping() {
	        return "Backend is running";
	    }

	    @GetMapping("/check")
	    public String checkMongoConnection() {
	        try {
	            mongoTemplate.getDb().runCommand(new org.bson.Document("ping", 1));
	            return "MongoDB connection is successful";
	        } catch (RuntimeException e) {
	            return "Failed to connect to MongoDB: " + e.getMessage();
	        }
	    }
}
