package org.jackfruit.keliri.model;

import java.util.Objects;

public class contenta {
	private String label;
    private String buttonType;
    private Object action; //can%20be%20String%20or%20Action%20object
	@Override
	public String toString() {
		return "contenta [label=" + label + ", buttonType=" + buttonType + ", action=" + action + "]";
	}
	@Override
	public int hashCode() {
		return Objects.hash(action, buttonType, label);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		contenta other = (contenta) obj;
		return Objects.equals(action, other.action) && Objects.equals(buttonType, other.buttonType)
				&& Objects.equals(label, other.label);
	}
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public String getButtonType() {
		return buttonType;
	}
	public void setButtonType(String buttonType) {
		this.buttonType = buttonType;
	}
	public Object getAction() {
		return action;
	}
	public void setAction(Object action) {
		this.action = action;
	}
}
