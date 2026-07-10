package org.jackfruit.keliri.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.jackfruit.keliri.model.action;
import org.jackfruit.keliri.model.advertisements;
import org.jackfruit.keliri.model.buttonActionDTO;
import org.jackfruit.keliri.model.cta;
import org.jackfruit.keliri.repository.advertisementsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

@Service
public class advertisementService {

	 @Autowired
	    private MongoTemplate mongoTemplate;

	    @Autowired
	    private advertisementsRepository advertisementRepository;

	    /*** ----------------------- TEMPLATE APPROACH ----------------------- ***/
	/*    public List<buttonActionDTO> getCtaButtonActionsByCreatedByTemplate(String id) {
	        Query query = new Query();
	        query.addCriteria(Criteria.where("_id").is(id).and("cta").exists(true));
	        query.fields().include("cta.buttons.ctaId").include("cta.buttons.content.action");

	        List<advertisements> adsWithCta = mongoTemplate.find(query, advertisements.class, "advertisements");

	        List<buttonActionDTO> buttonActions = new ArrayList<>();
	        for (advertisements ad : adsWithCta) {
	            cta ctaObj = ad.getCta();
	            if (ctaObj != null && ctaObj.getButtons() != null) {
	                buttonActions.addAll(
	                    ctaObj.getButtons().stream()
	                        .filter(btn -> btn.getCtaId() != null
	                                     && btn.getContent() != null
	                                     && btn.getContent().getAction() != null)
	                        .map(btn -> new buttonActionDTO(btn.getCtaId(), btn.getContent().getAction()))
	                        .collect(Collectors.toList())
	                );
	            }
	        }
	        return buttonActions;
	    }*/

	    /*** ----------------------- REPOSITORY APPROACH ----------------------- ***/
	/*    public List<ButtonActionDTO> getCtaButtonActionsByCreatedByRepo(String createdBy) {
	        List<advertisements> ads = advertisementRepository.findCtaButtonsByCreatedBy(createdBy);

	        List<ButtonActionDTO> buttonActions = new ArrayList<>();
	        for (advertisements ad : ads) {
	            cta ctaObj = ad.getCta();
	            if (ctaObj != null && ctaObj.getButtons() != null) {
	                buttonActions.addAll(
	                    ctaObj.getButtons().stream()
	                        .filter(btn -> btn.getCtaId() != null
	                                     && btn.getContent() != null
	                                     && btn.getContent().getAction() != null)
	                        .map(btn -> new ButtonActionDTO(btn.getCtaId(), btn.getContent().getAction()))
	                        .collect(Collectors.toList())
	                );
	            }
	        }
	        return buttonActions;
	    }*/
	    
	    public List<buttonActionDTO> getCtaButtonActionsByCreatedByTemplate(String id) { 
	  /*  Query query = new Query();
        query.addCriteria(Criteria.where("_id").is(id).and("cta").exists(true));
        query.fields().include("cta.buttons.ctaId").include("cta.buttons.content.action");

        List<advertisements> adsWithCta = mongoTemplate.find(query, advertisements.class, "advertisements");

        List<buttonActionDTO> buttonActions = new ArrayList<>();
        for (advertisements ad : adsWithCta) {
            cta ctaObj = ad.getCta();
            if (ctaObj != null && ctaObj.getButtons() != null) {
                buttonActions.addAll(
                    ctaObj.getButtons().stream()
                        .filter(btn -> btn.getCtaId() != null
                                && btn.getContent() != null
                                && btn.getContent().getAction() != null)
                        .map(btn -> {
                            Object actionObj = btn.getContent().getAction();
                            String actionValue = null;

                            // Case 1: action is a String
                            if (actionObj instanceof String) {
                                actionValue = (String) actionObj;
                            }

                            // Case 2: action is an Object with lat/lng
                            else if (actionObj instanceof Map) {
                                Map<?, ?> map = (Map<?, ?>) actionObj;
                                Object lat = map.get("latitude");
                                Object lng = map.get("longitude");

                                if (lat != null && lng != null) {
                                    actionValue = "lat=" + lat.toString() + ", lng=" + lng.toString();
                                } else {
                                    actionValue = "No coordinates available";
                                }
                            }

                            return new buttonActionDTO(btn.getCtaId().toString(), actionValue);
                        })
                        .collect(Collectors.toList())
                );
            }
        }
        return buttonActions;*/
	    	
	    	  Query query = new Query();
	          query.addCriteria(Criteria.where("_id").is(id).and("cta").exists(true));
	          query.fields().include("cta.buttons.ctaId").include("cta.buttons.content.action");

	          List<advertisements> adsWithCta = mongoTemplate.find(query, advertisements.class, "advertisements");

	          List<buttonActionDTO> buttonActions = new ArrayList<>();
	          for (advertisements ad : adsWithCta) {
	              cta ctaObj = ad.getCta();
	              if (ctaObj != null && ctaObj.getButtons() != null) {
	                  buttonActions.addAll(
	                      ctaObj.getButtons().stream()
	                          .filter(btn -> btn.getCtaId() != null
	                                  && btn.getContent() != null
	                                  && btn.getContent().getAction() != null)
	                          .map(btn -> {
	                              Object actionObj = btn.getContent().getAction();

	                              // Case 1: action is a simple String
	                              if (actionObj instanceof String) {
	                                  return new buttonActionDTO(btn.getCtaId().toString(), (String) actionObj);
	                              }

	                              // Case 2: action is a Map with latitude/longitude
	                              else if (actionObj instanceof Map) {
	                                  Map<?, ?> map = (Map<?, ?>) actionObj;
	                                  Double lat = map.get("latitude") instanceof Number ? ((Number) map.get("latitude")).doubleValue() : null;
	                                  Double lng = map.get("longitude") instanceof Number ? ((Number) map.get("longitude")).doubleValue() : null;

	                                  if (lat != null && lng != null) {
	                                      return new buttonActionDTO(btn.getCtaId().toString(), lat, lng);
	                                  } else {
	                                      return new buttonActionDTO(btn.getCtaId().toString(), (String) null);
	                                  }
	                              }

	                              return null;
	                          })
	                          .filter(dto -> dto != null)
	                          .collect(Collectors.toList())
	                  );
	              }
	          }
	          return buttonActions;
	      }
	    }
	    	

