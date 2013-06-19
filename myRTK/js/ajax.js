function decode(decStr) {
	var decStr;
	var decodedStr = decodeURIComponent(decStr.replace(/\+/g, " "));
	return decodedStr;
}

//XMLHttpRequest Functions

function downloadUrl(url, callback) {
	var request = window.ActiveXObject ?
	new ActiveXObject('Microsoft.XMLHTTP') :
	new XMLHttpRequest;
	request.onreadystatechange = function() {
		if (request.readyState == 4) {
			request.onreadystatechange = doNothing;
			//callback(request.responseText, request.status);
			callback(request, request.status);

		}
	};
	request.open('GET', url, true);
	request.send(null);
}

function parseXml(str) {
	if (window.ActiveXObject) {
		var doc = new ActiveXObject('Microsoft.XMLDOM');
		doc.loadXML(str);
		return doc;
	} else if (window.DOMParser) {
		return (new DOMParser).parseFromString(str, 'text/xml');
	}
}

function doNothing() {alert("does nothing!");}

function fillDiv(idt,id) {
	// Set up our request
	var retrURL = "xmlreport.jsp?IDT="+idt+"&ID="+id;
	var chartSize = "250x150";
	// Make our request
	$("#report").load(retrURL, function() {
		colorDataTable();
		createGraph(chartSize);
		//buildGraph();
		if(idt == "TRI") {
			var chemimgs = document.getElementById("chems").getElementsByTagName("img");
			var c;
			//alert(chemimgs);
			for(i=0;i<chemimgs.length;i++) {
				//alert("HI");
					//chemimgs[i].style.visibility = "visible";
					//chemimgs[i].width > 1 && 
				//else if (chemimgs[i].getAttribute("class") == "bar") {
					//chemimgs[i].style.visibility = "hidden";
				//} 
			}
		}
	});
}

function chemPop(chemid) {
	// Set up our request
	var retrURL = "chems.jsp?ID="+chemid;
	// Make our request
	$("#report").load(retrURL, function() {

	});
}