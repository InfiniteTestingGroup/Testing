package org.jackfruit.keliri.controller;

import java.util.ArrayList;
import java.util.Objects;

import org.jackfruit.keliri.model.Content;
import org.jackfruit.keliri.model.advertisements;
import org.jackfruit.keliri.model.dateRange;
import org.jackfruit.keliri.model.location;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Field;

 public class projectionClass {
	
	
	private String _id;
	
	 
	 private String compaignsStatus;
	 private String createdBy;
	 private String advertisementId;
	 private dateRange dateRange;
	/* private String latitude;
	 private String longitude;
	 private String range;*/
	 private location location;
	 private advertisements a;
	 /*private String title;
		private String description;*/
	/* public String getRange() {
		return range;
	}
	public void setRange(String range) {
		this.range = range;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}*/
	
	
	
	//another class
	
	public static  class advertisementsDetails {
		
		private String _id;
	    private String title;
	    private String  description;   
		private String company;
		private String thumbnail;
		public String get_id() {
			return _id;
		}
		public void set_id(String _id) {
			this._id = _id;
		}
		private Content content;
		private String adType;
		
		

		public String getAdType() {
			return adType;
		}
		public void setAdType(String adType) {
			this.adType = adType;
		}
		public String getThumbnail() {
			return thumbnail;
		}
		public void setThumbnail(String thumbnail) {
			this.thumbnail = thumbnail;
		}
		public Content getContent() {
			return content;
		}
		public void setContent(Content content) {
			this.content = content;
		}
		public String getCompany() {
			return company;
		}
		public void setCompany(String company) {
			this.company = company;
		}
	
		public String getTitle() {
			return title;
		}
		public void setTitle(String title) {
			this.title = title;
		}
		public String getDescription() {
			return description;
		}
		public void setDescription(String description) {
			this.description = description;
		}
		@Override
		public int hashCode() {
			return Objects.hash(adType, company, content, description, _id, thumbnail, title);
		}
		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			advertisementsDetails other = (advertisementsDetails) obj;
			return Objects.equals(adType, other.adType) && Objects.equals(company, other.company)
					&& Objects.equals(content, other.content) && Objects.equals(description, other.description)
					&& Objects.equals(_id, other._id) && Objects.equals(thumbnail, other.thumbnail)
					&& Objects.equals(title, other.title);
		}
		@Override
		public String toString() {
			return "advertisements [id=" + _id + ", title=" + title + ", description=" + description + ", company=" + company
					+ ", thumbnail=" + thumbnail + ", content=" + content + ", adType=" + adType + "]";
		}
		public advertisementsDetails(String _id, String title, String description) {
			super();
			this._id = _id;
			this.title = title;
			this.description = description;
		}
		
	}
	
	 public advertisements getA() {
			return a;
		}


		public void setA(advertisements a) {
			this.a = a;
		}


		public location getLocation() {
			return location;
		}


		public void setLocation(location location) {
			this.location = location;
		}

		// private String adType;
		// private String thumbnail;
		// private String content;
		// private String company;
		public String getId() {
			return _id;
		}
		

		public projectionClass( String compaignsStatus, String createdBy, String advertisementId,
				org.jackfruit.keliri.model.dateRange dateRange,location location,advertisements a) {
			super();
			//this._id = _id;
			this.compaignsStatus = compaignsStatus;
			this.createdBy = createdBy;
			this.advertisementId = advertisementId;
			this.dateRange = dateRange;
			this.location=location;
			this.a= a;
			
		}
		public String getCreatedBy() {
			return createdBy;
		}
		public void setCreatedBy(String createdBy) {
			this.createdBy = createdBy;
		}
		public String getAdvertisementId() {
			return advertisementId;
		}
		public void setAdvertisementId(String advertisementId) {
			this.advertisementId = advertisementId;
		}
		public dateRange getDateRange() {
			return dateRange;
		}
		public void setDateRange(dateRange dateRange) {
			this.dateRange = dateRange;
		}
		/*public String getLocation() {
			return location;
		}
		public void setLocation(String location) {
			this.location = location;
		}*/
	/*	public String getDescription() {
			return description;
		}
		public void setDescription(String description) {
			this.description = description;
		}*/
		public void setId(String id) {
			this._id = id;
		}
		public String getCompaignsStatus() {
			return compaignsStatus;
		}
		public void setCompaignsStatus(String compaignsStatus) {
			this.compaignsStatus = compaignsStatus;
		}
	@Override
		public int hashCode() {
			return Objects.hash(advertisementId, compaignsStatus, createdBy, dateRange, _id, location);
		}
		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			projectionClass other = (projectionClass) obj;
			return Objects.equals(advertisementId, other.advertisementId)
					&& Objects.equals(compaignsStatus, other.compaignsStatus) && Objects.equals(createdBy, other.createdBy)
					&& Objects.equals(dateRange, other.dateRange) && Objects.equals(_id, other._id)
					&& Objects.equals(location, other.location);
		}
		@Override
		public String toString() {
			return "projectionClass [id=" + _id + ", compaignsStatus=" + compaignsStatus + ", createdBy=" + createdBy
					+ ", advertisementId=" + advertisementId + ", dateRange=" + dateRange + ", location=" + location + "]";
		}
		
}
