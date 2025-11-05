<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.wayos.*"%>

<%

String accountId = System.getenv("showcaseAccountId");

String botId = System.getenv("showcaseBotId");

String contextRoot = application.getContextPath();

String contextRootURL = Configuration.domain(request) + contextRoot;

String playURL = contextRootURL + "/x/" + accountId + "/" + botId;
	
response.sendRedirect(playURL);

%>