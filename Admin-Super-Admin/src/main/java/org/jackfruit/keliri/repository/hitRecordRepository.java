package org.jackfruit.keliri.repository;

import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.hitRecord;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface hitRecordRepository extends MongoRepository<hitRecord, ObjectId>{

}
