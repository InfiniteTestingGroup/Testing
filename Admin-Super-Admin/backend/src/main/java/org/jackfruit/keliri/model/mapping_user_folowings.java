package org.jackfruit.keliri.model;

import java.util.Objects;

public class mapping_user_folowings {
	private String id;
	private String 	userId;
	private String entityId;
	@Override
	public String toString() {
		return "mapping_user_folowings [id=" + id + ", userId=" + userId + ", entityId=" + entityId + "]";
	}
	@Override
	public int hashCode() {
		return Objects.hash(entityId, id, userId);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		mapping_user_folowings other = (mapping_user_folowings) obj;
		return Objects.equals(entityId, other.entityId) && Objects.equals(id, other.id)
				&& Objects.equals(userId, other.userId);
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
	public String getEntityId() {
		return entityId;
	}
	public void setEntityId(String entityId) {
		this.entityId = entityId;
	}

}
