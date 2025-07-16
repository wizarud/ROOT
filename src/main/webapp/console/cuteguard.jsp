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
											<h3>Cuteguard</h3>
											<div class="form-group">
												<label> Cute Face Robot with AI Sensor </label> 
												<input type="text" id="cuteguardLink" readonly="readonly" class="form-control apiPath">
											</div>
											<span class="col-md-2" style="display: inline-block;float: right;padding: 0;z-index: 10;">
							                	<input type="button" onclick="generateCuteguardLink(true)" class="btn btn-default btn-block" value="New Location" id="newlocation"/>
							                	<input type="button" onclick="launchCuteguard()" class="btn btn-default btn-block" value="[^_^]" id="launch"/>
							            	</span>	
										</div>
										<div class="col-md-12">
											<h4>What is location id?</h4>
											<p>
												<ul>
													<li>Location id is an unique name suchas <i>organization-name-location-number<i> </li>
													<li>Example: yiem.cc-001</li>
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
<script src="js/cuteguard.js"></script>
<script type="text/javascript">

function launchCuteguard() {
	
	let cuteguardURL = document.getElementById("cuteguardLink").value;
	
	window.open(cuteguardURL, "_blank");	
}

function onBotListLoaded() {
	
	generateCuteguardLink();
}
</script>

</html>
