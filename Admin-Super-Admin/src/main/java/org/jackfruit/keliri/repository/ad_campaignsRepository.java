package org.jackfruit.keliri.repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.bson.types.ObjectId;
import org.jackfruit.keliri.controller.projectionClass;
import org.jackfruit.keliri.model.adCampaigns_advertisementsDTO;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.model.advertisements;
import org.jackfruit.keliri.model.postmanClass;
import org.jackfruit.keliri.model.users;
import org.springframework.data.mongodb.repository.Aggregation;
//import org.jackfruit.keliri.model.location;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface ad_campaignsRepository extends MongoRepository<ad_campaigns, String>,AdCampaignRepositoryCustom {
	
    //@Query(value="{compaignsStatus:'ACTIVE'}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1}")
    //@Query(value="{compaignsStatus:'ACTIVE'}")
   @Aggregation(pipeline= {
    		"{$match:{'compaignsStatus':'ACTIVE'}}",
    		"{$lookup:{from:'advertisements',localField:'advertisementId',foreignField:'_id',as:'advertisements'}}",
    	   	"{$unwind:'$advertisements'}",
    		"{$project:{compaignsStatus:1,createdBy:1,advertisementId:1,dateRange:1,location:1,'a':'$advertisements'}}"
    })	
	List<projectionClass> findByLatp();
	//"{$project:{_id:1,compaignsStatus:1,createdBy:1,advertisementId:1,dateRange:1,latitude:'$location.lat',longitude:'$location.lng',range:'$location.range','title': '$advertisementDetails.title','description':'$advertisementDetails.description'}}"
	
	
	@Query(value="{compaignsStatus:'ACTIVE'}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'giTag':1}")
	List<ad_campaigns> findByLat();
	
	@Query("{'$and':[{'campaignCategories':{ '$in':?0 }},{compaignsStatus:'ACTIVE'}]}")
	List<ad_campaigns> findbyloccatgry(ArrayList<ObjectId> arr);
	
	@Query(value="{'$and':[{'createdBy':?0},{compaignsStatus:'ACTIVE'}]}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1}")
	ArrayList<ad_campaigns> findbycreatedBy(ObjectId id );
//	ad_campaigns findbycreatedBy(ObjectId id );
    
	@Query(value="{'$and':[{'campaignCategories':{ '$in':?0 }},{compaignsStatus:'ACTIVE'},{createdBy:?1}]}",fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1}")
//	@Query(value="{{compaignsStatus:'ACTIVE'},'$or':[{'campaignCategories':{ '$in':?0 }},{createdBy:?1}]}")
	List<ad_campaigns> findads(ArrayList<ObjectId> arr,ObjectId createdByid);
	
	  @Query(value="{'_id':?0}",fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'giTag':1}")
	ad_campaigns findByIdadDetails(String id) ;
	  
	  @Query(value="{createdBy:?0}",fields="{compaignsStatus:1}")
	ArrayList<ad_campaigns>  findnoofCampaigns(ObjectId id);
	
	@Query(value="{'$and':[{'createdBy':?0},{compaignsStatus:?1}]}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1}")
	ArrayList<ad_campaigns> findbycreatedByCompleted(ObjectId id,String adStatus );
	
	@Query(value="{'$and':[{'createdBy':?0}]}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1}")
	ArrayList<ad_campaigns> findbycreatedByAllAds(ObjectId id );
	
	
	//@Query(value="{'$and':[{'location.locationName': {$regex:'.*?0.*', $options:'i'} },{compaignsStatus:'ACTIVE'}]}")
	@Query(value="{'location.locationName': {$regex:'.*?0.*', $options:'i'}}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1} ")
    List<ad_campaigns> searchAllFields(String keyword);
    
    @Query("{'$and':[{'advertisementId': { '$in': ?0 } },{compaignsStatus:'ACTIVE'}]}")
    List<ad_campaigns> searchwithadId(List<ObjectId> adIds);
    
    @Query("{'$and':[{'createdBy': { '$in': ?0 } },{compaignsStatus:'ACTIVE'}]}")
    List<ad_campaigns> searchWithCreatedBy(List<ObjectId> userIds);
    
    
    @Query("{'$and':[{'_id': { '$in': ?0 } },{compaignsStatus:'ACTIVE'}]}")
    List<ad_campaigns> searchfromfinallist(List<String> list);
    
    @Query(value="{compaignsStatus:'ACTIVE','giTag':1}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'giTag':1}")
	List<ad_campaigns> findByGiTags();
	
	@Aggregation(pipeline = {
	        "{ $match: { compaignsStatus: 'ACTIVE',giTag:{$ne:1}} }",
	        "{ $lookup: { from: 'advertisements', localField: 'advertisementId', foreignField: '_id', as: 'ads' } }",
	        "{ $unwind: '$ads' }",
	        "{ $match: { 'ads.gitagnumber': ?0 } }",
	        "{ $project: { _id:'$_id',advertisementId:'$advertisementId',fromDate:'$dateRange.fromDate',toDate:'$dateRange.toDate',latitude:'$location.lat',longitude:'$location.lng',locationName:'$location.locationName',range:'$location.range',compaignsStatus:'$compaignsStatus',createdBy:'$createdBy',title:'$ads.title',description:'$ads.description',company:'$ads.company',thumbnail:'$ads.thumbnail',content:'$ads.content',adType:'$ads.adType',customTextSection:'$ads.customTextSection', gitagnumber: '$ads.gitagnumber' } }"
	        
	    })
	List<adCampaigns_advertisementsDTO> findbygitagnumber(int gitagnumber);
	
	
	
	@Query(value="{'$and':[{'advertisementId':?0},{compaignsStatus:'ACTIVE'}]}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1}")
	ArrayList<ad_campaigns> findByAdId(ObjectId id );
	
	@Query(value="{compaignsStatus:'ACTIVE','temple':1}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'temple':1}")
	List<ad_campaigns> findByTempleAds();
	
	
	@Query(value="{compaignsStatus:'ACTIVE','forest':1}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'forest':1}")
	List<ad_campaigns> findByForestAds();
	
	@Query(value="{compaignsStatus:'ACTIVE','heritage':1}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'heritage':1}")
	List<ad_campaigns> findByHeritageAds();
	
	
	@Query(value="{compaignsStatus:'ACTIVE','hospital':1}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'hospital':1}")
	List<ad_campaigns> findByHospitalAds();
	
	
	@Query(value="{compaignsStatus:'ACTIVE','rickshaw':1}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'rickshaw':1}")
	List<ad_campaigns> findByRickshawAds();
	
	@Query(value="{compaignsStatus:'ACTIVE','bus':1}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'bus':1}")
	List<ad_campaigns> findByBusAds();
	
	
	@Query(value="{compaignsStatus:'ACTIVE','car':1}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'car':1}")
	List<ad_campaigns> findByCarAds();

	
	@Query(value="{compaignsStatus:'ACTIVE','goods':1}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'goods':1}")
	List<ad_campaigns> findByGoodsAds();
	
	
	@Query(value="{compaignsStatus:'ACTIVE','vlogs':1}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'vlogs':1}")
	List<ad_campaigns> findByVlogs();
	
	@Query(value="{compaignsStatus:'ACTIVE','news':1}", fields="{'location.lat':1,'location.lng':1,'compaignsStatus':1,'createdBy':1,'location.range':1,'dateRange':1,'campaignCategories':1,'advertisementId':1,'news':1}")
	List<ad_campaigns> findByNews();
	
	
}
