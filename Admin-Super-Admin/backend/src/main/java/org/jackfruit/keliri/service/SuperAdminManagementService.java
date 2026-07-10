package org.jackfruit.keliri.service;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;
import org.bson.types.ObjectId;
import org.jackfruit.keliri.model.PaymentTransaction;
import org.jackfruit.keliri.model.SuperAdminManagementResponse;
import org.jackfruit.keliri.model.ad_campaigns;
import org.jackfruit.keliri.model.advertisements;
import org.jackfruit.keliri.model.txn_user_locations;
import org.jackfruit.keliri.model.users;
import org.jackfruit.keliri.repository.PaymentTransactionRepository;
import org.jackfruit.keliri.repository.ad_campaignsRepository;
import org.jackfruit.keliri.repository.advertisementsRepository;
import org.jackfruit.keliri.repository.hitRecordRepository;
import org.jackfruit.keliri.repository.txn_user_locationsRepository;
import org.jackfruit.keliri.repository.usersRepository;
import org.jackfruit.keliri.repository.PublisherRepository;
import org.springframework.data.mongodb.core.MongoTemplate;
import com.razorpay.Payment;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;
import org.jackfruit.keliri.repository.companiesRepository;
import org.jackfruit.keliri.model.companies;
import org.jackfruit.keliri.model.Publisher;
import java.util.Optional;
import org.jackfruit.keliri.model.AdminRegistration;
import org.jackfruit.keliri.model.AuditLog;
import org.jackfruit.keliri.repository.AuditLogRepository;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Page;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import jakarta.servlet.http.HttpServletRequest;

@Service
public class SuperAdminManagementService {
    private static final ZoneId ZONE_ID = ZoneId.systemDefault();
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ISO_LOCAL_DATE;
    private final usersRepository usersRepository;
    private final ad_campaignsRepository campaignsRepository;
    private final advertisementsRepository advertisementsRepository;
    private final txn_user_locationsRepository locationsRepository;
    private final hitRecordRepository hitRecordRepository;
    private final org.jackfruit.keliri.repository.AdminRegistrationRepository registrationRepository;
    private final org.jackfruit.keliri.repository.SuperAdminRepository superAdminRepository;
    private final PublisherRepository publisherRepository;
    private final companiesRepository companyRepository;
    private final PaymentTransactionRepository paymentTransactionRepository;
    private final RazorpayClient razorpayClient;
    private final MongoTemplate mongoTemplate;
    private final org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder passwordEncoder = new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder();
    private final List<SuperAdminManagementResponse.EmailNotificationRecord> emailNotifications = new CopyOnWriteArrayList<>();
    private final MobilizeApiService mobilizeApiService;
    private final AuditLogRepository auditLogRepository;

    @org.springframework.beans.factory.annotation.Autowired
    private EmailService emailService;

    @org.springframework.beans.factory.annotation.Autowired
    private TokenService tokenService;

    @org.springframework.beans.factory.annotation.Value("${app.admin.portal-url:http://localhost:5173}")
    private String adminPortalUrl;

    public SuperAdminManagementService(
            usersRepository usersRepository,
            ad_campaignsRepository campaignsRepository,
            advertisementsRepository advertisementsRepository,
            txn_user_locationsRepository locationsRepository,
            hitRecordRepository hitRecordRepository,
            org.jackfruit.keliri.repository.AdminRegistrationRepository registrationRepository,
            org.jackfruit.keliri.repository.SuperAdminRepository superAdminRepository,
            PublisherRepository publisherRepository,
            companiesRepository companyRepository,
            PaymentTransactionRepository paymentTransactionRepository,
            RazorpayClient razorpayClient,
            MobilizeApiService mobilizeApiService,
            MongoTemplate mongoTemplate,
            AuditLogRepository auditLogRepository) {
        this.usersRepository = usersRepository;
        this.campaignsRepository = campaignsRepository;
        this.advertisementsRepository = advertisementsRepository;
        this.locationsRepository = locationsRepository;
        this.hitRecordRepository = hitRecordRepository;
        this.registrationRepository = registrationRepository;
        this.superAdminRepository = superAdminRepository;
        this.publisherRepository = publisherRepository;
        this.companyRepository = companyRepository;

        this.paymentTransactionRepository = paymentTransactionRepository;
        this.razorpayClient = razorpayClient;
        this.mobilizeApiService = mobilizeApiService;
        this.mongoTemplate = mongoTemplate;
        this.auditLogRepository = auditLogRepository;
    }

    public List<SuperAdminManagementResponse.AdminRecord> getAdmins(String search, String status) {
        List<SuperAdminManagementResponse.AdminRecord> admins = new ArrayList<>();
        // 1. Get real admins (Active/Suspended) from local DB
        List<SuperAdminManagementResponse.AdminRecord> activeAdmins = usersRepository.findbygivendor().stream()
                .map(this::toAdminRecord)
                .toList();
        admins.addAll(activeAdmins);
        // 2. Get registrations from admin_registrations collection
        List<org.jackfruit.keliri.model.AdminRegistration> regs = registrationRepository.findAll();
        for (org.jackfruit.keliri.model.AdminRegistration reg : regs) {
            if (admins.stream().anyMatch(a -> Objects.equals(a.getEmail(), reg.getEmailId())))
                continue;
            admins.add(toAdminRecordFromReg(reg));
        }
        return admins.stream()
                .filter(admin -> matchesAdminFilters(admin, search, status))
                .sorted(Comparator.comparing(SuperAdminManagementResponse.AdminRecord::getRegisteredDate).reversed())
                .toList();
    }

    public SuperAdminManagementResponse.AdminDetail getAdminDetail(String adminId) {
        long methodStart = System.currentTimeMillis();
        System.out.println("[AdminDetail] getAdminDetail started for id " + adminId);

        long startUsers = System.currentTimeMillis();
        // Try finding in local active users first
        users admin = usersRepository.findbygivendor().stream()
                .filter(user -> Objects.equals(user.getId(), adminId))
                .findFirst()
                .orElse(null);
        System.out.println("[AdminDetail] fetching users took " + (System.currentTimeMillis() - startUsers) + "ms");

        if (admin != null) {
            SuperAdminManagementResponse.AdminDetail detail = new SuperAdminManagementResponse.AdminDetail();
            SuperAdminManagementResponse.AdminRecord base = toAdminRecord(admin);
            copyAdmin(base, detail);

            long startPub = System.currentTimeMillis();
            List<SuperAdminManagementResponse.PublisherRecord> linkedPublishers = getPublishers(adminId, null, null,
                    null);
            System.out.println("[AdminDetail] getPublishers took " + (System.currentTimeMillis() - startPub) + "ms");

            List<SuperAdminManagementResponse.PublisherMini> minis = linkedPublishers.stream().map(publisher -> {
                SuperAdminManagementResponse.PublisherMini mini = new SuperAdminManagementResponse.PublisherMini();
                mini.setId(publisher.getId());
                mini.setName(publisher.getName());
                Object status = publisher.getStatus();

                String normalizedStatus = Boolean.TRUE.equals(status) ||
                        "ACTIVE".equalsIgnoreCase(String.valueOf(status))
                                ? "Active"
                                : "Inactive";

                mini.setStatus(normalizedStatus);
                mini.setAdsPosted(publisher.getAdsPosted());
                return mini;
            }).toList();
            detail.setPublishers(minis);
            detail.setPerformance(buildPerformance(linkedPublishers));
            // Populate registration for active admins by checking AdminRegistration or
            // Mobilize
            long startReg = System.currentTimeMillis();
            org.jackfruit.keliri.model.AdminRegistration reg = registrationRepository
                    .findByEmailId(admin.getEmailAddress()).orElse(null);
            if (reg == null) {
                reg = registrationRepository.findById(adminId).orElse(null);
            }
            System.out.println("[AdminDetail] findRegistration took " + (System.currentTimeMillis() - startReg) + "ms");

            if (reg != null) {
                SuperAdminManagementResponse.RegistrationInfo info = new SuperAdminManagementResponse.RegistrationInfo();
                info.setAuthorizedPerson(stringOrEmpty(reg.getAuthorizedPerson()));
                info.setBusinessAddress(stringOrEmpty(reg.getBusinessAddress()));
                info.setGstNumber(stringOrEmpty(reg.getGstNumber()));
                info.setMobileNumber(stringOrEmpty(reg.getMobileNumber()));
                info.setSubmittedAt(reg.getSubmittedAt() != null ? reg.getSubmittedAt().toString() : "");
                info.setCompanyType("PRODUCTS_SERVICES"); // Default
                info.setCountry("India"); // Default

                long startMob = System.currentTimeMillis();
                try {
                    Map<String, Object> company = mobilizeApiService.findCompanyByAdminIdOrEmail(
                            adminId,
                            admin.getEmailAddress());
                    System.out.println("[AdminDetail] fetchAllCompaniesDirectly (active) took "
                            + (System.currentTimeMillis() - startMob) + "ms");
                    if (company != null && company.get("keliriRegistration") instanceof Map) {
                        Map regPayload = (Map) company.get("keliriRegistration");
                        info.setCity(stringOrEmpty(regPayload.get("city")));
                        info.setState(stringOrEmpty(regPayload.get("state")));
                        info.setZipCode(stringOrEmpty(regPayload.get("zipCode")));
                        info.setAddressLine2(stringOrEmpty(regPayload.get("addressLine2")));
                    }
                } catch (Exception e) {
                    System.err.println("Failed to fetch mobilize details for active admin: " + e.getMessage());
                }

                detail.setRegistration(info);
                List<SuperAdminManagementResponse.DocumentItem> docs = new ArrayList<>();
                if (reg.getGstCertificateUrl() != null && !reg.getGstCertificateUrl().isBlank()) {
                    docs.add(newDocument("GST Certificate", "GST", reg.getGstCertificateUrl()));
                }
                if (reg.getCompanyRegistrationDocUrl() != null && !reg.getCompanyRegistrationDocUrl().isBlank()) {
                    docs.add(newDocument("Company Registration Document", "Company",
                            reg.getCompanyRegistrationDocUrl()));
                }
                if (reg.getIdProofUrl() != null && !reg.getIdProofUrl().isBlank()) {
                    docs.add(newDocument("ID Proof", "ID", reg.getIdProofUrl()));
                }
                detail.setDocuments(docs);
            } else {
                // Fallback to Mobilize DB
                long startMobFallback = System.currentTimeMillis();
                try {
                    Map<String, Object> company = (Map<String, Object>) (Map) mobilizeApiService
                            .fetchAllCompaniesDirectly()
                            .stream()
                            .filter(c -> Objects.equals(String.valueOf(c.get("uid")), adminId)
                                    || Objects.equals(String.valueOf(c.get("_id")), adminId))
                            .findFirst()
                            .orElse(null);
                    System.out.println("[AdminDetail] fetchAllCompaniesDirectly (fallback) took "
                            + (System.currentTimeMillis() - startMobFallback) + "ms");

                    if (company != null) {
                        List<SuperAdminManagementResponse.DocumentItem> docs = new ArrayList<>();
                        if (company.get("companyLogo") != null) {
                            docs.add(newDocument("Company Logo", "Logo", company.get("companyLogo").toString()));
                        }

                        if (company.get("keliriRegistration") instanceof Map) {
                            Map regPayload = (Map) company.get("keliriRegistration");
                            SuperAdminManagementResponse.RegistrationInfo info = new SuperAdminManagementResponse.RegistrationInfo();
                            info.setAuthorizedPerson(stringOrEmpty(regPayload.get("authorizedPerson")));
                            info.setBusinessAddress(stringOrEmpty(regPayload.get("businessAddress")));
                            info.setAddressLine2(stringOrEmpty(regPayload.get("addressLine2")));
                            info.setCity(stringOrEmpty(regPayload.get("city")));
                            info.setState(stringOrEmpty(regPayload.get("state")));
                            info.setZipCode(stringOrEmpty(regPayload.get("zipCode")));
                            info.setCountry(stringOrEmpty(regPayload.get("country")));
                            info.setGstNumber(stringOrEmpty(regPayload.get("gstNumber")));
                            info.setCompanyType(stringOrEmpty(regPayload.get("companyType")));
                            info.setCountryCode(stringOrEmpty(regPayload.get("countryCode")));
                            info.setMobileNumber(stringOrEmpty(regPayload.get("mobileNumber")));
                            info.setSubmittedAt(stringOrEmpty(regPayload.get("submittedAt")));
                            detail.setRegistration(info);

                            Object gstUrl = regPayload.get("gstCertificateUrl");
                            Object companyDocUrl = regPayload.get("companyRegistrationDocUrl");
                            Object idProofUrl = regPayload.get("idProofUrl");

                            if (gstUrl != null && !String.valueOf(gstUrl).isBlank())
                                docs.add(newDocument("GST Certificate", "GST", String.valueOf(gstUrl)));
                            if (companyDocUrl != null && !String.valueOf(companyDocUrl).isBlank())
                                docs.add(newDocument("Company Registration Document", "Company",
                                        String.valueOf(companyDocUrl)));
                            if (idProofUrl != null && !String.valueOf(idProofUrl).isBlank())
                                docs.add(newDocument("ID Proof", "ID", String.valueOf(idProofUrl)));
                        }
                        detail.setDocuments(docs);
                    } else {
                        detail.setDocuments(buildDocuments(adminId));
                    }
                } catch (Exception e) {
                    detail.setDocuments(buildDocuments(adminId));
                }
                // Just keep local logic

            }
            System.out.println("[AdminDetail] getAdminDetail (active path) total took "
                    + (System.currentTimeMillis() - methodStart) + "ms");
            return detail;
        }
        // Try finding in Admin Registrations
        org.jackfruit.keliri.model.AdminRegistration reg = registrationRepository.findById(adminId).orElse(null);
        System.out.println("ADMIN ID = " + adminId);

        if (reg != null) {
            System.out.println("REG LAT = " + reg.getLatitude());
            System.out.println("REG LNG = " + reg.getLongitude());
        }
        if (reg != null) {
            SuperAdminManagementResponse.AdminDetail detail = new SuperAdminManagementResponse.AdminDetail();
            SuperAdminManagementResponse.AdminRecord base = toAdminRecordFromReg(reg);
            copyAdmin(base, detail);
            detail.setPublishers(new ArrayList<>());

            SuperAdminManagementResponse.RegistrationInfo info = new SuperAdminManagementResponse.RegistrationInfo();
            info.setAuthorizedPerson(stringOrEmpty(reg.getAuthorizedPerson()));
            info.setBusinessAddress(stringOrEmpty(reg.getBusinessAddress()));
            info.setGstNumber(stringOrEmpty(reg.getGstNumber()));
            info.setMobileNumber(stringOrEmpty(reg.getMobileNumber()));
            info.setSubmittedAt(reg.getSubmittedAt() != null ? reg.getSubmittedAt().toString() : "");
            info.setCompanyType("PRODUCTS_SERVICES"); // Default
            info.setCountry("India"); // Default

            long startMobPending = System.currentTimeMillis();
            try {
                Map<String, Object> company = mobilizeApiService.findCompanyByAdminIdOrEmail(adminId, null);
                System.out.println("[AdminDetail] fetchAllCompaniesDirectly (pending) took "
                        + (System.currentTimeMillis() - startMobPending) + "ms");
                if (company != null && company.get("keliriRegistration") instanceof Map) {
                    Map regPayload = (Map) company.get("keliriRegistration");
                    info.setCity(stringOrEmpty(regPayload.get("city")));
                    info.setState(stringOrEmpty(regPayload.get("state")));
                    info.setZipCode(stringOrEmpty(regPayload.get("zipCode")));
                    info.setAddressLine2(stringOrEmpty(regPayload.get("addressLine2")));
                }
            } catch (Exception e) {
                System.err.println("Failed to fetch mobilize details for pending admin: " + e.getMessage());
            }

            detail.setRegistration(info);

            List<SuperAdminManagementResponse.DocumentItem> docs = new ArrayList<>();
            if (reg.getGstCertificateUrl() != null && !reg.getGstCertificateUrl().isBlank()) {
                docs.add(newDocument("GST Certificate", "GST", reg.getGstCertificateUrl()));
            }
            if (reg.getCompanyRegistrationDocUrl() != null && !reg.getCompanyRegistrationDocUrl().isBlank()) {
                docs.add(newDocument("Company Registration Document", "Company",
                        reg.getCompanyRegistrationDocUrl()));
            }
            if (reg.getIdProofUrl() != null && !reg.getIdProofUrl().isBlank()) {
                docs.add(newDocument("ID Proof", "ID", reg.getIdProofUrl()));
            }
            detail.setDocuments(docs);

            detail.setPerformance(new SuperAdminManagementResponse.PerformanceSummary());
            System.out.println("[AdminDetail] getAdminDetail (pending path) total took "
                    + (System.currentTimeMillis() - methodStart) + "ms");
            return detail;
        }
        System.out.println("[AdminDetail] getAdminDetail (not found) total took "
                + (System.currentTimeMillis() - methodStart) + "ms");
        throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                "Admin/Registration not found in Local DB");
    }

    private String stringOrEmpty(Object value) {
        if (value == null)
            return "";
        String s = String.valueOf(value);
        return s == null ? "" : s;
    }

    private String stringOrNull(Object value) {
        if (value == null)
            return null;
        return String.valueOf(value);
    }

    private String firstNonBlank(String... values) {
        if (values == null)
            return null;
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return null;
    }

    public SuperAdminManagementResponse.AdminActionResponse approveAdmin(String adminId) {
        // 1. Try finding in Admin Registrations first
        org.jackfruit.keliri.model.AdminRegistration reg = registrationRepository.findById(adminId).orElse(null);
        if (reg != null) {
            // Create the active admin user in the local system
            org.jackfruit.keliri.model.users newUser = new org.jackfruit.keliri.model.users();
            newUser.setId(reg.getId());
            newUser.setFullName(reg.getAuthorizedPerson());
            newUser.setEmailAddress(reg.getEmailId());
            newUser.setPassword(reg.getPassword()); // Already encrypted
            newUser.setCompanyName(reg.getCompanyName());
            newUser.setUserType("ADMIN");
            newUser.setAccountStatus("ACTIVE");
            newUser.setGivendor(1);
            newUser.setLatitude(reg.getLatitude());
            newUser.setLongitude(reg.getLongitude());
            if (reg.getMobileNumber() != null && !reg.getMobileNumber().isBlank()) {
                org.jackfruit.keliri.model.phoneNumber phone = new org.jackfruit.keliri.model.phoneNumber();
                phone.setCountryCode("+91");
                phone.setDialNumber(reg.getMobileNumber());
                newUser.setPhoneNumber(phone);
            }
            usersRepository.save(newUser);
            // Mark registration as approved
            reg.setStatus("APPROVED");
            reg.setProcessedAt(Instant.now());
            registrationRepository.save(reg);

            // Generate password reset token and send verification approval email
            String resetToken = tokenService.generatePasswordResetToken(reg.getEmailId());
            String resetLink = adminPortalUrl + "/reset-password?token=" + resetToken;
            try {
                emailService.sendAdminApprovedEmail(reg.getEmailId(), reg.getAuthorizedPerson(), resetLink);
            } catch (Exception e) {
                System.err.println("Failed to send admin approved email: " + e.getMessage());
            }
            // We could also delete it, but keeping it as APPROVED is better for auditing.
            // registrationRepository.delete(reg);
            return applyAdminAction(adminId, "Active", null, "Admin registration approved locally",
                    "Your registration has been approved. You can now login as an Admin.", "Approval");
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                "Company registration not found in Local DB");
    }

    public SuperAdminManagementResponse.AdminActionResponse rejectAdmin(String adminId, String reason) {
        if (reason == null || reason.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Reason is mandatory for rejection");
        }
        org.jackfruit.keliri.model.AdminRegistration reg = registrationRepository.findById(adminId).orElse(null);
        if (reg != null) {
            reg.setStatus("REJECTED");
            registrationRepository.save(reg);
            try {
                emailService.sendAdminRejectedEmail(reg.getEmailId(), reg.getAuthorizedPerson(), reason);
            } catch (Exception e) {
                System.err.println("Failed to send rejection email: " + e.getMessage());
            }
        }
        return applyAdminAction(
                adminId,
                "Rejected",
                reason,
                "Admin registration rejected",
                "Rejection notice delivered with reason: " + reason.trim(),
                "Approval");
    }

    public SuperAdminManagementResponse.AdminActionResponse suspendAdmin(String adminId, String reason) {
        // 1) Prefer local DB users (real active admins)
        users user = usersRepository.findById(adminId).orElse(null);
        if (user != null) {
            user.setAccountStatus("SUSPENDED");
            usersRepository.save(user);
            try {
                emailService.sendAdminSuspendedEmail(user.getEmailAddress(), user.getFullName(), reason);
            } catch (Exception e) {
                System.err.println("Failed to send suspension email: " + e.getMessage());
            }
            return applyAdminAction(adminId, "Suspended", reason, "Admin registration suspended",
                    "Suspension notice delivered with reason: "
                            + (reason != null ? reason.trim() : "Compliance review"),
                    "Account");
        }
        // 2) If adminId comes from Mobilize "companies" dataset, suspend via Mobilize
        // API
        org.jackfruit.keliri.model.AdminRegistration reg = registrationRepository.findById(adminId).orElse(null);
        String email = reg != null ? reg.getEmailId() : null;
        Map<String, Object> company = mobilizeApiService.findCompanyByAdminIdOrEmail(
                adminId,
                email);

        if (company != null) {
            boolean success = mobilizeApiService.updateCompanyStatusByCompanyDoc(company, false);
            if (!success) {
                throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                        "Failed to suspend company in Mobilize");
            }
            Object cEmail = company.get("email");
            Object cName = company.get("name");
            if (cEmail != null) {
                try {
                    emailService.sendAdminSuspendedEmail(cEmail.toString(), cName != null ? cName.toString() : "Admin",
                            reason);
                } catch (Exception ignored) {
                }
            }
            return applyAdminAction(adminId, "Suspended", reason, "Admin registration suspended",
                    "Suspension notice delivered with reason: "
                            + (reason != null ? reason.trim() : "Compliance review"),
                    "Account");
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Admin not found");
    }

    public SuperAdminManagementResponse.AdminActionResponse reinstateAdmin(String adminId) {
        // 1) Prefer local DB users (real active admins)
        users user = usersRepository.findById(adminId).orElse(null);
        if (user != null) {
            user.setAccountStatus("ACTIVE");
            usersRepository.save(user);
            try {
                emailService.sendAdminReinstatedEmail(user.getEmailAddress(), user.getFullName());
            } catch (Exception e) {
                System.err.println("Failed to send reinstatement email: " + e.getMessage());
            }
            return applyAdminAction(adminId, "Active", null, null, null, "Account");
        }
        // 2) If adminId comes from Mobilize "companies" dataset, reinstate via Mobilize
        // API
        Map<String, Object> company = (Map<String, Object>) (Map) mobilizeApiService
                .findCompanyByAdminIdOrEmail(adminId, null);

        if (company != null) {
            boolean success = mobilizeApiService.updateCompanyStatusByCompanyDoc(company, true);
            if (!success) {
                throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                        "Failed to reinstate company in Mobilize");
            }
            Object cEmail = company.get("email");
            Object cName = company.get("name");
            if (cEmail != null) {
                try {
                    emailService.sendAdminReinstatedEmail(cEmail.toString(),
                            cName != null ? cName.toString() : "Admin");
                } catch (Exception ignored) {
                }
            }
            return applyAdminAction(adminId, "Active", null, null, null, "Account");
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Admin not found");
    }

    public void deleteAdmin(String adminId) {
        // Try finding in active users
        users user = usersRepository.findById(adminId).orElse(null);
        if (user != null) {
            System.out.println("Deleting Admin User: " + user.getEmailAddress() + " (ID: " + adminId + ")");
            usersRepository.delete(user);
            // Also cleanup registration if it exists for this email
            registrationRepository.findByEmailId(user.getEmailAddress()).ifPresent(reg -> {
                System.out.println("Cleaning up registration for: " + user.getEmailAddress());
                registrationRepository.delete(reg);
            });
            addAuditLog("Super Admin", "Super Admin", "Account Deletion", "User", adminId,
                    "Permanently deleted admin account", "192.168.1.20");
            return;
        }
        // Try finding in registrations only
        org.jackfruit.keliri.model.AdminRegistration reg = registrationRepository.findById(adminId)
                .orElseThrow(
                        () -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Admin or Registration not found"));
        System.out.println("Deleting Registration: " + reg.getEmailId() + " (ID: " + adminId + ")");
        registrationRepository.delete(reg);
        addAuditLog("Super Admin", "Super Admin", "Registration Deletion", "Registration", adminId,
                "Permanently deleted pending registration", "192.168.1.20");
    }

    public List<SuperAdminManagementResponse.EmailNotificationRecord> getEmailNotifications() {
        return emailNotifications.stream()
                .sorted(Comparator.comparing(SuperAdminManagementResponse.EmailNotificationRecord::getTimestamp)
                        .reversed())
                .limit(20)
                .toList();
    }

    public List<SuperAdminManagementResponse.PublisherRecord> getPublishers(
            String adminId,
            String status,
            String location,
            String search) {
        List<SuperAdminManagementResponse.AdminRecord> admins = getAdmins(null, null);

        List<companies> companies = companyRepository.findAll();
        System.out.println("Total companies from DB: " + companies.size());
        List<ad_campaigns> campaigns = campaignsRepository.findAll();
        Map<String, List<ad_campaigns>> campaignsByPublisher = campaigns.stream()
                .collect(Collectors.groupingBy(this::resolvePublisherIdForCampaign));
        List<SuperAdminManagementResponse.PublisherRecord> records = new ArrayList<>();
        for (companies company : companies) {
            SuperAdminManagementResponse.AdminRecord assignedAdmin = admins.stream()
                    .filter(a -> a.getId().equals(company.getAdminId()))
                    .findFirst()
                    .orElse(null);
            List<ad_campaigns> publisherCampaigns = campaignsByPublisher.getOrDefault(company.getId(), List.of());
            long adsPosted = publisherCampaigns.size();
            long impressions = adsPosted == 0 ? 0 : adsPosted * 4200L;
            long clicks = impressions == 0 ? 0 : Math.round(impressions * 0.02);
            double engagement = impressions == 0 ? 0 : roundToTwoDecimals((clicks * 100.0) / impressions);
            SuperAdminManagementResponse.PublisherRecord record = new SuperAdminManagementResponse.PublisherRecord();
            record.setId(company.getId());
            record.setName(defaultString(company.getName(), "Publisher"));
            record.setAdminId(company.getAdminId() != null ? company.getAdminId() : "");
            record.setAdminName(assignedAdmin != null ? assignedAdmin.getName() : "Unknown Admin");
            record.setLocation(defaultString(company.getLocation(), "Unknown"));
            if (company.getLocation() != null && company.getLocation().contains(",")) {
                try {
                    String[] coords = company.getLocation().split(",");

                    if (coords.length >= 2) {
                        record.setLatitude(Double.parseDouble(coords[0].trim()));
                        record.setLongitude(Double.parseDouble(coords[1].trim()));
                    }
                } catch (Exception e) {
                    System.out.println("Failed to parse location: " + company.getLocation());
                }
            }
            record.setAdsPosted(adsPosted);
            record.setImpressions(impressions);
            record.setClicks(clicks);
            record.setEngagement(engagement);
            // Use the status derived from the company data if available; otherwise fallback
            // to campaign‑based logic
            if (company.getStatus() != null) {
                record.setStatus(company.getStatus());
            } else {
                record.setStatus(resolvePublisherStatus(publisherCampaigns));
            }
            record.setEmail(defaultString(company.getEmail(), "not-available@keliri.com"));
            record.setPhone(defaultString(company.getMobile(), "N/A"));
            record.setJoinDate(company.getCreatedAt() != null
                    ? company.getCreatedAt().atZone(ZONE_ID).toLocalDate().format(DATE_FORMATTER)
                    : resolveDateFromObjectId(company.getId()));

            records.add(record);
        }
        return records.stream()
                .filter(record -> matchesPublisherFilters(record, adminId, status, location, search))
                .sorted(Comparator.comparing(SuperAdminManagementResponse.PublisherRecord::getJoinDate).reversed())
                .toList();
    }

    public SuperAdminManagementResponse.PublisherDetail getPublisherDetail(String publisherId) {
        SuperAdminManagementResponse.PublisherRecord base = getPublishers(null, null, null, null).stream()
                .filter(record -> record.getId().equals(publisherId))
                .findFirst()
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Publisher not found"));
        List<ad_campaigns> campaigns = campaignsRepository.findAll().stream()
                .filter(campaign -> resolvePublisherIdForCampaign(campaign).equals(publisherId))
                .toList();
        Map<String, advertisements> adsById = advertisementsRepository.findDashboardAdsByIds(
                campaigns.stream().map(ad_campaigns::getAdvertisementId).filter(Objects::nonNull).distinct().toList())
                .stream().collect(Collectors.toMap(advertisements::getId, ad -> ad));
        SuperAdminManagementResponse.PublisherDetail detail = new SuperAdminManagementResponse.PublisherDetail();
        copyPublisher(base, detail);
        detail.setAds(campaigns.stream().map(campaign -> {
            advertisements ad = adsById.get(campaign.getAdvertisementId());
            SuperAdminManagementResponse.PublisherAdRecord adRecord = new SuperAdminManagementResponse.PublisherAdRecord();
            adRecord.setId(campaign.getId());
            adRecord.setTitle(ad != null && ad.getTitle() != null ? ad.getTitle() : "Untitled Ad");
            adRecord.setType(ad != null && ad.getAdType() != null ? ad.getAdType() : "Banner");
            adRecord.setStatus(normalizeCampaignStatus(campaign.getCompaignsStatus()));
            adRecord.setCtr(calculateCtrForCampaign(campaign));
            return adRecord;
        }).sorted(Comparator.comparing(SuperAdminManagementResponse.PublisherAdRecord::getId).reversed()).toList());
        return detail;
    }

    public List<SuperAdminManagementResponse.AdvertisementRecord> getAdvertisements() {
        // 1. Fetch all users once (used for admin name lookup)
        Map<String, users> usersById = new HashMap<>();
        usersRepository.findAll().forEach(user -> usersById.put(user.getId(), user));
        usersRepository.findbygivendor().forEach(user -> usersById.put(user.getId(), user));

        // 2. Fetch all campaigns ONCE (previously called twice)
        List<ad_campaigns> allCampaigns = campaignsRepository.findAll();

        // 3. Collect all campaign IDs for bulk queries
        List<String> campaignIds = allCampaigns.stream()
                .map(ad_campaigns::getId)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        // 4. Server-side MongoDB aggregation: count hits grouped by (campaignId,
        // eventType).
        // This replaces findByCampaignIdIn() which loaded EVERY raw hit document into
        // Java
        // heap just to count them — the primary cause of the 5+ minute /ads load time.
        // Now MongoDB does the counting; only a tiny list of {campaignId, eventType,
        // count}
        // rows is returned over the wire.
        Map<String, Map<String, Long>> hitCountsByCampaign = new HashMap<>();
        if (!campaignIds.isEmpty()) {
            List<Object> queryIds = new ArrayList<>();
            for (String id : campaignIds) {
                queryIds.add(id);
                if (ObjectId.isValid(id)) {
                    queryIds.add(new ObjectId(id));
                }
            }
            hitRecordRepository.aggregateHitCounts(queryIds).forEach(result -> {
                if (result.getCampaignId() != null && result.getEventType() != null) {
                    hitCountsByCampaign
                            .computeIfAbsent(result.getCampaignId(), k -> new HashMap<>())
                            .put(result.getEventType(), result.getCount());
                }
            });
        }

        // 4b. Bulk-fetch publishing view counts from txn_publishing_view_counts
        Map<String, Long> publishingViewCounts = new HashMap<>();
        if (!campaignIds.isEmpty()) {
            List<Object> queryIds = new ArrayList<>();
            for (String id : campaignIds) {
                queryIds.add(id);
                if (ObjectId.isValid(id)) {
                    queryIds.add(new ObjectId(id));
                }
            }
            org.springframework.data.mongodb.core.query.Query query = new org.springframework.data.mongodb.core.query.Query(
                    org.springframework.data.mongodb.core.query.Criteria.where("campaignId").in(queryIds));
            List<org.bson.Document> docs = mongoTemplate.find(query, org.bson.Document.class,
                    "txn_publishing_view_counts");
            for (org.bson.Document doc : docs) {
                Object cIdObj = doc.get("campaignId");
                String cId = cIdObj != null ? cIdObj.toString() : null;
                Object cntObj = doc.get("count");
                long count = 0;
                if (cntObj instanceof Number) {
                    count = ((Number) cntObj).longValue();
                } else if (cntObj instanceof String) {
                    try {
                        count = Long.parseLong((String) cntObj);
                    } catch (NumberFormatException ignored) {
                    }
                }
                if (cId != null) {
                    publishingViewCounts.put(cId, publishingViewCounts.getOrDefault(cId, 0L) + count);
                }
            }
        }

        // 5. Fetch advertisement details in one query (no duplicate findAll)
        List<String> adIds = allCampaigns.stream()
                .map(ad_campaigns::getAdvertisementId)
                .filter(Objects::nonNull)
                .distinct()
                .collect(Collectors.toList());
        Map<String, advertisements> adsById = adIds.isEmpty()
                ? new HashMap<>()
                : advertisementsRepository.findDashboardAdsByIds(adIds)
                        .stream()
                        .collect(Collectors.toMap(advertisements::getId, ad -> ad));

        // 5b. Bulk-fetch all media documents needed for images — replaces the
        // per-campaign mongoTemplate.findOne() call that used to live inside
        // resolveCampaignImage(), which fired one network round-trip to MongoDB
        // PER AD. On localhost that round trip was nearly free (same machine);
        // once MongoDB moved onto EC2, each round trip pays real network latency,
        // and with hundreds/thousands of ads this became the dominant cost of the
        // whole endpoint. This was the actual cause of the 8s -> 3min regression
        // after the local -> EC2 + S3 move. Use the [PERF] timing log below to
        // confirm before/after if you want hard numbers.
        Map<String, org.bson.Document> mediaById = new HashMap<>();
        List<ObjectId> mediaObjectIds = adsById.values().stream()
                .map(this::resolveMediaIdForAd)
                .filter(Objects::nonNull)
                .distinct()
                .filter(ObjectId::isValid)
                .map(ObjectId::new)
                .collect(Collectors.toList());
        if (!mediaObjectIds.isEmpty()) {
            org.springframework.data.mongodb.core.query.Query mediaQuery = new org.springframework.data.mongodb.core.query.Query(
                    org.springframework.data.mongodb.core.query.Criteria.where("_id").in(mediaObjectIds));
            mongoTemplate.find(mediaQuery, org.bson.Document.class, "medias")
                    .forEach(doc -> mediaById.put(doc.get("_id").toString(), doc));
        }

        // 6. Map to records using pre-fetched data — no Mobilize API call needed here
        long __startMap = System.currentTimeMillis();
        List<SuperAdminManagementResponse.AdvertisementRecord> result = allCampaigns.stream()
                .map(campaign -> toAdvertisementRecordFast(
                        campaign,
                        adsById.get(campaign.getAdvertisementId()),
                        usersById,
                        hitCountsByCampaign,
                        publishingViewCounts,
                        mediaById))
                .sorted(Comparator.comparing(SuperAdminManagementResponse.AdvertisementRecord::getCreatedDate)
                        .reversed())
                .toList();
        long __endMap = System.currentTimeMillis();
        System.out.println("[PERF] toAdvertisementRecordFast mapping took " + (__endMap - __startMap) + " ms for "
                + allCampaigns.size() + " campaigns");
        return result;
    }

    public SuperAdminManagementResponse.AdvertisementRecord suspendAdvertisement(String campaignId) {
        ad_campaigns campaign = campaignsRepository.findById(campaignId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Campaign not found"));
        campaign.setCompaignsStatus("SUSPENDED");
        campaignsRepository.save(campaign);
        addAuditLog(
                "Super Admin",
                "Super Admin",
                "Ad Update",
                "Ad",
                campaignId,
                "Suspended campaign " + shortId(campaignId),
                getClientIp());
        Map<String, users> usersById = new HashMap<>();
        usersRepository.findAll().forEach(user -> usersById.put(user.getId(), user));
        usersRepository.findbygivendor().forEach(user -> usersById.put(user.getId(), user));
        Map<String, SuperAdminManagementResponse.PublisherRecord> firstPublisherByAdminId = getPublishers(null, null,
                null, null).stream()
                .collect(Collectors.toMap(
                        SuperAdminManagementResponse.PublisherRecord::getAdminId,
                        publisher -> publisher,
                        (left, right) -> left));
        advertisements ad = campaign.getAdvertisementId() == null ? null
                : advertisementsRepository.findById(campaign.getAdvertisementId()).orElse(null);
        return toAdvertisementRecord(campaign, ad, usersById, firstPublisherByAdminId);
    }

    public Page<SuperAdminManagementResponse.AuditLogRecord> getAuditLogs(
            String search,
            String actionType,
            String actorRole,
            String entityType,
            String fromDate,
            String toDate,
            Pageable pageable) {
        Query query = new Query();

        if (search != null && !search.isBlank()) {
            Criteria searchCriteria = new Criteria().orOperator(
                    Criteria.where("actorName").regex(search, "i"),
                    Criteria.where("actionType").regex(search, "i"),
                    Criteria.where("entityType").regex(search, "i"),
                    Criteria.where("entityId").regex(search, "i"),
                    Criteria.where("action").regex(search, "i"),
                    Criteria.where("ipAddress").regex(search, "i"));
            query.addCriteria(searchCriteria);
        }

        if (actionType != null && !actionType.isBlank()) {
            query.addCriteria(Criteria.where("actionType").is(actionType));
        }

        if (actorRole != null && !actorRole.isBlank()) {
            query.addCriteria(Criteria.where("actorRole").is(actorRole));
        }

        if (entityType != null && !entityType.isBlank()) {
            query.addCriteria(Criteria.where("entityType").is(entityType));
        }

        LocalDate from = parseDate(fromDate);
        LocalDate to = parseDate(toDate);

        if (from != null || to != null) {
            Criteria dateCriteria = Criteria.where("timestamp");
            if (from != null) {
                dateCriteria.gte(from.atStartOfDay(ZONE_ID).toInstant());
            }
            if (to != null) {
                dateCriteria.lt(to.plusDays(1).atStartOfDay(ZONE_ID).toInstant());
            }
            query.addCriteria(dateCriteria);
        }

        long total = mongoTemplate.count(query, AuditLog.class);
        query.with(pageable);
        List<AuditLog> auditLogs = mongoTemplate.find(query, AuditLog.class);

        List<SuperAdminManagementResponse.AuditLogRecord> dtos = auditLogs.stream().map(log -> {
            SuperAdminManagementResponse.AuditLogRecord dto = new SuperAdminManagementResponse.AuditLogRecord();
            dto.setId(log.getId());
            dto.setTimestamp(log.getTimestamp() != null ? log.getTimestamp().toString() : "");
            dto.setActorName(log.getActorName());
            dto.setActorRole(log.getActorRole());
            dto.setActionType(log.getActionType());
            dto.setEntityType(log.getEntityType());
            dto.setEntityId(log.getEntityId());
            dto.setAction(log.getAction());
            dto.setIp(log.getIpAddress());
            return dto;
        }).toList();

        return new org.springframework.data.domain.PageImpl<>(dtos, pageable, total);
    }

    public List<SuperAdminManagementResponse.TransactionRecord> getTransactions() {
        return paymentTransactionRepository.findAllByOrderByCreatedAtDesc()
                .stream()
                .map(this::toTransactionRecord)
                .toList();
    }

    public Optional<SuperAdminManagementResponse.TransactionRecord> getTransactionById(String transactionId) {
        Optional<PaymentTransaction> txnOpt = paymentTransactionRepository.findByRazorpayPaymentId(transactionId);
        if (txnOpt.isEmpty()) {
            txnOpt = paymentTransactionRepository.findByRazorpayOrderId(transactionId);
        }
        if (txnOpt.isEmpty() && transactionId.matches("^[0-9a-fA-F]{24}$")) {
            txnOpt = paymentTransactionRepository.findById(transactionId);
        }
        return txnOpt.map(this::toTransactionRecord);
    }

    private SuperAdminManagementResponse.TransactionRecord toTransactionRecord(PaymentTransaction txn) {
        SuperAdminManagementResponse.TransactionRecord record = new SuperAdminManagementResponse.TransactionRecord();

        // Prefer razorpayPaymentId (post-verify) over razorpayOrderId (pre-verify)
        String reference = txn.getRazorpayPaymentId() != null
                ? txn.getRazorpayPaymentId()
                : txn.getRazorpayOrderId();

        String shortRef = reference != null
                ? reference.substring(Math.max(0, reference.length() - 4)).toUpperCase()
                : txn.getId().substring(Math.max(0, txn.getId().length() - 4)).toUpperCase();

        record.setId("TXN-" + shortRef);
        record.setDate(txn.getCreatedAt() != null
                ? txn.getCreatedAt().toString()
                : Instant.now().toString());
        record.setAdminId(txn.getAdminId() != null ? txn.getAdminId() : "");

        String resolvedName = "System";
        if (txn.getAdminId() != null && !txn.getAdminId().isBlank()) {
            resolvedName = resolveAdminName(txn.getAdminId());
        }
        if ("System".equals(resolvedName) && txn.getAdminName() != null && !txn.getAdminName().isBlank()) {
            resolvedName = txn.getAdminName();
        }
        record.setAdminName(resolvedName);
        record.setReference(reference != null ? reference : txn.getId());
        record.setAmount(txn.getAmount());
        record.setStatus(normalizeStatus(txn.getStatus()));
        record.setIncoming(txn.isIncoming());
        record.setPublisherName(txn.getPublisherName());
        record.setLatitude(txn.getLatitude());
        record.setLongitude(txn.getLongitude());
        return record;
    }

    private String resolveAdminName(String adminId) {
        if (adminId == null || adminId.isBlank()) {
            return "System";
        }
        try {
            Optional<org.jackfruit.keliri.model.users> userOpt = usersRepository.findById(adminId);
            if (userOpt.isPresent() && userOpt.get().getFullName() != null && !userOpt.get().getFullName().isBlank()) {
                return userOpt.get().getFullName();
            }
            Optional<org.jackfruit.keliri.model.SuperAdmin> saOpt = superAdminRepository.findById(adminId);
            if (saOpt.isPresent() && saOpt.get().getName() != null && !saOpt.get().getName().isBlank()) {
                return saOpt.get().getName();
            }
            Optional<org.jackfruit.keliri.model.AdminRegistration> regOpt = registrationRepository.findById(adminId);
            if (regOpt.isPresent() && regOpt.get().getAuthorizedPerson() != null) {
                return regOpt.get().getAuthorizedPerson();
            }
        } catch (Exception ignored) {
        }
        return "System";
    }

    private String normalizeStatus(String status) {
        if ("SUCCESS".equalsIgnoreCase(status))
            return "Completed";
        if ("FAILED".equalsIgnoreCase(status))
            return "Failed";
        return "Pending";
    }

    private SuperAdminManagementResponse.AdminActionResponse applyAdminAction(
            String adminId,
            String newStatus,
            String reason,
            String emailTrigger,
            String emailContent,
            String actionType) {
        SuperAdminManagementResponse.AdminRecord admin = getAdmins(null, null).stream()
                .filter(record -> record.getId().equals(adminId))
                .findFirst()
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Admin not found"));
        SuperAdminManagementResponse.EmailNotificationRecord emailNotification = null;
        if (emailTrigger != null) {
            emailNotification = new SuperAdminManagementResponse.EmailNotificationRecord();
            emailNotification.setId("MAIL-" + Instant.now().toEpochMilli());
            emailNotification.setTrigger(emailTrigger);
            emailNotification.setTo(admin.getEmail());
            emailNotification.setContent(emailContent);
            emailNotification.setTimestamp(Instant.now().toString());
            emailNotifications.add(0, emailNotification);
            if (emailNotifications.size() > 100) {
                emailNotifications.remove(emailNotifications.size() - 1);
            }
        }
        SuperAdminManagementResponse.AdminRecord updated = getAdmins(null, null).stream()
                .filter(record -> record.getId().equals(adminId))
                .findFirst()
                .orElse(admin);
        addAuditLog(
                "Super Admin",
                "Super Admin",
                actionType,
                "Account",
                adminId,
                "Updated admin status to " + newStatus + (reason != null ? " (Reason: " + reason + ")" : ""),
                getClientIp());
        SuperAdminManagementResponse.AdminActionResponse response = new SuperAdminManagementResponse.AdminActionResponse();
        response.setAdmin(updated);
        response.setEmailNotification(emailNotification);
        return response;
    }

    private List<SuperAdminManagementResponse.DocumentItem> buildDocuments(String adminId) {
        SuperAdminManagementResponse.DocumentItem gst = new SuperAdminManagementResponse.DocumentItem();
        gst.setName("GST-Certificate-" + shortId(adminId) + ".pdf");
        gst.setType("GST");
        gst.setUrl("https://placehold.co/600x800?text=GST-Certificate-" + shortId(adminId) + ".pdf");
        SuperAdminManagementResponse.DocumentItem company = new SuperAdminManagementResponse.DocumentItem();
        company.setName("Company-Registration-" + shortId(adminId) + ".pdf");
        company.setType("Company");
        company.setUrl("https://placehold.co/600x800?text=Company-Registration-" + shortId(adminId) + ".pdf");
        return List.of(gst, company);
    }

    private SuperAdminManagementResponse.AdminRecord registrationToAdminRecord(
            org.jackfruit.keliri.model.AdminRegistration reg) {
        SuperAdminManagementResponse.AdminRecord record = new SuperAdminManagementResponse.AdminRecord();
        record.setId(reg.getId());
        record.setName(reg.getAuthorizedPerson());
        record.setEmail(reg.getEmailId());
        record.setCompany(reg.getCompanyName());
        record.setRegisteredDate(reg.getSubmittedAt().atZone(ZONE_ID).toLocalDate().format(DATE_FORMATTER));
        record.setStatus(reg.getStatus().substring(0, 1).toUpperCase() + reg.getStatus().substring(1).toLowerCase());
        record.setLocation(reg.getBusinessAddress());
        return record;
    }

    private SuperAdminManagementResponse.PerformanceSummary buildPerformance(
            List<SuperAdminManagementResponse.PublisherRecord> linkedPublishers) {
        long totalAds = linkedPublishers.stream().mapToLong(SuperAdminManagementResponse.PublisherRecord::getAdsPosted)
                .sum();
        long totalImpressions = linkedPublishers.stream()
                .mapToLong(SuperAdminManagementResponse.PublisherRecord::getImpressions).sum();
        long totalClicks = linkedPublishers.stream().mapToLong(SuperAdminManagementResponse.PublisherRecord::getClicks)
                .sum();
        SuperAdminManagementResponse.PerformanceSummary performance = new SuperAdminManagementResponse.PerformanceSummary();
        performance.setTotalAds(totalAds);
        performance.setRevenue(totalAds * 1750L);
        performance.setAvgCtr(totalImpressions == 0 ? 0 : roundToTwoDecimals((totalClicks * 100.0) / totalImpressions));
        return performance;
    }

    private SuperAdminManagementResponse.AdminRecord toAdminRecord(users user) {
        SuperAdminManagementResponse.AdminRecord record = new SuperAdminManagementResponse.AdminRecord();
        record.setId(user.getId());
        record.setName(defaultString(user.getFullName(), "Admin"));
        record.setEmail(defaultString(user.getEmailAddress(), "not-available@keliri.com"));
        record.setCompany(resolveCompanyName(user));
        record.setRegisteredDate(resolveDateFromObjectId(user.getId()));
        String rawStatus = defaultString(user.getAccountStatus(), "Active");
        String normalizedStatus = rawStatus.isEmpty() ? "Active"
                : rawStatus.substring(0, 1).toUpperCase(java.util.Locale.ENGLISH)
                        + rawStatus.substring(1).toLowerCase(java.util.Locale.ENGLISH);
        record.setStatus(normalizedStatus);
        record.setPhone(resolvePhone(user));
        record.setLatitude(user.getLatitude());
        record.setLongitude(user.getLongitude());
        record.setLocation(resolveLocation(user));
        return record;
    }

    private String resolveLocation(users user) {
        Optional<AdminRegistration> registration = registrationRepository.findByEmailId(user.getEmailAddress());
        if (registration.isPresent()
                && registration.get().getBusinessAddress() != null
                && !registration.get().getBusinessAddress().isBlank()) {
            return registration.get().getBusinessAddress();
        }
        return "";
    }

    private boolean matchesAdminFilters(SuperAdminManagementResponse.AdminRecord admin, String search, String status) {
        if (status != null && !status.isBlank() && !admin.getStatus().equalsIgnoreCase(status.trim())) {
            return false;
        }
        if (search == null || search.isBlank()) {
            return true;
        }
        String query = search.toLowerCase(Locale.ENGLISH);
        return admin.getName().toLowerCase(Locale.ENGLISH).contains(query)
                || admin.getEmail().toLowerCase(Locale.ENGLISH).contains(query)
                || admin.getCompany().toLowerCase(Locale.ENGLISH).contains(query)
                || (admin.getLocation() != null
                        && admin.getLocation().toLowerCase(Locale.ENGLISH).contains(query));
    }

    private boolean matchesPublisherFilters(
            SuperAdminManagementResponse.PublisherRecord publisher,
            String adminId,
            String status,
            String location,
            String search) {
        if (adminId != null && !adminId.isBlank() && !adminId.equals(publisher.getAdminId())) {
            return false;
        }
        if (status != null && !status.isBlank() && !status.equalsIgnoreCase(publisher.getStatus())) {
            return false;
        }
        if (location != null && !location.isBlank() && !location.equalsIgnoreCase(publisher.getLocation())) {
            return false;
        }
        if (search == null || search.isBlank()) {
            return true;
        }
        String query = search.toLowerCase(Locale.ENGLISH);
        return publisher.getName().toLowerCase(Locale.ENGLISH).contains(query)
                || publisher.getEmail().toLowerCase(Locale.ENGLISH).contains(query)
                || publisher.getLocation().toLowerCase(Locale.ENGLISH).contains(query);
    }

    private boolean matchesAuditFilters(
            SuperAdminManagementResponse.AuditLogRecord log,
            String search,
            String actionType,
            String actorRole,
            String entityType,
            LocalDate from,
            LocalDate to) {
        if (actionType != null && !actionType.isBlank() && !actionType.equalsIgnoreCase(log.getActionType())) {
            return false;
        }
        if (actorRole != null && !actorRole.isBlank() && !actorRole.equalsIgnoreCase(log.getActorRole())) {
            return false;
        }
        if (entityType != null && !entityType.isBlank() && !entityType.equalsIgnoreCase(log.getEntityType())) {
            return false;
        }
        LocalDate date = Instant.parse(log.getTimestamp()).atZone(ZONE_ID).toLocalDate();
        if (from != null && date.isBefore(from)) {
            return false;
        }
        if (to != null && date.isAfter(to)) {
            return false;
        }
        if (search == null || search.isBlank()) {
            return true;
        }
        String query = search.toLowerCase(Locale.ENGLISH);
        return log.getId().toLowerCase(Locale.ENGLISH).contains(query)
                || log.getActorName().toLowerCase(Locale.ENGLISH).contains(query)
                || log.getAction().toLowerCase(Locale.ENGLISH).contains(query)
                || log.getEntityId().toLowerCase(Locale.ENGLISH).contains(query)
                || log.getIp().contains(search);
    }

    private List<SuperAdminManagementResponse.AuditLogRecord> buildGeneratedAuditLogs() {
        List<ad_campaigns> campaigns = campaignsRepository.findAll();
        Map<String, users> usersById = new HashMap<>();
        usersRepository.findAll().forEach(user -> usersById.put(user.getId(), user));
        usersRepository.findbygivendor().forEach(user -> usersById.put(user.getId(), user));
        List<SuperAdminManagementResponse.AuditLogRecord> logs = new ArrayList<>();
        int index = 0;
        for (ad_campaigns campaign : campaigns.stream().limit(80).toList()) {
            SuperAdminManagementResponse.AuditLogRecord log = new SuperAdminManagementResponse.AuditLogRecord();
            log.setId("LOG-" + (9100 + index));
            log.setTimestamp(resolveCampaignInstant(campaign).toString());
            users actor = usersById.get(campaign.getCreatedBy());
            log.setActorName(actor != null ? defaultString(actor.getFullName(), "Admin") : "Admin User");
            log.setActorRole("Admin");
            log.setActionType(index % 2 == 0 ? "Ad Creation" : "Ad Update");
            log.setEntityType("Ad");
            log.setEntityId(defaultString(campaign.getAdvertisementId(), campaign.getId()));
            log.setAction((index % 2 == 0 ? "Created" : "Updated") + " campaign " + shortId(campaign.getId()));
            log.setIp("10.0." + (index % 8) + "." + ((index % 200) + 11));
            logs.add(log);
            index++;
        }
        List<SuperAdminManagementResponse.AdminRecord> admins = getAdmins(null, null);
        for (int i = 0; i < Math.min(10, admins.size()); i++) {
            SuperAdminManagementResponse.AdminRecord admin = admins.get(i);
            SuperAdminManagementResponse.AuditLogRecord loginLog = new SuperAdminManagementResponse.AuditLogRecord();
            loginLog.setId("LOG-L" + (700 + i));
            loginLog.setTimestamp(Instant.now().minusSeconds((long) i * 7200).toString());
            loginLog.setActorName(admin.getName());
            loginLog.setActorRole("Admin");
            loginLog.setActionType("Login");
            loginLog.setEntityType("Session");
            loginLog.setEntityId("SES-" + shortId(admin.getId()));
            loginLog.setAction("Admin login successful");
            loginLog.setIp("172.16.1." + (i + 10));
            logs.add(loginLog);
        }
        return logs;
    }

    public void logLogin(String actorName, String actorRole, String ip, String action) {
        addAuditLog(actorName, actorRole, "Login", "Session", "SES-" + java.time.Instant.now().toEpochMilli(), action,
                ip);
    }

    private void addAuditLog(
            String actorName,
            String actorRole,
            String actionType,
            String entityType,
            String entityId,
            String action,
            String ip) {
        AuditLog log = new AuditLog();
        log.setTimestamp(Instant.now());
        log.setCreatedAt(Instant.now());
        log.setActorName(actorName);
        log.setActorRole(actorRole);
        log.setActionType(actionType);
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setAction(action);
        log.setIpAddress(ip);

        try {
            ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs != null) {
                HttpServletRequest req = attrs.getRequest();
                String ua = req.getHeader("User-Agent");
                log.setUserAgent(ua != null ? ua : "Unknown");
            }
        } catch (Exception e) {
            log.setUserAgent("Unknown");
        }

        auditLogRepository.save(log);
    }

    private String getClientIp() {
        try {
            ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs != null) {
                HttpServletRequest request = attrs.getRequest();
                String ipAddress = Optional.ofNullable(request.getHeader("X-Forwarded-For"))
                        .map(s -> s.split(",")[0].trim())
                        .orElse(request.getRemoteAddr());
                if ("0:0:0:0:0:0:0:1".equals(ipAddress)) {
                    ipAddress = "127.0.0.1";
                }
                return ipAddress;
            }
        } catch (Exception e) {
        }
        return "Unknown";
    }

    private String resolvePublisherStatus(List<ad_campaigns> campaigns) {
        if (campaigns.isEmpty()) {
            return "Inactive";
        }
        boolean hasActive = campaigns.stream()
                .anyMatch(campaign -> "ACTIVE".equalsIgnoreCase(campaign.getCompaignsStatus()));
        boolean hasPaused = campaigns.stream()
                .anyMatch(campaign -> "SUSPENDED".equalsIgnoreCase(campaign.getCompaignsStatus()));
        if (hasPaused && !hasActive) {
            return "Suspended";
        }
        if (hasActive) {
            return "Active";
        }
        return "Inactive";
    }

    private String resolvePublisherIdForCampaign(ad_campaigns campaign) {
        if (campaign.getCreatedBy() != null && !campaign.getCreatedBy().isBlank()) {
            return campaign.getCreatedBy();
        }
        return "UNKNOWN";
    }

    private long getImpressionsFromPublishingViewCounts(String campaignId) {
        if (campaignId == null || campaignId.isBlank()) {
            return 0L;
        }
        List<Object> queryIds = new ArrayList<>();
        queryIds.add(campaignId);
        if (ObjectId.isValid(campaignId)) {
            queryIds.add(new ObjectId(campaignId));
        }
        org.springframework.data.mongodb.core.query.Query query = new org.springframework.data.mongodb.core.query.Query(
                org.springframework.data.mongodb.core.query.Criteria.where("campaignId").in(queryIds));
        List<org.bson.Document> docs = mongoTemplate.find(query, org.bson.Document.class, "txn_publishing_view_counts");
        long total = 0;
        for (org.bson.Document doc : docs) {
            Object cntObj = doc.get("count");
            if (cntObj instanceof Number) {
                total += ((Number) cntObj).longValue();
            } else if (cntObj instanceof String) {
                try {
                    total += Long.parseLong((String) cntObj);
                } catch (NumberFormatException ignored) {
                }
            }
        }
        return total;
    }

    private SuperAdminManagementResponse.AdvertisementRecord toAdvertisementRecord(
            ad_campaigns campaign,
            advertisements ad,
            Map<String, users> usersById,
            Map<String, SuperAdminManagementResponse.PublisherRecord> firstPublisherByAdminId) {
        SuperAdminManagementResponse.AdvertisementRecord record = new SuperAdminManagementResponse.AdvertisementRecord();
        users admin = usersById.get(campaign.getCreatedBy());
        SuperAdminManagementResponse.PublisherRecord publisher = firstPublisherByAdminId.get(campaign.getCreatedBy());
        Instant campaignInstant = resolveCampaignInstant(campaign);
        record.setId(campaign.getId());
        record.setTitle(ad != null && ad.getTitle() != null ? ad.getTitle() : "Untitled Campaign");
        record.setDescription(ad != null ? ad.getDescription() : null);
        record.setType(ad != null && ad.getAdType() != null ? ad.getAdType() : "Banner");
        record.setAdminId(campaign.getCreatedBy());
        record.setAdminName(admin != null ? defaultString(admin.getFullName(), "Admin") : "Admin User");
        record.setPublisherId(publisher != null ? publisher.getId() : campaign.getCreatedBy());
        record.setPublisherName(publisher != null ? publisher.getName() : "Publisher Network");
        record.setCreatedDate(campaignInstant.atZone(ZONE_ID).toLocalDate().format(DATE_FORMATTER));
        record.setStatus(normalizeCampaignStatus(campaign.getCompaignsStatus()));
        long impressions = getImpressionsFromPublishingViewCounts(campaign.getId());
        long clicks = hitRecordRepository.countByCampaignIdAndEventType(campaign.getId(), "AD_CLICK");
        record.setImpressions(impressions);
        record.setClicks(clicks);
        record.setCtr(impressions == 0 ? 0D : roundToTwoDecimals((clicks * 100.0) / impressions));
        record.setStartDate(resolveStartDate(campaign));
        record.setEndDate(resolveEndDate(campaign));
        record.setLocation(resolveCampaignLocation(campaign));
        record.setRadius(resolveCampaignRadius(campaign));
        record.setImage(resolveCampaignImage(ad));
        // Populate coordinates so the frontend can skip live Geocoding API calls
        if (campaign.getLocation() != null) {
            try {
                String latStr = campaign.getLocation().getLat();
                String lngStr = campaign.getLocation().getLng();
                if (latStr != null && !latStr.isBlank() && lngStr != null && !lngStr.isBlank()) {
                    record.setLat(Double.parseDouble(latStr));
                    record.setLng(Double.parseDouble(lngStr));
                }
            } catch (NumberFormatException ignored) {
            }
            int range = campaign.getLocation().getRange();
            if (range > 0) {
                record.setLocationRange(range);
            }
        }
        return record;
    }

    /**
     * Fast variant used by getAdvertisements().
     * Uses a pre-built hit-counts map (one bulk DB query for all campaigns)
     * and derives admin/publisher names from the already-loaded usersById map,
     * completely avoiding the expensive Mobilize API + N×2 DB queries.
     * Also uses a pre-built mediaById map (one bulk DB query for all ads)
     * instead of resolveCampaignImage()'s per-ad mongoTemplate.findOne() call.
     */
    private SuperAdminManagementResponse.AdvertisementRecord toAdvertisementRecordFast(
            ad_campaigns campaign,
            advertisements ad,
            Map<String, users> usersById,
            Map<String, Map<String, Long>> hitCountsByCampaign,
            Map<String, Long> publishingViewCounts,
            Map<String, org.bson.Document> mediaById) {
        SuperAdminManagementResponse.AdvertisementRecord record = new SuperAdminManagementResponse.AdvertisementRecord();
        users admin = usersById.get(campaign.getCreatedBy());
        Instant campaignInstant = resolveCampaignInstant(campaign);
        record.setId(campaign.getId());
        record.setTitle(ad != null && ad.getTitle() != null ? ad.getTitle() : "Untitled Campaign");
        record.setDescription(ad != null ? ad.getDescription() : null);
        record.setType(ad != null && ad.getAdType() != null ? ad.getAdType() : "Banner");
        record.setAdminId(campaign.getCreatedBy());
        record.setAdminName(admin != null ? defaultString(admin.getFullName(), "Admin") : "Admin User");
        // Publisher derived from admin user — avoids calling getPublishers() / Mobilize
        // API
        record.setPublisherId(campaign.getCreatedBy());
        record.setPublisherName(
                admin != null ? defaultString(admin.getCompanyName(), "Publisher Network") : "Publisher Network");
        record.setCreatedDate(campaignInstant.atZone(ZONE_ID).toLocalDate().format(DATE_FORMATTER));
        record.setCreatedAt(campaignInstant.toString());
        record.setStatus(normalizeCampaignStatus(campaign.getCompaignsStatus()));
        // Use pre-fetched hit counts — O(1) map lookups instead of 2 DB queries per
        // campaign
        Map<String, Long> counts = hitCountsByCampaign.getOrDefault(campaign.getId(), new HashMap<>());
        long impressions = publishingViewCounts.getOrDefault(campaign.getId(), 0L);
        long clicks = counts.getOrDefault("AD_CLICK", 0L);
        record.setImpressions(impressions);
        record.setClicks(clicks);
        record.setCtr(impressions == 0 ? 0D : roundToTwoDecimals((clicks * 100.0) / impressions));
        record.setStartDate(resolveStartDate(campaign));
        record.setEndDate(resolveEndDate(campaign));
        record.setLocation(resolveCampaignLocation(campaign));
        record.setRadius(resolveCampaignRadius(campaign));
        record.setImage(resolveCampaignImageFast(ad, mediaById));
        // Populate coordinates so the frontend can skip live Geocoding API calls
        if (campaign.getLocation() != null) {
            try {
                String latStr = campaign.getLocation().getLat();
                String lngStr = campaign.getLocation().getLng();
                if (latStr != null && !latStr.isBlank() && lngStr != null && !lngStr.isBlank()) {
                    record.setLat(Double.parseDouble(latStr));
                    record.setLng(Double.parseDouble(lngStr));
                }
            } catch (NumberFormatException ignored) {
            }
            int range = campaign.getLocation().getRange();
            if (range > 0) {
                record.setLocationRange(range);
            }
        }
        return record;
    }

    private String resolveLocationLabel(users publisher, Map<String, txn_user_locations> locationsById) {
        if (publisher.getLastKnownLocation() != null) {
            txn_user_locations location = locationsById.get(publisher.getLastKnownLocation());
            if (location != null && location.getLocation() != null) {
                return String.format(Locale.ENGLISH, "%.4f, %.4f", location.getLocation().getY(),
                        location.getLocation().getX());
            }
        }
        if (publisher.getLatitude() != 0 || publisher.getLongitude() != 0) {
            return String.format(Locale.ENGLISH, "%.4f, %.4f", publisher.getLatitude(), publisher.getLongitude());
        }
        return "Unknown";
    }

    private String resolveCampaignLocation(ad_campaigns campaign) {
        if (campaign.getLocation() == null) {
            return "Unknown";
        }
        if (campaign.getLocation().getLocationName() != null && !campaign.getLocation().getLocationName().isBlank()) {
            return campaign.getLocation().getLocationName();
        }
        try {
            String latStr = campaign.getLocation().getLat();
            String lngStr = campaign.getLocation().getLng();

            if (latStr != null && !latStr.isBlank() &&
                    lngStr != null && !lngStr.isBlank()) {

                return String.format(Locale.ENGLISH, "%.4f, %.4f",
                        Double.parseDouble(latStr),
                        Double.parseDouble(lngStr));
            }
        } catch (NumberFormatException ignored) {
        }

        return "Unknown";
    }

    private String resolveCampaignRadius(ad_campaigns campaign) {
        if (campaign.getLocation() == null) {
            return "N/A";
        }
        Integer range = campaign.getLocation().getRange();
        if (range == null || range <= 0) {
            return "N/A";
        }
        return roundToTwoDecimals(range) + "km";
    }

    private String resolveStartDate(ad_campaigns campaign) {
        if (campaign.getDateRange() != null && campaign.getDateRange().getFromDate() != null) {
            return campaign.getDateRange().getFromDate().toInstant().atZone(ZONE_ID).toLocalDate()
                    .format(DATE_FORMATTER);
        }
        return resolveDateFromObjectId(campaign.getId());
    }

    private String resolveEndDate(ad_campaigns campaign) {
        if (campaign.getDateRange() != null && campaign.getDateRange().getToDate() != null) {
            return campaign.getDateRange().getToDate().toInstant().atZone(ZONE_ID).toLocalDate().format(DATE_FORMATTER);
        }
        return resolveStartDate(campaign);
    }

    /**
     * Determines which media ID (if any) an ad needs resolved from the 'medias'
     * collection, without hitting the DB. Used to build the bulk media_id list
     * up front in getAdvertisements(). Returns null for ads that don't need a
     * DB lookup (no media, or already-absolute URLs).
     */
    private String resolveMediaIdForAd(advertisements ad) {
        if (ad == null) {
            return null;
        }
        String mediaId = null;
        if (ad.getThumbnail() != null && !ad.getThumbnail().isBlank()) {
            mediaId = ad.getThumbnail();
        } else if (ad.getContent() != null && ad.getContent().getBanners() != null
                && !ad.getContent().getBanners().isEmpty()) {
            mediaId = ad.getContent().getBanners().get(0);
        } else if (ad.getContent() != null && ad.getContent().getVideoLink() != null
                && !ad.getContent().getVideoLink().isBlank()) {
            mediaId = ad.getContent().getVideoLink();
        }
        if (mediaId == null || mediaId.isBlank()
                || mediaId.startsWith("http://") || mediaId.startsWith("https://")) {
            return null; // absolute URLs and empty values don't need a DB lookup
        }
        return mediaId;
    }

    /**
     * Fast variant of resolveCampaignImage(): resolves the image URL using a
     * pre-fetched media map (built once in getAdvertisements()) instead of
     * querying MongoDB per ad. Used by toAdvertisementRecordFast().
     */
    private String resolveCampaignImageFast(advertisements ad, Map<String, org.bson.Document> mediaById) {
        if (ad == null) {
            return null;
        }
        String mediaId = null;
        if (ad.getThumbnail() != null && !ad.getThumbnail().isBlank()) {
            mediaId = ad.getThumbnail();
        } else if (ad.getContent() != null && ad.getContent().getBanners() != null
                && !ad.getContent().getBanners().isEmpty()) {
            mediaId = ad.getContent().getBanners().get(0);
        } else if (ad.getContent() != null && ad.getContent().getVideoLink() != null
                && !ad.getContent().getVideoLink().isBlank()) {
            mediaId = ad.getContent().getVideoLink();
        }

        if (mediaId == null || mediaId.isBlank()) {
            return null;
        }

        if (mediaId.startsWith("http://") || mediaId.startsWith("https://")) {
            return mediaId;
        }

        org.bson.Document mediaDoc = mediaById.get(mediaId);
        if (mediaDoc != null) {
            String s3Loc = mediaDoc.getString("s3Location");
            if (s3Loc != null && !s3Loc.isBlank()) {
                return s3Loc;
            }
            String url = mediaDoc.getString("url");
            if (url != null && !url.isBlank()) {
                return url;
            }
        }

        // Fallback to placehold.co mockup URL if the media file isn't found in the map
        return "https://placehold.co/600x400?text=Media-" + mediaId;
    }

    /**
     * Original single-lookup variant. Still used by suspendAdvertisement() and
     * toAdvertisementRecord() (the non-"fast" path for single-record responses),
     * where a single per-call DB hit is fine — only the bulk getAdvertisements()
     * path needed the batched version above.
     */
    private String resolveCampaignImage(advertisements ad) {
        if (ad == null) {
            return null;
        }
        String mediaId = null;
        if (ad.getThumbnail() != null && !ad.getThumbnail().isBlank()) {
            mediaId = ad.getThumbnail();
        } else if (ad.getContent() != null && ad.getContent().getBanners() != null
                && !ad.getContent().getBanners().isEmpty()) {
            mediaId = ad.getContent().getBanners().get(0);
        } else if (ad.getContent() != null && ad.getContent().getVideoLink() != null
                && !ad.getContent().getVideoLink().isBlank()) {
            mediaId = ad.getContent().getVideoLink();
        }

        if (mediaId == null || mediaId.isBlank()) {
            return null;
        }

        // If it's already an absolute URL, return it directly
        if (mediaId.startsWith("http://") || mediaId.startsWith("https://")) {
            return mediaId;
        }

        // Otherwise, resolve the media ID from the 'medias' collection
        try {
            org.bson.types.ObjectId objId = new org.bson.types.ObjectId(mediaId);
            org.springframework.data.mongodb.core.query.Query q = new org.springframework.data.mongodb.core.query.Query(
                    org.springframework.data.mongodb.core.query.Criteria.where("_id").is(objId));
            org.bson.Document mediaDoc = mongoTemplate.findOne(q, org.bson.Document.class, "medias");
            if (mediaDoc != null) {
                String s3Loc = mediaDoc.getString("s3Location");
                if (s3Loc != null && !s3Loc.isBlank()) {
                    return s3Loc;
                }
                String url = mediaDoc.getString("url");
                if (url != null && !url.isBlank()) {
                    return url;
                }
            }
        } catch (Exception e) {
            System.err.println("[SuperAdminManagementService] Failed to resolve media URL for ID " + mediaId + ": "
                    + e.getMessage());
        }

        // Fallback to placehold.co mockup URL if the media file isn't found in DB
        return "https://placehold.co/600x400?text=Media-" + mediaId;
    }

    private String resolveDateFromObjectId(String id) {
        try {
            return new ObjectId(id).getDate().toInstant().atZone(ZONE_ID).toLocalDate().format(DATE_FORMATTER);
        } catch (Exception ex) {
            return LocalDate.now().format(DATE_FORMATTER);
        }
    }

    private String resolveCompanyName(users user) {

        Optional<AdminRegistration> registration = registrationRepository.findByEmailId(user.getEmailAddress());

        if (registration.isPresent()
                && registration.get().getCompanyName() != null
                && !registration.get().getCompanyName().isBlank()) {
            return registration.get().getCompanyName();
        }

        if (user.getCompanyName() != null
                && !user.getCompanyName().isBlank()) {
            return user.getCompanyName();
        }

        return "Keliri Partner";
    }

    private String resolvePhone(users user) {
        if (user.getPhoneNumber() != null) {
            String countryCode = defaultString(user.getPhoneNumber().getCountryCode(), "");
            String dial = defaultString(user.getPhoneNumber().getDialNumber(), "");
            String value = (countryCode + " " + dial).trim();
            if (!value.isEmpty() && !"N/A".equals(value)) {
                return value;
            }
        }

        // Fallback: look up in AdminRegistration
        Optional<AdminRegistration> registration = registrationRepository.findByEmailId(user.getEmailAddress());
        if (registration.isPresent()
                && registration.get().getMobileNumber() != null
                && !registration.get().getMobileNumber().isBlank()) {
            return registration.get().getMobileNumber();
        }

        return "N/A";
    }

    private Instant resolveCampaignInstant(ad_campaigns campaign) {
        try {
            if (campaign.getDateRange() != null && campaign.getDateRange().getFromDate() != null) {
                return campaign.getDateRange().getFromDate().toInstant();
            }
            return new ObjectId(campaign.getId()).getDate().toInstant();
        } catch (Exception ex) {
            return Instant.now();
        }
    }

    private LocalDate parseDate(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        try {
            return LocalDate.parse(raw, DATE_FORMATTER);
        } catch (Exception ex) {
            return null;
        }
    }

    private double calculateCtrForCampaign(ad_campaigns campaign) {
        int hash = Math.abs(campaign.getId().hashCode() % 300);
        return roundToTwoDecimals(1.5 + (hash / 100.0));
    }

    private String normalizeCampaignStatus(String status) {
        if (status == null || status.isBlank()) {
            return "Draft";
        }
        String normalized = status.trim().toUpperCase(Locale.ENGLISH);
        if ("ACTIVE".equals(normalized)) {
            return "Active";
        }
        if ("PENDING".equals(normalized)) {
            return "Pending";
        }
        if ("COMPLETED".equals(normalized)) {
            return "Completed";
        }
        if ("SUSPENDED".equals(normalized)) {
            return "Suspended";
        }
        if ("PAUSED".equals(normalized)) {
            return "Paused";
        }
        if ("INACTIVE".equals(normalized)) {
            return "Inactive";
        }
        if ("EXPIRED".equals(normalized)) {
            return "Expired";
        }
        return "Draft";
    }

    private double roundToTwoDecimals(double value) {
        return Math.round(value * 100.0) / 100.0;
    }

    private SuperAdminManagementResponse.DocumentItem newDocument(String name, String type, String url) {
        SuperAdminManagementResponse.DocumentItem doc = new SuperAdminManagementResponse.DocumentItem();
        doc.setName(name);
        doc.setType(type);
        doc.setUrl(url);
        return doc;
    }

    private SuperAdminManagementResponse.AdminRecord toAdminRecordFromReg(
            org.jackfruit.keliri.model.AdminRegistration reg) {
        SuperAdminManagementResponse.AdminRecord record = new SuperAdminManagementResponse.AdminRecord();
        record.setId(reg.getId());
        record.setName(reg.getAuthorizedPerson());
        record.setEmail(reg.getEmailId());
        record.setCompany(reg.getCompanyName());
        record.setLocation(reg.getBusinessAddress());
        record.setLatitude(reg.getLatitude());
        record.setLongitude(reg.getLongitude());
        record.setLocation(reg.getBusinessAddress());
        record.setPhone(reg.getMobileNumber() != null ? reg.getMobileNumber() : "");
        String regStatus = reg.getStatus();
        if ("APPROVED".equalsIgnoreCase(regStatus))
            record.setStatus("Active");
        else if ("REJECTED".equalsIgnoreCase(regStatus))
            record.setStatus("Rejected");
        else
            record.setStatus("Pending");
        if (reg.getSubmittedAt() != null) {
            record.setRegisteredDate(reg.getSubmittedAt().atZone(ZONE_ID).toLocalDate().format(DATE_FORMATTER));
        } else {
            record.setRegisteredDate(LocalDate.now().format(DATE_FORMATTER));
        }
        return record;
    }

    private SuperAdminManagementResponse.AdminRecord mobilizeCompanyToAdminRecord(Map<String, Object> company) {
        SuperAdminManagementResponse.AdminRecord record = new SuperAdminManagementResponse.AdminRecord();
        String id = stringOrNull(company.get("_id"));
        if (id == null)
            id = stringOrNull(company.get("uid"));
        record.setId(id);
        Map primaryContact = (Map) company.get("primaryContact");
        if (primaryContact != null && primaryContact.get("name") != null) {
            record.setName(primaryContact.get("name").toString());
        } else {
            record.setName((String) company.get("name"));
        }
        record.setEmail((String) company.get("email"));
        record.setCompany((String) company.get("name"));
        Object createdAt = company.get("createdAt");
        if (createdAt != null) {
            try {
                String dateStr = createdAt.toString();
                record.setRegisteredDate(dateStr.contains("T") ? dateStr.substring(0, 10) : dateStr);
            } catch (Exception e) {
                record.setRegisteredDate(LocalDate.now().format(DATE_FORMATTER));
            }
        } else {
            record.setRegisteredDate(LocalDate.now().format(DATE_FORMATTER));
        }
        Object statusObj = company.get("status");
        boolean isActive = statusObj instanceof Boolean ? (Boolean) statusObj
                : Boolean.parseBoolean(statusObj.toString());
        // Since we are falling back to the mobilize collection for admins that don't
        // have
        // local user accounts yet, their admin portal status is always "Pending",
        // regardless of whether their ad company status is active or not.
        record.setStatus("Pending");
        if (primaryContact != null && primaryContact.get("phoneNumber") != null) {
            Map phone = (Map) primaryContact.get("phoneNumber");
            if (phone.get("dialNumber") != null)
                record.setPhone(phone.get("dialNumber").toString());
        } else if (company.get("phoneNumber") != null) {
            Map phone = (Map) company.get("phoneNumber");
            if (phone.get("dialNumber") != null)
                record.setPhone(phone.get("dialNumber").toString());
        }
        // Try extracting location from primaryContact or company if it exists
        try {
            Map location = (Map) company.get("location");
            if (location != null && location.get("coordinates") != null) {
                List<?> coords = (List<?>) location.get("coordinates");
                if (coords.size() >= 2) {
                    record.setLongitude(((Number) coords.get(0)).doubleValue());
                    record.setLatitude(((Number) coords.get(1)).doubleValue());
                }
            } else if (company.get("latitude") != null && company.get("longitude") != null) {
                record.setLatitude(Double.parseDouble(company.get("latitude").toString()));
                record.setLongitude(Double.parseDouble(company.get("longitude").toString()));
            } else {
                record.setLatitude(0.0);
                record.setLongitude(0.0);
            }
        } catch (Exception e) {
            record.setLatitude(0.0);
            record.setLongitude(0.0);
        }
        return record;
    }

    private String defaultString(String value, String fallback) {
        return value == null || value.isBlank() ? fallback : value;
    }

    private String shortId(String value) {
        if (value == null || value.length() <= 6) {
            return value == null ? "000000" : value;
        }
        return value.substring(value.length() - 6);
    }

    private void copyAdmin(
            SuperAdminManagementResponse.AdminRecord source,
            SuperAdminManagementResponse.AdminDetail target) {

        target.setId(source.getId());
        target.setName(source.getName());
        target.setEmail(source.getEmail());
        target.setCompany(source.getCompany());
        target.setRegisteredDate(source.getRegisteredDate());
        target.setStatus(source.getStatus());
        target.setPhone(source.getPhone());

        target.setLatitude(source.getLatitude());
        target.setLongitude(source.getLongitude());
    }

    private void copyPublisher(SuperAdminManagementResponse.PublisherRecord source,
            SuperAdminManagementResponse.PublisherDetail target) {
        target.setId(source.getId());
        target.setName(source.getName());
        target.setAdminId(source.getAdminId());
        target.setAdminName(source.getAdminName());
        target.setLocation(source.getLocation());
        target.setAdsPosted(source.getAdsPosted());
        target.setImpressions(source.getImpressions());
        target.setClicks(source.getClicks());
        target.setEngagement(source.getEngagement());
        target.setStatus(source.getStatus());
        target.setEmail(source.getEmail());
        target.setPhone(source.getPhone());
        target.setJoinDate(source.getJoinDate());
    }

    // Create a new company (publisher) record
    public companies createPublisher(Publisher publisherRequest) {
        // Validate required fields
        if (publisherRequest.getName() == null || publisherRequest.getName().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Publisher Name is required");
        }
        if (publisherRequest.getEmail() == null || publisherRequest.getEmail().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email ID is required");
        }
        if (publisherRequest.getMobile() == null || publisherRequest.getMobile().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Mobile Number is required");
        }
        if (publisherRequest.getAdminId() == null || publisherRequest.getAdminId().trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Admin ID is required");
        }
        // Check for existing company by email or mobile
        if (companyRepository.findByEmail(publisherRequest.getEmail()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Company with this email already exists");
        }
        if (companyRepository.findByMobile(publisherRequest.getMobile()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Company with this mobile already exists");
        }

        // Populate and save new company
        companies company = new companies();
        company.setName(publisherRequest.getName());
        company.setEmail(publisherRequest.getEmail());
        company.setMobile(publisherRequest.getMobile());
        company.setContactPerson(publisherRequest.getContactPerson() != null ? publisherRequest.getContactPerson()
                : publisherRequest.getName());
        company.setAddress(publisherRequest.getAddress());
        company.setLocation(publisherRequest.getLocation());
        company.setAdminId(publisherRequest.getAdminId());
        company.setStatus("ACTIVE");
        company.setCreatedAt(Instant.now());

        companies saved = companyRepository.save(company);

        // Audit log entry
        addAuditLog(
                "Super Admin",
                "Super Admin",
                "Publisher Creation",
                "Publisher",
                saved.getId(),
                "Created publisher " + saved.getName(),
                getClientIp());
        return saved;
    }
}