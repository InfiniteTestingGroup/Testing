package org.jackfruit.keliri.model;

import java.util.Map;
import java.util.Objects;

public class buttonActionDTO {
	
	/*
	    private String ctaId;
	    private String action;  // Can be String or complex object

	    

	    public String getCtaId() {
	        return ctaId;
	    }

	    public void setCtaId(String ctaId) {
	        this.ctaId = ctaId;
	    }

	    public Object getAction() {
	        return action;
	    }

	    public void setAction(String action) {
	        this.action = action;
	    }

		
		
		 @Override
		public String toString() {
			return "buttonActionDTO [ctaId=" + ctaId + ", action=" + action + "]";
		}

		@Override
		public int hashCode() {
			return Objects.hash(action, ctaId);
		}

		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			buttonActionDTO other = (buttonActionDTO) obj;
			return Objects.equals(action, other.action) && Objects.equals(ctaId, other.ctaId);
		}

		public buttonActionDTO(String ctaId, Object actionObj) {
		        this.ctaId = ctaId;

		        if (actionObj instanceof String) {
		            this.action = (String) actionObj;
		        } else if (actionObj instanceof Map) {
		            Map<?, ?> map = (Map<?, ?>) actionObj;
		            this.action = (String) map.get("shareLink");  // extract shareLink if exists
		        } else {
		            this.action = null;
		        }
		    }
		    */
	
	
	/*  private String ctaId;
	    private String action;

	    public buttonActionDTO(String ctaId, String action) {
	        this.ctaId = ctaId;
	        this.action = action;
	    }

	    public String getCtaId() {
	        return ctaId;
	    }

	    public void setCtaId(String ctaId) {
	        this.ctaId = ctaId;
	    }

	    public String getAction() {
	        return action;
	    }

	    public void setAction(String action) {
	        this.action = action;
	    }

	    @Override
	    public String toString() {
	        return "buttonActionDTO [ctaId=" + ctaId + ", action=" + action + "]";
	    }

	    @Override
	    public int hashCode() {
	        return Objects.hash(ctaId, action);
	    }

	    @Override
	    public boolean equals(Object obj) {
	        if (this == obj) return true;
	        if (obj == null || getClass() != obj.getClass()) return false;
	        buttonActionDTO other = (buttonActionDTO) obj;
	        return Objects.equals(ctaId, other.ctaId) && Objects.equals(action, other.action);
	    }*/
	
	
	 private String ctaId;
	    private String actionType; // "STRING" or "LOCATION"
	    private String action;     // for String actions (phone/WhatsApp)
	    private Double latitude;   // for location-based actions
	    private Double longitude;  // for location-based actions

	    public buttonActionDTO() {}

	    public buttonActionDTO(String ctaId, String action) {
	        this.ctaId = ctaId;
	        this.action = action;
	        this.actionType = "STRING";
	    }

	    public buttonActionDTO(String ctaId, Double latitude, Double longitude) {
	        this.ctaId = ctaId;
	        this.latitude = latitude;
	        this.longitude = longitude;
	        this.actionType = "LOCATION";
	    }

	    public String getCtaId() {
	        return ctaId;
	    }

	    public void setCtaId(String ctaId) {
	        this.ctaId = ctaId;
	    }

	    public String getAction() {
	        return action;
	    }

	    public void setAction(String action) {
	        this.action = action;
	    }

	    public Double getLatitude() {
	        return latitude;
	    }

	    public void setLatitude(Double latitude) {
	        this.latitude = latitude;
	    }

	    public Double getLongitude() {
	        return longitude;
	    }

	    public void setLongitude(Double longitude) {
	        this.longitude = longitude;
	    }

	    public String getActionType() {
	        return actionType;
	    }

	    public void setActionType(String actionType) {
	        this.actionType = actionType;
	    }

	    @Override
	    public String toString() {
	        return "buttonActionDTO [ctaId=" + ctaId 
	                + ", actionType=" + actionType 
	                + ", action=" + action 
	                + ", latitude=" + latitude 
	                + ", longitude=" + longitude + "]";
	    }

	    @Override
	    public int hashCode() {
	        return Objects.hash(ctaId, action, latitude, longitude, actionType);
	    }

	    @Override
	    public boolean equals(Object obj) {
	        if (this == obj) return true;
	        if (obj == null || getClass() != obj.getClass()) return false;
	        buttonActionDTO other = (buttonActionDTO) obj;
	        return Objects.equals(ctaId, other.ctaId)
	                && Objects.equals(action, other.action)
	                && Objects.equals(latitude, other.latitude)
	                && Objects.equals(longitude, other.longitude)
	                && Objects.equals(actionType, other.actionType);
	    }

	}



