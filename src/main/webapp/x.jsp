<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,x.org.json.JSONObject, com.wayos.*,com.wayos.Application, com.wayos.connector.SessionPool" %>
<%@ page isELIgnored="true" %>
<!doctype html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang=""> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang=""> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang=""> <![endif]-->
<!--[if gt IE 8]><!-->
<%@ include file="i18n.jspf"%>
<html class="no-js" lang="">
<!--<![endif]-->
<head>

<% 

	String contextRoot = application.getContextPath();
	String accountId = (String) request.getAttribute("accountId");
	String botId = (String) request.getAttribute("botId");	
	
	/* Use sessionId Parameter Instead
	String sessionId = (String) request.getAttribute("sessionId");
	*/
	String sessionId = request.getParameter("sessionId");	
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

%>

<% if (properties.optString("title")!=null) { %>
<title><%= properties.optString("title") %></title>
<% } else { %>
<title>wayOS</title>
<% } %>

<%@ include file="css.jspf" %>

<style>
body, div, section, iframe {
	touch-action: none;
}
.context {
	margin: 0;
//	padding: 10px 0;
	padding: 0;
	width: 100%;
}
.footer {
   position: fixed;
   left: 0;
   bottom: 0;
   width: 100%;
   text-align: center;
}
</style>

<meta property="fb:app_id" content="<%= System.getenv("facebook_appId") %>" />

<meta property="og:type" content="website" />
<meta property="og:title" content="<%= properties.optString("title") %>" />
<meta property="og:description" content="<%= properties.optString("description") %>" />
<meta property="og:url" content="<%= Configuration.domain + contextRoot %>/x/<%= accountId %>/<%= botId %>" />
<meta property="og:image" content="<%= Configuration.domain + contextRoot %>/public/<%= accountId %>/<%= botId %>.PNG" />
<meta property="og:image:alt" content="<%=  Configuration.domain + contextRoot %>/images/gigi.png" />

<link rel="icon" type="image/png" href="<%= Configuration.domain + contextRoot %>/public/<%= accountId %>/<%= botId %>.PNG">

</head>
<body>

<!--[if lt IE 8]>
	<p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
<![endif]-->

	<div class='preloader'>
		<div class='loaded'>&nbsp;</div>
	</div>
	
	<%@ include file="nav-bar.jspf"%>
	
	<%@ include file="overlay.jspf" %>
	
	<%@ include file="javascript.jspf" %>	
	
	<script>
	function logout() {

		  <% if (session.getAttribute("accountId") != null) { %>
		  
		 	var xhr = new XMLHttpRequest();
		 	xhr.open("GET", contextRoot + "/logout", true);
		 	xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		 	xhr.send();

		 	xhr.onreadystatechange = function() {
		 	  	if (xhr.readyState == 4 && xhr.status == 200) {		 
		 			if (xhr.responseText == "success") {
		 					 				
	 				  window.location.href = "<%= Configuration.domain + contextRoot %>/x/<%= accountId %>/<%= botId %>";
		 				
		 			}
		 		}
		 	}	
		 	
		 	<% } %>
		};
	</script>
	
	<script src="<%= contextRootURL %>/wayosapp.js"></script>
	<%--
	 --%>
	<script>
	//Paste for Test
	</script>
	<script>
<% if (sessionAccountId!=null && sessionAccountId.equals(accountId)) { %>

	var playURL;

	function playAudio (src) {
	
		let audio = new Audio();
	
		audio.src = src;
			
		audio.play();
			
	}
	
	function updateAllUnreadMessages(playURL, targetClassName) {
		
		let xhr = new XMLHttpRequest();
		
		let url = playURL.replace('/x/', '/console/unread/');
		
		xhr.open("GET", url); 
		
		xhr.onload = function() {
		 
		    if (xhr.status === 200) {
		    	
		    	//console.log("All unread messages:" + xhr.responseText);
		    	
		    	let allUnread = parseInt(xhr.responseText);
		    	
		    	let unreadString;
				if (allUnread > 0) {
				
					unreadString = "&nbsp;(" + allUnread + ")";
				
				} else {
					
					unreadString = "";
				}
				
				let targetHtmlElements = document.getElementsByClassName(targetClassName);
				
				if (targetHtmlElements) {
					for (let i in targetHtmlElements) {
						targetHtmlElements[i].innerHTML = unreadString;
					}							
				}
		    }
			
		}.bind(this);
		
		xhr.send();				
	}
	
	function onWSMessage(messages) {
		/**
		* Do logout if another admin for this contextName is authenticated from another location!
		*/
		if (messages.length===1 && messages[0].type==='text' && messages[0].text==='..(-.-)') {
			
			alert('Administrator of this content has authenticated from another location!');
			logout();
			return;
		}
		
		playAudio('/public/eoss-th/question_003.ogg');
		
	  	updateAllUnreadMessages(playURL, "unread");
	  	
	}
	function registerAdminIfOwner(parentElement) {
		
		parentElement.wayOS.parse('ลงทะเบียนผู้ดูแล!');
		
		playURL = parentElement.wayOS.playURL;
		
	  	updateAllUnreadMessages(playURL, "unread");
		
	}
<% } else { %>
	function onWSMessage(messages) {}
	function registerAdminIfOwner(parentElement) {
		//Guest
		console.log("Welcome you are guest!");
	}
<% } %>
	</script>
	<script>
		var viewMode;
		
		function adjustSize() {
						
		  	let play = document.getElementById("play");
		  	if (window.innerWidth >  992) {
				console.log("Adjust Size for Desktop..");
		  		//play.style.height = "87dvh";
		  		play.style.height = (window.innerHeight - 100) + "px";
		  	} else {
				console.log("Adjust Size for Mobile..");
		  		//play.style.height = "91dvh";
		  		play.style.height = (window.innerHeight - 55) + "px";
		  	}
		  	
		  	viewMode = window.innerWidth > window.innerHeight ? "landscape" : "portrait";
			
		}
			
		var applyTheme = function (props) {
			
			document.addEventListener('touchstart', function(e) {e.preventDefault()}, false);
			document.addEventListener('touchmove', function(e) {e.preventDefault()}, false);
			
			//let titleHeader = document.getElementById("title");
	   		//titleHeader.innerHTML = props.title ? props.title : "wayOS";
			//let titleLink = document.getElementById("title_link");
			//let titleURI = "<%= contextRoot + "/x/" + accountId + "/" + botId %>";
			//titleLink.setAttribute("href", titleURI);
	   		/*
	   		let xRingButton = document.getElementById("xRingButton");
	   		xRingButton.addEventListener('click', function(event) {
	 			
	 			this.ring();
	 			
		    }.bind(this));
	   		
	   		let xChatButton = document.getElementById("xChatButton");
	   		xChatButton.addEventListener('click', function(event) {
	 			
				//Toggle chatBar
				if (this.chatBar.isShowing()) {
					this.chatBar.hide();
				} else {
					this.chatBar.show();				
				}
	 			
		    }.bind(this));
	   		*/
	   			   		
		  	let socialSection = document.getElementById("social");
	 	  	socialSection.style.background = props.borderColor;			
				 	  	
			document.body.style.backgroundColor = props.borderColor;
			
		  	let footerSection = document.getElementById("footer");
		  	footerSection.style.background = props.borderColor;	
		  	
		  	adjustSize();
		  	
		  	//registerAdminIfOwner(this);
		}
		
		window.onorientationchange = (event) => {
			
			location.reload();
			
		};
		
		window.onresize = (event) => {
			
		  	adjustSize();
			
		};
	</script>

	<section id="footer" class="context">
		<div class="col-md-12" style="text-align: center; padding: 0; touch-action: none;">
			<wayos-let id="play" data-speak="yes" data-session-id="<%= sessionId %>" data-url="<%= playURL %>" data-message="<%= message %>" data-top-id="xNav" data-top="ring|chat" data-chat="no" data-onload="applyTheme" data-onmessage="onWSMessage"></wayos-let>
		</div>
	</section>			
</html>