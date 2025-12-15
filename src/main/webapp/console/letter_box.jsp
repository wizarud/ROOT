<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="fragment/i18n.jspf"%>
<!doctype html>
<html lang="en">
<head>
<title>WAYOS</title>
<%@ include file="fragment/env-css.jspf"%>
</head>
<body>
	<%@ include file="fragment/env-param.jspf"%>
	<div class="wrapper">
		<%@ include file="fragment/sidebar.jspf"%>
		<div class="main-panel">
			<%@ include file="fragment/navbar.jspf"%>			
			<div class="content">
				<div class="container-fluid">
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="header">
									<label class="title"><fmt:message key="date.start" /> : </label>
									<select id="yearAndMonth" class="form-control">
									</select>
									
								</div>
								<div id="letterbox" class="botlist content table-responsive table-full-width"
									style="width: 100%; display: inline-block; margin-left: 0px;">
								</div>								
							</div>

                        <div class="card col-md-8" style="padding: 10px;">
                        	<div id="service-content" class="content" >
								<div>
									<label><fmt:message key="push.bot.target" /> : </label>
									<label id="target" style="text-transform: none;"></label>
									<br>
									<label><fmt:message key="push.bot.name" /> : </label>
									<label id="botName" style="text-transform: none;"></label>
									<br>
									<label><fmt:message key="push.Keywords" /> : </label>
									<select id="keyword"></select>
								</div>
						        <div id="chat_widget_input_container">
						            <form method="post" id="chat_widget_form">
						            	<input type="file" id="chat_widget_file"><br>
						                <textarea class="form-control" id="chat_widget_input" ondrop="textAreaDropHandler(event);" ondragover="textAreaDragOverHandler(event);"	rows="4" cols="50"></textarea>
						                <br>
						                <div class="col-md-2" style="padding: 0;float: none;">
						                	<input type="button" class="btn btn-default btn-block" value="<fmt:message key="btt.notification" />!" id="reply_button"/>
						                </div>
						            </form>
						        </div>	
					        </div>						
                        </div>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="fragment/overlay-addbot.jspf"%>
	<%@ include file="fragment/overlay-loader.jspf"%>
</body>
<%@ include file="fragment/env-js.jspf"%>
<link href="js/lib/jquery-ui.min.css" rel="stylesheet" />
<style>
.timestamp {
	margin-left: 5px; 
	padding:5px 10px;
	border-radius: 5px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	border: 1px solid #1DC7EA;
}
</style>
<script src="js/lib/jquery-ui.min.js"></script>
<script src="js/push-service.js"></script>
<script type="text/javascript">

/**
 * For Letter Box, Warning if target is empty
 */
$('#reply_button').click(function () {
			
    const message = $("#chat_widget_input").val(); //get the value from the text input
	const keyword = $("#keyword").val();
	const target = $("#target").text();
	
	if (target==='') {
		alert('Please select a letter you want to reply (^o^)ๆ');
		return;
	}
	
	$("#reply_button").attr("disabled", true);
	$("#reply_button").val(sending_text);
	   		
    const data = {message, keyword, target};
    
    //console.log("(^o^)ๆ Boardcast to " + contextName(botId));
    
    $.post(contextRoot + '/console/push/' + contextName(botId), data,
        function (msg) {
    	
    	alert("Reach: " + msg + " targets!");
    	
        	$("#reply_button").attr("disabled", false);
        	$("#reply_button").val(notification_text);
        	$('#chat_widget_input').val("");
        	
        	location.reload();
        	
        }, "text");

});

function loadYearAndMonthMenu(success) {
	
	overlayPopup('loader');
	
	$("#yearAndMonth").empty();
	
    $.get(contextRoot + "/console/vars/" + contextName(botId), function(yearAndMonthArray, status) {
    	
    	overlayPopup('loader');
    	
    	//console.log('Year and Month Array :' + JSON.stringify(yearAndMonthArray));
    	
    	for (let i in yearAndMonthArray) {

    		let yearAndMonthString = yearAndMonthArray[i];
    		$('#yearAndMonth').append($('<option></option>').val(yearAndMonthString).html(yearAndMonthString));
    		
    	}
    	
    	$('#yearAndMonth').on("change", function() {
    		        	
        	let yearAndMonth = $('#yearAndMonth').val();
        	
        	//console.log('Select:' + yearAndMonth);
        	
        	if (success) {
        		success(yearAndMonth);
        	}
    		
    	}).trigger( "change" );
    	    	
    });
	
}

var lastSelectedTab;

function loadReport(yearAndMonth) {
	
	overlayPopup('loader');
	
    $.get(contextRoot + "/console/vars/" + contextName(botId) + "?yearAndMonth=" + yearAndMonth, function(dates, status) {

    	$("#letterbox").empty();
    	
		const tabs = $("<div></div>");
    	
    	var lastClickTR;
    	    	
    	dates.forEach(function(date) {
    		
    		const day = date.split("-")[2];
    		
    		const tab = $("<span>" + day + "</span>");
    		tab.css('display', 'inline-block');
    		tab.css('border', '1px solid black');
    		tab.css('padding', '10px');
    		tab.css('width', '50px');
    		tab.css('border-radius', '5px');
    		tab.css('cursor', 'pointer');
    		tab.css('text-align', 'center');
    		    		
    		tab.click(function() {
    			
    			if (lastSelectedTab) {
	
    				lastSelectedTab.css('background-color', '#f9f9f9');
    				lastSelectedTab.css({"font-weight": "normal", "text-decoration": "none"});
    			}
    			
    			tab.css('background-color', '#FFFFFF');
    			tab.css({"font-weight": "900", "text-decoration": "underline"});
    			
    			lastSelectedTab = tab;    			
				lastSelectedTab.data("date", date);
				
    			overlayPopup('loader');
    			
		    	const letterboxPane = $('<div></div>');
		    		    		
    			overlayPopup('loader');
    		    $.get(contextRoot + "/console/vars/" + contextName(botId) + "?date=" + date, function(unordered_vars, status) {
    		    
    		    	letterboxPane.empty();
    		    	
    		    	const vars = unordered_vars;
    		    	
    		    	console.log(vars);
    		    	
    		    	const table = $("<table style='width: 100%'></table>");
    		    	
    		    	var firstTR;
    		    	let tr, td;
    		    	for (let row in vars) {
    		    		
    		    		tr = $("<tr style='cursor: pointer'></tr>");
    		    		td = $("<td valign='top'>" + Object.keys(vars[row])[0] + "<br>" + "<a href='#chat_widget_input_container'>Reply</a>" + "</td>");
    		    		tr.append(td);
    		    		
		    			const tokens = vars[row][Object.keys(vars[row])[0]].split("|");
		    			let line = '';
		    			let t;
		    			for (let i in tokens) {
		    				if (i<2) continue; //skip channel and sessionId
		    				t = tokens[i].trim();
		    				//t = t.replaceAll(/\[br\]/g,"<br>");
		    				t = t.replaceAll(/\n/g,"<br>");
		    				
		    				if (t.startsWith("https://") || t.startsWith("http://")) {
		    					
		    					let tailchk = t.toLowerCase();
		    					
		    					if (tailchk.endsWith("jpg") || 
		    							tailchk.endsWith("jpeg") ||
		    								tailchk.endsWith("png") ||
		    									tailchk.endsWith("gif")) {
		    						
			    					t = "<img src='" + t + "' style='width: auto; height: 50%; max-height: 512px'></img>";		    						
		    						
		    					} else {
		    						
			    					t = "<a href='" + t + "' target='_blank'>View</a>";
			    					
		    					}
		    				
		    				}
		    				line += t + "\t";
		    			}
		    			
    		    		td = $("<td>[" + tokens[0] + "] - " + tokens[1] + "<br><br>" + line + "<br>&nbsp;</td>");    		    		
    		    		
    		    		tr.append(td);
    		    		
    		    		const thisRow = tr;
    		    		
    		    		tr.hover(function() {
    		    			
    		    			thisRow.css("background-color", "#F5F5F5");
    		    			
    		    		}, function() {
    		    			
    		    			if (thisRow!==lastClickTR)
	    		    			thisRow.css("background-color", "transparent");
    		    			
    		    		});
    		    		
    		    		tr.click(function() {
    		    			
    		    			$("#target").text(tokens[0] + "/" + tokens[1]);
    		    			
    		    			if (lastClickTR) {
    		    				
    		    				lastClickTR.css("background-color", "transparent");
        		    			
    		    			}
    		    			
    		    			thisRow.css("background-color", "#F5F5F5");
    		    			
    		    			lastClickTR = thisRow;
    		    			
    		    		});
    		    		
    		    		if (!firstTR) {
    		    			firstTR = tr;
    		    			firstTR.attr('id', 'lastLetter');     		    			
    		    		}
    		    		
    		    		table.append(tr);
    		    	}
    		    	
    		    	letterboxPane.append(table);
    		    	
        			overlayPopup('loader');
        			
    		    }, "json");
    		        	    
        		$("#logs").empty();
        		$("#logs").append(letterboxPane);
		    	
    			overlayPopup('loader');
    			    			
    		});
    		    		
    		tabs.append(tab);
    		
    	});
    	    	
		$("#letterbox").append(tabs);
		$("#letterbox").append($('<br>'));
		$("#letterbox").append($('<br>'));
		
    	const logs = $('<div id="logs"></div>');
		$("#letterbox").append(logs);
		
    	overlayPopup('loader');
    	
    	console.log(tabs.children().length);
    	
		if (tabs.children().length>0) {
			const firstTab = $(tabs.children().first());
			firstTab.attr('id', 'nowReportTab'); 
			firstTab.trigger("click"); 	
		}
    	
    }, "json");

}

function onBotListLoaded() {
	
	loadYearAndMonthMenu(function(yearAndMonth) {
		
		loadReport(yearAndMonth);
		
	});

	//Push to target sessionId service
	$("#botName").text(decodeURI(botId));
	$("#chat_widget_file").change(function() {
		sendFiles(document.getElementById("chat_widget_file").files);
	});
	$("#chat_widget_button").show();
	loadKeywords();
}
</script>
</html>
