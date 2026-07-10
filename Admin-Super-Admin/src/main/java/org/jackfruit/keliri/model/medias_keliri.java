package org.jackfruit.keliri.model;

import java.util.Date;
import java.util.Objects;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
public class medias_keliri {

	@Id
	private String id;
	private String s3Location;
	private String uid;
	private String mediaKey;
	private String mediaId;
	public String getMediaKey() {
		return mediaKey;
	}

	public void setMediaKey(String mediaKey) {
		this.mediaKey = mediaKey;
	}

	public String getMediaId() {
		return mediaId;
	}

	public void setMediaId(String mediaId) {
		this.mediaId = mediaId;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getMediaType() {
		return mediaType;
	}

	public void setMediaType(String mediaType) {
		this.mediaType = mediaType;
	}

	public ObjectId getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(ObjectId createdBy) {
		this.createdBy = createdBy;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public Date getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}

	private String url;
	private String mediaType;
	private ObjectId createdBy;
	private Date createdAt;
	private Date updatedAt;
	
	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	

	public String getS3Location() {
		return s3Location;
	}

	public void setS3Location(String s3Location) {
		this.s3Location = s3Location;
	}

	@Override
	public int hashCode() {
		return Objects.hash(createdAt, createdBy, id, mediaId, mediaKey, mediaType, s3Location, uid, updatedAt, url);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		medias_keliri other = (medias_keliri) obj;
		return Objects.equals(createdAt, other.createdAt) && Objects.equals(createdBy, other.createdBy)
				&& Objects.equals(id, other.id) && Objects.equals(mediaId, other.mediaId)
				&& Objects.equals(mediaKey, other.mediaKey) && Objects.equals(mediaType, other.mediaType)
				&& Objects.equals(s3Location, other.s3Location) && Objects.equals(uid, other.uid)
				&& Objects.equals(updatedAt, other.updatedAt) && Objects.equals(url, other.url);
	}

	@Override
	public String toString() {
		return "medias [id=" + id + ", s3Location=" + s3Location + ", uid=" + uid + ", mediaKey=" + mediaKey
				+ ", mediaId=" + mediaId + ", url=" + url + ", mediaType=" + mediaType + ", createdBy=" + createdBy
				+ ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + "]";
	}

	public medias_keliri(String s3Location, String uid, String mediaKey, String mediaId, String url,
			String mediaType, ObjectId createdBy, Date createdAt, Date updatedAt) {
		super();
		
		this.s3Location = s3Location;
		this.uid = uid;
		this.mediaKey = mediaKey;
		this.mediaId = mediaId;
		this.url = url;
		this.mediaType = mediaType;
		this.createdBy = createdBy;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
	}
	
	
}
