package org.jackfruit.keliri.model;

import java.util.Objects;

public class location {
	public String lat;
	public String lng;
	private Integer range;
	private String locationName;

	public location() {
	}

	public location(String lat, String lng, Integer range) {
		this.lat = lat;
		this.lng = lng;
		this.range = range;
	}

	// ✅ THE FIX - null-safe, no NPE on unboxing
	public int getRange() {
		return range != null ? range : 0;
	}

	public void setRange(double range) {
		this.range = (int) range;
	}

	public void setRange(Integer range) {
		this.range = range;
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

	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
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
}