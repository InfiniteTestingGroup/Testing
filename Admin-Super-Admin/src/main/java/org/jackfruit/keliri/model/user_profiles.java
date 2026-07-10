package org.jackfruit.keliri.model;

import java.util.Date;
import java.util.Objects;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
public class user_profiles {
    @Id
	private String id;
	private ObjectId userId;
	private ObjectId profilePicture;
	private ObjectId createdBy;
	private ObjectId updatedBy;
	private Date createdAt;
	public ObjectId getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(ObjectId createdBy) {
		this.createdBy = createdBy;
	}
	public ObjectId getUpdatedBy() {
		return updatedBy;
	}
	public void setUpdatedBy(ObjectId updatedBy) {
		this.updatedBy = updatedBy;
	}
	public ObjectId getUserId() {
		return userId;
	}
	public void setUserId(ObjectId userId) {
		this.userId = userId;
	}
	
	
	public ObjectId getProfilePicture() {
		return profilePicture;
	}
	public void setProfilePicture(ObjectId profilePicture) {
		this.profilePicture = profilePicture;
	}
	public Date getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	@Override
	public int hashCode() {
		return Objects.hash(createdAt, createdBy, id, profilePicture, updatedBy, userId);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		user_profiles other = (user_profiles) obj;
		return Objects.equals(createdAt, other.createdAt) && Objects.equals(createdBy, other.createdBy)
				&& Objects.equals(id, other.id) && Objects.equals(profilePicture, other.profilePicture)
				&& Objects.equals(updatedBy, other.updatedBy) && Objects.equals(userId, other.userId);
	}
	@Override
	public String toString() {
		return "user_profiles [id=" + id + ", userId=" + userId + ", profilePicture=" + profilePicture + ", createdBy="
				+ createdBy + ", updatedBy=" + updatedBy + ", createdAt=" + createdAt + "]";
	}
	public user_profiles(ObjectId userId, ObjectId profilePicture, ObjectId createdBy, ObjectId updatedBy,
			Date createdAt) {
		super();
		
		this.userId = userId;
		this.profilePicture = profilePicture;
		this.createdBy = createdBy;
		this.updatedBy = updatedBy;
		this.createdAt = createdAt;
	}
	
	
}
