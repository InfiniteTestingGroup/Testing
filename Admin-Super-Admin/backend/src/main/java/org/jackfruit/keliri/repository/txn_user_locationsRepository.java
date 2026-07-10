package org.jackfruit.keliri.repository;

import java.util.List;
import java.util.Optional;

import org.jackfruit.keliri.model.txn_user_locations;
import org.jackfruit.keliri.model.txn_user_locations_users;
import org.jackfruit.keliri.model.users;
import org.springframework.data.geo.Point;
import org.springframework.data.mongodb.repository.Aggregation;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

public interface txn_user_locationsRepository extends MongoRepository<txn_user_locations,String>{

    @Query(value = "{_id:?0}",fields = "{'location':1}")
	public Optional<txn_user_locations> findById(String id);
	
/* @Query("{'location': { $near: { $geometry: { type: 'Point', coordinates: ?0 }, $maxDistance: ?1 } }}")
	    List<Place> findNearbyPlaces(Point location, double maxDistance);
	 */
	 
	 @Aggregation(pipeline = {
		        "{ '$geoNear': { " +
		            "'near': ?0, " +
		            "'distanceField': 'distance', " +
		            "'maxDistance': ?1, " +
		            "'spherical': true " +
		        "} }",
		        "{ '$lookup': { " +
		            "'from': 'users', " +
		            "'let': { 'lastKnownlocationn': '$_id' }, " +
		            "'pipeline': [ " +
		                "{ '$match': { '$expr': { '$and': [ " +
		                    "{ '$eq': ['$lastKnownLocation', '$$lastKnownlocationn'] }, " + // Match placeId
		                    "{ '$eq': ['$userType', 'PUBLISHER'] } " +    // Only reviews with role 'Publisher'
		                "] } } } " +
		            "], " +
		            "'as': 'Users' " +
		        "} }",
		        "{ '$match': { 'Users': { '$ne': [] } } }"// ✅ Remove places where reviews are empty
		       
		    })
		    
		    List<users> findNearbySpotlights(double[] location, double maxDistance);
		    
		    
		    @Query(value = "{_id:?0}",fields = "{'location':1}")
		    public  txn_user_locations getlatlng(String id);

}
//"{ $lookup: { from: 'users', localField: '_id', foreignField: 'lastKnownLocation', as: 'Users' } }",
//"{  $unwind: '$Users'}",
//"{$match:{'Users.userType': 'PUBLISHER'}}"