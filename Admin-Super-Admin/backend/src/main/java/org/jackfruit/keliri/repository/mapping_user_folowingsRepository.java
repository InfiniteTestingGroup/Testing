package org.jackfruit.keliri.repository;

import java.util.ArrayList;

import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.model.mapping_user_folowings;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface mapping_user_folowingsRepository extends MongoRepository<mapping_user_folowings, String>{

	@Query(value="{entityId:?0}",fields="{userId:1}")
	ArrayList<mapping_user_folowings> findbyentityId(ObjectId id);

	
}
