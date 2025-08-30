package listener;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;

import com.wayos.Session;
import com.wayos.command.TaskUpdateCommandNode;
import com.wayos.command.wakeup.ExtensionSupportWakeupCommandNode;

@WebListener
public class DefaultToolsListener extends ExtensionSupportWakeupCommandNode.WebListener {

	@Override
	public void wakup(Session session) {
		
        session.commandList().add(new TaskUpdateCommandNode(session, new String[]{"taskCMD"}));
		
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
		
		/**
		 * DOM Id query pattern to apply colour
		 * extCommand-<Hook>
		 */
		logicDesignerExtToolMap.put("extCommand-taskCMD", sampleEntity1Map);
		
		System.out.println("Loaded Sample Tools: " + sce.getServletContext().getAttribute("logicDesignerExtToolMap"));		
		
	}

}
