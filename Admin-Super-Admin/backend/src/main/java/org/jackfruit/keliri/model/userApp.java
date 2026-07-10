package org.jackfruit.keliri.model;

import java.time.Instant;

import org.springframework.data.annotation.Id;

public class userApp {
	
	@Id
	private String id;
	private String mobileNumber;
	private Instant createdAt;
	private Instant lastLogin;
	private AccountStatus accountStatus;

}

