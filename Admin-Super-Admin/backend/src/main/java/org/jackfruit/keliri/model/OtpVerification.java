package org.jackfruit.keliri.model;

import java.time.Instant;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "otp_verifications")
@CompoundIndex(name = "otp_expiry_idx", def = "{'expiresAt': 1}")
public class OtpVerification {
	
	@Id
	private String id;
	private String mobileNumber;
	private String otpHash;
	private int attempts;
	private Instant expiresAt;

}
