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
	
%>

<% if (properties.optString("title")!=null) { %>
<title><%= properties.optString("title") %></title>
<% } else { %>
<title>wayOS</title>
<% } %>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

</head>

<body style="background-color: <%= properties.opt("borderColor") %>">

<script src="https://unpkg.com/ml5@0.12.2/dist/ml5.min.js"></script>
<script src="../../app/cuteguard/robo.js"></script>
<script src="../../wayosapp.js"></script>
<script src="../../widget.js"></script>

<script>

var debugging = <%= request.getParameter("debug") != null %>;

var debugElement = document.createElement('span');

function debug(text) {
	
	debugElement.innerText = text;
	
	console.log(text);
}

var robo;

wayOS = new WayOS("<%= playURL %>", "<%= sessionId %>");

wayOS.onAsyncMessage = function(message) {
	
	robo.speak();
	
	wayOS.speak(message.text, function() {
		
		robo.standby();
		
	});	
		
};

//Blocking for debugging
wayOS.onmessages = function(messages) {
	
	console.log(JSON.stringify(messages));
	
	var step = function() {
		
		let message = messages.shift();
		
		if (!message) return;
				
		if (message.type==='text') {
			
			console.log(">>" + message.text);
			
			robo.speak();
						
			wayOS.speak(message.text, function() {
				
				robo.standby();
				
				setTimeout(function() {
					step();
				}, 2000);
				
			});
			
		} else if (message.type==='audio') {
			
			console.log(">>" + message.src);
			
			robo.speak();
						
			let audio = new Audio(message.src);
			
			audio.play();
			
			audio.onended = function() {
				
				robo.standby();
				
				setTimeout(function() {						
					step();
				}, 2000);
				
			}
			
		}
		
	}
	
	step();
		
};

// Copyright (c) 2019 ml5
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/* ===
ml5 Example
Real time Object Detection using objectDetector
=== */

const PADDING_RIGHT = 0;

const CHAT_BAR_HEIGHT = 50;

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
radiusW.type = 'range';
radiusW.value = 0;
radiusW.min = 0;
radiusW.max = width;

let radiusH = document.createElement("input");
radiusH.type = 'range';
radiusH.value = 0;
radiusH.min = 0;
radiusH.max = height;

let onAdjustRadius = false;

let centerX, centerY;

const lastFounds = [];

let lastPan, lastCol, lastRow = 0;

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
    	    	
        draw();
        
    	objectDetector.detect(video, function(err, results) {
    	      
    		if (err) {
    		    	
    			debug(err + ", Retry in 3 seconds..");
    			    
    			//setTimeout(startDetecting, 3000); For soft solution
    			location.reload(); //For hardcore solution 55555	    
    			    
    			return;
    		}
    		                    	
    		objects = [];
    		
    		for (let i in results) {
    			
    			objects[i] = scale(results[i]);    			
    		}
			
    		if (objects == null || objects.length==0) {
    		    	        		
            	robo.update();
            	
    		    detect();
    		        
    		    return;
    		}
    		
    		/**
    		* Found Somthing?
    		*/
    		    		        
    		draw();
    		    
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
    	    	
    }, 0);

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
		
		//Not same position, should speak it!
		//let shouldSpeak = grid.col !== lastCol || grid.row !== lastRow;
		let shouldSpeak = true;
		
		if (distance>1) {
			
			debug(object.label + " too close !!!");
			
			if (shouldSpeak)
				wayOS.parse("close " + object.label);
			
		} else if (grid.col > 2) {
			
			debug(object.label + ": " + distance + ", " + grid.col + ", " + grid.row);
			
			if (shouldSpeak)
				wayOS.parse("right " + object.label);
			
		} else if (grid.col < 2) {
			
			debug(object.label + ": " + distance + ", " + grid.col + ", " + grid.row);
			
			if (shouldSpeak)
				wayOS.parse("left " + object.label);
			
		} else {
			
			debug(object.label + " " + distance + ", " + grid.col + ", " + grid.row);
			
			if (shouldSpeak)
				wayOS.parse("found " + object.label);
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

  // Clear part of the canvas
  ctx.globalAlpha = 1.0;
  ctx.fillStyle = "#000000"
  ctx.fillRect(0,0, width, height);

  //ctx.drawImage(video, 0, 0);
  
	robo.draw();
 
  //Draw focus area
  ctx.globalAlpha = 0.2;
  
  if (onAdjustRadius) {
	  
	  ctx.beginPath();
	  ctx.strokeStyle = "red";  
	  ctx.rect(centerX - (radiusW.value/2), centerY - (radiusH.value/2), radiusW.value, radiusH.value);
	  ctx.stroke();
	  ctx.closePath();
	  
	  onAdjustRadius = false;
  }
  
  //ctx.globalAlpha = 1.0;
  
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

function createCanvas(w, h) {
	
  const canvas = document.createElement("canvas"); 
  canvas.id = "screen";
  canvas.width  = w;
  canvas.height = h;  
  document.body.appendChild(canvas);
  
  return canvas;
}

window.onresize = function () {
	
	location.reload();
	
};

window.onload = function () {
	
	if (debugging) {
		
	    document.body.appendChild(debugElement);
		
	    document.body.appendChild(document.createElement('br'));
	    
	}
    
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
    
    document.body.appendChild(document.createElement('br'));
	
    let screenCanvas = createCanvas(width, height);
    
    robo = new Robo(screenCanvas, '#F8B195');
	
    document.body.appendChild(document.createElement('br'));
    
	let lastRadiusH = localStorage.getItem("radiusH");

	if (lastRadiusH) {
		
		console.log("Last Radius H:" + lastRadiusH);
		
		radiusH.value = lastRadiusH;
	}

	radiusH.onchange = function (e) {
		
		//console.log(e.srcElement.value);
		
		localStorage.setItem("radiusH", e.srcElement.value);
		
		onAdjustRadius = true;
	}
	
	radiusH.style.width = width + 'px';
    
    document.body.appendChild(radiusH);	
	
	debug("Capturing..");

	//get the video
	video = getVideo(ml5); 
}

</script>
</body>
</html>