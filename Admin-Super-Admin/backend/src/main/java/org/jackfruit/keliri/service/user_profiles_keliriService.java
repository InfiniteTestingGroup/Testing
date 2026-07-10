package org.jackfruit.keliri.service;

import java.util.Date;

import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.user_profiles;
import org.jackfruit.keliri.model.user_profiles_keliri;
import org.jackfruit.keliri.repository.user_profiles_keliriRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class user_profiles_keliriService {
	
	
	@Autowired
	private user_profiles_keliriRepository user_profiles_keliriRepo;
	
	
	
	public user_profiles_keliri create_user_profiles(ObjectId userId, ObjectId profilePicture, ObjectId createdBy, ObjectId updatedBy,Date createdAt)
	{
		user_profiles_keliri  user_profiless = new user_profiles_keliri(userId,profilePicture, createdBy,  updatedBy, createdAt);
		return user_profiles_keliriRepo.save(user_profiless);
	}


}
