package servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;

@WebServlet("/VesionCheckerServlet")
public class VesionCheckerServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
    private static final String owner = "wizarud";
    private static final String repo = "ROOT";
    
    private String readLocalVersion() {
    	
    	Properties props = new Properties();
    	
    	try (InputStream in = getClass().getClassLoader().getResourceAsStream("version.properties")) {
    		
    	    if (in != null) {
    	        props.load(in);
    	    }
    	    
        	String version = props.getProperty("app.version");
        	
        	return version;
        	
    	} catch (Exception e) {
			e.printStackTrace();
		}    	
    	
    	return null;    	
    }

    // Read version from remote pom.xml
    private String readPomVersion(String url) {
    	
        try (InputStream is = new URL(url).openStream()) {
        	
            DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            Document doc = dBuilder.parse(is);
            doc.getDocumentElement().normalize();
            
            return doc.getElementsByTagName("version").item(0).getTextContent();
        	
		} catch (Exception e) {
			e.printStackTrace();
		}
        
        return null;
    }
    
    // Get latest tag from GitHub API
    private static String getLatestTag(String owner, String repo) {
        try {
            String json = httpGet("https://api.github.com/repos/" + owner + "/" + repo + "/tags");
            return extractValue(json, "name"); // First tag
        } catch (Exception e) {
            throw new RuntimeException("Failed to get latest tag", e);
        }
    }
    
    // HTTP GET
    private static String httpGet(String urlStr) throws Exception {
        HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/vnd.github+json");
        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = in.readLine()) != null) sb.append(line);
        in.close();
        return sb.toString();
    }

    // Extract simple JSON value
    private static String extractValue(String json, String key) {
        int idx = json.indexOf("\"" + key + "\"");
        if (idx == -1) return null;
        int colon = json.indexOf(":", idx);
        int q1 = json.indexOf("\"", colon + 1);
        int q2 = json.indexOf("\"", q1 + 1);
        return json.substring(q1 + 1, q2);
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
    	/**
    	 * Use the same tag name for all dependencies
    	 */
        String branchOrTag = getLatestTag(owner, repo);
        
        System.out.println("Found Last Release: " + branchOrTag);        
        
        String localVersion = readLocalVersion();
        
        String remotePomUrl = String.format(
            "https://raw.githubusercontent.com/%s/%s/%s/pom.xml",
            owner, repo, branchOrTag
        );
        String remoteVersion = readPomVersion(remotePomUrl);

        System.out.println("Local version:  " + localVersion);
        System.out.println("Remote version: " + remoteVersion);

        if (localVersion==null || !localVersion.equals(remoteVersion)) {
        
        	response.getWriter().print("Found Update: " + remoteVersion);
        	
        	return;
        }
		
    	response.getWriter().print(localVersion);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
	}

}
