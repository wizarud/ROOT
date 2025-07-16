var wayOS;

if (window.frameElement && window.frameElement.dataset.parentElementId) {
	
	wayOS = parent.document.getElementById(window.frameElement.dataset.parentElementId).wayOS;
	
	console.log("This widget is using API from " + wayOS.webhookURL);
	
	wayOS.onparse = function(message) {
		//No need to show loading animation
	};	
	
	
} else {
	
	console.log("For Mockup testing as standalone widget.");
	
	wayOS = new WayOS();
	
	wayOS.parse = function(message) {	
		//Just pass through (echo)
		wayOS.onmessages([{text: message}]);
	}
	
}
