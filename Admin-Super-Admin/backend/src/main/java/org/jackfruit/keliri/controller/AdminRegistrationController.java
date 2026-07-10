// package org.jackfruit.keliri.controller;

// import org.jackfruit.keliri.model.AdminRegistration;
// import org.jackfruit.keliri.model.users;
// import org.jackfruit.keliri.model.phoneNumber;
// import org.jackfruit.keliri.repository.AdminRegistrationRepository;
// import org.jackfruit.keliri.repository.usersRepository;
// import org.jackfruit.keliri.service.FileStorageService;
// import org.jackfruit.keliri.service.MobilizeApiService;
// import org.springframework.http.HttpStatus;
// import org.springframework.http.ResponseEntity;
// import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
// import org.springframework.web.bind.annotation.*;
// import org.springframework.web.multipart.MultipartFile;
// import org.springframework.web.server.ResponseStatusException;

// import java.time.Instant;
// import java.util.List;
// import java.util.Map;

// @CrossOrigin(originPatterns = "*", maxAge = 3600, allowCredentials = "true")
// @RestController
// @RequestMapping("/api/admin")
// public class AdminRegistrationController {

//     private final AdminRegistrationRepository registrationRepository;
//     private final FileStorageService fileStorageService;
//     private final usersRepository usersRepository;
//     private final MobilizeApiService mobilizeApiService;
//     private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

//     public AdminRegistrationController(AdminRegistrationRepository registrationRepository,
//             FileStorageService fileStorageService,
//             usersRepository usersRepository,
//             MobilizeApiService mobilizeApiService) {
//         this.registrationRepository = registrationRepository;
//         this.fileStorageService = fileStorageService;
//         this.usersRepository = usersRepository;
//         this.mobilizeApiService = mobilizeApiService;
//     }

//     @PostMapping(value = "/register", consumes = "multipart/form-data")
//     public ResponseEntity<?> register(
//             @RequestParam(value = "companyName", required = false) String companyName,
//             @RequestParam(value = "companyType", required = false) String companyType,
//             @RequestParam(value = "authorizedPerson", required = false) String authorizedPerson,
//             @RequestParam(value = "businessAddress", required = false) String businessAddress,
//             @RequestParam(value = "addressLine2", required = false) String addressLine2,
//             @RequestParam(value = "city", required = false) String city,
//             @RequestParam(value = "state", required = false) String state,
//             @RequestParam(value = "zipCode", required = false) String zipCode,
//             @RequestParam(value = "country", required = false) String country,
//             @RequestParam(value = "gstNumber", required = false) String gstNumber,
//             @RequestParam(value = "mobileNumber", required = false) String mobileNumber,
//             @RequestParam(value = "countryCode", required = false) String countryCode,
//             @RequestParam(value = "emailId", required = false) String emailId,
//             @RequestParam(value = "password", required = false) String password,
//             @RequestParam(value = "companyId", required = false) String companyId,
//             @RequestParam(value = "superAdminCreate", required = false, defaultValue = "false") boolean superAdminCreate,
//             @RequestParam(value = "gstCertificate", required = false) MultipartFile gstCertificate,
//             @RequestParam(value = "companyRegistrationDoc", required = false) MultipartFile companyRegistrationDoc,
//             @RequestParam(value = "idProof", required = false) MultipartFile idProof) {
//         try {
//             // Mobilize-only: upload docs to S3, then store full payload in Mobilize
//             // "companies"
//             String cleanEmail = emailId != null && !emailId.isBlank() ? emailId : "temp_" + Instant.now().toEpochMilli() + "@example.com";
//             String idSuffix = cleanEmail.replaceAll("[^a-zA-Z0-9]", "_");

//             String gstUrl = "";
//             if (gstCertificate != null && !gstCertificate.isEmpty()) {
//                 gstUrl = fileStorageService.uploadFile(gstCertificate, idSuffix + "/gst");
//             }
//             String companyDocUrl = "";
//             if (companyRegistrationDoc != null && !companyRegistrationDoc.isEmpty()) {
//                 companyDocUrl = fileStorageService.uploadFile(companyRegistrationDoc, idSuffix + "/company");
//             }
//             String idProofUrl = "";
//             if (idProof != null && !idProof.isEmpty()) {
//                 idProofUrl = fileStorageService.uploadFile(idProof, idSuffix + "/id");
//             }

//             Map<String, Object> mobilizePayload = new java.util.LinkedHashMap<>();
//             if (companyId != null && !companyId.isBlank()) {
//                 mobilizePayload.put("companyId", companyId);
//             }
//             mobilizePayload.put("companyName", companyName != null ? companyName : "");
//             mobilizePayload.put("companyType", companyType != null ? companyType : "PRODUCTS_SERVICES");
//             mobilizePayload.put("authorizedPerson", authorizedPerson != null ? authorizedPerson : "");
//             mobilizePayload.put("businessAddress", businessAddress != null ? businessAddress : "");
//             mobilizePayload.put("addressLine2", addressLine2 != null ? addressLine2 : "");
//             mobilizePayload.put("city", city != null ? city : "");
//             mobilizePayload.put("state", state != null ? state : "");
//             mobilizePayload.put("zipCode", zipCode != null ? zipCode : "");
//             mobilizePayload.put("country", country != null ? country : "India");
//             mobilizePayload.put("gstNumber", gstNumber != null ? gstNumber : "");
//             mobilizePayload.put("countryCode", countryCode != null ? countryCode : "");
//             mobilizePayload.put("mobileNumber", mobileNumber != null ? mobileNumber : "");
//             mobilizePayload.put("email", cleanEmail);
//             mobilizePayload.put("emailId", cleanEmail);
//             // Store hashed password only (do NOT store plaintext)
//             String encodedPassword = password != null && !password.isEmpty() ? passwordEncoder.encode(password) : "";
//             mobilizePayload.put("passwordHash", encodedPassword);
//             mobilizePayload.put("gstCertificateUrl", gstUrl);
//             mobilizePayload.put("companyRegistrationDocUrl", companyDocUrl);
//             mobilizePayload.put("idProofUrl", idProofUrl);
//             mobilizePayload.put("submittedAt", Instant.now().toString());
//             mobilizePayload.put("source", "KELIRI_ADMIN_PORTAL");
//             // Flag: Super Admin is directly creating this account (no approval step needed)
//             if (superAdminCreate) {
//                 mobilizePayload.put("superAdminCreate", true);
//             }

//             String mobilizeId = mobilizeApiService.upsertKeliriAdminRegistrationCompany(mobilizePayload);
//             if (mobilizeId == null) {
//                 return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                         .body(Map.of("success", false, "message", "Failed to save registration in Mobilize database"));
//             }

//             // Also save locally for Super Admin visibility
//             AdminRegistration localReg = new AdminRegistration();
//             localReg.setId(mobilizeId);
//             localReg.setCompanyName(companyName != null ? companyName : "");
//             localReg.setAuthorizedPerson(authorizedPerson != null ? authorizedPerson : "");
//             localReg.setBusinessAddress(businessAddress != null ? businessAddress : "");
//             localReg.setGstNumber(gstNumber != null ? gstNumber : "");
//             localReg.setMobileNumber(mobileNumber != null ? mobileNumber : "");
//             localReg.setEmailId(cleanEmail);
//             localReg.setPassword(encodedPassword);
//             localReg.setGstCertificateUrl(gstUrl);
//             localReg.setCompanyRegistrationDocUrl(companyDocUrl);
//             localReg.setIdProofUrl(idProofUrl);
//             localReg.setSubmittedAt(Instant.now());

//             if (superAdminCreate) {
//                 // Super Admin directly created this account — mark as approved immediately
//                 localReg.setStatus("APPROVED");
//                 localReg.setProcessedAt(Instant.now());

//                 // Auto-create an ACTIVE user so the admin can login right away
//                 users newUser = usersRepository.findByEmailAddress(cleanEmail).orElseGet(users::new);
//                 newUser.setId(mobilizeId);
//                 newUser.setFullName(authorizedPerson != null && !authorizedPerson.isBlank() ? authorizedPerson
//                         : (companyName != null ? companyName : "Admin"));
//                 newUser.setEmailAddress(cleanEmail);
//                 newUser.setPassword(encodedPassword);
//                 newUser.setCompanyName(companyName != null ? companyName : "");
//                 newUser.setUserType("ADMIN");
//                 newUser.setAccountStatus("ACTIVE");
//                 newUser.setGivendor(1);
//                 newUser.setLatitude(0);
//                 newUser.setLongitude(0);
//                 if (mobileNumber != null && !mobileNumber.isBlank()) {
//                     phoneNumber phone = new phoneNumber();
//                     phone.setCountryCode(countryCode != null && !countryCode.isBlank() ? countryCode : "+91");
//                     phone.setDialNumber(mobileNumber);
//                     newUser.setPhoneNumber(phone);
//                 }
//                 usersRepository.save(newUser);
//                 System.out.println("[AdminRegistrationController] Auto-activated admin user: " + cleanEmail);
//             } else {
//                 localReg.setStatus("PENDING");
//             }

//             registrationRepository.save(localReg);

//             return ResponseEntity.ok(Map.of(
//                     "success", true,
//                     "message", "Registration submitted successfully. Awaiting approval.",
//                     "companyId", mobilizeId));
//         } catch (software.amazon.awssdk.services.s3.model.S3Exception e) {
//             System.err.println("[AdminRegistrationController] S3 Error: " + e.awsErrorDetails().errorMessage());
//             e.printStackTrace();
//             return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                     .body(Map.of("message", "AWS S3 Error: " + e.awsErrorDetails().errorMessage()));
//         } catch (Exception e) {
//             System.err.println("[AdminRegistrationController] General Error: " + e.getMessage());
//             e.printStackTrace();
//             return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                     .body(Map.of("message", "Error submitting registration: " + e.getMessage()));
//         }
//     }

//     @GetMapping("/status")
//     public ResponseEntity<?> getStatus(@RequestParam("email") String email) {
//         // 1) Preferred: local registration record (created via /api/admin/register)
//         var regOpt = registrationRepository.findByEmailId(email);
//         if (regOpt.isPresent()) {
//             AdminRegistration reg = regOpt.get();
//             return ResponseEntity.ok(Map.of(
//                     "success", true,
//                     "status", reg.getStatus(),
//                     "companyName", reg.getCompanyName(),
//                     "submittedAt", reg.getSubmittedAt(),
//                     "rejectionReason", reg.getRejectionReason() != null ? reg.getRejectionReason() : ""));
//         }

//         // 2) If already approved and promoted to an active local admin user, return
//         // success too.
//         var userOpt = usersRepository.findByEmailAddress(email);
//         if (userOpt.isPresent()) {
//             var user = userOpt.get();
//             // For this screen, "approved" means an admin account exists.
//             return ResponseEntity.ok(Map.of(
//                     "success", true,
//                     "status", "APPROVED",
//                     "companyName", user.getCompanyName() != null ? user.getCompanyName() : "",
//                     "submittedAt", Instant.now(),
//                     "rejectionReason", ""));
//         }

//         // 3) Fallback: check Mobilize companies (unified DB). Mobilize uses boolean
//         // `status`.
//         List<Map> companies = mobilizeApiService.fetchAllCompaniesDirectly();
//         Map<?, ?> company = companies.stream()
//                 .filter(c -> c != null && email.equalsIgnoreCase(String.valueOf(((Map) c).get("email"))))
//                 .map(c -> (Map<?, ?>) c)
//                 .findFirst()
//                 .orElse(null);

//         if (company != null) {
//             String companyName = String.valueOf(company.get("name"));
//             return ResponseEntity.ok(Map.of(
//                     "success", true,
//                     "status", "PENDING",
//                     "companyName", companyName != null && !"null".equals(companyName) ? companyName : "",
//                     "submittedAt", Instant.now(),
//                     "rejectionReason", ""));
//         }

//         throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No registration found for this email");
//     }

//     /**
//      * Returns the S3 document URLs for a given registration (by ID).
//      * Used by Super Admin to preview/download submitted documents.
//      */
//     @GetMapping("/{id}/documents")
//     public ResponseEntity<?> getDocuments(@PathVariable String id) {
//         return registrationRepository.findById(id)
//                 .map(reg -> {
//                     java.util.Map<String, Object> docs = new java.util.LinkedHashMap<>();
//                     docs.put("registrationId", reg.getId());
//                     docs.put("companyName", reg.getCompanyName());
//                     docs.put("emailId", reg.getEmailId());
//                     docs.put("gstCertificateUrl", reg.getGstCertificateUrl() != null ? reg.getGstCertificateUrl() : "");
//                     docs.put("companyRegistrationDocUrl",
//                             reg.getCompanyRegistrationDocUrl() != null ? reg.getCompanyRegistrationDocUrl() : "");
//                     docs.put("idProofUrl", reg.getIdProofUrl() != null ? reg.getIdProofUrl() : "");
//                     return ResponseEntity.ok(docs);
//                 })
//                 .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Registration not found"));
//     }
// }
package org.jackfruit.keliri.controller;

import org.jackfruit.keliri.model.AdminRegistration;
import org.jackfruit.keliri.model.users;
import org.jackfruit.keliri.model.phoneNumber;
import org.jackfruit.keliri.repository.AdminRegistrationRepository;
import org.jackfruit.keliri.repository.usersRepository;
import org.jackfruit.keliri.service.FileStorageService;
import org.jackfruit.keliri.service.MobilizeApiService;
import org.jackfruit.keliri.service.EmailService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.List;
import java.util.Map;

@CrossOrigin(originPatterns = "*", maxAge = 3600, allowCredentials = "true")
@RestController
@RequestMapping("/api/admin")
public class AdminRegistrationController {

    private final AdminRegistrationRepository registrationRepository;
    private final FileStorageService fileStorageService;
    private final usersRepository usersRepository;
    private final MobilizeApiService mobilizeApiService;
    private final EmailService emailService;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public AdminRegistrationController(AdminRegistrationRepository registrationRepository,
            FileStorageService fileStorageService,
            usersRepository usersRepository,
            MobilizeApiService mobilizeApiService,
            EmailService emailService) {
        this.registrationRepository = registrationRepository;
        this.fileStorageService = fileStorageService;
        this.usersRepository = usersRepository;
        this.mobilizeApiService = mobilizeApiService;
        this.emailService = emailService;
    }

    @PostMapping(value = "/register", consumes = "multipart/form-data")
    public ResponseEntity<?> register(
            @RequestParam(value = "companyName", required = false) String companyName,
            @RequestParam(value = "companyType", required = false) String companyType,
            @RequestParam(value = "authorizedPerson", required = false) String authorizedPerson,
            @RequestParam(value = "businessAddress", required = false) String businessAddress,
            @RequestParam(value = "latitude", required = false) Double latitude,
@RequestParam(value = "longitude", required = false) Double longitude,
            @RequestParam(value = "addressLine2", required = false) String addressLine2,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "state", required = false) String state,
            @RequestParam(value = "zipCode", required = false) String zipCode,
            @RequestParam(value = "country", required = false) String country,
            @RequestParam(value = "gstNumber", required = false) String gstNumber,
            @RequestParam(value = "mobileNumber", required = false) String mobileNumber,
            @RequestParam(value = "countryCode", required = false) String countryCode,
            @RequestParam(value = "emailId", required = false) String emailId,
            @RequestParam(value = "password", required = false) String password,
            @RequestParam(value = "companyId", required = false) String companyId,
            @RequestParam(value = "superAdminCreate", required = false, defaultValue = "false") boolean superAdminCreate,
            @RequestParam(value = "gstCertificate", required = false) MultipartFile gstCertificate,
            @RequestParam(value = "companyRegistrationDoc", required = false) MultipartFile companyRegistrationDoc,
            @RequestParam(value = "idProof", required = false) MultipartFile idProof) {
        try {
            // Mobilize-only: upload docs to S3, then store full payload in Mobilize
            // "companies"
            String cleanEmail = emailId != null && !emailId.isBlank() ? emailId : "temp_" + Instant.now().toEpochMilli() + "@example.com";
            String idSuffix = cleanEmail.replaceAll("[^a-zA-Z0-9]", "_");

            String gstUrl = "";
            if (gstCertificate != null && !gstCertificate.isEmpty()) {
                gstUrl = fileStorageService.uploadFile(gstCertificate, idSuffix + "/gst");
            }
            String companyDocUrl = "";
            if (companyRegistrationDoc != null && !companyRegistrationDoc.isEmpty()) {
                companyDocUrl = fileStorageService.uploadFile(companyRegistrationDoc, idSuffix + "/company");
            }
            String idProofUrl = "";
            if (idProof != null && !idProof.isEmpty()) {
                idProofUrl = fileStorageService.uploadFile(idProof, idSuffix + "/id");
            }

            Map<String, Object> mobilizePayload = new java.util.LinkedHashMap<>();
            if (companyId != null && !companyId.isBlank()) {
                mobilizePayload.put("companyId", companyId);
            }
            mobilizePayload.put("companyName", companyName != null ? companyName : "");
            mobilizePayload.put("companyType", companyType != null ? companyType : "PRODUCTS_SERVICES");
            mobilizePayload.put("authorizedPerson", authorizedPerson != null ? authorizedPerson : "");
            mobilizePayload.put("businessAddress", businessAddress != null ? businessAddress : "");
            mobilizePayload.put("latitude", latitude);
mobilizePayload.put("longitude", longitude);
            mobilizePayload.put("addressLine2", addressLine2 != null ? addressLine2 : "");
            mobilizePayload.put("city", city != null ? city : "");
            mobilizePayload.put("state", state != null ? state : "");
            mobilizePayload.put("zipCode", zipCode != null ? zipCode : "");
            mobilizePayload.put("country", country != null ? country : "India");
            mobilizePayload.put("gstNumber", gstNumber != null ? gstNumber : "");
            mobilizePayload.put("countryCode", countryCode != null ? countryCode : "");
            mobilizePayload.put("mobileNumber", mobileNumber != null ? mobileNumber : "");
            mobilizePayload.put("email", cleanEmail);
            mobilizePayload.put("emailId", cleanEmail);
            // Store hashed password only (do NOT store plaintext)
            String encodedPassword = password != null && !password.isEmpty() ? passwordEncoder.encode(password) : "";
            mobilizePayload.put("passwordHash", encodedPassword);
            mobilizePayload.put("gstCertificateUrl", gstUrl);
            mobilizePayload.put("companyRegistrationDocUrl", companyDocUrl);
            mobilizePayload.put("idProofUrl", idProofUrl);
            mobilizePayload.put("submittedAt", Instant.now().toString());
            mobilizePayload.put("source", "KELIRI_ADMIN_PORTAL");
            // Flag: Super Admin is directly creating this account (no approval step needed)
            if (superAdminCreate) {
                mobilizePayload.put("superAdminCreate", true);
            }

            String mobilizeId = mobilizeApiService.upsertKeliriAdminRegistrationCompany(mobilizePayload);
            if (mobilizeId == null) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(Map.of("success", false, "message", "Failed to save registration in Mobilize database"));
            }

            // Also save locally for Super Admin visibility
            AdminRegistration localReg = new AdminRegistration();
            localReg.setId(mobilizeId);
            localReg.setCompanyName(companyName != null ? companyName : "");
            localReg.setAuthorizedPerson(authorizedPerson != null ? authorizedPerson : "");
            localReg.setBusinessAddress(businessAddress != null ? businessAddress : "");
            localReg.setLatitude(latitude);
localReg.setLongitude(longitude);
            localReg.setGstNumber(gstNumber != null ? gstNumber : "");
            localReg.setMobileNumber(mobileNumber != null ? mobileNumber : "");
            localReg.setEmailId(cleanEmail);
            localReg.setPassword(encodedPassword);
            localReg.setGstCertificateUrl(gstUrl);
            localReg.setCompanyRegistrationDocUrl(companyDocUrl);
            localReg.setIdProofUrl(idProofUrl);
            localReg.setSubmittedAt(Instant.now());

            if (superAdminCreate) {
                // Super Admin directly created this account — mark as approved immediately
                localReg.setStatus("APPROVED");
                localReg.setProcessedAt(Instant.now());

                // Auto-create an ACTIVE user so the admin can login right away
                users newUser = usersRepository.findByEmailAddress(cleanEmail).orElseGet(users::new);
                newUser.setId(mobilizeId);
                newUser.setFullName(authorizedPerson != null && !authorizedPerson.isBlank() ? authorizedPerson
                        : (companyName != null ? companyName : "Admin"));
                newUser.setEmailAddress(cleanEmail);
                newUser.setPassword(encodedPassword);
                newUser.setCompanyName(companyName != null ? companyName : "");
                newUser.setUserType("ADMIN");
                newUser.setAccountStatus("ACTIVE");
                newUser.setGivendor(1);
                newUser.setLatitude(localReg.getLatitude());
newUser.setLongitude(localReg.getLongitude());
                if (mobileNumber != null && !mobileNumber.isBlank()) {
                    phoneNumber phone = new phoneNumber();
                    phone.setCountryCode(countryCode != null && !countryCode.isBlank() ? countryCode : "+91");
                    phone.setDialNumber(mobileNumber);
                    newUser.setPhoneNumber(phone);
                }
                usersRepository.save(newUser);
                System.out.println("[AdminRegistrationController] Auto-activated admin user: " + cleanEmail);
            } else {
                localReg.setStatus("PENDING");
                try {
                    emailService.sendRegistrationPendingEmail(cleanEmail, authorizedPerson != null && !authorizedPerson.isBlank() ? authorizedPerson : (companyName != null ? companyName : "Admin"));
                } catch (Exception e) {
                    System.err.println("[AdminRegistrationController] Failed to send registration pending email: " + e.getMessage());
                }
            }

            registrationRepository.save(localReg);

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Registration submitted successfully. Awaiting approval.",
                    "companyId", mobilizeId));
        } catch (software.amazon.awssdk.services.s3.model.S3Exception e) {
            System.err.println("[AdminRegistrationController] S3 Error: " + e.awsErrorDetails().errorMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "AWS S3 Error: " + e.awsErrorDetails().errorMessage()));
        } catch (Exception e) {
            System.err.println("[AdminRegistrationController] General Error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Error submitting registration: " + e.getMessage()));
        }
    }

    @GetMapping("/companies")
    public ResponseEntity<?> getCompanies() {
        try {
            List<Map<String, Object>> companies = mobilizeApiService.getAllCompaniesForRegistration();
            return ResponseEntity.ok(Map.of("success", true, "data", companies));
        } catch (Exception e) {
            System.err.println("[AdminRegistrationController] Error listing companies: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Error listing companies: " + e.getMessage()));
        }
    }

    @GetMapping("/status")
    public ResponseEntity<?> getStatus(@RequestParam("email") String email) {
        // 1) Preferred: local registration record (created via /api/admin/register)
        var regOpt = registrationRepository.findByEmailId(email);
        if (regOpt.isPresent()) {
            AdminRegistration reg = regOpt.get();
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "status", reg.getStatus(),
                    "companyName", reg.getCompanyName(),
                    "submittedAt", reg.getSubmittedAt(),
                    "rejectionReason", reg.getRejectionReason() != null ? reg.getRejectionReason() : ""));
        }

        // 2) If already approved and promoted to an active local admin user, return
        // success too.
        var userOpt = usersRepository.findByEmailAddress(email);
        if (userOpt.isPresent()) {
            var user = userOpt.get();
            // For this screen, "approved" means an admin account exists.
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "status", "APPROVED",
                    "companyName", user.getCompanyName() != null ? user.getCompanyName() : "",
                    "submittedAt", Instant.now(),
                    "rejectionReason", ""));
        }

        // 3) Fallback: check Mobilize companies (unified DB). Mobilize uses boolean
        // `status`.
        List<Map> companies = mobilizeApiService.fetchAllCompaniesDirectly();
        Map<?, ?> company = companies.stream()
                .filter(c -> c != null && email.equalsIgnoreCase(String.valueOf(((Map) c).get("email"))))
                .map(c -> (Map<?, ?>) c)
                .findFirst()
                .orElse(null);

        if (company != null) {
            String companyName = String.valueOf(company.get("name"));
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "status", "PENDING",
                    "companyName", companyName != null && !"null".equals(companyName) ? companyName : "",
                    "submittedAt", Instant.now(),
                    "rejectionReason", ""));
        }

        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No registration found for this email");
    }

    /**
     * Returns the S3 document URLs for a given registration (by ID).
     * Used by Super Admin to preview/download submitted documents.
     */
    @GetMapping("/{id}/documents")
    public ResponseEntity<?> getDocuments(@PathVariable String id) {
        return registrationRepository.findById(id)
                .map(reg -> {
                    java.util.Map<String, Object> docs = new java.util.LinkedHashMap<>();
                    docs.put("registrationId", reg.getId());
                    docs.put("companyName", reg.getCompanyName());
                    docs.put("emailId", reg.getEmailId());
                    docs.put("gstCertificateUrl", reg.getGstCertificateUrl() != null ? reg.getGstCertificateUrl() : "");
                    docs.put("companyRegistrationDocUrl",
                            reg.getCompanyRegistrationDocUrl() != null ? reg.getCompanyRegistrationDocUrl() : "");
                    docs.put("idProofUrl", reg.getIdProofUrl() != null ? reg.getIdProofUrl() : "");
                    return ResponseEntity.ok(docs);
                })
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Registration not found"));
    }
}