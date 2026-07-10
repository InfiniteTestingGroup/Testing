package org.jackfruit.keliri.service;

import java.util.LinkedHashMap;
import java.util.Map;

import org.jackfruit.keliri.model.SuperAdmin;
import org.jackfruit.keliri.repository.SuperAdminRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class SuperAdminSeeder implements CommandLineRunner {
    private final SuperAdminRepository superAdminRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Value("${security.superadmin.seed-enabled:false}")
    private boolean seedEnabled;

    public SuperAdminSeeder(SuperAdminRepository superAdminRepository) {
        this.superAdminRepository = superAdminRepository;
    }

    @Override
    public void run(String... args) {
        if (!seedEnabled) {
            System.out.println("Super admin seed is disabled. Set SEED_SUPERADMIN=true to create default local users.");
            return;
        }

        try {
            seedMaster();
            seedSubAdmin();
        } catch (RuntimeException ex) {
            System.err.println("Skipping super admin seed because MongoDB is temporarily unavailable: " + ex.getMessage());
        }
    }

    private void seedMaster() {
        String email = "admin@keliri.com";
        String password = "password123";

        SuperAdmin admin = superAdminRepository.findByEmail(email).orElseGet(SuperAdmin::new);
        admin.setName("Master Super Admin");
        admin.setEmail(email);
        admin.setPhone("+91 9876543210");
        admin.setPassword(passwordEncoder.encode(password));
        admin.setLocked(false);
        admin.setFailedAttempts(0);
        admin.setLockUntil(null);
        admin.setRole("MASTER_SUPER_ADMIN");
        admin.setPermissions(fullPermissions());
        superAdminRepository.save(admin);
    }

    private void seedSubAdmin() {
        String email = "subadmin@keliri.com";
        String password = "password123";

        SuperAdmin subAdmin = superAdminRepository.findByEmail(email).orElseGet(SuperAdmin::new);
        subAdmin.setName("Operations Sub Admin");
        subAdmin.setEmail(email);
        subAdmin.setPhone("+91 9876500000");
        subAdmin.setPassword(passwordEncoder.encode(password));
        subAdmin.setLocked(false);
        subAdmin.setFailedAttempts(0);
        subAdmin.setLockUntil(null);
        subAdmin.setRole("SUB_SUPER_ADMIN");
        Map<String, Boolean> permissions = new LinkedHashMap<>();
        permissions.put("dashboard", true);
        permissions.put("analytics", true);
        permissions.put("admins", true);
        permissions.put("publishers", true);
        permissions.put("ads", true);
        permissions.put("revenue", false);
        permissions.put("transactions", false);
        permissions.put("tickets", true);
        permissions.put("auditLogs", true);
        permissions.put("profile", true);
        permissions.put("settings", true);
        permissions.put("subAdmins", false);
        subAdmin.setPermissions(permissions);
        superAdminRepository.save(subAdmin);
    }

    private Map<String, Boolean> fullPermissions() {
        Map<String, Boolean> permissions = new LinkedHashMap<>();
        permissions.put("dashboard", true);
        permissions.put("analytics", true);
        permissions.put("admins", true);
        permissions.put("publishers", true);
        permissions.put("ads", true);
        permissions.put("revenue", true);
        permissions.put("transactions", true);
        permissions.put("tickets", true);
        permissions.put("auditLogs", true);
        permissions.put("profile", true);
        permissions.put("settings", true);
        permissions.put("subAdmins", true);
        return permissions;
    }
}
