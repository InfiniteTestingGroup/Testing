package org.jackfruit.keliri.model;

import java.util.Objects;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
public class users_keliri {
	@Id
	private String id;
	
	private String name;
	private String phoneNumber;
	private String nickName;
	private String emailId;
	private String age;
	private String interest;
	private String gender;
	
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getProfileImagePath() {
		return profileImagePath;
	}
	public void setProfileImagePath(String profileImagePath) {
		this.profileImagePath = profileImagePath;
	}
	private String profileImagePath;
	@Override
	public String toString() {
		return "users_keliri [id=" + id + ", name=" + name + ", phoneNumber=" + phoneNumber + ", nickName=" + nickName
				+ ", emailId=" + emailId + ", age=" + age + ", interest=" + interest + ", gender=" + gender
				+ ", profileImagePath=" + profileImagePath + "]";
	}
	@Override
	public int hashCode() {
		return Objects.hash(age, emailId, gender, id, interest, name, nickName, phoneNumber, profileImagePath);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		users_keliri other = (users_keliri) obj;
		return Objects.equals(age, other.age) && Objects.equals(emailId, other.emailId)
				&& Objects.equals(gender, other.gender) && Objects.equals(id, other.id)
				&& Objects.equals(interest, other.interest) && Objects.equals(name, other.name)
				&& Objects.equals(nickName, other.nickName) && Objects.equals(phoneNumber, other.phoneNumber)
				&& Objects.equals(profileImagePath, other.profileImagePath);
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
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	public String getNickName() {
		return nickName;
	}
	public void setNickName(String nickName) {
		this.nickName = nickName;
	}
	public String getEmailId() {
		return emailId;
	}
	public void setEmailId(String emailId) {
		this.emailId = emailId;
	}
	public String getAge() {
		return age;
	}
	public void setAge(String age) {
		this.age = age;
	}
	public String getInterest() {
		return interest;
	}
	public void setInterest(String interest) {
		this.interest = interest;
	}
	

}
