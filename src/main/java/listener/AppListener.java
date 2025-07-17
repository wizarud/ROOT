package listener;

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
		List<String> taskList = storage.listObjectsWithPrefix("silent");
		JSONObject silentObj;
		double silentInterval;
		String accountId;
		String botId;
		String channel;
		String sessionId;

		String [] tokens;
		for (String task:taskList) {

			try {

				silentObj = storage.readAsJSONObject("silent/" + task);

				if (silentObj==null) continue;

				silentInterval = silentObj.getDouble("interval");

				System.out.println("Repeat: " + task + " every " + silentInterval + " hours..");

				tokens = task.split("\\.");
				accountId = tokens[0];
				botId = tokens[1];
				channel = tokens[2];
				sessionId = tokens[3];

				silentPusher.register(silentInterval, accountId + "/" + botId, channel, sessionId, false);

			} catch (Exception e) {

				e.printStackTrace();

			}
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
