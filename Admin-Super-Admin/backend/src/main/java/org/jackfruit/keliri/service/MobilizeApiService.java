package org.jackfruit.keliri.service;

import org.springframework.stereotype.Service;
import java.util.*;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.bson.types.ObjectId;

@Service
public class MobilizeApiService {

    private final MongoTemplate mongoTemplate;

    @Autowired
    public MobilizeApiService(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    /**
     * Fetches companies directly from the MongoDB collection.
     */
    /**
     * Finds a single company by uid, _id, or email.
     * This avoids loading the entire companies collection into memory.
     */
    public Map<String, Object> findCompanyByAdminIdOrEmail(String adminId, String email) {
        try {
            List<Criteria> criteriaList = new ArrayList<>();

            if (adminId != null && !adminId.isBlank()) {
                criteriaList.add(Criteria.where("uid").is(adminId));

                if (ObjectId.isValid(adminId)) {
                    criteriaList.add(Criteria.where("_id").is(new ObjectId(adminId)));
                } else {
                    criteriaList.add(Criteria.where("_id").is(adminId));
                }
            }

            if (email != null && !email.isBlank()) {
                criteriaList.add(Criteria.where("email").is(email));
            }

            if (criteriaList.isEmpty()) {
                return null;
            }

            Query query = new Query(
                    new Criteria().orOperator(criteriaList.toArray(new Criteria[0])));

            return mongoTemplate.findOne(query, Map.class, "companies");

        } catch (Exception e) {
            System.err.println("Error finding company: " + e.getMessage());
            return null;
        }
    }

    public List<Map<String, Object>> fetchCompanies(String type, boolean status) {
        try {
            Query query = new Query();
            if (type != null && !type.isBlank()) {
                query.addCriteria(Criteria.where("companyType").is(type));
            }
            query.addCriteria(Criteria.where("status").is(status));

            return (List) mongoTemplate.find(query, Map.class, "companies");
        } catch (Exception e) {
            System.err.println("Error fetching companies directly from Mobilize DB: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Fetches ALL companies directly from the MongoDB collection.
     */
    public List<Map> fetchAllCompaniesDirectly() {
        try {
            return mongoTemplate.findAll(Map.class, "companies");
        } catch (Exception e) {
            System.err.println("Error fetching directly from Mobilize DB: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Fetches all companies from MongoDB and resolves their logo URLs for public
     * registration.
     */
    public List<Map<String, Object>> getAllCompaniesForRegistration() {
        try {
            List<Map> rawCompanies = mongoTemplate.findAll(Map.class, "companies");
            List<Map<String, Object>> formattedCompanies = new ArrayList<>();

            // Step 1: Collect all unique companyLogo ObjectIds
            Set<ObjectId> logoIds = new HashSet<>();
            for (Map raw : rawCompanies) {
                Object logoObj = raw.get("companyLogo");
                if (logoObj != null) {
                    try {
                        ObjectId logoId = null;
                        if (logoObj instanceof ObjectId) {
                            logoId = (ObjectId) logoObj;
                        } else if (logoObj instanceof Map) {
                            Object oid = ((Map) logoObj).get("$oid");
                            if (oid != null) {
                                logoId = new ObjectId(oid.toString());
                            }
                        } else {
                            logoId = new ObjectId(logoObj.toString());
                        }
                        if (logoId != null) {
                            logoIds.add(logoId);
                        }
                    } catch (Exception e) {
                        // ignore malformed IDs
                    }
                }
            }

            // Step 2: Fetch all logos in a single bulk query
            Map<ObjectId, String> logoMap = new HashMap<>();
            if (!logoIds.isEmpty()) {
                Query mediaQuery = new Query(Criteria.where("_id").in(logoIds));
                List<Map> rawMedias = mongoTemplate.find(mediaQuery, Map.class, "medias");
                for (Map media : rawMedias) {
                    Object idObj = media.get("_id");
                    if (idObj instanceof ObjectId) {
                        logoMap.put((ObjectId) idObj, (String) media.get("s3Location"));
                    }
                }
            }

            // Step 3: Format the companies using the in-memory map
            for (Map raw : rawCompanies) {
                Map<String, Object> formatted = new LinkedHashMap<>();

                Object idObj = raw.get("_id");
                String idStr = idObj != null ? idObj.toString() : "";
                formatted.put("_id", idStr);
                formatted.put("name", raw.getOrDefault("name", ""));
                formatted.put("companyType", raw.getOrDefault("companyType", ""));

                String logoUrl = null;
                Object logoObj = raw.get("companyLogo");
                if (logoObj != null) {
                    try {
                        ObjectId logoId = null;
                        if (logoObj instanceof ObjectId) {
                            logoId = (ObjectId) logoObj;
                        } else if (logoObj instanceof Map) {
                            Object oid = ((Map) logoObj).get("$oid");
                            if (oid != null) {
                                logoId = new ObjectId(oid.toString());
                            }
                        } else {
                            logoId = new ObjectId(logoObj.toString());
                        }

                        if (logoId != null) {
                            logoUrl = logoMap.get(logoId);
                        }
                    } catch (Exception e) {
                        // ignore/log
                    }
                }
                formatted.put("companyLogo", logoUrl);
                formattedCompanies.add(formatted);
            }
            return formattedCompanies;
        } catch (Exception e) {
            System.err.println("Error in getAllCompaniesForRegistration: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Creates/updates a Mobilize "companies" record with Keliri admin registration
     * details.
     */
    public String upsertKeliriAdminRegistrationCompany(Map<String, Object> payload) {
        try {
            String email = payload.get("email") != null ? String.valueOf(payload.get("email")) : null;
            String companyId = payload.get("companyId") != null ? String.valueOf(payload.get("companyId")) : null;

            if (email == null || email.isBlank()) {
                throw new IllegalArgumentException("email is required");
            }

            Map existing = null;
            if (companyId != null && !companyId.isBlank()) {
                try {
                    Query qId = new Query(Criteria.where("_id").is(new ObjectId(companyId)));
                    existing = mongoTemplate.findOne(qId, Map.class, "companies");
                } catch (Exception e) {
                    System.err.println("Invalid companyId format: " + companyId);
                }
            }

            if (existing == null) {
                Query qEmail = new Query(Criteria.where("email").is(email));
                existing = mongoTemplate.findOne(qEmail, Map.class, "companies");
            }

            if (existing == null) {
                Map<String, Object> doc = new LinkedHashMap<>();
                doc.put("name", payload.getOrDefault("companyName", ""));
                doc.put("email", email);
                boolean isActiveCreate = Boolean.TRUE.equals(payload.get("superAdminCreate"));
                doc.put("status", isActiveCreate ? Boolean.TRUE : Boolean.FALSE);
                doc.put("companyType", payload.getOrDefault("companyType", "PRODUCTS_SERVICES"));
                doc.put("createdAt", new Date());
                doc.put("updatedAt", new Date());
                doc.put("keliriRegistration", payload);

                Map saved = mongoTemplate.insert(doc, "companies");
                Object id = saved.get("_id");
                return id != null ? String.valueOf(id) : null;
            }

            existing.put("updatedAt", new Date());
            existing.put("name", payload.getOrDefault("companyName", existing.getOrDefault("name", "")));
            existing.put("companyType",
                    payload.getOrDefault("companyType", existing.getOrDefault("companyType", "PRODUCTS_SERVICES")));
            existing.put("keliriRegistration", payload);
            if (Boolean.TRUE.equals(payload.get("superAdminCreate"))) {
                existing.put("status", Boolean.TRUE);
            }

            mongoTemplate.save(existing, "companies");
            Object id = existing.get("_id");
            return id != null ? String.valueOf(id) : null;
        } catch (Exception e) {
            System.err.println("Error upserting Keliri registration into Mobilize companies: " + e.getMessage());
            return null;
        }
    }

    /**
     * Approves a company by setting its status to true
     */
    public boolean approveCompany(String uid) {
        return updateCompanyStatus(uid, true);
    }

    /**
     * Updates company status in Mobilize DB (true=active, false=inactive).
     */
    public boolean updateCompanyStatus(String uid, boolean status) {
        try {
            Query query;
            if (ObjectId.isValid(uid)) {
                query = new Query(Criteria.where("_id").is(new ObjectId(uid)));
            } else {
                query = new Query(Criteria.where("uid").is(uid));
            }

            Map existing = mongoTemplate.findOne(query, Map.class, "companies");
            if (existing == null) {
                return false;
            }

            existing.put("status", status);
            existing.put("updatedAt", new Date());
            mongoTemplate.save(existing, "companies");
            return true;
        } catch (Exception e) {
            System.err.println("Error updating company status: " + e.getMessage());
            return false;
        }
    }

    /**
     * Fetches advertisements directly from Mobilize DB with company-specific
     * filtering
     */
    public List<Map<String, Object>> fetchAdvertisements(String companyUID, int page, int limit) {
        try {
            Query query = new Query();
            if (companyUID != null && !companyUID.isBlank()) {
                if (ObjectId.isValid(companyUID)) {
                    query.addCriteria(Criteria.where("company").is(new ObjectId(companyUID)));
                } else {
                    query.addCriteria(Criteria.where("company").is(companyUID));
                }
            }
            // Add pagination
            query.skip((long) (page - 1) * limit);
            query.limit(limit);

            return (List) mongoTemplate.find(query, Map.class, "advertisements");
        } catch (Exception e) {
            System.err.println("Error fetching advertisements directly from Mobilize DB: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Fetches dashboard counts directly from MongoDB
     */
    public Map<String, Object> fetchDashboardCounts(String companyUID) {
        try {
            long usersCount = mongoTemplate.count(new Query(), "users");
            long companiesCount = mongoTemplate.count(new Query(), "companies");

            Query adsQuery = new Query();
            if (companyUID != null && !companyUID.isBlank()) {
                if (ObjectId.isValid(companyUID)) {
                    adsQuery.addCriteria(Criteria.where("company").is(new ObjectId(companyUID)));
                } else {
                    adsQuery.addCriteria(Criteria.where("company").is(companyUID));
                }
            }
            long adsCount = mongoTemplate.count(adsQuery, "advertisements");

            long campaignsCount = mongoTemplate.count(new Query(), "campaigns"); // Or 'ad_campaigns' depending on
                                                                                 // actual collection name

            Map<String, Object> counts = new HashMap<>();
            counts.put("users", usersCount);
            counts.put("companies", companiesCount);
            counts.put("advertisements", adsCount);
            counts.put("campaigns", campaignsCount);
            return counts;
        } catch (Exception e) {
            System.err.println("Error fetching dashboard counts from Mobilize DB: " + e.getMessage());
            return Collections.emptyMap();
        }
    }

    /**
     * Updates company status with direct Mongo update by `_id` / `email`
     */
    public boolean updateCompanyStatusByCompanyDoc(Map<String, Object> company, boolean status) {
        if (company == null) {
            return false;
        }

        try {
            Query query = null;
            Object idObj = company.get("_id");
            if (idObj instanceof ObjectId) {
                query = new Query(Criteria.where("_id").is(idObj));
            } else if (idObj != null) {
                String id = String.valueOf(idObj);
                if (ObjectId.isValid(id)) {
                    query = new Query(Criteria.where("_id").is(new ObjectId(id)));
                }
            }

            if (query == null) {
                Object emailObj = company.get("email");
                if (emailObj != null) {
                    query = new Query(Criteria.where("email").is(String.valueOf(emailObj)));
                }
            }

            if (query == null) {
                Object uidObj = company.get("uid");
                if (uidObj != null) {
                    query = new Query(Criteria.where("uid").is(String.valueOf(uidObj)));
                }
            }

            if (query == null) {
                return false;
            }

            Map existing = mongoTemplate.findOne(query, Map.class, "companies");
            if (existing == null) {
                return false;
            }

            existing.put("status", status);
            existing.put("updatedAt", new Date());
            mongoTemplate.save(existing, "companies");
            return true;
        } catch (Exception e) {
            System.err.println("Error updating company status directly in DB: " + e.getMessage());
            return false;
        }
    }
}
