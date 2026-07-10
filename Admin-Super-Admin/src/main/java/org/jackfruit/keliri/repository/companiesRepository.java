package org.jackfruit.keliri.repository;

import java.util.List;
import java.util.Optional;

import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.companies;
import org.jackfruit.keliri.model.master_product_categories;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface companiesRepository extends MongoRepository<companies,String>{

	 @Query(value="{_id:?0}",fields="{'name':1,'companyCategories':1,'companyLogo':1}")
	 companies findBycustomId(String id);
	 
	 @Query(value="{'name': { $regex: ?0, $options: 'i' }}")//,fields = "{'_id':1}"
		List<companies> searchAllFields(String keyword);
		
	@Query(value = "{ 'companyCategories': { '$elemMatch': { '$in': ?0 } } }",fields = "{'_id':1}")
	List<companies> searchByCompanyCategory(List<ObjectId> list);	
	 
}
