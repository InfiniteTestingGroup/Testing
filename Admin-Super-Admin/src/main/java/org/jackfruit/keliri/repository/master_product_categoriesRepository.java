package org.jackfruit.keliri.repository;

import java.util.List;

import org.jackfruit.keliri.model.advertisements;
import org.jackfruit.keliri.model.master_product_categories;
import org.springframework.data.domain.Example;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface master_product_categoriesRepository extends MongoRepository<master_product_categories, String>{
	
	/*@Query(fields="{'name':1}")
	List<master_product_categories>  ;*/
 
	@Query(value="{'status':true}",fields="{'name':1}")
	 List<master_product_categories> findAll() ;
	
	@Query(value ="{ $or: [ { 'name': { $regex: ?0, $options: 'i' } }, { 'description': { $regex: ?0, $options: 'i' } } ] }",fields="{'_id':1}")
		List<master_product_categories> searchAllFields(String keyword);
		
		
		
}
