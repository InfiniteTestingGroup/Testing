package org.jackfruit.keliri.model;

import java.util.List;
import java.util.Objects;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
@Document
public class companies {
	@Id
	private String id;
	private String name;
	private List<ObjectId> companyCategories;
	private ObjectId companyLogo;
	private String companyLogoPath;

	private String contactPerson;
	private String mobile;
	private String email;
	private String address;
	private String location;
	private String adminId;
	private String status;
	private java.time.Instant createdAt;

	public String getContactPerson() { return contactPerson; }
	public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }

	public String getMobile() { return mobile; }
	public void setMobile(String mobile) { this.mobile = mobile; }

	public String getEmail() { return email; }
	public void setEmail(String email) { this.email = email; }

	public String getAddress() { return address; }
	public void setAddress(String address) { this.address = address; }

	public String getLocation() { return location; }
	public void setLocation(String location) { this.location = location; }

	public String getAdminId() { return adminId; }
	public void setAdminId(String adminId) { this.adminId = adminId; }

	public String getStatus() { return status; }
	public void setStatus(String status) { this.status = status; }

	public java.time.Instant getCreatedAt() { return createdAt; }
	public void setCreatedAt(java.time.Instant createdAt) { this.createdAt = createdAt; }

	public String getCompanyLogoPath() {
		return companyLogoPath;
	}
	public void setCompanyLogoPath(String companyLogoPath) {
		this.companyLogoPath = companyLogoPath;
	}
	public ObjectId getCompanyLogo() {
		return companyLogo;
	}
	public void setCompanyLogo(ObjectId companyLogo) {
		this.companyLogo = companyLogo;
	}
	public List<ObjectId> getCompanyCategories() {
		return companyCategories;
	}
	public void setCompanyCategories(List<ObjectId> companyCategories) {
		this.companyCategories = companyCategories;
	}
	@Override
	public String toString() {
		return "companies [id=" + id + ", name=" + name + ", companyCategories=" + companyCategories + ", companyLogo="
				+ companyLogo + ", companyLogoPath=" + companyLogoPath + "]";
	}
	@Override
	public int hashCode() {
		return Objects.hash(companyCategories, companyLogo, companyLogoPath, id, name);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		companies other = (companies) obj;
		return Objects.equals(companyCategories, other.companyCategories)
				&& Objects.equals(companyLogo, other.companyLogo)
				&& Objects.equals(companyLogoPath, other.companyLogoPath) && Objects.equals(id, other.id)
				&& Objects.equals(name, other.name);
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	} 
	

}
