package org.jackfruit.keliri.model;

import java.util.Map;
import java.util.Objects;

public class action {
	 /*private double latitude;
	    private double longitude;
	    private String shareLink;
		@Override
		public String toString() {
			return "action [latitude=" + latitude + ", longitude=" + longitude + ", shareLink=" + shareLink + "]";
		}
		@Override
		public int hashCode() {
			return Objects.hash(latitude, longitude, shareLink);
		}
		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			action other = (action) obj;
			return Double.doubleToLongBits(latitude) == Double.doubleToLongBits(other.latitude)
					&& Double.doubleToLongBits(longitude) == Double.doubleToLongBits(other.longitude)
					&& Objects.equals(shareLink, other.shareLink);
		}
		public double getLatitude() {
			return latitude;
		}
		public void setLatitude(double latitude) {
			this.latitude = latitude;
		}
		public double getLongitude() {
			return longitude;
		}
		public void setLongitude(double longitude) {
			this.longitude = longitude;
		}
		public String getShareLink() {
			return shareLink;
		}
		public void setShareLink(String shareLink) {
			this.shareLink = shareLink;
		}*/
	
	
	 private String value; // for simple strings like phone or WhatsApp
	    private Double lat;   // for location
	    private Double lng;

	    public action() {}

	    public action(Object actionObj) {
	        if (actionObj instanceof String) {
	            this.value = (String) actionObj;
	        } else if (actionObj instanceof Map) {
	            Map<?, ?> map = (Map<?, ?>) actionObj;
	            if (map.get("lat") != null && map.get("lng") != null) {
	                this.lat = ((Number) map.get("lat")).doubleValue();
	                this.lng = ((Number) map.get("lng")).doubleValue();
	            } else if (map.get("shareLink") != null) {
	                this.value = (String) map.get("shareLink");
	            }
	        }
	    }

	    public String getValue() {
	        return value;
	    }

	    public Double getLat() {
	        return lat;
	    }

	    public Double getLng() {
	        return lng;
	    }

	    @Override
	    public String toString() {
	        if (value != null) return value;
	        if (lat != null && lng != null) return "lat=" + lat + ", lng=" + lng;
	        return null;
	    }

}
