package org.jackfruit.keliri.model;

import java.util.List;
import java.util.Objects;

import org.springframework.data.annotation.Id;
import org.springframework.data.geo.Point;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
import org.springframework.data.mongodb.core.mapping.Document;



@Document
public class txn_user_locations {

	@Id
	private String id;
	private String userId;
	private String userType;
	private Point location;
	private List<users> u;
	public txn_user_locations() {
		// TODO Auto-generated constructor stub
	}
	@Override
	public String toString() {
		return "txn_user_locations [id=" + id + ", userId=" + userId + ", userType=" + userType + ", location="
				+ location + "]";
	}
	@Override
	public int hashCode() {
		return Objects.hash(id, location, userId, userType);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		txn_user_locations other = (txn_user_locations) obj;
		return Objects.equals(id, other.id) && Objects.equals(location, other.location)
				&& Objects.equals(userId, other.userId) && Objects.equals(userType, other.userType);
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String userType) {
		this.userType = userType;
	}
	public Point getLocation() {
		return location;
	}
	public void setLocation(GeoJsonPoint location) {
		this.location = location;
	}
}
