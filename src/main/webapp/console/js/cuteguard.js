function generateCuteguardLink(reset) {
	
	let locationId = localStorage.getItem("locationId");
	
	if (reset || !locationId) {
		locationId = prompt("Please enter your location id");
		localStorage.setItem("locationId", locationId);
	}
		
	let playURL = domain + contextRoot + "/x/" + contextName(botId);
	
	let cuteguardURL = domain + "/Cuteguard";
			
	$("#cuteguardLink").val(cuteguardURL + "?playURL=" + playURL + "&sessionId=" + locationId);

}
