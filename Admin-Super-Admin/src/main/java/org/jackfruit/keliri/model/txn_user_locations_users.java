package org.jackfruit.keliri.model;

import java.util.List;
import java.util.Objects;

public class txn_user_locations_users {
	private String id;
	private String fullName;
	private phoneNumber phoneNumber;
	private List<users> u;
	public txn_user_locations_users(String id, String fullName, org.jackfruit.keliri.model.phoneNumber phoneNumber,
			List<users> u) {
		super();
		this.id = id;
		this.fullName = fullName;
		this.phoneNumber = phoneNumber;
		this.u = u;
	}
	public List<users> getU() {
		return u;
	}
	public void setU(List<users> u) {
		this.u = u;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public phoneNumber getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(phoneNumber phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	@Override
	public int hashCode() {
		return Objects.hash(fullName, id, phoneNumber, u);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		txn_user_locations_users other = (txn_user_locations_users) obj;
		return Objects.equals(fullName, other.fullName) && Objects.equals(id, other.id)
				&& Objects.equals(phoneNumber, other.phoneNumber) && Objects.equals(u, other.u);
	}
	@Override
	public String toString() {
		return "txn_user_locations_users [id=" + id + ", fullName=" + fullName + ", phoneNumber=" + phoneNumber + ", u="
				+ u + "]";
	}
	

}
