package listener;

import java.util.List;
import java.util.TimeZone;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

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

public class AppListener implements ServletContextListener, HttpSessionListener {
	
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		
		new Thread(new Runnable() {

			@Override
			public void run() {
				
				boolean isRoot = sce.getServletContext().getContextPath().isEmpty();
				
				String storagePath;
				
				if (!isRoot) {
					
					storagePath = System.getenv("storagePath") + sce.getServletContext().getContextPath();
					
				} else {
					
					storagePath = System.getenv("storagePath") + "/ROOT";
					
				}
				
				System.out.println("contextInitialized.." + storagePath);
				
				TimeZone.setDefault(TimeZone.getTimeZone("GMT+7"));
				
				/**
				 * Use ${storagePath}${contextPath} as home directory for /libs, /private, /public, /vars, /users
				 */
				PathStorage storage = new DirectoryStorage(storagePath);
				
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
				String silentInterval;
				String accountId;
				String botId;
				String channel;
				String sessionId;
				
				String [] tokens;
				for (String task:taskList) {
					
					try {
						
						silentObj = storage.readAsJSONObject("silent/" + task);
						
						if (silentObj==null) continue;
						
						silentInterval = "" + silentObj.getLong("interval");
						
						System.out.println("Repeat: " + task + " every " + silentInterval + " hours..");

						tokens = task.split("\\.");
						accountId = tokens[0];
						botId = tokens[1];
						channel = tokens[2];
						sessionId = tokens[3];
						
						silentPusher.register(silentInterval, accountId + "/" + botId, channel, sessionId, true);
						
					} catch (Exception e) {
						
						e.printStackTrace();
						
					}
				}
												
			}
			
		}).start();
		
	}

	@Override
	public void sessionCreated(HttpSessionEvent se) {
		
		/**
		 * Lazy Initilize by first session
		 */
		//if (Application.instance().get(SessionPool.class.getName())!=null) return;
		

		
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {
		
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		
	}
	
}
