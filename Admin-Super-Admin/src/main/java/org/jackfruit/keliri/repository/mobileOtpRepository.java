package org.jackfruit.keliri.repository;



import org.jackfruit.keliri.model.mobile_otp;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.data.mongodb.repository.Update;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface mobileOtpRepository extends MongoRepository<mobile_otp, String> 
{
	
   
	
}
