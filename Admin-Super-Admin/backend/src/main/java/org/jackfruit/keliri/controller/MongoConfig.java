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
@Value("${spring.data.mongodb.uri}")
	private String mongoUri;

	@Value("${spring.data.mongodb.database}")
	private String databaseName;

	@Bean
	public MongoDatabase mongoDatabase() {
		MongoClient mongoClient = MongoClients.create(mongoUri);
		return mongoClient.getDatabase(databaseName);
	}
}
