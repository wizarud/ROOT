package servlet.campaign;

import java.io.*;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.wayos.Configuration;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.stream.Collectors;
import java.util.zip.CRC32;
import java.nio.file.StandardOpenOption;
import java.time.Instant;

@WebServlet("/g")
public class GenerateLyricsBotServlet extends HttpServlet {
	
    private static final String CONTEXT_ID = "demo";
    private static final String APP_ID = "songbook";
    private static final String CONFIG_PATH = System.getenv("storagePath") + "/ROOT/libs/" + CONTEXT_ID + "/LyricsTemplate.context";
    private static final String SAVE_DIRECTORY = System.getenv("storagePath") + "/ROOT/libs/";
    private static final String PUBLIC_DIRECTORY = System.getenv("storagePath") + "/ROOT/public/" + CONTEXT_ID + "/";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	
    	
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	request.setCharacterEncoding("UTF-8");    	
        response.setContentType("text/plain; charset=UTF-8");
    	
        String lyrics = request.getParameter("lyrics");
        
        /**
         * Create New Lyrics Song
         * Succeed: Return to lyrics record app
         */
        if (lyrics!=null) {
        	        	
        	String title = request.getParameter("title");
            String imageURL = request.getParameter("imageURL");
            String audioURL = request.getParameter("audioURL");
            
            if (title == null || imageURL == null || audioURL == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters, title, lyrics, imageURL and audioURL");
                return;
            }
            
            title = title.replace("\n", "\\n");//Escape New Line
        	lyrics = lyrics.replace("\n", "\\n");//Escape New Line
        	
        	//Encode imageURL to prevent space and special characters
            String imageFileName = URLEncoder.encode(imageURL.substring(imageURL.lastIndexOf("/") + 1), "UTF-8");
        	imageURL = imageURL.substring(0, imageURL.lastIndexOf("/")) + "/" + imageFileName;
            
        	//Encode audioURL to prevent space and special characters
            String audioFileName = URLEncoder.encode(audioURL.substring(audioURL.lastIndexOf("/") + 1), "UTF-8");
        	audioURL = audioURL.substring(0, audioURL.lastIndexOf("/")) + "/" + audioFileName;
        	
            String template = loadContextTemplate();
            if (template == null) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load template");
                return;
            }
            
            long utcTimestamp = Instant.now().getEpochSecond();
            String botId = convertToBase36(utcTimestamp);
            
            String widgetURL = Configuration.domain + "/lyrics/" + CONTEXT_ID + "/" + botId;
            
            String result = template.replace("{title}", title)
            						.replace("{widgetURL}", widgetURL)
            						.replace("{lyrics}", lyrics)
                                    .replace("{imageURL}", imageURL)
                                    .replace("{audioURL}", audioURL);
            
            String contextName = CONTEXT_ID + "/" + botId; 
            
            saveContext(result, contextName);
                        
            copyImageFile(imageFileName, botId);
                        
            response.getWriter().write(contextName);
        	
            return;
        }
        
        /**
         * Update Time Indices
         * Succeed: Return to songbook with message=afterRecord <contextName>
         */    	
        String timeIndices = request.getParameter("timeIndices");
        
        if (timeIndices!=null) {
        	
            String contextName = request.getParameter("contextName");
            
            if (contextName == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameter: timeIndices or contextName");
                return;
            }
            
            timeIndices = timeIndices.replace("\n", "\\n");//Escape New Line
            
            String template = loadContextTemplate(contextName);
            if (template == null) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load template");
                return;
            }
            
            String result = template.replace("{timeIndices}", timeIndices);
            
            saveContext(result, contextName);
                        
            String lyricsURL = Configuration.domain + "/x/" + CONTEXT_ID + "/" + APP_ID + "?message=afterRecord " + contextName;
            
            response.getWriter().write(lyricsURL);
        	
            return;
        }
        
        /**
         * Delete contextName
         */
        String contextName = request.getParameter("contextName");

        if (contextName != null) {
        	
        	deleteContext(contextName);
        	
            response.getWriter().write("greeting");//Reinit bot
            
            return;
        }
        
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameter: lyrics, timeIndices or contextName");
    }

    public static String convertToBase36(long timestamp) {
        CRC32 crc = new CRC32();
        crc.update(Long.toString(timestamp).getBytes());
        long checksum = crc.getValue();
        return Long.toString(checksum, 36); // Convert to Base36
    }
    
    private String loadContextTemplate() {
        try {
            return Files.lines(Paths.get(CONFIG_PATH)).collect(Collectors.joining("\n"));
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    private String loadContextTemplate(String contextName) {
        try {
            return Files.lines(Paths.get(SAVE_DIRECTORY + contextName + ".context")).collect(Collectors.joining("\n"));
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private void saveContext(String content, String contextName) {
        try {
            Files.write(Paths.get(SAVE_DIRECTORY + contextName + ".context"), content.getBytes(), StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private void deleteContext(String contextName) {
        try {
        	Files.delete(Paths.get(SAVE_DIRECTORY + contextName + ".context"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private void copyImageFile(String imagePath, String filename) {
        try (InputStream in = new FileInputStream(PUBLIC_DIRECTORY + imagePath)) {
            Files.copy(in, Paths.get(PUBLIC_DIRECTORY + filename + ".PNG"), StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private String [] list(String contextId) {
    	return null;
    }
    
}

