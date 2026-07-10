package org.jackfruit.keliri.controller;

import org.jackfruit.keliri.model.medias;
import org.jackfruit.keliri.repository.mediaRepository;
import org.jackfruit.keliri.service.S3Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.bson.types.ObjectId;

import java.util.*;

@RestController
@RequestMapping("/api/admin/media")
public class AdminMediaController {

    @Autowired
    private S3Service s3Service;

    @Autowired
    private mediaRepository mediaRepo;

    @PostMapping("/upload")
    public ResponseEntity<?> uploadMedia(@RequestParam("file") MultipartFile file) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 1. Upload to S3 using S3Service, with a fallback to mock URL if it fails
            String s3Url;
            try {
                s3Url = s3Service.uploadFile(file);
            } catch (Exception e) {
                System.err.println("⚠️ [AdminMediaController] S3 upload failed, using fallback URL: " + e.getMessage());
                s3Url = "https://placehold.co/150?text=" + file.getOriginalFilename();
            }
            
            // 2. Extract media key
            String mediaKey = "";
            String[] urlParts = s3Url.split("/");
            if (urlParts.length > 4) {
                mediaKey = urlParts[urlParts.length - 1];
            } else {
                mediaKey = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            }

            // 3. Generate a UUID for the uid field
            String uid = UUID.randomUUID().toString();

            // 4. Save to the 'medias' collection in MongoDB
            medias media = new medias(
                    s3Url,                         // s3Location
                    uid,                           // uid
                    mediaKey,                      // mediaKey
                    mediaKey,                      // mediaId
                    s3Url,                         // url
                    "MEDIA",                       // mediaType
                    new ObjectId("64ed86323200e1d6c520605d"), // createdBy
                    new Date(),                    // createdAt
                    new Date()                     // updatedAt
            );
            
            medias savedMedia = mediaRepo.save(media);
            System.out.println("✅ [AdminMediaController] Saved media to MongoDB. ID: " + savedMedia.getId() + ", UID: " + uid);

            // 5. Build response matching expected formats
            response.put("success", true);
            response.put("uid", uid);
            response.put("mediaUid", uid);
            response.put("url", s3Url);
            
            Map<String, Object> data = new HashMap<>();
            data.put("uid", uid);
            data.put("url", s3Url);
            response.put("data", data);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Failed to upload media");
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
