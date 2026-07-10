package org.jackfruit.keliri.controller;

import io.jsonwebtoken.Claims;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.advertisements;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.repository.advertisementsRepository;
import org.jackfruit.keliri.repository.ad_campaignsRepository;
import org.jackfruit.keliri.service.JwtService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/admin")
public class AdminAdvertisementController {

    @Autowired
    private advertisementsRepository advertisementsRepo;

    @Autowired
    private ad_campaignsRepository campaignsRepo;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private MongoTemplate mongoTemplate;

    private void resolveFieldsToObjectId(advertisements ad) {
        if (ad.getCompany() != null) {
            String compStr = ad.getCompany();
            if (compStr.length() == 24 && compStr.matches("^[0-9a-fA-F]{24}$")) {
                ad.setCompany(new ObjectId(compStr));
            }
        }
        
        if (ad.getAdType() != null) {
            String adTypeStr = ad.getAdType();
            if ("6707daa0-7efa-4ccd-990d-a97cdb4f0dc7".equals(adTypeStr)) {
                ad.setAdType(new ObjectId("64887c11cce361dafc86c23b"));
            } else if ("f91cf072-c131-48f5-ae1b-3bd9434e47ac".equals(adTypeStr)) {
                ad.setAdType(new ObjectId("64887c11cce361dafc86c23c"));
            } else if ("fa2d8d92-bfd7-48af-aad1-8a55c84d436d".equals(adTypeStr)) {
                ad.setAdType(new ObjectId("64887c11cce361dafc86c23d"));
            } else if (adTypeStr.length() == 24 && adTypeStr.matches("^[0-9a-fA-F]{24}$")) {
                ad.setAdType(new ObjectId(adTypeStr));
            }
        }
        
        if (ad.getThumbnail() != null) {
            String thumbStr = ad.getThumbnail();
            if (thumbStr.length() == 24 && thumbStr.matches("^[0-9a-fA-F]{24}$")) {
                ad.setThumbnail(new ObjectId(thumbStr));
            } else if (thumbStr.length() == 36 || !thumbStr.matches("^[0-9a-fA-F]{24}$")) {
                Query q = new Query(Criteria.where("uid").is(thumbStr));
                Document mediaDoc = mongoTemplate.findOne(q, Document.class, "medias");
                if (mediaDoc != null && mediaDoc.get("_id") != null) {
                    ad.setThumbnail(mediaDoc.get("_id"));
                }
            }
        }
    }

    @PostMapping("/advertisements/create")
    public ResponseEntity<?> createAdvertisement(@RequestBody advertisements ad) {
        try {
            // Generate a UUID for the uid field
            if (ad.getUid() == null || ad.getUid().isEmpty()) {
                ad.setUid(UUID.randomUUID().toString());
            }
            
            // Default status or gitagnumber if needed
            ad.setPaymentStatus("pending");

            resolveFieldsToObjectId(ad);

            advertisements saved = advertisementsRepo.save(ad);
            System.out.println("✅ [AdminAdvertisementController] Created advertisement. ID: " + saved.getId() + ", UID: " + saved.getUid());

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", saved);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Failed to create advertisement", "error", e.getMessage()));
        }
    }

    @PutMapping("/advertisements/update/{uid}")
    public ResponseEntity<?> updateAdvertisement(@PathVariable("uid") String uid, @RequestBody advertisements adUpdate) {
        try {
            Optional<advertisements> existingOpt = advertisementsRepo.findByUid(uid);
            if (existingOpt.isEmpty()) {
                // Try finding by Id just in case the parameter passed is database ObjectId
                existingOpt = advertisementsRepo.findById(uid);
            }

            if (existingOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("success", false, "message", "Advertisement not found with UID: " + uid));
            }

            advertisements existing = existingOpt.get();
            if (adUpdate.getTitle() != null) existing.setTitle(adUpdate.getTitle());
            if (adUpdate.getDescription() != null) existing.setDescription(adUpdate.getDescription());
            if (adUpdate.getCompany() != null) existing.setCompany(adUpdate.getCompany());
            if (adUpdate.getThumbnail() != null) existing.setThumbnail(adUpdate.getThumbnail());
            if (adUpdate.getContent() != null) existing.setContent(adUpdate.getContent());
            if (adUpdate.getAdType() != null) existing.setAdType(adUpdate.getAdType());
            if (adUpdate.getCustomTextSection() != null) existing.setCustomTextSection(adUpdate.getCustomTextSection());
            if (adUpdate.getCta() != null) existing.setCta(adUpdate.getCta());
            if (adUpdate.getStartDate() != null) existing.setStartDate(adUpdate.getStartDate());
            if (adUpdate.getEndDate() != null) existing.setEndDate(adUpdate.getEndDate());

            resolveFieldsToObjectId(existing);

            advertisements saved = advertisementsRepo.save(existing);
            System.out.println("✅ [AdminAdvertisementController] Updated advertisement. ID: " + saved.getId() + ", UID: " + saved.getUid());

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", saved);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Failed to update advertisement", "error", e.getMessage()));
        }
    }

    @PostMapping("/campaigns/create")
    public ResponseEntity<?> createCampaign(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestBody ad_campaigns campaign) {
        try {
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("success", false, "message", "Missing or invalid Authorization header"));
            }

            String token = authHeader.substring(7);
            Claims claims = jwtService.parseToken(token);
            String adminId = claims.get("userId", String.class);

            if (adminId == null || adminId.isEmpty()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("success", false, "message", "Invalid token: missing userId"));
            }

            campaign.setCreatedBy(adminId);
            
            if (campaign.getUid() == null || campaign.getUid().isEmpty()) {
                campaign.setUid(UUID.randomUUID().toString());
            }

            campaign.setCompaignsStatus("PENDING");
            campaign.setCreatedThrough("WEB");

            ad_campaigns saved = campaignsRepo.save(campaign);
            System.out.println("✅ [AdminAdvertisementController] Created campaign. ID: " + saved.getId() + ", UID: " + saved.getUid());

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", saved);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Failed to create campaign", "error", e.getMessage()));
        }
    }


    @GetMapping("/advertisements/{uid}")
    public ResponseEntity<?> getAdvertisement(@PathVariable("uid") String uid) {
        try {
            Optional<advertisements> existingOpt = advertisementsRepo.findByUid(uid);
            if (existingOpt.isEmpty()) {
                existingOpt = advertisementsRepo.findById(uid);
            }
            if (existingOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("success", false, "message", "Advertisement not found with UID: " + uid));
            }
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", existingOpt.get());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Failed to get advertisement", "error", e.getMessage()));
        }
    }

    @DeleteMapping("/advertisements/{uid}")

    public ResponseEntity<?> deleteAdvertisement(@PathVariable("uid") String uid) {
        try {
            Optional<advertisements> existingOpt = advertisementsRepo.findByUid(uid);
            if (existingOpt.isEmpty()) {
                existingOpt = advertisementsRepo.findById(uid);
            }

            if (existingOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("success", false, "message", "Advertisement not found with UID: " + uid));
            }

            advertisementsRepo.delete(existingOpt.get());
            System.out.println("✅ [AdminAdvertisementController] Deleted advertisement. UID: " + uid);

            return ResponseEntity.ok(Map.of("success", true, "message", "Advertisement deleted successfully"));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Failed to delete advertisement", "error", e.getMessage()));
        }
    }
}
