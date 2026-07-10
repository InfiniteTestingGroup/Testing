package org.jackfruit.keliri.service;

import java.util.List;

import org.jackfruit.keliri.model.ad_campaigns;
import org.springframework.beans.factory.annotation.Autowired;

public interface ad_campaignsServices {
	public List<ad_campaigns> findByLat(String lat, String lng);
	
	
	   
}
