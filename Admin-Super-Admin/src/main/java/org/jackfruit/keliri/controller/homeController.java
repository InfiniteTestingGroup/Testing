package org.jackfruit.keliri.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Random;
import java.util.Set;
import java.util.TimeZone;
import java.util.stream.Collectors;

import javax.sound.sampled.AudioSystem;

import org.apache.catalina.valves.JsonAccessLogValve;
import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.Content;
import org.jackfruit.keliri.model.SessionData;
import org.jackfruit.keliri.model.action;
import org.jackfruit.keliri.model.ad_campaigns;import org.jackfruit.keliri.model.adCampaigns_advertisementsDTO;
import org.jackfruit.keliri.model.advertisements;
import org.jackfruit.keliri.model.buttonActionDTO;
import org.jackfruit.keliri.model.companies;
import org.jackfruit.keliri.model.cta;
import org.jackfruit.keliri.model.dateRange;
import org.jackfruit.keliri.model.hitRecord;
import org.jackfruit.keliri.model.location;
import org.jackfruit.keliri.model.mapping_user_folowings;
import org.jackfruit.keliri.model.master_product_categories;
import org.jackfruit.keliri.model.medias;
import org.jackfruit.keliri.model.medias_keliri;
import org.jackfruit.keliri.model.mobile_otp;
import org.jackfruit.keliri.model.phoneNumber;
import org.jackfruit.keliri.model.postmanClass;
import org.jackfruit.keliri.model.spotlighttwolists;
import org.jackfruit.keliri.model.takeMeThere;
import org.jackfruit.keliri.model.txn_user_locations;
import org.jackfruit.keliri.model.txn_user_locations_users;
import org.jackfruit.keliri.model.user_profiles;
import org.jackfruit.keliri.model.user_profiles_keliri;
import org.jackfruit.keliri.model.users;
import org.jackfruit.keliri.model.users_keliri;
import org.jackfruit.keliri.repository.ad_campaignsRepository;
import org.jackfruit.keliri.repository.advertisementsRepository;
import org.jackfruit.keliri.repository.companiesRepository;
import org.jackfruit.keliri.repository.mapping_user_folowingsRepository;
import org.jackfruit.keliri.repository.master_product_categoriesRepository;
import org.jackfruit.keliri.repository.mediaRepository;
import org.jackfruit.keliri.repository.txn_user_locationsRepository;
import org.jackfruit.keliri.repository.user_profilesRepository;
import org.jackfruit.keliri.repository.usersRepository;
import org.jackfruit.keliri.repository.users_keliriRepository;
import org.jackfruit.keliri.repository.hitRecordRepository;
import org.jackfruit.keliri.service.MediaService;
import org.jackfruit.keliri.service.S3Service;
import org.jackfruit.keliri.service.SessionActivityService;
import org.jackfruit.keliri.service.hitFileService;

import org.jackfruit.keliri.service.ad_campaignsservice;
import org.jackfruit.keliri.service.advertisementService;
import org.jackfruit.keliri.service.medias_keliriService;
import org.jackfruit.keliri.service.mobileotpService;
import org.jackfruit.keliri.service.user_profilesService;
import org.jackfruit.keliri.service.user_profiles_keliriService;
import org.jackfruit.keliri.service.users_keliriService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.parsing.Location;
import org.springframework.data.geo.Point;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;


import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.*;

@RestController 
public class homeController {

/*	 @Autowired
	 private ad_campaignsServices adcampserv;*/
	
@Autowired
private ad_campaignsRepository ad_campaignsRepo;
	
@Autowired
private usersRepository usersRepo;
	
@Autowired
private txn_user_locationsRepository txnuserrepo;

@Autowired
private advertisementsRepository adrepo;

@Autowired
private companiesRepository companyrepo;

@Autowired
private master_product_categoriesRepository productRepo;

@Autowired
private mobileotpService mobileservice;

@Autowired
private S3Service s3Service;

@Autowired
private mediaRepository mediarepo;


@Autowired
private user_profilesRepository user_profilesrepo;

@Autowired
private mapping_user_folowingsRepository mapping_user_folowingsrepo;

@Autowired
private medias_keliriService mediakeliriService;

@Autowired
private user_profiles_keliriService user_profiles_keliriServ;


@Autowired
private users_keliriService users_keliriServ;

@Autowired
private users_keliriRepository users_keliri_repo;

@Autowired
ad_campaignsservice ad_campaignsService;

@Autowired
private advertisementService advertisementService;

private String finallistofads;

@Autowired
private hitRecordRepository hitRecordRepository;

@Autowired
private hitFileService hitFileService;


@Autowired
private SessionActivityService sessionService;


@Value("${apk.file.path:}")
private String apkFilePath;
/*private static final Map<String, String> VERTICAL_MAP = Map.of(
        "gitagenabled", "giTag",
        "templeenabled", "temple",
        "forestenabled", "forest",
        "heritageenabled", "heritage",
        "hospitalenabled", "hospital",
        "busenabled", "bus",
        "carenabled", "car",
        "goodsenabled", "goods",
        "rickshawenabled", "rickshaw",
        "vlogsenabled","vlogs",
        "newsenabled","news"
    );*/// supports only 10 entries
private static final Map<String, String> VERTICAL_MAP = Map.ofEntries(
        Map.entry("gitagenabled", "giTag"),
        Map.entry("templeenabled", "temple"),
        Map.entry("forestenabled", "forest"),
        Map.entry("heritageenabled", "heritage"),
        Map.entry("hospitalenabled", "hospital"),
        Map.entry("busenabled", "bus"),
        Map.entry("carenabled", "car"),
        Map.entry("goodsenabled", "goods"),
        Map.entry("rickshawenabled", "rickshaw"),
        Map.entry("vlogsenabled", "vlogs"),
        Map.entry("newsenabled", "news")
    );

private SessionData getSessionAnalytics(HttpServletRequest request) {
    String sessionId = request.getSession(true).getId();
    SessionData s = sessionService.get(sessionId);

    s.sessionId = sessionId;
    s.ip = request.getRemoteAddr();
    s.userAgent = request.getHeader("User-Agent");

    return s;
}
@PostMapping("/location")
public String getHomePage(@RequestBody location location,HttpSession session, HttpServletRequest request) {
	 System.out.println("Location in ajax : " +location);
	 System.out.println("latitude in ajx : " +location.getLat());		 
	
	//location.setLat("13.529271965260616");
	//location.setLng("75.36285138756304");
	 //session.removeAttribute("latitude");
	//	session.removeAttribute("longitude");
	 String latitudeearlier = (String)session.getAttribute("latitude");//string to double
	 String longitudeearlier = (String)session.getAttribute("longitude");
	 String userAgent = request.getHeader("User-Agent");
	//  session.setAttribute("slider", sliderValue);
	//  double slider = (Double)session.getAttribute("slider");
	  ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
	  //System.out.println("+++++++++++++++ " +latitudeearlier +"--------------------" +longitudeearlier +"---------"+categories +"++++++++++" );;
		//session.setAttribute("profilePicPath", "/Default_pfp.jpg");
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
		ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
		//session.invalidate();
		
		// 1. LOG THE HIT RECORD (NEW LOGIC)
        hitRecord hit = new hitRecord();
        hit.setLatitude(location.getLat());
        hit.setLongitude(location.getLng());
        hit.setUserAgent(userAgent);
        hitRecordRepository.save(hit);
        
        
   /*     String latFile = location.getLat();
        String lngFile = location.getLng();
        hitFileService.writeHit(latFile, lngFile, userAgent);*/ // <--- CHANGE: Use HitFileService
        
        SessionData s = getSessionAnalytics(request);
        //s.startTime= java.time.Instant.now();
        
        s.startTime= ZonedDateTime.now(ZoneId.of("Asia/Kolkata"));
        //s.hitCount++;
        s.lat = location.getLat();
        s.lng = location.getLng();
	  if(latitudeearlier == null && latitudeearlier==null)
	  {	  
	System.out.println("in session null");
	session.setAttribute("latitude", location.getLat());
	session.setAttribute("longitude", location.getLng());
	session.setAttribute("slider", 2.0);
	session.removeAttribute("categories");
	session.removeAttribute("mobilenumber");
	session.removeAttribute("currentLocationset");
	// first time page is loaded start here
	  double lat = Double.parseDouble(location.getLat());
	  double lng = Double.parseDouble(location.getLng());
	  double lat1 = 0.0;
	  double lng1 = 0.0;
	//	double dist_range=300.00;
	  long startTime = System.currentTimeMillis();
List<ad_campaigns> list = ad_campaignsRepo.findByLat();
//System.out.println("list size of active: " +list.size());

	//System.out.println("------"+list.size());		
int j=0;
for(ad_campaigns item1:list)
{
	j++;
if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
{
lat1 = Double.parseDouble(item1.getLocation().lat);
lng1 = Double.parseDouble(item1.getLocation().lng);
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=2.0) {
	ul.add(item1);
}
}

if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
{
Optional<users> u = usersRepo.findById(item1.getCreatedBy());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
if(!(userloc.isEmpty())) {
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=2.0) {
ul.add(item1);
}
}
}
}
//System.out.println("size of ul : " + ul.size());
long endTime = System.currentTimeMillis();
long duration = endTime - startTime;
//System.out.println("to find the reachable ads list : " +duration);
long startTime2 = System.currentTimeMillis();
for(ad_campaigns item:ul)//list
	{
	
	  Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String			   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());		
	  String s3locationurl = s3Location.getS3Location();	
	  companies.setCompanyLogoPath(s3locationurl);
	  item.setCompanies(companies);
	  
	  
	  //to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			
			
			listofimagepaths.add(s3url.getS3Location());
		
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		
       advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		
		 ad.get().setContent(l.getContent());
		
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 
		 
		 // to start here
		 else
		 {
			 if(ad.get().getContent().getVideoLink().contains("youtube"))
			 {
			//	 System.out.println("inside youtube : ");
				String videoid=  ad.get().getContent().getVideoLink().substring(ad.get().getContent().getVideoLink().indexOf("=") + 1);
				//https://www.youtube.com/embed/
					ad.get().getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
			 }
		 }
		 //till here
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
		
	 }
	 
	 //to get simple text end here
	 	 
	 //to get custom text start here
	 
	 // to get custom text end here
	   item.setA(ad.get());
//
	   
	   //to get name and ph nomner
	   //to get cta start here
	   
	  
	   

	   //to get cta end here
Optional<users> user  =  usersRepo.findByIdphandemail(item.getCreatedBy());
item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
//item.setEmailAddress(user.get().getEmailAddress());
item.setFullName(user.get().getFullName());
item.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
	   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item.getAdvertisementId());
	   if (cta != null && !cta.isEmpty()) {
	   for(buttonActionDTO b : cta)
	   {
		   if (b.getCtaId() == null || b.getAction() == null) continue;
			    switch (b.getCtaId()) {
			        case "64887c11cce361dafc86c241":  // Phone
			            item.setPhoneNumber(b.getAction());
			            break;
			        case "64887c11cce361dafc86c242":  // WhatsApp
			            item.setWhatsappNumber(b.getAction());
			            break;
			        case "64e99c7651a484a077ae2c1f":  // Take me there
			        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
			        	if(b.getLatitude()!=null && b.getLongitude()!=null) {
			        	 item.getLocation().setLat(Double.toString(b.getLatitude()));
			        	 
			        	 item.getLocation().setLng(Double.toString(b.getLongitude()));}
			            break;
			        default:
			            break;
			    }
		   }
	   
	   }
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here

		//i++;
		//if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
		//{
		//lat1 = Double.parseDouble(item.getLocation().lat);
		//lng1 = Double.parseDouble(item.getLocation().lng);
		//double distanceVal=distance(lat1,lat,lng1,lng);
		//item.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
		//	ul.add(item);
		//}
		//}
		
		//if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
		//{
		
//Optional<users> u = usersRepo.findById(item.getCreatedBy());
//Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//if(!(userloc.isEmpty())) {
//lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
//item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);
//item.setDistance(distanceVal);
//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
//ul.add(item);
//}
//}
//}	

} 
long endTime2 = System.currentTimeMillis();
long duration2 = endTime2 - startTime2;
//System.out.println("to set the images path : " + ul.size());

session.setAttribute("FinalListOfAds", ul);
return new Gson().toJson(ul);	   
}
	  
	 
	/*  else
	  {
		  double slider=0.0;
		  System.out.println("in not  null else" +categories);
		  double lat = Double.parseDouble((String)session.getAttribute("latitude"));
		  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
		  if(session.getAttribute("slider") !=null)
			{
				slider =(Double)session.getAttribute("slider");
			}
			else 
			{
				slider =1.3;
			}	 
	//	  System.out.println("slider in else : " +slider);
		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
	     // System.out.println("in else : " + lat +"and "+lng);
			List<ad_campaigns> list = new ArrayList<ad_campaigns>();
	
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
			 
			 long startTime3 = System.currentTimeMillis();
				 list = ad_campaignsRepo.findByLat();

				 for(ad_campaigns item:list)
				   {	
					if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
					{
					//	System.out.println("in if 1 ");
					lat1 = Double.parseDouble(item.getLocation().lat);
					lng1 = Double.parseDouble(item.getLocation().lng);
					double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
					if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
						//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
						ull.add(item);
					}
					}		
					if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
					{
					//	System.out.println("in if 2 ");
						//System.out.println("Created By : " +item.getCreatedBy());
			//ObjectId id = new ObjectId(item.getCreatedBy());
			//System.out.println("ObjectId : " +id);
			Optional<users> u = usersRepo.findById(item.getCreatedBy());
			//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
			Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
			//System.out.println("user locations : " +userloc);
			if(!(userloc.isEmpty())) {
			//System.out.println(userloc.get().getLocation().getX());
			//System.out.println(userloc.get().getLocation().getY());
			lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
			item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
			double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
			//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
			if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
			ull.add(item);
			}
			}
			}	
			} 	  //for
				 long endTime3 = System.currentTimeMillis(); 
			//	 System.out.println("ull : " +ull.size() +"and duration to get reachable ads : " +  (endTime3 - startTime3));
				  long startTime4 = System.currentTimeMillis(); 
		for(ad_campaigns item2:ull)
		{
		
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
			
		  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
//		  System.out.println("companies: " +companies); 
		  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
			
			  String s3locationurl = s3Location.getS3Location();
		
			  companies.setCompanyLogoPath(s3locationurl);
			  
		      item2.setCompanies(companies);
	
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
	
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				
				listofimagepaths.add(s3url.getS3Location());
			
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
			 else
			 {
				 if(ad.get().getContent().getVideoLink().contains("youtube"))
				 {
				//	 System.out.println("inside youtube : ");
					String videoid=  ad.get().getContent().getVideoLink().substring(ad.get().getContent().getVideoLink().indexOf("=") + 1);
					//https://www.youtube.com/embed/
						ad.get().getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
				 }
			 }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
	//System.out.println("final ad : " +ad);
		   
		   //to get name and ph nomner
		   
	Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
	//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
	item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
	item2.setEmailAddress(user.get().getEmailAddress());item2.setFullName(user.get().getFullName());
	//System.out.println("item ph : " +item.getPhoneNumber());
	//to get name and ph nomner till here
		   
		   if(categories!=null) {
			   if(categories.size()>0) {
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			   for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
				  if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
		   }
		}	   
		}	
		//System.out.println("size of set : " +set.size());
		if(categories!=null) {
			 if(categories.size()>0) {
			ull.clear();
		    ull = new ArrayList<>(set);}
		}
		
		
		 long endTime4 = System.currentTimeMillis(); // End time
		// System.out.println("ull 2nd  : " +ull.size() +"and duration to set the images : " +(endTime4-startTime4) );
		for(ad_campaigns item3:ull)
		   {	
			if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
			{
			
				ul.add(item3);
			
			}		
			if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
			{
			
		ul.add(item3);
	}	
	} 	
	  }//else*/
  
	 /* System.out.println("Final size of ul: " +ul.get(0).getId() +"gi Tag : " +ul.get(0).getGiTag());
	  System.out.println("Final size of ul: " +ul.get(1).getId() +"gi Tag : " +ul.get(1).getGiTag());
	  System.out.println("Final size of ul: " +ul.get(2).getId() +"gi Tag : " +ul.get(2).getGiTag());
	  System.out.println("Final size of ul: " +ul.get(3).getId() +"gi Tag : " +ul.get(3).getGiTag());
	  System.out.println("Final size of ul: " +ul.get(4).getId() +"gi Tag : " +ul.get(4).getGiTag());
	  System.out.println("Final size of ul: " +ul.get(5).getId() +"gi Tag : " +ul.get(5).getGiTag());
	  System.out.println("Final size of ul: " +ul.get(6).getId() +"gi Tag : " +ul.get(6).getGiTag());
	  System.out.println("Final size of ul: " +ul.get(7).getId() +"gi Tag : " +ul.get(7).getGiTag());
	  System.out.println("Final size of ul: " +ul.get(8).getId() +"gi Tag : " +ul.get(8).getGiTag());
	  System.out.println("Final size of ul: " +ul.get(9).getId() +"gi Tag : " +ul.get(9).getGiTag());*/
	  
	  else {
	  System.out.println("Final size of ul: " +ul.size());
	//  System.out.println("in not  null else" +categories);
	  
	  ul = (ArrayList<ad_campaigns>) session.getAttribute("FinalListOfAds");
	    return new Gson().toJson(ul);
	  
	  }
	  
			// first time page is loaded end here
	   
	//	return "index";
		
	}	
	
	@PostMapping("/currentlocation")
	public String getCurrentLocation(@RequestBody location location, @RequestParam(name = "mode", required = false) String mode,HttpSession session,HttpServletRequest request) {
	 System.out.println("Mode : " +mode);	
	 System.out.println("latitude in ajx : " +location.getLat());
//	 HttpServletRequest request;
	 session.setAttribute("latitude", location.getLat());
	 session.setAttribute("longitude", location.getLng());
     ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
     session.setAttribute("currentLocationset", true);

	double slider =0.0; 

	if(session.getAttribute("slider") !=null)
	{
		slider =(Double)session.getAttribute("slider");
	}
	else 
	{
		slider =2.0;
	}
       	
	
		  double lat = Double.parseDouble(location.getLat());
		  double lng = Double.parseDouble(location.getLng());
		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
			ArrayList<ad_campaigns> ul  = new ArrayList<ad_campaigns>();
			ArrayList<ad_campaigns> ull = new ArrayList<ad_campaigns>();
			List<ad_campaigns> list     = new ArrayList<ad_campaigns>();
			Set<ad_campaigns> set       = new HashSet<ad_campaigns>();
			 
		/*	 if (Boolean.TRUE.equals(session.getAttribute("gi")))
			 {
				 list = ad_campaignsRepo.findByGiTags(); 
			 }
			 
			 else
			 {*/
			   String vertical = (String)	session.getAttribute("verticalenabled");
			   String searchKeyword = (String)	session.getAttribute("searchKeyword");
			   
			   
			if(searchKeyword!= null && !searchKeyword.isEmpty()) { 
				System.out.println("in so Serach");
		
		  List<ad_campaigns> result = dosearch(searchKeyword, session, request);
		    return new Gson().toJson(result);
				
			   
			}
			
			else   //new
			{
			if(mode!= null && !mode.isEmpty() ) {   //when executed
			//	 list = ad_campaignsRepo.findByLatvertical(mode);
				//list = ad_campaignsRepo.findByLat();
			//	System.out.println("IIn Mode" +mode); 
				list = ad_campaignsService.getCampaignsByDynamicField(mode,1);
			}
			else
			{
				if(vertical !=null)  // for all vehicles 
				{
					//System.out.println("IIn vertical" +vertical);
					String parameterToPass = VERTICAL_MAP.getOrDefault(vertical, "defaultTag");

					list = ad_campaignsService.getCampaignsByDynamicField(parameterToPass,1);
					
					for (ad_campaigns item1:list)
					{
						if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
						{
						//	System.out.println("in if 1 ");
						lat1 = Double.parseDouble(item1.getLocation().lat);
						lng1 = Double.parseDouble(item1.getLocation().lng);
						double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
						//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
						//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
							ull.add(item1);
						//}
						}
						
						if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
						{
						//	System.out.println("in if 2 ");
							//System.out.println("Created By : " +item.getCreatedBy());
				//ObjectId id = new ObjectId(item.getCreatedBy());
				//System.out.println("ObjectId : " +id);
				Optional<users> u = usersRepo.findById(item1.getCreatedBy());
				//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
				Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
				//System.out.println("user locations : " +userloc);
				if(!(userloc.isEmpty())) {
				//System.out.println(userloc.get().getLocation().getX());
				//System.out.println(userloc.get().getLocation().getY());
				lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
				item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
				double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
				//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
				//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
				ull.add(item1);
				//}
				}
				}	
					}
				}
				else
				{
					//System.out.println(":::::::::::::::::::::::::::::::::::::::::::::::::");
				 list = ad_campaignsRepo.findByLat();
				 for (ad_campaigns item1:list)
					{
						if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
						{
						//	System.out.println("in if 1 ");
						lat1 = Double.parseDouble(item1.getLocation().lat);
						lng1 = Double.parseDouble(item1.getLocation().lng);
						double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
						//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
							if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
							ull.add(item1);
						}
						}
						
						if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
						{
						//	System.out.println("in if 2 ");
							//System.out.println("Created By : " +item.getCreatedBy());
				//ObjectId id = new ObjectId(item.getCreatedBy());
				//System.out.println("ObjectId : " +id);
				Optional<users> u = usersRepo.findById(item1.getCreatedBy());
				//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
				Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
				//System.out.println("user locations : " +userloc);
				if(!(userloc.isEmpty())) {
				//System.out.println(userloc.get().getLocation().getX());
				//System.out.println(userloc.get().getLocation().getY());
				lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
				item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
				double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
				//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
				if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
				ull.add(item1);
				}
				}
				}	
					}
				}
			}
			}//new
			
		//	 }
	
	//System.out.println("size of Ull : " +ull.size());
		for(ad_campaigns item2:ull)
		{
		//	System.out.println("NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" +ull.size());
			
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
		//  System.out.println("companies: " +companies.getCompanyCategories());
            
            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
       	 // System.out.println("s3 loctio : " +s3Location);
       		//  item.getCompanies().setCompanyLogo(s3Location);
       	 // companies.setCompanyLogoPath(s3Location);
       	  String s3locationurl = s3Location.getS3Location();
       	 // System.out.println("s3locationurl : " +s3locationurl);
       	  companies.setCompanyLogoPath(s3locationurl);
       	  
       	  
		  item2.setCompanies(companies);
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
		 //to get name and ph nomner
		   
		   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
		   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
		   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
		   item2.setEmailAddress(user.get().getEmailAddress());
		   item2.setFullName(user.get().getFullName());
		   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
		   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item2.getAdvertisementId());
		   if (cta != null && !cta.isEmpty()) {
		   for(buttonActionDTO b : cta)
		   {
			   if (b.getCtaId() == null || b.getAction() == null) continue;
				    switch (b.getCtaId()) {
				        case "64887c11cce361dafc86c241":  // Phone
				            item2.setPhoneNumber(b.getAction());
				            break;
				        case "64887c11cce361dafc86c242":  // WhatsApp
				            item2.setWhatsappNumber(b.getAction());
				            break;
				        case "64e99c7651a484a077ae2c1f":  // Take me there
				        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
				        	if(b.getLatitude()!=null && b.getLongitude()!=null) {
				        	 item2.getLocation().setLat(Double.toString(b.getLatitude()));
				        	 
				        	 item2.getLocation().setLng(Double.toString(b.getLongitude()));}
				            break;
				        default:
				            break;
				    }
			   }
		   }
		   //System.out.println("item ph : " +item.getPhoneNumber());
		   //to get name and ph nomner till here
		   if(categories!=null) {
			   if(categories.size()>0) { 
		
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			   for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
				  if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
	//	   System.out.println("Contents  of list2" +set);		
		   }//if >0
		}//if
		   
		}//for
		if(categories!=null) {
			if(categories.size()>0) {
		/*list.clear();
	    list = new ArrayList<>(set);*/
	    ull.clear();
	    ull = new ArrayList<>(set);
			}
		}
		//System.out.println("Size of list : " +ull.size());
		   for(ad_campaigns item3:ull)
		   {
			   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item3.getLocation().lat);
				lng1 = Double.parseDouble(item3.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
					//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
					ul.add(item3);
				//}
				}
				
				if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
				{
			
	//	Optional<users> u = usersRepo.findById(item3.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
	//	Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
	//	if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
	//	lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
	//	item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
		ul.add(item3);
	//	}
	//	}
		}				
} 
		//System.out.println("Final size of ul in CURRENT LOCATION: " +ul.size());
		
		session.removeAttribute("FinalListOfAds");
		session.setAttribute("FinalListOfAds", ul);
			   return new Gson().toJson(ul);
	//	return "index";
		
	}
		
	@PostMapping("/pinlocation")
	public String pinlocation(@RequestBody location location,HttpSession session) {
	// System.out.println("Location in ajax : " +location);
	// System.out.println("latitude in ajx : " +location.getLat());

	 session.setAttribute("latitude", location.getLat());
	 session.setAttribute("longitude", location.getLng());
	 double slider = 0.0; /*(Double)session.getAttribute("slider");*/
	 if(session.getAttribute("slider") !=null)
		{
			slider =(Double)session.getAttribute("slider");
		}
		else 
		{
			slider =2.0;
		}
	 ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
	 
	 session.setAttribute("currentLocationset", false);
		  double lat = Double.parseDouble(location.getLat());
		  double lng = Double.parseDouble(location.getLng());
		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
			ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
			ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
			List<ad_campaigns> list = new ArrayList<ad_campaigns>();
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
			/* if (Boolean.TRUE.equals(session.getAttribute("gi")))
			 {
				 list = ad_campaignsRepo.findByGiTags(); 
			 }
			 
			 else
			 {*/
			 
			   String vertical = (String)	session.getAttribute("verticalenabled");
				
						if(vertical !=null)
						{
							String parameterToPass = VERTICAL_MAP.getOrDefault(vertical, "defaultTag");

							list = ad_campaignsService.getCampaignsByDynamicField(parameterToPass,1);
							
							for(ad_campaigns item1:list)
							{
								if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
								{
								//	System.out.println("in if 1 ");
								lat1 = Double.parseDouble(item1.getLocation().lat);
								lng1 = Double.parseDouble(item1.getLocation().lng);
								double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
								//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
									ull.add(item1);
								//}
								}
								
								if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
								{
								//	System.out.println("in if 2 ");
									//System.out.println("Created By : " +item.getCreatedBy());
					//ObjectId id = new ObjectId(item.getCreatedBy());
					//System.out.println("ObjectId : " +id);
					Optional<users> u = usersRepo.findById(item1.getCreatedBy());
					//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
					Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
					//System.out.println("user locations : " +userloc);
					if(!(userloc.isEmpty())) {
					//System.out.println(userloc.get().getLocation().getX());
					//System.out.println(userloc.get().getLocation().getY());
					lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
					item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
					double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
					//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

					//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
						ull.add(item1);
					//}
					}
					}	
					}
						}
						else
						{
								list = ad_campaignsRepo.findByLat();
		 for(ad_campaigns item1:list)
			{
				if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item1.getLocation().lat);
				lng1 = Double.parseDouble(item1.getLocation().lng);
				double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
				if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
					ull.add(item1);
				}
				}
				
				if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
	//ObjectId id = new ObjectId(item.getCreatedBy());
	//System.out.println("ObjectId : " +id);
	Optional<users> u = usersRepo.findById(item1.getCreatedBy());
	//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
	Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
	//System.out.println("user locations : " +userloc);
	if(!(userloc.isEmpty())) {
	//System.out.println(userloc.get().getLocation().getX());
	//System.out.println(userloc.get().getLocation().getY());
	lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
	item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
	double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
	//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
		ull.add(item1);
	}
	}
	}	
	}
						}
			 //}
	//	System.out.println("session categories: " + session.getAttribute("categories"));
	//	System.out.println("------"+list.size());
		//System.out.println("------"+list);		
		
		//System.out.println("ull : " +ull.size());
		for(ad_campaigns item2:ull) {
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
			
			//System.out.println("advertisements : " +ad.get().getCompany());
			//item.getA().setTitle(a.get().getTitle());
			//item.getA().setDescription(a.get().getDescription());
		   
		  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
		//  System.out.println("companies: " +companies.getCompanyCategories());
		  		  
		  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
			 // System.out.println("s3 loctio : " +s3Location);
				//  item.getCompanies().setCompanyLogo(s3Location);
			 // companies.setCompanyLogoPath(s3Location);
			  String s3locationurl = s3Location.getS3Location();
			 // System.out.println("s3locationurl : " +s3locationurl);
			  companies.setCompanyLogoPath(s3locationurl);
			  
		  item2.setCompanies(companies);
		//to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
	//System.out.println("final ad : " +ad);
		   
		   
		   
		   
//		   cta ctaObj = new cta();ctaObj.setButtons(null)
//		   ad.get().setCta();
		   /*
		    * 
		    * for (advertisements item : ads) {
	        String createdBy = item.getCreatedBy();  // Assuming getCreatedBy() exists in your model
	        List<ButtonActionDTO> buttonActions = advertisementService.getCtaButtonActionsByCreatedByTemplate(createdBy);

	        System.out.println("Advertisement ID: " + item.getId() + ", CreatedBy: " + createdBy);
	        buttonActions.forEach(btn -> 
	            System.out.println("ctaId: " + btn.getCtaId() + ", action: " + btn.getAction())
	        );
	        System.out.println("-----------------------------");
	    }
		    */
		 //  System.out.println("final cta : " +cta);
		   //to get cta end here
		   
		   //to get name and ph nomner
		   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item2.setEmailAddress(user.get().getEmailAddress());
item2.setFullName(user.get().getFullName());
item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
//System.out.println("item ph : " +item.getPhoneNumber());
		   
		   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item2.getAdvertisementId());
		   if (cta != null && !cta.isEmpty()) {
		   for(buttonActionDTO b : cta)
		   {
			   if (b.getCtaId() == null || b.getAction() == null) continue;
			

			    switch (b.getCtaId()) {
			        case "64887c11cce361dafc86c241":  // Phone
			            item2.setPhoneNumber(b.getAction());
			            break;
			        case "64887c11cce361dafc86c242":  // WhatsApp
			            item2.setWhatsappNumber(b.getAction());
			            break;
			        case "64e99c7651a484a077ae2c1f":  // Take me there
			        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
			        	if(b.getLatitude()!=null && b.getLongitude()!=null) {
			        	 item2.getLocation().setLat(Double.toString(b.getLatitude()));
			        	 
			        	 item2.getLocation().setLng(Double.toString(b.getLongitude()));}
			            break;
			        default:
			            break;
			    }
		   }
		   }
//to get name and ph nomner till here
		   
		   if(categories!=null ) {
			   if(categories.size()>0) {
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			   for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
				  if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
	//	   System.out.println("Contents  of list2" +set);		
		//	System.out.println("item: " +item.getCampaignCategories() +"and : " +item.getId());
			   }
		}//if
		  
		}
		if(categories!=null) {
			if(categories.size()>0) {
			/*list.clear();
		    list = new ArrayList<>(set);*/
		    ull.clear();
		    ull = new ArrayList<>(set);
			}
		}
		//System.out.println("set ull :  " +ull.size());
		   for(ad_campaigns item3:ull)
		   {
			   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item3.getLocation().lat);
				lng1 = Double.parseDouble(item3.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
				//if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
					ul.add(item3);
				//}
				}
				
				if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
				{
				
	//Optional<users> u = usersRepo.findById(item3.getCreatedBy());

//	Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
	
//	if(!(userloc.isEmpty())) {
	
//	lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
	//item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
	//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
	//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

	//if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
		ul.add(item3);
	//}
//	}
	}	
} 
		System.out.println("Final size of ul: " +ul.size());
		
		session.removeAttribute("FinalListOfAds");
		session.setAttribute("FinalListOfAds", ul);
			   return new Gson().toJson(ul);
	//	return "index";
		
	}

@GetMapping("/")
public ModelAndView homepage(HttpServletRequest request,HttpSession session)
{
	session.removeAttribute("activeLink");
	session.setAttribute("activeLink", "home");
    String userAgent = request.getHeader("User-Agent").toLowerCase();
    System.out.println("user agent : " +userAgent);
    // Check for mobile devices based on User-Agent
    boolean isMobile = userAgent.contains("iphone") || userAgent.contains("android") || userAgent.contains("mobile"); 
    System.out.println("in /");
	System.out.println("in index");
	ModelAndView m = new ModelAndView();	
	
	/*long totalHits = hitRecordRepository.count();
    m.addObject("totalHits", totalHits); 
    System.out.println("Total website hits fetched: " + totalHits);
    
    long totalHitsFile = hitFileService.getHitCount(); // <--- CHANGE: Use HitFileService
    m.addObject("totalHits", totalHitsFile); 
    System.out.println("Total website hits fetched from file: " + totalHitsFile);*/
    
    
	/*List<users> users = usersRepo.findAll();
	for(users u : users)
	{
		//System.out.println("user id : " + u.getId());
		 ObjectId objectId = new ObjectId(u.getId());
		// System.out.println("ObjectId : " +objectId);
		user_profiles profilepicId = user_profilesrepo.findByuserId(objectId);//get profilePicturre id
		// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
	//	System.out.println("Profile pic Id : " +profilepicId);
		if(profilepicId != null) {
if(profilepicId.getProfilePicture()!=null) 
{	
	medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
	if(profiles3location !=null ) 
	{
		//System.out.println("profiles3location : "+profiles3location.getS3Location());
		u.setProfilePicPath(profiles3location.getS3Location());
		}
	}
	}
	}
	System.out.println("Users: " +users.size());
	m.addObject("users",new Gson().toJson(users));*/

	if (isMobile) {
		m.setViewName("responsiveindex");
        return m;  // Return mobile-specific JSP
    } else {
    	List<users> users = usersRepo.findAll();
    	for(users u : users)
    	{
    		//System.out.println("user id : " + u.getId());
    		ObjectId objectId = new ObjectId(u.getId());
    		// System.out.println("ObjectId : " +objectId);
    		user_profiles profilepicId = user_profilesrepo.findByuserId(objectId);//get profilePicturre id
    		// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
    	//	System.out.println("Profile pic Id : " +profilepicId);
    		if(profilepicId != null) {
    if(profilepicId.getProfilePicture()!=null) 
    {	
    	medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
    	if(profiles3location !=null ) 
    	{
    		//System.out.println("profiles3location : "+profiles3location.getS3Location());
    		u.setProfilePicPath(profiles3location.getS3Location());
    		}
    	}
    	}
    	}
    //	System.out.println("Users: " +users.size());
    	m.addObject("users",new Gson().toJson(users));
    	m.setViewName("index");
    }
	return m;
}
	
public static double distance(double lat1, double lat2, double lon1, double lon2) 
{ 
	
	// The math module contains a function 
	// named toRadians which converts from 
	// degrees to radians. 
	lon1 = Math.toRadians(lon1); 
	lon2 = Math.toRadians(lon2); 
	lat1 = Math.toRadians(lat1); 
	lat2 = Math.toRadians(lat2); 
	
	// Haversine formula  
	double dlon = lon2 - lon1;  
	double dlat = lat2 - lat1; 
	double a = Math.pow(Math.sin(dlat / 2), 2) 
	        + Math.cos(lat1) * Math.cos(lat2) 
	        * Math.pow(Math.sin(dlon / 2),2); 
	     
	double c = 2 * Math.asin(Math.sqrt(a)); 
	
	// Radius of earth in kilometers. Use 3956  
	// for miles 
	double r = 6371.0; 
	
	// calculate the result 
	return(c * r); 
	}  
	
 
	@PostMapping("/spotlight")//from ajax spotlight  may be ui 3, aspotlight and aspotlightdetail from ui1 
	public ArrayList<ad_campaigns> spotlight(@RequestBody String y,HttpSession session)
	{
		//System.out.println("y : " +y);
		  double lat1 = 0.0;  double lng1 = 0.0;		  
		  double lat = Double.parseDouble((String)session.getAttribute("latitude"));
		  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	
		ArrayList<ad_campaigns> ulspotlyt=new ArrayList<ad_campaigns>();
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();		
		ulspotlyt=ad_campaignsRepo.findbycreatedBy(new ObjectId(y));
		//System.out.println("contents of ul : " +ulspotlyt);
		//to find followers
	ArrayList<mapping_user_folowings> followings = 	mapping_user_folowingsrepo.findbyentityId(new ObjectId(y));
	//System.out.println("followings: " +followings.size());
	ArrayList<ad_campaigns> noofCampaigns = ad_campaignsRepo.findbycreatedBy(new ObjectId(y));
	//System.out.println("no of camp: " +noofCampaigns.size());
		for(ad_campaigns item:ulspotlyt)
		{
		
			Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String			
			//System.out.println("advertisements : " +ad.get().getCompany());
			//item.getA().setTitle(a.get().getTitle());
			//item.getA().setDescription(a.get().getDescription());
		   
		  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
	
		  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
			 // System.out.println("s3 loctio : " +s3Location);
				//  item.getCompanies().setCompanyLogo(s3Location);
			 // companies.setCompanyLogoPath(s3Location);
			  String s3locationurl = s3Location.getS3Location();
			 // System.out.println("s3locationurl : " +s3locationurl);
			  companies.setCompanyLogoPath(s3locationurl);
		  item.setCompanies(companies);
		  
		  
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
			 
			 else
			 {
				 if(ad.get().getContent().getVideoLink().contains("youtube"))
				 {
				//	 System.out.println("inside youtube : ");
					String videoid=  ad.get().getContent().getVideoLink().substring(ad.get().getContent().getVideoLink().indexOf("=") + 1);
					//https://www.youtube.com/embed/
						ad.get().getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
				 }
			 }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item.setA(ad.get());
	//System.out.println("final ad : " +ad);
		   
		   //to get name and ph nomner
		   
Optional<users> user  = usersRepo.findByIdphandemail(item.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item.setEmailAddress(user.get().getEmailAddress());
item.setFullName(user.get().getFullName());
item.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here

		
			if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
			{
			//	System.out.println("in if 1 ");
			lat1 = Double.parseDouble(item.getLocation().lat);
			lng1 = Double.parseDouble(item.getLocation().lng);
			//double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
			//if(distanceVal<=item.getLocation().getRange()/1000 ) {
				ul.add(item);
			//}
			}
			
			if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
			{
			//	System.out.println("in if 2 ");
				//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);
//if(distanceVal<=item.getLocation().getRange()/1000 ) {
	ul.add(item);
//}
}
}	
			item.setNoOfCampaigns(noofCampaigns.size());
			item.setNoOfFollow(followings.size());			
			//to get profile pic start here
			user_profiles profilepicId = user_profilesrepo.findByuserId(new ObjectId(y));//get profilePicturre id
			// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
		//	System.out.println("Profile pic Id : " +profilepicId);
			if(profilepicId != null) {
	if(profilepicId.getProfilePicture()!=null) 
	{	
		medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
		if(profiles3location !=null ) 
		{
			//System.out.println("profiles3location : "+profiles3location.getS3Location());
			
			item.setProfilePicturePath(profiles3location.getS3Location());
			}
		}
		}
			// to get profile pic end here
} 		
	    System.out.println(ul.size());
	    return ul;
	}
	
@PostMapping("/combined")//slider
public String combined(@RequestParam("slidervalue") double sliderValue,HttpSession session) {
	//System.out.println("slider value is : " +sliderValue);
	 double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	  session.setAttribute("slider", sliderValue);
	  double slider = (Double)session.getAttribute("slider");
	  ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
	  double lat1 = 0.0;
	  double lng1 = 0.0;
	
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
	//List<ad_campaigns> list = ad_campaignsRepo.findByLat();

		List<ad_campaigns> list = new ArrayList<ad_campaigns>();
		 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
		 String vertical = (String)	session.getAttribute("verticalenabled");
			
			if(vertical !=null)
			{
				String parameterToPass = VERTICAL_MAP.getOrDefault(vertical, "defaultTag");

				list = ad_campaignsService.getCampaignsByDynamicField(parameterToPass,1);
				
				for(ad_campaigns item1:list)
				{
					if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
					{
					//	System.out.println("in if 1 ");
					lat1 = Double.parseDouble(item1.getLocation().lat);
					lng1 = Double.parseDouble(item1.getLocation().lng);
					double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
					//System.out.println("distance: " +distanceVal +" Name : " +item1.getAdvertisementId());
					//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
						
						if(distanceVal <=slider) {
						ull.add(item1);
					}
					}
					
					if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
					{
					//	System.out.println("in if 2 ");
						//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item1.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
		double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

	//	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
			
			if(distanceVal <=slider) {
			
			ull.add(item1);
		}
		}
		}	
		}
			}
				else
		 
				{
			 list = ad_campaignsRepo.findByLat();
			 for(ad_campaigns item:list)
			   {	
				if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item.getLocation().lat);
				lng1 = Double.parseDouble(item.getLocation().lng);
				double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
				if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<= slider) {
					//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
					ull.add(item);
				}
				}		
				if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
		double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);

		if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<= slider) {
		ull.add(item);
		}
		}
		}	
		} 
				}
			 System.out.println("ull size : " +ull.size());
	for(ad_campaigns item2:ull)
	{
	//System.out.println("item inside for : " +item);
		Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
		
		//System.out.println("advertisements : " +ad.get().getCompany());
		//item.getA().setTitle(a.get().getTitle());
		//item.getA().setDescription(a.get().getDescription());
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
//	  System.out.println("companies: " +companies); 
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
		 // System.out.println("s3 loctio : " +s3Location);
			//  item.getCompanies().setCompanyLogo(s3Location);
		 // companies.setCompanyLogoPath(s3Location);
		  String s3locationurl = s3Location.getS3Location();
		 // System.out.println("s3locationurl : " +s3locationurl);
		  companies.setCompanyLogoPath(s3locationurl);
		  
	  item2.setCompanies(companies);
	//to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			//System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	   item2.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item2.setEmailAddress(user.get().getEmailAddress());item2.setFullName(user.get().getFullName());
item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber())	   ;
//System.out.println("item ph : " +item.getPhoneNumber());
	   
	   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item2.getAdvertisementId());// only if this is not empty
	   if (cta != null && !cta.isEmpty()) {
	   for(buttonActionDTO b : cta)
	   {
		   if (b.getCtaId() == null || b.getAction() == null) continue;
			    switch (b.getCtaId()) {
			        case "64887c11cce361dafc86c241":  // Phone
			            item2.setPhoneNumber(b.getAction());
			            break;
			        case "64887c11cce361dafc86c242":  // WhatsApp
			            item2.setWhatsappNumber(b.getAction());
			            break;
			        case "64e99c7651a484a077ae2c1f":  // Take me there
			        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
			        	if(b.getLatitude()!=null && b.getLongitude()!=null) {
			        	 item2.getLocation().setLat(Double.toString(b.getLatitude()));
			        	 
			        	 item2.getLocation().setLng(Double.toString(b.getLongitude()));}
			            break;
			        default:
			            break;
			    }
		   }
	   }
//to get name and ph nomner till here
	   
	   if(categories!=null) {
		   if(categories.size()>0) {
	   for(ObjectId o:companies.getCompanyCategories() )
	   {
		//   System.out.println("value of o : " +o);
		   for(ObjectId id : categories)
		   {
			//   System.out.println("value of id : " +id);
			  if( o.equals(id)  )
			  {		  
			//	  System.out.println("inside equals : " +o +" value of id : " +id );
				  set.add(item2);
				//  System.out.println("Contents  of list2" +set);										  
			  }
		   }
	   }
	}	
		   }   
	}	
	if(categories!=null) {
		if(categories.size()>0) {
	/*	list.clear();
	    list = new ArrayList<>(set);*/
		ull.clear();
	    ull = new ArrayList<>(set);
		}  
	}
//	System.out.println("ull : " +ull.size())  ;
	for(ad_campaigns item3:ull) // no lat lng will be null at this point
	   {	
		if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item3.getLocation().lat);
		lng1 = Double.parseDouble(item3.getLocation().lng);
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal< slider) {
			//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
			ul.add(item3);
	//	}
		}		
		if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
//Optional<users> u = usersRepo.findById(item3.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
//Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
//if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
//lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
//item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);

//if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal< slider) {
ul.add(item3);
//}
//}
}	
}	
	System.out.println("Final size of ul: " +ul.size());	
	session.removeAttribute("FinalListOfAds");
	session.setAttribute("FinalListOfAds", ul);
		   return new Gson().toJson(ul);

//	return ul;
}

@PostMapping("/categories")
public String categories(@RequestBody ArrayList<ObjectId> categories,HttpSession session) {
	System.out.println("categoeies: " + categories);
	session.setAttribute("categories", categories);
	double slider = (Double)session.getAttribute("slider");
	System.out.println("SLider : " +slider);
	 double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));	

	  double lat1 = 0.0;
	  double lng1 = 0.0;
	 		
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();List<ad_campaigns> list = new ArrayList<ad_campaigns>();
		
		//List<ad_campaigns> list = ad_campaignsRepo.findbyloccatgry(categories);
		
	/*	if (Boolean.TRUE.equals(session.getAttribute("gi")))
		 {
			 list = ad_campaignsRepo.findByGiTags(); 
		 }
		 
		 else
		 {*/
	 list = ad_campaignsRepo.findByLat();
	 
		// }
		//List<ad_campaigns> list  = ad_campaignsRepo.findByLat();
			System.out.println("------"+list.size());
		
			//System.out.println("------"+list);
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
			 if(categories.size() !=0) {
				 
				 for(ad_campaigns item:list)
				   {
					if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
					{
						//System.out.println("inside if  " );
					lat1 = Double.parseDouble(item.getLocation().lat);
					lng1 = Double.parseDouble(item.getLocation().lng);
					double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
					//System.out.println("distance val : " +distanceVal);
					//System.out.println("range : " +item.getLocation().getRange());
					if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<=slider ) {
						ull.add(item);
					}
					}
					
					if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
					{
						//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
		double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);
		if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<=slider) {
			ull.add(item);
		}
		}
		}	
		}
				 System.out.println("ull size : " +ull.size());
			for(ad_campaigns item2:ull)
			{
				
				Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
				
				//System.out.println("advertisements : " +ad.get().getCompany());
				//item.getA().setTitle(a.get().getTitle());
				//item.getA().setDescription(a.get().getDescription());
			   
			  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
			//  System.out.println("companies: " +companies.getCompanyCategories());
			  
			  
			  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
				 // System.out.println("s3 loctio : " +s3Location);
					//  item.getCompanies().setCompanyLogo(s3Location);
				 // companies.setCompanyLogoPath(s3Location);
				  String s3locationurl = s3Location.getS3Location();
				 // System.out.println("s3locationurl : " +s3locationurl);
				  companies.setCompanyLogoPath(s3locationurl);
				  
				  
			  item2.setCompanies(companies);
			   //item2.setA(ad.get());
			//to get ad path
//			  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
			// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
			  
			 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
			 //System.out.println("thumbpath : " +thumbpath);
			// ad.get().setThumbnail(thumbpath);
			 ad.get().setThumbnail(thumbpath.getS3Location());
			//to get banners start here
			 medias s3url ;
			 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
			 {
				// System.out.println("in if banners: " +ad.get().getId() );
				 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
				 
				// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
				ad.get().setContent(l.getContent());//set to advertisements first
			//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
				ArrayList<String> listofimagepaths = new ArrayList<String>();
				 for(String banner:l.getContent().getBanners())
				 {
					 s3url =  mediarepo.findByUid(banner);
					//System.out.println("s3url : " +s3url);z
					
					listofimagepaths.add(s3url.getS3Location());
				//	l.get().getContent().setBanners(listofimagepaths);
					//banner.getContent().setBanners(listofimagepaths);
					//l.getContent()
					//System.out.println("array: " +listofimagepaths);
					ad.get().getContent().setBanners(listofimagepaths);
				 }
				
			 }
			 
			//to get banners end here
			 //to get video start here
			 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
				// System.out.println("in if video: " +ad.get().getId() );
		         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
				// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
				 ad.get().setContent(l.getContent());
				 //System.out.println("ad afetr setContent() : " +ad);
				 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
				// System.out.println("s3url in video : " +s3url);
				 if(s3url!=null) {
				 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
			 }
			 
			 //to get video end here
			 //to get simple text start here
			 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
			 {
				  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
				  ad.get().setContent(l.getContent());
			 }
			 
			 //to get simple text end here
			   item2.setA(ad.get());
		//System.out.println("final ad : " +ad);
			   
			   //to get name and ph nomner
			   
	Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());	
	item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
	item2.setEmailAddress(user.get().getEmailAddress());item2.setFullName(user.get().getFullName());
	item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
			   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item2.getAdvertisementId());
			   if (cta != null && !cta.isEmpty()) {
			   for(buttonActionDTO b : cta)
			   {
				   if (b.getCtaId() == null || b.getAction() == null) continue;
				
					    switch (b.getCtaId()) {
					        case "64887c11cce361dafc86c241":  // Phone
					            item2.setPhoneNumber(b.getAction());
					            break;
					        case "64887c11cce361dafc86c242":  // WhatsApp
					            item2.setWhatsappNumber(b.getAction());
					            break;
					        case "64e99c7651a484a077ae2c1f":  // Take me there
					        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
					        	if(b.getLatitude()!=null && b.getLongitude()!=null) {
					        	 item2.getLocation().setLat(Double.toString(b.getLatitude()));
					        	 
					        	 item2.getLocation().setLng(Double.toString(b.getLongitude()));}
					            break;
					        default:
					            break;
					    }
				   }
			   }
	//to get name and ph nomner till here
	//		System.out.println("!=0");
			   for(ObjectId o:companies.getCompanyCategories() )
			   {
				//   System.out.println("value of o : " +o);
				   for(ObjectId id : categories)
				   {
					//   System.out.println("value of id : " +id);
					  if( o.equals(id)  )
					  {		  
					//	  System.out.println("inside equals : " +o +" value of id : " +id );
						  set.add(item2);
						//  System.out.println("Contents  of list2" +set);										  
					  }
				   }
			   }
		//	   System.out.println("Contents  of list2" +set);		
			//	System.out.println("item: " +item.getCampaignCategories() +"and : " +item.getId());
	}
		
			   List<ad_campaigns> list2 = new ArrayList<>(set);//convert a set to list
			 //  System.out.println("list2 size : " +list2.size());
			   for(ad_campaigns item:list2)
			   {
				if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
				{
					//System.out.println("inside if  " );
				lat1 = Double.parseDouble(item.getLocation().lat);
				lng1 = Double.parseDouble(item.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
			
			//	if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<slider ) {
					ul.add(item);
			//	}
				}
				
				if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
				{
					
	//Optional<users> u = usersRepo.findById(item.getCreatedBy());
	
	//Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
	
	//if(!(userloc.isEmpty())) {
	
	//lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
	//item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
	//double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
	
	//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<slider) {
		ul.add(item);
	//}
	//}
	}	
	}
			 }//if categories!=0
			 else
			 {
				 for(ad_campaigns item2:list) {
				 if((item2.getLocation().getLat()!=null) && (item2.getLocation().getLng()!=null))
					{
						//System.out.println("inside if  " );
					lat1 = Double.parseDouble(item2.getLocation().lat);
					lng1 = Double.parseDouble(item2.getLocation().lng);
					double distanceVal=distance(lat1,lat,lng1,lng);
					//System.out.println("distance val : " +distanceVal);
					//System.out.println("range : " +item.getLocation().getRange());
					if(distanceVal<=item2.getLocation().getRange()/1000 && distanceVal<slider ) {
						ul.add(item2);
					}
					}
					
					if((item2.getLocation().getLat()==null) && (item2.getLocation().getLng()==null))
					{
						//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item2.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item2.getLocation().setLat(String.valueOf(lat1));item2.getLocation().setLng(String.valueOf(lng1));//null pointer
		double distanceVal=distance(lat1,lat,lng1,lng);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);
		if(distanceVal<=item2.getLocation().getRange()/1000 && distanceVal<slider) {
			ul.add(item2);
		}
		}
		}
				 }
					for(ad_campaigns item3:ul)
					{
						String a = item3.getId();
						Optional<advertisements> ad = adrepo.findById(item3.getAdvertisementId());//String
						
						//System.out.println("advertisements : " +ad.get().getCompany());
						//item.getA().setTitle(a.get().getTitle());
						//item.getA().setDescription(a.get().getDescription());
					   
					  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
					//  System.out.println("companies: " +companies.getCompanyCategories());
					  
					  
					  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
						 // System.out.println("s3 loctio : " +s3Location);
							//  item.getCompanies().setCompanyLogo(s3Location);
						 // companies.setCompanyLogoPath(s3Location);
						  String s3locationurl = s3Location.getS3Location();
						 // System.out.println("s3locationurl : " +s3locationurl);
						  companies.setCompanyLogoPath(s3locationurl);
						  
						  
					  item3.setCompanies(companies);
					   //item2.setA(ad.get());
					//to get ad path
//					  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
					// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
					  
					 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
					 //System.out.println("thumbpath : " +thumbpath);
					// ad.get().setThumbnail(thumbpath);
					 ad.get().setThumbnail(thumbpath.getS3Location());
					//to get banners start here
					 medias s3url ;
					 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
					 {
						// System.out.println("in if banners: " +ad.get().getId() );
						 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
						 
						// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
						ad.get().setContent(l.getContent());//set to advertisements first
					//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
						ArrayList<String> listofimagepaths = new ArrayList<String>();
						 for(String banner:l.getContent().getBanners())
						 {
							 s3url =  mediarepo.findByUid(banner);
							//System.out.println("s3url : " +s3url);
							
							listofimagepaths.add(s3url.getS3Location());
						//	l.get().getContent().setBanners(listofimagepaths);
							//banner.getContent().setBanners(listofimagepaths);
							//l.getContent()
							//System.out.println("array: " +listofimagepaths);
							ad.get().getContent().setBanners(listofimagepaths);
						 }
						
					 }
					 
					//to get banners end here
					 //to get video start here
					 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
						// System.out.println("in if video: " +ad.get().getId() );
				         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
						// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
						 ad.get().setContent(l.getContent());
						 //System.out.println("ad afetr setContent() : " +ad);
						 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
						// System.out.println("s3url in video : " +s3url);
						 if(s3url!=null) {
						 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
					 }
					 
					 //to get video end here
					 //to get simple text start here
					 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
					 {
						  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
						  ad.get().setContent(l.getContent());
					 }
					 
					 //to get simple text end here
					   item3.setA(ad.get());
				//System.out.println("final ad : " +ad);
					   
					   //to get name and ph nomner
					   
			Optional<users> user  = 		   usersRepo.findByIdphandemail(item3.getCreatedBy());
			//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
			item3.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
			item3.setEmailAddress(user.get().getEmailAddress());item3.setFullName(user.get().getFullName());
			
			item3.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
			//System.out.println("item ph : " +item.getPhoneNumber());
			//to get name and ph nomner till here
					   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item3.getAdvertisementId());
					   if (cta != null && !cta.isEmpty()) {
					   for(buttonActionDTO b : cta)
					   {
						   if (b.getCtaId() == null || b.getAction() == null) continue;
					
							    switch (b.getCtaId()) {
							        case "64887c11cce361dafc86c241":  // Phone
							            item3.setPhoneNumber(b.getAction());
							            break;
							        case "64887c11cce361dafc86c242":  // WhatsApp
							            item3.setWhatsappNumber(b.getAction());
							            break;
							        case "64e99c7651a484a077ae2c1f":  // Take me there
							      if(b.getLatitude()!=null && b.getLongitude()!=null) {
							        	 item3.getLocation().setLat(Double.toString(b.getLatitude()));
							        	 
							        	 item3.getLocation().setLng(Double.toString(b.getLongitude()));}
							            break;
							        default:
							            break;
							    }
						   }	   
					   }				
			}
			 }
			 
			 session.removeAttribute("FinalListOfAds");
				session.setAttribute("FinalListOfAds", ul);
			System.out.println("Final size of ul: " +ul.size());
			 return new Gson().toJson(ul);
}

@PostMapping("/reset")
public String reset(HttpSession session) {
    //TODO: process POST request
	System.out.println("inreset:" +session.getAttribute("categories"));
    session.removeAttribute("categories");
    return "success";
}

@PostMapping("sendOtp.htm")
public int generateOtp(@RequestParam("mobilenumber") String mobilenumber)
{//	System.out.println("Mobile umber received : " +mobilenumber);
	Random rnd = new Random();
	int random = 1000 + rnd.nextInt(9000); 
	//System.out.println("OTP IS : " +random);
		LocalDateTime currentTime = LocalDateTime.now();
		LocalDateTime newTime = currentTime.plusMinutes(4);
		mobile_otp m = new mobile_otp();
		m.setMobile_otp_number(mobilenumber);
		m.setMobile_otp_value(random);
		m.setMobile_otp_reason("Login");
		m.setMobile_otp_status(0);
		m.setMobile_otp_confirm_time(currentTime);
		m.setMobile_otp_expiry_time(newTime);
		mobileservice.createUserOtp(m);
	
	return random;
}


@PostMapping("verifyOtp.htm")
public Map<String,String> verifyOtp(@RequestParam("mobilenumber") String mobilenumber,@RequestParam("otp") String otp,HttpSession session )
{
	System.out.println("received mobile number: " +mobilenumber +"and :" +otp);
	int number = Integer.parseInt(otp);
	boolean s = mobileservice.verifyotp(mobilenumber, number);
	 Map<String, String> response = new HashMap<>();
	if(s==true)
	{
		//System.out.println("inside true");
		session.setAttribute("mobilenumber", mobilenumber);
		//create a user
		users_keliri uk = new users_keliri();
		users_keliri u1 = new users_keliri();
		u1 = users_keliri_repo.findByPhoneNumber(mobilenumber);//check if user already exists, write join query here in service
		if(u1==null) {//if new user
		uk.setName(null);
			uk.setAge("");
			uk.setEmailId(null);
			uk.setGender("Male");
			uk.setInterest(null);
			uk.setNickName(null);
			uk.setPhoneNumber(mobilenumber);
			uk.setProfileImagePath("/Default_pfp.jpg");
		    u1=users_keliri_repo.save(uk);//save only phone number
		}
		//for existing user
		else {
			//for the user details store the profile path in session 
			session.setAttribute("profilePicPath", u1.getProfileImagePath());
			
			
		}
		response.put("status", "Success");
		response.put("profileImagePath", u1.getProfileImagePath());
		//return "Success";
		return response;
	}
	
	response.put("status","Failure");
	response.put("profileImagePath", "/Default_pfp.jpg");
	return response;
	
	
}
@GetMapping("getSessionVariable")

public String getSession(HttpSession session )
{
	//System.out.println("to get session variable");
	String mobilenumber=(String)session.getAttribute("mobilenumber");
return mobilenumber;
}

@GetMapping("getSessionVariableLocation")

public location getSessionlocation(HttpSession session )
{
	//System.out.println("to get session variable");
	String latitude=(String)session.getAttribute("latitude");
	String longitude = (String)session.getAttribute("longitude");
	location location = new location();
	location.setLat(latitude);
	location.setLng(longitude);
	//System.out.println("location Ob: " +location);	
     return location ;
}

@PostMapping("adDetails")
public String idd(@RequestParam String buttonId,HttpSession session ,HttpServletRequest request, HttpServletResponse response)
{
	session.setAttribute("adId",buttonId );
//	System.out.println("id receibed: " +buttonId);
	
		   return new Gson().toJson(buttonId);
	
}

@GetMapping("adDetailsview")
public ModelAndView adDetailsview(HttpSession session)
{
	String buttonId = (String)session.getAttribute("adId");
	
	 double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	ad_campaigns adDetail = ad_campaignsRepo.findByIdadDetails(buttonId);
//	System.out.println("List : " +adDetail);
	ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
	List<ad_campaigns> list = ad_campaignsRepo.findByLat();
	  double lat1 = 0.0;
	  double lng1 = 0.0;
//	System.out.println("------"+list.size());
	//System.out.println("------"+list);
	int i=0;
	
	for(ad_campaigns item:list)
	{
	//System.out.println("item inside for : " +item);
		Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String
		
		//System.out.println("advertisements : " +ad.get().getCompany());
		//item.getA().setTitle(a.get().getTitle());
		//item.getA().setDescription(a.get().getDescription());
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
	 // System.out.println("companies: " +companies);
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
	 // System.out.println("s3 loctio : " +s3Location);
		//  item.getCompanies().setCompanyLogo(s3Location);
	 // companies.setCompanyLogoPath(s3Location);
	  String s3locationurl = s3Location.getS3Location();
	 // System.out.println("s3locationurl : " +s3locationurl);
	  companies.setCompanyLogoPath(s3locationurl);
	  item.setCompanies(companies);
	  
	  //to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			//System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 }
	 
	 //to get video end here
	  //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 // to get simple text end here
	 
	  
	  
	   item.setA(ad.get());
//System.out.println("Compnies Object: " +companies);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item.setEmailAddress(user.get().getEmailAddress());
item.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());	   
	   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item.getAdvertisementId());
	   if (cta != null && !cta.isEmpty()) {
	   for(buttonActionDTO b : cta)
	   {
		   if (b.getCtaId() == null || b.getAction() == null) continue;
		
		   
			    switch (b.getCtaId()) {
			        case "64887c11cce361dafc86c241":  // Phone
			            item.setPhoneNumber(b.getAction());
			            break;
			        case "64887c11cce361dafc86c242":  // WhatsApp
			            item.setWhatsappNumber(b.getAction());
			            break;
			        case "64e99c7651a484a077ae2c1f":  // Take me there
			        if(b.getLatitude()!=null && b.getLongitude() !=null) {
			        	 item.getLocation().setLat(Double.toString(b.getLatitude()));
			        	 
			        	 item.getLocation().setLng(Double.toString(b.getLongitude()));}
			            break;
			        default:
			            break;
			    }
		   }
	   }
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here



		i++;
		if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item.getLocation().lat);
		lng1 = Double.parseDouble(item.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);
		if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=2.0) {
			ul.add(item);
		}
		}
		
		if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=2.0) {
ul.add(item);
}
}
}	
} //end of for
	
	//for(ad_campaigns items:adDetail)
	//{
	//System.out.println("item inside for : " +item);
		Optional<advertisements> ad = adrepo.findById(adDetail.getAdvertisementId());//String
		
	//	System.out.println("advertisements type : " +ad.get().getAdType());
		//item.getA().setTitle(a.get().getTitle());
		//item.getA().setDescription(a.get().getDescription());
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
	//  System.out.println("companies: " +companies.getCompanyLogo());
	  
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
	  //System.out.println("s3 loctio : " +s3Location);
		//  item.getCompanies().setCompanyLogo(s3Location);
	 // companies.setCompanyLogoPath(s3Location);
	  String s3locationurl = s3Location.getS3Location();
	  //System.out.println("s3locationurl : " +s3locationurl);
	  companies.setCompanyLogoPath(s3locationurl);
	  adDetail.setCompanies(companies);
	  
	  
	  //to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if : " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
		//	System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location());}
		 else
		 {
			 if(ad.get().getContent().getVideoLink().contains("youtube"))
			 {
			//	 System.out.println("inside youtube : ");
				String videoid=  ad.get().getContent().getVideoLink().substring(ad.get().getContent().getVideoLink().indexOf("=") + 1);
				//https://www.youtube.com/embed/
					ad.get().getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
			 }
		 }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	  adDetail.setA(ad.get());
	//  ad.get().setThumbnail(thumbpath);
	//  System.out.println("ad.get : " +ad.get());
	//   System.out.println("ad finally: " +ad);
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(adDetail.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
adDetail.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
adDetail.setEmailAddress(user.get().getEmailAddress());
adDetail.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here

		i++;
		if((adDetail.getLocation().getLat()!=null) && (adDetail.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(adDetail.getLocation().lat);
		lng1 = Double.parseDouble(adDetail.getLocation().lng);
		//double distanceVal=distance(lat1,lat,lng1,lng);
		//if(distanceVal<=items.getLocation().getRange()/1000 && distanceVal <=1.3) {
		///	ul.add(items);
		//}
		}
		
		if((adDetail.getLocation().getLat()==null) && (adDetail.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(adDetail.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
adDetail.getLocation().setLat(String.valueOf(lat1));adDetail.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=items.getLocation().getRange()/1000 && distanceVal <=1.3) {
//ul.add(items);
//}
}
}	
//} 
	ModelAndView mv = new  ModelAndView("adDetails");
//	System.out.println("one ad : "+adDetail);
	//System.out.println("one ad : "+ul);
	
	mv.addObject("allads",ul);
	mv.addObject("addetails", adDetail);
	
	return mv;
	
}

@GetMapping("/spotlights")//view all
public ModelAndView l3screen(HttpSession session)
{
	//System.out.println("in l3screen");
	ModelAndView mv = new ModelAndView("spotlight");
	List<users> users = usersRepo.findAll();
	for(users u : users)
	{
		//System.out.println("user id : " + u.getId());
		 ObjectId objectId = new ObjectId(u.getId());
		// System.out.println("ObjectId : " +objectId);
		user_profiles profilepicId = user_profilesrepo.findByuserId(objectId);//get profilePicturre id
		// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
		//System.out.println("Profile pic Id : " +profilepicId);
		if(profilepicId != null) {
if(profilepicId.getProfilePicture()!=null) 
{	
	medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
	if(profiles3location !=null ) 
	{
		//System.out.print		ln("profiles3location : "+profiles3location.getS3Location());
		u.setProfilePicPath(profiles3location.getS3Location());
		}
	}
	}
	}
//	System.out.println("Users: " +users.size());
	mv.addObject("users",new Gson().toJson(users));
	String spotlightid = users.get(1).getId();
	
	//to get 1st spotlight details start here
	 double lat1 = 0.0;
	  double lng1 = 0.0;
	//System.out.println("y in pathvariab : " +y);
	ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
	/*System.out.println(user.getId());
	var objectId = new ObjectId(user.getId());*/
	ul=	ad_campaignsRepo.findbycreatedBy(new ObjectId(spotlightid));
//	System.out.println("contents of ul : " +ul);
	//to find followers
ArrayList<mapping_user_folowings> followings = 	mapping_user_folowingsrepo.findbyentityId(new ObjectId(spotlightid));
//System.out.println("followings: " +followings.size());
ArrayList<ad_campaigns> noofCampaigns = ad_campaignsRepo.findbycreatedBy(new ObjectId(spotlightid));
//System.out.println("no of camp: " +noofCampaigns.size());
	for(ad_campaigns item:ul)
	{
	
		Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String			
		//System.out.println("advertisements : " +ad.get().getCompany());
		//item.getA().setTitle(a.get().getTitle());
		//item.getA().setDescription(a.get().getDescription());
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  

	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
		 // System.out.println("s3 loctio : " +s3Location);
			//  item.getCompanies().setCompanyLogo(s3Location);
		 // companies.setCompanyLogoPath(s3Location);
		  String s3locationurl = s3Location.getS3Location();
		 // System.out.println("s3locationurl : " +s3locationurl);
		  companies.setCompanyLogoPath(s3locationurl);
	  item.setCompanies(companies);
	  
	  
	  //to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			//System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
       advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	   item.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item.setEmailAddress(user.get().getEmailAddress());
item.setFullName(user.get().getFullName());
//item.setCreatedBy(user.get().getFullName());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here

	
		if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item.getLocation().lat);
		lng1 = Double.parseDouble(item.getLocation().lng);
	//	double distanceVal=distance(lat1,lat,lng1,lng);
	//	if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
			//ul.add(item);
//		}
		}
		
		if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
//ul.add(item);
//}
}
}	
		item.setNoOfCampaigns(noofCampaigns.size());
		item.setNoOfFollow(followings.size());
		//to get profile pic start here
		user_profiles profilepicId = user_profilesrepo.findByuserId(new ObjectId(spotlightid));//get profilePicturre id
		// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
	//	System.out.println("Profile pic Id : " +profilepicId);
		if(profilepicId != null) {
if(profilepicId.getProfilePicture()!=null) 
{	
	medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
	if(profiles3location !=null ) 
	{
	//	System.out.println("profiles3location : "+profiles3location.getS3Location());
		
		item.setProfilePicturePath(profiles3location.getS3Location());
		}
	}
	}
		// to get profile pic end here
} 
//  System.out.println(ul.size());
 // ModelAndView mv = new ModelAndView("spotlight");
  mv.addObject("spotlightDetails",new Gson().toJson(ul));
 
	//to get 1st spotlight details end here
	//mv.addObject("spotlightDetails");
	return mv;
}
@GetMapping("/aspotlightdetail")//ui 3
public ModelAndView aspotlightdetails(HttpSession session){
	String y = (String)session.getAttribute("spotlightid");
//	System.out.println("y : " +y);
	 double lat1 = 0.0;
	  double lng1 = 0.0;
	//System.out.println("y in pathvariab : " +y);
	ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
	/*System.out.println(user.getId());
	var objectId = new ObjectId(user.getId());*/
	ul=	ad_campaignsRepo.findbycreatedBy(new ObjectId(y));
	//System.out.println("contents of ul : " +ul);
	//to find followers
ArrayList<mapping_user_folowings> followings = 	mapping_user_folowingsrepo.findbyentityId(new ObjectId(y));
//System.out.println("followings: " +followings.size());
ArrayList<ad_campaigns> noofCampaigns = ad_campaignsRepo.findbycreatedBy(new ObjectId(y));
//System.out.println("no of camp: " +noofCampaigns.size());
	for(ad_campaigns item:ul)
	{
	
		Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String			
		//System.out.println("advertisements : " +ad.get().getCompany());
		//item.getA().setTitle(a.get().getTitle());
		//item.getA().setDescription(a.get().getDescription());
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  

	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
		 // System.out.println("s3 loctio : " +s3Location);
			//  item.getCompanies().setCompanyLogo(s3Location);
		 // companies.setCompanyLogoPath(s3Location);
		  String s3locationurl = s3Location.getS3Location();
		 // System.out.println("s3locationurl : " +s3locationurl);
		  companies.setCompanyLogoPath(s3locationurl);
	  item.setCompanies(companies);
	  
	  
	  //to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			//System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
        advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	   item.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item.setEmailAddress(user.get().getEmailAddress());
//item.setCreatedBy(user.get().getFullName());
item.setFullName(user.get().getFullName());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here

	
		if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item.getLocation().lat);
		lng1 = Double.parseDouble(item.getLocation().lng);
	//	double distanceVal=distance(lat1,lat,lng1,lng);
	//	if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
			//ul.add(item);
//		}
		}
		
		if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
//ul.add(item);
//}
}
}	
		item.setNoOfCampaigns(noofCampaigns.size());
		item.setNoOfFollow(followings.size());
		//to get profile pic start here
		user_profiles profilepicId = user_profilesrepo.findByuserId(new ObjectId(y));//get profilePicturre id
		// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
		//System.out.println("Profile pic Id : " +profilepicId);
		if(profilepicId != null) {
if(profilepicId.getProfilePicture()!=null) 
{	
	medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
	if(profiles3location !=null ) 
	{
	//	System.out.println("profiles3location : "+profiles3location.getS3Location());
		
		item.setProfilePicturePath(profiles3location.getS3Location());
		}
	}
	}
		// to get profile pic end here
} 
 //  System.out.println(ul.size());
   ModelAndView mv = new ModelAndView("spotlight");
   mv.addObject("spotlightDetails",new Gson().toJson(ul));
   
   List<users> users = usersRepo.findAll();
	for(users u : users)
	{
		//System.out.println("user id : " + u.getId());
		 ObjectId objectId = new ObjectId(u.getId());
		// System.out.println("ObjectId : " +objectId);
		user_profiles profilepicId = user_profilesrepo.findByuserId(objectId);//get profilePicturre id
		// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
		//System.out.println("Profile pic Id : " +profilepicId);
		if(profilepicId != null) {
if(profilepicId.getProfilePicture()!=null) 
{	
	medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
	if(profiles3location !=null ) 
	{
	//	System.out.println("profiles3location : "+profiles3location.getS3Location());
		u.setProfilePicPath(profiles3location.getS3Location());
		}
	}
	}
	}
	//System.out.println("Users in: " +users);
	mv.addObject("users",new Gson().toJson(users));
   return mv;
}

@PostMapping("/aspotlight")//in ui 1 on click of spotlight
public String aspotlight(@RequestBody String y,HttpSession session){
	System.out.println("y : " +y);
	session.setAttribute("spotlightid", y);
	return y;
}

@GetMapping("/spotlightslider")
public String spotlightslider(@RequestParam("slidervalue") double sliderValue,HttpSession session )
{
	System.out.println("slider value is : " +sliderValue);
	 double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	 // double lat = Double.parseDouble(location.getLat());
	 // double lng = Double.parseDouble(location.getLng());
	  double lat1 = 0.0;
	  double lng1 = 0.0;
	//	double dist_range=300.00;
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
	List<ad_campaigns> list = ad_campaignsRepo.findByLat();
//	System.out.println("------"+list.size());
	//System.out.println("------"+list);
	int i=0;
	
	for(ad_campaigns item:list)
	{
	//System.out.println("item inside for : " +item);
		Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String
		
		//System.out.println("advertisements : " +ad.get().getCompany());
		//item.getA().setTitle(a.get().getTitle());
		//item.getA().setDescription(a.get().getDescription());
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
//	  System.out.println("companies: " +companies);
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
		 // System.out.println("s3 loctio : " +s3Location);
			//  item.getCompanies().setCompanyLogo(s3Location);
		 // companies.setCompanyLogoPath(s3Location);
		  String s3locationurl = s3Location.getS3Location();
		 // System.out.println("s3locationurl : " +s3locationurl);
		  companies.setCompanyLogoPath(s3locationurl);
	  item.setCompanies(companies);
	  
	  
	  //to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			//System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	   item.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item.setEmailAddress(user.get().getEmailAddress());
item.setFullName(user.get().getFullName());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here

		i++;
		if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item.getLocation().lat);
		lng1 = Double.parseDouble(item.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);
		if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=sliderValue) {
			ul.add(item);
		}
		}
		
		if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=sliderValue) {
ul.add(item);
}
}
}	
		//to get profile pic start here
		/*		user_profiles profilepicId = user_profilesrepo.findByuserId(new ObjectId(item.getCreatedBy()));//get profilePicturre id
				// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
				System.out.println("Profile pic Id : " +profilepicId);
				if(profilepicId != null) {
		if(profilepicId.getProfilePicture()!=null) 
		{	
			medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
			if(profiles3location !=null ) 
			{
				System.out.println("profiles3location : "+profiles3location.getS3Location());
				
				item.setProfilePicturePath(profiles3location.getS3Location());
				}
			}
			}
				// to get profile pic end here
				//to find followers 
			/*	ArrayList<mapping_user_folowings> followings = 	mapping_user_folowingsrepo.findbyentityId(new ObjectId(item.getCreatedBy()));
				System.out.println("followings: " +followings.size());
				ArrayList<ad_campaigns> noofCampaigns = ad_campaignsRepo.findbycreatedBy(new ObjectId(y));
				System.out.println("no of camp: " +noofCampaigns.size());*/
} //for
	System.out.println("Final size of ul: " +ul.size());
		   return new Gson().toJson(ul);
}

@GetMapping("/All")
public void showAllAds()
{
	
	
}


@GetMapping("/ads")
public ArrayList<ad_campaigns> showCompletedAds(@RequestParam("spotlightId") String spotlightId,@RequestParam("buttonval") String buttonval,HttpSession session)
{	
		  double lat1 = 0.0;
		  double lng1 = 0.0;		  
		  buttonval = buttonval.toUpperCase();
		System.out.println("buttonval : " +buttonval +"and spotlightId : " +spotlightId);
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
		/*System.out.println(user.getId());
		var objectId = new ObjectId(user.getId());*/
		if(buttonval.equals("ACTIVE") || buttonval.equals("COMPLETED") ) {
		ul=	ad_campaignsRepo.findbycreatedByCompleted(new ObjectId(spotlightId),buttonval );}
		
		if(buttonval.equals("ALL")) {
			ul=	ad_campaignsRepo.findbycreatedByAllAds(new ObjectId(spotlightId));}
	//	System.out.println("contents of ul : " +ul);
		//to find followers
	ArrayList<mapping_user_folowings> followings = 	mapping_user_folowingsrepo.findbyentityId(new ObjectId(spotlightId));
	//System.out.println("followings: " +followings.size());
	ArrayList<ad_campaigns> noofCampaigns = ad_campaignsRepo.findbycreatedBy(new ObjectId(spotlightId));
	//System.out.println("no of camp: " +noofCampaigns.size());
		for(ad_campaigns item:ul)
		{
		
			Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String			
			//System.out.println("advertisements : " +ad.get().getCompany());
			//item.getA().setTitle(a.get().getTitle());
			//item.getA().setDescription(a.get().getDescription());
		   
		  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
	
		  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
			 // System.out.println("s3 loctio : " +s3Location);
				//  item.getCompanies().setCompanyLogo(s3Location);
			 // companies.setCompanyLogoPath(s3Location);
			  String s3locationurl = s3Location.getS3Location();
			 // System.out.println("s3locationurl : " +s3locationurl);
			  companies.setCompanyLogoPath(s3locationurl);
		  item.setCompanies(companies);
		  
		  
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item.setA(ad.get());
	//System.out.println("final ad : " +ad);
		   
		   //to get name and ph nomner
		   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item.setEmailAddress(user.get().getEmailAddress());
item.setFullName(user.get().getFullName());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here

		
			if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
			{
			//	System.out.println("in if 1 ");
			lat1 = Double.parseDouble(item.getLocation().lat);
			lng1 = Double.parseDouble(item.getLocation().lng);
		//	double distanceVal=distance(lat1,lat,lng1,lng);
		//	if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
				//ul.add(item);
	//		}
			}
			
			if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
			{
			//	System.out.println("in if 2 ");
				//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
	//ul.add(item);
//}
}
}	
			item.setNoOfCampaigns(noofCampaigns.size());
			item.setNoOfFollow(followings.size());
			
			//to get profile pic start here
			user_profiles profilepicId = user_profilesrepo.findByuserId(new ObjectId(spotlightId));//get profilePicturre id
			// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
		//	System.out.println("Profile pic Id : " +profilepicId);
			if(profilepicId != null) {
	if(profilepicId.getProfilePicture()!=null) 
	{	
		medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
		if(profiles3location !=null ) 
		{
			//System.out.println("profiles3location : "+profiles3location.getS3Location());
			
			item.setProfilePicturePath(profiles3location.getS3Location());
			}
		}
		}
			// to get profile pic end here
} //for
		
	    System.out.println(ul.size());
	    return ul;	
}

@GetMapping("/responsivelocation")
public ModelAndView showResponsiveLocation(HttpSession session)
{
	session.setAttribute("activeLink", "location");
	/*   List<users> users = usersRepo.findAll();
		for(users u : users)
		{
			
			 ObjectId objectId = new ObjectId(u.getId());
			
			user_profiles profilepicId = user_profilesrepo.findByuserId(objectId);//get profilePicturre id
			
			if(profilepicId != null) {
	if(profilepicId.getProfilePicture()!=null) 
	{	
		medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
		if(profiles3location !=null ) 
		{
		
			u.setProfilePicPath(profiles3location.getS3Location());
			}
		}
		}
		}
		// mv.addObject("users",new Gson().toJson(users));
		*/
		
	  
	   ModelAndView mv = new ModelAndView("responsivelocation");
		   return mv;

//	return ul;

}

@PostMapping("/responsivelocations")
public  List<ad_campaigns> responsivelocations(@RequestBody location location,HttpSession session)
//public  List<ad_campaigns> responsivelocations(HttpSession session)
{
	//System.out.println("in to get markers" +location);
	double lat=0.0,lng=0.0;
	if(session.getAttribute("latitude") ==null)
	{
		//System.out.println("inside if *************");
		 lat = Double.parseDouble(location.getLat());
		 lng = Double.parseDouble(location.getLng());
		 session.setAttribute("latitude", location.getLat());
			session.setAttribute("longitude", location.getLng());
	}
	else
	{
		//System.out.println("inside else ************");
	  lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  lng = Double.parseDouble((String)session.getAttribute("longitude"));
	}
	 // session.setAttribute("slider", 1.3);
	  //double slider = (Double)session.getAttribute("slider");
	double slider = 0.0;
	if(session.getAttribute("slider") !=null)
	{
		slider =(Double)session.getAttribute("slider");
	}
	else 
	{
		slider =2.0;
	}	 
	  ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
	//  System.out.println("categories : " + categories);
	  double lat1 = 0.0;
	  double lng1 = 0.0;
	//	double dist_range=300.00;
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
	//List<ad_campaigns> list = ad_campaignsRepo.findByLat();
//	System.out.println("------"+list.size());
	//System.out.println("------"+list);
		List<ad_campaigns> list = new ArrayList<ad_campaigns>();
		 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
		// System.out.println("slider: " +slider);
			 list = ad_campaignsRepo.findByLat();
			 for(ad_campaigns item:list)
			   {	
				if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item.getLocation().lat);
				lng1 = Double.parseDouble(item.getLocation().lng);
				double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
				if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal< slider) {
					//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
					ull.add(item);
				}
				}		
				if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
		double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);

		if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal< slider) {
		ull.add(item);
		}
		}
		}	
		}   	
  //  System.out.println("ull size : " +ull.size());
	for(ad_campaigns item2:ull)
	{
	
		Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  	  
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
	 String s3locationurl = s3Location.getS3Location();
	  companies.setCompanyLogoPath(s3locationurl);		  
	  item2.setCompanies(companies);
		
	//to get ad path
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 ad.get().setThumbnail(thumbpath.getS3Location());
		
	//to get banners start here
	 medias s3url ;
	/* if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		ad.get().setContent(l.getContent());//set to advertisements first
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			s3url =  mediarepo.findByUid(banner);
			listofimagepaths.add(s3url.getS3Location());
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }*/
	 
	//to get banners end here
	 //to get video start here
/*	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
      advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 }*/
	 
	 //to get video end here
	 //to get simple text start here
/*	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 */
	 //to get simple text end here
	   item2.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item2.setEmailAddress(user.get().getEmailAddress());
item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here
List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item2.getAdvertisementId());
if (cta != null && !cta.isEmpty()) {
for(buttonActionDTO b : cta)
{
	   if (b.getCtaId() == null || b.getAction() == null) continue;
		    switch (b.getCtaId()) {
		        case "64887c11cce361dafc86c241":  // Phone
		            item2.setPhoneNumber(b.getAction());
		            break;
		        case "64887c11cce361dafc86c242":  // WhatsApp
		            item2.setWhatsappNumber(b.getAction());
		            break;
		        case "64e99c7651a484a077ae2c1f":  // Take me there
		        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
		        	if(b.getLatitude()!=null && b.getLongitude()!=null) {
		        	 item2.getLocation().setLat(Double.toString(b.getLatitude()));
		        	 
		        	 item2.getLocation().setLng(Double.toString(b.getLongitude()));}
		            break;
		        default:
		            break;
		    }
	   }
}
	   
	  if(categories!=null) {
		  if(categories.size()>0) {
//if(categories.size() !=0 || categories!=null) {
	   for(ObjectId o:companies.getCompanyCategories() )
	   {
		//   System.out.println("value of o : " +o);
		   for(ObjectId id : categories)
		   {
			//   System.out.println("value of id : " +id);
			  if( o.equals(id)  )
			  {		  
			//	  System.out.println("inside equals : " +o +" value of id : " +id );
				  set.add(item2);
				//  System.out.println("Contents  of list2" +set);										  
			  }
		   }
	   }
		  }
	}	   
	}	
	//System.out.println("set: " +set.size());
	//System.out.println("categories: " +categories.size());
	if(categories!=null) {
		if(categories.size()>0) {
	//if(categories.size() !=0 || categories!=null) {
		//System.out.println("categories!=null ");
		/*list.clear();
	    list = new ArrayList<>(set);*/
	    ull.clear();
	    ull = new ArrayList<>(set);
		}
	    }
//	System.out.println("ull after set: " +ull.size());
	   for(ad_campaigns item:ull)
	   {	
		if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item.getLocation().lat);
		lng1 = Double.parseDouble(item.getLocation().lng);
	//	double distanceVal=distance(lat1,lat,lng1,lng);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal< slider) {
			//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
			ul.add(item);
		//}
		}		
		if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
//Optional<users> u = usersRepo.findById(item.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
//Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
//if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
//lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
//item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);
//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal< slider) {
ul.add(item);
//}
//}
}	
}   	
	   System.out.println("Final size of ul: " +ul .size());
	   //return new Gson().toJson(ul);
	   
	   session.removeAttribute("FinalListOfAds");
		session.setAttribute("FinalListOfAds", ul);
	   
	   
	   return ul;	   
}

@GetMapping("/otheradsbypubli")
public Map<String, Object> toshowotheradsbypubli(@RequestParam("adId") String adcampaignId,@RequestParam("createdBy") String createdBy,HttpSession session, HttpServletRequest request)
{
	getSessionAnalytics(request).ads.add(adcampaignId);
	 double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	ad_campaigns adDetail = ad_campaignsRepo.findByIdadDetails(adcampaignId);
	ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
	  double lat1 = 0.0;
	  double lng1 = 0.0;double lat2 = 0.0;
	  double lng2 = 0.0;
      int i=0;
	
	//to find details of single ad start here
		Optional<advertisements> ad = adrepo.findById(adDetail.getAdvertisementId());//String	   
	    companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
	    medias s3Location = mediarepo.findById(companies.getCompanyLogo());
	    String s3locationurl = s3Location.getS3Location();
	    companies.setCompanyLogoPath(s3locationurl);
	    adDetail.setCompanies(companies);
	    medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	    ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 
	 
	 
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {		
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 ad.get().setContent(l.getContent());//set to advertisements first
		 ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			 listofimagepaths.add(s3url.getS3Location());
		     ad.get().getContent().setBanners(listofimagepaths);
		 }
		 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		ad.get().setContent(l.getContent());
		s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 
		 else
		 {
			 if(ad.get().getContent().getVideoLink().contains("youtube"))
			 {
			//	 System.out.println("inside youtube : ");
				String videoid=  ad.get().getContent().getVideoLink().substring(ad.get().getContent().getVideoLink().indexOf("=") + 1);
				//https://www.youtube.com/embed/
					ad.get().getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
			 }
		 }
		 
		 
	
	 }
	 
	 //to get video end here
	  //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 	 // to get simple text end here
	 adDetail.setA(ad.get());

	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(adDetail.getCreatedBy());
adDetail.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
adDetail.setEmailAddress(user.get().getEmailAddress());adDetail.setFullName(user.get().getFullName());
adDetail.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(adDetail.getAdvertisementId());
if (cta != null && !cta.isEmpty()) {
for(buttonActionDTO b : cta)
{
	   if (b.getCtaId() == null || b.getAction() == null) continue;
		    switch (b.getCtaId()) {
		        case "64887c11cce361dafc86c241":  // Phone
		            adDetail.setPhoneNumber(b.getAction());
		            break;
		        case "64887c11cce361dafc86c242":  // WhatsApp
		            adDetail.setWhatsappNumber(b.getAction());
		            break;
		        case "64e99c7651a484a077ae2c1f":  // Take me there
		        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
		        	if(b.getLatitude()!=null && b.getLongitude()!=null) {
		        	 adDetail.getLocation().setLat(Double.toString(b.getLatitude()));
		        	 
		        	 adDetail.getLocation().setLng(Double.toString(b.getLongitude()));}
		            break;
		        default:
		            break;
		    }
	   }
}
//to get name and ph nomner till here
		i++;
if((adDetail.getLocation().getLat()!=null) && (adDetail.getLocation().getLng()!=null))
{
		lat1 = Double.parseDouble(adDetail.getLocation().lat);
		lng1 = Double.parseDouble(adDetail.getLocation().lng);
		
		
}
		
		if((adDetail.getLocation().getLat()==null) && (adDetail.getLocation().getLng()==null))
		{		
Optional<users> u = usersRepo.findById(adDetail.getCreatedBy());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
if(!(userloc.isEmpty())) {
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
adDetail.getLocation().setLat(String.valueOf(lat1));adDetail.getLocation().setLng(String.valueOf(lng1));//null pointer

}
}	
		//to find details of single ad end here
		//to find all ads of a single publisher start here
		//ul=	ad_campaignsRepo.findbycreatedByAllAds(new ObjectId(createdBy));

	/*for(ad_campaigns item:ul)
	{
	
		Optional<advertisements> adm = adrepo.findById(item.getAdvertisementId());//String	//m for many		
		
	    companies companiesm =  companyrepo.findBycustomId(adm.get().getCompany());  

	    medias s3Locationm = mediarepo.findById(companiesm.getCompanyLogo());
		
		String s3locationurlm = s3Locationm.getS3Location();
		
		companiesm.setCompanyLogoPath(s3locationurlm);
	  
		item.setCompanies(companiesm);
	  
	  
	  //to get ad path

	  
	 medias thumbpathm =  mediarepo.findById(new ObjectId(adm.get().getThumbnail()));
	 
	 adm.get().setThumbnail(thumbpathm.getS3Location());
	//to get banners start here
	 medias s3urlm ;
	 if(adm.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements lm = adrepo.findbyContent(new ObjectId(adm.get().getId()));
		
		adm.get().setContent(lm.getContent());//set to advertisements first
	
		ArrayList<String> listofimagepathsm = new ArrayList<String>();
		 for(String bannerm:lm.getContent().getBanners())
		 {
			 s3urlm =  mediarepo.findByUid(bannerm);
			//System.out.println("s3url : " +s3url);
			
			listofimagepathsm.add(s3urlm.getS3Location());
		
			adm.get().getContent().setBanners(listofimagepathsm);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(adm.get().getAdType().equals("64887c11cce361dafc86c23c")) {
	
         advertisements lm = adrepo.findbyContent(new ObjectId(adm.get().getId()));		 
		
		 adm.get().setContent(lm.getContent());
		 
		 s3urlm =  mediarepo.findByUid(lm.getContent().getVideoLink());
		
		 if(s3urlm!=null) {
		 adm.get().getContent().setVideoLink(s3urlm.getS3Location()); }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(adm.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements lm = adrepo.findbyContent(new ObjectId(adm.get().getId()));
		  adm.get().setContent(lm.getContent());
	 }
	 
	 //to get simple text end here
	   item.setA(adm.get());
   
	   //to get name and ph nomner
	   
Optional<users> userm  = 		   usersRepo.findByIdphandemail(item.getCreatedBy());

item.setPhoneNumber(userm.get().getPhoneNumber().getDialNumber());
item.setEmailAddress(userm.get().getEmailAddress());
item.setFullName(userm.get().getFullName());

//to get name and ph nomner till here

	
if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
{	
		lat2 = Double.parseDouble(item.getLocation().lat);
		lng2 = Double.parseDouble(item.getLocation().lng);		
}
		
if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
{		
Optional<users> um = usersRepo.findById(item.getCreatedBy());

Optional<txn_user_locations> userlocm =txnuserrepo.findById(um.get().getLastKnownLocation());

if(!(userlocm.isEmpty())) {

lng2=userlocm.get().getLocation().getX();lat2=userlocm.get().getLocation().getY();
item.getLocation().setLat(String.valueOf(lat2));item.getLocation().setLng(String.valueOf(lng2));//null pointer

}
}	
		
		
		//to get profile pic start here
	/*	user_profiles profilepicIdm = user_profilesrepo.findByuserId(new ObjectId(createdBy));//get profilePicturre id
		
		if(profilepicIdm != null) {
if(profilepicIdm.getProfilePicture()!=null) 
{	
	medias profiles3locationm = 	 mediarepo.findById(profilepicIdm.getProfilePicture());
	if(profiles3locationm !=null ) 
	{	
		item.setProfilePicturePath(profiles3locationm.getS3Location());
		}
	}
	}*/
		// to get profile pic end here
//} //for*/
	
	
		Map<String, Object> response = new HashMap<>(); 
		//System.out.println("adDetail: " +adDetail.getA().getCustomTextSection());
		response.put("onead", adDetail); 
		response.put("allads", ul); 
		//System.out.println(response.get("onead"));
		//return  new Gson().toJson(response);
		return response;
}

@GetMapping("/responsivespotlight")// from responsivefooter on click of spotlight footer
public ModelAndView respspotlight (HttpSession session) {
	//    System.out.println("in responsive spotlight");
	    ModelAndView mv = new ModelAndView("responsivespotlight");
		List<users> spotlightList = new ArrayList<users>();
		
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
		ArrayList<ad_campaigns> ulspotlightList=new ArrayList<ad_campaigns>();String spotlightid="";
	    if(session.getAttribute("latitude")!=null) {
	    double lat = Double.parseDouble((String)session.getAttribute("latitude"));
		  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	    
	//	  System.out.println("Location from session not null: " +lat);
		  double latspotlyt = 0.0;
		  double lngspotlyt = 0.0;
	//	  Point location = new Point(lng, lat);
		/*  double[] location = {lng, lat};
		  double maxdistanceinmeters=5000;
		  System.out.println("Location : " +location[0] +"and : " +location[1]);
	List<users> usersList=	  txnuserrepo.findNearbySpotlights(location, maxdistanceinmeters);
	System.out.println("usersList: " +usersList.size() );
	System.out.println("usersList: " +usersList );*/
		
		List<users> users = usersRepo.findAll();
		session.setAttribute("activeLink", "spotlight");
	
		for(users u1 : users)
		{
			//Optional<users> u = usersRepo.findById(u1.getLastKnownLocation());
			Optional<txn_user_locations> userlocspotlyt =txnuserrepo.findById(u1.getLastKnownLocation());
			if(!(userlocspotlyt.isEmpty())) {
				lngspotlyt=userlocspotlyt.get().getLocation().getX();latspotlyt=userlocspotlyt.get().getLocation().getY();
		
			double distanceVal=distance(latspotlyt,lat,lngspotlyt,lng);
			if(distanceVal<=5.3) {
				spotlightList.add(u1);
			} 
			}
		}
		
		//System.out.println("spotlight List : " +spotlightList.size());
		for(users u : spotlightList)
		{
			//System.out.println("user id : " + u.getId());
			 ObjectId objectId = new ObjectId(u.getId());
			// System.out.println("ObjectId : " +objectId);
			user_profiles profilepicId = user_profilesrepo.findByuserId(objectId);//get profilePicturre id
			// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
			//System.out.println("Profile pic Id : " +profilepicId);
			if(profilepicId != null) {
	 if(profilepicId.getProfilePicture()!=null) 
	{	
		medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
		if(profiles3location !=null ) 
		{
			//System.out.print		ln("profiles3location : "+profiles3location.getS3Location());
			u.setProfilePicPath(profiles3location.getS3Location());
			}
		}
		}
		}
//		System.out.println("Users: " +users.size());
		//mv.addObject("users",new Gson().toJson(users));
		mv.addObject("users",new Gson().toJson(spotlightList));
		//String spotlightid = users.get(1).getId();
	//	String spotlightid = spotlightList.get(0).getId();
		//to get 1st spotlight details start here
		 double lat1 = 0.0;
		  double lng1 = 0.0;
		//System.out.println("y in pathvariab : " +y);
	
		/*System.out.println(user.getId());
		var objectId = new ObjectId(user.getId());*/
		for(users s1 :spotlightList) {
			 spotlightid = s1.getId();
			ul=	ad_campaignsRepo.findbycreatedBy(new ObjectId(spotlightid));
		if(!(ul.isEmpty()) && (ul.size()>=1)) {
			break;
		}
		
		}
//		System.out.println("contents of ul : " +ul);
		//to find followers
	ArrayList<mapping_user_folowings> followings = 	mapping_user_folowingsrepo.findbyentityId(new ObjectId(spotlightid));
	//System.out.println("followings: " +followings.size());
	ArrayList<ad_campaigns> noofCampaigns = ad_campaignsRepo.findbycreatedBy(new ObjectId(spotlightid));
	//System.out.println("no of camp: " +noofCampaigns.size());
		for(ad_campaigns item:ul)
		{		
			Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String			
			//System.out.println("advertisements : " +ad.get().getCompany());
			//item.getA().setTitle(a.get().getTitle());
			//item.getA().setDescription(a.get().getDescription());
		   
		  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  

		  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
			 // System.out.println("s3 loctio : " +s3Location);
				//  item.getCompanies().setCompanyLogo(s3Location);
			 // companies.setCompanyLogoPath(s3Location);
			  String s3locationurl = s3Location.getS3Location();
			 // System.out.println("s3locationurl : " +s3locationurl);
			  companies.setCompanyLogoPath(s3locationurl);
		      item.setCompanies(companies);
		  
		  
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	       advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
			 else
			 {
				 if(ad.get().getContent().getVideoLink().contains("youtube"))
				 {
				//	 System.out.println("inside youtube : ");
					String videoid=  ad.get().getContent().getVideoLink().substring(ad.get().getContent().getVideoLink().indexOf("=") + 1);
					//https://www.youtube.com/embed/
						ad.get().getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
				 }
			 }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item.setA(ad.get());
	//System.out.println("final ad : " +ad);
		   
		   //to get name and ph nomner
		   
	Optional<users> user  = 		   usersRepo.findByIdphandemail(item.getCreatedBy());
	//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
	item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
	item.setEmailAddress(user.get().getEmailAddress());
	item.setFullName(user.get().getFullName());
	//item.setCreatedBy(user.get().getFullName());
	//System.out.println("item ph : " +item.getPhoneNumber());
	//to get name and ph nomner till here

		
			if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
			{
			//	System.out.println("in if 1 ");
			lat1 = Double.parseDouble(item.getLocation().lat);
			lng1 = Double.parseDouble(item.getLocation().lng);
		//	double distanceVal=distance(lat1,lat,lng1,lng);
		//	if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
				//ul.add(item);
//			}
			}
			
			if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
			{
			//	System.out.println("in if 2 ");
				//System.out.println("Created By : " +item.getCreatedBy());
	//ObjectId id = new ObjectId(item.getCreatedBy());
	//System.out.println("ObjectId : " +id);
	Optional<users> u = usersRepo.findById(item.getCreatedBy());
	//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
	Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
	//System.out.println("user locations : " +userloc);
	if(!(userloc.isEmpty())) {
	//System.out.println(userloc.get().getLocation().getX());
	//System.out.println(userloc.get().getLocation().getY());
	lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
	item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
	//double distanceVal=distance(lat1,lat,lng1,lng);
	//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

	//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
	//ul.add(item);
	//}
	}
	}	
			item.setNoOfCampaigns(noofCampaigns.size());
			item.setNoOfFollow(followings.size());
			//to get profile pic start here
			user_profiles profilepicId = user_profilesrepo.findByuserId(new ObjectId(spotlightid));//get profilePicturre id
			// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
		//	System.out.println("Profile pic Id : " +profilepicId);
			if(profilepicId != null) {
	if(profilepicId.getProfilePicture()!=null) 
	{	
		medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
		if(profiles3location !=null ) 
		{
		//	System.out.println("profiles3location : "+profiles3location.getS3Location());
			
			item.setProfilePicturePath(profiles3location.getS3Location());
			}
		}
		}
			// to get profile pic end here
	} 
	//  System.out.println("ul:" +ul);
	 // ModelAndView mv = new ModelAndView("spotlight");
	  
	    
	  mv.addObject("spotlightDetails",new Gson().toJson(ul));
	    }
		//to get 1st spotlight details end here
		//mv.addObject("spotlightDetails");
	    else
	    {
	    	mv.addObject("users",new Gson().toJson(spotlightList));
	    	  mv.addObject("spotlightDetails",new Gson().toJson(ul));
	    }
		return mv;
}

@GetMapping("/adDetailSpotlight")
public void adDetailFromSpotlight(@RequestParam String param1, @RequestParam String param2) 
{
System.out.println("adid: " +param1);
System.out.println("createdBy: " +param2);
String spotlightid= param2;
String adId= param1;
double lat1 = 0.0;
double lng1 = 0.0;		  
//	System.out.println("y : " +y);
ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
/*System.out.println(user.getId());
var objectId = new ObjectId(user.getId());*/
ul=	ad_campaignsRepo.findbycreatedBy(new ObjectId(spotlightid));
//	System.out.println("contents of ul : " +ul);
//to find followers
ArrayList<mapping_user_folowings> followings = 	mapping_user_folowingsrepo.findbyentityId(new ObjectId(spotlightid));
//System.out.println("followings: " +followings.size());
ArrayList<ad_campaigns> noofCampaigns = ad_campaignsRepo.findbycreatedBy(new ObjectId(spotlightid));
//System.out.println("no of camp: " +noofCampaigns.size());
for(ad_campaigns item:ul)
{

	Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String			
	//System.out.println("advertisements : " +ad.get().getCompany());
	//item.getA().setTitle(a.get().getTitle());
	//item.getA().setDescription(a.get().getDescription());
 
companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  

medias s3Location = mediarepo.findById(companies.getCompanyLogo());
	 // System.out.println("s3 loctio : " +s3Location);
		//  item.getCompanies().setCompanyLogo(s3Location);
	 // companies.setCompanyLogoPath(s3Location);
	  String s3locationurl = s3Location.getS3Location();
	 // System.out.println("s3locationurl : " +s3locationurl);
	  companies.setCompanyLogoPath(s3locationurl);
item.setCompanies(companies);


//to get ad path
//System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());

medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
//System.out.println("thumbpath : " +thumbpath);
// ad.get().setThumbnail(thumbpath);
ad.get().setThumbnail(thumbpath.getS3Location());
//to get banners start here
medias s3url ;
if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
{
	// System.out.println("in if banners: " +ad.get().getId() );
	 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
	 
	// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
	ad.get().setContent(l.getContent());//set to advertisements first
//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
	ArrayList<String> listofimagepaths = new ArrayList<String>();
	 for(String banner:l.getContent().getBanners())
	 {
		 s3url =  mediarepo.findByUid(banner);
		//System.out.println("s3url : " +s3url);
		
		listofimagepaths.add(s3url.getS3Location());
	//	l.get().getContent().setBanners(listofimagepaths);
		//banner.getContent().setBanners(listofimagepaths);
		//l.getContent()
		//System.out.println("array: " +listofimagepaths);
		ad.get().getContent().setBanners(listofimagepaths);
	 }
	
}

//to get banners end here
//to get video start here
if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
	// System.out.println("in if video: " +ad.get().getId() );
   advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
	// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
	 ad.get().setContent(l.getContent());
	 //System.out.println("ad afetr setContent() : " +ad);
	 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
	// System.out.println("s3url in video : " +s3url);
	 if(s3url!=null) {
	 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
}

//to get video end here
//to get simple text start here
if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
{
	  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
	  ad.get().setContent(l.getContent());
}

//to get simple text end here
 item.setA(ad.get());
//System.out.println("final ad : " +ad);
 
 //to get name and ph nomner
 
Optional<users> user  = 		   usersRepo.findByIdphandemail(item.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item.setEmailAddress(user.get().getEmailAddress());
item.setFullName(user.get().getFullName());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here


	if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
	{
	//	System.out.println("in if 1 ");
	lat1 = Double.parseDouble(item.getLocation().lat);
	lng1 = Double.parseDouble(item.getLocation().lng);
//	double distanceVal=distance(lat1,lat,lng1,lng);
//	if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
		//ul.add(item);
//		}
	}
	
	if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
	{
	//	System.out.println("in if 2 ");
		//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);
//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
//ul.add(item);
//}
}
}	
	item.setNoOfCampaigns(noofCampaigns.size());
	item.setNoOfFollow(followings.size());			
	//to get profile pic start here
	user_profiles profilepicId = user_profilesrepo.findByuserId(new ObjectId(spotlightid));//get profilePicturre id
	// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
//	System.out.println("Profile pic Id : " +profilepicId);
	if(profilepicId != null) {
if(profilepicId.getProfilePicture()!=null) 
{	
medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
if(profiles3location !=null ) 
{
	//System.out.println("profiles3location : "+profiles3location.getS3Location());
	
	item.setProfilePicturePath(profiles3location.getS3Location());
	}
}
}
	// to get profile pic end here
} 		
System.out.println(ul.size());
//return ul;
}

@GetMapping("/home")
public String homepage(HttpSession session)
{
	//System.out.println("slider value is : " +sliderValue);
	 double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	 // session.setAttribute("slider", sliderValue);
	  double slider = (Double)session.getAttribute("slider");
	  ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
	  double lat1 = 0.0;
	  double lng1 = 0.0;
	//	double dist_range=300.00;
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
	//List<ad_campaigns> list = ad_campaignsRepo.findByLat();
//	System.out.println("------"+list.size());
	//System.out.println("------"+list);
		List<ad_campaigns> list = new ArrayList<ad_campaigns>();
		 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
			 list = ad_campaignsRepo.findByLat();

	for(ad_campaigns item2:list)
	{
	//System.out.println("item inside for : " +item);
		Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
		
		//System.out.println("advertisements : " +ad.get().getCompany());
		//item.getA().setTitle(a.get().getTitle());
		//item.getA().setDescription(a.get().getDescription());
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
//	  System.out.println("companies: " +companies); 
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
		 // System.out.println("s3 loctio : " +s3Location);
			//  item.getCompanies().setCompanyLogo(s3Location);
		 // companies.setCompanyLogoPath(s3Location);
		  String s3locationurl = s3Location.getS3Location();
		 // System.out.println("s3locationurl : " +s3locationurl);
		  companies.setCompanyLogoPath(s3locationurl);
		  
	  item2.setCompanies(companies);
	//to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			//System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
        advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	   item2.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item2.setEmailAddress(user.get().getEmailAddress());
item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here
	   
	   if(categories!=null) {
	   for(ObjectId o:companies.getCompanyCategories() )
	   {
		//   System.out.println("value of o : " +o);
		   for(ObjectId id : categories)
		   {
			//   System.out.println("value of id : " +id);
			  if( o.equals(id)  )
			  {		  
			//	  System.out.println("inside equals : " +o +" value of id : " +id );
				  set.add(item2);
				//  System.out.println("Contents  of list2" +set);										  
			  }
		   }
	   }
	}	   
	}	
	if(categories!=null) {
		list.clear();
	    list = new ArrayList<>(set);}
	   for(ad_campaigns item:list)
	   {	
		if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item.getLocation().lat);
		lng1 = Double.parseDouble(item.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);
		if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal< slider) {
			//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
			ul.add(item);
		}
		}		
		if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);
//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);

if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal< slider) {
ul.add(item);
}
}
}	
} 
	System.out.println("Final size of ul: " +ul .size());
		   return new Gson().toJson(ul);

//	return ul;
	
}

@PostMapping("keyword")
public List<ad_campaigns> search(@RequestBody String searchKeyword,HttpSession session, HttpServletRequest request)
{
	//to search ad_campaigns
	//ad_campaignsRepo
	 getSessionAnalytics(request).keywords.add(searchKeyword);
	System.out.println("in keyword : " +searchKeyword);List<ad_campaigns> finalul = new ArrayList<ad_campaigns>();
	
	session.setAttribute("searchKeyword", searchKeyword);
	 String escapedKeyword = searchKeyword.replaceAll("([\\W])", "\\\\$1"); // Escape special characters
     String regex = ".*" + escapedKeyword + ".*"; // Construct regex pattern
	List<ad_campaigns> searchresult1 =ad_campaignsRepo.searchAllFields(regex);
//	String afterescape=searchKeyword.replaceAll("([\\\\.*+?^=!:${}()|[\\]\\\\])", "\\\\$1");//Gives error
	
	
    // System.out.println(escapedKeyword +"and : " +regex);
	List<advertisements> searchresult2 = adrepo.searchAllFields(regex);
	
//	String s1 = searchKeyword.replaceAll("([\\\\.*+?^${}()|\\[\\]\\])", "\\\\$1");
			    
//    System.out.println(s1 +"and : " +"and : " );
	
	List<companies> searchresult3= companyrepo.searchAllFields(regex);
	
	List<users> searchresult4 = usersRepo.searchAllFields(regex);
	
	List<master_product_categories> searchresult5 = productRepo.searchAllFields(regex);
	
	//System.out.println("Search Result1 : " +searchresult1.size() +"\n");
	//System.out.println("Search Result2 : " +searchresult2.size()+"\n");
	//System.out.println("Search Result3 : " +searchresult3.size() +"\n");
	//System.out.println("Search Result4 : " +searchresult4.size() +"\n");
	//System.out.println("Search Result5 : " +searchresult5.size() +"\n");
	//System.out.println("Search Result5 : " +searchresult5 +"\n");g
	//when found in advertisemenst start here
	List<ObjectId> searchresult22= new ArrayList<ObjectId>();	
	for(advertisements sr2:searchresult2 )//if advertisements is not empty
	{
		//find if the record with this advertisementId is active
	searchresult22.add(new ObjectId(sr2.getId()));		
	}
	List<ad_campaigns> sublist1 = 	ad_campaignsRepo.searchwithadId(searchresult22);   //sub1
	//System.out.println("sublist1 from advertisements : " +sublist1.size() +"\n");
	//when found in advertisemenst end here
	
	//when found in companies start here
	List<ObjectId> searchresult33= new ArrayList<ObjectId>();
	List<ObjectId> searchresult331= new ArrayList<ObjectId>();
	for(companies sr3:searchresult3)//if companies is not empty
	{
		//find all the advertisements with this company and then check active so 2queries 
		searchresult33.add(new ObjectId(sr3.getId()));		
	}
	
	List<advertisements> list2 =adrepo.searchByCompanyId(searchresult33);
	for(advertisements a : list2)
	{
	searchresult331.add(new ObjectId(a.getId()));	
	}
	List<ad_campaigns> sublist3 = ad_campaignsRepo.searchwithadId(searchresult331);  //sub
	//System.out.println("sublist3 from companies: " +sublist3.size() +"\n");
	//when found in companies end here
	

	
	//when found in users start here
	List<ObjectId> searchresult44= new ArrayList<ObjectId>();
	for(users sr4:searchresult4 ) { //if users is not empty
		searchresult44.add(new ObjectId(sr4.getId()));
	}
		//check the ad_campaigns
    List<ad_campaigns>	sublist4 = ad_campaignsRepo.searchWithCreatedBy(searchresult44); //sub
	System.out.println("sublist4 from users : " +sublist4.size() +"\n");

	//when found in users end here
	
	//when found in product category start here
	List<ObjectId> searchresult55= new ArrayList<ObjectId>();
	for(master_product_categories sr5:searchresult5)//if master_product_categories is not empty
	{
		searchresult55.add(new ObjectId(sr5.getId()));
	}
		//check the companies  category array for this id, then advertisement then ad_campaigns
	
	List<companies> list5 = companyrepo.searchByCompanyCategory(searchresult55);

	List<ObjectId> searchresult551= new ArrayList<ObjectId>();
	for(companies c :list5 ) {
		searchresult551.add(new ObjectId(c.getId()));
	}
	
	List<advertisements> list6 = adrepo.searchByCompanyId(searchresult551);
	List<ObjectId> searchresult552= new ArrayList<ObjectId>();
    for(advertisements a:list6)
    {
    	searchresult552.add(new ObjectId(a.getId()));
    }
	List<ad_campaigns> sublist7 = ad_campaignsRepo.searchwithadId(searchresult552);          //sub
   System.out.println("sublist7 from product category : " +sublist7.size());
	//when found in product category end here
	
	//System.out.println("sublist1 : " +sublist1.size() +"and contents: " +sublist1);
	//System.out.println("sublist2 : " +sublist3.size() +"and contents: " +sublist3);
	//System.out.println("sublist3 : " +sublist4.size() +"and contents: " +sublist4);
	//System.out.println("sublist4 : " +sublist7.size() +"and contents: " +sublist7);
	 List<ad_campaigns> ull = new ArrayList<ad_campaigns>();
	 ull.addAll(sublist1);
	 ull.addAll(sublist3);
	 ull.addAll(sublist4);
     ull.addAll(sublist7);
	// System.out.println("ull : " +ull.size());
	 List<ad_campaigns> duplicateElementsRemoved = new ArrayList<ad_campaigns>();
	 Set<String> seenIds = new HashSet<>();
	 for(ad_campaigns element : ull)
	 {
		// System.out.println(element.getId());
	         /*   if (Collections.frequency(ull, element) > 1 && !duplicateElementsRemoved.contains(element)) {
	            	duplicateElementsRemoved.add(element);
	            }	*/
		
		 if (seenIds.add(element.getId())) {
			// System.out.println(seenIds.add(element.getId()));
			 duplicateElementsRemoved.add(element);
         }
		// System.out.println("size of set : " +seenIds.size());
	 }
	 
	 //System.out.println("duplicateElementsRemoved : " +duplicateElementsRemoved.size());
		
//to get the reachable ads start here 
	 
	
	 
	 double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	
//	  double slider = (Double)session.getAttribute("slider");
	  double slider=0.0;
	  ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
	  double lat1 = 0.0;
	  double lng1 = 0.0;
	  if(session.getAttribute("slider") !=null)
		{
			slider =(Double)session.getAttribute("slider");
		}
		else 
		{
			slider =2.0;
		}
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ulll=new ArrayList<ad_campaigns>();
	//List<ad_campaigns> list = ad_campaignsRepo.findByLat();
//	System.out.println("------"+list.size());
	//System.out.println("------"+list);
		List<String> listOfIds = new ArrayList<String>();
		for(ad_campaigns d : duplicateElementsRemoved)
		{
			listOfIds.add(d.getId());
		}
		List<ad_campaigns> list = new ArrayList<ad_campaigns>();
		 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
		 //System.out.println("slider: " +slider);
		 //System.out.println("categories: " +categories);
			 list = ad_campaignsRepo.searchfromfinallist(listOfIds);
			
			 for(ad_campaigns item:list)
			   {	
				 
				 if(item.getGiTag()==1 || item.getTemple()==1 || item.getForest() ==1 || item.getHeritage() ==1 || item.getHospital() ==1 || item.getBus()==1 || item.getCar() ==1 || item.getRickshaw() ==1 || item.getGoods()==1 || item.getVlogs() ==1 || item.getNews() ==1)
				 {  
					 if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
						{
						
						lat1 = Double.parseDouble(item.getLocation().lat);
						lng1 = Double.parseDouble(item.getLocation().lng);
						double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
						
						//if gitag is enabled do not check the distance  
						/*if(distanceVal<=item.getLocation().getRange()/1000 ) */{
							//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
							ulll.add(item);
						}
						}		
						if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
						{
						
				Optional<users> u = usersRepo.findById(item.getCreatedBy());
				
				Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
				
				if(!(userloc.isEmpty())) {
				
				lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
				item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
				double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
				
				/*if(distanceVal<=item.getLocation().getRange()/1000)*/ {
				ulll.add(item);
				}
				}
				}	
										
				 }
				 
				 else {
				if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
				{
				
				lat1 = Double.parseDouble(item.getLocation().lat);
				lng1 = Double.parseDouble(item.getLocation().lng);
				double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
				
				//if gitag is enabled do not check the distance  
				if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<= slider) {
					//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
					ulll.add(item);
				}
				}		
				if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
				{
				
		Optional<users> u = usersRepo.findById(item.getCreatedBy());
		
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		
		if(!(userloc.isEmpty())) {
		
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
		double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
		
		if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<= slider) {
		ulll.add(item);
		}
		}
		}	
		} 
				 
			   }		 
			// System.out.println("ull size : " +ulll.size());
	for(ad_campaigns item2:ulll)
	{
	//System.out.println("item inside for : " +item);
		Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
		
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
//	  System.out.println("companies: " +companies); 
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
		 // System.out.println("s3 loctio : " +s3Location);
			//  item.getCompanies().setCompanyLogo(s3Location);
		 // companies.setCompanyLogoPath(s3Location);
		  String s3locationurl = s3Location.getS3Location();
		 // System.out.println("s3locationurl : " +s3locationurl);
		  companies.setCompanyLogoPath(s3locationurl);
		  
	  item2.setCompanies(companies);
	//to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			//System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	   item2.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = usersRepo.findByIdphandemail(item2.getCreatedBy());
item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item2.setEmailAddress(user.get().getEmailAddress());item2.setFullName(user.get().getFullName());
item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber())	   ;
	   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item2.getAdvertisementId());
	   
	   if (cta != null && !cta.isEmpty()) {
	   for(buttonActionDTO b : cta)
	   {
		   if (b.getCtaId() == null || b.getAction() == null) continue;
		   
			    switch (b.getCtaId()) {
			        case "64887c11cce361dafc86c241":  // Phone
			            item2.setPhoneNumber(b.getAction());
			            break;
			        case "64887c11cce361dafc86c242":  // WhatsApp
			            item2.setWhatsappNumber(b.getAction());
			            break;
			        case "64e99c7651a484a077ae2c1f":  // Take me there
			        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
			        	if(b.getLatitude()!=null && b.getLongitude() !=null) {
			        	 item2.getLocation().setLat(Double.toString(b.getLatitude()));
			        	 
			        	 item2.getLocation().setLng(Double.toString(b.getLongitude()));}
			            break;
			        default:
			            break;
			    }
		   }
	   }
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here
	   
	   if(categories!=null) {
		   if(categories.size()>0) {
	   for(ObjectId o:companies.getCompanyCategories() )
	   {
		//   System.out.println("value of o : " +o);
		   for(ObjectId id : categories)
		   {
			//   System.out.println("value of id : " +id);
			  if( o.equals(id)  )
			  {		  
			//	  System.out.println("inside equals : " +o +" value of id : " +id );
				  set.add(item2);
				//  System.out.println("Contents  of list2" +set);										  
			  }
		   }
	   }
	}	
		   }   
	}	
	if(categories!=null) {
		if(categories.size()>0) {
	/*	list.clear();
	    list = new ArrayList<>(set);*/
		ulll.clear();
	    ulll = new ArrayList<>(set);
		}  
	}
//	System.out.println("ull : " +ulll.size())  ;
	for(ad_campaigns item3:ulll)
	   {	
		if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item3.getLocation().lat);
		lng1 = Double.parseDouble(item3.getLocation().lng);
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal< slider) {
			//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
			ul.add(item3);
	//	}
		}		
		if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
		{
		
//Optional<users> u = usersRepo.findById(item3.getCreatedBy());

//Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());

//if(!(userloc.isEmpty())) {

////lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
//item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);

//if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal< slider) {
ul.add(item3);
//}
//}
}	
}
	
	List<ad_campaigns> finallistofadsfromsession = (List)session.getAttribute("FinalListOfAds");
	  Set<String> sessionIds = finallistofadsfromsession.stream()
              .map(ad_campaigns::getId)
              .filter(Objects::nonNull)
              .collect(Collectors.toSet());

      // --- Step 2A: Keep only elements found in both lists (IN-PLACE) ---
      ul.removeIf(ad -> !sessionIds.contains(ad.getId()));
	//System.out.println("ul size: " +ul.size());
	String enabledVertical   =(String) session.getAttribute("verticalenabled");
	//System.out.println("enabled Verticle : " +enabledVertical); 
	if(enabledVertical !=null)
	{
		//System.out.println("enabled Verticle : " +enabledVertical); 
		
		if(enabledVertical.equals("gitagenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getGiTag()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		if(enabledVertical.equals("templeenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getTemple()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		if(enabledVertical.equals("forestenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getForest()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		
		if(enabledVertical.equals("heritageenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getHeritage()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		
		if(enabledVertical.equals("hospitalenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getHospital()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		
		if(enabledVertical.equals("busenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getBus()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		
		if(enabledVertical.equals("carenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getCar()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		if(enabledVertical.equals("rickshawenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getRickshaw()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		if(enabledVertical.equals("goodsenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getGoods()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		
	}
	
	else
	{
		finalul = ul;
	}
	 session.removeAttribute("FinalListOfAds");
		session.setAttribute("FinalListOfAds", finalul);

	System.out.println("Final size of ul: " +finalul.size());
		 // return new Gson().toJson(ul);
	
//to get the reachable ads endtem
		return finalul;
	 
	
}


@PostMapping("/locationkoppa")
public String getHomePagekoppa(@RequestBody location location,HttpSession session, HttpServletRequest request) {
 System.out.println("Location in ajax : " +location);
 System.out.println("latitude in ajx : " +location.getLat());		  
//location.setLat("13.529271965260616");
//location.setLng("75.36285138756304");
 //session.removeAttribute("latitude");
//	session.removeAttribute("longitude");
 String latitudeearlier = (String)session.getAttribute("latitude");//string to double
 String longitudeearlier = (String)session.getAttribute("longitude");
 
 String userAgent = request.getHeader("User-Agent");
//  session.setAttribute("slider", sliderValue);
//  double slider = (Double)session.getAttribute("slider");
  ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
  //System.out.println("+++++++++++++++ " +latitudeearlier +"--------------------" +longitudeearlier +"---------"+categories +"++++++++++" );;

	ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
	ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
	//session.invalidate();
//  if(latitudeearlier == null && latitudeearlier==null)
  {	  

session.setAttribute("latitude", location.getLat());
session.setAttribute("longitude", location.getLng());
session.setAttribute("slider", 2.0);
session.removeAttribute("categories");
session.removeAttribute("mobilenumber");
// first time page is loaded start here
  double lat = Double.parseDouble(location.getLat());
  double lng = Double.parseDouble(location.getLng());
  double lat1 = 0.0;
  double lng1 = 0.0;
//	double dist_range=300.00;
  long startTime = System.currentTimeMillis();
List<ad_campaigns> list = ad_campaignsRepo.findByLat();
System.out.println("list size of active: " +list.size());

System.out.println("------"+list.size());		
int j=0;

hitRecord hit = new hitRecord();
hit.setLatitude(location.getLat());
hit.setLongitude(location.getLng());
hit.setUserAgent(userAgent);
hitRecordRepository.save(hit);

for(ad_campaigns item1:list)
{
j++;
if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
{
lat1 = Double.parseDouble(item1.getLocation().lat);
lng1 = Double.parseDouble(item1.getLocation().lng);
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=2.0) {
ul.add(item1);
}
}

if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
{

Optional<users> u = usersRepo.findById(item1.getCreatedBy());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
if(!(userloc.isEmpty())) {
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=2.0) {
ul.add(item1);
}
}
}
}
System.out.println("size of ul : " + ul.size());
long endTime = System.currentTimeMillis();
long duration = endTime - startTime;
//System.out.println("to find the reachable ads list : " +duration);
long startTime2 = System.currentTimeMillis();
for(ad_campaigns item:ul)//list
{

  Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String			
	
   
  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  

  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
	
	  String s3locationurl = s3Location.getS3Location();

	  companies.setCompanyLogoPath(s3locationurl);
   item.setCompanies(companies);
  
  
  //to get ad path
//  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
  
 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
 //System.out.println("thumbpath : " +thumbpath);
// ad.get().setThumbnail(thumbpath);
 ad.get().setThumbnail(thumbpath.getS3Location());
//to get banners start here
 medias s3url ;
 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
 {
	// System.out.println("in if banners: " +ad.get().getId() );
	 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
	 
	// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
	ad.get().setContent(l.getContent());//set to advertisements first
//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
	ArrayList<String> listofimagepaths = new ArrayList<String>();
	 for(String banner:l.getContent().getBanners())
	 {
		 s3url =  mediarepo.findByUid(banner);
		
		
		listofimagepaths.add(s3url.getS3Location());
	
		ad.get().getContent().setBanners(listofimagepaths);
	 }
	
 }
 
//to get banners end here
 //to get video start here
 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
	
   advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
	
	 ad.get().setContent(l.getContent());
	
	 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
	
	 if(s3url!=null) {
	 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 
	 
	 // to start here
	 else
	 {
		 if(ad.get().getContent().getVideoLink().contains("youtube"))
		 {
		//	 System.out.println("inside youtube : ");
			String videoid=  ad.get().getContent().getVideoLink().substring(ad.get().getContent().getVideoLink().indexOf("=") + 1);
			//https://www.youtube.com/embed/
				ad.get().getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
		 }
	 }
	 //till here
 }
 
 //to get video end here
 //to get simple text start here
 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
 {
	  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
	  ad.get().setContent(l.getContent());
	
 }
 
 //to get simple text end here
 	 
 //to get custom text start here
 
 // to get custom text end here
   item.setA(ad.get());
//System.out.println("final ad : " +ad);
   
   //to get name and ph nomner
   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item.getCreatedBy());

item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item.setEmailAddress(user.get().getEmailAddress());item.setFullName(user.get().getFullName());
item.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here

	//i++;
	//if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
	//{
	//lat1 = Double.parseDouble(item.getLocation().lat);
	//lng1 = Double.parseDouble(item.getLocation().lng);
	//double distanceVal=distance(lat1,lat,lng1,lng);
	//item.setDistance(distanceVal);
	//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
	//	ul.add(item);
	//}
	//}
	
	//if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
	//{
	
//Optional<users> u = usersRepo.findById(item.getCreatedBy());
//Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//if(!(userloc.isEmpty())) {
//lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
//item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);
//item.setDistance(distanceVal);
//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
//ul.add(item);
//}
//}
//}	
   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item.getAdvertisementId());
   
   if (cta != null && !cta.isEmpty()) {
   for(buttonActionDTO b : cta)
   {
	   if (b.getCtaId() == null || b.getAction() == null) continue;
	
		    switch (b.getCtaId()) {
		        case "64887c11cce361dafc86c241":  // Phone
		            item.setPhoneNumber(b.getAction());
		            break;
		        case "64887c11cce361dafc86c242":  // WhatsApp
		            item.setWhatsappNumber(b.getAction());
		            break;
		        case "64e99c7651a484a077ae2c1f":  // Take me there
		        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
		        	if(b.getLatitude()!=null && b.getLongitude() !=null) {
		        	 item.getLocation().setLat(Double.toString(b.getLatitude()));
		        	 
		        	 item.getLocation().setLng(Double.toString(b.getLongitude()));}
		            break;
		        default:
		            break;
		    }
	   }
   }
} 
long endTime2 = System.currentTimeMillis();
long duration2 = endTime2 - startTime2;
//System.out.println("to set the images path : " + duration2);
}
  
 
 // else
 /* {
	  double slider=0.0;
	  System.out.println("in not  null" +categories);
	  double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	  if(session.getAttribute("slider") !=null)
		{
			slider =(Double)session.getAttribute("slider");
		}
		else 
		{
			slider =1.3;
		}	 
	  System.out.println("slider in else : " +slider);
	  double lat1 = 0.0;
	  double lng1 = 0.0;
	//	double dist_range=300.00;
      System.out.println("in else : " + lat +"and "+lng);
		List<ad_campaigns> list = new ArrayList<ad_campaigns>();

		 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
		 
		 long startTime3 = System.currentTimeMillis();
			 list = ad_campaignsRepo.findByLat();

			 for(ad_campaigns item:list)
			   {	
				if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item.getLocation().lat);
				lng1 = Double.parseDouble(item.getLocation().lng);
				double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
				if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
					//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
					ull.add(item);
				}
				}		
				if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
		double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);

		if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
		ull.add(item);
		}
		}
		}	
		} 	  //for
			 long endTime3 = System.currentTimeMillis(); 
			 System.out.println("ull : " +ull.size() +"and duration to get reachable ads : " +  (endTime3 - startTime3));
			  long startTime4 = System.currentTimeMillis(); 
	for(ad_campaigns item2:ull)
	{
	
		Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
		
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
//	  System.out.println("companies: " +companies); 
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
		
		  String s3locationurl = s3Location.getS3Location();
	
		  companies.setCompanyLogoPath(s3locationurl);
		  
	  item2.setCompanies(companies);

	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first

		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			
			listofimagepaths.add(s3url.getS3Location());
		
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 else
		 {
			 if(ad.get().getContent().getVideoLink().contains("youtube"))
			 {
			//	 System.out.println("inside youtube : ");
				String videoid=  ad.get().getContent().getVideoLink().substring(ad.get().getContent().getVideoLink().indexOf("=") + 1);
				//https://www.youtube.com/embed/
					ad.get().getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
			 }
		 }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	   item2.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item2.setEmailAddress(user.get().getEmailAddress());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here
	   
	   if(categories!=null) {
		   if(categories.size()>0) {
	   for(ObjectId o:companies.getCompanyCategories() )
	   {
		//   System.out.println("value of o : " +o);
		   for(ObjectId id : categories)
		   {
			//   System.out.println("value of id : " +id);
			  if( o.equals(id)  )
			  {		  
			//	  System.out.println("inside equals : " +o +" value of id : " +id );
				  set.add(item2);
				//  System.out.println("Contents  of list2" +set);										  
			  }
		   }
	   }
	   }
	}	   
	}	
	System.out.println("size of set : " +set.size());
	if(categories!=null) {
		 if(categories.size()>0) {
		ull.clear();
	    ull = new ArrayList<>(set);}
	}
	
	
	 long endTime4 = System.currentTimeMillis(); // End time
	 System.out.println("ull 2nd  : " +ull.size() +"and duration to set the images : " +(endTime4-startTime4) );
	for(ad_campaigns item3:ull)
	   {	
		if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
		{
		
			ul.add(item3);
		
		}		
		if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
		{
		
	ul.add(item3);
}	
} 	
  }//else*/

  		
  System.out.println("Final size of ul: " +ul.size());
  
  session.removeAttribute("FinalListOfAds");
	session.setAttribute("FinalListOfAds", ul);
  return new Gson().toJson(ul);	   
		// first time page is loaded end here
   
//	return "index";
	
}

@PostMapping("/currentLocationSpotlight")
public spotlighttwolists currentLocationSpotlight (@RequestBody location location,HttpSession session) {
	   // System.out.println("in responsive spotlight: " +location);
	 
	
			 double spotlightlat = Double.parseDouble(location.getLat());
			 double spotlightlng = Double.parseDouble(location.getLng());
			 
		  double latspotlyt = 0.0;
		  double lngspotlyt = 0.0;
	//	  Point location = new Point(lng, lat);
		/*  double[] location = {lng, lat};
		  double maxdistanceinmeters=5000;
		  System.out.println("Location : " +location[0] +"and : " +location[1]);
	List<users> usersList=	  txnuserrepo.findNearbySpotlights(location, maxdistanceinmeters);
	System.out.println("usersList: " +usersList.size() );
	System.out.println("usersList: " +usersList );*/
		ModelAndView mv = new ModelAndView("responsivespotlight");
		List<users> users = usersRepo.findAll();
		session.setAttribute("activeLink", "spotlight");
		List<users> spotlightList = new ArrayList<users>();
		for(users u1 : users)
		{
			//Optional<users> u = usersRepo.findById(u1.getLastKnownLocation());
			Optional<txn_user_locations> userlocspotlyt =txnuserrepo.findById(u1.getLastKnownLocation());
			
			if(!(userlocspotlyt.isEmpty())) {
				lngspotlyt=userlocspotlyt.get().getLocation().getX();
				latspotlyt=userlocspotlyt.get().getLocation().getY();
		//		System.out.println("txn_user_locations : " +latspotlyt +"lat2 : " +spotlightlat +"lng : " +lngspotlyt +"lng2: " +spotlightlng);
			double distanceVal=distance(latspotlyt,spotlightlat,lngspotlyt,spotlightlng);
			
			//System.out.println("txn_user_locations : " +distanceVal);
			if(distanceVal<=5.3) {
				spotlightList.add(u1);
			} 
			}
		}
		
		//System.out.println("spotlight List : " +spotlightList.size());
		for(users u : spotlightList)
		{
			//System.out.println("user id : " + u.getId());
			 ObjectId objectId = new ObjectId(u.getId());
			// System.out.println("ObjectId : " +objectId);
			user_profiles profilepicId = user_profilesrepo.findByuserId(objectId);//get profilePicturre id
			// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
			//System.out.println("Profile pic Id : " +profilepicId);
			if(profilepicId != null) {
	 if(profilepicId.getProfilePicture()!=null) 
	{	
		medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
		if(profiles3location !=null ) 
		{
			//System.out.print		ln("profiles3location : "+profiles3location.getS3Location());
			u.setProfilePicPath(profiles3location.getS3Location());
			}
		}
		}
		}
//		System.out.println("Users: " +users.size());
		//mv.addObject("users",new Gson().toJson(users));
//		mv.addObject("users",new Gson().toJson(spotlightList));
		//String spotlightid = users.get(1).getId();
	//	String spotlightid = spotlightList.get(0).getId();
		//to get 1st spotlight details start here
		 double lat1 = 0.0;
		  double lng1 = 0.0;
		//System.out.println("y in pathvariab : " +y);
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
		ArrayList<ad_campaigns> ulspotlightList=new ArrayList<ad_campaigns>();String spotlightid="";
		/*System.out.println(user.getId());
		var objectId = new ObjectId(user.getId());*/
		for(users s1 :spotlightList) {
			 spotlightid = s1.getId();
		//	 System.out.println("Spotlight id : " +s1.getId());
			ul=	ad_campaignsRepo.findbycreatedBy(new ObjectId(spotlightid));
		if(!(ul.isEmpty()) && (ul.size()>=1)) {
			break;
		}
		
		}
//		System.out.println("contents of ul : " +ul);
		//to find followers
	ArrayList<mapping_user_folowings> followings = 	mapping_user_folowingsrepo.findbyentityId(new ObjectId(spotlightid));
	//System.out.println("followings: " +followings.size());
	ArrayList<ad_campaigns> noofCampaigns = ad_campaignsRepo.findbycreatedBy(new ObjectId(spotlightid));
	//System.out.println("no of camp: " +noofCampaigns.size());
		for(ad_campaigns item:ul)
		{		
			Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String			
			//System.out.println("advertisements : " +ad.get().getCompany());
			//item.getA().setTitle(a.get().getTitle());
			//item.getA().setDescription(a.get().getDescription());
		   
		  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  

		  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
			 // System.out.println("s3 loctio : " +s3Location);
				//  item.getCompanies().setCompanyLogo(s3Location);
			 // companies.setCompanyLogoPath(s3Location);
			  String s3locationurl = s3Location.getS3Location();
			 // System.out.println("s3locationurl : " +s3locationurl);
			  companies.setCompanyLogoPath(s3locationurl);
		      item.setCompanies(companies);
		  
		  
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	       advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
			 else
			 {
				 if(ad.get().getContent().getVideoLink().contains("youtube"))
				 {
				//	 System.out.println("inside youtube : ");
					String videoid=  ad.get().getContent().getVideoLink().substring(ad.get().getContent().getVideoLink().indexOf("=") + 1);
					//https://www.youtube.com/embed/
						ad.get().getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
				 }
			 }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item.setA(ad.get());
	//System.out.println("final ad : " +ad);
		   
		   //to get name and ph nomner
		   
	Optional<users> user  = 		   usersRepo.findByIdphandemail(item.getCreatedBy());
	//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
	item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
	item.setEmailAddress(user.get().getEmailAddress());
	item.setFullName(user.get().getFullName());
	//item.setCreatedBy(user.get().getFullName());
	//System.out.println("item ph : " +item.getPhoneNumber());
	//to get name and ph nomner till here

		
			if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
			{
			//	System.out.println("in if 1 ");
			lat1 = Double.parseDouble(item.getLocation().lat);
			lng1 = Double.parseDouble(item.getLocation().lng);
		//	double distanceVal=distance(lat1,lat,lng1,lng);
		//	if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
				//ul.add(item);
//			}
			}
			
			if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
			{
			//	System.out.println("in if 2 ");
				//System.out.println("Created By : " +item.getCreatedBy());
	//ObjectId id = new ObjectId(item.getCreatedBy());
	//System.out.println("ObjectId : " +id);
	Optional<users> u = usersRepo.findById(item.getCreatedBy());
	//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
	Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
	//System.out.println("user locations : " +userloc);
	if(!(userloc.isEmpty())) {	//System.out.println(userloc.get().getLocation().getX());	//System.out.println(userloc.get().getLocation().getY());
	lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
	item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
	//double distanceVal=distance(lat1,lat,lng1,lng);
	//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

	//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=1.3) {
	//ul.add(item);
	//}
	}
	}	
			item.setNoOfCampaigns(noofCampaigns.size());
			item.setNoOfFollow(followings.size());
			//to get profile pic start here
			user_profiles profilepicId = user_profilesrepo.findByuserId(new ObjectId(spotlightid));//get profilePicturre id
			// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
		//	System.out.println("Profile pic Id : " +profilepicId);
			if(profilepicId != null) {
	if(profilepicId.getProfilePicture()!=null) 
	{	
		medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
		if(profiles3location !=null ) 
		{
		//	System.out.println("profiles3location : "+profiles3location.getS3Location());
			
			item.setProfilePicturePath(profiles3location.getS3Location());
			}
		}
		}
			// to get profile pic end here
	} 
	  //System.out.println("ul:" +ul);
	 // ModelAndView mv = new ModelAndView("spotlight");
	
	 
		//to get 1st spotlight details end here
		//mv.addObject("spotlightDetails");
		//return mv;
	  
	  return new spotlighttwolists(spotlightList,ul);
}


@GetMapping("/responsiveprofile")
public ModelAndView responsiveprofile(HttpSession session,Model model)
{
	session.setAttribute("activeLink", "profile");
	ModelAndView mv = new ModelAndView("responsiveprofile");
//	model.addAttribute("users_keliri");
	
	String phno = (String)session.getAttribute("mobilenumber");
	users_keliri u1 = new users_keliri();
	
	//boolean b = users_keliri_repo.existsByPhoneNumber(phno);
	if(phno!=null) {
	u1 = users_keliri_repo.findByPhoneNumber(phno);
	
	}  //means logged in
	
	/*if(u1==null) {	
	//u2.setProfileImagePath("Default_pfp.jpg");}*/
	//if already exists
	else
	{
		u1.setProfileImagePath("/Default_pfp.jpg");
		
	}
	//System.out.println("user details : " +u1);
	mv.addObject("users_keliri",u1);
	return mv;
	
}


@Value("${aws.s3.endpointUrl:}")
private String endpointUrl;

@Value("${aws.s3.folder:uploads}")
private String uploadFolder;
@PostMapping("/upload")
public Map<String, String> uploadFile(@RequestParam("file") MultipartFile file) {
    Map<String, String> response = new HashMap<>();
    try {
      //  String imageUrl = s3Service.uploadFile(file);
    	String imageUrl = "http://omhbdbsdhbh/media/udhhuhduh.png";
        System.out.println("imageUrl : " +imageUrl);
        String[] ImageURL = imageUrl.split("/");
        String mediaKey="",mediaId="",createdByLoggedInUser ="",profilePic="";
        for(int i=0;i<ImageURL.length;i++)
        {
        	mediaKey=ImageURL[4];
        	mediaId = ImageURL[4];		
        	
        }
     // Define the desired date format
        Date now = new Date();
        
        // Format to include date and timestamp (e.g., "2025-02-28 17:30:00")
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        //to store the url in user_profiles and media
        //String s3Location = s3Service. 
        
      medias_keliri mediasID =  mediakeliriService.createMedia(imageUrl,"",uploadFolder+"/"+mediaKey,uploadFolder+"/"+mediaKey,imageUrl,"MEDIA",new ObjectId("64ed86323200e1d6c520605d"),new Date(),new Date());
     // System.out.println("mediasID : " +mediasID);
      user_profiles_keliri u =  user_profiles_keliriServ.create_user_profiles(new ObjectId("64ed86323200e1d6c520605d"), new ObjectId("64ed86323200e1d6c520605d"), new ObjectId("64ed86323200e1d6c520605d"), new ObjectId("64ed86323200e1d6c520605d"), new Date());
    //  System.out.println("User Profiles ID : " +u) ;
        response.put("imageUrl", imageUrl);
    } 
    catch (Exception e) {
        e.printStackTrace();
        response.put("error", "Upload failed");
    }
    return response;
}


@PostMapping("/profileForm")
public ModelAndView profileformupdate(@ModelAttribute users_keliri uk,@RequestParam("profileImageFile") MultipartFile image,HttpSession session)
{
	//System.out.println("uk : " +uk);
	ModelAndView mv = new ModelAndView("responsiveprofile");
	session.setAttribute("mobilenumber", uk.getPhoneNumber());
	 Map<String, String> response = new HashMap<>();String imageUrl="/Default_pfp.jpg";   String mediaKey="",mediaId="",createdByLoggedInUser ="",profilePic="";
	 try {
		 //if ( image.isEmpty()) {
		 
	//	 System.out.println("Image is not null" +image.getOriginalFilename() +","+image.getSize());
		 users_keliri u1 = new users_keliri();
		 u1 = users_keliri_repo.findByPhoneNumber(uk.getPhoneNumber());//check if user already exists
		 if (  image.getSize()>0 ) {
			 System.out.println("Image is not null" +image.getOriginalFilename() +","+image.getSize());
			  imageUrl = s3Service.uploadFile(image);
			   // 	String imageUrl = "http://omhbdbsdhbh/media/udhhuhduh.png";
			        System.out.println("imageUrl : " +imageUrl);
			        String[] ImageURL = imageUrl.split("/");
			     
			        for(int i=0;i<ImageURL.length;i++)
			        {
			        	mediaKey=ImageURL[4];
			        	mediaId = ImageURL[4];		
			        	
			        }
			        
			        uk.setProfileImagePath(imageUrl);  //for new user
			        u1.setProfileImagePath(imageUrl);  // for existing user
		 }
		
			
			
			if(u1==null)   //for creating a new user
{
	     
	     // Define the desired date format
	        Date now = new Date();
	        
	        // Format to include date and timestamp (e.g., "2025-02-28 17:30:00")
	        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	        //to store the url in user_profiles_keliri, users_keliri and media
	        
	        uk.setProfileImagePath(imageUrl);//if no profile pic is uploaded
	   users_keliri ukk =      users_keliri_repo.save(uk);
	 //  System.out.println("users_kelriri after saaved : " +ukk);
	     medias_keliri mediasID =  mediakeliriService.createMedia(imageUrl,"",uploadFolder+"/"+mediaKey,uploadFolder+"/"+mediaKey,imageUrl,"MEDIA",new ObjectId(ukk.getId()),new Date(),new Date());
	      //System.out.println("mediasID : " +mediasID);
	      user_profiles_keliri u =  user_profiles_keliriServ.create_user_profiles(new ObjectId(ukk.getId()), new ObjectId(mediasID.getId()), new ObjectId(ukk.getId()), new ObjectId(ukk.getId()), new Date());
	      System.out.println("User Profiles ID : " +u) ;
	      
	      //  response.put("imageUrl", imageUrl);
	      ukk.setProfileImagePath(imageUrl);  //may not be necessary
	  	session.setAttribute("profilePicPath", ukk.getProfileImagePath());
	      
	      mv.addObject("users_keliri",ukk);
			}
						
			
			//for an existing user
			else
			{
				
				     // Define the desired date format
				        Date now = new Date();
				        
				        // Format to include date and timestamp (e.g., "2025-02-28 17:30:00")
				        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				        //to store the url in user_profiles_keliri, users_keliri and media
				        
				     //   uk.setProfileImagePath(imageUrl);
				   //     System.out.println("ALREADY EXISTING USER : " +uk);
				        
				        u1.setName(uk.getName());
						u1.setAge(uk.getAge());
						u1.setEmailId(uk.getEmailId());
						u1.setGender(uk.getGender());
						u1.setInterest(uk.getInterest());
						u1.setNickName(uk.getNickName());
						u1.setPhoneNumber(uk.getPhoneNumber());
						//u1.setProfileImagePath(u1.getProfileImagePath());
				 users_keliri ukk =      users_keliri_repo.save(u1);
				 //ukk.setProfileImagePath(imageUrl);
					session.setAttribute("profilePicPath", ukk.getProfileImagePath());
			      mv.addObject("users_keliri",ukk);
				
			}
	    } 
	    catch (Exception e) {
	        e.printStackTrace();
	        response.put("error", "Upload failed");
	    }
	return mv;
}

@GetMapping("/giads")
public String getGiAds(HttpSession session,HttpServletRequest request) {
	String requestId = request.getParameter("requestId");
	// System.out.println("request id in rickshaw : " + requestId);
	session.setAttribute("latestRequestId", requestId);
	session.setAttribute("verticalenabled", "gitagenabled");
	double lat=  Double.parseDouble((String)session.getAttribute("latitude"));	
	double lng = Double.parseDouble((String) session.getAttribute("longitude"));	
    ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
    session.removeAttribute("vlogsenabled");
  //  session.setAttribute("currentLocationset", true);

	double slider =0.0; 
//	System.out.println("slider : " +slider );
	if(session.getAttribute("slider") !=null)
	{
		slider =(Double)session.getAttribute("slider");
	}
	else 
	{
		slider =2.0;
	}
	//System.out.println("categories : " +categories);
	
		 /* double lat = Double.parseDouble(location.getLat());
		  double lng = Double.parseDouble(location.getLng());*/
		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
			ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
			List<ad_campaigns> listOfGiTagAds = new ArrayList<ad_campaigns>();
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
		     listOfGiTagAds = ad_campaignsRepo.findByGiTags();
		    // System.out.println("listOfGiTagAds: " +listOfGiTagAds);
		     
	for (ad_campaigns item1:listOfGiTagAds)
	{
		if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item1.getLocation().lat);
		lng1 = Double.parseDouble(item1.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
		//	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
			ull.add(item1);
	//	}
		}
		
		if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item1.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);
//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
ull.add(item1);
//}
}
}	
	}
	//System.out.println("size of Ull : " +ull.size());
		for(ad_campaigns item2:ull)
		{
			
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
		//  System.out.println("companies: " +companies.getCompanyCategories());
            
            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
       	 // System.out.println("s3 loctio : " +s3Location);
       		//  item.getCompanies().setCompanyLogo(s3Location);
       	 // companies.setCompanyLogoPath(s3Location);
       	  String s3locationurl = s3Location.getS3Location();
       	 // System.out.println("s3locationurl : " +s3locationurl);
       	  companies.setCompanyLogoPath(s3locationurl);
       	  
       	  
		  item2.setCompanies(companies);
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
		 //to get name and ph nomner
		   
		   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
		   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
		   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
		   item2.setEmailAddress(user.get().getEmailAddress()); item2.setFullName(user.get().getFullName());
		   
		//   item2.setWhats(user.get().getPhoneNumber().getDialNumber());
		   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
		   //System.out.println("item ph : " +item.getPhoneNumber());
		   //to get name and ph nomner till here
		   //if(categories!=null) 
		   {
			//   if(categories.size()>0)
			   { 
		
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			   //for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
				  //if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
	//	   System.out.println("Contents  of list2" +set);		
		   }//if >0
		}//if
		   
		}//for
		//if(categories!=null)
		{
			
			//if(categories.size()>0) 
			{
		/*list.clear();
	    list = new ArrayList<>(set);*/
	    ull.clear();
	    ull = new ArrayList<>(set);
			}
		}
		//System.out.println("Size of list : " +ull.size());
		   for(ad_campaigns item3:ull)
		   {
			   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item3.getLocation().lat);
				lng1 = Double.parseDouble(item3.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
					//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
					ul.add(item3);
				//}
				}
				
				if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item3.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
		
	//	}
		ul.add(item3);
		}
		
		
		}				
} 
		//System.out.println("Final size of ul: " +ul.size());
		
		 String latest = (String) session.getAttribute("latestRequestId");
		    if (!requestId.equals(latest)) {
		       // System.out.println("Ignoring outdated REMOVE response: " + requestId);
		        return "[]";
		    }
		    
		 session.removeAttribute("FinalListOfAds");
			session.setAttribute("FinalListOfAds", ul);
			   return new Gson().toJson(ul);
	
}


@PutMapping("/showvendors")
public String showvendors(HttpSession session,@RequestBody int gitagnumber)
{
	//System.out.println("gitag number: " +gitagnumber);
	 double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	//List<users> givendors = usersRepo.findbygivendor();
List<adCampaigns_advertisementsDTO> list1 = ad_campaignsRepo.findbygitagnumber(gitagnumber);
ArrayList<adCampaigns_advertisementsDTO> ull = new ArrayList<adCampaigns_advertisementsDTO>();List<users> usersList = new ArrayList<users>();
List<ad_campaigns> ul = new ArrayList<ad_campaigns>();
companies companies = new companies();
	double lat1=0.0,lng1=0.0;
//System.out.println("LIST 1 : " +list1.size());
for(adCampaigns_advertisementsDTO a : list1)
{	
	//to set the location, comapny, image path
	if((a.getLatitude()!=null) && (a.getLongitude()!=null))
	{
	lat1 = Double.parseDouble(a.getLatitude());
	lng1 = Double.parseDouble(a.getLatitude());
	double distanceVal=distance(lat1,lat,lng1,lng);a.setDistance(distanceVal);
	//if(distanceVal<=a.getRange()/1000 && distanceVal <=1.3) {
		ull.add(a);
	//}
	}
	if((a.getLatitude()==null) && (a.getLongitude()==null))
	{
	Optional<users> u = usersRepo.findById(a.getCreatedBy());
	Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
	System.out.println("u & userloc : " + u +"and : " +userloc);
	if(!(userloc.isEmpty())) {
	lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
	a.setLatitude(String.valueOf(lat1));a.setLongitude(String.valueOf(lng1));//null pointer
	double distanceVal=distance(lat1,lat,lng1,lng);a.setDistance(distanceVal);
	//if(distanceVal<=a.getRange()/1000 && distanceVal <=1.3) {
	
	//}
	
	
	}
	ull.add(a);
	}	
}


//System.out.println("Sub Sub  list : " +ull.size());
for(adCampaigns_advertisementsDTO item2:ull)
{

	//Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//
	
   companies =  companyrepo.findBycustomId(item2.getCompany());  
 
  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
	
	  String s3locationurl = s3Location.getS3Location();

	  companies.setCompanyLogoPath(s3locationurl);   //set this obj to ad_campaigns
	  
     // item2.setCompanies(companies);//

  
 medias thumbpath =  mediarepo.findById(new ObjectId(item2.getThumbnail()));

 item2.setThumbnail(thumbpath.getS3Location()); //set this to advertisement obj in ad_campaigns
//to get banners start here
 medias s3url ;
 if(item2.getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
 {
	
	// advertisements l = adrepo.findbyContent(new ObjectId(item2.getId()));//
	 
	
	//ad.get().setContent(l.getContent());//

	ArrayList<String> listofimagepaths = new ArrayList<String>();
	 for(String banner:item2.getContent().getBanners())
	 {
		 s3url =  mediarepo.findByUid(banner);
		
		listofimagepaths.add(s3url.getS3Location());
	
		item2.getContent().setBanners(listofimagepaths);
	 }
	
 }
 
//to get banners end here
 //to get video start here
 if(item2.getAdType().equals("64887c11cce361dafc86c23c")) {
	
     //advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));//		 
	
	// ad.get().setContent(l.getContent());//
	 
	 s3url =  mediarepo.findByUid(item2.getContent().getVideoLink());
	// System.out.println("s3url in video : " +s3url);
	 if(s3url!=null) {
	 item2.getContent().setVideoLink(s3url.getS3Location()); }
	 else
	 {
		 if(item2.getContent().getVideoLink().contains("youtube"))
		 {
		//	 System.out.println("inside youtube : ");
			String videoid=  item2.getContent().getVideoLink().substring(item2.getContent().getVideoLink().indexOf("=") + 1);
			//https://www.youtube.com/embed/
				item2.getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
		 }
	 }
 }
 
 //to get video end here
 //to get simple text start here
 if(item2.getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
 {
	//  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));//
	//  ad.get().setContent(l.getContent());//
 }
 

  // item2.setA(ad.get());//                                      //set all the attributes of advertisements to advertisemnets DTO
/*   if(categories!=null) {
	   if(categories.size()>0) {
   for(ObjectId o:companies.getCompanyCategories() )
   {
	//   System.out.println("value of o : " +o);
	   for(ObjectId id : categories)
	   {
		//   System.out.println("value of id : " +id);
		  if( o.equals(id)  )
		  {		  
		//	  System.out.println("inside equals : " +o +" value of id : " +id );
			  set.add(item2);
			//  System.out.println("Contents  of list2" +set);										  
		  }
	   }
   }
   }
}	*/   
}	
//System.out.println("Sub Final list : " +ull.size());
//to get name and ph nomner
for(adCampaigns_advertisementsDTO item3:ull) {
Optional<users> user  = 		   usersRepo.findByIdphandemail(item3.getCreatedBy());

//item3.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());//
//item3.setEmailAddress(user.get().getEmailAddress());//

//System.out.println("item3: " +item3.getFromDate() +item3.getDescription());
ad_campaigns a = new ad_campaigns();
location l = new location();
a.setId(item3.get_id());
l.setLat(item3.getLatitude());l.setLng(item3.getLongitude());l.setRange(item3.getRange());l.setLocationName(item3.getLocationName());
a.setLocation(l);
a.setCompaignsStatus(item3.getCompaignsStatus());
a.setCompanies(companies);
advertisements ad = new advertisements();
ad.setId(item3.getAdvertisementId());
ad.setAdType(item3.getAdType());
ad.setContent(item3.getContent());
ad.setCompany(item3.getCompany());
ad.setCustomTextSection(item3.getCustomTextSection());
ad.setDescription(item3.getDescription());
ad.setGitagnumber(item3.getGitagnumber());
ad.setTitle(item3.getTitle());
ad.setThumbnail(item3.getThumbnail());
a.setA(ad);
a.setDistance(item3.getDistance());
a.setGiTag(1);
a.setAdvertisementId(item3.getAdvertisementId());
dateRange dr = new dateRange();
//OffsetDateTime odt1 = OffsetDateTime.parse(item3.getFromDate());
//return Date.from(odt.toInstant());
//dr.setFromDate(Date.from(odt1.toInstant()));  dr.//setToDate(item3.getToDate());

/*Instant instant = Instant.parse(item3.getFromDate());
Date fromDate = Date.from(instant);
Instant instant2 = Instant.parse(item3.getToDate());
Date toDate = Date.from(instant2);*/

try {
SimpleDateFormat formatter = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy", Locale.ENGLISH);
formatter.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata"));

//System.out.println("item3.getFromDate: " +item3.getFromDate());
	Date fromDate = formatter.parse(item3.getFromDate());
	Date toDate = formatter.parse(item3.getToDate());;
	dr.setFromDate(fromDate);dr.setToDate(toDate);
} catch (ParseException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
if(gitagnumber!=0)
{
	a.setGiTag(1);
}

a.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
a.setEmailAddress(user.get().getEmailAddress());a.setFullName(user.get().getFullName());
a.setCreatedBy(item3.getCreatedBy());
a.setDateRange(dr);
a.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
ul.add(a);


users u = new users();
u.setId(item3.getCreatedBy());
phoneNumber ph = new phoneNumber();
ph.setCountryCode("+91");
ph.setDialNumber(user.get().getPhoneNumber().getDialNumber());
u.setPhoneNumber(ph);
u.setEmailAddress(user.get().getEmailAddress());
u.setFullName(user.get().getFullName());

u.setGivendor(1);
ObjectId objectId = new ObjectId(item3.getCreatedBy());

user_profiles profilepicId = user_profilesrepo.findByuserId(objectId);//get profilePicturre id

if(profilepicId != null) {
if(profilepicId.getProfilePicture()!=null) 
{	
medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
if(profiles3location !=null ) 
{
//System.out.println("profiles3location : "+profiles3location.getS3Location());
u.setProfilePicPath(profiles3location.getS3Location());


}
}
}
usersList.add(u);
}	
//System.out.println("Final list : " +ul);
//System.out.println("usersList : " +usersList);
	Map<String,List> map = new HashMap<String,List>();
	//System.out.println("GI Tagged Vendors : " +givendors);	
	map.put("advertisementlist", ul);
	map.put("GISpotlights", usersList);
	return new Gson().toJson(map);
	
}


@PostMapping("/showvendorsspotlight")//from ajax spotlight  may be ui 3, aspotlight and aspotlightdetail from ui1 
public ArrayList<ad_campaigns> showvendorsspotlight(@RequestParam("spotlightId") String spotlightId,@RequestParam("gitagnumber") int gitagnumber,HttpSession session)
{
	//System.out.println("y : " +spotlightId +"gitagnumber: " +gitagnumber);
	  double lat1 = 0.0;  double lng1 = 0.0;		  
	  double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));

	ArrayList<ad_campaigns> ulspotlyt=new ArrayList<ad_campaigns>();
	ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();		
	
	ArrayList<advertisements> adList = new ArrayList<advertisements>();
	adList = adrepo.showvendorsfindByCreatedBy(new ObjectId(spotlightId), gitagnumber);
	ulspotlyt=ad_campaignsRepo.findByAdId(new ObjectId(adList.get(0).getId()));
	//System.out.println("adList: " +adList.size());
	//System.out.println("ulspotlyt: " +ulspotlyt.size());
	
	for(ad_campaigns item:ulspotlyt)
	{
	
		Optional<advertisements> ad = adrepo.findById(item.getAdvertisementId());//String			
		//System.out.println("advertisements : " +ad.get().getCompany());
		//item.getA().setTitle(a.get().getTitle());
		//item.getA().setDescription(a.get().getDescription());
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  

	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
		 // System.out.println("s3 loctio : " +s3Location);
			//  item.getCompanies().setCompanyLogo(s3Location);
		 // companies.setCompanyLogoPath(s3Location);
		  String s3locationurl = s3Location.getS3Location();
		 // System.out.println("s3locationurl : " +s3locationurl);
		  companies.setCompanyLogoPath(s3locationurl);
	  item.setCompanies(companies);
	  
	  
	  //to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			//System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 
		 else
		 {
			 if(ad.get().getContent().getVideoLink().contains("youtube"))
			 {
			//	 System.out.println("inside youtube : ");
				String videoid=  ad.get().getContent().getVideoLink().substring(ad.get().getContent().getVideoLink().indexOf("=") + 1);
				//https://www.youtube.com/embed/
					ad.get().getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
			 }
		 }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	   item.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = usersRepo.findByIdphandemail(item.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
item.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item.setEmailAddress(user.get().getEmailAddress());
item.setFullName(user.get().getFullName());
item.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here

	
		if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item.getLocation().lat);
		lng1 = Double.parseDouble(item.getLocation().lng);
		//double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 ) {
			ul.add(item);
		//}
		}
		
		if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);
//if(distanceVal<=item.getLocation().getRange()/1000 ) {

//}
}
ul.add(item);
}	
					
		//to get profile pic start here
	/*	user_profiles profilepicId = user_profilesrepo.findByuserId(new ObjectId(y));//get profilePicturre id
		// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
	//	System.out.println("Profile pic Id : " +profilepicId);
		if(profilepicId != null) {
if(profilepicId.getProfilePicture()!=null) 
{	
	medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
	if(profiles3location !=null ) 
	{
		//System.out.println("profiles3location : "+profiles3location.getS3Location());
		
		item.setProfilePicturePath(profiles3location.getS3Location());
		}
	}
	}*/
		// to get profile pic end here
} 		
    System.out.println(ul.size());
    return ul;
}


@PostMapping("/removegiads")
public String removegiadsfromsession(HttpSession session, HttpServletRequest request)
{
	// If this request is outdated (user selected another vertical already), ignore it
	String requestId = request.getParameter("requestId");
    session.setAttribute("latestRequestId", requestId);
    System.out.println("request Id in Remove : " + requestId);
	session.removeAttribute("vlogsenabled");session.removeAttribute("verticalenabled");session.removeAttribute("searchKeyword");
	/*String vertical = (String) session.getAttribute("verticalenabled");
	
	if (vertical != null) {
		System.out.println("vertical REMOVE : " + vertical);
	    return "[]";
	}*/
	  	  
	  String latitude  = (String)session.getAttribute("latitude");
	  String longitude =(String)session.getAttribute("longitude");
	  ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
	  
	//     session.setAttribute("currentLocationset", true);
//System.out.println("in remove");
		double slider =0.0; 

		if(session.getAttribute("slider") !=null)
		{
			slider =(Double)session.getAttribute("slider");
		}
		else 
		{
			slider =2.0;
		}
	
		
			  double lat = Double.parseDouble(latitude);
			  double lng = Double.parseDouble(longitude);
			  double lat1 = 0.0;  double lng1 = 0.0;
			//	double dist_range=300.00;
				ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
				ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
				List<ad_campaigns> list = new ArrayList<ad_campaigns>();
				Set<ad_campaigns> set = new HashSet<ad_campaigns>();
				 
			/*	 if (Boolean.TRUE.equals(session.getAttribute("gi")))
				 {
					 list = ad_campaignsRepo.findByGiTags(); 
				 }
				 
				 else
				 {*/
					 list = ad_campaignsRepo.findByLat();
			 
			//	 }
		for (ad_campaigns item1:list)
		{
			if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
			{
			//	System.out.println("in if 1 ");
			lat1 = Double.parseDouble(item1.getLocation().lat);
			lng1 = Double.parseDouble(item1.getLocation().lng);
			double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
			//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
				if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
				ull.add(item1);
			}
			}
			
			if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
			{
			
	Optional<users> u = usersRepo.findById(item1.getCreatedBy());
	//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
	Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
	//System.out.println("user locations : " +userloc);
	if(!(userloc.isEmpty())) {
	lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
	item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
	double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
	ull.add(item1);
	}
	}
	}	
		}
		
			for(ad_campaigns item2:ull)
			{
				
				Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
	            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
			//  System.out.println("companies: " +companies.getCompanyCategories());
	            
	            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
	       	 // System.out.println("s3 loctio : " +s3Location);
	       		//  item.getCompanies().setCompanyLogo(s3Location);
	       	 // companies.setCompanyLogoPath(s3Location);
	       	  String s3locationurl = s3Location.getS3Location();
	       	 // System.out.println("s3locationurl : " +s3locationurl);
	       	  companies.setCompanyLogoPath(s3locationurl);
	       	  
	       	  
			  item2.setCompanies(companies);
			  //to get ad path
//			  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
			// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
			  
			 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
			 //System.out.println("thumbpath : " +thumbpath);
			// ad.get().setThumbnail(thumbpath);
			 ad.get().setThumbnail(thumbpath.getS3Location());
			//to get banners start here
			 medias s3url ;
			 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
			 {
				// System.out.println("in if banners: " +ad.get().getId() );
				 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
				 
				// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
				ad.get().setContent(l.getContent());//set to advertisements first
			//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
				ArrayList<String> listofimagepaths = new ArrayList<String>();
				 for(String banner:l.getContent().getBanners())
				 {
					 s3url =  mediarepo.findByUid(banner);
					//System.out.println("s3url : " +s3url);
					
					listofimagepaths.add(s3url.getS3Location());
				//	l.get().getContent().setBanners(listofimagepaths);
					//banner.getContent().setBanners(listofimagepaths);
					//l.getContent()
					//System.out.println("array: " +listofimagepaths);
					ad.get().getContent().setBanners(listofimagepaths);
				 }
				
			 }
			 
			//to get banners end here
			 //to get video start here
			 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
				// System.out.println("in if video: " +ad.get().getId() );
		         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
				// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
				 ad.get().setContent(l.getContent());
				 //System.out.println("ad afetr setContent() : " +ad);
				 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
				// System.out.println("s3url in video : " +s3url);
				 if(s3url!=null) {
				 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
			 }
			 
			 //to get video end here
			 //to get simple text start here
			 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
			 {
				  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
				  ad.get().setContent(l.getContent());
			 }
			 
			 //to get simple text end here
			   item2.setA(ad.get());
			 //to get name and ph nomner
			   
			   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
			   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
			   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
			   item2.setEmailAddress(user.get().getEmailAddress());item2.setFullName(user.get().getFullName());
			   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
			   //System.out.println("item ph : " +item.getPhoneNumber());
			   //to get name and ph nomner till here
			   if(categories!=null) {
				   if(categories.size()>0) { 
			
			   for(ObjectId o:companies.getCompanyCategories() )
			   {
				
				   for(ObjectId id : categories)
				   {
					
					  if( o.equals(id)  )
					  {		  
					
						  set.add(item2);
														  
					  }
				   }
			   }
	
			   }//if >0
			}//if
			   
			}//for
			if(categories!=null) {
				if(categories.size()>0) {
			/*list.clear();
		    list = new ArrayList<>(set);*/
		    ull.clear();
		    ull = new ArrayList<>(set);
				}
			}
			//System.out.println("Size of list : " +ull.size());
			   for(ad_campaigns item3:ull)
			   {
				   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
					{
					//	System.out.println("in if 1 ");
					lat1 = Double.parseDouble(item3.getLocation().lat);
					lng1 = Double.parseDouble(item3.getLocation().lng);
					//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
					//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
						//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
						ul.add(item3);
					//}
					}
					
					if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
					{
					
		/*	Optional<users> u = usersRepo.findById(item3.getCreatedBy());			
			Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());			
			if(!(userloc.isEmpty())) {
		
			lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
			item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
		*/
			ul.add(item3);
	
		
			}				
	} 
			System.out.println("Final size of ul: " +ul.size());
			 
			 
			 String latest = (String) session.getAttribute("latestRequestId");
			    if (!requestId.equals(latest)) {
			        System.out.println("Ignoring outdated REMOVE response: " + requestId);
			        return "[]";
			    }
			    session.removeAttribute("FinalListOfAds");
				session.setAttribute("FinalListOfAds", ul);
				   return new Gson().toJson(ul);
}


@GetMapping("/templeads")
public String gettempleAds(HttpSession session,HttpServletRequest request) {
	
	String requestId = request.getParameter("requestId");
	// System.out.println("request id in rickshaw : " + requestId);
	session.setAttribute("latestRequestId", requestId);
	session.setAttribute("verticalenabled", "templeenabled");
	double lat=  Double.parseDouble((String)session.getAttribute("latitude"));	
	double lng = Double.parseDouble((String) session.getAttribute("longitude"));	
    ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
    session.removeAttribute("vlogsenabled");
    //session.setAttribute("currentLocationset", true);

	double slider =0.0; 
//	System.out.println("slider : " +slider );
	if(session.getAttribute("slider") !=null)
	{
		slider =(Double)session.getAttribute("slider");
	}
	else 
	{
		slider =2.0;
	}
	//System.out.println("categories : " +categories);
	
		 /* double lat = Double.parseDouble(location.getLat());
		  double lng = Double.parseDouble(location.getLng());*/
		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
			ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
			List<ad_campaigns> templeAds = new ArrayList<ad_campaigns>();
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
		     templeAds = ad_campaignsRepo.findByTempleAds();
		    // System.out.println("listOfGiTagAds: " +listOfGiTagAds);
		     
	for (ad_campaigns item1:templeAds)
	{
		if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item1.getLocation().lat);
		lng1 = Double.parseDouble(item1.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
		//	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
			ull.add(item1);
	//	}
		}
		
		if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item1.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
ull.add(item1);
//}
}
}	
	}
	//System.out.println("size of Ull : " +ull.size());
		for(ad_campaigns item2:ull)
		{
			
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
		//  System.out.println("companies: " +companies.getCompanyCategories());
            
            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
       	 // System.out.println("s3 loctio : " +s3Location);
       		//  item.getCompanies().setCompanyLogo(s3Location);
       	 // companies.setCompanyLogoPath(s3Location);
       	  String s3locationurl = s3Location.getS3Location();
       	 // System.out.println("s3locationurl : " +s3locationurl);
       	  companies.setCompanyLogoPath(s3locationurl);
       	  
       	  
		  item2.setCompanies(companies);
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
		 //to get name and ph nomner
		   
		   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
		   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
		   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
		   item2.setEmailAddress(user.get().getEmailAddress()); item2.setFullName(user.get().getFullName());
		   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
		   //System.out.println("item ph : " +item.getPhoneNumber());
		   //to get name and ph nomner till here
		 //  if(categories!=null) 
		   {
			//   if(categories.size()>0) 
			   { 
		
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			 //  for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
				  //if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
	//	   System.out.println("Contents  of list2" +set);		
		   }//if >0
		}//if
		   
		}//for
		//if(categories!=null)
		{
		//	if(categories.size()>0) 
			{
		/*list.clear();
	    list = new ArrayList<>(set);*/
	    ull.clear();
	    ull = new ArrayList<>(set);
			}
		}
		//System.out.println("Size of list : " +ull.size());
		   for(ad_campaigns item3:ull)
		   {
			   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item3.getLocation().lat);
				lng1 = Double.parseDouble(item3.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
					//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
					ul.add(item3);
				//}
				}
				
				if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item3.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
		
	//	}
		ul.add(item3);
		}
		
		
		}				
} 
	//	System.out.println("Final size of ul: " +ul.size());
		
		String latest = (String) session.getAttribute("latestRequestId");
		if (!requestId.equals(latest)) {
		//System.out.println("Ignoring outdated REMOVE response: " + requestId);
		return "[]";
		}
		 session.removeAttribute("FinalListOfAds");
			session.setAttribute("FinalListOfAds", ul);
			   return new Gson().toJson(ul);
	
}

@GetMapping("/registrationform")
public String redirectToOtherApp() {
    // Assuming the other app is deployed with context path /otherapp
    return "redirect:/kelirilink/registrationForm";
}


@GetMapping("/forestads")
public String getforestAds(HttpSession session,HttpServletRequest request) {	
	
	session.setAttribute("verticalenabled", "forestenabled");session.removeAttribute("vlogsenabled");
	
	String requestId = request.getParameter("requestId");
	// System.out.println("request id in rickshaw : " + requestId);
	session.setAttribute("latestRequestId", requestId);
	double lat=  Double.parseDouble((String)session.getAttribute("latitude"));	
	double lng = Double.parseDouble((String) session.getAttribute("longitude"));	
    ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
    
  //  session.setAttribute("currentLocationset", true);

	double slider =0.0; 
//	System.out.println("slider : " +slider );
	if(session.getAttribute("slider") !=null)
	{
		slider =(Double)session.getAttribute("slider");
	}
	else 
	{
		slider =2.0;
	}

		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
			ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
			List<ad_campaigns> ForestAds = new ArrayList<ad_campaigns>();
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
		     ForestAds = ad_campaignsRepo.findByForestAds();
		   
		     
	for (ad_campaigns item1:ForestAds)
	{
		if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item1.getLocation().lat);
		lng1 = Double.parseDouble(item1.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
		//	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
			ull.add(item1);
	//	}
		}
		
		if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item1.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
ull.add(item1);
//}
}
}	
	}
	System.out.println("size of Ull : " +ull.size());
		for(ad_campaigns item2:ull)
		{
			
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
		//  System.out.println("companies: " +companies.getCompanyCategories());
            
            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
       	 // System.out.println("s3 loctio : " +s3Location);
       		//  item.getCompanies().setCompanyLogo(s3Location);
       	 // companies.setCompanyLogoPath(s3Location);
       	  String s3locationurl = s3Location.getS3Location();
       	 // System.out.println("s3locationurl : " +s3locationurl);
       	  companies.setCompanyLogoPath(s3locationurl);
       	  
       	  
		  item2.setCompanies(companies);
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
		 //to get name and ph nomner
		   
		   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
		   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
		   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
		   item2.setEmailAddress(user.get().getEmailAddress()); item2.setFullName(user.get().getFullName());
		   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
		   //System.out.println("item ph : " +item.getPhoneNumber());
		   //to get name and ph nomner till here
		 //  if(categories!=null)
		   {
			//   if(categories.size()>0)
			   { 
		
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			  // for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
				 // if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
	//	   System.out.println("Contents  of list2" +set);		
		   }//if >0
		}//if
		   
		}//for
		//if(categories!=null)
		{
			//if(categories.size()>0) 
			{
		/*list.clear();
	    list = new ArrayList<>(set);*/
	    ull.clear();
	    ull = new ArrayList<>(set);
			}
		}
		//System.out.println("Size of list : " +ull.size());
		   for(ad_campaigns item3:ull)
		   {
			   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item3.getLocation().lat);
				lng1 = Double.parseDouble(item3.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
					//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
					ul.add(item3);
				//}
				}
				
				if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item3.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
		
	//	}
		ul.add(item3);
		}
		
		
		}				
} 
		System.out.println("Final size of ul: " +ul.size());
		
		String latest = (String) session.getAttribute("latestRequestId");
		if (!requestId.equals(latest)) {
		//System.out.println("Ignoring outdated REMOVE response: " + requestId);
		return "[]";
		}
		 session.removeAttribute("FinalListOfAds");
			session.setAttribute("FinalListOfAds", ul);
			   return new Gson().toJson(ul);
	
}


@GetMapping("/heritageads")
public String getheritageAds(HttpSession session,HttpServletRequest request) {	
	
	String requestId = request.getParameter("requestId");
	// System.out.println("request id in rickshaw : " + requestId);
	session.setAttribute("latestRequestId", requestId);
	session.setAttribute("verticalenabled", "heritageenabled");session.removeAttribute("vlogsenabled");
	double lat=  Double.parseDouble((String)session.getAttribute("latitude"));	
	double lng = Double.parseDouble((String) session.getAttribute("longitude"));	
    ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
    
    //session.setAttribute("currentLocationset", true);

	double slider =0.0; 
//	System.out.println("slider : " +slider );
	if(session.getAttribute("slider") !=null)
	{
		slider =(Double)session.getAttribute("slider");
	}
	else 
	{
		slider =2.0;
	}

		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
			ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
			List<ad_campaigns> heritageAds = new ArrayList<ad_campaigns>();
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
		     heritageAds = ad_campaignsRepo.findByHeritageAds();
		   
		     
	for (ad_campaigns item1:heritageAds)
	{
		if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item1.getLocation().lat);
		lng1 = Double.parseDouble(item1.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
		//	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
			ull.add(item1);
	//	}
		}
		
		if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item1.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
ull.add(item1);
//}
}
}	
	}
	System.out.println("size of Ull : " +ull.size());
		for(ad_campaigns item2:ull)
		{
			
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
		//  System.out.println("companies: " +companies.getCompanyCategories());
            
            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
       	 // System.out.println("s3 loctio : " +s3Location);
       		//  item.getCompanies().setCompanyLogo(s3Location);
       	 // companies.setCompanyLogoPath(s3Location);
       	  String s3locationurl = s3Location.getS3Location();
       	 // System.out.println("s3locationurl : " +s3locationurl);
       	  companies.setCompanyLogoPath(s3locationurl);
       	  
       	  
		  item2.setCompanies(companies);
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
		 //to get name and ph nomner
		   
		   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
		   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
		   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
		   item2.setEmailAddress(user.get().getEmailAddress()); item2.setFullName(user.get().getFullName());
		   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
		   //System.out.println("item ph : " +item.getPhoneNumber());
		   //to get name and ph nomner till here
		  // if(categories!=null)
		   {
			//   if(categories.size()>0)
			   { 
		
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			 //  for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
				 // if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
	//	   System.out.println("Contents  of list2" +set);		
		   }//if >0
		}//if
		   
		}//for
		//if(categories!=null) 
		{
		//	if(categories.size()>0)
			{
		/*list.clear();
	    list = new ArrayList<>(set);*/
	    ull.clear();
	    ull = new ArrayList<>(set);
			}
		}
		//System.out.println("Size of list : " +ull.size());
		   for(ad_campaigns item3:ull)
		   {
			   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item3.getLocation().lat);
				lng1 = Double.parseDouble(item3.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
					//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
					ul.add(item3);
				//}
				}
				
				if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item3.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
		
	//	}
		ul.add(item3);
		}
		
		
		}				
} 
		System.out.println("Final size of ul: " +ul.size());
		
		String latest = (String) session.getAttribute("latestRequestId");
		if (!requestId.equals(latest)) {
		//System.out.println("Ignoring outdated REMOVE response: " + requestId);
		return "[]";
		}
		 session.removeAttribute("FinalListOfAds");
			session.setAttribute("FinalListOfAds", ul);
			   return new Gson().toJson(ul);
	
}


@GetMapping("/hospitalads")
public String gethospitalAds(HttpSession session,HttpServletRequest request) {	
	
	session.setAttribute("verticalenabled", "hospitalenabled");session.removeAttribute("vlogsenabled");
	String requestId = request.getParameter("requestId");
	// System.out.println("request id in rickshaw : " + requestId);
	session.setAttribute("latestRequestId", requestId);
	double lat=  Double.parseDouble((String)session.getAttribute("latitude"));	
	double lng = Double.parseDouble((String) session.getAttribute("longitude"));	
    ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
    
    //session.setAttribute("currentLocationset", true);

	double slider =0.0; 
//	System.out.println("slider : " +slider );
	if(session.getAttribute("slider") !=null)
	{
		slider =(Double)session.getAttribute("slider");
	}
	else 
	{
		slider =2.0;
	}

		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
			ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
			List<ad_campaigns> hospitalAds = new ArrayList<ad_campaigns>();
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
			 hospitalAds = ad_campaignsRepo.findByHospitalAds();
		   
		     
	for (ad_campaigns item1:hospitalAds)
	{
		if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item1.getLocation().lat);
		lng1 = Double.parseDouble(item1.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
		//	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
			ull.add(item1);
	//	}
		}
		
		if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item1.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
ull.add(item1);
//}
}
}	
	}
	System.out.println("size of Ull : " +ull.size());
		for(ad_campaigns item2:ull)
		{
			
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
		//  System.out.println("companies: " +companies.getCompanyCategories());
            
            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
       	 // System.out.println("s3 loctio : " +s3Location);
       		//  item.getCompanies().setCompanyLogo(s3Location);
       	 // companies.setCompanyLogoPath(s3Location);
       	  String s3locationurl = s3Location.getS3Location();
       	 // System.out.println("s3locationurl : " +s3locationurl);
       	  companies.setCompanyLogoPath(s3locationurl);
       	  
       	  
		  item2.setCompanies(companies);
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
		 //to get name and ph nomner
		   
		   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
		   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
		   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
		   item2.setEmailAddress(user.get().getEmailAddress()); item2.setFullName(user.get().getFullName());
		   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
		   //System.out.println("item ph : " +item.getPhoneNumber());
		   //to get name and ph nomner till here
		//   if(categories!=null) 
		   {
			//   if(categories.size()>0) 
			   { 
		
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			 //  for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
			//	  if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
	//	   System.out.println("Contents  of list2" +set);		
		   }//if >0
		}//if
		   
		}//for
		//if(categories!=null) 
		{
		//	if(categories.size()>0)
			{
		/*list.clear();
	    list = new ArrayList<>(set);*/
	    ull.clear();
	    ull = new ArrayList<>(set);
			}
		}
		//System.out.println("Size of list : " +ull.size());
		   for(ad_campaigns item3:ull)
		   {
			   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item3.getLocation().lat);
				lng1 = Double.parseDouble(item3.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
					//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
					ul.add(item3);
				//}
				}
				
				if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item3.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
		
	//	}
		ul.add(item3);
		}
		
		
		}				
} 
		System.out.println("Final size of ul: " +ul.size());
		
		String latest = (String) session.getAttribute("latestRequestId");
		if (!requestId.equals(latest)) {
		//System.out.println("Ignoring outdated REMOVE response: " + requestId);
		return "[]";
		}
		 session.removeAttribute("FinalListOfAds");
			session.setAttribute("FinalListOfAds", ul);
			   return new Gson().toJson(ul);
	
}

@GetMapping("/rickshawads")
public String getrickshawAds(HttpSession session, HttpServletRequest request) {	
	/*String vertical = (String) session.getAttribute("verticalenabled");
	if (vertical != null && !vertical.equals("rickshawenabled")) {
		System.out.println("vertical : " + vertical);
	    return "[]";
	}*/
	
	 String requestId = request.getParameter("requestId");
	// System.out.println("request id in rickshaw : " + requestId);
	    session.setAttribute("latestRequestId", requestId);
	session.setAttribute("verticalenabled", "rickshawenabled");session.removeAttribute("vlogsenabled");
	double lat=  Double.parseDouble((String)session.getAttribute("latitude"));	
	double lng = Double.parseDouble((String) session.getAttribute("longitude"));	
    ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
    
    //session.setAttribute("currentLocationset", true);

	double slider =0.0; 
//	System.out.println("slider : " +slider );
	if(session.getAttribute("slider") !=null)
	{
		///slider =(Double)session.getAttribute("slider");
		slider = 2.0;
	}
	else 
	{
		slider =2.0;
	}

		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
			ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
			List<ad_campaigns> rickshawAds = new ArrayList<ad_campaigns>();
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
			 rickshawAds = ad_campaignsRepo.findByRickshawAds();
		   
		     
	for (ad_campaigns item1:rickshawAds)
	{
		if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item1.getLocation().lat);
		lng1 = Double.parseDouble(item1.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
		//	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
			ull.add(item1);
	//	}
		}
		
		if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item1.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
ull.add(item1);
//}
}
}	
	}
	System.out.println("size of Ull : " +ull.size());
		for(ad_campaigns item2:ull)
		{
			
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
		//  System.out.println("companies: " +companies.getCompanyCategories());
            
            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
       	 // System.out.println("s3 loctio : " +s3Location);
       		//  item.getCompanies().setCompanyLogo(s3Location);
       	 // companies.setCompanyLogoPath(s3Location);
       	  String s3locationurl = s3Location.getS3Location();
       	 // System.out.println("s3locationurl : " +s3locationurl);
       	  companies.setCompanyLogoPath(s3locationurl);
       	  
       	  
		  item2.setCompanies(companies);
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
		 //to get name and ph nomner
		   
		   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
		   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
		   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
		   item2.setEmailAddress(user.get().getEmailAddress()); item2.setFullName(user.get().getFullName());
		   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
		   //System.out.println("item ph : " +item.getPhoneNumber());
		   //to get name and ph nomner till here
		   //if(categories!=null)
		   {
			//   if(categories.size()>0)
			   { 
		
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			  // for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
				 // if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
	//	   System.out.println("Contents  of list2" +set);		
		   }//if >0
		}//if
		   
		}//for
	//	if(categories!=null) 
		{
	//		if(categories.size()>0)
			{
		/*list.clear();
	    list = new ArrayList<>(set);*/
	    ull.clear();
	    ull = new ArrayList<>(set);
			}
		}
		//System.out.println("Size of list : " +ull.size());
		   for(ad_campaigns item3:ull)
		   {
			   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item3.getLocation().lat);
				lng1 = Double.parseDouble(item3.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
					//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
					ul.add(item3);
				//}
				}
				
				if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item3.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
		
	//	}
		ul.add(item3);
		}
		
		
		}				
} 
	//	System.out.println("Final size of ul: " +ul.size());
		
		
		 
		 String latest = (String) session.getAttribute("latestRequestId");
		    if (!requestId.equals(latest)) {
		       // System.out.println("Ignoring outdated REMOVE response: " + requestId);
		        return "[]";
		    }
		    
		    session.removeAttribute("FinalListOfAds");
			session.setAttribute("FinalListOfAds", ul);
			   return new Gson().toJson(ul);
	
}


@GetMapping("/busads")
public String getbusAds(HttpSession session,HttpServletRequest request) {	
	
	session.setAttribute("verticalenabled", "busenabled");session.removeAttribute("vlogsenabled");
	
	String requestId = request.getParameter("requestId");
	// System.out.println("request id in rickshaw : " + requestId);
	session.setAttribute("latestRequestId", requestId);
	double lat=  Double.parseDouble((String)session.getAttribute("latitude"));	
	double lng = Double.parseDouble((String) session.getAttribute("longitude"));	
    ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
    
   // session.setAttribute("currentLocationset", true);

	double slider =0.0; 
//	System.out.println("slider : " +slider );
	if(session.getAttribute("slider") !=null)
	{
		slider =10.0;
	}
	else 
	{
		slider =10.0;
	}

		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
			ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
			List<ad_campaigns> busAds = new ArrayList<ad_campaigns>();
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
			busAds = ad_campaignsRepo.findByBusAds();
		   
		     
	for (ad_campaigns item1:busAds)
	{
		if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item1.getLocation().lat);
		lng1 = Double.parseDouble(item1.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
		//	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
			ull.add(item1);
	//	}
		}
		
		if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item1.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
ull.add(item1);
//}
}
}	
	}
	System.out.println("size of Ull : " +ull.size());
		for(ad_campaigns item2:ull)
		{
			
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
		//  System.out.println("companies: " +companies.getCompanyCategories());
            
            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
       	 // System.out.println("s3 loctio : " +s3Location);
       		//  item.getCompanies().setCompanyLogo(s3Location);
       	 // companies.setCompanyLogoPath(s3Location);
       	  String s3locationurl = s3Location.getS3Location();
       	 // System.out.println("s3locationurl : " +s3locationurl);
       	  companies.setCompanyLogoPath(s3locationurl);
       	  
       	  
		  item2.setCompanies(companies);
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
		 //to get name and ph nomner
		   
		   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
		   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
		   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
		   item2.setEmailAddress(user.get().getEmailAddress()); item2.setFullName(user.get().getFullName());
		   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
		   //System.out.println("item ph : " +item.getPhoneNumber());
		   //to get name and ph nomner till here
		  // if(categories!=null) 
		   {
			//   if(categories.size()>0)
			   { 
		
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			  // for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
				//  if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
	//	   System.out.println("Contents  of list2" +set);		
		   }//if >0
		}//if
		   
		}//for
		//if(categories!=null) 
		{
		//	if(categories.size()>0) 
			{
		/*list.clear();
	    list = new ArrayList<>(set);*/
	    ull.clear();
	    ull = new ArrayList<>(set);
			}
		}
		//System.out.println("Size of list : " +ull.size());
		   for(ad_campaigns item3:ull)
		   {
			   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item3.getLocation().lat);
				lng1 = Double.parseDouble(item3.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
					//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
					ul.add(item3);
				//}
				}
				
				if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item3.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
		
	//	}
		ul.add(item3);
		}
		
		
		}				
} 
		System.out.println("Final size of ul: " +ul.size());
		String latest = (String) session.getAttribute("latestRequestId");
		if (!requestId.equals(latest)) {
		//System.out.println("Ignoring outdated REMOVE response: " + requestId);
		return "[]";
		}
		 session.removeAttribute("FinalListOfAds");
			session.setAttribute("FinalListOfAds", ul);
			   return new Gson().toJson(ul);
	
}


@GetMapping("/carads")
public String getcarAds(HttpSession session,HttpServletRequest request) {	
	
	session.setAttribute("verticalenabled", "carenabled");session.removeAttribute("vlogsenabled");
	String requestId = request.getParameter("requestId");
	// System.out.println("request id in rickshaw : " + requestId);
	session.setAttribute("latestRequestId", requestId);
	double lat=  Double.parseDouble((String)session.getAttribute("latitude"));	
	double lng = Double.parseDouble((String) session.getAttribute("longitude"));	
    ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
    
  //  session.setAttribute("currentLocationset", true);

	double slider =0.0; 
//	System.out.println("slider : " +slider );
	if(session.getAttribute("slider") !=null)
	{
		//slider =(Double)session.getAttribute("slider");
		slider = 5.0;
	}
	else 
	{
		slider =5.0;
	}

		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
			ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
			List<ad_campaigns> carAds = new ArrayList<ad_campaigns>();
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
			carAds = ad_campaignsRepo.findByCarAds();
		   
		     
	for (ad_campaigns item1:carAds)
	{
		if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item1.getLocation().lat);
		lng1 = Double.parseDouble(item1.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
		//	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
			ull.add(item1);
	//	}
		}
		
		if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item1.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
ull.add(item1);
//}
}
}	
	}
	//System.out.println("size of Ull : " +ull.size());
		for(ad_campaigns item2:ull)
		{
			
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
		//  System.out.println("companies: " +companies.getCompanyCategories());
            
            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
       	 // System.out.println("s3 loctio : " +s3Location);
       		//  item.getCompanies().setCompanyLogo(s3Location);
       	 // companies.setCompanyLogoPath(s3Location);
       	  String s3locationurl = s3Location.getS3Location();
       	 // System.out.println("s3locationurl : " +s3locationurl);
       	  companies.setCompanyLogoPath(s3locationurl);
       	  
       	  
		  item2.setCompanies(companies);
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
		 //to get name and ph nomner
		   
		   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
		   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
		   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
		   item2.setEmailAddress(user.get().getEmailAddress()); item2.setFullName(user.get().getFullName());
		   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
		   //System.out.println("item ph : " +item.getPhoneNumber());
		   //to get name and ph nomner till here
		   //if(categories!=null)
{
			//   if(categories.size()>0) 
			   { 
		
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			//   for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
				//  if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
	//	   System.out.println("Contents  of list2" +set);		
		   }//if >0
		}//if
		   
		}//for
		//if(categories!=null) 
		{
		//	if(categories.size()>0) 
			{
		/*list.clear();
	    list = new ArrayList<>(set);*/
	    ull.clear();
	    ull = new ArrayList<>(set);
			}
		}
		//System.out.println("Size of list : " +ull.size());
		   for(ad_campaigns item3:ull)
		   {
			   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item3.getLocation().lat);
				lng1 = Double.parseDouble(item3.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
					//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
					ul.add(item3);
				//}
				}
				
				if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item3.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
		
	//	}
		ul.add(item3);
		}
		
		
		}				
} 
		System.out.println("Final size of ul: " +ul.size());
		
		String latest = (String) session.getAttribute("latestRequestId");
		if (!requestId.equals(latest)) {
		//System.out.println("Ignoring outdated REMOVE response: " + requestId);
		return "[]";
		}
		 session.removeAttribute("FinalListOfAds");
			session.setAttribute("FinalListOfAds", ul);
			   return new Gson().toJson(ul);
	
}


@GetMapping("/goodsads")
public String getgoodsAds(HttpSession session,HttpServletRequest request) {	
	
	session.setAttribute("verticalenabled", "goodsenabled");session.removeAttribute("vlogsenabled");
	
	String requestId = request.getParameter("requestId");
	// System.out.println("request id in rickshaw : " + requestId);
	session.setAttribute("latestRequestId", requestId);
	double lat=  Double.parseDouble((String)session.getAttribute("latitude"));	
	double lng = Double.parseDouble((String) session.getAttribute("longitude"));	
    ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
    
   // session.setAttribute("currentLocationset", true);

	double slider =0.0; 
//	System.out.println("slider : " +slider );
	if(session.getAttribute("slider") !=null)
	{
		//slider =(Double)session.getAttribute("slider");
		slider = 5.0;
	}
	else 
	{
		slider =5.0;
	}

		  double lat1 = 0.0;
		  double lng1 = 0.0;
		//	double dist_range=300.00;
			ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
			List<ad_campaigns> goodsAds = new ArrayList<ad_campaigns>();
			 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
			goodsAds = ad_campaignsRepo.findByGoodsAds();
		   
		     
	for (ad_campaigns item1:goodsAds)
	{
		if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item1.getLocation().lat);
		lng1 = Double.parseDouble(item1.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
		//	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
			ull.add(item1);
	//	}
		}
		
		if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(item1.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
//if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
ull.add(item1);
//}
}
}	
	}
	System.out.println("size of Ull : " +ull.size());
		for(ad_campaigns item2:ull)
		{
			
			Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
		//  System.out.println("companies: " +companies.getCompanyCategories());
            
            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
       	 // System.out.println("s3 loctio : " +s3Location);
       		//  item.getCompanies().setCompanyLogo(s3Location);
       	 // companies.setCompanyLogoPath(s3Location);
       	  String s3locationurl = s3Location.getS3Location();
       	 // System.out.println("s3locationurl : " +s3locationurl);
       	  companies.setCompanyLogoPath(s3locationurl);
       	  
       	  
		  item2.setCompanies(companies);
		  //to get ad path
//		  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
		// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
		  
		 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
		 //System.out.println("thumbpath : " +thumbpath);
		// ad.get().setThumbnail(thumbpath);
		 ad.get().setThumbnail(thumbpath.getS3Location());
		//to get banners start here
		 medias s3url ;
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
		 {
			// System.out.println("in if banners: " +ad.get().getId() );
			 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			ad.get().setContent(l.getContent());//set to advertisements first
		//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
			ArrayList<String> listofimagepaths = new ArrayList<String>();
			 for(String banner:l.getContent().getBanners())
			 {
				 s3url =  mediarepo.findByUid(banner);
				//System.out.println("s3url : " +s3url);
				
				listofimagepaths.add(s3url.getS3Location());
			//	l.get().getContent().setBanners(listofimagepaths);
				//banner.getContent().setBanners(listofimagepaths);
				//l.getContent()
				//System.out.println("array: " +listofimagepaths);
				ad.get().getContent().setBanners(listofimagepaths);
			 }
			
		 }
		 
		//to get banners end here
		 //to get video start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
			// System.out.println("in if video: " +ad.get().getId() );
	         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
			// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
			 ad.get().setContent(l.getContent());
			 //System.out.println("ad afetr setContent() : " +ad);
			 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
			// System.out.println("s3url in video : " +s3url);
			 if(s3url!=null) {
			 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
		 }
		 
		 //to get video end here
		 //to get simple text start here
		 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
		 {
			  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
			  ad.get().setContent(l.getContent());
		 }
		 
		 //to get simple text end here
		   item2.setA(ad.get());
		 //to get name and ph nomner
		   
		   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
		   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
		   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
		   item2.setEmailAddress(user.get().getEmailAddress()); item2.setFullName(user.get().getFullName());
		   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
		   //System.out.println("item ph : " +item.getPhoneNumber());
		   //to get name and ph nomner till here
		//   if(categories!=null) 
		   {
//			   if(categories.size()>0) 
			   { 
		
		   for(ObjectId o:companies.getCompanyCategories() )
		   {
			//   System.out.println("value of o : " +o);
			 //  for(ObjectId id : categories)
			   {
				//   System.out.println("value of id : " +id);
				//  if( o.equals(id)  )
				  {		  
				//	  System.out.println("inside equals : " +o +" value of id : " +id );
					  set.add(item2);
					//  System.out.println("Contents  of list2" +set);										  
				  }
			   }
		   }
	//	   System.out.println("Contents  of list2" +set);		
		   }//if >0
		}//if
		   
		}//for
	//	if(categories!=null) 
		{
		//	if(categories.size()>0) 
			{
		/*list.clear();
	    list = new ArrayList<>(set);*/
	    ull.clear();
	    ull = new ArrayList<>(set);
			}
		}
		//System.out.println("Size of list : " +ull.size());
		   for(ad_campaigns item3:ull)
		   {
			   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item3.getLocation().lat);
				lng1 = Double.parseDouble(item3.getLocation().lng);
				//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
					//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
					ul.add(item3);
				//}
				}
				
				if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item3.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal <=slider) {
		
	//	}
		ul.add(item3);
		}
		
		
		}				
} 
		System.out.println("Final size of ul: " +ul.size());
		String latest = (String) session.getAttribute("latestRequestId");
		if (!requestId.equals(latest)) {
		//System.out.println("Ignoring outdated REMOVE response: " + requestId);
		return "[]";
		}
		 session.removeAttribute("FinalListOfAds");
		 session.setAttribute("FinalListOfAds", ul);
		 return new Gson().toJson(ul);	
}


@GetMapping("/responsivelocationsfromsession")
public String responsivelocationsfromsession(HttpSession session)
{
	List<ad_campaigns> ul = (List<ad_campaigns>) session.getAttribute("FinalListOfAds");
//	System.out.println("UL : " +ul.get(3));
    return new Gson().toJson(ul);
}


@GetMapping("/vlogs")
public String getVlogs(HttpSession session,HttpServletRequest request)
{
	 //System.out.println("vlogs");
	 session.setAttribute("vlogsenabled", "vlogsenabled");
	 session.setAttribute("verticalenabled", "vlogsenabled");
	 String requestId = request.getParameter("requestId");
	// System.out.println("request id in rickshaw : " + requestId);
	session.setAttribute("latestRequestId", requestId);
	 double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	//  session.removeAttribute("verticalenabled");
	  double slider = (Double)session.getAttribute("slider");
	  ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
	  double lat1 = 0.0;
	  double lng1 = 0.0;
	
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
		ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
	//List<ad_campaigns> list = ad_campaignsRepo.findByLat();

		List<ad_campaigns> list = new ArrayList<ad_campaigns>();
		 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
		 String vertical = (String)	session.getAttribute("verticalenabled");
			
			
				
			 list = ad_campaignsRepo.findByVlogs();
			 for(ad_campaigns item:list)
			   {	
				if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
				{
				//	System.out.println("in if 1 ");
				lat1 = Double.parseDouble(item.getLocation().lat);
				lng1 = Double.parseDouble(item.getLocation().lng);
				double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<= slider) {
					
					ull.add(item);
				//}
				}		
				if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
				{
				//	System.out.println("in if 2 ");
					//System.out.println("Created By : " +item.getCreatedBy());
		//ObjectId id = new ObjectId(item.getCreatedBy());
		//System.out.println("ObjectId : " +id);
		Optional<users> u = usersRepo.findById(item.getCreatedBy());
		//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		//System.out.println("user locations : " +userloc);
		if(!(userloc.isEmpty())) {
		//System.out.println(userloc.get().getLocation().getX());
		//System.out.println(userloc.get().getLocation().getY());
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
		double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
		//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);

		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<= slider) {
		ull.add(item);
		//}
		}
		}	
		} 
			
			 System.out.println("ull size 1: " +ull.size());
	for(ad_campaigns item2:ull)
	{
	//System.out.println("item inside for : " +item);
		Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
		
		//System.out.println("advertisements : " +ad.get().getCompany());
		//item.getA().setTitle(a.get().getTitle());
		//item.getA().setDescription(a.get().getDescription());
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
//	  System.out.println("companies: " +companies); 
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
		 // System.out.println("s3 loctio : " +s3Location);
			//  item.getCompanies().setCompanyLogo(s3Location);
		 // companies.setCompanyLogoPath(s3Location);
		  String s3locationurl = s3Location.getS3Location();
		 // System.out.println("s3locationurl : " +s3locationurl);
		  companies.setCompanyLogoPath(s3locationurl);
		  
	  item2.setCompanies(companies);
	//to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			//System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
        advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	   item2.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item2.setEmailAddress(user.get().getEmailAddress());item2.setFullName(user.get().getFullName());
item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber())	   ;

	   
	   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item2.getAdvertisementId());// only if this is not empty
	   if (cta != null && !cta.isEmpty()) {
	   for(buttonActionDTO b : cta)
	   {
		   if (b.getCtaId() == null || b.getAction() == null) continue;
			    switch (b.getCtaId()) {
			        case "64887c11cce361dafc86c241":  // Phone
			            item2.setPhoneNumber(b.getAction());
			            break;
			        case "64887c11cce361dafc86c242":  // WhatsApp
			            item2.setWhatsappNumber(b.getAction());
			            break;
			        case "64e99c7651a484a077ae2c1f":  // Take me there
			        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
			        	if(b.getLatitude()!=null && b.getLongitude()!=null) {
			        	 item2.getLocation().setLat(Double.toString(b.getLatitude()));
			        	 
			        	 item2.getLocation().setLng(Double.toString(b.getLongitude()));}
			            break;
			        default:
			            break;
			    }
		   }
	   }

	   

	//System.out.println("Final size of ull 2: " +ull.size());
	String latest = (String) session.getAttribute("latestRequestId");
	if (!requestId.equals(latest)) {
	//System.out.println("Ignoring outdated REMOVE response: " + requestId);
	return "[]";
	}
	session.removeAttribute("FinalListOfAds");
	session.setAttribute("FinalListOfAds", ull);

}
	  return new Gson().toJson(ull);
}

@GetMapping("/news")
public String getNews(HttpSession session,HttpServletRequest request)
{
	 session.setAttribute("vlogsenabled", "newsenabled");
	 
	 String requestId = request.getParameter("requestId");
	// System.out.println("request id in rickshaw : " + requestId);
	session.setAttribute("latestRequestId", requestId);
	 double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	  session.setAttribute("verticalenabled", "newsenabled");
		//session.removeAttribute("verticalenabled");
	  double slider = (Double)session.getAttribute("slider");
	  ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
	  double lat1 = 0.0;
	  double lng1 = 0.0;
	
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
		ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();


		List<ad_campaigns> list = new ArrayList<ad_campaigns>();
		 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
		 String vertical = (String)	session.getAttribute("verticalenabled");
			
			
				
			 list = ad_campaignsRepo.findByNews();
			 for(ad_campaigns item:list)
			   {	
				if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
				{
			
				lat1 = Double.parseDouble(item.getLocation().lat);
				lng1 = Double.parseDouble(item.getLocation().lng);
				double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
				//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<= slider) {
					
					ull.add(item);
				//}
				}		
				if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
				{
				
		Optional<users> u = usersRepo.findById(item.getCreatedBy());
		
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		
		if(!(userloc.isEmpty())) {
		
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
		double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
		//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<= slider) {
		ull.add(item);
	//	}
		}
		}	
		} 
			
			 System.out.println("ull size : " +ull.size());
	for(ad_campaigns item2:ull)
	{
	//System.out.println("item inside for : " +item);
		Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
		
		//System.out.println("advertisements : " +ad.get().getCompany());
		//item.getA().setTitle(a.get().getTitle());
		//item.getA().setDescription(a.get().getDescription());
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
//	  System.out.println("companies: " +companies); 
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
		 // System.out.println("s3 loctio : " +s3Location);
			//  item.getCompanies().setCompanyLogo(s3Location);
		 // companies.setCompanyLogoPath(s3Location);
		  String s3locationurl = s3Location.getS3Location();
		 // System.out.println("s3locationurl : " +s3locationurl);
		  companies.setCompanyLogoPath(s3locationurl);
		  
	  item2.setCompanies(companies);
	//to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			//System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
        advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	   item2.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item2.setEmailAddress(user.get().getEmailAddress());item2.setFullName(user.get().getFullName());
item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber())	   ;

	   
	   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item2.getAdvertisementId());// only if this is not empty
	   if (cta != null && !cta.isEmpty()) {
	   for(buttonActionDTO b : cta)
	   {
		   if (b.getCtaId() == null || b.getAction() == null) continue;
			    switch (b.getCtaId()) {
			        case "64887c11cce361dafc86c241":  // Phone
			            item2.setPhoneNumber(b.getAction());
			            break;
			        case "64887c11cce361dafc86c242":  // WhatsApp
			            item2.setWhatsappNumber(b.getAction());
			            break;
			        case "64e99c7651a484a077ae2c1f":  // Take me there
			        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
			        	if(b.getLatitude()!=null && b.getLongitude()!=null) {
			        	 item2.getLocation().setLat(Double.toString(b.getLatitude()));
			        	 
			        	 item2.getLocation().setLng(Double.toString(b.getLongitude()));}
			            break;
			        default:
			            break;
			    }
		   }
	   }

	   

//	System.out.println("Final size of ul: " +ull.size());
	
	String latest = (String) session.getAttribute("latestRequestId");
	if (!requestId.equals(latest)) {
	//System.out.println("Ignoring outdated REMOVE response: " + requestId);
	return "[]";
	}
	session.removeAttribute("FinalListOfAds");
	session.setAttribute("FinalListOfAds", ull);

}
	  return new Gson().toJson(ull);
}

@GetMapping("/download-apk")
public void downloadApk(HttpServletResponse response) throws IOException {

    Path apkPath = Paths.get(apkFilePath);

    if (!Files.exists(apkPath)) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "APK not found");
        return;
    }

    response.setContentType("application/vnd.android.package-archive");
    response.setHeader(
            "Content-Disposition",
            "attachment; filename=\"kelirivehicle.apk\""
    );
    response.setContentLengthLong(Files.size(apkPath));

    try (InputStream in = Files.newInputStream(apkPath);
         OutputStream out = response.getOutputStream()) {

        byte[] buffer = new byte[8192];
        int len;
        while ((len = in.read(buffer)) != -1) {
            out.write(buffer, 0, len);
        }
        out.flush();
    }
}

public List<ad_campaigns> dosearch(@RequestBody String searchKeyword,HttpSession session, HttpServletRequest request)
{
	//to search ad_campaigns
	//ad_campaignsRepo
	 //getSessionAnalytics(request).keywords.add(searchKeyword);
	//System.out.println("in keyword : " +searchKeyword);
	List<ad_campaigns> finalul = new ArrayList<ad_campaigns>();
	
	session.setAttribute("searchKeyword", searchKeyword);
	 String escapedKeyword = searchKeyword.replaceAll("([\\W])", "\\\\$1"); // Escape special characters
     String regex = ".*" + escapedKeyword + ".*"; // Construct regex pattern
	List<ad_campaigns> searchresult1 =ad_campaignsRepo.searchAllFields(regex);
//	String afterescape=searchKeyword.replaceAll("([\\\\.*+?^=!:${}()|[\\]\\\\])", "\\\\$1");//Gives error
	
	
    // System.out.println(escapedKeyword +"and : " +regex);
	List<advertisements> searchresult2 = adrepo.searchAllFields(regex);
	
//	String s1 = searchKeyword.replaceAll("([\\\\.*+?^${}()|\\[\\]\\])", "\\\\$1");
			    
//    System.out.println(s1 +"and : " +"and : " );
	
	List<companies> searchresult3= companyrepo.searchAllFields(regex);
	
	List<users> searchresult4 = usersRepo.searchAllFields(regex);
	
	List<master_product_categories> searchresult5 = productRepo.searchAllFields(regex);
	
	//System.out.println("Search Result1 : " +searchresult1.size() +"\n");
	//System.out.println("Search Result2 : " +searchresult2.size()+"\n");
	//System.out.println("Search Result3 : " +searchresult3.size() +"\n");
	//System.out.println("Search Result4 : " +searchresult4.size() +"\n");
	//System.out.println("Search Result5 : " +searchresult5.size() +"\n");
	//System.out.println("Search Result5 : " +searchresult5 +"\n");g
	//when found in advertisemenst start here
	List<ObjectId> searchresult22= new ArrayList<ObjectId>();	
	for(advertisements sr2:searchresult2 )//if advertisements is not empty
	{
		//find if the record with this advertisementId is active
	searchresult22.add(new ObjectId(sr2.getId()));		
	}
	List<ad_campaigns> sublist1 = 	ad_campaignsRepo.searchwithadId(searchresult22);   //sub1
	//System.out.println("sublist1 from advertisements : " +sublist1.size() +"\n");
	//when found in advertisemenst end here
	
	//when found in companies start here
	List<ObjectId> searchresult33= new ArrayList<ObjectId>();
	List<ObjectId> searchresult331= new ArrayList<ObjectId>();
	for(companies sr3:searchresult3)//if companies is not empty
	{
		//find all the advertisements with this company and then check active so 2queries 
		searchresult33.add(new ObjectId(sr3.getId()));		
	}
	
	List<advertisements> list2 =adrepo.searchByCompanyId(searchresult33);
	for(advertisements a : list2)
	{
	searchresult331.add(new ObjectId(a.getId()));	
	}
	List<ad_campaigns> sublist3 = ad_campaignsRepo.searchwithadId(searchresult331);  //sub
	//System.out.println("sublist3 from companies: " +sublist3.size() +"\n");
	//when found in companies end here
	

	
	//when found in users start here
	List<ObjectId> searchresult44= new ArrayList<ObjectId>();
	for(users sr4:searchresult4 ) { //if users is not empty
		searchresult44.add(new ObjectId(sr4.getId()));
	}
		//check the ad_campaigns
    List<ad_campaigns>	sublist4 = ad_campaignsRepo.searchWithCreatedBy(searchresult44); //sub
	//System.out.println("sublist4 from users : " +sublist4.size() +"\n");

	//when found in users end here
	
	//when found in product category start here
	List<ObjectId> searchresult55= new ArrayList<ObjectId>();
	for(master_product_categories sr5:searchresult5)//if master_product_categories is not empty
	{
		searchresult55.add(new ObjectId(sr5.getId()));
	}
		//check the companies  category array for this id, then advertisement then ad_campaigns
	
	List<companies> list5 = companyrepo.searchByCompanyCategory(searchresult55);

	List<ObjectId> searchresult551= new ArrayList<ObjectId>();
	for(companies c :list5 ) {
		searchresult551.add(new ObjectId(c.getId()));
	}
	
	List<advertisements> list6 = adrepo.searchByCompanyId(searchresult551);
	List<ObjectId> searchresult552= new ArrayList<ObjectId>();
    for(advertisements a:list6)
    {
    	searchresult552.add(new ObjectId(a.getId()));
    }
	List<ad_campaigns> sublist7 = ad_campaignsRepo.searchwithadId(searchresult552);          //sub
   //System.out.println("sublist7 from product category : " +sublist7.size());
	//when found in product category end here
	
	//System.out.println("sublist1 : " +sublist1.size() +"and contents: " +sublist1);
	//System.out.println("sublist2 : " +sublist3.size() +"and contents: " +sublist3);
	//System.out.println("sublist3 : " +sublist4.size() +"and contents: " +sublist4);
	//System.out.println("sublist4 : " +sublist7.size() +"and contents: " +sublist7);
	 List<ad_campaigns> ull = new ArrayList<ad_campaigns>();
	 ull.addAll(sublist1);
	 ull.addAll(sublist3);
	 ull.addAll(sublist4);
     ull.addAll(sublist7);
//	 System.out.println("ull : " +ull.size());
	 List<ad_campaigns> duplicateElementsRemoved = new ArrayList<ad_campaigns>();
	 Set<String> seenIds = new HashSet<>();
	 for(ad_campaigns element : ull)
	 {
		// System.out.println(element.getId());
	         /*   if (Collections.frequency(ull, element) > 1 && !duplicateElementsRemoved.contains(element)) {
	            	duplicateElementsRemoved.add(element);
	            }	*/
		
		 if (seenIds.add(element.getId())) {
			// System.out.println(seenIds.add(element.getId()));
			 duplicateElementsRemoved.add(element);
         }
		// System.out.println("size of set : " +seenIds.size());
	 }
	 
	// System.out.println("duplicateElementsRemoved : " +duplicateElementsRemoved.size());
		
//to get the reachable ads start here 
	 
	
	 
	 double lat = Double.parseDouble((String)session.getAttribute("latitude"));
	  double lng = Double.parseDouble((String)session.getAttribute("longitude"));
	
//	  double slider = (Double)session.getAttribute("slider");
	  double slider=0.0;
	  ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
	  double lat1 = 0.0;
	  double lng1 = 0.0;
	  if(session.getAttribute("slider") !=null)
		{
			slider =(Double)session.getAttribute("slider");
		}
		else 
		{
			slider =2.0;
		}
		ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();ArrayList<ad_campaigns> ulll=new ArrayList<ad_campaigns>();
	//List<ad_campaigns> list = ad_campaignsRepo.findByLat();
//	System.out.println("------"+list.size());
	//System.out.println("------"+list);
		List<String> listOfIds = new ArrayList<String>();
		for(ad_campaigns d : duplicateElementsRemoved)
		{
			listOfIds.add(d.getId());
		}
		List<ad_campaigns> list = new ArrayList<ad_campaigns>();
		 Set<ad_campaigns> set = new HashSet<ad_campaigns>();
		 //System.out.println("slider: " +slider);
		 //System.out.println("categories: " +categories);
			 list = ad_campaignsRepo.searchfromfinallist(listOfIds);
			
			 for(ad_campaigns item:list)
			   {	
				 
				 if(item.getGiTag()==1 || item.getTemple()==1 || item.getForest() ==1 || item.getHeritage() ==1 || item.getHospital() ==1 || item.getBus()==1 || item.getCar() ==1 || item.getRickshaw() ==1 || item.getGoods()==1 || item.getVlogs() ==1 || item.getNews() ==1)
				 {  
					 if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
						{
						
						lat1 = Double.parseDouble(item.getLocation().lat);
						lng1 = Double.parseDouble(item.getLocation().lng);
						double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
						
						//if gitag is enabled do not check the distance  
						/*if(distanceVal<=item.getLocation().getRange()/1000 ) */{
							//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
							ulll.add(item);
						}
						}		
						if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
						{
						
				Optional<users> u = usersRepo.findById(item.getCreatedBy());
				
				Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
				
				if(!(userloc.isEmpty())) {
				
				lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
				item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
				double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
				
				/*if(distanceVal<=item.getLocation().getRange()/1000)*/ {
				ulll.add(item);
				}
				}
				}	
										
				 }
				 
				 else {
				if((item.getLocation().getLat()!=null) && (item.getLocation().getLng()!=null))
				{
				
				lat1 = Double.parseDouble(item.getLocation().lat);
				lng1 = Double.parseDouble(item.getLocation().lng);
				double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
				
				//if gitag is enabled do not check the distance  
				if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<= slider) {
					//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
					ulll.add(item);
				}
				}		
				if((item.getLocation().getLat()==null) && (item.getLocation().getLng()==null))
				{
				
		Optional<users> u = usersRepo.findById(item.getCreatedBy());
		
		Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
		
		if(!(userloc.isEmpty())) {
		
		lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
		item.getLocation().setLat(String.valueOf(lat1));item.getLocation().setLng(String.valueOf(lng1));//null pointer
		double distanceVal=distance(lat1,lat,lng1,lng);item.setDistance(distanceVal);
		
		if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal<= slider) {
		ulll.add(item);
		}
		}
		}	
		} 
				 
			   }		 
			 System.out.println("ull size : " +ulll.size());
	for(ad_campaigns item2:ulll)
	{
	//System.out.println("item inside for : " +item);
		Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
		
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
//	  System.out.println("companies: " +companies); 
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
		 // System.out.println("s3 loctio : " +s3Location);
			//  item.getCompanies().setCompanyLogo(s3Location);
		 // companies.setCompanyLogoPath(s3Location);
		  String s3locationurl = s3Location.getS3Location();
		 // System.out.println("s3locationurl : " +s3locationurl);
		  companies.setCompanyLogoPath(s3locationurl);
		  
	  item2.setCompanies(companies);
	//to get ad path
//	  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
	// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	 //System.out.println("thumbpath : " +thumbpath);
	// ad.get().setThumbnail(thumbpath);
	 ad.get().setThumbnail(thumbpath.getS3Location());
	//to get banners start here
	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		// System.out.println("in if banners: " +ad.get().getId() );
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		ad.get().setContent(l.getContent());//set to advertisements first
	//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
			//System.out.println("s3url : " +s3url);
			
			listofimagepaths.add(s3url.getS3Location());
		//	l.get().getContent().setBanners(listofimagepaths);
			//banner.getContent().setBanners(listofimagepaths);
			//l.getContent()
			//System.out.println("array: " +listofimagepaths);
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
		// System.out.println("in if video: " +ad.get().getId() );
         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 //System.out.println("ad afetr setContent() : " +ad);
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		// System.out.println("s3url in video : " +s3url);
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	   item2.setA(ad.get());
//System.out.println("final ad : " +ad);
	   
	   //to get name and ph nomner
	   
Optional<users> user  = usersRepo.findByIdphandemail(item2.getCreatedBy());
item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
item2.setEmailAddress(user.get().getEmailAddress());item2.setFullName(user.get().getFullName());
item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber())   ;
	   List<buttonActionDTO> cta=  advertisementService.getCtaButtonActionsByCreatedByTemplate(item2.getAdvertisementId());
	   
	   if (cta != null && !cta.isEmpty()) {
	   for(buttonActionDTO b : cta)
	   {
		   if (b.getCtaId() == null || b.getAction() == null) continue;
		   
			    switch (b.getCtaId()) {
			        case "64887c11cce361dafc86c241":  // Phone
			            item2.setPhoneNumber(b.getAction());
			            break;
			        case "64887c11cce361dafc86c242":  // WhatsApp
			            item2.setWhatsappNumber(b.getAction());
			            break;
			        case "64e99c7651a484a077ae2c1f":  // Take me there
			        	// item2.setTakemethere("Latitude: " + b.getLatitude() + ", Longitude: " + b.getLongitude());
			        	if(b.getLatitude()!=null && b.getLongitude() !=null) {
			        	 item2.getLocation().setLat(Double.toString(b.getLatitude()));
			        	 
			        	 item2.getLocation().setLng(Double.toString(b.getLongitude()));}
			            break;
			        default:
			            break;
			    }
		   }
	   }
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here
	   
	   if(categories!=null) {
		   if(categories.size()>0) {
	   for(ObjectId o:companies.getCompanyCategories() )
	   {
		//   System.out.println("value of o : " +o);
		   for(ObjectId id : categories)
		   {
			//   System.out.println("value of id : " +id);
			  if( o.equals(id)  )
			  {		  
			//	  System.out.println("inside equals : " +o +" value of id : " +id );
				  set.add(item2);
				//  System.out.println("Contents  of list2" +set);										  
			  }
		   }
	   }
	}	
		   }   
	}	
	if(categories!=null) {
		if(categories.size()>0) {
	/*	list.clear();
	    list = new ArrayList<>(set);*/
		ulll.clear();
	    ulll = new ArrayList<>(set);
		}  
	}
//	System.out.println("ull : " +ulll.size())  ;
	for(ad_campaigns item3:ulll)
	   {	
		if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(item3.getLocation().lat);
		lng1 = Double.parseDouble(item3.getLocation().lng);
	//	double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
	//	if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal< slider) {
			//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);
			ul.add(item3);
	//	}
		}		
		if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
		{
		
//Optional<users> u = usersRepo.findById(item3.getCreatedBy());

//Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());

//if(!(userloc.isEmpty())) {

////lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
//item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getA().getTitle()+" calculated distance val : " +distanceVal);

//if(distanceVal<=item3.getLocation().getRange()/1000 && distanceVal< slider) {
ul.add(item3);
//}
//}
}	
}
//	System.out.println("ul size 11111111111 " +ul.size());
	List<ad_campaigns> finallistofadsfromsession = (List)session.getAttribute("FinalListOfAds"); // session.setAttribute("FinalListOfAds", finalul);
//	System.out.println("finallistofadsfromsession" +finallistofadsfromsession.size());
	  Set<String> sessionIds = finallistofadsfromsession.stream()
              .map(ad_campaigns::getId)
              .filter(Objects::nonNull)
              .collect(Collectors.toSet());

      // --- Step 2A: Keep only elements found in both lists (IN-PLACE) ---
      ul.removeIf(ad -> !sessionIds.contains(ad.getId()));
//	System.out.println("ul size:::::::::::: " +ul.size());
	String enabledVertical   =(String) session.getAttribute("verticalenabled");
//	System.out.println("enabled Verticle : " +enabledVertical); 
	if(enabledVertical !=null)
	{
		System.out.println("enabled Verticle : " +enabledVertical); 
		
		if(enabledVertical.equals("gitagenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getGiTag()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		if(enabledVertical.equals("templeenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getTemple()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		if(enabledVertical.equals("forestenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getForest()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		
		if(enabledVertical.equals("heritageenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getHeritage()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		
		if(enabledVertical.equals("hospitalenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getHospital()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		
		if(enabledVertical.equals("busenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getBus()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		
		if(enabledVertical.equals("carenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getCar()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		if(enabledVertical.equals("rickshawenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getRickshaw()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		if(enabledVertical.equals("goodsenabled"))
		{
			for (ad_campaigns a: ul) {
				if(a.getGoods()==1)
				{
					finalul.add(a);
				}
			}
		}
		
		
	}
	
	else
	{
		finalul = ul;
	}
	 session.removeAttribute("FinalListOfAds");
		session.setAttribute("FinalListOfAds", finalul);

	System.out.println("Final size of ul: " +finalul.size());
		 // return new Gson().toJson(ul);
	
//to get the reachable ads endtem
		return finalul;
	 
	
}


@PostMapping("/removesearch")
public String removesearch(HttpSession session, HttpServletRequest request)
{
	// If this request is outdated (user selected another vertical already), ignore it
	String requestId = request.getParameter("requestId");
    session.setAttribute("latestRequestId", requestId);
    System.out.println("request Id in Remove searchs : " + requestId);
	/*session.removeAttribute("vlogsenabled");session.removeAttribute("verticalenabled");*/
    session.removeAttribute("searchKeyword");
	/*String vertical = (String) session.getAttribute("verticalenabled");
	
	if (vertical != null) {
		System.out.println("vertical REMOVE : " + vertical);
	    return "[]";
	}*/
	  	  
	  String latitude  =(String)session.getAttribute("latitude");
	  String longitude =(String)session.getAttribute("longitude");
	  ArrayList<ObjectId> categories=(ArrayList)session.getAttribute("categories");
	  
	//     session.setAttribute("currentLocationset", true);
//System.out.println("in remove");
		double slider =0.0; 

		if(session.getAttribute("slider") !=null)
		{
			slider =(Double)session.getAttribute("slider");
		}
		else 
		{
			slider =2.0;
		}
	
		
			  double lat = Double.parseDouble(latitude);
			  double lng = Double.parseDouble(longitude);
			  double lat1 = 0.0;  double lng1 = 0.0;
			//	double dist_range=300.00;
				ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
				ArrayList<ad_campaigns> ull=new ArrayList<ad_campaigns>();
				List<ad_campaigns> list = new ArrayList<ad_campaigns>();
				Set<ad_campaigns> set = new HashSet<ad_campaigns>();
				 String vertical = (String)	session.getAttribute("verticalenabled");
				if(vertical !=null)  // for all vehicles 
				{
					System.out.println("IIn vertical" +vertical);
					String parameterToPass = VERTICAL_MAP.getOrDefault(vertical, "defaultTag");

					list = ad_campaignsService.getCampaignsByDynamicField(parameterToPass,1);
					
					for (ad_campaigns item1:list)
					{
						if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
						{
							ull.add(item1);
						
						}
						
						if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
						{
				
							ull.add(item1);
				
				}
				}	
					}
				
				 else
				 {
					 list = ad_campaignsRepo.findByLat();
			 
			for(ad_campaigns item1:list)
		{
			if((item1.getLocation().getLat()!=null) && (item1.getLocation().getLng()!=null))
			{
			//	System.out.println("in if 1 ");
			lat1 = Double.parseDouble(item1.getLocation().lat);
			lng1 = Double.parseDouble(item1.getLocation().lng);
			double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
			//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
				if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
				ull.add(item1);
			}
			}
			
			if((item1.getLocation().getLat()==null) && (item1.getLocation().getLng()==null))
			{
			
	Optional<users> u = usersRepo.findById(item1.getCreatedBy());
	//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
	Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
	//System.out.println("user locations : " +userloc);
	if(!(userloc.isEmpty())) {
	lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
	item1.getLocation().setLat(String.valueOf(lat1));item1.getLocation().setLng(String.valueOf(lng1));//null pointer
	double distanceVal=distance(lat1,lat,lng1,lng);item1.setDistance(distanceVal);
	if(distanceVal<=item1.getLocation().getRange()/1000 && distanceVal <=slider) {
	ull.add(item1);
	}
	}
	}	
		}
				 }
			for(ad_campaigns item2:ull)
			{
				
				Optional<advertisements> ad = adrepo.findById(item2.getAdvertisementId());//String
	            companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
			//  System.out.println("companies: " +companies.getCompanyCategories());
	            
	            medias s3Location = mediarepo.findById(companies.getCompanyLogo());
	       	 // System.out.println("s3 loctio : " +s3Location);
	       		//  item.getCompanies().setCompanyLogo(s3Location);
	       	 // companies.setCompanyLogoPath(s3Location);
	       	  String s3locationurl = s3Location.getS3Location();
	       	 // System.out.println("s3locationurl : " +s3locationurl);
	       	  companies.setCompanyLogoPath(s3locationurl);
	       	  
	       	  
			  item2.setCompanies(companies);
			  //to get ad path
//			  System.out.println("thumbnail and ad type : " +ad.get().getAdType()+"and : " +ad.get().getThumbnail());
			// Optional<medias> thumbpath =  mediarepo.findById(ad.get().getThumbnail());
			  
			 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
			 //System.out.println("thumbpath : " +thumbpath);
			// ad.get().setThumbnail(thumbpath);
			 ad.get().setThumbnail(thumbpath.getS3Location());
			//to get banners start here
			 medias s3url ;
			 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
			 {
				// System.out.println("in if banners: " +ad.get().getId() );
				 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
				 
				// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
				ad.get().setContent(l.getContent());//set to advertisements first
			//	System.out.println("set to advertisements first : " ad.get().setContent(l.getContent()));
				ArrayList<String> listofimagepaths = new ArrayList<String>();
				 for(String banner:l.getContent().getBanners())
				 {
					 s3url =  mediarepo.findByUid(banner);
					//System.out.println("s3url : " +s3url);
					
					listofimagepaths.add(s3url.getS3Location());
				//	l.get().getContent().setBanners(listofimagepaths);
					//banner.getContent().setBanners(listofimagepaths);
					//l.getContent()
					//System.out.println("array: " +listofimagepaths);
					ad.get().getContent().setBanners(listofimagepaths);
				 }
				
			 }
			 
			//to get banners end here
			 //to get video start here
			 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
				// System.out.println("in if video: " +ad.get().getId() );
		         advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
				// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
				 ad.get().setContent(l.getContent());
				 //System.out.println("ad afetr setContent() : " +ad);
				 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
				// System.out.println("s3url in video : " +s3url);
				 if(s3url!=null) {
				 ad.get().getContent().setVideoLink(s3url.getS3Location()); }
			 }
			 
			 //to get video end here
			 //to get simple text start here
			 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
			 {
				  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
				  ad.get().setContent(l.getContent());
			 }
			 
			 //to get simple text end here
			   item2.setA(ad.get());
			 //to get name and ph nomner
			   
			   Optional<users> user  = 		   usersRepo.findByIdphandemail(item2.getCreatedBy());
			   //System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
			   item2.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
			   item2.setEmailAddress(user.get().getEmailAddress());item2.setFullName(user.get().getFullName());
			   item2.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
			   //System.out.println("item ph : " +item.getPhoneNumber());
			   //to get name and ph nomner till here
			   if(categories!=null) {
				   if(categories.size()>0) { 
			
			   for(ObjectId o:companies.getCompanyCategories() )
			   {
				
				   for(ObjectId id : categories)
				   {
					
					  if( o.equals(id)  )
					  {		  
					
						  set.add(item2);
														  
					  }
				   }
			   }
	
			   }//if >0
			}//if
			   
			}//for
			if(categories!=null) {
				if(categories.size()>0) {
			/*list.clear();
		    list = new ArrayList<>(set);*/
		    ull.clear();
		    ull = new ArrayList<>(set);
				}
			}
			//System.out.println("Size of list : " +ull.size());
			   for(ad_campaigns item3:ull)
			   {
				   if((item3.getLocation().getLat()!=null) && (item3.getLocation().getLng()!=null))
					{
					//	System.out.println("in if 1 ");
					lat1 = Double.parseDouble(item3.getLocation().lat);
					lng1 = Double.parseDouble(item3.getLocation().lng);
					//double distanceVal=distance(lat1,lat,lng1,lng);item3.setDistance(distanceVal);
					//if(distanceVal<=item.getLocation().getRange()/1000 && distanceVal <=slider) {
						//if(distanceVal<=item3.getLocation().getRange()/1000 ) {
						ul.add(item3);
					//}
					}
					
					if((item3.getLocation().getLat()==null) && (item3.getLocation().getLng()==null))
					{
					
		/*	Optional<users> u = usersRepo.findById(item3.getCreatedBy());			
			Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());			
			if(!(userloc.isEmpty())) {
		
			lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
			item3.getLocation().setLat(String.valueOf(lat1));item3.getLocation().setLng(String.valueOf(lng1));//null pointer
		*/
			ul.add(item3);
	
		
			}				
	} 
				
			System.out.println("Final size of ul: " +ul.size());
			 
			 
			 String latest = (String) session.getAttribute("latestRequestId");
			    if (!requestId.equals(latest)) {
			        System.out.println("Ignoring outdated REMOVE response: " + requestId);
			        return "[]";
			    }
			    session.removeAttribute("FinalListOfAds");
				session.setAttribute("FinalListOfAds", ul);
				   return new Gson().toJson(ul);
}



@GetMapping("/vehicleDetails")
public ModelAndView getVehicleDetails(@RequestParam("id") String id,HttpSession session,HttpServletRequest request) {
	System.out.println("id : " +id);
	session.removeAttribute("activeLink");
	session.setAttribute("activeLink", "home");
	
	ModelAndView m = new ModelAndView();
	
	//m.setViewName("index");
	
	ad_campaigns adDetail = ad_campaignsRepo.findByIdadDetails(id);
	double lat=  Double.parseDouble((String)session.getAttribute("latitude"));	
	double lng = Double.parseDouble((String) session.getAttribute("longitude"));
	ArrayList<ad_campaigns> ul=new ArrayList<ad_campaigns>();
	List<ad_campaigns> list = ad_campaignsRepo.findByLat();
	  double lat1 = 0.0;
	  double lng1 = 0.0;

	int i=0;
	

		Optional<advertisements> ad = adrepo.findById(adDetail.getAdvertisementId());//String
		
	
	   
	  companies companies =  companyrepo.findBycustomId(ad.get().getCompany());  
	
	  
	  medias s3Location = mediarepo.findById(companies.getCompanyLogo());
	
	  String s3locationurl = s3Location.getS3Location();
	
	  companies.setCompanyLogoPath(s3locationurl);
	  adDetail.setCompanies(companies);
	  
	
	  
	 medias thumbpath =  mediarepo.findById(new ObjectId(ad.get().getThumbnail()));
	
	 ad.get().setThumbnail(thumbpath.getS3Location());

	 medias s3url ;
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23b"))//get the banners array
	 {
		
		 advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		 
	
		ad.get().setContent(l.getContent());//set to advertisements first
	
		ArrayList<String> listofimagepaths = new ArrayList<String>();
		 for(String banner:l.getContent().getBanners())
		 {
			 s3url =  mediarepo.findByUid(banner);
	
			
			listofimagepaths.add(s3url.getS3Location());
		
			ad.get().getContent().setBanners(listofimagepaths);
		 }
		
	 }
	 
	//to get banners end here
	 //to get video start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23c")) {
        advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));		 
		// System.out.println("l value : " +l.getContent().getBanners()+"and : " +l);
		 ad.get().setContent(l.getContent());
		 s3url =  mediarepo.findByUid(l.getContent().getVideoLink());
		 if(s3url!=null) {
		 ad.get().getContent().setVideoLink(s3url.getS3Location());}
		 else
		 {
			 if(ad.get().getContent().getVideoLink().contains("youtube"))
			 {
			//	 System.out.println("inside youtube : ");
				String videoid=  ad.get().getContent().getVideoLink().substring(ad.get().getContent().getVideoLink().indexOf("=") + 1);
				//https://www.youtube.com/embed/
					ad.get().getContent().setVideoLink("https://www.youtube.com/embed/"+videoid+"?rel=0");
			 }
		 }
	 }
	 
	 //to get video end here
	 //to get simple text start here
	 if(ad.get().getAdType().equals("64887c11cce361dafc86c23d"))//get the banners array
	 {
		  advertisements l = adrepo.findbyContent(new ObjectId(ad.get().getId()));
		  ad.get().setContent(l.getContent());
	 }
	 
	 //to get simple text end here
	  adDetail.setA(ad.get());
	//  ad.get().setThumbnail(thumbpath);
	//  System.out.println("ad.get : " +ad.get());
	//   System.out.println("ad finally: " +ad);
	   //to get name and ph nomner
	   
Optional<users> user  = 		   usersRepo.findByIdphandemail(adDetail.getCreatedBy());
//System.out.println("user : " +user.get().getPhoneNumber().getDialNumber());
adDetail.setPhoneNumber(user.get().getPhoneNumber().getDialNumber());
adDetail.setEmailAddress(user.get().getEmailAddress());
adDetail.setWhatsappNumber(user.get().getPhoneNumber().getDialNumber());
//System.out.println("item ph : " +item.getPhoneNumber());
//to get name and ph nomner till here

		i++;
		if((adDetail.getLocation().getLat()!=null) && (adDetail.getLocation().getLng()!=null))
		{
		//	System.out.println("in if 1 ");
		lat1 = Double.parseDouble(adDetail.getLocation().lat);
		lng1 = Double.parseDouble(adDetail.getLocation().lng);
		double distanceVal=distance(lat1,lat,lng1,lng);adDetail.setDistance(distanceVal);
		//if(distanceVal<=items.getLocation().getRange()/1000 && distanceVal <=1.3) {
		///	ul.add(items);
		//}
		}
		
		if((adDetail.getLocation().getLat()==null) && (adDetail.getLocation().getLng()==null))
		{
		//	System.out.println("in if 2 ");
			//System.out.println("Created By : " +item.getCreatedBy());
//ObjectId id = new ObjectId(item.getCreatedBy());
//System.out.println("ObjectId : " +id);
Optional<users> u = usersRepo.findById(adDetail.getCreatedBy());
//System.out.println("users last known loc: " +u.get().getLastKnownLocation());
Optional<txn_user_locations> userloc =txnuserrepo.findById(u.get().getLastKnownLocation());
//System.out.println("user locations : " +userloc);
if(!(userloc.isEmpty())) {
//System.out.println(userloc.get().getLocation().getX());
//System.out.println(userloc.get().getLocation().getY());
lng1=userloc.get().getLocation().getX();lat1=userloc.get().getLocation().getY();
adDetail.getLocation().setLat(String.valueOf(lat1));adDetail.getLocation().setLng(String.valueOf(lng1));//null pointer
double distanceVal=distance(lat1,lat,lng1,lng);adDetail.setDistance(distanceVal);
//System.out.println("range when location is null : " +item.getLocation().getRange()+" distance val : " +distanceVal);

//if(distanceVal<=items.getLocation().getRange()/1000 && distanceVal <=1.3) {
//ul.add(items);
//}
}
}	
//} 
	
	ObjectMapper mapper = new ObjectMapper();

	String adDetailsJson = "[]"; // default to empty list

	if (adDetail != null) {
	    try {
	        adDetailsJson = mapper.writeValueAsString(adDetail);
	    } catch (JsonProcessingException e) {
	        e.printStackTrace();
	        adDetailsJson = "[]"; // fallback
	    }
	}
	
	//session.setAttribute("addetailsJson", adDetailsJson);
	//session.setAttribute("vehiclead", 1);
	
	m.addObject("addetailsJson", adDetailsJson);
	m.addObject("vehiclead", 1);
	 //ModelAndView m = new ModelAndView();
	    populateHomepageData(m, request, adDetailsJson, 1);
    return  m;
}
private void populateHomepageData(ModelAndView m, HttpServletRequest request,
        String addetailsJson, int vehiclead) {

// Mobile detection
	System.out.println("in populate");
String userAgent = request.getHeader("User-Agent").toLowerCase();
boolean isMobile = userAgent.contains("iphone") || userAgent.contains("android") || userAgent.contains("mobile");

// Users list (simplified)
List<users> users = usersRepo.findAll();
m.addObject("users", new Gson().toJson(users));

// Add ad details and vehicle flag
m.addObject("addetailsJson", addetailsJson != null ? addetailsJson : "[]");
m.addObject("vehiclead", vehiclead);

// Decide which JSP to render
m.setViewName(isMobile ? "responsiveindex" : "index");
}



@GetMapping("/responsivelocationsfromvehicle")
public String responsivelocationsfromvehicle(HttpSession session)
{
	List<ad_campaigns> ul = (List<ad_campaigns>) session.getAttribute("FinalListOfAds");
//	System.out.println("UL : " +ul.get(3));
    return new Gson().toJson(ul);
}


@GetMapping("/homepagefromvehicle")
public ModelAndView homepagefromvehicle(HttpServletRequest request,HttpSession session)
{
	session.removeAttribute("activeLink");
	session.setAttribute("activeLink", "home");
//	session.setAttribute("vehiclead",1);
    String userAgent = request.getHeader("User-Agent").toLowerCase();
    System.out.println("user agent : " +userAgent);
    // Check for mobile devices based on User-Agent
    boolean isMobile = userAgent.contains("iphone") || userAgent.contains("android") || userAgent.contains("mobile"); 
    System.out.println("in /");
	System.out.println("in index");
	ModelAndView m = new ModelAndView();	
	
	if (isMobile) {
		m.setViewName("responsiveindex");
        return m;  // Return mobile-specific JSP
    } else {
    	List<users> users = usersRepo.findAll();
    	for(users u : users)
    	{
    		//System.out.println("user id : " + u.getId());
    		ObjectId objectId = new ObjectId(u.getId());
    		// System.out.println("ObjectId : " +objectId);
    		user_profiles profilepicId = user_profilesrepo.findByuserId(objectId);//get profilePicturre id
    		// ObjectId objectId2 = new ObjectId(profilepicId.getUserId());
    	//	System.out.println("Profile pic Id : " +profilepicId);
    		if(profilepicId != null) {
    if(profilepicId.getProfilePicture()!=null) 
    {	
    	medias profiles3location = 	 mediarepo.findById(profilepicId.getProfilePicture());
    	if(profiles3location !=null ) 
    	{
    		//System.out.println("profiles3location : "+profiles3location.getS3Location());
    		u.setProfilePicPath(profiles3location.getS3Location());
    		}
    	}
    	}
    	}
    //	System.out.println("Users: " +users.size());
    	m.addObject("users",new Gson().toJson(users));
    	m.setViewName("index");
    	Object addetailsJson = session.getAttribute("addetailsJson");
    	Object vehiclead = session.getAttribute("vehiclead");

    	if (addetailsJson != null) {
    	    m.addObject("addetailsJson", addetailsJson);
    	    session.removeAttribute("addetailsJson");
    	} else {
    	    m.addObject("addetailsJson", "[]");
    	}

    	if (vehiclead != null) {
    	    m.addObject("vehiclead", vehiclead);
    	    session.removeAttribute("vehiclead");
    	} else {
    	    m.addObject("vehiclead", 0);
    	}        return m; // Return desktop-specific JSP
    }
	//return m ;
}

@GetMapping("/vehicleRoute")
public ModelAndView showResponsiveLocationfromvehicle(HttpSession session,@RequestParam("adsId") String adsId, Model model)
{
	session.setAttribute("activeLink", "location");
System.out.println("ads Id :" +adsId);	  model.addAttribute("adsId", adsId);

	   ModelAndView mv = new ModelAndView("responsivelocation");
		   return mv;

//	return ul;

}
}
