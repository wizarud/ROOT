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
<style>
body {
    width: 100%;
    height: 100%;
    overflow-x: hidden;
    overflow-y: hidden;
    padding: 0;
    margin-left: 0;
    margin-right: 0;
}
.play {
	width: 500px;
	height: 500px;
	max-width: 100%;
	max-height: 100vh;
	background-image: url('../../app/lyrics/play_button-overrider.png');
	background-size: contain;
	background-repeat: no-repeat;
	cursor: pointer;
	margin: auto;
}
.rec {
	width: 500px;
	height: 500px;
	max-width: 100%;
	max-height: 100vh;
	background-image: url('../../app/lyrics/rec_button-overrider.png');
	background-size: contain;
	background-repeat: no-repeat;
	cursor: pointer;
	margin: auto;
}
#howtoplay {
	width: 100%;
	height: 100vh;
	padding-top: 100px;
	vertical-align: middle;
}
#lyrics {
  position: fixed;
  display: none;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0,0,0,0.5);
  z-index: 2;
  cursor: pointer;
}
.center {
  position: absolute;
  top: 50%;
  left: 50%;
  font-size: 50px;
  color: white;
  transform: translate(-50%,-50%);
  -ms-transform: translate(-50%,-50%);
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
<body onclick="tab()" style="height: 100vh; background-color: black">

<script src="../../wayosapp.js"></script>
<script src="../../widget.js"></script>
<script>
var thisWayOS = new WayOS("<%= playURL %>", "<%= sessionId %>");
var contextName = "<%= accountId + "/" + botId %>";

var startRecordingTime; //Will be Date.now() when audio play
var recordTape; //Will be 'queues\n' when audio play

var recording = <%= request.getParameter("record") != null %>;

var recordElement = document.createElement('div');
recordElement.style.backgroundColor = "black";

var centerElement = document.createElement('div');
centerElement.className = "center";
centerElement.style.left = "75%";

var linesElement = document.createElement('span');
linesElement.style.fontSize = "18px";
linesElement.style.color = "white";

recordElement.appendChild(centerElement);
recordElement.appendChild(linesElement);

var audio = new Audio();

var endOfSong = false;

const fadeoutTiming = {
 	duration: 250,
	iterations: 1
};
	
const fadeinTiming = {
 	duration: 1000,
	iterations: 1
};

function animate(displayElement, text) {
	
	let fadeOut = [
		{ opacity: "1" },
		{ opacity: "0" },
	];
	
	displayElement.animate(fadeOut, fadeoutTiming).onfinish = function(e) {
		
		displayElement.innerHTML = text;
		
		let fadeIn = [
			{ opacity: "0" },
			{ opacity: "1" },
		];

		displayElement.animate(fadeIn, fadeinTiming);
		
	};			
	
}

function updateLyrics() {
	
	linesElement.innerHTML = "";

	for (let i in lyrics) {
		if (i==0)  
			linesElement.innerHTML += "<b>" + lyrics[i] + "</b>👈 แตะเมื่อถึง<br>";
		else
			linesElement.innerHTML += lyrics[i] + "<br>";
	}	
}

function record(timeString) {
	
	let text = lyrics.shift();
	
	if (text) {
		
		animate(centerElement, text);
		
		updateLyrics();
			
		recordTape += timeString + "\n";
		
		console.log(timeString);
		
	}
		
}

const PADDING_RIGHT = 0;

const CHAT_BAR_HEIGHT = 50;

let width = window.innerWidth - PADDING_RIGHT;

let height = window.innerHeight - CHAT_BAR_HEIGHT;

let content;

/**
 * Config next keywords after speak and media played here!
 */
let onaudioended = 'next';
let onvideoended = 'slide';
let onimageended = 'slide';
 
let queue = [];
queue[onaudioended] = [];
queue[onvideoended] = [];
queue[onimageended] = [];

let lyrics = [];
let lineQueues = [];

function registerLyrics(lyricsStrings) {
	
	console.log("Register Lyrics:" + lyricsStrings);

	lyrics = lyricsStrings.split("\n");
	
	lyrics.shift();//Remove first signal "queue"
	
	if (recording) {
		
		updateLyrics();
		
	}
	
}

function registerLineQueues(queueStrings) {
	
	console.log("Register Queues:" + queueStrings);
	
	let timelines = queueStrings.split("\n");
	
	timelines.shift();//Remove first signal "queue"
	
	for (let i in timelines) {
		
		let startInMs = parseInt(timelines[i]);
		let line = lyrics[i];
		
		lineQueues.push({startInMs, line});
						
	}
	
}

function updateTimeIndices() {
	
	let url = "<%= Configuration.domain + contextRoot %>/g";
	let xhr = new XMLHttpRequest();
		
	let params = "timeIndices=" + encodeURIComponent(recordTape) + "&contextName=" + contextName;
		
	xhr.open("POST", url, true);
	xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

	xhr.onload = function() {
			
	    if (xhr.status === 200) {
		    
	    	animate(centerElement, "บันทึกเวลาเรียบร้อยแล้วจ้า จะเด้งไปหน้า " + xhr.responseText + " ในอีก 3 วิ");

	    	// Redirect after 3 seconds
	    	setTimeout(function() {
	    		
	    		window.top.location.href = xhr.responseText;
	    		
	    	}, 3000);
		}
		    
	}.bind(this);
		
	xhr.send(params);
	
}

function playLines() {
		
	document.getElementById("lyrics").style.display = "block";
	
	for (let i in lineQueues) {
		
		let lineQ = lineQueues[i];
				
		setTimeout(function() {
			
			console.log("Auto Play:" + lineQ.startInMs + ":" + lineQ.line);
			
			animate(document.getElementById("line"), lineQ.line);
			
		}, lineQ.startInMs);
		
	}
		
}

function play(messages) {
	
	console.log(JSON.stringify(messages));
	
	let texts = [];
	let audios = [];
	let videos = [];
	let images = [];
	
	//Register kick queue if any			
	for (let i in messages) {
		
		let message = messages[i];
			
		if (message.type==='text') {
			
			texts.push(message);
					
		}
		
		if (message.type==='audio') {
			
			audios.push(message);
			
			//console.log("Add " + message.src + " to queue:" + onaudioended);
			
			queue[onaudioended].push(message.src);
							
		}
		
		if (message.type==='video') {
			
			videos.push(message);
			
			//console.log("Add " + message.src + " to queue:" + onvideoended);
			
			queue[onvideoended].push(message.src);
							
		}
		
		if (message.type==='image') {
			
			images.push(message);
			
			//console.log("Add " + message.src + " to queue:" + onimageended);
			
			queue[onimageended].push(message.src);
		}
			
	}
	
	var textStep = function() {
		
		if (endOfSong) return;
		
		let message = texts.shift();
		
		if (!message) return;
				
		if (message.type==='text') {
			
			console.log(">>" + message.text);
						
			if (message.text.startsWith("lyrics\n")) {//Lyrics Signal, Should appear before queue!
				
				registerLyrics(message.text);
			
				textStep();
				
			} else if (!recording && message.text.startsWith("queues\n")) {//Queue play Signal
				
				registerLineQueues(message.text);
			
				textStep();
				
			} else {
				
				//Display contents
				
				let line = document.createElement("h5");
				line.style.backgroundColor = "black";
				line.style.color = "white";
				
				if (!recording) {
					line.innerHTML = message.text;					
				} else {
					line.innerHTML = "แตะเพื่อใส่เนื้อร้อง";
				}
				
				content.appendChild(line);
						
				setTimeout(function() {
					line.remove();
					textStep();
				}, 1000);
				
			}
			
						
		}
		
	}
	
	var audioStep = function() {
		
		if (endOfSong) return;
		
		let message = audios.shift();
		
		if (!message) return;
				
		if (message.type==='audio') {
			
			console.log(">>" + message.src);
			
			if (!audio.paused) {
				audio.pause();
			}
		
			audio.src = message.src;
												
			audio.onended = function() {
				
				queue[onaudioended].pop();
				
				console.log("Ended: " + message.src + ":" + queue[onaudioended]);
				
				if (recording) {
					
					recordTape = recordTape.trim();
					
					//console.log("Copy text below to queues message");
					//console.log(recordTape);
					
					//Update to this contextName
					updateTimeIndices();
					
				} else {
					
					if (queue[onaudioended].length===0) {
						
						console.log("Kick to " + onaudioended);
						
						thisWayOS.parse(onaudioended + "!");
						
					}
					
					setTimeout(function() {
						audioStep();
					}, 500);
				}
			
			}
			
			audio.onplay = function() {

				if (recording) {
				
					startRecordingTime = Date.now();
					
					recordTape = "queues\n";
					
					console.log("Start recording time:" + startRecordingTime);
					
				} else {
					
					console.log("Start playing lines Q");
					
					playLines();
					
				}
			}
			
			audio.play().catch(error => {
				
				//May be cause by autoplay that need user interact first!!
				
				console.log(error);
				
				//Reconstruct Play button
				let replay = document.createElement("div");
				replay.id = "howtoplay";
				let autoplay = document.createElement("div");
				autoplay.id = "autoPlay";
				autoplay.className = "play";
				
				replay.appendChild(autoplay);
				
				document.body.appendChild(replay);
				
			});			
		}
		
	}
	
	var videoStep = function() {
		
		if (endOfSong) return;
		
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
					
					thisWayOS.parse(onvideoended + "!");
					
				}
								
				setTimeout(function() {
					videoStep();
				}, 500);
				
			}
			
			video.play();

		}		
	}	
	
	var imageStep = function() {
		
		if (endOfSong) return;
		
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
					
					thisWayOS.parse(onimageended + "!");
					
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

thisWayOS.onload = function(props) {

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

thisWayOS.onparse = function(message, from) {
	console.log("Parsing.." + message);
		
	if (message=== onaudioended + '!') {
		endOfSong = true;
	}
	
}

thisWayOS.onmessages = function(messages) {
	
	//console.log("Split messages to text and media:" + JSON.stringify(messages));
	
	play(messages);
	
};

/*
window.onresize = function () {
	location.reload();
};
*/

window.onload = function () {
	
	if (recording) {
		document.body.appendChild(recordElement);
	}
	
	content = document.createElement("div"); 
	content.id = "content";
	content.width  = width;
	content.height = height;
	document.body.appendChild(content);
	   	
	if (document.getElementById("autoPlay")) {
		setTimeout(function() {
			console.log("Auto play..");
			tab();
		}, 3000);
	}

}

function tab() {

	if (document.getElementById("howtoplay")) {
		
		document.getElementById("howtoplay").remove();
		
		console.log("Init!");
		
	    //Init thisWayOS
		console.log("Connecting to " + thisWayOS.playURL + " with sessionId " + thisWayOS.sessionId);
		
		thisWayOS.load("lyrics");
						
	} else if (recording) {
		
		let time = Date.now() - startRecordingTime;
		
		record(time);
		
	}
	
}
</script>
<div id="lyrics">
  <div id="line" class="center"><%= title %></div>
</div>
<div id="howtoplay">
<% if (request.getParameter("record") != null) { %>
<div class="rec"></div>
<% } else { %>
<div class="play" id="autoPlay"></div>
<% } %>
</div>
</body>
</html>