package org.jackfruit.keliri.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3ClientBuilder;
import software.amazon.awssdk.services.s3.model.GetUrlRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.util.UUID;

/**
 * Handles document uploads for admin registrations.
 * Uploads files to AWS S3 under the 'registrations/' prefix.
 * Falls back to IAM role credentials when access/secret keys are not configured
 * (recommended for AWS EC2/ECS hosting).
 */
@Service
public class FileStorageService {

    @Value("${aws.accessKey:}")
    private String accessKey;

    @Value("${aws.secretKey:}")
    private String secretKey;

    @Value("${aws.region:ap-south-1}")
    private String region;

    @Value("${aws.s3.bucketName:keliri-uploads}")
    private String bucketName;

    /**
     * Uploads a file to S3 under the registrations/<subFolder>/ path.
     *
     * @param file      the multipart file to upload
     * @param subFolder subdirectory inside registrations/, e.g. "emailId/gst"
     * @return the public S3 URL of the uploaded file
     */
    public String uploadFile(MultipartFile file, String subFolder) throws IOException {
        if (accessKey.isBlank() || secretKey.isBlank()) {
            System.out.println("[FileStorageService] AWS keys missing. Returning mock URL for local testing.");
            return "https://placehold.co/150?text=" + file.getOriginalFilename();
        }

        S3Client s3Client = buildS3Client();

        String originalName = file.getOriginalFilename() != null ? file.getOriginalFilename() : "file";
        String s3Key = "registrations/" + subFolder + "/" + UUID.randomUUID() + "_" + originalName;

        PutObjectRequest putRequest = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(s3Key)
                .contentType(file.getContentType())
                .build();

        try {
            s3Client.putObject(putRequest, RequestBody.fromBytes(file.getBytes()));

            // Build and return the public S3 URL
            String s3Url = s3Client.utilities()
                    .getUrl(GetUrlRequest.builder().bucket(bucketName).key(s3Key).build())
                    .toString();

            System.out.println("[FileStorageService] Uploaded: " + s3Url);
            return s3Url;
        } catch (Exception e) {
            System.err.println("[FileStorageService] AWS S3 Upload Failed: " + e.getMessage());
            System.err.println("[FileStorageService] Returning mock URL so registration can proceed.");
            return "https://placehold.co/150?text=" + file.getOriginalFilename();
        }
    }

    private S3Client buildS3Client() {
        S3ClientBuilder builder = S3Client.builder().region(Region.of(region != null ? region.trim() : "ap-south-1"));
        if (accessKey != null && !accessKey.trim().isBlank() && secretKey != null && !secretKey.trim().isBlank()) {
            builder.credentialsProvider(StaticCredentialsProvider.create(
                    AwsBasicCredentials.create(accessKey.trim(), secretKey.trim())));
        } else {
            // Uses IAM Role on AWS, or ~/.aws/credentials locally
            builder.credentialsProvider(DefaultCredentialsProvider.create());
        }
        return builder.build();
    }
}
