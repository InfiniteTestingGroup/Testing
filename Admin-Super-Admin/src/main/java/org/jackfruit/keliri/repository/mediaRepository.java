package org.jackfruit.keliri.repository;

import org.bson.types.ObjectId;

import org.jackfruit.keliri.model.medias;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface mediaRepository extends MongoRepository<medias, String>{
	
	@Query(value="{_id:?0}", fields= "{'s3Location':1,'_id':0}")
	public String  findByS3Location(ObjectId id);
	
	@Query(fields= "{'s3Location':1,'_id':0}")
	public medias  findById(ObjectId id);
	
	@Query(fields= "{'s3Location':1,'_id':0}")
	public medias  findByUid(String uid);

}
