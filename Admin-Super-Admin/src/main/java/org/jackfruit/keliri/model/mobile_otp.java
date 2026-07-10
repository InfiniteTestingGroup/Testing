package org.jackfruit.keliri.model;

import java.time.LocalDateTime;
import java.util.Objects;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
public class mobile_otp {

	@Id
	String id;
	String mobile_otp_number;
	int  mobile_otp_value;
	
	String mobile_otp_reason;
	LocalDateTime   mobile_otp_expiry_time;
	int mobile_otp_status;
	LocalDateTime mobile_otp_confirm_time; 
	
	public void setMobile_otp_value(int mobile_otp_value) {
		this.mobile_otp_value = mobile_otp_value;
	}
	
	public int getMobile_otp_value() {
		return mobile_otp_value;
	}
	public void setMobile_otp_status(int mobile_otp_status) {
		this.mobile_otp_status = mobile_otp_status;
	}
	@Override
	public String toString() {
		return "mobileOtp [id=" + id + ", mobile_otp_number=" + mobile_otp_number + ", mobile_otp_value="
				+ mobile_otp_value + ", mobile_otp_reason=" + mobile_otp_reason + ", mobile_otp_expiry_time="
				+ mobile_otp_expiry_time + ", mobile_otp_status=" + mobile_otp_status + ", mobile_otp_confirm_time="
				+ mobile_otp_confirm_time + "]";
	}
	@Override
	public int hashCode() {
		return Objects.hash(id, mobile_otp_confirm_time, mobile_otp_expiry_time, mobile_otp_number, mobile_otp_reason,
				mobile_otp_status, mobile_otp_value);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		mobile_otp other = (mobile_otp) obj;
		return Objects.equals(id, other.id) && Objects.equals(mobile_otp_confirm_time, other.mobile_otp_confirm_time)
				&& Objects.equals(mobile_otp_expiry_time, other.mobile_otp_expiry_time)
				&& Objects.equals(mobile_otp_number, other.mobile_otp_number)
				&& Objects.equals(mobile_otp_reason, other.mobile_otp_reason)
				&& mobile_otp_status == other.mobile_otp_status && mobile_otp_value == other.mobile_otp_value;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getMobile_otp_number() {
		return mobile_otp_number;
	}
	public void setMobile_otp_number(String mobile_otp_number) {
		this.mobile_otp_number = mobile_otp_number;
	}
	
	public String getMobile_otp_reason() {
		return mobile_otp_reason;
	}
	public void setMobile_otp_reason(String mobile_otp_reason) {
		this.mobile_otp_reason = mobile_otp_reason;
	}
	
	public LocalDateTime getMobile_otp_expiry_time() {
		return mobile_otp_expiry_time;
	}
	public void setMobile_otp_expiry_time(LocalDateTime mobile_otp_expiry_time) {
		this.mobile_otp_expiry_time = mobile_otp_expiry_time;
	}
	public LocalDateTime getMobile_otp_confirm_time() {
		return mobile_otp_confirm_time;
	}
	public void setMobile_otp_confirm_time(LocalDateTime mobile_otp_confirm_time) {
		this.mobile_otp_confirm_time = mobile_otp_confirm_time;
	}
	public int getMobile_otp_status() {
		return mobile_otp_status;
	}
	
}
