package org.jackfruit.keliri.model;

import java.util.List;
import java.util.Objects;

public class cta {
	
	    private String ctaType;
	    private List<button> buttons;
		public String getCtaType() {
			return ctaType;
		}
		public void setCtaType(String ctaType) {
			this.ctaType = ctaType;
		}
		public List<button> getButtons() {
			return buttons;
		}
		public void setButtons(List<button> buttons) {
			this.buttons = buttons;
		}
		@Override
		public String toString() {
			return "Cta [ctaType=" + ctaType + "]";
		}
		@Override
		public int hashCode() {
			final int prime = 31;
			int result = 1;
			result = prime * result + getEnclosingInstance().hashCode();
			result = prime * result + Objects.hash(ctaType);
			return result;
		}
		@Override
		public boolean equals(Object obj) {
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			cta other = (cta) obj;
			if (!getEnclosingInstance().equals(other.getEnclosingInstance()))
				return false;
			return Objects.equals(ctaType, other.ctaType);
		}
		private cta getEnclosingInstance() {
			return cta.this;
		} // ✅ Array of Button objects

}
