package org.jackfruit.keliri.model;

import java.util.Objects;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
public class users {
	
	@Id
	private String id;
	
	private Object lastKnownLocation;
	
	private String fullName;
	
	private phoneNumber phoneNumber;
	
	private String emailAddress;
	
	private String userType;

    private String profilePicPath;
    private int givendor;
	
    private double latitude;
    private double longitude;
    
    private String password;
    private String companyName;
    private String companyUID; // Mobilize company UUID — used for data isolation
    private String accountStatus; // ACTIVE, SUSPENDED, PENDING
    
    
	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public int getGivendor() {
		return givendor;
	}

	public void setGivendor(int givendor) {
		this.givendor = givendor;
	}

	public String getProfilePicPath() {
		return profilePicPath;
	}

	public void setProfilePicPath(String profilePicPath) {
		this.profilePicPath = profilePicPath;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getCompanyUID() {
		return companyUID;
	}

	public void setCompanyUID(String companyUID) {
		this.companyUID = companyUID;
	}

	public String getAccountStatus() {
		return accountStatus;
	}

	public void setAccountStatus(String accountStatus) {
		this.accountStatus = accountStatus;
	}


	public phoneNumber getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(phoneNumber phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	@Override
	public String toString() {
		return "users [id=" + id + ", lastKnownLocation=" + lastKnownLocation + ", fullName=" + fullName
				+ ", phoneNumber=" + phoneNumber + ", emailAddress=" + emailAddress + ", userType=" + userType + ", profilePicPath="
				+ profilePicPath + ", givendor=" + givendor + ", latitude=" + latitude + ", longitude=" + longitude
				+ "]";
	}

	@Override
	public int hashCode() {
		return Objects.hash(emailAddress, fullName, givendor, id, lastKnownLocation, latitude, longitude, phoneNumber,
				profilePicPath);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		users other = (users) obj;
		return Objects.equals(emailAddress, other.emailAddress) && Objects.equals(fullName, other.fullName)
				&& givendor == other.givendor && Objects.equals(id, other.id)
				&& Objects.equals(lastKnownLocation, other.lastKnownLocation)
				&& Objects.equals(latitude, other.latitude) && Objects.equals(longitude, other.longitude)
				&& Objects.equals(phoneNumber, other.phoneNumber)
				&& Objects.equals(profilePicPath, other.profilePicPath);
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getLastKnownLocation() {
		if (lastKnownLocation == null) {
			return null;
		}
		if (lastKnownLocation instanceof org.bson.types.ObjectId) {
			return ((org.bson.types.ObjectId) lastKnownLocation).toHexString();
		}
		return lastKnownLocation.toString();
	}

	public void setLastKnownLocation(Object lastKnownLocation) {
		this.lastKnownLocation = lastKnownLocation;
	}
public users() {
	// TODO Auto-generated constructor stub
}
}
