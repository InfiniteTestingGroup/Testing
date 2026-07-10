package org.jackfruit.keliri.service;



/*
	    private final S3Client s3Client;

	 /*   @Value("${cloud.aws.region.static}")
	    private String region;

	    @Value("${cloud.aws.s3.bucket-name}")
	    private String bucketName;
*/
	/*    public S3Service(@Value("${cloud.aws.credentials.access-key}") String accessKey,
	                     @Value("${cloud.aws.credentials.secret-key}") String secretKey,  @Value("${cloud.aws.s3.bucket-name}") String bucketName,
	                     @Value("${cloud.aws.region.static}")  String region    ) {
	    	System.out.println("region: " +region +" buck: " +bucketName);
	        AwsBasicCredentials awsCreds = AwsBasicCredentials.create(accessKey, secretKey);
	        this.s3Client = S3Client.builder()
	                .credentialsProvider(StaticCredentialsProvider.create(awsCreds))
	                .region(Region.of(region))
	                .build();
	    //    System.out.println(""+);
	    }
	    */
	/*    public void downloadFile(String keyName, String downloadFilePath) {
	    System.out.println("download");
	        GetObjectRequest getObjectRequest = GetObjectRequest.builder()
	                .bucket("oms-s3-bucket1")
	                .key(keyName)
	                .build();
ResponseInputStream<GetObjectResponse> s = s3Client.getObject(getObjectRequest);
System.out.println("s : " +s);
	        try {
	        	
	        	  // Define your file name and directory
	            String directory = "C:\\Users\\User 1\\Desktop\\kkk\\"; // Change to your actual path
	          //  String fileName = "myFile.txt";

	            // Generate the file path
//	            File file = new File(directory, fileName);

	            // Print the absolute path
	           // System.out.println("File path: " + file.getAbsolutePath());
	            Path path = Path.of(directory);
	            Files.createDirectories(path.getParent()); // Ensure the parent directory exists
	            s3Client.getObject(getObjectRequest, path);
	            System.out.println("File downloaded successfully to " + downloadFilePath);
	        } catch (Exception e) {
	            e.printStackTrace();
	            System.out.println("Error downloading file: " + e.getMessage());
	        }
	    }
*/
	
	
	
	
	
	
	import org.springframework.beans.factory.annotation.Value;
	import org.springframework.stereotype.Service;
	import org.springframework.web.multipart.MultipartFile;
	import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3ClientBuilder;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
	import java.nio.file.Files;
	import java.nio.file.Path;
	import java.util.UUID;

import javax.imageio.ImageIO;

	@Service
	public class S3Service {

		 @Value("${aws.accessKey:}")
		    private String accessKey;

		    @Value("${aws.secretKey:}")
		    private String secretKey;

		    @Value("${aws.region:ap-south-1}")
		    private String region;

		    @Value("${aws.s3.bucketName:keliri-uploads}")
		    private String bucketName;

	    @Value("${aws.s3.endpointUrl:}")
		    private String endpointUrl;

		    @Value("${aws.s3.folder:uploads}")
		    private String uploadFolder;

		    @Value("${aws.s3.thumbnailFolder:thumbnails}")
		    private String thumbnailFolder;

		    private S3Client getS3Client() {
		    	S3ClientBuilder builder = S3Client.builder().region(Region.of(region != null ? region.trim() : "ap-south-1"));

		    	if (accessKey != null && !accessKey.trim().isBlank() && secretKey != null && !secretKey.trim().isBlank()) {
		    		builder.credentialsProvider(StaticCredentialsProvider.create(
		    				AwsBasicCredentials.create(accessKey.trim(), secretKey.trim())
		    		));
		    	} else {
		    		builder.credentialsProvider(DefaultCredentialsProvider.create());
		    	}

		        return builder.build();
		    }

		    public String uploadFile(MultipartFile file) throws IOException {
		    	if (accessKey == null || accessKey.trim().isBlank() || secretKey == null || secretKey.trim().isBlank()) {
		    		System.out.println("[S3Service] AWS keys missing. Returning mock URL for local testing.");
		    		return "https://via.placeholder.com/150?text=" + file.getOriginalFilename();
		    	}
		    	
		    	validateUploadConfiguration();
		        S3Client s3Client = getS3Client();
		        String fileName = UUID.randomUUID()+ "-" + file.getOriginalFilename();
		        String filePath = uploadFolder +"/"+ fileName;
                System.out.println("filePath : " +filePath);
		        Path tempFile = Files.createTempFile("upload-", fileName);
		        Files.write(tempFile, file.getBytes());

		        PutObjectRequest putRequest = PutObjectRequest.builder()
		                .bucket(bucketName)
		                .key(filePath)
		                .contentType(file.getContentType())
		                .build();

		        s3Client.putObject(putRequest, tempFile);
		        Files.delete(tempFile);

		        return endpointUrl + "/"+filePath;
		    }

		    private void validateUploadConfiguration() {
		    	if (bucketName == null || bucketName.trim().isBlank() || endpointUrl == null || endpointUrl.trim().isBlank()) {
		    		throw new IllegalStateException("AWS S3 is not configured. Set aws.s3.bucketName and aws.s3.endpointUrl.");
		    	}
		    }

		    private void uploadToS3(S3Client s3Client, byte[] fileData, String filePath, String contentType) throws IOException {
		        Path tempFile = Files.createTempFile("upload-", filePath);
		        Files.write(tempFile, fileData);

		        PutObjectRequest putRequest = PutObjectRequest.builder()
		                .bucket(bucketName)
		                .key(filePath)
		                .contentType(contentType)
		                .build();

		        s3Client.putObject(putRequest, tempFile);
		        Files.delete(tempFile);
		    }
		    
		  /*  private byte[] generateThumbnail(MultipartFile file) throws IOException {
		        BufferedImage originalImage = ImageIO.read(file.getInputStream());
		        BufferedImage thumbnail = Scalr.resize(originalImage, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_WIDTH, 100);

		        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		        ImageIO.write(thumbnail, "jpg", outputStream);
		        return outputStream.toByteArray();
		    }*/

	}

	
	

