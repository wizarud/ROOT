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
		
	String contextRootURL = Configuration.domain(request) + contextRoot;
	String playURL = contextRootURL + "/x/" + accountId + "/" + botId;
	
%>

<% if (properties.optString("title")!=null) { %>
<title><%= properties.optString("title") %></title>
<% } else { %>
<title>wayOS</title>
<% } %>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

</head>
<body onclick="init()" style="height: 100vh">

<script src="../../wayosapp.js"></script>
<script src="../../widget.js"></script>
<script>

var debugging = <%= request.getParameter("debug") != null %>;

var debugElement = document.createElement('span');

function debug(text) {
	
	debugElement.innerText = text;
	
	console.log(text);
}

const PADDING_RIGHT = 0;

const CHAT_BAR_HEIGHT = 50;

let width = window.innerWidth - PADDING_RIGHT;

let height = window.innerHeight - CHAT_BAR_HEIGHT;

let content;

/**
 * Config next keywords after speak and media played here!
 */
let onspeakended = 'greeting';
let onaudioended = 'greeting';
let onvideoended = 'slide';
let onimageended = 'slide';
 
let queue = [];
queue[onspeakended] = [];
queue[onaudioended] = [];
queue[onvideoended] = [];
queue[onimageended] = [];

function play(messages) {
	
	let texts = [];
	let audios = [];
	let videos = [];
	let images = [];
	
	//Register kick queue if any			
	for (let i in messages) {
		
		let message = messages[i];
			
		if (message.type==='text') {
			
			texts.push(message);
				
			console.log("Add " +  message.text + " to queue:" + onspeakended);
			
			queue[onspeakended].push(message.text);
	
		}
		
		if (message.type==='audio') {
			
			audios.push(message);
			
			console.log("Add " + message.src + " to queue:" + onaudioended);
			
			queue[onaudioended].push(message.src);
							
		}
		
		if (message.type==='video') {
			
			videos.push(message);
			
			console.log("Add " + message.src + " to queue:" + onvideoended);
			
			queue[onvideoended].push(message.src);
							
		}
		
		if (message.type==='image') {
			
			images.push(message);
			
			console.log("Add " + message.src + " to queue:" + onimageended);
			
			queue[onimageended].push(message.src);
		}
			
	}
	
	var textStep = function() {
		
		let message = texts.shift();
		
		if (!message) return;
				
		if (message.type==='text') {
			
			console.log(">>" + message.text);
			
			let line = document.createElement("h5");
			line.style.backgroundColor = "black";
			line.style.color = "white";
			line.innerHTML = message.text;
			content.appendChild(line);
						
			wayOS.speak(message.text, function() {
				
				line.remove();

				queue[onspeakended].pop();
				
				if (queue[onspeakended].length===0) {
					
					console.log("Kick to " + onspeakended);
					
					wayOS.parse(onspeakended + "!");
					
				}
				
				setTimeout(function() {
					textStep();
				}, 500);
				
			});			
			
		}
		
	}
	
	var audioStep = function() {
		
		let message = audios.shift();
		
		if (!message) return;
				
		if (message.type==='audio') {
			
			console.log(">>" + message.src);
			
			let audio = new Audio(message.src);
			
			audio.play();
			
			audio.onended = function() {
				
				queue[onaudioended].pop();
				
				console.log("Ended: " + message.src + ":" + queue[onaudioended]);
				
				if (queue[onaudioended].length===0) {
					
					console.log("Kick to " + onaudioended);
					
					wayOS.parse(onaudioended + "!");
					
				}
				
				setTimeout(function() {	
					audioStep();
				}, 500);
				
			}
			
		}
		
	}
	
	var videoStep = function() {
		
		let message = videos.shift();
		
		if (!message) return;
				
		if (message.type==='video') {
			
			console.log(">>" + message.src);
						
			let video = document.createElement('video');
			
			video.src = message.src;
			
			video.volume = 0;
							
			video.style.position = "fixed";
			
			video.style.right = "0";
			
			video.style.bottom = "0";
			
			video.style.minWidth = '100%';
			
			video.style.minHeight = '100%';
			
			content.appendChild(video);
			
			video.onended = function() {
				
				video.remove();
				
				queue[onvideoended].pop();
				
				if (queue[onvideoended].length===0) {
					
					console.log("Kick to " + onvideoended);
					
					wayOS.parse(onvideoended + "!");
					
				}
								
				setTimeout(function() {
					videoStep();
				}, 500);
				
			}
			
			video.play();

		}		
	}	
	
	var imageStep = function() {
		
		let message = images.shift();
		
		if (!message) return;
				
		if (message.type==='image') {
			
			console.log(">>" + message.src);
			
			document.body.style.backgroundImage = "url('" + message.src + "')";
			document.body.style.backgroundSize = "100% 100%";
						
			setTimeout(function() {
				
				queue[onimageended].pop();
				
				if (queue[onimageended].length===0) {
					
					console.log("Kick to " + onimageended);
					
					wayOS.parse(onimageended + "!");
					
				}
				
				imageStep();
				
			}, 3000);
						
		}
		
	}	
	
	textStep();	
	
	audioStep();
	
	videoStep();
	
	imageStep();
	
}

wayOS = new WayOS("<%= playURL %>", "<%= sessionId %>");

wayOS.onload = function(props) {

	/**
	{
		"borderColor":"#1d4529",
		"publish":"true",
		"description":"",
		"language":"TH",
		"sessionId":"thewalk001",
		"title":"",
		"coverImageURL":"http://localhost:8080/public/sitcom/ep0.PNG",
		"defaultMenuImageURL":"http://localhost:8080/images/gigi.png"}		
	*/
	
	console.log("Apply Theme: " + JSON.stringify(props));		
	
	let image = new Image();
	image.src = props.coverImageURL;
	image.onload = function() {
		document.body.style.backgroundImage = "url('" + props.coverImageURL + "')";
		document.body.style.backgroundRepeat = "no-repeat";
		document.body.style.backgroundAttachment = "fixed";
		document.body.style.backgroundSize = "100% 100%";
	}
	
	image.onerror = function() {
		document.body.style.backgroundColor = props.borderColor;
	}

}

wayOS.onmessages = function(messages) {
	
	console.log("Split messages to text and media:" + JSON.stringify(messages));
	
	play(messages);
	
};

window.onresize = function () {
	location.reload();
};

window.onload = function () {
	
	content = document.createElement("div"); 
	content.id = "content";
	content.width  = width;
	content.height = height;
	document.body.appendChild(content);
    	
}

function init() {
	
	document.getElementById("howtoplay").remove();
	
	console.log("Init!");
	
    //Init wayOS
	console.log("Connecting to " + wayOS.playURL + " with sessionId " + wayOS.sessionId);
	
	wayOS.load("greeting");
	
}
</script>
<p style="text-align:center" id="howtoplay">
<img src="../../app/vrdj/play_button-overrider.png">
</p>
</body>
</html>