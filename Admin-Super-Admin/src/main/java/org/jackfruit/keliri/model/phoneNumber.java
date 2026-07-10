package org.jackfruit.keliri.model;

import java.util.Objects;

public class phoneNumber {
	private String countryCode;
	private String dialNumber;
	public String getCountryCode() {
		return countryCode;
	}
	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}
	public String getDialNumber() {
		return dialNumber;
	}
	public void setDialNumber(String dialNumber) {
		this.dialNumber = dialNumber;
	}
	@Override
	public int hashCode() {
		return Objects.hash(countryCode, dialNumber);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		phoneNumber other = (phoneNumber) obj;
		return Objects.equals(countryCode, other.countryCode) && Objects.equals(dialNumber, other.dialNumber);
	}
	@Override
	public String toString() {
		return "phoneNumber [countryCode=" + countryCode + ", dialNumber=" + dialNumber + "]";
	}
	

}
