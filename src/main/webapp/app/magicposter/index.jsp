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

<style>
canvas {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1;
  cursor: pointer;
}

span {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 2;
  cursor: pointer;
}

input.height {
  position: fixed;
  writing-mode: vertical-lr;
  direction: ltr;
  vertical-align: middle; 
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 3;
  cursor: pointer;
  height: 98vh;
}

input.width {
  position: fixed;
  top: 50;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 4;
  cursor: pointer;
}

</style>

</head>
<body style="height: 100vh">

<script src="https://unpkg.com/ml5@0.12.2/dist/ml5.min.js"></script>
<script src="../../wayosapp.js"></script>
<script src="../../widget.js"></script>

<script>

var debugging = <%= request.getParameter("debug") != null %>;

var debugElement = document.createElement('span');

function debug(text) {
	
	debugElement.innerText = text;
	
	console.log(text);
}

// Copyright (c) 2019 ml5
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/* ===
ml5 Example
Real time Object Detection using objectDetector
=== */

const PADDING_RIGHT = 0;

//const CHAT_BAR_HEIGHT = 50;
const CHAT_BAR_HEIGHT = 0;

let width = window.innerWidth - PADDING_RIGHT;

let height = window.innerHeight - CHAT_BAR_HEIGHT;

if (height > width) height = width; //Trim

let scaleX = width / 416;
let scaleY = height / 416;

let objectDetector;
let objects = [];
let video;
let canvas, ctx;

let videoElement = document.createElement('video');
let capture;

let radiusW = document.createElement("input");
radiusW.className = "width";
radiusW.type = 'range';
radiusW.value = 0;
radiusW.min = 0;
radiusW.max = width;

let radiusH = document.createElement("input");
radiusH.orient="vertical";
radiusH.className = "height";
radiusH.type = 'range';
radiusH.value = 0;
radiusH.min = 0;
radiusH.max = height;

let centerX, centerY;

const lastFounds = [];

let lastPan, lastCol, lastRow = 0;

//Not same position, should speak it!
//let shouldSpeak = grid.col !== lastCol || grid.row !== lastRow;
let shouldSpeak = true;

let messageVideoElement = document.createElement("video");

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

//Blocking for debugging
wayOS.onmessages = function(messages) {
	
	shouldSpeak = false;
	
	console.log(JSON.stringify(messages));
		
	var step = function() {
				
		let message = messages.shift();
		
		if (!message) {
			
			console.log("End of messages!");
									
			shouldSpeak = true;
			
			return;
		}
				
		if (message.type==='text') {
			
			console.log("Speak >>" + message.text);
			
			wayOS.speak(message.text, function() {
				
				step();
				
			});
			
		} else if (message.type==='audio') {
			
			console.log("Play Sound>>" + message.src);
			
			let audio = new Audio(message.src);
			
			audio.play();
			
			audio.onended = function() {
								
				step();
				
			}
			
			
		} else if (message.type==='image') {
			
			console.log("Display>>" + message.src);
			
			document.body.style.backgroundImage = "url('" + message.src + "')";
			document.body.style.backgroundSize = "100% 100%";
			
			setTimeout(function() {
				
				step();
				
			}, 1000);
			
		} else if (message.type==='video') {
			
			console.log("Play Video>>" + message.src);
						
			let video = document.createElement('video');
			
			video.width = width;
			
			video.height = height;
			
			video.src = message.src;
			
			video.volume = 0;
							
			video.style.position = "fixed";
			
			video.style.right = "0";
			
			video.style.bottom = "0";
			
			video.style.minWidth = '100%';
			
			video.style.minHeight = '100%';
						
			document.body.appendChild(video);
			
			video.onended = function() {
				
				video.remove();
				
				step();
				
			}
			
			video.play();
						
		}
				
	}
	
	step();
		
};

function startDetecting() {
	
	objectDetector = ml5.objectDetector('yolo', detect)
	
}

function stopDetecting() {
	
	capture.getTracks()[0].stop();	
	
	video.pause();
	
}

function detect() {
	    
    setTimeout(function() {
    	
    	debug("Detecting..");
    	
    	if (debugging) {
    			    	
            draw();
            
    	}
        
    	objectDetector.detect(video, function(err, results) {
    	      
    		if (err) {
    		    	
    			debug(err + ", Retry in 3 seconds..");
    			    
    			//setTimeout(startDetecting, 3000); For soft solution
    			location.reload(); //For hardcore solution 55555	    
    			    
    			return;
    		}
    		
    		if (results == null || results.length==0) {
        		
    		    detect();
    		        
    		    return;
    		}
    		                    	
    		objects = [];
    		
    		for (let i in results) {
    			
    			objects[i] = scale(results[i]);    			
    		}
			    		
    		/**
    		* Found Somthing?
    		*/
    		if (debugging) {
    			
        		draw();
        		
    		}
    		
    		for (let i in objects) {
 
    			let object = objects[i];
    			
    			let distance = collide(object);
    			
    			if (distance>0) {
    		 
    				grid = toGrid(object);
    				
    				play(object, distance, grid);
    		    }
    		}
    		    			
		    detect();
		    
    	});
    	    	
    }, 250);

}

function scale(object) {
	
	let o = {label:object.label};
	
	o.x = object.x * scaleX;
	o.width = object.width * scaleX;
	
	o.y = object.y * scaleY;
	o.height = object.height * scaleY;
	
	return o;
}

/**
 * Return
 * 0: not collape
 * 1: Intersect
 * 2: Cover
 */
function collide(object) {
	
	if (object.x + object.width < centerX - parseInt(radiusW.value)/2) return 0;
	
	if (object.x > centerX + parseInt(radiusW.value)/2) return 0;
	
	if (object.y + object.height < centerY - parseInt(radiusH.value)/2) return 0;
	
	if (object.y > centerY + parseInt(radiusH.value)/2) return 0;
	
	ctx.globalAlpha = 0.2;
	
	if (object.x < centerX - parseInt(radiusW.value)/2 && 
			object.x + object.width > centerX + parseInt(radiusW.value)/2 &&
				object.y < centerY - parseInt(radiusH.value)/2 &&
					object.y + object.height > centerY + parseInt(radiusH.value)/2) {
		
		ctx.fillStyle = "red";
		ctx.fillRect(centerX - parseInt(radiusW.value)/2, centerY - parseInt(radiusH.value)/2, parseInt(radiusW.value), parseInt(radiusH.value));
		
		return 2;
	}
	
	ctx.fillStyle = "yellow";
	ctx.fillRect(centerX - parseInt(radiusW.value)/2, centerY - parseInt(radiusH.value)/2, parseInt(radiusW.value), parseInt(radiusH.value));
	
	return 1;
}

/**
 * To 0 - 4 (col, row)
 */
function toGrid(object) {
	 
	let objCenterX = object.x + object.width/2;
	
	let objCenterY = object.y + object.height/2;
	
	/**
	* Scale to 0 - 4 col x row
	*/
	let col = Math.floor((objCenterX/width) * 5);
	
	let row = Math.floor((objCenterY/height) * 5);
	
	return {col, row};
}

function play(object, distance, grid) {
	
	try {
				
		if (distance>1) {
			
			debug(object.label + " too close !!!" + ":" + shouldSpeak);
			
			if (shouldSpeak)
				wayOS.parse(object.label + " close");
			
		} else if (grid.col > 2) {
			
			debug(object.label + ": " + distance + ", " + grid.col + ", " + grid.row + ":" + shouldSpeak);
			
			if (shouldSpeak)
				wayOS.parse(object.label + " right");
			
		} else if (grid.col < 2) {
			
			debug(object.label + ": " + distance + ", " + grid.col + ", " + grid.row + ":" + shouldSpeak);
			
			if (shouldSpeak)
				wayOS.parse(object.label + " left");
			
		} else {
			
			debug(object.label + " " + distance + ", " + grid.col + ", " + grid.row + ":" + shouldSpeak);
			
			if (shouldSpeak)
				wayOS.parse(object.label);
		}
		
		//Update found obj position!
		lastCol = grid.col;
		lastRow = grid.row;
				
	} catch (e) {
		
		debug(e);
		
		//stopDetecting();
				
		//location.reload();
		
	}

}

function draw() {

	//ctx.globalAlpha = 0.5;
	ctx.fillStyle = "#000000";
	ctx.fillRect(0,0, width, height);
	ctx.clearRect(0,0, width, height);
	
	ctx.drawImage(video, 0, 0);

	//Draw focus area	
	ctx.globalAlpha = 1;	
	ctx.beginPath();
	ctx.rect(centerX - (radiusW.value/2), centerY - (radiusH.value/2), radiusW.value, radiusH.value);
	ctx.strokeStyle = "red";
	ctx.stroke();
	ctx.closePath();
  
	//Draw objects
	for (let i = 0; i < objects.length; i += 1) {
		ctx.font = "16px Arial";
    	ctx.fillStyle = "green";
    	ctx.fillText(objects[i].label, objects[i].x + 4, objects[i].y + 16); 

    	ctx.beginPath();
    	ctx.rect(objects[i].x, objects[i].y, objects[i].width, objects[i].height);
    	ctx.strokeStyle = "green";
    	ctx.stroke();
    	ctx.closePath();
	}
}

// Helper Functions
function getVideo(ml5) {
  // Create a webcam capture
  navigator.mediaDevices.getUserMedia({ video: {width, height, facingMode: 'environment'} }).then((stream) => {
    /* use the stream */
    capture = stream;
    
    //width = capture.getTracks()[0].getSettings().width;

    centerX = width / 2;

    centerY = height / 2;
    
    // Grab elements, create settings, etc.
    videoElement.setAttribute("style", "display: none; margin: auto"); 
    
    videoElement.width = width;
    
    videoElement.height = height;
    
    videoElement.onplaying = function () {
  	  startDetecting();
    };
    
    videoElement.onerror = function (e) {
  	  debug(e);
    };
    
    document.body.appendChild(videoElement);
        
    videoElement.srcObject = capture;
    
    videoElement.play();    
    
    canvas = document.getElementById("screen");

    ctx = canvas.getContext('2d');
    
    //Init wayOS
	console.log("Connecting to " + wayOS.playURL + " with sessionId " + wayOS.sessionId);
	
	wayOS.load("greeting");
        
  })
  .catch((err) => {
    /* handle the error */
    debug(err);
  });

  return videoElement
}

function createCanvas() {
	
	const canvas = document.createElement("canvas");
	
	canvas.id = "screen";
	
	canvas.width  = width;
	
	canvas.height = height;

	canvas.style.position = "fixed";
	
	canvas.style.right = "0";
	
	canvas.style.bottom = "0";
	
	canvas.style.minWidth = '100%';
	
	canvas.style.minHeight = '100%';
	
	document.body.appendChild(canvas);
	
	return canvas;

}

window.onresize = function () {
	
	location.reload();
	
};

window.onload = function () {
	
	if (debugging) {
			    
		let lastRadiusH = localStorage.getItem("radiusH");

		if (lastRadiusH) {
			
			console.log("Last Radius H:" + lastRadiusH);
			
			radiusH.value = lastRadiusH;
		}

		radiusH.onchange = function (e) {
			
			//console.log(e.srcElement.value);
			
			localStorage.setItem("radiusH", e.srcElement.value);
			
		}
		
		radiusH.style.width = '20px';
	    
	    document.body.appendChild(radiusH);	
	    
		
		let lastRadiusW = localStorage.getItem("radiusW");

		if (lastRadiusW) {
			
			console.log("Last Radius W:" + lastRadiusW);
			
			radiusW.value = lastRadiusW;
		}

		radiusW.onchange = function (e) {
			
			//console.log(e.srcElement.value);
			
			localStorage.setItem("radiusW", e.srcElement.value);
			
			onAdjustRadius = true;
		}
		
	    radiusW.style.width = width + 'px';
	    
	    document.body.appendChild(radiusW);
	    
	    document.body.appendChild(debugElement);
	    
	    createCanvas();	    		
	    
		debug("Capturing..");	
		
	} else {
		
	    createCanvas();		
	
	}
    
	//get the video
	video = getVideo(ml5); 
	
}

</script>
</body>
</html>