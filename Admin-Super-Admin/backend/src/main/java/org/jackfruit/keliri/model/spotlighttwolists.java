package org.jackfruit.keliri.model;

import java.util.List;
import java.util.Objects;

public class spotlighttwolists {
private List<users> usersList1;
private List<ad_campaigns> adsList2;
public List<users> getUsersList1() {
	return usersList1;
}
public void setUsersList1(List<users> usersList1) {
	this.usersList1 = usersList1;
}
public List<ad_campaigns> getAdsList2() {
	return adsList2;
}
public void setAdsList2(List<ad_campaigns> adsList2) {
	this.adsList2 = adsList2;
}
@Override
public int hashCode() {
	return Objects.hash(adsList2, usersList1);
}
@Override
public boolean equals(Object obj) {
	if (this == obj)
		return true;
	if (obj == null)
		return false;
	if (getClass() != obj.getClass())
		return false;
	spotlighttwolists other = (spotlighttwolists) obj;
	return Objects.equals(adsList2, other.adsList2) && Objects.equals(usersList1, other.usersList1);
}
@Override
public String toString() {
	return "spotlighttwolists [usersList1=" + usersList1 + ", adsList2=" + adsList2 + "]";
}
public spotlighttwolists(List<users> usersList1, List<ad_campaigns> adsList2) {
	super();
	this.usersList1 = usersList1;
	this.adsList2 = adsList2;
}


}
