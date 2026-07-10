package org.jackfruit.keliri.service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.jackfruit.keliri.model.phoneNumber;
import org.jackfruit.keliri.model.users;
import org.jackfruit.keliri.repository.usersRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.jackfruit.keliri.service.SuperAdminManagementService;
import jakarta.servlet.http.HttpServletRequest;

@Service
public class AdminAuthService {
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Autowired
    private usersRepository usersRepo;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private MobilizeApiService mobilizeApiService;

    @Autowired
private SuperAdminManagementService superAdminManagementService;

    public Map<String, Object> login(
        String identifier,
        String password,
        HttpServletRequest request){
        // Try finding by email
        Optional<users> userOpt = usersRepo.findByEmailAddress(identifier);

        // If not found locally, bootstrap from an approved Mobilize registration.
        users user = userOpt.orElseGet(() -> provisionApprovedMobilizeAdmin(identifier, password));
        if (user == null) {
            throw new RuntimeException("Invalid credentials");
        }

        // SECURE LOGIN: Check if account is ACTIVE
        if (user.getAccountStatus() == null || !"ACTIVE".equals(user.getAccountStatus())) {
            throw new RuntimeException("Account is not active. Please wait for Super Admin approval.");
        }

        if (passwordEncoder.matches(password, user.getPassword())) {
            // If companyUID is missing (old record), look it up from Mobilize and save it now
            if (user.getCompanyUID() == null || user.getCompanyUID().isBlank()) {
                try {
                    List<Map> companies = mobilizeApiService.fetchAllCompaniesDirectly();
                    Map<String, Object> matched = (Map<String, Object>) companies.stream()
                            .filter(c -> {
                                if (c == null) return false;
                                String cEmail = String.valueOf(c.get("email"));
                                String cName = String.valueOf(c.get("name"));
                                return identifier.equalsIgnoreCase(cEmail) || 
                                       (user.getCompanyName() != null && user.getCompanyName().equalsIgnoreCase(cName));
                            })
                            .findFirst().orElse(null);
                    if (matched != null && matched.get("uid") != null) {
                        user.setCompanyUID(String.valueOf(matched.get("uid")));
                        usersRepo.save(user);
                    }
                } catch (Exception e) {
                    System.err.println("Could not look up companyUID from Mobilize for: " + identifier);
                }
            }

            String token = jwtService.generateToken(user);
            try {
    String ipAddress = request.getHeader("X-Forwarded-For");

if (ipAddress == null || ipAddress.isBlank()) {
    ipAddress = request.getRemoteAddr();
}

superAdminManagementService.logLogin(
    user.getFullName(),
    "Admin",
    ipAddress,
    "Admin login successful"
);
} catch (Exception e) {
    e.printStackTrace();
}
            
            Map<String, Object> payload = new LinkedHashMap<>();
            payload.put("success", true);
            payload.put("token", token);
            payload.put("message", "Login Successful");
            Map<String, Object> userMap = new LinkedHashMap<>();
            userMap.put("id", user.getId());
            userMap.put("name", user.getFullName());
            userMap.put("email", user.getEmailAddress());
            userMap.put("company", user.getCompanyName() != null ? user.getCompanyName() : "");
            userMap.put("role", user.getUserType());
            // Include companyUID so the frontend can correctly scope all API calls
            userMap.put("companyUID", user.getCompanyUID() != null ? user.getCompanyUID() : "");
            payload.put("user", userMap);
            return payload;
        }

        throw new RuntimeException("Invalid credentials");
    }

    private users provisionApprovedMobilizeAdmin(String identifier, String password) {
        List<Map> companies = mobilizeApiService.fetchAllCompaniesDirectly();
        Map<String, Object> company = (Map<String, Object>) companies.stream()
                .filter(c -> c != null && identifier.equalsIgnoreCase(String.valueOf(((Map) c).get("email"))))
                .findFirst()
                .orElse(null);
        if (company == null) {
            return null;
        }

        Object statusObj = company.get("status");
        boolean isActive = statusObj instanceof Boolean
                ? (Boolean) statusObj
                : Boolean.parseBoolean(String.valueOf(statusObj));
        if (!isActive) {
            return null;
        }

        Object regObj = company.get("keliriRegistration");
        if (!(regObj instanceof Map)) {
            return null;
        }
        Map<String, Object> reg = (Map<String, Object>) regObj;
        String passwordHash = reg.get("passwordHash") != null ? String.valueOf(reg.get("passwordHash")) : null;
        if (passwordHash == null || passwordHash.isBlank() || !passwordEncoder.matches(password, passwordHash)) {
            return null;
        }

        users user = new users();
        Object companyId = company.get("_id");
        if (companyId != null) {
            user.setId(String.valueOf(companyId));
        }
        // Store the Mobilize UUID (uid field) — this is the companyUID for data isolation
        Object companyUid = company.get("uid");
        if (companyUid != null) {
            user.setCompanyUID(String.valueOf(companyUid));
        }
        user.setFullName(firstNonBlank(
                asString(reg.get("authorizedPerson")),
                asString(company.get("name")),
                "Admin"));
        user.setEmailAddress(identifier);
        user.setPassword(passwordHash);
        user.setCompanyName(firstNonBlank(
                asString(reg.get("companyName")),
                asString(company.get("name")),
                ""));
        user.setUserType("ADMIN");
        user.setAccountStatus("ACTIVE");
        user.setGivendor(1);
        user.setLatitude(0);
        user.setLongitude(0);

        String mobile = asString(reg.get("mobileNumber"));
        if (mobile != null && !mobile.isBlank()) {
            phoneNumber phone = new phoneNumber();
            phone.setCountryCode(firstNonBlank(asString(reg.get("countryCode")), "+91"));
            phone.setDialNumber(mobile);
            user.setPhoneNumber(phone);
        }

        return usersRepo.save(user);
    }

    private String asString(Object value) {
        return value == null ? null : String.valueOf(value);
    }

    private String firstNonBlank(String... values) {
        if (values == null) return null;
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return null;
    }
}
