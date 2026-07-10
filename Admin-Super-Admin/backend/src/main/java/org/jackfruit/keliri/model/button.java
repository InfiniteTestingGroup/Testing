package org.jackfruit.keliri.model;

import java.util.Objects;

public class button {
	 private String ctaId;
	    private contenta content;
	    private style style;
	    private boolean isToPublisher;
	    @Override
		public String toString() {
			return "button [ctaId=" + ctaId + ", content=" + content + ", style=" + style + ", isToPublisher="
					+ isToPublisher + ", _id=" + _id + "]";
		}
		@Override
		public int hashCode() {
			return Objects.hash(_id, content, ctaId, isToPublisher, style);
		}
		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			button other = (button) obj;
			return Objects.equals(_id, other._id) && Objects.equals(content, other.content)
					&& Objects.equals(ctaId, other.ctaId) && isToPublisher == other.isToPublisher
					&& Objects.equals(style, other.style);
		}
		public String getCtaId() {
			return ctaId;
		}
		public void setCtaId(String ctaId) {
			this.ctaId = ctaId;
		}
		public contenta getContent() {
			return content;
		}
		public void setContent(contenta content) {
			this.content = content;
		}
		public style getStyle() {
			return style;
		}
		public void setStyle(style style) {
			this.style = style;
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
		private String _id;
}
