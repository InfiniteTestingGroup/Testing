package org.jackfruit.keliri.model;

import java.util.Objects;

public class customTextSectionArrayObject {
	
	private String id;
	private String title;
	private String description;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	@Override
	public int hashCode() {
		return Objects.hash(description, id, title);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		customTextSectionArrayObject other = (customTextSectionArrayObject) obj;
		return Objects.equals(description, other.description) && Objects.equals(id, other.id)
				&& Objects.equals(title, other.title);
	}
	@Override
	public String toString() {
		return "customTextSectionArrayObject [id=" + id + ", title=" + title + ", description=" + description + "]";
	}
	

}
