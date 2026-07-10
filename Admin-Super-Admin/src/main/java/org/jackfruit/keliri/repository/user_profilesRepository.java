package org.jackfruit.keliri.repository;

import java.util.Optional;

import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.user_profiles;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface user_profilesRepository extends MongoRepository<user_profiles, String>{
	
     @Query(value="{userId:?0}",fields="{'profilePicture':1,'_id':0}")
	 user_profiles findByuserId(ObjectId id) ;
		

}
