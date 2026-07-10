package org.jackfruit.keliri.service;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.UUID;
import java.util.stream.Stream;

import org.springframework.stereotype.Service;

@Service
public class hitFileService {

	// Define the file name. Using CSV for easy writing/reading.
    private static final String FILENAME = "website_hits_log.csv";
    
    // Define the file header including the new UniqueID field.
    private static final String HEADER = "UniqueID,Timestamp,Latitude,Longitude,UserAgent\n"; // <--- NEW HEADER

    /**
     * Retrieves the Path object using the current working directory, which is OS-agnostic.
     * @return Path object for the log file.
     */
    private Path getFilePath() {
        // Paths.get handles OS-specific path separators (/, \) automatically.
        // It uses the application's starting directory (user.dir) as the base.
        String appRoot = System.getProperty("user.dir");
        return Paths.get(appRoot, FILENAME);
    }

    /**
     * Creates the file and writes the header if the file does not already exist.
     */
    private void initializeFile() {
        Path filePath = getFilePath();
        if (!Files.exists(filePath)) {
            try {
                // Create the file and write the header row
                Files.writeString(filePath, HEADER);
                System.out.println("Created new hit log file: " + FILENAME + " and wrote header.");
                System.out.println("Log file path: " + filePath.toAbsolutePath().toString());
            } catch (IOException e) {
                System.err.println("Error creating or writing header to hit log file: " + e.getMessage());
            }
        }
    }

    /**
     * Appends a new hit record to the log file, including a unique ID.
     * @param lat The latitude string.
     * @param lng The longitude string.
     * @param userAgent The User-Agent string.
     */
    public synchronized void writeHit(String lat, String lng, String userAgent) {
        initializeFile(); // Ensure the file and header exist
        
        // Generate a Unique ID for this hit
        String uniqueId = UUID.randomUUID().toString(); // <--- NEW UNIQUE ID

        // Format the data into a CSV line
        String timestamp = new Date().toString();
        
        // Data is enclosed in quotes to handle commas within the UserAgent string.
        String dataLine = String.format("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"\n", 
                                        uniqueId,
                                        timestamp, 
                                        lat, 
                                        lng, 
                                        // Clean up UserAgent string to prevent CSV format breakage
                                        userAgent.replace("\"", "'").replace("\n", "")); 

        try (BufferedWriter writer = new BufferedWriter(
                new FileWriter(getFilePath().toFile(), true))) { // 'true' enables append mode
            
            writer.write(dataLine);
            System.out.println("Appended new hit to " + FILENAME + " (ID: " + uniqueId + ")");
            
        } catch (IOException e) {
            System.err.println("Error writing hit data to file: " + e.getMessage());
        }
    }

    /**
     * Reads the log file and returns the total number of hit records.
     * @return The total number of recorded hits (lines - 1 for the header).
     */
    public long getHitCount() {
        Path filePath = getFilePath();
        if (!Files.exists(filePath)) {
            return 0;
        }
        
        try (Stream<String> lines = Files.lines(filePath)) {
            // Count all lines, then subtract 1 for the header
            return Math.max(0, lines.count() - 1); 
        } catch (IOException e) {
            System.err.println("Error reading hit count from file: " + e.getMessage());
            return 0; 
        }
    }
}
