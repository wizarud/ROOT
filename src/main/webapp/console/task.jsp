<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="fragment/i18n.jspf"%>
<!doctype html>
<html lang="en">
<head>
<title>WAYOS</title>
<%@ include file="fragment/env-css.jspf" %>	
</head>
<body>
<%@ include file="fragment/env-param.jspf" %>		
<div class="wrapper">
 	<%@ include file="fragment/sidebar.jspf" %>
    <div class="main-panel">
		<%@ include file="fragment/navbar.jspf" %>
        <div class="content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-8">
                        <div class="card generateMinHeight">
							<div id="service-content" class="content">
								<div id="Test-Connection-content">
									<span class="form-group">
										<p id="errorMessage" style="color: red; display: none"><fmt:message key="chatbox.err" /></p>
										<label>To Session Id : </label>
										<span class="col-md-8" style="display: inline-block;float: none;">
											<input id="sessionId" type="text" class="form-control" value="<fmt:message key="chatbox.loading" />">
										</span><br>
										<label>Message : </label>
										<span class="col-md-8" style="display: inline-block;float: none;">
											<input id="message" type="text" class="form-control" value="<fmt:message key="chatbox.loading" />">
										</span><br>
										<label>Time [Hours Interval|HH:mm|Cron Expression] : </label>
										<span class="col-md-8" style="display: inline-block;float: none;">
											<input id="interval" type="text" class="form-control" value="<fmt:message key="chatbox.loading" />">
										</span><br>
										<label>Last Execute : </label>
										<span class="col-md-8" style="display: inline-block;float: none;">
											<input id="lastExecute" type="text" class="form-control" value="<fmt:message key="chatbox.loading" />" disabled>
										</span><br>
										<label>Last ResponseText : </label>
										<span class="col-md-8" style="display: inline-block;float: none;">
											<textarea id="lastResponseText" class="form-control" disabled><fmt:message key="chatbox.loading" /></textarea>
										</span><br>										
										<label>Next Execute : </label>
										<span class="col-md-8" style="display: inline-block;float: none;">
											<input id="nextExecute" type="text" class="form-control" value="<fmt:message key="chatbox.loading" />" disabled>
										</span>
										<br><br>
										<span style="display: inline-block; padding: 0;">
						                	<input type="button" class="btn btn-default" value="<fmt:message key="btt.update" />" id="update"/>
						                	<input type="button" class="btn btn-default" value="<fmt:message key="btt.delete" />" id="delete"/>
						                </span>
									</span>	
								</div>

							</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>
<%@ include file="fragment/overlay-addbot.jspf" %>
<%@ include file="fragment/overlay-loader.jspf"%>
</body>
<%@ include file="fragment/env-js.jspf" %>
<script src='js/lib/spectrum.js'></script>
<link rel='stylesheet' href='css/spectrum.css' />
<script src="js/task.js"></script> 
<script type="text/javascript">
function onBotListLoaded() {
	getTask();
}
</script>
</html>
