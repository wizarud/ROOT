<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title></title>
<meta name="description" content="">
<meta name="viewport" content="width=device-width">

<link rel="stylesheet" href="diagram_assets/css/bootstrap.min.css">
<link rel="stylesheet" href="diagram_assets/css/bootstrap-select.css">
<link rel="stylesheet" href="diagram_assets/css/main.css">
<link rel="stylesheet" href="diagram_assets/css/application.css">
<link rel="stylesheet" href="diagram_assets/css/jquery.layout.css" />
<link rel="stylesheet" href="diagram_assets/css/jquery.handsontable.full.css" />

<style>
.overlayBot {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
	z-index: 10000;
}

.debug-toast {
    position: fixed;
    background-color: #333;
    color: #fff;
    padding: 10px 20px;
    border-radius: 5px;
    z-index: 9999;
    opacity: 0;
    transition: opacity 0.5s ease;
    transform: translate(-50%, -50%); /* Center anchor */
}

.debug-toast.show {
    opacity: 1;
}

</style>

<SCRIPT src="./diagram_assets/draw2d/lib/shifty.js"></SCRIPT>
<SCRIPT src="./diagram_assets/draw2d/lib/raphael.js"></SCRIPT>
<SCRIPT src="./diagram_assets/draw2d/lib/jquery-1.12.0.min.js"></SCRIPT>
<SCRIPT src="./diagram_assets/draw2d/lib/jquery.autoresize.js"></SCRIPT>
<SCRIPT src="./diagram_assets/draw2d/lib/jquery-touch_punch.js"></SCRIPT>
<SCRIPT src="./diagram_assets/draw2d/lib/jquery.contextmenu.js"></SCRIPT>
<SCRIPT src="./diagram_assets/draw2d/lib/rgbcolor.js"></SCRIPT>
<SCRIPT src="./diagram_assets/draw2d/lib/canvg.js"></SCRIPT>
<SCRIPT src="./diagram_assets/draw2d/lib/Class.js"></SCRIPT>
<SCRIPT src="./diagram_assets/draw2d/lib/json2.js"></SCRIPT>
<SCRIPT src="./diagram_assets/draw2d/lib/pathfinding-browser.min.js"></SCRIPT>

<SCRIPT src="./diagram_assets/draw2d/src/draw2d.js"></SCRIPT>

<SCRIPT src="./diagram_assets/lib/jquery.browser.js"></SCRIPT>
<SCRIPT src="./diagram_assets/lib/jquery-ui-1.8.23.custom.min.js"></SCRIPT>
<SCRIPT src="./diagram_assets/lib/jquery.layout.js"></SCRIPT>

<script src="diagram_assets/lib/modernizr-2.6.2-respond-1.1.0.min.js"></script>
<script src="diagram_assets/lib/bootstrap.min.js"></script>
<script src="diagram_assets/lib/bootstrap-select.js"></script>
<script src="diagram_assets/lib/plugins.js"></script>
<script src="diagram_assets/lib/main.js"></script>
<script src="diagram_assets/lib/hogan.min.js"></script>
<script src="diagram_assets/lib/regex-colorizer.js"></script>
<script src="diagram_assets/lib/jquery-caretposition.js"></script>
<script src="diagram_assets/lib/jquery.pulse.js"></script>

<SCRIPT src="diagram_assets/lib/jquery.handsontable.full.js"></SCRIPT>

<SCRIPT src="./diagram_assets/src/Application.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/Toolbar.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/View.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/PropertyPane.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/backend/ContextBackend.js"></SCRIPT>

<SCRIPT src="./diagram_assets/src/propertypane/PropertyPaneEntity.js"></SCRIPT>

<SCRIPT	src="./diagram_assets/src/dialog/TemplateParameterEditorDialog.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/dialog/EntityParameterEditorDialog.js"></SCRIPT>

<SCRIPT src="./diagram_assets/src/shape/EntityShape.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/QuestionEntityShape.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/PropertiesEntityShape.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/EventShape.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/StartEntityShape.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/EndEntityShape.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/SilentEntityShape.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/HooksLabel.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/ResponseLabel.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/LabelEditor.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/LabelInplaceEditor.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/HoverConnection.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/OutputPort.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/shape/QuestionDecorator.js"></SCRIPT>

<SCRIPT src="./diagram_assets/src/command/CommandSetJSON.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandChangeLanguage.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandConnect.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandDelete.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandDropClone.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandDropQuestion.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandAddResponse.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandUpdateResponse.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandUpdateHooks.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandUpdateWeights.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandMarkAsQuestion.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandMarkAsForward.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/command/CommandSetSelectedResponse.js"></SCRIPT>

<SCRIPT src="./diagram_assets/src/policy/CopyInterceptorPolicy.js"></SCRIPT>
<SCRIPT src="./diagram_assets/src/policy/KeyboardPolicy.js"></SCRIPT>

<script src="./js/util.js" type="text/javascript"></script>

</head>
<body id="container">

<%@ include file="fragment/env-param.jspf"%>

	<div id="loader" class="overlayBot" style="display: none;">
		<div style="width: 100%; height: 100%; z-index: 200">
			<div class="loader"></div>
		</div>
	</div>

	<div id="content">
		<div id="editor" class="well">
			<div id="palette" class="">
				<div id="entityLabel" 
					data-shape="limz_EntityShape"
					class="palette_node_element draw2d_droppable"
					title="drag&amp;drop the Entity into the canvas..">Entity</div>
				<div id="questEntityLabel" 
					data-shape="limz_QuestionEntityShape"
					class="palette_node_element draw2d_droppable"
					style="background-color: #D0021B"
					title="drag&amp;drop the Question into the canvas..">Quest</div>
			</div>
			<div id="view">
				<div id="canvas"
					ondrop="dropHandler(event);"
					ondragover="dragOverHandler(event);"					
					style="width: 18000px; height: 18000px; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></div>
				<div id="property"></div>
			</div>
		</div>
	</div>
	<div id="toolbar"></div>

	<div id="myModal" style="z-index: 2000" class="modal hide fade"
		tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
		aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"
				aria-hidden="true">×</button>
			<h3 id="myModalLabel">Modal header</h3>
		</div>
		<div class="modal-body"></div>
		<div class="modal-footer"></div>
	</div>
	
	<script src="../wayosapp.js"></script>

	<script type="text/javascript">
	
        var app = null;
        
		$(document).ready(function() {
			draw2d.Configuration.factory.createOutputPort = function(relatedFigure) {
		        return new limz_OutputPort();
   			};
		    app  = new limz_Application();		    
		});
		
		window.onbeforeunload = function(e) {
	    	if (app!==null && app.view.getCommandStack().canUndo()) {
				e.preventDefault();
				return "Are you sure you want to discard the changes you made?";
    		}
    	};
    	
    	function dropHandler(ev) {
    		
			  ev.stopPropagation();
    		  ev.preventDefault();
    		      		  
    		  if (!ev.dataTransfer) return;
    		  
    		  //Adjust Drop position relate to canvas
    		  const canvas = document.getElementById('canvas');
    		  var rect = canvas.getBoundingClientRect();
    		  
    		  var x = ev.clientX - rect.left + canvas.scrollLeft;
    		  var y = ev.clientY - rect.top + canvas.scrollTop;    		  
    		  
    		  const url = ev.dataTransfer.getData('URL');
    		  
    		  if ( url.length > 0 ) {
    			  
    			  figure = new limz_EntityShape(); 
		    	  figure.setHooks('');
		    	  figure.addResponse(url, false);    			    	    		  		    		      		    		  
    			  
    			  app.executeCommand(new draw2d.command.CommandAdd(app.view, figure, x, y));
    			  
    			  return;
    		  }
    		      		  
    		  var files = [];

    		  if (ev.dataTransfer.items) {
    		    // Use DataTransferItemList interface to access the file(s)
    		    for (var i = 0; i < ev.dataTransfer.items.length; i++) {
    		      // If dropped items aren't files, reject them
    		      if (ev.dataTransfer.items[i].kind === 'file') {
    		    	  
    		        files.push(ev.dataTransfer.items[i].getAsFile());
    		        
    		      } else {
    		    	  
    		    	  ev.dataTransfer.items[i].getAsString(function (s) {
    		    		  console.log("(-.-)ๆ " + ev.dataTransfer.items[i].type + ":" +s);
    		    	  });    		    	  
    		      }
    		    }
    		  } else {
    		    // Use DataTransfer interface to access the file(s)
    		    for (var i = 0; i < ev.dataTransfer.files.length; i++) {
    		    	
    		        files.push(ev.dataTransfer.files[i]);

    		    }
    		  }
    		      		      		  
    		  var file;
    		  var figure;
    		      		      		  
    		  var formData;
    		  
    		  for (var i in files) {
    			  
    			  file = files[i];
    			  
    			  figure = new limz_EntityShape();
    			  figure.setHooks('(^o^)ๆ Uploading..' + file.name);
    			  
    			  app.executeCommand(new draw2d.command.CommandAdd(app.view, figure, x, y));
    			  y += 70;
    			      			  
    			  upload(figure, file);
    			  
    		  }
 
    	}
    	
    	function upload(figure, file) {
    		
	          formData = new FormData();
			  formData.append('content[]', file, file.name);
	          
	          $.ajax({
	          	url: contextRoot + "/console/storage/public/" + accountId + "/" + file.name,
	              type: "POST",
	              data: formData,
	              enctype: 'multipart/form-data',
	              processData: false,
	              contentType: false
	            }).done(function(data) {
	            	
	            	//const path = domain + contextRoot + '/public/' + accountId + '/' + encodeURI(file.name);
	            	const path = '/public/' + accountId + '/' + encodeURI(file.name); //Use Relative Path Instead
	            	
		    		figure.setHooks('');
		    		figure.addResponse(path, false);    		    			    	    		  		    		      		    		  
	            	
	            }).fail(function(jqXHR, textStatus) {
	            	
	            	const msg = "Upload " + file.name + " " + textStatus;
	            	alert(msg);    	            	
		    		figure.setHooks(msg);
	            });   
    		
    	}
    	
    	function dragOverHandler(ev) {
    		  // Prevent default behavior (Prevent file from being opened)
			  ev.stopPropagation();
    		  ev.preventDefault();    		  
    	}
    	
    	function debugToast(message, color, x, y, duration = 3000) {
    		
    	    // Create toast element
    	    const toast = document.createElement('div');
    	    toast.className = 'debug-toast';
    	    toast.innerText = message;

    	    // Position the toast
    	    toast.style.left = x + 'px';
    	    toast.style.top = y + 'px';
    	    toast.style.backgroundColor = color;

    	    // Add to body
    	    document.body.appendChild(toast);

    	    // Trigger show animation
    	    setTimeout(() => toast.classList.add('show'), 10);

    	    // Remove after duration
    	    setTimeout(() => {
    	    	
    	      toast.classList.remove('show');
    	      setTimeout(() => toast.remove(), 500); // Wait for fade out
    	      
    	    }, duration);
    	    
    	}
    	
    	function getHexColorFromSessionId(sessionId) {
    		  // Hash the string to a number
    		  let hash = 0;
    		  for (let i = 0; i < sessionId.length; i++) {
    		    hash = sessionId.charCodeAt(i) + ((hash << 5) - hash);
    		  }

    		  // Generate RGB components from hash
    		  const r = (hash >> 16) & 0xff;
    		  const g = (hash >> 8) & 0xff;
    		  const b = hash & 0xff;

    		  // Convert to hex and pad with zeroes if needed
    		  const toHex = (n) => n.toString(16).padStart(2, '0');

    		  return `#${toHex(r)}${toHex(g)}${toHex(b)}`;
    	}
    	
		const centerX = window.innerWidth / 2;
		const centerY = window.innerHeight / 2;    		
		
    	wayOS = new WayOS(domain + contextRoot + "/x/" + accountId + "/" + botId, 'logic-designer');
    	
    	wayOS.load("greeting");
    	
    	wayOS.onload = function(props) {

    		console.log("Logic Designer wayOS.onload>>" + JSON.stringify(props));
    		
			// Show toast in the center of the screen
    		debugToast("Ready for Realtime Debugging.. ", getHexColorFromSessionId(props.sessionId), centerX, centerY, 3000);
    				
    	}

    	wayOS.onmessages = function(messages) {
    		
    		console.log("wayOS.onmessages>>" + JSON.stringify(messages));
    		
    		if (messages.length===1) {
    			
				console.log(JSON.stringify(messages[0]));
				
				if (messages[0].type === 'update') {
					
	    	    	//Try Reload
					if (app.contextId) {
						
						app.load(app.contextId);
						
					}
					
	    	    	return;
				}
								
				let figure = app.getView().getFigure(messages[0].type);
				
				if (figure!=null) {
					
					console.log("FIGURECOLOR: " + JSON.stringify(figure.hooksLabel.attr('bgColor')));
					
					const hooksColor = figure.hooksLabel.attr('bgColor');
					
					figure.hooksLabel.attr({ bgColor: getHexColorFromSessionId(messages[0].sessionId) });
					
					//app.getView().scrollTo(figure.getX(), figure.getY());
					
					//figure.setGlow(true);
					
	    	    	setTimeout(function() {
	    	    		
						//figure.setGlow(false);
						
						figure.hooksLabel.attr({ bgColor: hooksColor });
						
	    	    	}, 500);
	    	    	
	    	    	/*
	    	    	debugToast(messages[0].sessionId + "\n" + messages[0].text, 
	    	    			getHexColorFromSessionId(messages[0].sessionId), 
	    	    			app.getView().getAbsoluteX() + figure.getX() - app.getView().getScrollLeft(), 
	    	    			app.getView().getAbsoluteY() + figure.getY() - app.getView().getScrollTop(), 3000);		    	    	
	    	    	*/
    	    		
				} else {
					
					//Skip From greeting
    	    		//debugToast(JSON.stringify(messages) + " not found", "black", centerX, centerY, 3000);
    	    		
				}
				
    									
    		}
    			  	
    		    		
    	};	    	
    	
    	function showToast(text, x, y) {
    		
    	}
    	
	</script>
	
</body>
</html>