package org.jackfruit.keliri.model;

import java.util.ArrayList;
import java.util.Objects;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.MongoId;


public class ad_campaigns {
	@Id
	//@MongoId(FieldType.OBJECT_ID)
 private String id;
 private location location; 
 private String compaignsStatus;
 private String createdBy;
 private String advertisementId;
 private dateRange dateRange;
 private ArrayList<String> campaignCategories;
 private advertisements a;
 private companies companies;
 private String phoneNumber;
 private String emailAddress;
 private int noOfFollow;
 private int noOfCampaigns;
 private String fullName;
 private String profilePicturePath;
 public double distance;
 private int giTag; 
 private int temple; 
 private int forest; 
 private int hospital; 
 private int heritage; 
 private int bus;  
 private int car; 
 private int goods; 
 private int rickshaw; 
 private int vlogs;
 private int news;
 public int getVlogs() {
	return vlogs;
}
public void setVlogs(int vlogs) {
	this.vlogs = vlogs;
}
public int getNews() {
	return news;
}
public void setNews(int news) {
	this.news = news;
}
private String whatsappNumber;
 private String takemethere;
 public String getWhatsappNumber() {
	return whatsappNumber;
}
public void setWhatsappNumber(String whatsappNumber) {
	this.whatsappNumber = whatsappNumber;
}
public String getTakemethere() {
	return takemethere;
}
public void setTakemethere(String takemethere) {
	this.takemethere = takemethere;
}
public int getTemple() {
	return temple;
}
public void setTemple(int temple) {
	this.temple = temple;
}
public int getForest() {
	return forest;
}
public void setForest(int forest) {
	this.forest = forest;
}
public int getHospital() {
	return hospital;
}
public void setHospital(int hospital) {
	this.hospital = hospital;
}
public int getHeritage() {
	return heritage;
}
public void setHeritage(int heritage) {
	this.heritage = heritage;
}
public int getBus() {
	return bus;
}
public void setBus(int bus) {
	this.bus = bus;
}
public int getCar() {
	return car;
}
public void setCar(int car) {
	this.car = car;
}
public int getGoods() {
	return goods;
}
public void setGoods(int goods) {
	this.goods = goods;
}
public int getRickshaw() {
	return rickshaw;
}
public void setRickshaw(int rickshaw) {
	this.rickshaw = rickshaw;
}
public int getGiTag() {
	return giTag;
}
public void setGiTag(int giTag) {
	this.giTag = giTag;
}
public double getDistance() {
	return distance;
}
public void setDistance(double distance) {
	this.distance = distance;
}

 public String getProfilePicturePath() {
	return profilePicturePath;
}
public void setProfilePicturePath(String profilePicturePath) {
	this.profilePicturePath = profilePicturePath;
}
public String getFullName() {
	return fullName;
}
public void setFullName(String fullName) {
	this.fullName = fullName;
}
public int getNoOfFollow() {
	return noOfFollow;
}
public void setNoOfFollow(int noOfFollow) {
	this.noOfFollow = noOfFollow;
}
public int getNoOfCampaigns() {
	return noOfCampaigns;
}
public void setNoOfCampaigns(int noOfCampaigns) {
	this.noOfCampaigns = noOfCampaigns;
}


public String getPhoneNumber() {
	return phoneNumber;
}
public void setPhoneNumber(String phoneNumber) {
	this.phoneNumber = phoneNumber;
}
public String getEmailAddress() {
	return emailAddress;
}
public void setEmailAddress(String emailAddress) {
	this.emailAddress = emailAddress;
}
public companies getCompanies() {
	return companies;
}
public void setCompanies(companies companies) {
	this.companies = companies;
}
public advertisements getA() {
	return a;
}
public void setA(advertisements a) {
	this.a = a;
}
public dateRange getDateRange() {
	return dateRange;
}
public void setDateRange(dateRange dateRange) {
	this.dateRange = dateRange;
}
public ArrayList<String> getCampaignCategories() {
	return campaignCategories;
}
public void setCampaignCategories(ArrayList<String> campaignCategories) {
	this.campaignCategories = campaignCategories;
}
public String getAdvertisementId() {
	return advertisementId;
}
public ad_campaigns(String id, org.jackfruit.keliri.model.location location, String compaignsStatus, String createdBy,
		String advertisementId, org.jackfruit.keliri.model.dateRange dateRange, ArrayList<String> campaignCategories) {
	super();
	this.id = id;
	this.location = location;
	this.compaignsStatus = compaignsStatus;
	this.createdBy = createdBy;
	this.advertisementId = advertisementId;
	this.dateRange = dateRange;
	this.campaignCategories = campaignCategories;
}
public void setAdvertisementId(String advertisementId) {
	this.advertisementId = advertisementId;
}


public String getId() {
	return id;
}
public void setId(String id) {
	this.id = id;
}
public location getLocation() {
	return location;
}
public void setLocation(location location) {
	this.location = location;
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
@Override
public int hashCode() {
	return Objects.hash(a, advertisementId, bus, campaignCategories, car, compaignsStatus, companies, createdBy,
			dateRange, distance, emailAddress, forest, fullName, giTag, goods, heritage, hospital, id, location, news,
			noOfCampaigns, noOfFollow, phoneNumber, profilePicturePath, rickshaw, takemethere, temple, vlogs,
			whatsappNumber);
}
@Override
public boolean equals(Object obj) {
	if (this == obj)
		return true;
	if (obj == null)
		return false;
	if (getClass() != obj.getClass())
		return false;
	ad_campaigns other = (ad_campaigns) obj;
	return Objects.equals(a, other.a) && Objects.equals(advertisementId, other.advertisementId) && bus == other.bus
			&& Objects.equals(campaignCategories, other.campaignCategories) && car == other.car
			&& Objects.equals(compaignsStatus, other.compaignsStatus) && Objects.equals(companies, other.companies)
			&& Objects.equals(createdBy, other.createdBy) && Objects.equals(dateRange, other.dateRange)
			&& Double.doubleToLongBits(distance) == Double.doubleToLongBits(other.distance)
			&& Objects.equals(emailAddress, other.emailAddress) && forest == other.forest
			&& Objects.equals(fullName, other.fullName) && giTag == other.giTag && goods == other.goods
			&& heritage == other.heritage && hospital == other.hospital && Objects.equals(id, other.id)
			&& Objects.equals(location, other.location) && news == other.news && noOfCampaigns == other.noOfCampaigns
			&& noOfFollow == other.noOfFollow && Objects.equals(phoneNumber, other.phoneNumber)
			&& Objects.equals(profilePicturePath, other.profilePicturePath) && rickshaw == other.rickshaw
			&& Objects.equals(takemethere, other.takemethere) && temple == other.temple && vlogs == other.vlogs
			&& Objects.equals(whatsappNumber, other.whatsappNumber);
}
@Override
public String toString() {
	return "ad_campaigns [id=" + id + ", location=" + location + ", compaignsStatus=" + compaignsStatus + ", createdBy="
			+ createdBy + ", advertisementId=" + advertisementId + ", dateRange=" + dateRange + ", campaignCategories="
			+ campaignCategories + ", a=" + a + ", companies=" + companies + ", phoneNumber=" + phoneNumber
			+ ", emailAddress=" + emailAddress + ", noOfFollow=" + noOfFollow + ", noOfCampaigns=" + noOfCampaigns
			+ ", fullName=" + fullName + ", profilePicturePath=" + profilePicturePath + ", distance=" + distance
			+ ", giTag=" + giTag + ", temple=" + temple + ", forest=" + forest + ", hospital=" + hospital
			+ ", heritage=" + heritage + ", bus=" + bus + ", car=" + car + ", goods=" + goods + ", rickshaw=" + rickshaw
			+ ", vlogs=" + vlogs + ", news=" + news + ", whatsappNumber=" + whatsappNumber + ", takemethere="
			+ takemethere + "]";
}
public ad_campaigns() {
	// TODO Auto-generated constructor stub
}
}
