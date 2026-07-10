package org.jackfruit.keliri.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;

import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.repository.ad_campaignsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.repository.query.FluentQuery.FetchableFluentQuery;
import org.springframework.stereotype.Service;


@Service
public class ad_campaignsservice  {

	@Autowired
	ad_campaignsRepository ad_campaignsrepo;
	
	
	
	
	 public List<ad_campaigns> getCampaignsByDynamicField(String fieldName, int value) {
		 System.out.println("in service");
	        return ad_campaignsrepo.getbySelectedMode(fieldName, value);
	    }

}
