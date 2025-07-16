var attachment = {

	closeEditor: function(cell, save) {
		let value = cell.innerHTML;
		return value;
	},

	openEditor: function(cell) {

		//Lazy Create input
		if (!cell.input) {
			cell.input = document.createElement("input");
			cell.input.type = "file";
			cell.input.style = "display: none";
		}

		$(cell.input).change(function() {
			file = cell.input.files[0];

			formData = new FormData();
			formData.append("content[]", file, file.name);

			$.ajax({
				url: contextRoot + "/console/storage/public/" + accountId + "/" + file.name,
				type: "POST",
				data: formData,
				enctype: "multipart/form-data",
				processData: false,
				contentType: false
			}).done(function(data) {

				cell.innerHTML = domain + contextRoot + "/public/" + accountId + "/" + encodeURI(file.name);

				tsv.closeEditor(cell, true);

			}).fail(function(jqXHR, textStatus) {

				cell.innerHTML = "Upload " + file.name + " " + textStatus;

				tsv.closeEditor(cell, true);
			});

		});

		$(cell.input).trigger("click");

	},

	getValue: function(cell) {
		return cell.innerHTML;
	},

	setValue: function(cell, value) {
		cell.innerHTML = value;
	}
}

function cellUpload(file, input) {

	formData = new FormData();
	formData.append("content[]", file, file.name);

	$.ajax({
		url: contextRoot + "/console/storage/public/" + accountId + "/" + file.name,
		type: "POST",
		data: formData,
		enctype: "multipart/form-data",
		processData: false,
		contentType: false
	}).done(function(data) {

		console.log("(-.-)ๆ Upload finished " + file.name);

		const imageURL = /* domain + contextRoot + */ "/public/" + accountId + "/" + encodeURI(file.name);

		tsv.setValueFromCoords(input.cell.dataset.x, input.cell.dataset.y, imageURL);

	}).fail(function(jqXHR, textStatus) {

		console.log("(T.T)ๆ Upload failure " + file.name);

		const errMsg = "Upload " + file.name + " " + textStatus;

		tsv.setValueFromCoords(input.cell.dataset.x, input.cell.dataset.y, errMsg);

	});
}

var textAttachment = {

	closeEditor : function(cell, save) {
		
		console.log("(-.-)ๆ Close Editor:" + cell.innerHTML);
	
		//Check is image
		if (cell.children[0] && cell.children[0].src) {
			
			let value = cell.children[0].src;			
			cell.innerHTML = value;
			
			return value;
		}
		
		//Check has input text or not
		if (cell.children[0] && cell.children[0].children[0]) {
			
			let value = cell.children[0].children[0].value;//input text
			cell.innerHTML = value;
			
			return value;
		}
		
		//Waiting for input status
		//console.log("(-.-)ๆ:" + cell.innerHTML);
		
		return cell.innerHTML;
	},

	openEditor : function(cell) {

		text = document.createElement("input");
		text.type = "text";
		text.size = 20;
		text.style = "border: 0";

		if (cell.children[0]) {
			if (cell.children[0].src) {//Image
				text.value = cell.children[0].src;
			} else {
				
				//Error Happen! (Reopen?)
				console.log("(T.T)ๆ Unknown error at cell:" + cell.innerHTML);
				
			}
		} else {
			text.value = cell.innerHTML;//Plain Text			
		}

		button = document.createElement("input");
		button.type = "button";
		button.value = " ... ";

		input = document.createElement("input");
		input.type = "file";
		input.style = "display: none";
		input.cell = cell;

		span = document.createElement("span");			
		span.appendChild(text);
		span.appendChild(button);
		span.appendChild(input);

		cell.innerHTML = "";
		cell.appendChild(span);
		
		$(text).keypress(function(event) {

			let keycode = (event.keyCode ? event.keyCode : event.which);
			
			if (keycode == 13) {

				tsv.closeEditor(cell, true);
			}

		});			

		$(span).blur(function() {

			tsv.closeEditor(cell, true);

		});

		$(input).change(function() {

			let file = input.files[0];
			
			text.value = "(^o^)ๆ Uploading " + file.name + "...";
			
			tsv.closeEditor(cell, true);
			
			cellUpload(file, input);

		});

		$(button).click(function() {

			$(input).trigger("click");

		});

		text.focus();
	},

	getValue : function(cell) {

		return cell.innerHTML;
	},

	setValue : function(cell, value) {

		cell.innerHTML = value;
	}
}

var textAreaAttachment = {

	closeEditor: function(cell, save) {

		console.log("(-.-)ๆ Close Editor:" + cell.innerHTML);
		
		//Check has textarea or not
		if (cell.children[0] && cell.children[0].children[0]) {

			let value = cell.children[0].children[0].value;//input text
			cell.innerHTML = value;
			//cell.innerHTML = value.replace(/\n/g, '\\n');

			return value;
		}
		
		return cell.innerHTML;
	},

	openEditor: function(cell) {

		textarea = document.createElement("textarea");
		
		textarea.style.width = '100%';
		textarea.style.height = '100%';
		textarea.style.boxSizing = 'border-box';
		textarea.style.resize = 'none'; // prevent resize if needed
		textarea.style.whiteSpace = 'pre-wrap'; // ensure newline rendering
		textarea.style.overflow = 'hidden'; // optional

		textarea.value = cell.innerHTML;//Plain Text			

		span = document.createElement("span");
		span.appendChild(textarea);

		cell.innerHTML = "";
		cell.appendChild(span);

		$(span).blur(function() {

			tsv.closeEditor(cell, true);

		});

		textarea.focus();
	},

	getValue: function(cell) {

		return cell.innerHTML;
	},

	setValue: function(cell, value) {

		cell.innerHTML = value;
	}
}

var textAreaWithUploadImageButtonAttachment = {

	closeEditor: function(cell, save) {

		console.log("(-.-)ๆ Close Editor:" + cell.innerHTML);

		//Check is image
		if (cell.children[0] && cell.children[0].src) {

			let value = cell.children[0].src;
			cell.innerHTML = value;

			return value;
		}

		//Check has textarea or not
		if (cell.children[0] && cell.children[0].children[0]) {

			let value = cell.children[0].children[0].value;//input text
			cell.innerHTML = value;
			//cell.innerHTML = value.replace(/\n/g, '\\n');

			return value;
		}

		//Waiting for input status
		//console.log("(-.-)ๆ:" + cell.innerHTML);

		return cell.innerHTML;
	},

	openEditor: function(cell) {

		textarea = document.createElement("textarea");
		textarea.style.width = '100%';
		textarea.style.height = '100%';
		textarea.style.boxSizing = 'border-box';
		textarea.style.resize = 'none'; // prevent resize if needed
		textarea.style.whiteSpace = 'pre-wrap'; // ensure newline rendering
		textarea.style.overflow = 'hidden'; // optional

		if (cell.children[0]) {
			if (cell.children[0].src) {//Image
				textarea.value = cell.children[0].src;
			} else {

				//Error Happen! (Reopen?)
				console.log("(T.T)ๆ Unknown error at cell:" + cell.innerHTML);

			}
		} else {
			textarea.value = cell.innerHTML;//Plain Text			
		}

		button = document.createElement("input");
		button.type = "button";
		button.value = " ... ";

		input = document.createElement("input");
		input.type = "file";
		input.style = "display: none";
		input.cell = cell;

		span = document.createElement("span");
		span.appendChild(textarea);
		span.appendChild(button);
		span.appendChild(input);

		cell.innerHTML = "";
		cell.appendChild(span);

		$(textarea).keypress(function(event) {

			let keycode = (event.keyCode ? event.keyCode : event.which);

			if (keycode == 13) {

				//tsv.closeEditor(cell, true);
			}

		});

		$(span).blur(function() {

			tsv.closeEditor(cell, true);

		});

		$(input).change(function() {

			let file = input.files[0];

			textarea.value = "(^o^)ๆ Uploading " + file.name + "...";

			tsv.closeEditor(cell, true);

			cellUpload(file, input);

		});

		$(button).click(function() {

			$(input).trigger("click");

		});

		textarea.focus();
	},

	getValue: function(cell) {

		return cell.innerHTML;
	},

	setValue: function(cell, value) {

		cell.innerHTML = value;
	}
}