package org.jackfruit.keliri.model;

import java.util.ArrayList;
import java.util.Objects;

public class Content {

	private ArrayList<String> banners;
	 private String videoLink;
	 private String AdText;
	public String getAdText() {
		return AdText;
	}
	public void setAdText(String adText) {
		AdText = adText;
	}
	@Override
	public String toString() {
		return "Content [banners=" + banners + ", videoLink=" + videoLink + ", AdText=" + AdText + "]";
	}
	@Override
	public int hashCode() {
		return Objects.hash(AdText, banners, videoLink);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Content other = (Content) obj;
		return Objects.equals(AdText, other.AdText) && Objects.equals(banners, other.banners)
				&& Objects.equals(videoLink, other.videoLink);
	}
	public ArrayList<String> getBanners() {
		return banners;
	}
	public void setBanners(ArrayList<String> banners) {
		this.banners = banners;
	}
	public String getVideoLink() {
		return videoLink;
	}
	public void setVideoLink(String videoLink) {
		this.videoLink = videoLink;
	}
}
