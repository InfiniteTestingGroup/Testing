package org.jackfruit.keliri.service;

import java.util.Date;

import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.medias;
import org.jackfruit.keliri.model.medias_keliri;
import org.jackfruit.keliri.repository.medias_keliriRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class medias_keliriService {
	
	@Autowired
	private medias_keliriRepository medias_keliriRepo;
	
	 public medias_keliri createMedia(String s3Location, String uid, String mediaKey, String mediaId, String url,
				String mediaType, ObjectId createdBy, Date createdAt, Date updatedAt) {
		 medias_keliri m = new medias_keliri(s3Location,  uid, mediaKey,  mediaId,  url,
	    			 mediaType,  createdBy,  createdAt,  updatedAt);
	        return medias_keliriRepo.save(m); // Inserts the record
	    }

}
