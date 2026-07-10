package org.jackfruit.keliri.model;

import java.util.ArrayList;
import java.util.Objects;
import java.util.Optional;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Document
public class advertisements {
	
@Id
	private String id;
    private String title;
    private String  description;   
	private String company;
	public cta getCta() {
		return cta;
	}
	public void setCta(cta cta) {
		this.cta = cta;
	}
	private String thumbnail;
	private Content content;
	private String adType;
	private ArrayList<customTextSectionArrayObject> customTextSection;
	private int gitagnumber;

	private cta cta;
	public int getGitagnumber() {
		return gitagnumber;
	}
	public void setGitagnumber(int gitagnumber) {
		this.gitagnumber = gitagnumber;
	}
	public ArrayList<customTextSectionArrayObject> getCustomTextSection() {
		return customTextSection;
	}
	public void setCustomTextSection(ArrayList<customTextSectionArrayObject> customTextSection) {
		this.customTextSection = customTextSection;
	}
	public String getAdType() {
		return adType;
	}
	public void setAdType(String adType) {
		this.adType = adType;
	}
	public String getThumbnail() {
		return thumbnail;
	}
	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
	}
	public Content getContent() {
		return content;
	}
	public void setContent(Content content) {
		this.content = content;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
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
		return Objects.hash(adType, company, content, cta, customTextSection, description, gitagnumber, id, thumbnail,
				title);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		advertisements other = (advertisements) obj;
		return Objects.equals(adType, other.adType) && Objects.equals(company, other.company)
				&& Objects.equals(content, other.content) && Objects.equals(cta, other.cta)
				&& Objects.equals(customTextSection, other.customTextSection)
				&& Objects.equals(description, other.description) && gitagnumber == other.gitagnumber
				&& Objects.equals(id, other.id) && Objects.equals(thumbnail, other.thumbnail)
				&& Objects.equals(title, other.title);
	}
	@Override
	public String toString() {
		return "advertisements [id=" + id + ", title=" + title + ", description=" + description + ", company=" + company
				+ ", thumbnail=" + thumbnail + ", content=" + content + ", adType=" + adType + ", customTextSection="
				+ customTextSection + ", gitagnumber=" + gitagnumber + ", cta=" + cta + "]";
	}
	public advertisements(String title, String description) {
		super();
		//this._id = id;
		this.title = title;
		this.description = description;
	}
	public advertisements(String _id, String title, String description, String company, String thumbnail,
			Content content, String adType) {
		super();
		this.id = _id;
		this.title = title;
		this.description = description;
		this.company = company;
		this.thumbnail = thumbnail;
		this.content = content;
		this.adType = adType;
	}
	public advertisements() {
		// TODO Auto-generated constructor stub
	}
	
}
