package org.jackfruit.keliri.repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.Content;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.model.advertisements;
import org.jackfruit.keliri.model.companies;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface advertisementsRepository extends MongoRepository<advertisements, String>{
	
//	@Query(fields="{'title':1,'description':1,'company':1}")
@Query(	value="{'$and':[{'_id':?0},{'company':{'$in':?1}}]}",fields="{'title':1,'description':1,'company':1}")
public Optional<advertisements> findById(String id,ArrayList<ObjectId> categories);
	
@Query(	fields="{'title':1,'description':1,'company':1,'thumbnail':1,'adType':1,'customTextSection':1,'gitagnumber':1}")
public Optional<advertisements> findById(String id);
//{'campaignCategories':{ '$in':?0 }}

@Query(value="{'_id':?0}",	fields="{'customTextSection':1}")
public Optional<advertisements> findByIdCustom(String id);


@Query(value="{'_id':?0}",fields="{'content':1,'_id':0}")
advertisements findbyContent(ObjectId id);


/*@Query(value="{'$or': [" +
        "{'title': {$regex: ?0, $options: 'i'}}, " +  // 'i' for case-insensitive
        "{'description': {$regex: ?0, $options: 'i'}}, " +
        "{'customTextSection': {$elemMatch: {'$or': [" +
        "{'title': {$regex: ?0, $options: 'i'}}, " +  // Search by 'type'
        "{'description': {$regex: ?0, $options: 'i'}}" +  // Search by 'number'
    "]} } } " +
        "]}",fields="{'_id':1,'title':1,'description':1,'adType':1,'thumbnail':1,'content':1,'customTextSection':1}")*/
@Query(value="{'$or': [" +
        "{'title': {$regex: ?0, $options: 'i'}}, " +  // 'i' for case-insensitive
        "{'description': {$regex: ?0, $options: 'i'}}, " +
        "{'customTextSection': {$elemMatch: {'$or': [" +
        "{'title': {$regex: ?0, $options: 'i'}}, " +  // Search by 'type'
        "{'description': {$regex: ?0, $options: 'i'}}" +  // Search by 'number'
    "]} } } " +
        "]}",fields="{'_id':1}")//,fields="{'_id':1}"
List<advertisements> searchAllFields(String keyword);

@Query(value = "{'company': { '$in': ?0 } }",fields = "{'_id':1}") //get ad ids
List<advertisements> searchByCompanyId(List<ObjectId> list2);

@Query(value="{'$and':[{'createdBy':?0},{'gitagnumber':?1}]}",fields="{'_id':1}")
ArrayList<advertisements> showvendorsfindByCreatedBy(ObjectId id, int gitagnumber);
}
