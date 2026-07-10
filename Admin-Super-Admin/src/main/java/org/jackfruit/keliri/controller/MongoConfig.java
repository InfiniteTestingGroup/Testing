package org.jackfruit.keliri.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;

@Component
@Configuration
public class MongoConfig {
	@Value("${mongodb.uri:}")
	private String mongoUri;

	@Value("${mongodb.database:keliri_production}")
	private String databaseName;

	 @Bean
	    public MongoDatabase mongoDatabase() {
	       MongoClient mongoClient = MongoClients.create(mongoUri);
	       return mongoClient.getDatabase(databaseName);
	    }
}
