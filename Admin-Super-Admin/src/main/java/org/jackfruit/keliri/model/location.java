package org.jackfruit.keliri.model;

import java.util.Objects;

public class location {
	public String lat;
	public String lng;
	private Integer range;
	private String locationName;

	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}

	public location(String lat, String lng, int range) {
		super();
		this.lat = lat;
		this.lng = lng;
		this.range = range;
	}

	public Integer getRange() {
		return range == null ? 0 : range;
	}

	public void setRange(Double range) {
		this.range = range == null ? null : range.intValue();
	}

	public void setRange(Integer range) {
		this.range = range;
	}

	@Override
	public String toString() {
		return "location [lat=" + lat + ", lng=" + lng + ", range=" + range + ", locationName=" + locationName + "]";
	}

	@Override
	public int hashCode() {
		return Objects.hash(lat, lng, locationName, range);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		location other = (location) obj;
		return Objects.equals(lat, other.lat) && Objects.equals(lng, other.lng)
				&& Objects.equals(locationName, other.locationName) && Objects.equals(range, other.range);
	}

	public String getLat() {
		return lat;
	}

	public void setLat(String lat) {
		this.lat = lat;
	}

	public String getLng() {
		return lng;
	}

	public void setLng(String lng) {
		this.lng = lng;
	}

	public location() {
		// TODO Auto-generated constructor stub
	}
}
