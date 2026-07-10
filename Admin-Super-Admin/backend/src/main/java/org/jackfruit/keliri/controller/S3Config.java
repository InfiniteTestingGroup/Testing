package org.jackfruit.keliri.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;

/*
	@Configuration
	public class S3Config {

	    @Bean
	    public S3Client s3Client() {
	        return S3Client.builder()
	                .credentialsProvider(StaticCredentialsProvider.create(
	                        AwsBasicCredentials.create(
	                                System.getProperty("aws.accessKeyId"),
	                                System.getProperty("aws.secretKey")
	                        )))
	                .region(Region.of(System.getProperty("aws.region")))
	                .build();
	    }*/
//}*/

@Configuration
public class S3Config {

    @Value("${aws.accessKey:}")
    private String accessKey;

    @Value("${aws.secretKey:}")
    private String secretKey;

    @Value("${aws.region:ap-south-1}")
    private String region;

    @Bean
    public S3Client s3Client() {
        if (accessKey != null && !accessKey.isBlank() && secretKey != null && !secretKey.isBlank()) {
            return S3Client.builder()
                    .region(Region.of(region))
                    .credentialsProvider(StaticCredentialsProvider.create(
                            AwsBasicCredentials.create(accessKey, secretKey)
                    ))
                    .build();
        }
        
        // Fallback to default provider (env vars, credentials file, etc.)
        return S3Client.builder()
                .region(Region.of(region))
                .credentialsProvider(DefaultCredentialsProvider.create())
                .build();
    }
}
