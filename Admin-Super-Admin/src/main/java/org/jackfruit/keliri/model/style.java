package org.jackfruit.keliri.model;

import java.util.Objects;

public class style {
	private String icon;
    private String backgroundColor;
    private String textColor;
    private boolean isToPublisher;
    private String _id;
	@Override
	public String toString() {
		return "style [icon=" + icon + ", backgroundColor=" + backgroundColor + ", textColor=" + textColor
				+ ", isToPublisher=" + isToPublisher + ", _id=" + _id + "]";
	}
	@Override
	public int hashCode() {
		return Objects.hash(_id, backgroundColor, icon, isToPublisher, textColor);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		style other = (style) obj;
		return Objects.equals(_id, other._id) && Objects.equals(backgroundColor, other.backgroundColor)
				&& Objects.equals(icon, other.icon) && isToPublisher == other.isToPublisher
				&& Objects.equals(textColor, other.textColor);
	}
	public String getIcon() {
		return icon;
	}
	public void setIcon(String icon) {
		this.icon = icon;
	}
	public String getBackgroundColor() {
		return backgroundColor;
	}
	public void setBackgroundColor(String backgroundColor) {
		this.backgroundColor = backgroundColor;
	}
	public String getTextColor() {
		return textColor;
	}
	public void setTextColor(String textColor) {
		this.textColor = textColor;
	}
	public boolean isToPublisher() {
		return isToPublisher;
	}
	public void setToPublisher(boolean isToPublisher) {
		this.isToPublisher = isToPublisher;
	}
	public String get_id() {
		return _id;
	}
	public void set_id(String _id) {
		this._id = _id;
	}
}
