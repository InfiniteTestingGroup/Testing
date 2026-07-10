package org.jackfruit.keliri.model;

import java.util.ArrayList;
import java.util.Objects;

public class customTextSection {
	
	private ArrayList<customTextSectionArrayObject> customArray;

	@Override
	public String toString() {
		return "customTextSection [customArray=" + customArray + "]";
	}

	@Override
	public int hashCode() {
		return Objects.hash(customArray);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		customTextSection other = (customTextSection) obj;
		return Objects.equals(customArray, other.customArray);
	}

	public ArrayList<customTextSectionArrayObject> getCustomArray() {
		return customArray;
	}

	public void setCustomArray(ArrayList<customTextSectionArrayObject> customArray) {
		this.customArray = customArray;
	}
	

}
