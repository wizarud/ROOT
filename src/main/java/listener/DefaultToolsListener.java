package listener;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;

import com.wayos.Session;
import com.wayos.command.AsyncCommandNode;
import com.wayos.command.AsyncCommandRunner;
import com.wayos.command.StartProcessCommandNode;
import com.wayos.command.StopProcessCommandNode;
import com.wayos.command.TaskUpdateCommandNode;
import com.wayos.command.WaitCommandNode;
import com.wayos.command.wakeup.ExtensionSupportWakeupCommandNode;

@WebListener
public class DefaultToolsListener extends ExtensionSupportWakeupCommandNode.WebListener {

	@Override
	public void wakup(Session session) {
		
        session.commandList().add(new TaskUpdateCommandNode(session, new String[]{"taskCMD"}));
        
        session.commandList().add(new StartProcessCommandNode(session, new String[]{"start"}));
        
        session.commandList().add(new StopProcessCommandNode(session, new String[]{"stop"}));
        
        session.commandList().add(new WaitCommandNode(session, new String[]{"wait"}));        
        
		session.commandList().add(new AsyncCommandNode(session, new String[]{"awaitCMD"}, new AsyncCommandRunner(new WaitCommandNode(session, null))));
        		
		System.out.println(session + " Default Commands ready..");
		
	}

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		
		super.contextInitialized(sce);
		
		/**
		 * TODO: Check why too many load!!!!
		 */
		
		Map<String, Map<String, String>> logicDesignerExtToolMap = 
				(Map<String, Map<String, String>>)sce.getServletContext().getAttribute("logicDesignerExtToolMap");
		
		Map<String, String> sampleEntity1Map = new HashMap<>();
		sampleEntity1Map.put("tool-label", "Task");
		sampleEntity1Map.put("tool-color", "#F7A5A5");
		sampleEntity1Map.put("tool-tip", "Create your task schedule!");
		sampleEntity1Map.put("entity-resps", "["
				+ "{"
				+ "	txt: 'CMD',"
				+ "	params: [{ parameterName: 'hook', value: 'taskCMD' }, { parameterName: 'params', value: 'HH:mm keyToFire' }]"
				+ "}"
				+ "]");
		
		Map<String, String> sampleEntity2Map = new HashMap<>();
		sampleEntity2Map.put("tool-label", "aWait");
		sampleEntity2Map.put("tool-color", "#D7C3F1");
		sampleEntity2Map.put("tool-tip", "Asynchronous Wait in millisecond!");
		sampleEntity2Map.put("entity-resps", "["
				+ "{"
				+ "	txt: 'CMD',"
				+ "	params: [{ parameterName: 'hook', value: 'awaitCMD' }, { parameterName: 'params', value: '1000' }]"
				+ "}"
				+ "]");
		
		/**
		 * DOM Id query pattern to apply colour
		 * extCommand-<Hook>
		 */
		logicDesignerExtToolMap.put("extCommand-taskCMD", sampleEntity1Map);
		logicDesignerExtToolMap.put("extCommand-awaitCMD", sampleEntity2Map);
		
		System.out.println("Loaded Sample Tools: " + sce.getServletContext().getAttribute("logicDesignerExtToolMap"));		
		
	}

}
