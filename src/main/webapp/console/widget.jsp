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
								<div class="content">
									<div class="row">
										<div class="col-md-12">
											<h3>Widget</h3>
											<div class="form-group">
												<label> HTML Component </label> 
												<input type="text" id="widgetTag" readonly="readonly" class="form-control apiPath">
											</div>
											<span class="col-md-2" style="display: inline-block;float: right;padding: 0;z-index: 10;">
							                	<input type="button" onclick="copyToclipBoard('widgetTag')" class="btn btn-default btn-block" value="<fmt:message key="btt.copy" />" id="copy"/>
							            	</span>	
										</div>
										<div class="col-md-12">
											<h4>Optional Data Attributes</h4>
											<p>
												<ul>
													<li>data-message - You can initialize with other message rather than greeting</li>
													<li>data-top - You can specify title or ring or include together</li>
													<li>data-chat - If 'yes' User can use the chatbox below</li>
													<li>data-speak - If 'yes' Chatbot can use the text2speech service from web browser</li>
													<li>data-onload - You can define the callback function that will activate on load</li>
													<li>data-sessionId - You can override with your own sessionId</li>
												</ul>									
											</p>
											
										</div>
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
<script src="js/widget.js"></script>
<script type="text/javascript">

function onBotListLoaded() {
	
	generateWidgetTag();
}
</script>

</html>
