package org.jackfruit.keliri.controller;

import io.jsonwebtoken.Claims;
import org.jackfruit.keliri.model.AdminRegistration;
import org.jackfruit.keliri.repository.AdminRegistrationRepository;
import org.jackfruit.keliri.service.JwtService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import org.jackfruit.keliri.model.users;
import org.jackfruit.keliri.model.phoneNumber;
import org.jackfruit.keliri.repository.usersRepository;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/admin/profile")
public class AdminProfileController {

    @Autowired
    private JwtService jwtService;

    @Autowired
    private AdminRegistrationRepository adminRegistrationRepo;

    @Autowired
    private usersRepository usersRepo;

    @Autowired
    private MongoTemplate mongoTemplate;

    @GetMapping
    public ResponseEntity<?> getOwnProfile(
            @RequestHeader(value = "Authorization", required = false) String authHeader) {
        String adminId = extractAdminId(authHeader);
        if (adminId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "message", "Unauthorized"));
        }

        try {
            Map<String, Object> profile = new LinkedHashMap<>();

            // 1. Fetch from AdminRegistration (if present)
            Optional<AdminRegistration> regOpt = adminRegistrationRepo.findById(adminId);

            // 2. Fetch from users collection (if present)
            Optional<users> userOpt = usersRepo.findById(adminId);

            // 3. Fetch from companies collection by user.id or user.companyUID (strictly final for lambda capture)
            final Map<String, Object> companyDoc;
            if (userOpt.isPresent()) {
                Map<String, Object> tempDoc = null;
                String compId = userOpt.get().getId();
                if (compId != null) {
                    tempDoc = mongoTemplate.findById(compId, Map.class, "companies");
                }
                if (tempDoc == null && userOpt.get().getCompanyUID() != null) {
                    Query q = new Query(Criteria.where("uid").is(userOpt.get().getCompanyUID()));
                    tempDoc = mongoTemplate.findOne(q, Map.class, "companies");
                }
                companyDoc = tempDoc;
            } else {
                companyDoc = null;
            }

            // Resolve Name
            final String name = regOpt.map(AdminRegistration::getAuthorizedPerson)
                    .or(() -> userOpt.map(users::getFullName))
                    .orElseGet(() -> {
                        if (companyDoc != null) {
                            if (companyDoc.get("authorizedPerson") != null) {
                                return String.valueOf(companyDoc.get("authorizedPerson"));
                            }
                            Object kelReg = companyDoc.get("keliriRegistration");
                            if (kelReg instanceof Map && ((Map) kelReg).get("authorizedPerson") != null) {
                                return String.valueOf(((Map) kelReg).get("authorizedPerson"));
                            }
                        }
                        return "Keliri Admin";
                    });

            // Resolve Email
            final String email = regOpt.map(AdminRegistration::getEmailId)
                    .or(() -> userOpt.map(users::getEmailAddress))
                    .orElseGet(() -> {
                        if (companyDoc != null) {
                            if (companyDoc.get("email") != null) {
                                return String.valueOf(companyDoc.get("email"));
                            }
                            if (companyDoc.get("emailId") != null) {
                                return String.valueOf(companyDoc.get("emailId"));
                            }
                        }
                        return "Not available";
                    });

            // Resolve Company Name
            final String companyName = regOpt.map(AdminRegistration::getCompanyName)
                    .or(() -> userOpt.map(users::getCompanyName))
                    .filter(c -> c != null && !c.isBlank())
                    .orElseGet(() -> {
                        if (companyDoc != null) {
                            if (companyDoc.get("companyName") != null) {
                                return String.valueOf(companyDoc.get("companyName"));
                            }
                            if (companyDoc.get("name") != null) {
                                return String.valueOf(companyDoc.get("name"));
                            }
                            Object kelReg = companyDoc.get("keliriRegistration");
                            if (kelReg instanceof Map && ((Map) kelReg).get("companyName") != null) {
                                return String.valueOf(((Map) kelReg).get("companyName"));
                            }
                        }
                        return name;
                    });

            // Resolve Address (Remove hardcoded "Admin Virtual Terminal")
            final String address = regOpt.map(AdminRegistration::getBusinessAddress)
                    .filter(a -> a != null && !a.isBlank())
                    .orElseGet(() -> {
                        if (companyDoc != null) {
                            if (companyDoc.get("businessAddress") != null) {
                                String addr = String.valueOf(companyDoc.get("businessAddress"));
                                if (!addr.isBlank() && !"Admin Virtual Terminal".equals(addr)) {
                                    return addr;
                                }
                            }
                            Object kelReg = companyDoc.get("keliriRegistration");
                            if (kelReg instanceof Map && ((Map) kelReg).get("businessAddress") != null) {
                                String addr = String.valueOf(((Map) kelReg).get("businessAddress"));
                                if (!addr.isBlank() && !"Admin Virtual Terminal".equals(addr)) {
                                    return addr;
                                }
                            }
                        }
                        return "";
                    });

            // Resolve Mobile
            final String mobile = regOpt.map(AdminRegistration::getMobileNumber)
                    .or(() -> userOpt.map(users::getPhoneNumber).map(phoneNumber::getDialNumber))
                    .filter(m -> m != null && !m.isBlank())
                    .orElseGet(() -> {
                        if (companyDoc != null) {
                            if (companyDoc.get("mobileNumber") != null) {
                                return String.valueOf(companyDoc.get("mobileNumber"));
                            }
                            if (companyDoc.get("phone") != null) {
                                return String.valueOf(companyDoc.get("phone"));
                            }
                            Object kelReg = companyDoc.get("keliriRegistration");
                            if (kelReg instanceof Map && ((Map) kelReg).get("mobileNumber") != null) {
                                return String.valueOf(((Map) kelReg).get("mobileNumber"));
                            }
                        }
                        return "Not available";
                    });

            profile.put("name", name);
            profile.put("email", email);
            profile.put("companyName", companyName);
            profile.put("businessAddress", address);
            profile.put("mobileNumber", mobile);

            // Add alias keys so frontend or localStorage never misses any properties
            profile.put("company", companyName);
            profile.put("address", address);
            profile.put("phone", mobile);
            profile.put("mobile", mobile);

            return ResponseEntity.ok(Map.of("success", true, "data", profile));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Internal server error"));
        }
    }

    private String extractAdminId(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer "))
            return null;
        try {
            Claims claims = jwtService.parseToken(authHeader.substring(7));
            // Checks all common claim keys to ensure ID is properly extracted
            String id = claims.get("userId", String.class);
            if (id == null)
                id = claims.get("adminId", String.class);
            if (id == null)
                id = claims.get("id", String.class);
            if (id == null)
                id = claims.get("sub", String.class);
            if (id == null)
                id = claims.getSubject();
            return id;
        } catch (Exception e) {
            return null;
        }
    }
}