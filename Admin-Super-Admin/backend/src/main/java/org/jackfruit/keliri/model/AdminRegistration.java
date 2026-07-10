// package org.jackfruit.keliri.model;

// import org.springframework.data.annotation.Id;
// import org.springframework.data.mongodb.core.mapping.Document;
// import java.time.Instant;

// @Document(collection = "admin_registrations")
// public class AdminRegistration {
//     @Id
//     private String id;
    
//     private String companyName;
//     private String authorizedPerson;
//     private String businessAddress;
//     private String gstNumber;
//     private String mobileNumber;
//     private String emailId;
//     private String password; // Encrypted
    
//     // S3 URLs
//     private String gstCertificateUrl;
//     private String companyRegistrationDocUrl;
//     private String idProofUrl;
    
//     private String status; // PENDING, APPROVED, REJECTED
//     private String rejectionReason;
//     private Instant submittedAt;
//     private Instant processedAt;

//     public AdminRegistration() {}

//     public String getId() { return id; }
//     public void setId(String id) { this.id = id; }

//     public String getCompanyName() { return companyName; }
//     public void setCompanyName(String companyName) { this.companyName = companyName; }

//     public String getAuthorizedPerson() { return authorizedPerson; }
//     public void setAuthorizedPerson(String authorizedPerson) { this.authorizedPerson = authorizedPerson; }

//     public String getBusinessAddress() { return businessAddress; }
//     public void setBusinessAddress(String businessAddress) { this.businessAddress = businessAddress; }

//     public String getGstNumber() { return gstNumber; }
//     public void setGstNumber(String gstNumber) { this.gstNumber = gstNumber; }

//     public String getMobileNumber() { return mobileNumber; }
//     public void setMobileNumber(String mobileNumber) { this.mobileNumber = mobileNumber; }

//     public String getEmailId() { return emailId; }
//     public void setEmailId(String emailId) { this.emailId = emailId; }

//     public String getPassword() { return password; }
//     public void setPassword(String password) { this.password = password; }

//     public String getGstCertificateUrl() { return gstCertificateUrl; }
//     public void setGstCertificateUrl(String gstCertificateUrl) { this.gstCertificateUrl = gstCertificateUrl; }

//     public String getCompanyRegistrationDocUrl() { return companyRegistrationDocUrl; }
//     public void setCompanyRegistrationDocUrl(String companyRegistrationDocUrl) { this.companyRegistrationDocUrl = companyRegistrationDocUrl; }

//     public String getIdProofUrl() { return idProofUrl; }
//     public void setIdProofUrl(String idProofUrl) { this.idProofUrl = idProofUrl; }

//     public String getStatus() { return status; }
//     public void setStatus(String status) { this.status = status; }

//     public String getRejectionReason() { return rejectionReason; }
//     public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

//     public Instant getSubmittedAt() { return submittedAt; }
//     public void setSubmittedAt(Instant submittedAt) { this.submittedAt = submittedAt; }

//     public Instant getProcessedAt() { return processedAt; }
//     public void setProcessedAt(Instant processedAt) { this.processedAt = processedAt; }
// }
package org.jackfruit.keliri.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.Instant;

@Document(collection = "admin_registrations")
public class AdminRegistration {
    @Id
    private String id;
    
    private String companyName;
    private String authorizedPerson;
    private String businessAddress;
    private Double latitude;
    private Double longitude;
    private String gstNumber;
    private String mobileNumber;
    private String emailId;
    private String password; // Encrypted
    
    // S3 URLs
    private String gstCertificateUrl;
    private String companyRegistrationDocUrl;
    private String idProofUrl;
    
    private String status; // PENDING, APPROVED, REJECTED
    private String rejectionReason;
    private Instant submittedAt;
    private Instant processedAt;

    public AdminRegistration() {}

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getAuthorizedPerson() { return authorizedPerson; }
    public void setAuthorizedPerson(String authorizedPerson) { this.authorizedPerson = authorizedPerson; }

    public String getBusinessAddress() { return businessAddress; }
    public void setBusinessAddress(String businessAddress) { this.businessAddress = businessAddress; }

    public Double getLatitude() {
    return latitude;
}

public void setLatitude(Double latitude) {
    this.latitude = latitude;
}

public Double getLongitude() {
    return longitude;
}

public void setLongitude(Double longitude) {
    this.longitude = longitude;
}

    public String getGstNumber() { return gstNumber; }
    public void setGstNumber(String gstNumber) { this.gstNumber = gstNumber; }

    public String getMobileNumber() { return mobileNumber; }
    public void setMobileNumber(String mobileNumber) { this.mobileNumber = mobileNumber; }

    public String getEmailId() { return emailId; }
    public void setEmailId(String emailId) { this.emailId = emailId; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getGstCertificateUrl() { return gstCertificateUrl; }
    public void setGstCertificateUrl(String gstCertificateUrl) { this.gstCertificateUrl = gstCertificateUrl; }

    public String getCompanyRegistrationDocUrl() { return companyRegistrationDocUrl; }
    public void setCompanyRegistrationDocUrl(String companyRegistrationDocUrl) { this.companyRegistrationDocUrl = companyRegistrationDocUrl; }

    public String getIdProofUrl() { return idProofUrl; }
    public void setIdProofUrl(String idProofUrl) { this.idProofUrl = idProofUrl; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public Instant getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Instant submittedAt) { this.submittedAt = submittedAt; }

    public Instant getProcessedAt() { return processedAt; }
    public void setProcessedAt(Instant processedAt) { this.processedAt = processedAt; }
}