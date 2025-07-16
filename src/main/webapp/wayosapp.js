class WayOS {

	constructor (playURL, sessionId) {
		
		//For mockup test widget
		if (!playURL && !sessionId) {
			this.props = {};
			this.props.language = 'en';
			return;
		}
		
		this.playURL = playURL;
		this.webhookURL = this.playURL.replace('/x/', '/webhooks/');
		this.propsURL = this.webhookURL.replace('webhooks', 'props');
		this.websocketURL = this.webhookURL.replace('webhooks', 'websocket');
		if (this.websocketURL.startsWith("https:")) {
			this.websocketURL = this.websocketURL.replace('https', 'wss');
		} else if (this.websocketURL.startsWith("http:")) {
			this.websocketURL = this.websocketURL.replace('http', 'ws');			
		}
		this.coverImageURL = this.webhookURL.replace('webhooks', 'public') + '.PNG';
		this.defaultMenuImageURL = this.webhookURL.substring(0, this.webhookURL.indexOf('/webhooks')) + '/images/gigi.png';

		this.sessionId = sessionId;
		//Default callbacks, For debugging purpose!
		
		this.onload = function(props) {
			console.log("DEBUG: LOAD..");
			console.log(JSON.stringify(props));
			console.log("\n");
		}
		
		this.onparse = function(message) {
			console.log("DEBUG: PARSING..");
			console.log(message);
			console.log("\n");
		}
		
		this.onmessages = function(messages) {
			console.log("DEBUG: GOT..");
			console.log(JSON.stringify(messages));
			console.log("\n");
		}
		
		this.onAsyncMessage = function(message) {
			console.log("DEBUG: GOT..");
			console.log(message);
			console.log("\n");
		}
	}

	load(initMessage) {
		
 		let url = this.propsURL;
 		
 		//From specific sessionId attribute
		if (!this.sessionId) {

			//Use last sessionId
			this.sessionId = localStorage.getItem(this.websocketURL);
			//console.log("LocalStorage sessionId " + this.sessionId);
			
		}
		 		
		if (this.sessionId) {
			url += "?sessionId=" + this.sessionId;				
		}
		
	 	var xhr = new XMLHttpRequest();
	 	xhr.open("GET", url, true);
	 	
	 	xhr.onload = function() {
	 		
	 	  	if (xhr.status === 200) {
	 	  	
				this.props = JSON.parse(xhr.responseText);
				this.sessionId = this.props.sessionId;
				localStorage.setItem(this.websocketURL, this.sessionId);
				//console.log("INIT " + url + " with sessionId:" + this.sessionId);
				
				//Designer can override cover image in properties pane
				if (!this.props.coverImageURL) {
					this.props.coverImageURL = this.coverImageURL;
				}
				
				if (!this.props.defaultMenuImageURL) {
					this.props.defaultMenuImageURL = this.defaultMenuImageURL;
				}				
				
				this.onload(this.props);
	 	  		
				this.initWebSocket();
				
	 	  		this.parse(initMessage);

	 		}

	 	}.bind(this);
	 	
	 	xhr.send();
	 	
    }
	
	parse(message, from) {
			  	
		this.onparse(message, from);
		
		let xhr = new XMLHttpRequest();
 		let url = this.webhookURL;
 		
 		let params = "message=" + encodeURIComponent(message) + "&sessionId=" + this.sessionId;
 		
 		xhr.open("POST", url, true);
 		xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

 		xhr.onload = function() {
 			
 		    if (xhr.status === 200) {
 		    	
 		    	this.onmessages(JSON.parse(xhr.responseText));
 		    	
 		    }
 		    
 		}.bind(this);
 		
 		xhr.send(params);
	}
	
	dropFile(file, message) {
		
		this.onparse('Dropping ' + file.name);
		
        let formData = new FormData();
        
		if (message) {
			
			formData.append('message', message);
			
		}
		
		if (file && file.length) {
		
	        for (let i in file) {
				
	    		formData.append('file', file[i], file[i].name);
	    		
	        }
    		
		} else {
			
    		formData.append('file', file, file.name);
    		
	    }
		        
 		let xhr = new XMLHttpRequest();
 		
 		let url = this.webhookURL + "/" + this.sessionId;
 		
 		xhr.open("POST", url); 
 		
 		xhr.onload = function() {
			 
			 //console.log("Dropping.." + xhr.status);
 			
 		    if (xhr.status === 200) {
 		    	
 		    	this.onmessages(JSON.parse(xhr.responseText));
 		    	
 		    }
 			
 		}.bind(this);
 		
 		xhr.send(formData);	
 	}
 		
	initWebSocket() {
		
 		let url = this.websocketURL + "/" + this.sessionId;
	 	
	 	console.log('Connecting..' + url);
	 	
		let websocket = new WebSocket(url);
		
		websocket.onopen = function () {
			
	        console.log('Info: WebSocket connection opened for ' + url);
	        
	    };

	    websocket.onclose = function () {
	    	
	    	//console.log('Info: WebSocket closed.');
	    	
	    };

	    websocket.onmessage = function (message) {
	    	
			console.log("Incoming message:" + message.data);
			
			let messageArray = JSON.parse(message.data);
			if (messageArray.length==1 && messageArray[0].type==='forward') {
				
				console.log("Continue Flow from Async Command: " + messageArray[0].text);
				this.parse(messageArray[0].text);
				return;
				
			}
			
			if (messageArray.length==1 && messageArray[0].type==='partial') {
				
				console.log("Append: " + messageArray[0].text);
				this.onAsyncMessage(messageArray[0].text);
				
				return;
				
			}
			
			//To support websocket callback to manipulate outer DOM
			let parentElement = this.parentElement;
			try {
				
				if (parentElement.dataset.onmessage) {
					
					window[parentElement.dataset.onmessage].call(parentElement, JSON.parse(message.data));
					
				}
				
			} catch (error) {
				console.log(error);
			}

 		    this.onmessages(JSON.parse(message.data));//Play Message rather than parse again!			
 		    
 		}.bind(this);
	}
	
	speak(text, onFinish) {
		
		if (this.speaking) return;
		
 		if ("speechSynthesis" in window) {
 			
 			const synth = window.speechSynthesis;
 			const voices = synth.getVoices();
 			const lang = this.props.language.toLowerCase();
 			
	 		//console.log ("Finding voice.." + lang);
 			
 			const msg = new SpeechSynthesisUtterance();
			//msg.text = text.replace(/([\s.'ๆ,])\1+/, 'ๆ'); //Replace repeting ๆ to single one
			msg.text = text;
			msg.voice = voices.find(
				(voice) => voice.lang.startsWith(lang)
			);
			
			if (onFinish) {
				msg.onend = function(e) {
					onFinish();
				}
			}
 	
			if (msg.voice) {
 				
 				//console.log("Start Using voice.." + msg.voice.name);
 	 			
				this.speaking = true;
				
				synth.cancel();
				
 				synth.speak(msg);
 				
 				setTimeout(function() {
					 
					this.speaking = false;
					
				}.bind(this), 3000);
 
			} else {
 			
				console.log('speechSynthesis not support!');
 				console.log(text);
 				console.log('\n');
				
				if (onFinish) {
					onFinish();					
				}
				 			
 			}
		
		}
	}
}

class FrameUX {

	constructor(parentElement) {		
		this.parentElement = parentElement;	
	}
	
	init (props) {
		
		this.props = props;
		//To prevent duplicate from from ringing
		if (this.frame) {
			this.parentElement.removeChild(this.frame);		
		}

		this.frame = document.createElement("iframe");
		this.frame.scrolling = "no";
		this.frame.allowfullscreen = "true";
		this.frame.style.width = "100%";
		this.frame.style.height = "100vh";//Fallback config for old browser
		this.frame.style.flex = 1;
		this.frame.style.borderWidth = "0px";
		
		//Id for widget query
		this.frame.dataset.parentElementId = this.parentElement.id;
		
		this.parentElement.appendChild(this.frame);
		
		this.frame.onload = function () {
			this.reload();
		}.bind(this);
		
		//this.frame.src = "about:blank";		
		this.frame.contentWindow.location.reload();
		
	}
	
	reload () {
		
		console.log("Frame reload...");
		
		this.frame.contentDocument.head.innerHTML = "";
		this.frame.contentDocument.body.innerHTML = "";
		
		//this.frame.contentDocument.body.style.paddingTop = "20px";
		//this.frame.contentDocument.body.style.paddingBottom = "20px";
		
		this.frame.contentDocument.body.style.backgroundRepeat = "no-repeat";
		this.frame.contentDocument.body.style.backgroundSize = "cover"; // or contain
		this.frame.contentDocument.body.style.backgroundPosition = "center";
		this.frame.contentDocument.body.style.height = "100%";			
		
		/**
		* Apply Background color or image when load or ring pressed
		*/
		this.frame.contentDocument.body.style.backgroundColor = this.props.borderColor;
		
		if (this.props.publish && this.props.publish==='true') {
			this.frame.contentDocument.body.style.backgroundImage = "url('" + this.props.coverImageURL + "')";
		}
					
		let style = this.frame.contentDocument.createElement('style');
		style.textContent = 
		`div.vertical-center, p {
			touch-action: none;
		}
		img {
		  width: 100%;
		  height: 100%;
		}
		.vertical {
			width: 100%;
		}
		.vertical-top {
			margin: 0;
			position: absolute;
			color: white;
			width: 100%;
			transform: translateX(-8px);
		}
		.vertical-center-icon {
			margin: 0;
			position: absolute;
			width: 100%;
			height: 100%;
			transform: translateX(-8px) translateY(-8px);
		}
		.vertical-center {
			margin: 0;
			position: absolute;
			width: 100%;
			//height: 100%;
			top: 50%;
			transform: translateX(-8px) translateY(-50%);
		}
		.vertical-bottom {
			margin: 0;
			position: absolute;
			width: 100%;
			bottom: 15%;
			transform: translateX(-8px);
		}
		video {
			width: 100%;
	    	height: 100%;
			object-fit: cover;
		}
		video::-webkit-media-controls-start-playback-button {
		    display: none !important;
		    opacity: 0 !important;
		}			
		.wayos-image-head {
			cursor: pointer;
		    //width: 90%;
		    //height: 40vh;
			width: 50vw;
			height: 50vh;
			margin: 0px auto;
		    border-radius: 15px;
		    -moz-border-radius: 15px;
		    -webkit-border-radius: 15px;
		    background-position: center; 
		    background-repeat: no-repeat;
		    //background-size: cover;
		    background-size: contain;
		}
		.wayos-image-icon {
			width: 100%;
			height: 100%;
		    background-position: center; 
		    background-repeat: no-repeat;
		    background-size: contain;
		}
		.wayos-label { 
			cursor: pointer; 
			width: 80%; 
			border-radius: 15px; 
			-moz-border-radius: 15px; 
			-webkit-border-radius: 15px; 
			padding: 2px 10px; 
			color: white; 
			background: ${this.props.borderColor}
		} 
		.wayos-menu {
		    border-radius: 15px;
		    -moz-border-radius: 15px;
		    -webkit-border-radius: 15px;
		}
		.wayos-menu-item { 
			cursor: pointer; 
			width: 80%; 
			margin: 5px; 
			padding: 5px 10px; 
			border-radius: 5px; 
			-moz-border-radius: 5px; 
			-webkit-border-radius: 5px; 
			background: #FFFFFF; 
			text-align: center; 
			color: ${this.props.borderColor}; 
			border: 1px solid ${this.props.borderColor} 
		}`;
		
		this.frame.contentDocument.head.appendChild(style);		
		this.style = style;
		
		let script = this.frame.contentDocument.createElement('script');
		script.textContent = `var wayOS = parent.document.getElementById("${this.parentElement.id}").wayOS;`;
		this.frame.contentDocument.head.appendChild(script);
		this.script = script;
				
		this.top = this.frame.contentDocument.createElement('div');
		this.top.setAttribute('align', 'center');
		this.top.setAttribute('class', 'vertical-top');
		this.top.innerHTML = `👁️ ${this.props.viewCount}`;
		this.frame.contentDocument.body.appendChild(this.top);
		
		this.icon = this.frame.contentDocument.createElement('div');
		this.icon.setAttribute('align', 'center');
		this.icon.setAttribute('class', 'vertical-center-icon');		
		this.frame.contentDocument.body.appendChild(this.icon);
		
		this.content = this.frame.contentDocument.createElement('div');
		this.content.setAttribute('align', 'center');
		this.content.setAttribute('class', 'vertical-center');		
		this.frame.contentDocument.body.appendChild(this.content);
		
		/*
 	  	if (this.props.loadingGif) {

 	  		loading.classList.remove("wayos-loader");
 	  		loading.classList.add("gifLoader"); 	  		
 	  		loading.style.backgroundImage = "url('" + this.props.loadingGif + "')";
 	  		
 	  	} else {
 	  		
 	  		loading.classList.remove("gifLoader");
 	  		loading.classList.add("wayos-loader");
 	  		loading.style.backgroundImage = "";
 	  		
 	  	}
		*/		
	}
	
	/**
	 * Override here to display content
	 */
	play (messages) {}

	/**
	 * Show background image as a content of single menu or center it.
	 * @returns 
	 */
	verticalPosition () {
				
		return document.body.style.backgroundImage ? "vertical-bottom" : "vertical-center";
	}
	
	locateTo (url) {
		
		const src = this.frame.src;			
		let that = this;
		
		this.frame.onload = function () {
			
			this.style.height = this.parentElement.offsetHeight + 'px';
			
			//this.onload = null;
		}
		this.frame.onerror = function (e) {
			console.log("Error: " + e);
			this.src = src;
		}
		this.frame.src = url;
	}
	
	setInnerHTML (innerHTML, onload) {
		
		this.content.innerHTML = innerHTML;
		
		//Has Icon, So move to below
		if (this.icon.innerHTML!="") {
			this.content.className = "vertical-bottom";
		} else {
			this.content.className = "vertical-center";			
		} 
		
		if (onload)
				onload(this.frame);
	}
	
	setText (innerHTML, onload) {
				
		this.content.innerHTML = innerHTML;
		
		//Has Icon, So move to below
		if (this.icon.innerHTML!="") {
			this.content.className = "vertical-bottom";
		} else {
			this.content.className = "vertical-center";
		}
		
		if (onload)
				onload(this.frame);
				
	}
	
	appendText (text) {
		
		if (!this.content.firstElementChild || this.content.firstElementChild.tagName !== "H2") {
			
			let innerHTML = "<h2 class=\"wayos-label\"></h2>";
			
			this.content.innerHTML = innerHTML;		
		}
		
		let textChild = this.content.firstChild;
		
		textChild.innerText = textChild.innerText + text;
		
	}	
	
	
	setIconImage (innerHTML, onload) {
		
		//this.icon.className = "vertical-center-icon";
		this.icon.innerHTML = innerHTML;
		
		//Has Text, So move to below
		if (this.content.innerHTML!="" && this.content.innerHTML.startsWith("<h1")) {
			this.content.className = "vertical-bottom";
		} else {
			this.content.className = "vertical-center";
		}
		
		if (onload)
				onload(this.frame);
	}
	
	clearIconImage () {
		
		if (this.icon)
			this.icon.innerHTML = '';
		
	}
	
	clearBackgroundImage () {
		
		this.frame.contentDocument.body.style.backgroundColor = this.props.borderColor;
		
		if (this.props.publish && this.props.publish==='true') {
			this.frame.contentDocument.body.style.backgroundImage = "url('" + this.props.coverImageURL + "')";
		}
		
	}
	
	setBackgroundImage (src, onload) {
		
		this.frame.contentDocument.body.style.backgroundImage = 'url("' + src +'")';
		
		if (onload)
				onload(this.frame);
	}
	
	
	br () {
		return "<br>";
	}
	
	div (innerHTML, position) {
		
		if (position)
			return "<div align=\"center\" class=\"" + position + "\">" + innerHTML + "</div>";
			
		return "<div align=\"center\" class=\"vertical\">" + innerHTML + "</div>";
	}

	p (innerHTML) {
		return "<p>" + innerHTML + "</p>";
	}

	img (src) {
		//return "<img src=\"" + src + "\"></img>";
		return "<div class=\"wayos-image-icon\" style=\"background-image: url('" + src + "');\"></div>";
	}
	
	h1 (innerHTML) {
		return "<h1 class=\"wayos-label\">" + innerHTML + "</h1>";
	}

	a (href, innerHTML) {
		return "<a href=\"" + href + "\" target=\"_blank\">" + innerHTML + "</a>";
	}
	
	image (imageURL, linkTo) {
		return "<div class=\"wayos-image-head\" onclick=\"" + linkTo + "\" style=\"background-image: url('" + imageURL + "');\"></div>";
	}
	
	audio (audioURL) {
		return "<audio controls style=\"width:95%\"><source src=\"" + audioURL +"\" type=\"audio/mp4\"></audio>";
	}
		
	video (videoURL) {
		return "<video controls style=\"width:95%\"><source src=\"" + videoURL +"\" type=\"video/mp4\"></video>";
	}
		
	menus (menusObject, direction) {
								
		let menuArray = menusObject.menus;
		let html = '';
		
		let isSlideMenu = false;
		
		if (menuArray.length>1) {
			
			html += "<div style=\"overflow: auto; white-space: nowrap;\">";
			isSlideMenu = true;
    		
		}
				
		let menuObject;
		
	    for (let i in menuArray) {
	        			        		
	        if (menuArray.length>1) {
	       
	        	html += "<div align=\"center\" style=\"" + direction + "\">";
	    		
	        }
	        
	        menuObject = menuArray[i];
	        
	        html += this.menu(menuObject, isSlideMenu);
    			    			
	        if (menuArray.length>1) {
				
	        	html += "</div>";
	    		
	        } 
	     
	    }
	    	
	    if (menuArray.length>1) {
			
	    	html += "</div>";
    		
		}
		
		return html;
	}
	
	widget (linkURL) {
		
		//let html = '';
		
		//return html;
		
		return this.frame(linkURL);
	}
	
	//Todo: Reset For widget
	iframe (src) {
		return "<iframe src=\"" + src + "\" scrolling=\"no\" frameborder=\"0\" allowfullscreen></iframe>";
	}	
	
	menu (menuObject, isSlideMenu) {
		
		let html = '';
		let choice;
		let defaultChoice;
		let clickEvent;
		
        if (menuObject.choices.length>0) {
			
	        defaultChoice = menuObject.choices[0];//Default Choice for image and label touch
	        		
    		if (defaultChoice.linkURL || defaultChoice.imageURL) {
    					
    			clickEvent = "window.open('" + defaultChoice.linkURL + "', '_blank')";
    							
    		} else {
	        		
    			clickEvent = "wayOS.parse('" + this.escapeHtml(defaultChoice.parent + " " + defaultChoice.label) + "')";
    			
    		}
        			
        } else {
        			
        	clickEvent = "";
        	
        }	
				
        if (menuObject.imageURL) {
        			
        	html += this.image(menuObject.imageURL, clickEvent);
    				
        } else if (isSlideMenu) {
        			
        	/**
             * Default Image for Slide Menu Only
             */
             html += this.image(this.props.defaultMenuImageURL, clickEvent);
    		 
        }
        
        menuObject.label =  menuObject.label.replaceAll(/\n/g, "<br>");//Keep newline
        		
        html += "<div align=\"center\" onclick=\"" + clickEvent + "\"><h1 class=\"wayos-label\">" + menuObject.label + "</h1></div>";

        if (menuObject.choices.length>0) {
    				
        	html += "<div align=\"center\">";
    				
        	for (let j in menuObject.choices) {
        				
        		choice = menuObject.choices[j];
        		
        		if (choice.linkURL || choice.imageURL) {
        					
        			html += "<a href=\"" + choice.linkURL + "\" target=\"_blank\"><div class=\"wayos-menu-item\">" + choice.label + "</div></a>";
        					
        		} else {
        			
        			clickEvent = "wayOS.parse('" + this.escapeHtml(choice.parent + " " + choice.label) + "', this)";
        					
        			html += "<div class=\"wayos-menu-item\" onclick=\"" + clickEvent + "\">" + choice.label + "</div>";
        		}
        	}
        	
        	html += "</div>";
        	
    	}
        
        return html;
	}
	
	escapeHtml (unsafe) {
		
		return unsafe.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;').replaceAll("'", '&#039;');
	}

}

class AnimateFrameUX extends FrameUX {

	constructor(parentElement, wayOS) {
		super(parentElement, wayOS);
	}

	/**
	* Display Simple Animation on wayos-frame
	*/
	play(messages) {
		
		this.clearIconImage();//Clear
		
		//Break Animation
		if (this.timeoutId) {
			clearTimeout(this.timeoutId);
		}

		//Reset Icon
		//this.icon.innerHTML = "";
		let duration = 250 * 2;
		
		const timing = {
		  		duration,
				iterations: 1,
			};
		
		let fadeOut = [
			{ opacity: "1" },
			{ opacity: "0" },
		];												
		
		let fadeIn = [
			{ opacity: "0" },
			{ opacity: "1" },
		];
		
		let step = function() {
			
			let that = this;
				
			let message = messages.shift();
			
			if (!message) return;
			
			function next() { 
														
				if (messages.length==0) return;
																							
				try {
										
					let fadeOutAnimation = that.content.animate(fadeOut, timing);
					fadeOutAnimation.onfinish = (event) => {
						
						step();							
						
					};

				} catch (error) {
					
					if (error.name === "NS_ERROR_FAILURE") {
												
						alert("By just upgrade your OS or use last version of Google Chrome");
						throw error;
						
					}
				}
								
			};
								
			if (message.type==='menus') {
				
				//this.clearIconImage();
									
				let innerHTML;
				if (message.menus.length > 1) {
					
					//For Slide Menus
					innerHTML = this.p(this.menus(message, 'display: inline-block; width: 70%'));
					
				} else if (message.menus[0].type!=='widget') {
					
					//For Single Menu
					innerHTML = this.p(this.menus(message, 'display: inline-block; width: 100%'));
										
					//Sow chatbar only if no choice item
					let hasNoChoice = message.menus[0].choices.length===0;
					//console.log("Is single menu with no choices: " + hasNoChoice);
					if (hasNoChoice) {
						this.parentElement.chatBar.show();
					}
										
				} else {
					
					//For Widget
					this.locateTo(message.menus[0].linkURL);
					return;
					
				}
				
				this.setInnerHTML(innerHTML, (frame)=>{if (next) next()});						
									
				try {
					
					
					this.content.animate(fadeIn, timing);
				
				} catch (error) {
					

					if (error.name === "NS_ERROR_FAILURE") {
						
						alert("Please use modern browser!");
						throw error;
					
					}
				}
				
			}
			
			//TODO: Test For Widget
			if (message.type==='widget' /*|| message.type==='audio' || message.type==='video'*/) {
			
				this.locateTo(message.src);
				return;
			}
			
			if (message.type==='video') {
				
				this.clearIconImage();
				//this.clearBackgroundImage();
				
				let video = document.createElement('video');
				
				video.src = message.src;
												
				this.icon.appendChild(video);

				video.onended = function() {
										
					//this.clearIconImage();//Clear					
					
					//if (next) next();
					
					let canvas = document.createElement('canvas');
					
					canvas.width = window.innerWidth;
					canvas.height = window.innerHeight;
					
					console.log(canvas.width + "x" + canvas.height);
					
					let ctx = canvas.getContext('2d');					
					ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
					
					let videoCapturedURI = canvas.toDataURL('image/png');
					
					this.setBackgroundImage(videoCapturedURI, (frame)=>{if (next) next()});
					
					video.remove();
			
				}.bind(this);
				
				video.onplay = function () {
					
					const timing = {
					  		duration: 1000,
							iterations: 1,
						};
					
					let fadeIn = [
						{ opacity: "0" },
						{ opacity: "1" },
					];				
					
					let fadeInAnimation = video.animate(fadeIn, timing);
					fadeInAnimation.onfinish = (event) => {
						
					};					
					
				}.bind(this);
				
				video.onerror = function(e) {
					
					alert(JSON.stringify(e));
					
				}
				
				video.play().catch(error => {
					
					alert(error);
				    
				});
				
				video.style.aspectRatio = "unset";
				
			    video.setAttribute("width", window.innerWidth);
			    video.setAttribute("height", window.innerHeight);
				// Ensure inline playback on iOS
			    video.setAttribute("playsinline", "true");
			    video.setAttribute("webkit-playsinline", "true");
			    
			    video.play();
					
			}
			
			if (message.type==='audio') {
				
				this.parentElement.play(message.src);
				
				if (next) next();
				
			}

			if (message.type==='link') {
									
				//Fast redirect if found playURL
				let playDomain = this.parentElement.wayOS.playURL.substring(0, this.parentElement.wayOS.playURL.lastIndexOf("/x/") + 3);
				console.log("Found link! Compare to auto redirect " + playDomain);
				
				if (message.src.startsWith(playDomain)) {
					
					window.location.replace(message.src); //Cannot back!
					
				} else {
					
					let innerHTML = this.a(message.src, this.h1(message.src));
					
					this.setText(innerHTML, (frame)=>{if (next) next()});	
					
				}
				
			}

			if (message.type==='image') {
								
				if (message.src.endsWith('png') || message.src.endsWith('PNG') ||///Experimental to display gif animation or PNG (transparent bkg) over the background
					message.src.endsWith('gif') || message.src.endsWith('GIF')) {					
					
					this.setIconImage(this.img(message.src), (frame)=>{if (next) next()});
				
				} 
				//For jpeg use as background image
				else {
					
					this.setBackgroundImage(message.src, (frame)=>{if (next) next()});
						
					try {
												
						this.content.animate(fadeIn, timing);

					} catch (error) {
						
						if (error.name === "NS_ERROR_FAILURE") {
							
							alert("Please use modern browser!");
							throw error;
							
						}					
						
					}
					
				}
								
			}

			if (message.type==='text') {
			
				let text = message.text;
								
				if (text.endsWith(".."))
					this.animateTypingText(text, next);
				else if (text.endsWith("."))
					this.animateTypingText(text, next, 50);
				else if (text.endsWith("ๆ"))
					this.animateJumpingText(text.replace("ๆ", ""), next);
				else {
					text =  text.replaceAll(/\n/g, "<br>");//Keep newline
					this.setText("<h1 class=\"wayos-label\">" + text + "</h1>", function(fame) {
						if (next) {
							setTimeout(function() {
								next();								
							}, 250 * 3);
						}	
					});					
				}			

				try {
										
					this.content.animate(fadeIn, timing);

				} catch (error) {
					
					if (error.name === "NS_ERROR_FAILURE") {
						
						alert("Please use modern browser!");
						throw error;
						
					}
						
				}
				
			}
				
		}.bind(this);
		
		setTimeout(step, 250);//delay for first scene
	}
	
	animateJumpingText(text, next) {
					
		let innerHTML = "<h1 class=\"wayos-label\">" + text + "</h1>";
		
		let that = this;
				
		this.setText(innerHTML, function (frame) {
											
				const jumpingText = frame.contentWindow.document.getElementsByTagName("h1")[0];
				
				this.parentElement.play('/public/eoss-th/question_003.ogg');
				
				let duration = 500;
				const jumping = [
					{ transform: "translateY(100px) scale(0.5)" },
					{ transform: "translateY(-20px) scale(1.25)" },
					{ transform: "translateY(20px) scale(1)" },
					{ transform: "translateY(-10px) scale(1)" },
					{ transform: "translateY(0) scale(1)" },
				];
				
				const timing = {
			  		duration,
					iterations: 1,
				};
				
				if (jumpingText) {
					
					try {
												
						jumpingText.animate(jumping, timing);				

					} catch (error) {
						
						if (error.name === "NS_ERROR_FAILURE") {
							
							alert("Please use modern browser!");
							throw error;
						
						}
						
					}
				
				}
													
				that.timeoutId = setTimeout(function() {						
					if (next) {
						next();				
					}
				}, duration);
				
			}.bind(this));		
	}
	
	animateTypingText(text, next, speed) {
		
		let innerHTML = "<h1 class=\"wayos-label\"></h1>";
		
		let that = this;
		
		let duration = speed ? speed : 120;		
				
		this.setText(innerHTML, function (frame) {
					
				if (this.parentElement.speak) {
															
					this.parentElement.wayOS.speak(text);
				}
					
				const typingText = frame.contentWindow.document.getElementsByTagName("h1")[0];
				const textArray = text.split("");
				textArray.push("\r");
				let i = 0;
					
				function type(c) {
						
					if (c==="\r") {
						frame.onload = null;
						if (next) {
							delete that.timeoutId;
							next();							
						}
						return;
					} 
						
					if (c==="\n") {
						c = "<br>";
					}
											
					typingText.innerHTML = typingText.innerHTML + c;
					
					//Vibrate
					if (c==='ๆ' && Navigator.vibrate) {
							
						Navigator.vibrate(200);						
							
					}
					
					that.timeoutId = setTimeout(function() {
						type(textArray[i++]);
					}, duration);
						
				};
					
				try {
											
					type(textArray[i++]);

				} catch (error) {
					
					alert("Please use modern browser!");
					throw error;
					
				}
					
			}.bind(this));		
	}
		
	/**
	* Show background image as a content of single menu or center it.
	*/
	position () {
	
		return document.body.style.backgroundImage ? "vertical-bottom" : "vertical-center";
	}	

}

/**
 * For default ring and riches menu
 */
class NavBar {
	
	constructor(parentElement) {
		
		this.parentElement = parentElement;
		
		if (document.getElementById(this.parentElement.dataset.topId)) {
			
			this.bar = document.getElementById(this.parentElement.dataset.topId);
			
		} else {
			
			this.bar = document.createElement("span");
			this.parentElement.appendChild(this.bar);
		}
						
		this.title = document.createElement("button");
		this.title.className = "wayos-nav wayos-title-menu";
		this.title.innerHTML = "wayOS";
 		this.title.addEventListener('click', function(event) {
 			
 			this.onTitleButtonClick();
 			
	    }.bind(this));
 		this.title.style.color = "WHITE";
 		this.title.style.display = "none";
 		this.bar.appendChild(this.title);
 		
		this.ringButton = document.createElement("button");
		this.ringButton.className = "wayos-nav wayos-rich-menu";
		this.ringButton.innerHTML = "🔔";
		this.ringButton.disabled = true;
 		this.ringButton.style.display = "none";
 		this.ringButton.addEventListener('click', function(event) {
 			
 			this.onRingButtonClick();
			
	    }.bind(this));
 		this.bar.appendChild(this.ringButton); 		
		
		this.chatButton = document.createElement("button");
		this.chatButton.className = "wayos-nav wayos-rich-menu";
		this.chatButton.innerHTML = "💬";
		this.chatButton.disabled = true;
 		this.chatButton.style.display = "none";
 		this.chatButton.addEventListener('click', function(event) {
 			
 			this.onChatButtonClick();
			
	    }.bind(this));
 		this.bar.appendChild(this.chatButton); 		
		 		
		this.richArea = document.createElement("span");
 		this.bar.appendChild(this.richArea);
 		 				
		this.onTitleButtonClick = function() {
			console.log("DEBUG: Title click..");
			console.log("\n");
		}
		
		this.onRingButtonClick = function() {
			console.log("DEBUG: RINGING..");
			console.log("\n");
		}
		
		this.onChatButtonClick = function() {
			console.log("DEBUG: Toggling chat bar..");
			console.log("\n");
		}
		
		this.onCreateRichMenus = function(props, richMenus) {
			
			console.log("DEBUG: onCreateRichMenus.." + JSON.stringify(richMenus));
			console.log("\n");
			
		};
	}
	
	init(props) {
		
		//this.bar.style.width = '100%';
		
		this.title.innerHTML = props.title ? props.title : "wayOS";
 		//this.title.style.backgroundColor = props.borderColor;
				
 		this.chatButton.disabled = false;
 		this.chatButton.style.color = "WHITE";
 		//this.chatButton.style.backgroundColor = props.borderColor;
 		
 		this.ringButton.disabled = false;
 		this.ringButton.style.color = "WHITE";
 		//this.ringButton.style.backgroundColor = props.borderColor;
 		 		
   		if (props.richMenus) {
   			
   			let richMenus = [];
   			let items = props.richMenus.split(',');
   			
   			for (let i in items) {
   				let item = items[i].trim(); 
   				richMenus.push(item);
   			}
   		
   			this.onCreateRichMenus(props, richMenus);
   		}
		
	}
	
	show(menus) {
		if (menus && menus.length) {
			for (let i in menus) {
				if (menus[i]==='title') {
			 		this.title.style.display = "inline-block";	
			 		continue;	
				}
				if (menus[i]==='ring') {
			 		this.ringButton.style.display = "inline-block";					
			 		continue;	
				}
				if (menus[i]==='chat') {
			 		this.chatButton.style.display = "inline-block";					
			 		continue;	
				}
			}
		}
	}
}

/**
 * For contact
 */
class ChatBar {
	
	constructor(parentElement) {
		
		this.parentElement = parentElement;
		
		//To prevent duplicated from from ringing
		if (this.bar) {
			this.parentElement.removeChild(this.bar);		
		}
		
		this.inputTextArea = document.createElement("textarea");		
		this.inputTextArea.className = "wayos-textarea";
		this.inputTextArea.rows = "1";
		this.inputTextArea.cols = "33";
		this.inputTextArea.disabled = true;
				
		this.fileDialog = document.createElement("input");
		this.fileDialog.type = "file";		
		this.fileDialog.style.display = "none";
  		this.fileDialog.onchange = function () {
  			
 	  		this.onFileDialogSubmit(Array.from(this.fileDialog.files));
 	  		
  		}.bind(this);		
				
		this.fileButton = document.createElement("button");
		this.fileButton.className = "wayos-file-button";
		this.fileButton.innerHTML = "🖼";
 		this.fileButton.addEventListener('click', function() {
 			 	  		
 	  		this.fileDialog.click();
 	  		
 	  	}.bind(this));		
		this.fileButton.disabled = true;
				
		this.ringButton = document.createElement("button");
		this.ringButton.className = "wayos-button";
		this.ringButton.innerHTML = "🔔";
 		this.ringButton.addEventListener('click', function(event) {
 			
 			this.onRingButtonClick();
			
	    }.bind(this));
		this.ringButton.disabled = true;
				
		this.sendButton = document.createElement("Button");
		this.sendButton.className = "wayos-button";		
		this.sendButton.innerHTML = "SEND";
 		this.sendButton.addEventListener('click', function(event) {
 			
            let text = this.inputTextArea.value.trim();
			if (text != '') {
				
	 			this.onSendButtonClick(text);
	 			this.inputTextArea.value = "";				
			}
			
	    }.bind(this));		
		this.sendButton.disabled = true;
		
		//Overrrides these callback.		
		this.onFileDialogSubmit = function(files) {			
			console.log("DEBUG: DROPPING..");
	        for (let i in files) {
				console.log(files[i].name);				
	        }			
			console.log("\n");
		}
		
		this.onRingButtonClick = function() {
			console.log("DEBUG: RINGING..");
			console.log("\n");
		}
		
		this.onSendButtonClick = function(text) {
			console.log("DEBUG: SENDING..");
			console.log(text);
			console.log("\n");
		}
		
		this.bar = document.createElement("span");		
		this.bar.appendChild(this.inputTextArea);
		this.bar.appendChild(document.createElement("br"));
		this.bar.appendChild(this.fileDialog);
		this.bar.appendChild(this.fileButton);
		this.bar.appendChild(this.ringButton);
		this.bar.appendChild(this.sendButton);
		this.bar.appendChild(document.createElement("br"));
		
		//Trying to move chatbar to the bottom
		this.bar.style.alignSelf = 'flex-end';
		this.bar.style.width = '100%';
		
	}
		
	init(props) {
		
 		console.log("Apply Console style.." + JSON.stringify(props));
 	  	
 		this.inputTextArea.disabled = false;
 		this.inputTextArea.autofocus = true;
 		
 		this.fileButton.disabled = false;
 		this.fileButton.style.color = "WHITE";
 		this.fileButton.style.backgroundColor = props.borderColor;
 	  	
 		this.ringButton.disabled = false;
 		this.ringButton.style.color = "WHITE";
 		this.ringButton.style.backgroundColor = props.borderColor;
 	  	
 		this.sendButton.disabled = false;
 		this.sendButton.style.color = "WHITE";
 		this.sendButton.style.backgroundColor = props.borderColor;  	 		
 		
		this.parentElement.appendChild(this.bar);
	}
	
	show() {
		this.bar.style.display = 'block';
		this.parentElement.style.marginBottom = '180px';
	}
	
	hide() {
		this.bar.style.display = 'none';
		this.parentElement.style.marginBottom = '50px';		
	}
	
	isShowing() {
		return this.bar.style.display === 'block';
	}
	
}

class Wayoslet extends HTMLElement {
	
	constructor() {
		super();
		
		this.initMessage = "greeting";
		
		let style = document.getElementById('wayos-style');
		
		if (!style) {
			
			let style = document.createElement('style');
			style.id = 'wayos-style';
			style.textContent = 
			`
			.wayos-nav { 
				cursor: pointer; 
				height: 40px; 
				min-width: 60px;
				border-radius: 15px; 
				-moz-border-radius: 15px; 
				-webkit-border-radius: 15px; 
				font-size: large;
				padding: 2px 10px; 
				//margin-bottom: 5px;
				margin-left: 5px;
			}
			.wayos-title-menu { 
				float: left;
			}
			.wayos-rich-menu { 
				//float: right;
				background-color: transparent;
			}
			.wayos-textarea {
				width: 88%;
				border: 1px solid #DDDDDD;
				border-radius: 5px;
				-webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */
				-moz-box-sizing: border-box; /* Firefox, other Gecko */
				box-sizing: border-box;  
				font-size: x-large;
				color: black;
				background-color: darkGray;
				margin-top: 5px;
			}
			.wayos-file-button {
			    width: 8%;
				border: 0;
		   		background: #3498db;
		    	color: white;
		   		line-height: 40px;
		    	margin-bottom: 10px;
		    	margin-right: 10px;
				cursor: pointer;
			}
			.wayos-button {
			    width: 38%;
				border: 1px solid #DDDDDD;
				border-radius: 10px;
		   		background: #3498db;
		    	color: white;
		   		line-height: 40px;
		    	margin-bottom: 10px;
		    	margin-right: 5px;
				cursor: pointer;
			}
			.wayos-loader {
				background-color: rgba(0, 0, 0, 0.3); 
				width: 100%;			
			}
			@keyframes spin {
			    0% { transform: rotate(0deg); }
			    100% { transform: rotate(360deg); }
			}
			.wayos-spinner {
	    		border: 8px solid #f3f3f3; /* Light grey */
			    border-top: 8px solid #555; /* Blue */
	    		border-radius: 50%;
	    		width: 70px;
	    		height: 70px;
			    animation: spin 2s linear infinite;
	    		position: fixed;
			    top: 50%;
	    		left: 50%;
			    margin-top: -35px;
			    margin-left: -35px;
			}`;
			
			document.head.appendChild(style);						
		}
				
	}
	
	connectedCallback() {
		
		if (!this.id) {
			
			this.id = Wayoslet.generateId();
			
		}
		
		Wayoslet.register(this);
		
		//console.log("ID:" + this.id);
		
		let parentElement = this;
				
		this.navBar = new NavBar(parentElement);
		
		this.frameUX = new AnimateFrameUX(parentElement);
		
		this.chatBar = new ChatBar(parentElement);
				
		this.navBar.onTitleButtonClick = function(message) {
			
			window.open(parentElement.wayOS.playURL, '_blank');
			
		}
		
		this.navBar.onRingButtonClick = function() {
						
			//Recreate instance of wayOS and reinitialize ui
			parentElement.ring();
			
		}
		
		this.navBar.onChatButtonClick = function() {
			
			//Toggle chatBar
			if (parentElement.chatBar.isShowing()) {
				parentElement.chatBar.hide();
			} else {
				parentElement.chatBar.show();				
			}
			
		}		
		
		this.navBar.onCreateRichMenus = function(props, richMenus) {
			
			parentElement.navBar.richArea.innerHTML = "";
			
			let richMenu;
			for (let i in richMenus) {
				
				richMenu = richMenus[i];
				
				let button = document.createElement("button");
				button.className = "wayos-nav wayos-rich-menu";
				button.innerHTML = richMenu;
				button.style.color = "WHITE";
				//button.style.backgroundColor = props.borderColor;
				
				button.addEventListener('click', function(event) {
		 			
					parentElement.wayOS.parse(this.innerHTML + "!");
					
			    });
				
				parentElement.navBar.richArea.appendChild(button);
			}
			
		};
		
		this.chatBar.onRingButtonClick = function() {
			
			parentElement.ring();
			
		}
			
		this.chatBar.onSendButtonClick = function(message) {
			
			parentElement.wayOS.parse(message);
			
		}
		
		this.chatBar.onFileDialogSubmit = function(files) {
			
			parentElement.wayOS.dropFile(files);
			
		}
				
		this.style.display = "flex";
		this.style.flexDirection = "column";
				
		if (this.dataset.chat && this.dataset.chat === 'yes') {
			this.chatBar.show();
		} else {
			this.chatBar.hide();
		}
				
		if (this.dataset.message && this.dataset.message.trim()!=='') {
			this.initMessage = this.dataset.message.trim();
		}
		
		if (this.dataset.speak && this.dataset.speak === 'yes') {
			this.speak = true;
			console.log("Enable Speaking");
		}
							
		this.init();
		
	}
	
	init() {
		//Recreate instance of wayOS and reinitialize ui
		this.play('/public/eoss-th/question_003.ogg');
		this.wayOS = this.createWayOS();
		this.wayOS.load(this.initMessage);
	}
	
	ring() {
		this.play('/public/eoss-th/question_003.ogg');
		this.frameUX.reload();//Clear Frame
		this.wayOS.parse(this.initMessage);	
	}
	
	createWayOS() {
		
		let parentElement = this;
		
		let sessionId = parentElement.sessionId();
		
		let wayOS = new WayOS(parentElement.dataset.url, sessionId);
		
		wayOS.onload = function(props) {
						
			parentElement.frameUX.init(props);
			
			parentElement.navBar.init(props);
			
			if (parentElement.dataset.top) {
				parentElement.navBar.show(parentElement.dataset.top.split("|"));
			} 
			
			parentElement.chatBar.init(props);
			
			if (parentElement.dataset.onload) {
				
				window[parentElement.dataset.onload].call(parentElement, props);
				
			}
			
		};
		
		wayOS.onparse = function(message, from) {
			
			//For some browser that not support onload event!!!
			if (!parentElement.frameUX.content)
				parentElement.frameUX.reload();
			
			//Animate Effect for Single Menu
			if (from && 
					from.parentElement && 
					from.parentElement.parentElement && 
					from.parentElement.parentElement.getAttribute("class")==="vertical-center") {
				
				from.style.backgroundColor = "grey";
				
				let children = from.parentElement.children;
				for (let i=0; i<children.length; i++) {
					children[i].onclick = function() {};						
				}
									
				try {
					
					const timing = {
					  		duration: 250,
							iterations: 1,
						};
					
					let fadeOut = [
						{ opacity: "1" },
						{ opacity: "0" },
					];				
					
					let fadeOut2 = [
						{ transform: "translateY(0%)" },
						{ transform: "translateY(150%)" },
					];
					
					let fadeOutAnimation = from.parentElement.parentElement.animate(fadeOut, timing);
					fadeOutAnimation.onfinish = (event) => {
						
						from.parentElement.parentElement.innerHTML="";					
						
					};
					
				} catch (error) {
					alert(error);
				}				
			}
			
			parentElement.addLoader();
			
			//Clear Content
			/*
			if (parentElement.frameUX.content)
				parentElement.frameUX.content.innerHTML = "";
			*/
			
			//Close if no chatbar config
			if (!parentElement.dataset.chat || parentElement.dataset.chat === 'no') {
				parentElement.chatBar.hide();
			}
		};
		
		wayOS.onmessages = function(messages) {
	
			//Clear Content
			//if (parentElement.frameUX.content)
				//parentElement.frameUX.content.innerHTML = "";
			
			parentElement.removeLoader();
						
			parentElement.frameUX.play(messages);
				
		};	
		
		wayOS.onAsyncMessage = function(message) {
			
			//Clear Content
			//if (parentElement.frameUX.content)
				//parentElement.frameUX.content.innerHTML = "";
			
			//parentElement.removeLoader();
						
			parentElement.frameUX.appendText(message);
				
		};	
		
		wayOS.parentElement = parentElement;
		
		return wayOS;
	}
	
	sessionId () {
		
		if (this.dataset.sessionId && this.dataset.sessionId != "") return this.dataset.sessionId;
		
		return undefined;
	}
			
	addLoader () {
		
		this.removeLoader();
				
		let loader = document.createElement("div");
		loader.className = "wayos-loader";
		loader.style = "display: block";
		/*
		loader.innerHTML = 
		`<div style="position: absolute; width: 100%; height: 100%;">
			<div class="wayos-spinner"></div> 
		</div>`;
		*/
		loader.innerHTML = 
		`<div class="wayos-spinner"></div>`;
		
		this.appendChild(loader);
		this.loaderElement = loader;
	}
	
	removeLoader() {
		
		try {
			this.removeChild(this.loaderElement);
		} catch (e) {
		}
		
	}	
	
	showNotification(title, body, url) {
		
		let notification = new Notification(title, {body});
		
		/*
		notification.onclick = (e) => {
			window.location.href = url;
		};
		*/
		setTimeout(() => {
			
		    notification.close()
		    
		}, 4000);
	}
		
	play (src) {
		
		if (!this.audio) {			
			this.audio = new Audio();			
		}
		
		if (!this.audio.paused) {
			this.audio.pause();
		}
	
		this.audio.src = src;
				
		this.audio.play();
				
	}

}

Wayoslet.Id = 0;

Wayoslet.parentElements = [];

Wayoslet.generateId = function () {
	
	return 'wayos-let-' + (++Wayoslet.Id);	
}

Wayoslet.register = function (parentElement) {
		
	Wayoslet.parentElements.push(parentElement);
	
	parentElement.Wayoslet = this;
}

customElements.define('wayos-let', Wayoslet/*, { extends: 'div' }*/);