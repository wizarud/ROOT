<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,x.org.json.JSONObject, com.wayos.*,com.wayos.Application, com.wayos.connector.SessionPool" %>
<%@ page isELIgnored="true" %>
<% 
	String contextRoot = application.getContextPath();
	String accountId = (String) request.getAttribute("accountId");
	String botId = (String) request.getAttribute("botId");	
	
	/* Use sessionId parameter instead
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
	
	String title = properties.optString("title");
	if (title==null) { 
		title = "Over Rider";
	}

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HTML5 Joystick Controller</title>
    <style>
        body {
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            font-family: 'Arial', sans-serif;
            color: white;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .controller-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .controller {
            display: flex;
            align-items: center;
            gap: 60px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .joystick-container {
            position: relative;
            width: 150px;
            height: 150px;
        }

        .joystick-base {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: linear-gradient(145deg, #2c3e50, #34495e);
            box-shadow: inset 0 5px 15px rgba(0, 0, 0, 0.3);
            position: relative;
            border: 3px solid rgba(255, 255, 255, 0.2);
        }

        .joystick-stick {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(145deg, #e74c3c, #c0392b);
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            cursor: grab;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
            border: 2px solid rgba(255, 255, 255, 0.3);
            transition: all 0.1s ease;
            z-index: 10;
        }

        .joystick-stick:active {
            cursor: grabbing;
            transform: translate(-50%, -50%) scale(0.95);
        }

        .buttons-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .button {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: none;
            font-size: 24px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.1s ease;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            position: relative;
            overflow: hidden;
        }

        .button-a {
            background: linear-gradient(145deg, #27ae60, #2ecc71);
            color: white;
        }

        .button-b {
            background: linear-gradient(145deg, #e67e22, #f39c12);
            color: white;
        }

        .button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.4);
        }

        .button:active {
            transform: translateY(0px) scale(0.95);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        }

        .button.pressed {
            transform: scale(0.9);
            box-shadow: inset 0 4px 10px rgba(0, 0, 0, 0.3);
        }

        .status-display {
            margin-top: 40px;
            padding: 20px;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            font-family: 'Courier New', monospace;
            min-width: 300px;
        }

        .status-row {
            display: flex;
            justify-content: space-between;
            margin: 5px 0;
        }

        .api-section {
            margin-top: 30px;
            padding: 20px;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 10px;
        }

        .api-input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: none;
            border-radius: 5px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            font-size: 14px;
        }

        .api-input::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .api-button {
            background: linear-gradient(145deg, #8e44ad, #9b59b6);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
            transition: all 0.2s ease;
        }

        .api-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        }

        .response-area {
            margin-top: 15px;
            padding: 10px;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 5px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            max-height: 150px;
            overflow-y: auto;
        }

        @media (max-width: 768px) {
            .controller {
                flex-direction: column;
                gap: 40px;
            }
            
            .controller-container {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="controller-container">
        <h1 style="text-align: center; margin-bottom: 30px;">HTML5 Joystick Controller</h1>
        
        <div class="controller">
            <div class="joystick-container">
                <div class="joystick-base">
                    <div class="joystick-stick" id="joystick"></div>
                </div>
            </div>
            
            <div class="buttons-container">
                <button class="button button-a" id="buttonA">A</button>
                <button class="button button-b" id="buttonB">B</button>
            </div>
        </div>
    </div>
    
	<script src="../../wayosapp.js"></script>
	<script src="../../widget.js"></script>

    <script>
    
	    const thisWayOS = new WayOS("<%= playURL %>", "<%= sessionId %>");
    	
        class JoystickController {
            constructor() {
                this.joystick = document.getElementById('joystick');
                this.buttonA = document.getElementById('buttonA');
                this.buttonB = document.getElementById('buttonB');
                
                this.state = {
                    x: 0,
                    y: 0,
                    buttonA: false,
                    buttonB: false
                };

                this.isDragging = false;
                this.baseRect = null;
                this.maxDistance = 45; // Maximum distance from center
                this.streaming = false;
                this.streamInterval = null;

                this.initializeJoystick();
                this.initializeButtons();
            }

            initializeJoystick() {
                const base = this.joystick.parentElement;
                
                // Mouse events
                this.joystick.addEventListener('mousedown', this.startDrag.bind(this));
                document.addEventListener('mousemove', this.drag.bind(this));
                document.addEventListener('mouseup', this.endDrag.bind(this));
                
                // Touch events for mobile
                this.joystick.addEventListener('touchstart', this.startDrag.bind(this));
                document.addEventListener('touchmove', this.drag.bind(this));
                document.addEventListener('touchend', this.endDrag.bind(this));
            }

            initializeButtons() {
                this.buttonA.addEventListener('mousedown', () => this.setButtonState('A', true));
                this.buttonA.addEventListener('mouseup', () => this.setButtonState('A', false));
                this.buttonA.addEventListener('mouseleave', () => this.setButtonState('A', false));
                
                this.buttonB.addEventListener('mousedown', () => this.setButtonState('B', true));
                this.buttonB.addEventListener('mouseup', () => this.setButtonState('B', false));
                this.buttonB.addEventListener('mouseleave', () => this.setButtonState('B', false));

                // Touch events for buttons
                this.buttonA.addEventListener('touchstart', (e) => {
                    e.preventDefault();
                    this.setButtonState('A', true);
                });
                this.buttonA.addEventListener('touchend', () => this.setButtonState('A', false));
                
                this.buttonB.addEventListener('touchstart', (e) => {
                    e.preventDefault();
                    this.setButtonState('B', true);
                });
                this.buttonB.addEventListener('touchend', () => this.setButtonState('B', false));
            }

            startDrag(e) {
                e.preventDefault();
                this.isDragging = true;
                this.baseRect = this.joystick.parentElement.getBoundingClientRect();
            }

            drag(e) {
                if (!this.isDragging) return;
                
                e.preventDefault();
                
                let clientX, clientY;
                if (e.type.includes('touch')) {
                    clientX = e.touches[0].clientX;
                    clientY = e.touches[0].clientY;
                } else {
                    clientX = e.clientX;
                    clientY = e.clientY;
                }

                const centerX = this.baseRect.left + this.baseRect.width / 2;
                const centerY = this.baseRect.top + this.baseRect.height / 2;
                
                let deltaX = clientX - centerX;
                let deltaY = clientY - centerY;
                
                const distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
                
                if (distance > this.maxDistance) {
                    const angle = Math.atan2(deltaY, deltaX);
                    deltaX = Math.cos(angle) * this.maxDistance;
                    deltaY = Math.sin(angle) * this.maxDistance;
                }
                
                this.joystick.style.transform = `translate(${-50 + (deltaX / this.maxDistance) * 50}%, ${-50 + (deltaY / this.maxDistance) * 50}%)`;
                
                this.state.x = parseFloat((deltaX / this.maxDistance).toFixed(2));
                this.state.y = parseFloat((deltaY / this.maxDistance).toFixed(2));
                
                this.sendToAPI();
            }

            endDrag() {
                if (!this.isDragging) return;
                
                this.isDragging = false;
                this.joystick.style.transform = 'translate(-50%, -50%)';
                
                this.state.x = 0;
                this.state.y = 0;
                
                this.sendToAPI();
            }

            setButtonState(button, pressed) {
                const buttonElement = button === 'A' ? this.buttonA : this.buttonB;
                const stateKey = button === 'A' ? 'buttonA' : 'buttonB';
                
                this.state[stateKey] = pressed;
                
                if (pressed) {
                    buttonElement.classList.add('pressed');
                } else {
                    buttonElement.classList.remove('pressed');
                }
                
                this.sendToAPI();
            }

            sendToAPI() {
            	
                const data = {
                    timestamp: Date.now(),
                    joystick: {
                        x: this.state.x,
                        y: this.state.y
                    },
                    buttons: {
                        A: this.state.buttonA,
                        B: this.state.buttonB
                    }
                };

                const message = JSON.stringify(data);
                
                //Send Message to wayOS
                thisWayOS.parse('json ' + message);

            }

            logResponse(message) {
                const responseArea = document.getElementById('responseArea');
                const timestamp = new Date().toLocaleTimeString();
                responseArea.innerHTML += `[${timestamp}] ${message}<br>`;
                responseArea.scrollTop = responseArea.scrollHeight;
            }
        }

        // Initialize the controller
                
        const controller = new JoystickController();

        // Keyboard support
        document.addEventListener('keydown', (e) => {
            switch(e.key.toLowerCase()) {
                case 'a':
                case 'z':
                    controller.setButtonState('A', true);
                    break;
                case 's':
                case 'x':
                    controller.setButtonState('B', true);
                    break;
            }
        });

        document.addEventListener('keyup', (e) => {
            switch(e.key.toLowerCase()) {
                case 'a':
                case 'z':
                    controller.setButtonState('A', false);
                    break;
                case 's':
                case 'x':
                    controller.setButtonState('B', false);
                    break;
            }
        });
        
        thisWayOS.onload = function(props) {		
        }

        thisWayOS.onparse = function(message, from) {
        }

        //Callback Event
        thisWayOS.onmessages = function(messages) {
        	
        	console.log(JSON.stringify(messages));
        	
        };
        
    </script>
</body>
</html>