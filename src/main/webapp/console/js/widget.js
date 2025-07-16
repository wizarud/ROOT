function generateWidgetTag() {
	
	let includeScript = '<script src="' + domain + contextRoot + '/wayosapp.js"></script>';
	
	let playURL = domain + contextRoot + "/x/" + contextName(botId);
	
	let style = ' style="height: 500px; display: flex; flex-direction: column; margin-bottom: 50px;"';
	
	let htmlComponents = includeScript + '\n<wayos-let data-url="' + playURL + '" data-top="title|ring" data-chat="no"' + style + '></wayos-let>';
	
	$("#widgetTag").val(htmlComponents);

}
