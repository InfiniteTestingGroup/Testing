package org.jackfruit.keliri.service;



import java.time.LocalDateTime;

import org.jackfruit.keliri.model.mobile_otp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

import com.mongodb.client.result.UpdateResult;

@Service
public class mobileotpService {

	@Autowired
	private MongoTemplate mongotemplate;
	
	public void createUserOtp(mobile_otp mobileOtp)
	{
		System.out.println("in insert");
		System.out.println("Mobile Data : " +mobileOtp);
		mongotemplate.insert(mobileOtp);
	}
	
	public boolean verifyotp(String mobilenumber,int otp  )
	{
		
		//"update mobile_otp set mobile_otp_confirm_time= CURRENT_TIMESTAMP,mobile_otp_status='0'  
		//where mobile_otp_number=? and  mobile_otp_expiry_time >= CURRENT_TIMESTAMP and mobile_otp_value=? ";
		//System.out.println("in verify otp: " +otp);
		Query query = new Query();
		query.addCriteria(Criteria.where("mobile_otp_number").is(mobilenumber));
		query.addCriteria(Criteria.where("mobile_otp_value").is(otp));
		mobile_otp userTest1 = mongotemplate.findOne(query, mobile_otp.class);
		//System.out.println("User with : " +userTest1);
		
		LocalDateTime currentTime = LocalDateTime.now();
		if(userTest1!=null)
		{
		if(currentTime.isBefore(userTest1.getMobile_otp_expiry_time()))
		{
			//System.out.println("in check time");
			Update update = new Update();
	        update.set("mobile_otp_confirm_time", currentTime);
	        update.set("mobile_otp_status", 1);
	        UpdateResult result    = mongotemplate.updateFirst(query, update, mobile_otp.class);
	        if(result.getModifiedCount()>0)
			{
				return true;
				
			}
		}
		}
		return false;
	}
}
