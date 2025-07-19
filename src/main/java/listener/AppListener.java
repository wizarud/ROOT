package listener;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.TimeZone;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.wayos.Application;
import com.wayos.PathStorage;
import com.wayos.command.langchain4j.Langchain4JSessionPoolFactory;
import com.wayos.connector.SessionPool;
import com.wayos.pusher.FacebookPusher;
import com.wayos.pusher.LinePusher;
import com.wayos.pusher.PusherUtil;
import com.wayos.pusher.WebPusher;
import com.wayos.storage.DirectoryStorage;
import com.wayos.util.ConsoleUtil;
import com.wayos.util.SilentPusher;
import com.wayos.util.SilentPusherTask;

import x.org.json.JSONObject;

public class AppListener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {

		boolean isRoot = sce.getServletContext().getContextPath().isEmpty();

		String storagePath;

		if (!isRoot) {

			storagePath = System.getenv("storagePath") + sce.getServletContext().getContextPath();

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
		JSONObject startedObj = storage.readAsJSONObject("running.json");				
		if (startedObj!=null) {		

			System.out.println("Listener already started.. " + startedObj.toString());
			return;

		}

		System.out.println("Initialized.." + storagePath);

		/**
		 * Not yet? let start!
		 */

		startedObj = new JSONObject();
		startedObj.put("timestamp", new java.util.Date());
		storage.write(startedObj.toString(), "running.json");

		ConsoleUtil consoleUtil = new ConsoleUtil(storage);

		PusherUtil pusherUtil = new PusherUtil();

		//BLESessionPoolFactory sessionPoolFactory = new BLESessionPoolFactory(storage, consoleUtil, pusherUtil);
		/**
		 * Use Langchain4J Instead
		 */

		Langchain4JSessionPoolFactory sessionPoolFactory = new Langchain4JSessionPoolFactory(storage, consoleUtil, pusherUtil);

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
		SilentPusher silentPusher = new SilentPusher(storage);
		Application.instance().register(SilentPusher.class.getName(), silentPusher);

		/**
		 * Load pending task from saved file
		 */
		List<String> targetList = storage.listObjectsWithPrefix("silent");
		JSONObject cronObj;
		String [] tokens;
		for (String target:targetList) {
			
			cronObj = storage.readAsJSONObject("silent/" + target);

			if (cronObj==null) continue;
			
			String cronExpression = cronObj.getString("interval");
			tokens = target.split("\\.");
			String accountId = tokens[0];
			String botId = tokens[1];
			String channel = tokens[2];
			String sessionId = tokens[3];
			String messageToFire = tokens[4];
			
			SilentPusherTask silentPusherTask = new SilentPusherTask(cronExpression, accountId + "/" + botId, channel, sessionId, messageToFire);
			
			ZonedDateTime next = silentPusher.register(silentPusherTask);
			
			System.out.println(target + " will execute at " + next);

		}		

	}
	
	@Override
	public void contextDestroyed(ServletContextEvent sce) {

		/**
		 * Cancel all silent task
		 */
		SilentPusher silentPusher = (SilentPusher) Application.instance().get(SilentPusher.class.getName());
		
		if (silentPusher!=null)
			silentPusher.cancelAll();
		
		/**
		 * Delete running.json status file
		 */
		PathStorage storage = (PathStorage) Application.instance().get(PathStorage.class.getName());
		
		if (storage!=null)
			storage.delete("running.json");

		System.out.println("Server Destroyed");
		
	}

}
