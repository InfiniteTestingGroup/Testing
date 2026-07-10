package org.jackfruit.keliri.model;

import java.util.ArrayList;
import java.util.Objects;

import org.bson.types.ObjectId;

public class postmanClass {
	private ArrayList<ObjectId> selectedcattype;
	private location location;
	private String spotlight;
	private double  kilomtrs;
		public double getKilomtrs() {
		return kilomtrs;
	}
	public void setKilomtrs(double kilomtrs) {
		this.kilomtrs = kilomtrs;
	}
		public String getSpotlight() {
		return spotlight;
	}
	public void setSpotlight(String spotlight) {
		this.spotlight = spotlight;
	}
	public ArrayList<ObjectId> getSelectedcattype() {
		return selectedcattype;
	}
	public void setSelectedcattype(ArrayList<ObjectId> selectedcattype) {
		this.selectedcattype = selectedcattype;
	}
	public location getLocation() {
		return location;
	}
	public void setLocation(location location) {
		this.location = location;
	}
	@Override
	public int hashCode() {
		return Objects.hash(kilomtrs, location, selectedcattype, spotlight);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		postmanClass other = (postmanClass) obj;
		return Double.doubleToLongBits(kilomtrs) == Double.doubleToLongBits(other.kilomtrs)
				&& Objects.equals(location, other.location) && Objects.equals(selectedcattype, other.selectedcattype)
				&& Objects.equals(spotlight, other.spotlight);
	}
	@Override
	public String toString() {
		return "postmanClass [selectedcattype=" + selectedcattype + ", location=" + location + ", spotlight="
				+ spotlight + ", kilomtrs=" + kilomtrs + "]";
	}
	

}
