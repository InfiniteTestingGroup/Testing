package org.jackfruit.keliri.repository;

import org.jackfruit.keliri.model.users_keliri;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface users_keliriRepository extends MongoRepository<users_keliri, String> {
	
	@Query(value ="{phoneNumber:?0}")
	boolean existsByPhoneNumber(String phno);
	
	@Query(value="{phoneNumber:?0}")
	users_keliri findByPhoneNumber(String phno);

}
