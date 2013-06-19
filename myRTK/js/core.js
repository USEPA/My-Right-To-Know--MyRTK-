var uaString = navigator.appVersion;

function showorhide() {
	document.getElementById("showhide").style.height = document.height;
       if (document.getElementById("showhide").style.display=="inline") {
            document.getElementById("showhide").style.display = "none";
       } else {
            document.getElementById("showhide").style.display = "inline";
       }
}

function activatePlaceholders() {
	var inputs = document.getElementsByTagName("input");
	var labels = document.getElementsByTagName("label");
	for (var j=0;j<labels.length;j++) {
		labels[j].style.display = "none";
		for (var i=0;i<inputs.length;i++) {
			if (inputs[i].getAttribute("type") == "text") {
				if (inputs[i].getAttribute("value") && inputs[i].getAttribute("value").length > 0) {
					inputs[i].value = inputs[i].getAttribute("value");
					inputs[i].style.color = "#888";
					inputs[i].onfocus = function() {
						if (this.value == this.getAttribute("value")) {
							this.value = "";
							this.style.color = "#000";
						}
						return false;
					}
					inputs[i].onblur = function() {
						if (this.value.length < 1) {
							this.value = this.getAttribute("value");
							this.style.color = "#888";
						}
					}
				}
			}
		}
	}
}

function return_referrer () {
	var myurl = document.referrer + "#top";
	window.location = myurl;
}

/*
	Developed by Robert Nyman, http://www.robertnyman.com
	Code/licensing: http://code.google.com/p/getelementsbyclassname/
*/	
var getElementsByClassName = function (className, tag, elm){
	if (document.getElementsByClassName) {
		getElementsByClassName = function (className, tag, elm) {
			elm = elm || document;
			var elements = elm.getElementsByClassName(className),
				nodeName = (tag)? new RegExp("\\b" + tag + "\\b", "i") : null,
				returnElements = [],
				current;
			for(var i=0, il=elements.length; i<il; i+=1){
				current = elements[i];
				if(!nodeName || nodeName.test(current.nodeName)) {
					returnElements.push(current);
				}
			}
			return returnElements;
		};
	}
	else if (document.evaluate) {
		getElementsByClassName = function (className, tag, elm) {
			tag = tag || "*";
			elm = elm || document;
			var classes = className.split(" "),
				classesToCheck = "",
				xhtmlNamespace = "http://www.w3.org/1999/xhtml",
				namespaceResolver = (document.documentElement.namespaceURI === xhtmlNamespace)? xhtmlNamespace : null,
				returnElements = [],
				elements,
				node;
			for(var j=0, jl=classes.length; j<jl; j+=1){
				classesToCheck += "[contains(concat(' ', @class, ' '), ' " + classes[j] + " ')]";
			}
			try	{
				elements = document.evaluate(".//" + tag + classesToCheck, elm, namespaceResolver, 0, null);
			}
			catch (e) {
				elements = document.evaluate(".//" + tag + classesToCheck, elm, null, 0, null);
			}
			while ((node = elements.iterateNext())) {
				returnElements.push(node);
			}
			return returnElements;
		};
	}
	else {
		getElementsByClassName = function (className, tag, elm) {
			tag = tag || "*";
			elm = elm || document;
			var classes = className.split(" "),
				classesToCheck = [],
				elements = (tag === "*" && elm.all)? elm.all : elm.getElementsByTagName(tag),
				current,
				returnElements = [],
				match;
			for(var k=0, kl=classes.length; k<kl; k+=1){
				classesToCheck.push(new RegExp("(^|\\s)" + classes[k] + "(\\s|$)"));
			}
			for(var l=0, ll=elements.length; l<ll; l+=1){
				current = elements[l];
				match = false;
				for(var m=0, ml=classesToCheck.length; m<ml; m+=1){
					match = classesToCheck[m].test(current.className);
					if (!match) {
						break;
					}
				}
				if (match) {
					returnElements.push(current);
				}
			}
			return returnElements;
		};
	}
	return getElementsByClassName(className, tag, elm);
};

//if (navigator.platform == "Win32" && navigator.appName == "Microsoft Internet Explorer" && window.attachEvent) {
//	document.writeln('<style type="text/css">img { visibility:hidden; }  #trimap img { visibility: visible;}</style>');
//	window.attachEvent("onload", fnLoadPngs);
//}

function fnLoadPngs() {
	var rslt = navigator.appVersion.match(/MSIE (\d+\.\d+)/, '');
	var itsAllGood = (rslt != null && Number(rslt[1]) >= 5.5);

	for (var i = document.images.length - 1, img = null; (img = document.images[i]); i--) {
		if (itsAllGood && img.src.match(/\.png$/i) != null) {
			var src = img.src;
			var span = document.createElement("SPAN");
			span.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + src + "', sizing='scale')"
			span.style.width = img.width + "px";
			span.style.height = img.height + "px";
			span.style.display = "inline-block";
			img.replaceNode(span);
		}
		img.style.visibility = "visible";
	}
}



function doExpand() {
	var hideIt = document.getElementsByTagName("tr");
	for(var i=0; i<hideIt.length;i++) {
		if (hideIt[i].className == "hider chemical") {
			if (hideIt[i].style.display == "" || hideIt[i].style.display == "none") {
				hideIt[i].style.display = "table-row";
				document.getElementById("moremore").style.display = "none";
			}
		}
	}
}

function colorDataTable() {
	if (document.getElementById('mydata') == null) {
		return false;
	}
	
	var data_table = document.getElementById('mydata');
	var td_index = 1; // which TD contains the data
	
	///// STEP 1 - Get the, get the, get the data!
	// get the data[] from the table
	
	var tds, data = [], color, colors = [], value = 0, total = 0;
	var trs = data_table.getElementsByTagName('tr'); // all TRs
	for (var i = 0; i < trs.length; i++) {
		tds = trs[i].getElementsByTagName('td'); // all TDs
		if (tds.length === 0) continue; //  no TDs here, move on
		// get the value, update total
		value  = parseFloat(tds[td_index].innerHTML);
		data[data.length] = value;
		total += value;
		// background color
		var bgcolorlist=new Array("#C66363","#ced17b","#7ba7d1","#C66363");
		color = bgcolorlist[i];
		colors[colors.length] = color; // save for later
		trs[i].style.backgroundColor = color; // color this TR
	}
}

function createGraph(chartSize) {
	/* variables */
	var triggerClass = "tochart";
	var chartClass = "fromtable";
	var chartColor = "ced17b";
	var airColor = "ced17b";
	var waterColor = "7ba7d1";
	var landColor = "C66363";

	/* end variables */

	var tables = document.getElementsByTagName("table");
	var sizeCheck = /\s?size([^\s]+)/;
	for(var i=0;tables[i];i++) {
		var t = tables[i];
		var c = t.className;
		var data = [];
		var labels = []
		if(c.indexOf(triggerClass) !== -1) {
			var size = sizeCheck.exec(c);
			size = size ? size[1] : chartSize;
			var charturl = "http://chart.apis.google.com/chart?cht=p&chco="+airColor+"|"+waterColor+"|"+landColor+"&chs=" + size + "&chd=t:";
			var tds = t.getElementsByTagName("tbody")[0].getElementsByTagName("td");
			for(var j=0;tds[j];j+=2){
				labels.push(tds[j].innerHTML);
				data.push(tds[j+1].innerHTML);
			};
			if(data[0] == 0 && data[1] == 0 && data[2] == 0) {
				charturl = "http://chart.apis.google.com/chart?cht=p&chco=898a8b&chs=" + size + "&chd=t:1";
				labels[0] = "";
				labels[1] = "";
				labels[2] = "";
			}
			if (data[0] == 0) {
				labels[0] = "";
			}
			if (data[1] == 0) {
				labels[1] = "";
			}
			if (data[2] == 0) {
				labels[2] = "";
			}
			var chart = document.createElement("img");
			chart.setAttribute("src",charturl+data.join(",") + "&chl=" + labels.join("|"));
			chart.setAttribute("alt", "Releases");
			chart.className = chartClass;
			t.parentNode.insertBefore(chart,t);
		}
	}
}