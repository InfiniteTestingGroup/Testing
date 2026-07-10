package org.jackfruit.keliri.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

import java.util.List;

import org.jackfruit.keliri.model.ad_campaigns;

public class ad_campaignsRepositoryImpl implements AdCampaignRepositoryCustom {
	 @Autowired
	    private MongoTemplate mongoTemplate;

	    @Override
	    public List<ad_campaigns> getbySelectedMode(String fieldName, int value) {
	    //	System.out.println("in IMPL" +fieldName);
	       // Query query = new Query(Criteria.where(fieldName).is(value));// not checking two conditions 
	        
	    	   Criteria criteria = new Criteria()
	    	            .and(fieldName).is(value)
	    	            .and("compaignsStatus").is("ACTIVE");

	    	   Query query = new Query(criteria);
	        // Print the query structure
	        //System.out.println("Mongo Query: " + query.getQueryObject().toJson());

	        // Execute query and get results
	        List<ad_campaigns> results = mongoTemplate.find(query, ad_campaigns.class);

	        // Print result count and each document
	      //  System.out.println("Query returned " + results.size() + " documents:");
	       // results.forEach(System.out::println);
	        return results;
	    }

}
