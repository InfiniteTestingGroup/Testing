package org.jackfruit.keliri.repository;

import java.util.List;
import java.util.Optional;

import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.model.users;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface usersRepository extends MongoRepository<users, String>{
	
	 @Query(fields="{'lastKnownLocation':1}")
	public Optional<users> findById(String id) ;
	
	@Query(value = "{userType:'PUBLISHER'}", fields="{'fullName':1,'emailAddress':1,'phoneNumber.dialNumber':1,'lastKnownLocation':1}")
	 List<users> findAll();
	 
	 @Query(value = "{_id:?0}", fields="{'emailAddress':1,'phoneNumber.dialNumber':1,'phoneNumber.countryCode':1,'fullName':1}")
	 public Optional<users> findByIdphandemail(String id) ;
	 
	 @Query(value="{'fullName': {$regex:'.*?0.*', $options:'i'} }")//,fields ="{'_id':1}"
	    List<users> searchAllFields(String keyword);
	    
	 @Query(value="{'givendor':1}",fields="{'fullName':1,'emailAddress':1,'phoneNumber.dialNumber':1,'lastKnownLocation':1,'givendor':1}")
	 List<users> findbygivendor();
	 
}
