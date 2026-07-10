package org.jackfruit.keliri.model;

import java.util.ArrayList;
import java.util.Objects;

public class adCampaigns_advertisementsDTO {
	
	private String _id;
	private String advertisementId;
	private String fromDate;
	private String toDate;
	private String latitude;
	private String longitude;
	private String locationName; 
	private double range;	
	private String compaignsStatus;	 
	private String createdBy;
	
	
	//for advertisements table
		private String title;
	    private String  description;   
		private String company;
		private String thumbnail;
		private Content content;
		private String adType;
		private ArrayList<customTextSectionArrayObject> customTextSection;
		private int gitagnumber;
		private double distance;
		
	public double getDistance() {
			return distance;
		}
		public void setDistance(double distance) {
			this.distance = distance;
		}
	public String getFromDate() {
		return fromDate;
	}
	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}
	public String getToDate() {
		return toDate;
	}
	public void setToDate(String toDate) {
		this.toDate = toDate;
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
	}
	
		@Override
		public String toString() {
			return "adCampaigns_advertisementsDTO [_id=" + _id + ", advertisementId=" + advertisementId + ", fromDate="
					+ fromDate + ", toDate=" + toDate + ", latitude=" + latitude + ", longitude=" + longitude
					+ ", locationName=" + locationName + ", radius=" + range + ", compaignsStatus=" + compaignsStatus
					+ ", createdBy=" + createdBy + ", title=" + title + ", description=" + description + ", company="
					+ company + ", thumbnail=" + thumbnail + ", content=" + content + ", adType=" + adType
					+ ", customTextSection=" + customTextSection + ", gitagnumber=" + gitagnumber + ", distance="
					+ distance + "]";
		}
		@Override
		public int hashCode() {
			return Objects.hash(_id, adType, advertisementId, compaignsStatus, company, content, createdBy,
					customTextSection, description, distance, fromDate, gitagnumber, latitude, locationName, longitude,
					range, thumbnail, title, toDate);
		}
		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			adCampaigns_advertisementsDTO other = (adCampaigns_advertisementsDTO) obj;
			return Objects.equals(_id, other._id) && Objects.equals(adType, other.adType)
					&& Objects.equals(advertisementId, other.advertisementId)
					&& Objects.equals(compaignsStatus, other.compaignsStatus) && Objects.equals(company, other.company)
					&& Objects.equals(content, other.content) && Objects.equals(createdBy, other.createdBy)
					&& Objects.equals(customTextSection, other.customTextSection)
					&& Objects.equals(description, other.description)
					&& Double.doubleToLongBits(distance) == Double.doubleToLongBits(other.distance)
					&& Objects.equals(fromDate, other.fromDate) && gitagnumber == other.gitagnumber
					&& Objects.equals(latitude, other.latitude) && Objects.equals(locationName, other.locationName)
					&& Objects.equals(longitude, other.longitude) && Objects.equals(range, other.range)
					&& Objects.equals(thumbnail, other.thumbnail) && Objects.equals(title, other.title)
					&& Objects.equals(toDate, other.toDate);
		}
		public String get_id() {
			return _id;
		}
		public void set_id(String _id) {
			this._id = _id;
		}
		public String getAdvertisementId() {
			return advertisementId;
		}
		public void setAdvertisementId(String advertisementId) {
			this.advertisementId = advertisementId;
		}
		
	
		public String getCompaignsStatus() {
			return compaignsStatus;
		}
		public void setCompaignsStatus(String compaignsStatus) {
			this.compaignsStatus = compaignsStatus;
		}
		public String getCreatedBy() {
			return createdBy;
		}
		public void setCreatedBy(String createdBy) {
			this.createdBy = createdBy;
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
		public String getCompany() {
			return company;
		}
		public void setCompany(String company) {
			this.company = company;
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
		public String getAdType() {
			return adType;
		}
		public void setAdType(String adType) {
			this.adType = adType;
		}
		public ArrayList<customTextSectionArrayObject> getCustomTextSection() {
			return customTextSection;
		}
		public void setCustomTextSection(ArrayList<customTextSectionArrayObject> customTextSection) {
			this.customTextSection = customTextSection;
		}
		public int getGitagnumber() {
			return gitagnumber;
		}
		public void setGitagnumber(int gitagnumber) {
			this.gitagnumber = gitagnumber;
		}
		
		public String getLocationName() {
			return locationName;
		}
		public void setLocationName(String locationName) {
			this.locationName = locationName;
		}
		public double getRange() {
			return range;
		}
		public void setRadius(double range) {
			this.range = range;
		}
		public adCampaigns_advertisementsDTO(String _id, String advertisementId, String fromDate, String toDate,
				String latitude, String longitude, String locationName, double range, String compaignsStatus,
				String createdBy, String title, String description, String company, String thumbnail, Content content,
				String adType, ArrayList<customTextSectionArrayObject> customTextSection, int gitagnumber
				) {
			super();
			this._id = _id;
			this.advertisementId = advertisementId;
			this.fromDate = fromDate;
			this.toDate = toDate;
			this.latitude = latitude;
			this.longitude = longitude;
			this.locationName = locationName;
			this.range = range;
			this.compaignsStatus = compaignsStatus;
			this.createdBy = createdBy;
			this.title = title;
			this.description = description;
			this.company = company;
			this.thumbnail = thumbnail;
			this.content = content;
			this.adType = adType;
			this.customTextSection = customTextSection;
			this.gitagnumber = gitagnumber;
			//this.distance = distance;
		}
		
}
