package org.jackfruit.keliri;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication

public class KeliriApplication extends SpringBootServletInitializer {//to support war file deployment. Spring Boot Servlet Initializer class file allows you to configure the application when it is launched by using Servlet Container.

	 @Override
	    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
	        return application.sources(KeliriApplication.class);
	    }
	
	public static void main(String[] args) {
		// Force disable AWS EC2 Metadata lookup to prevent crash when running locally
		System.setProperty("aws.disableEc2Metadata", "true");
		
		// Load .env file variables into System properties
		loadEnv();
		
		SpringApplication.run(KeliriApplication.class, args);
		System.out.println("Here we go");
		//extends SpringBootServletInitializer
	}

	private static void loadEnv() {
		String[] paths = {
			".env",
			"../.env",
			"../../.env",
			"Admin-Super-Admin/.env",
			"Admin-Super-Admin/backend/.env"
		};
		java.io.File envFile = null;
		for (String path : paths) {
			java.io.File file = new java.io.File(path);
			if (file.exists() && file.isFile()) {
				envFile = file;
				break;
			}
		}
		if (envFile != null) {
			try {
				java.nio.file.Files.lines(envFile.toPath())
					.map(String::trim)
					.filter(line -> !line.isEmpty() && !line.startsWith("#"))
					.forEach(line -> {
						int delim = line.indexOf('=');
						if (delim > 0) {
							String key = line.substring(0, delim).trim();
							String value = line.substring(delim + 1).trim();
							if (value.startsWith("\"") && value.endsWith("\"")) {
								value = value.substring(1, value.length() - 1);
							} else if (value.startsWith("'") && value.endsWith("'")) {
								value = value.substring(1, value.length() - 1);
							}
							// Support multi-line values like private keys
							value = value.replace("\\n", "\n");
							System.setProperty(key, value);
						}
					});
				System.out.println("✅ [KeliriApplication] Loaded environment variables from: " + envFile.getAbsolutePath());
			} catch (Exception e) {
				System.err.println("❌ [KeliriApplication] Failed to load .env file: " + e.getMessage());
			}
		} else {
			System.out.println("⚠️ [KeliriApplication] No .env file found. Using default environment/system properties.");
		}
	}

}
