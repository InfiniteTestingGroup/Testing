package org.jackfruit.keliri.model;

import java.util.Date;
import java.util.Objects;

public class dateRange {

	Date fromDate;
	
	Date toDate;

	public Date getFromDate() {
		return fromDate;
	}

	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}

	public Date getToDate() {
		return toDate;
	}

	public void setToDate(Date toDate) {
		this.toDate = toDate;
	}

	@Override
	public int hashCode() {
		return Objects.hash(fromDate, toDate);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		dateRange other = (dateRange) obj;
		return Objects.equals(fromDate, other.fromDate) && Objects.equals(toDate, other.toDate);
	}

	@Override
	public String toString() {
		return "dateRange [fromDate=" + fromDate + ", toDate=" + toDate + "]";
	}
	public dateRange() {
		// TODO Auto-generated constructor stub
	}
	
}
