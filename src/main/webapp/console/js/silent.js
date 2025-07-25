function getSilent() {
	
	overlayPopup("loader");
	
	let url = contextRoot + "/console/silent/" + contextName(botId);
	let xhr = new XMLHttpRequest();
	xhr.open("GET", url, true);
	xhr.onload = function() {
		
		if (xhr.status == 200) {
			
			let obj = JSON.parse(xhr.responseText);
			$("#message").val(obj.message);
			$("#interval").val(obj.interval);
			$("#lastExecute").val(obj.lastExecute);
			$("#lastResponseText").val(obj.lastResponseText);
			$("#nextExecute").val(obj.nextExecute);
			
		}
		
		overlayPopup("loader");
	}
	
	xhr.send();	
}

$("#update").click(function () {
	
	/**
	 * Both must have or Both must not have the message and interval!
	 */
	if ($("#message").val() && $("#interval").val()) {

		overlayPopup("loader");
		
		$("#errorMessage").hide();
		
		let url = contextRoot + "/console/silent/" + contextName(botId);
 		let params = "message=" + encodeURIComponent($("#message").val()) + "&interval=" + encodeURIComponent($("#interval").val());
 
 		let xhr = new XMLHttpRequest();
 		xhr.open("POST", url, true);
 		xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

 		xhr.onload = function() {
	
 		    if (xhr.status == 200) {
	
	 			if (xhr.responseText === "success") {
		
	 				location.reload();
	 				
	 			} else {
		
	 				$("#errorMessage").show();
	 				
	 			}
	 			
	 			overlayPopup("loader");
 		    }
 		}
 		
 		xhr.send(params);
 		
	} else {
		
		$("#errorMessage").show();
	}
			
});

$("#delete").click(function () {
	
	overlayPopup("loader");
		
	$("#errorMessage").hide();
		
	let url = contextRoot + "/console/silent/" + contextName(botId);

	let xhr = new XMLHttpRequest();
	xhr.open("POST", url, true);
	xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

	xhr.onload = function() {

	    if (xhr.status == 200) {

			if (xhr.responseText === "success") {
		
				location.reload();
	 				
			} else {
		
				$("#errorMessage").show();
	 				
			}
	 			
			overlayPopup("loader");
	    }
	}
			
	xhr.send();
	
});