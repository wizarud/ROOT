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
        <h1>
        <b>C</b>ommon <b>H</b>yper <b>A</b>ctive <b>I</b>nstruction
        </h1>
        <br>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-12">
							<div class="card">
								<div class="header showcase-btt"
									style="width: 100%; display: inline-block;">
									<div class="col-md-2">
										<input type="file" style="display: none" id="spreadSheetFile" />
				                		<input type="button" class="btn btn-default btn-block" value="<fmt:message key="spreadSheet.open" />" id="openSpreadSheet"/>
				                	</div>
									<div class="col-md-2">
				                		<input type="button" class="btn btn-default btn-block" value="<fmt:message key="spreadSheet.save" />" id="saveSpreadSheet"/>
				                	</div>
									<div class="col-md-2">
				                		<input type="button" class="btn btn-default btn-block" value="<fmt:message key="spreadSheet.export" />" id="exportSpreadSheet"/>
				                	</div>
								</div>
								<div id="spreadsheet" class="content"></div>
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

<script src="js/lib/jexcel.js" type="text/javascript"></script>
<link href="css/jexcel.css" rel="stylesheet" />
 
<script src="js/lib/jsuites.js"></script>
<link href="css/jsuites.css" rel="stylesheet" />

<script src="js/jspreadSheet_plugins.js"></script>

<script>
//Edit uploadFileName & columns to match the drawer Here!

var uploadFileName = "chai.tsv";

var columns = [
    {
        type: 'text',
        title: 'Number',
        width: 50
    },
    {
        type: 'text',
        title: 'Keywords',
        width: 120
    },
    {
        type: 'text',
        wordWrap: true,
        title: 'Answer',
        width: 240,
        editor: textAreaWithUploadImageButtonAttachment
    },
    {
        type: 'dropdown',
        title: 'Question',
        width: 50,
        source:[
            "",
            "yes",
            "no"
          ]
    },
    {
        type: 'text',
        title: 'Next',
        width: 120
    },
    {
        type: 'text',
        wordWrap: true,
        title: 'Expressions',
        width: 120,
        editor: textAreaAttachment
    },
    {
        type: 'hidden',
        title:'W',
        width: 0
    },
    {
        type: 'hidden',
        title: 'X',
        width: 0,
    },
    {
        type: 'hidden',
        title: 'Y',
        width: 0,
    }
];

//---------------------------------------------------------------
</script>
<script>
function updateTable(instance, cell, col, row, val, label, cellName) {

	//Number
	if (col === 0) {
		//Todo: register row number
	}
	
	//Answer or Expressions
	if (col === 2 || col === 5) {

		if (val) {

			cell.innerHTML = cell.innerHTML.replace(/\\n/g, '\n');
			
			if (val.startsWith("https://") || val.startsWith("http://") || val.startsWith("/public/")) {

				const test = val.toLowerCase();

				if (test.endsWith("jpg") || test.endsWith("jpeg") || test.endsWith("png") || test.endsWith("gif")) {

					cell.innerHTML = "<img src=\"" + val + "\" style=\"width:300px;\">";

				}
			}

		}
	}

	// cell.style.overflow = "hidden";
}

$("#saveSpreadSheet").click(function() {

	let content = "";

	//Pack Header
	for (let i in columns) {
		content += columns[i].title + "\t";
	}
	content = content.trim() + "\n";

	//Pack Content
	const data = tsv.getData(false);

	for (let row in data) {

		for (let col in data[row]) {

			if (col == 2 || col == 5 ) {
								
				let x = data[row][col].replace(/\n/g, '\\n');
				content += x + "\t";
				
			} else {
				content += data[row][col] + "\t";
			}

		}
		content = content.trim() + "\n";
	}
	content = content.replace(/&lt;/g, "<");
	content = content.replace(/&gt;/g, ">");
	content = content.trim();

	let file = new File([content], contextName(botId) + "/" + uploadFileName, {
		type: "text/plain",
	});

	console.log("(^o^)ๆ Saving.." + file.name);

	let formData = new FormData();
	formData.append("file[]", file, file.name);

	overlayPopup("loader");

	$.ajax({
		url: contextRoot + "/console/factory",
		type: "POST",
		data: formData,
		enctype: "multipart/form-data",
		processData: false,
		contentType: false
	}).done(function(data) {

		alert(data);

		overlayPopup("loader");

		location.reload();

	}).fail(function(jqXHR, textStatus) {

		alert("File upload failed ..." + textStatus);

		overlayPopup("loader");

		location.reload();

	});
});

</script>
<script src="js/spreadSheet.js"></script>

<script type="text/javascript">
function onBotListLoaded(changed) {
	
	console.log("spreadSheet onBotListLoaded:" + changed);
	
	if (changed) {
		location.reload();
		return;
	}
	tsv = loadSpreadsheet(uploadFileName);
}
</script>

</html>
