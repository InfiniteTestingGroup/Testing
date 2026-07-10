package org.jackfruit.keliri.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mongodb.MongoClientException;
import com.mongodb.client.MongoDatabase;

@RestController
@RequestMapping("/api/health")
public class healthController {
	 @Autowired
	    private MongoDatabase mongoDatabase;

	    @GetMapping("/check")
	    public String checkMongoConnection() {
	        try {
	            mongoDatabase.runCommand(new org.bson.Document("ping", 1));
	            return "MongoDB connection is successful";
	        } catch (MongoClientException e) {
	            return "Failed to connect to MongoDB: " + e.getMessage();
	        }
	    }
}
