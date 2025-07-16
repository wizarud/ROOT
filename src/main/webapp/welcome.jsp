<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.wayos.*"%>

<%

/**
* Redirect to sale page in production
*/

if (Configuration.domain.equals("https://wayos.yiem.ai")) {
	
	response.sendRedirect("https://wayos.yiem.ai/th");
	
	return;
}

String accountId = System.getenv("showcaseAccountId");

String botId = System.getenv("showcaseBotId");

String contextRoot = application.getContextPath();

String contextRootURL = Configuration.domain + contextRoot;

String playURL = contextRootURL + "/x/" + accountId + "/" + botId;
	
response.sendRedirect(playURL);

%>