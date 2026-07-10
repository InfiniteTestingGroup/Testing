package org.jackfruit.keliri.model;
import java.util.Date;
import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "website_hits")
public class hitRecord {

	    @Id
	    private ObjectId id;
	    
	    private Date timestamp;
	    private String latitude;
	    private String longitude;
	    private String userAgent;
        private String campaignId;
        private String advertisementId;
        private String eventType;

	    // Default constructor: Sets the timestamp when the object is created
	    public hitRecord() {
	        this.timestamp = new Date(); 
	    }

	    // --- Getters and Setters ---
	    public ObjectId getId() { return id; }
	    public void setId(ObjectId id) { this.id = id; }

	    public Date getTimestamp() { return timestamp; }
	    public void setTimestamp(Date timestamp) { this.timestamp = timestamp; }

	    public String getLatitude() { return latitude; }
	    public void setLatitude(String latitude) { this.latitude = latitude; }

	    public String getLongitude() { return longitude; }
	    public void setLongitude(String longitude) { this.longitude = longitude; }

	    public String getUserAgent() { return userAgent; }
	    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
        public String getCampaignId() { return campaignId; }
        public void setCampaignId(String campaignId) { this.campaignId = campaignId; }
        public String getAdvertisementId() { return advertisementId; }
        public void setAdvertisementId(String advertisementId) { this.advertisementId = advertisementId; }
        public String getEventType() { return eventType; }
        public void setEventType(String eventType) { this.eventType = eventType; }
	}
