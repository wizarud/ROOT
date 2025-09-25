<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,x.org.json.JSONObject, com.wayos.*,com.wayos.Application, com.wayos.connector.SessionPool" %>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<% 

	String contextRoot = application.getContextPath();
	String accountId = (String) request.getAttribute("accountId");
	String botId = (String) request.getAttribute("botId");	
	String sessionId = (String) request.getAttribute("sessionId");
	if (sessionId==null || sessionId.trim().isEmpty()) {
		sessionId = "";
	}
	
	JSONObject properties = (JSONObject) request.getAttribute("props");
		
	String message = request.getParameter("message");
	if (message==null || message.trim().isEmpty()) {
		message = "";
	}
		
	String contextRootURL = Configuration.domain + contextRoot;
	String playURL = contextRootURL + "/x/" + accountId + "/" + botId;
	
	String title = properties.optString("title");
	if (title==null) { 
		title = "Over Rider";
	}

%>

<title><%= title %></title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script src="../../wayosapp.js"></script>
<script src="../../widget.js"></script>

<script>
var thisWayOS = new WayOS("<%= playURL %>", "<%= sessionId %>");
var contextName = "<%= accountId + "/" + botId %>";

thisWayOS.onload = function(props) {
}

thisWayOS.onparse = function(message, from) {
}

//Callback Event
thisWayOS.onmessages = function(messages) {

};
</script>

</body>
</html>