package listener;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.List;
import java.util.TimeZone;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.wayos.Application;
import com.wayos.PathStorage;
import com.wayos.connector.ExtensionCommandSupportSessionPoolFactory;
import com.wayos.connector.SessionPool;
import com.wayos.pusher.FacebookPusher;
import com.wayos.pusher.LinePusher;
import com.wayos.pusher.PusherUtil;
import com.wayos.pusher.WebPusher;
import com.wayos.storage.DirectoryStorage;
import com.wayos.util.ConsoleUtil;
import com.wayos.util.MessageTimer;
import com.wayos.util.MessageTimerTask;

import x.org.json.JSONArray;
import x.org.json.JSONObject;

@WebListener
public class AppListener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		
		boolean isRoot = sce.getServletContext().getContextPath().isEmpty();
		
		/**
		 * Check is deploy on PI or not?
		 * Retrieve PI Machine Id from /proc/cpuinfo
		 */
		//String piMachineId = piMachineId();
		
		String piMachineId = null; //Skip For yiem.cc		

		String storagePath;

		if (!isRoot) {

			storagePath = System.getenv("storagePath") + sce.getServletContext().getContextPath();

		}
		
		else if (piMachineId!=null) {
			
			/**
			 * TODO: Check allowed piMachineId
			 * Ex. From Support list on Updater.war
			 */
						
			storagePath = System.getenv("storagePath") + "/" + piMachineId;			
		
		} else {

			storagePath = System.getenv("storagePath") + "/ROOT";

		}

		TimeZone.setDefault(TimeZone.getTimeZone("GMT+7"));

		/**
		 * Use ${storagePath}${contextPath} as home directory for /libs, /private, /public, /vars, /users
		 */
		PathStorage storage = new DirectoryStorage(storagePath);

		/**
		 * Check this listener is already start or not?
		 */
		JSONObject runningObj = storage.readAsJSONObject("running.json");
		
		if (runningObj!=null) {		

			System.out.println("Listener already started.. " + runningObj.toString());
			
			stopDaemonProcess(runningObj);
			
			return;

		}

		System.out.println("Initialized.." + storagePath);

		/**
		 * Not yet? let start!
		 */
		runningObj = new JSONObject();
		runningObj.put("timestamp", new java.util.Date());
		storage.write(runningObj.toString(), "running.json");

		ConsoleUtil consoleUtil = new ConsoleUtil(storage);

		PusherUtil pusherUtil = new PusherUtil();

		//BLESessionPoolFactory sessionPoolFactory = new BLESessionPoolFactory(storage, consoleUtil, pusherUtil);
		/**
		 * Use Langchain4J Instead
		 */

		ExtensionCommandSupportSessionPoolFactory sessionPoolFactory = new ExtensionCommandSupportSessionPoolFactory(
				sce.getServletContext(), 
				storage, 
				consoleUtil, 
				pusherUtil);

		SessionPool sessionPool = sessionPoolFactory.create();

		/**
		 * Register Single Instance of Utilities class for future usages
		 */		
		Application.instance().register(SessionPool.class.getName(), sessionPool);
		Application.instance().register(PathStorage.class.getName(), storage);
		Application.instance().register(ConsoleUtil.class.getName(), consoleUtil);

		/**
		 * Register pusher to channel
		 */
		Application.instance().register(PusherUtil.class.getName(), pusherUtil);
		Application.instance().register("line", new LinePusher(storage));
		Application.instance().register("facebook.page", new FacebookPusher(storage));
		Application.instance().register("web", new WebPusher(storage));		

		/**
		 * Register SilentPusher
		 */
		MessageTimer silentFire = new MessageTimer(storage);
		Application.instance().register(MessageTimer.class.getName(), silentFire);

		/**
		 * Load pending task from saved file
		 */
		List<String> accountIdList = storage.listObjectsWithPrefix("silent");
		List<String> botIdList;
		JSONObject taskObj;
		String botId;
		String contextName;
		for (String accountId:accountIdList) {

			botIdList = storage.listObjectsWithPrefix("silent/" + accountId);
			
			for (String botJsonFile:botIdList) {
				
				System.out.println("silent/" + accountId + "/" + botJsonFile);
				
				taskObj = storage.readAsJSONObject("silent/" + accountId + "/" + botJsonFile);

				if (taskObj==null) continue;
				
				botId = botJsonFile.replace(".json", "");
				
				contextName = accountId + "/" + botId;
				
				silentFire.register(MessageTimerTask.build(contextName, taskObj));
				
			}			
			
		}		
		
	}
	
	@Override
	public void contextDestroyed(ServletContextEvent sce) {		

		/**
		 * Cancel all silent task
		 */
		MessageTimer silentFire = Application.instance().get(MessageTimer.class);
		
		if (silentFire!=null) {
			
			silentFire.cancelAll();
			
		}
		
		PathStorage storage = Application.instance().get(PathStorage.class);
		
		if (storage!=null) {
			
			/**
			 * List pending processes started by start command
			 */
			JSONObject runningObj = storage.readAsJSONObject("running.json");
			
			stopDaemonProcess(runningObj);
			
			/**
			 * Delete running.json status file
			 */		
			storage.delete("running.json");
			
		}

		System.out.println("Server Destroyed");
		
	}

	private void stopDaemonProcess(JSONObject runningObj) {
		
		if (runningObj!=null) {
			
			JSONArray processIdArray = runningObj.optJSONArray("processIds");
			
			if (processIdArray!=null) {
				
				for (int i=0; i<processIdArray.length(); i++) {
					
					long pid = processIdArray.getLong(i);
					
					ProcessHandle handle = ProcessHandle.of(pid).orElse(null);				
					
					if (handle!=null && handle.isAlive()) {
						
						if (handle.destroy()) {
							
							System.out.println("Process " + pid + " has been released..");
							
						} else {
							
							System.out.println("Process " + pid + " cannot release..");
							
						}
						
					} else {
						
						System.out.println("Process " + pid + " not found..");
						
					}
									
				}
				
			}
			
		}
	}
	
	private String piMachineId() {
		
		//Read Pi serial
        String serial;
        try (BufferedReader br = new BufferedReader(new FileReader("/proc/cpuinfo"))) {
        	
            String line; serial = null;
            
            while ((line = br.readLine()) != null) {
            	
                if (line.startsWith("Serial")) { serial = line.split(":")[1].trim(); break; }
                
            }
            
            return serial;
            
		} catch (Exception e) {
			//e.printStackTrace();
		}
        
        return null;
				
	}

}
