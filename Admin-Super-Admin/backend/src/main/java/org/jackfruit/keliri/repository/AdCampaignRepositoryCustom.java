package org.jackfruit.keliri.repository;

import java.util.List;

import org.jackfruit.keliri.model.ad_campaigns;
public interface AdCampaignRepositoryCustom {

	List<ad_campaigns> getbySelectedMode(String fieldName, int value);
}
