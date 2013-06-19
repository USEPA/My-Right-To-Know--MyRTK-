<%--
	Document   : map
	Created on : Apr 14, 2010, 2:43:37 PM
	Author     : BellFeinsD
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.Context,
	javax.naming.InitialContext,
	java.lang.Boolean,java.sql.*,
	java.lang.Object,java.io.*,
	java.net.URLEncoder,
	java.util.*,
	java.text.SimpleDateFormat,
	java.text.DecimalFormat,
	java.util.HashMap" %>
<%@ include file="langpage.jsp" %>
<%
String containFramesHeader ="";
StringBuffer Url = request.getRequestURL();
if(request.getParameter("containFrame") !=null)
{
  containFramesHeader = request.getParameter("containFrame");
}
String containFrames="No";
String plat = "";
String plng = "";
String ppoint = "";

if(containFramesHeader.indexOf("containFrames") != -1)
{
	containFrames ="Yes";
	plat = request.getParameter("lat");
	plng = request.getParameter("lng");
	if(plat == null )
	{
		ppoint = request.getParameter("point");
		StringTokenizer token = new StringTokenizer(ppoint, ",");
    		while(token.hasMoreTokens())
			{
      			   if(plat==null) plat = token.nextToken();
				else { plng =token.nextToken(); }
			}
  		
	}
	System.out.println("here"+plat+","+plng + ",point="+ppoint);
	
}
	String ua = request.getHeader( "User-Agent" );
	boolean isBlackberry = ( ua != null && ua.indexOf( "BlackBerry" ) != -1 );

	boolean isFirefox = ( ua != null && ua.indexOf( "Firefox/" ) != -1 );
	boolean isChrome = ( ua != null && ua.indexOf( "Chrome/" ) != -1 );
	boolean isSafari = ( ua != null && ua.indexOf( "Safari/" ) != -1 && ua.indexOf( "iPhone" ) == -1);
	boolean isMSIE = ( ua != null && ua.indexOf( "MSIE" ) != -1 );
	boolean isOpera = ( ua != null && ua.indexOf( "Opera" ) != -1 );

	boolean isIphone = (ua != null && ua.indexOf( "iPhone" ) != -1 );
	boolean isAndroid = (ua != null && ua.indexOf( "Android" ) != -1 );
	boolean DS1 = false;
	boolean DS2 = false;
	boolean DS3 = false;
	boolean DS4 = false;
	if(isIphone || isAndroid) {
		DS1 = true;
	} else if(isFirefox || isChrome || isMSIE || isSafari || isOpera) {
		DS2 = true;
	} else if(isBlackberry) {
		DS3 = true;
	} else {
		DS4 = true;
	}

	response.setHeader( "Vary", "User-Agent" );
	String title =map;
	String nav = "";
	if(DS1 || DS3) { nav = "navigation"; } else { nav="portalMenu-tabs"; }
%>

<%@ include file="top.jsp" %>
	<!--<meta name="DC.description" content="myRTK is an EPA website designed for mobile devices. For any address, the map displays nearby facilities regulated under federal environmental laws. Facility reports provide summaries of chemical/pollutant releases, chemical effects, and compliance history from numerous data systems." />

	<meta name="keywords" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />

	<meta name="DC.Subject" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />

	<title>myRTK - <%=map%></title>
	-->
	<link rel="icon" type="image/png" href="favicon.png" />

	<style type="text/css">
	#trimap {
		height: 88%;
		width: 100%;
		border: 1px solid black;
		background: E4E3DE;
	}
	#dialog {
		height: 55px !important;
		padding: 3px;
	}
	.ui-dialog-titlebar {
		display: none !important;
	}
	.ui-dialog-content {
		height: 50px;
	}
	.ui-dialog-buttonpane {
		padding: 1px;
	}
	.ui-button {
		float: right;
	}
	.ui-widget-overlay {
		width: 620px !important;
		height: 750px !important;
	}
	</style>

	<% if(DS1) { %>
		<style type="text/css" media="screen">@import 'css/ds1.css';</style>
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
		<meta name="format-detection" content="telephone=no" />
		<link rel="apple-touch-icon" href="index.png" />
	<% } else  if(DS2) { %>
		<style type="text/css" media="screen">@import 'css/ds2.css';</style>
		<style type="text/css" media="screen">@import 'css/jquery-ui-1.8.1.custom.css';</style>
		<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript" src="js/jquery-ui-1.8.1.custom.min.js"></script>
	<% } else if(DS3) { %>
		<style type="text/css" media="screen">@import 'css/ds3.css';</style>
		<meta name="HandheldFriendly" content="True" />
		<meta http-equiv="x-rim-auto-match" content="none" />
	<% } else { %>
		<style type="text/css" media="screen">@import 'css/ds4.css';</style>
	<% } %>

	<script type="text/javascript" src="js/cookies.js"></script>
	<script type="text/javascript" src="js/core.js"></script>
	<% if(langparm1.trim().equalsIgnoreCase("eng"))
	 { %>  <script type="text/javascript" src="http://maps.google.com/maps/api/js?file=api&v=3&sensor=true&language=en"></script>
	<% } else { %>
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?file=api&v=3&sensor=true&language=es"></script>
	<% } %>
	<script type="text/javascript" src="js/gears_init.js"></script>
	<script type="text/javascript" src="js/geolocate.js"></script>
	<script type="text/javascript" src="js/ajax.js"></script>

	<script type="text/javascript">
		$(document).ready(function() {
			var poswidth = 175;
			var posheight = 325;
			$('#dialog').dialog({
				autoOpen: false,
				height: 70,
				width: 270,
				modal: true,
				draggable: false,
				resizable: false,
				position: [poswidth,posheight],
				buttons: {
					Ok: function() {
						$(this).dialog('close');
					}
				}
			});
		});
	</script>
<!-- InstanceEndEditable -->
<!-- InstanceParam name="bodyClass" type="text" value="apps" -->


</head>

<body class="apps" onload="load();detectBrowser();">
<% if(containFrames=="No") { %>	
<%@ include file="justbanner.jsp" %>
<%} %>
	<% String srchtab="" ;
		String listtab="" ;
		String maptab="" ;
		String infotab="" ;
		String info2tab="" ;
		%>
	<% if( DS2) { %>
        <%  srchtab="" ;
		 listtab="" ;
		 maptab="style=\"background: url(images/tab-right-current.gif)\"" ;
		 infotab="" ;
		info2tab="" ;
	%>
	<% } %>
	<% if( DS1||DS3) {  %>
	<% srchtab="" ;
		listtab="" ;
		maptab="class=\"active\"" ;
		infotab="" ;
		info2tab="" ;
	%>
	<% } %>
	<% if(containFrames=="No") { %>	
	 <%@ include file="toplinks.jsp" %>
	 <%}else { %>
		<%@ include file="toplinks-F.jsp" %>
	<%} %>
	   <!-- <div id="map_content"> -->
	
		
		<div id="trimap" style="display:block;"></div>
		<div id="legend" style="display:block; border:1px solid black; background:white;font-size:0.895em;">
		<% if(containFrames=="Yes") { %>
			<%=infocontent5map%><br/>
			<%=infocontent6map%>
		<% }
	 	%>
		</div>
		
	<!-- </div> -->
	<% if(containFrames=="No") { %>	
                 <%@ include file="abovefooter.jsp" %>
		<div id="footer">
  			<p><a id="feedback_menu" href="http://m.epa.gov/privacy.html">Privacy</a><span class="key">[+]</span><a id="contact_menu" href="http://m.epa.gov/contact/index.html" accesskey="+">Contact</a><span class="key">[#]</span><a href="http://www.epa.gov/?m_rd=false" accesskey="#" title="EPA.gov Full Site">EPA.Gov</a><a id="desktop" href="http://www.epa.gov/?m_rd=false">Full site</a></p>
		</div>
		<%} %>
	<script type="text/javascript">
		//<![CDATA[
		var map;
		var markersArray = [];
		var locArray = [];
		var infoWindow;
		var modalState = 0;
		function openwin(url1)
		{
			mywin=window.open(url1,'mywin','toolbar=no,menubar=no,scrollbars=yes,resizable=yes, width=720px,height=400px');
			mywin.focus();
		}
		function load() {
			var center = findCenter();
			var zoom = findZoom();
			// Set map options
			var myOptions = {
				center: center,
				zoom: zoom,
				mapTypeId: google.maps.MapTypeId.ROADMAP
				//, mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,position: google.maps.ControlPosition.TOP_CENTER}
			}
			// Define the map
			map = new google.maps.Map(document.getElementById("trimap"), myOptions);
			map.disableDoubleClickZoom = true;
			// Create our popup window
			infoWindow = new google.maps.InfoWindow();
			var myloc = new google.maps.MarkerImage('images/blue_dot.png',
				new google.maps.Size(12, 12),
				new google.maps.Point(0, 0),
				new google.maps.Point(6, 6));
			var locmarker = new google.maps.Marker({
				position: findCenter(),
				flat: true,
				zIndex: 0,
				map: map,
				icon: myloc
				});
			cookieGen();

			// Called on initial map load
			google.maps.event.addListener(map, 'tilesloaded', function() {
				google.maps.event.clearListeners(map, 'tilesloaded');
				checkZoom();
			});
                        //map.disableDoubleClickZoom();
			google.maps.event.addListener(map,'dragend', function(){checkZoom();});
			google.maps.event.addListener(map,'zoom_changed', function(){checkZoom();});
			google.maps.event.addListener(map,'bounds_changed', function(){checkZoom();});
			google.maps.event.addListener(map, 'click', function(){infoWindow.close();});
			//google.maps.event.addListener(locmarker, 'click', function() {
				//map.setCenter(locmarker.getPosition());
				//map.setZoom(14);

			//});

			var geoControlDiv = document.createElement('DIV');
			var geoCtrl = new GeoLocControl(geoControlDiv, map);

			geoControlDiv.index = 1;
			map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(geoControlDiv);
		}

		function populateMap() {
			modalState = 0;
			// Get our boundaries
			var swlat = map.getBounds().getSouthWest().lat();
			var swlng = map.getBounds().getSouthWest().lng();
			var nelat = map.getBounds().getNorthEast().lat();
			var nelng = map.getBounds().getNorthEast().lng();

			// Set up our XML request
			var passToList = "swlat="+swlat+"&swlng="+swlng+"&nelat="+nelat+"&nelng="+nelng;
			var searchUrl = 'locations.jsp?'+passToList;
			del_cookie('bounds');
			setCookie('bounds',passToList,1);


			// Make our XML request
			downloadUrl(searchUrl, function(data) {
				//var xml = parseXml(data);
				var xml = data.responseXML; 
				var markerNodes = xml.documentElement.getElementsByTagName("marker");

				// Retrieve variables from XML request
				for (var i = 0; i < markerNodes.length; i++) {
					var NAME = markerNodes[i].getAttribute("name");
					var ADDR = markerNodes[i].getAttribute("address");
					var CITY = markerNodes[i].getAttribute("city");
					var STATE = markerNodes[i].getAttribute("state");
					var ZIP = '' + markerNodes[i].getAttribute("zip");
					var TRIID = markerNodes[i].getAttribute("triid");
					var FRS = markerNodes[i].getAttribute("frs");
					var TEXTSECTOR = markerNodes[i].getAttribute("sector");
					var ISTRI = markerNodes[i].getAttribute("istri");
					var LAT = markerNodes[i].getAttribute("lat");
					var LNG = markerNodes[i].getAttribute("lng");
					var point = new google.maps.LatLng(parseFloat(LAT),parseFloat(LNG));

					// Sent variables off to create a marker
					createMarker(point, TRIID, FRS, TEXTSECTOR, NAME, ADDR, CITY, STATE, ZIP, ISTRI);
				}
			});
		}

		function deleteMarkers() {
			if (markersArray) {
				for (i in markersArray) {
					markersArray[i].setMap(null);
				}
				markersArray.length = 0;
			}
		}

		function cookieGen() {
			var acenter = map.getCenter().toString();
			//alert(acenter );
			acenter = acenter.substr(1,acenter.length-2);
			var alevel = map.getZoom();
			del_cookie('center');
			del_cookie('centerlevel');
			setCookie('center',acenter,1);
			setCookie('centerlevel',alevel,1);
		}

		function GeoLocControl(controlDiv, map) {

			// Set CSS styles for the DIV containing the control
			controlDiv.style.padding = '5px';

			// Set CSS for the control
			var controlUI = document.createElement('DIV');
			controlUI.style.border = '1px solid black';
			controlUI.style.cursor = 'pointer';
			controlUI.style.textAlign = 'center';
			controlUI.style.background = 'white url(images/my_location_button.png) no-repeat';
			controlUI.style.width = '20px';
			controlUI.style.height = '20px';
			controlUI.style.MozBorderRadius = '5px';
			controlUI.style.webkitBorderRadius = '5px';
			//controlDiv.appendChild(controlUI);

			controlDiv.appendChild(document.getElementById("legend"));
			// Create the DOM listener
			google.maps.event.addDomListener(controlUI, 'click', function() {
				// Try W3C Geolocation (Preferred)
				if(navigator.geolocation) {
					browserSupportFlag = true;
					navigator.geolocation.getCurrentPosition(function(position) {
						initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
						map.setCenter(initialLocation);
						window.top.location.search = '';
						infoWindow.close();
						deleteMarkers();
						populateMap();
						cookieGen();
					}, function() {
						handleNoGeolocation(browserSupportFlag);
					});
					// Try Google Gears Geolocation
				} else if (google.gears) {
					browserSupportFlag = true;
					var geo = google.gears.factory.create('beta.geolocation');
					geo.getCurrentPosition(function(position) {
						initialLocation = new google.maps.LatLng(position.latitude,position.longitude);
						map.setCenter(initialLocation);
						window.top.location.search = '';
						infoWindow.close();
						deleteMarkers();
						populateMap();
						cookieGen();
					}, function() {
						handleNoGeoLocation(browserSupportFlag);
					});
					// Browser doesn't support Geolocation
				} else {
					browserSupportFlag = false;
					handleNoGeolocation(browserSupportFlag);
				}

				function handleNoGeolocation(errorFlag) {
					if (errorFlag == true) {
						alert("Geolocation service failed.");
					} else {
						alert("Your browser doesn't support geolocation.");
					}
				}
			});
		}

		function checkZoom() {
		//FUNCTION DESIGNED TO TEST ZOOM LEVEL AND IF IT'S BELOW '11', NOT DISPLAY RESULTS AND INSTEAD SHOW OVERLAY SAYING 'ZOOM IN FOR RESULTS'
			var zoomlvl = map.getZoom();
			if(zoomlvl < 12) {
				deleteMarkers();
				if(modalState != 1) {
					$("#dialog").dialog("open");
				<% if(DS1) { %>
					alert("No search results will be displayed beyond this zoom level. Zoom in to see facilities on the map.");
				<% } %>
					modalState = 1;
				}
				cookieGen();
			} else {
				deleteMarkers();
				populateMap();
				cookieGen();
			}
		}

		function findZoom() {
			var zoomlevel;
			var defzoom = 13;
			if (getCookie('centerlevel')) { var alevel= getCookie('centerlevel'); }
			if ((alevel==null) || (alevel=="")) {
				return defzoom;
			} else {
				zoomlevel = parseInt(alevel);
				return zoomlevel;
			}
		}

		function findCenter() {
				var queryString ="";
			<% if(containFrames=="No") { %>	
				
				 queryString = window.top.location.search.substring(1);
			<% } else {
					if(plat!= null)
					{
				 	%>
				  	queryString = "&point="+<%=plat%>+","+<%=plng%>;
					<% }
					else { %>
					alert(<%=ppoint %>);
					queryString =  "&point="+<%=request.getParameter("point") %> ;
					<% } %>
			<% } %>
			// queryString = window.top.location.search.substring(1);
			
			if (getParameter(queryString,"point")) {
				// Using getParameter to find location from url
				queryval = getParameter(queryString,"point");

				// Process url substring
				var latlng = queryval.split(",");
				var lat = latlng[0];
				var lng = latlng[1];

				// Define our center
				var center = new google.maps.LatLng(lat, lng);

				return center;
			} else {
				if (getCookie('center')) { var acenter = getCookie('center'); }
				if (getCookie('centerlevel')) { var alevel= getCookie('centerlevel'); }
				if ((acenter==null) || (acenter=="")) {
					// Testing geolocation
					return geolocMap();
				} else {
					// Pulling data from the cookie
					latlng = acenter.split(",");
					var lat = latlng[0];
					var lng = latlng[1];
					acenter = new google.maps.LatLng(lat, lng);

					return acenter;
				}
				// Working from the default location
				// return new google.maps.LatLng(42.375097,-71.105608);
			}
		}

		function getParameter( queryString, parameterName ) {
			// Add "=" to the parameter name (i.e. parameterName=value)
			var parameterName = parameterName + "=";
			if ( queryString.length > 0 ) {
				// Find the beginning of the string
				begin = queryString.indexOf ( parameterName );
				// If the parameter name is not found, skip it, otherwise return the value
				if ( begin != -1 ) {
					// Add the length (integer) to the beginning
					begin += parameterName.length;
					// Multiple parameters are separated by the "&" sign
					end = queryString.indexOf ( "&" , begin );
					if ( end == -1 ) {
						end = queryString.length
					}
					// Return the string
					return unescape ( queryString.substring ( begin, end ) );
				}
				// Return "null" if no parameter has been found
				return "null";
			}
		}
		function openPopup(url) {
			 window.open(url, "popup_id", "scrollbars,resizable,width=300,height=400");
			}


		function createMarker(point, TRIID, FRS, TEXTSECTOR, NAME, ADDR, CITY, STATE, ZIP, ISTRI) {
			var marker;
			var id;
			var idt;
			var glyph = [];
		//	glyph[0] = "http://labs.google.com/ridefinder/images/mm_20_blue.png";
		//	glyph[1] = "http://labs.google.com/ridefinder/images/mm_20_gray.png";
			glyph[0] = "images/blue.png";
			glyph[1] = "images/gray.png";
			var imgtri = new google.maps.MarkerImage('images/blue.png',
			  // This marker is 20 pixels wide by 32 pixels tall.
			  new google.maps.Size(20, 32),
			  // The origin for this image is 0,0.
			  new google.maps.Point(0,0),
			  // The anchor for this image is the base of the flagpole at 0,32.
			  new google.maps.Point(0, 32));

			var imgnontri = new google.maps.MarkerImage('images/gray.png',
				new google.maps.Size(20, 32),
				new google.maps.Point(0,0),
				new google.maps.Point(0, 32));


			var shadow = new google.maps.MarkerImage('images/shadow.png',
			  // The shadow image is larger in the horizontal dimension
			  // while the position and offset are the same as for the main image.
			  new google.maps.Size(37, 32),
			  new google.maps.Point(6,0),
			  new google.maps.Point(0, 32));

			ISTRI = unescape(ISTRI);
			ISTRI = ISTRI.replace(/\+/g," ");
			if (ISTRI=="yes") {
				marker = new google.maps.Marker({
				position: point,
				title: unescape(NAME).replace(/\+/g," "),
				map: map,
				shadow: shadow,
				zIndex: 5,
				icon: imgtri
				});
				glyph[3] = glyph[0];
				id = TRIID;
				idt = "TRI";
			} else {
				marker = new google.maps.Marker({
				position: point,
				title: unescape(NAME).replace(/\+/g," "),
				map: map,
				shadow: shadow,
				zIndex: 4,
				icon: imgnontri
				});
				glyph[3] = glyph[1];
				id = FRS;
				idt = "FRS";
			}

			// clean stuff
			NAME = unescape(NAME);
			NAME = NAME.replace(/\+/g," ");

			ADDR = unescape(ADDR);
			ADDR = ADDR.replace(/\+/g," ");

			CITY = unescape(CITY);
			CITY = CITY.replace(/\+/g," ");

			STATE = unescape(STATE);
			STATE = STATE.replace(/\+/g," ");

			ZIP = unescape(ZIP);
			ZIP = ZIP.replace(/\+/g," ");

			while (ZIP.length<5) {
				ZIP = '0' + ZIP;
			}

			TEXTSECTOR = unescape(TEXTSECTOR);
			TEXTSECTOR = TEXTSECTOR.replace(/\+/g," ");
			var full_name = "";
			<% if(containFrames=="No") { %>	
		full_name = "<li><img src=\""+glyph[3]+"\" alt=\"Facility Type\" /><a href=\"report.jsp?IDT="+idt+"&ID="+id+"\"><u>"+NAME+"</u><\/a><\/li>";
			<% }else { %>
			var url ="report.jsp?containFrame=containFrames&IDT="+idt+"&ID="+id;
			//full_name = "<li><img src=\""+glyph[3]+"\" alt=\"Facility Type\" /><a onclick= javascript:openwin('"+url+"');> <u>"+NAME+"</u> <\/a><\/li>";
			full_name = "<li><img src=\""+glyph[3]+"\" alt=\"Facility Type\" /><a href="+url+"><u>"+NAME+"</u><\/a><\/li>";
			<% } %>
			var full_addr = "<li>"+ADDR+"<\/li><li>"+CITY+", "+STATE+" "+ZIP+"<\/li>";
			var full_sector = "<li>"+TEXTSECTOR+"<\/li>";
			var html = "<ul class=\"mapaddr\">"+full_name+full_addr+full_sector+"<\/ul>";
			<% if(DS3) { %>
				google.maps.event.addListener(marker, 'click', (function(marker) {
        			return function() {
          				infowindow.setContent(html);
          				infowindow.open(map, marker);
        					}
      					});
			
			<% } else { %>
			google.maps.event.addListener(marker, 'click', function() {
				infoWindow.setContent(html);
				infoWindow.open(map, marker);
			});
			<% } %>
			markersArray.push(marker);
			google.maps.event.clearListeners(map, 'bounds_changed');

		}

		function detectBrowser() {
			var useragent = navigator.userAgent;
			var mapdiv = document.getElementById("trimap");
			<% if(DS1) { %>
				mapdiv.style.cssFloat = 'none';
				<% if(isIphone) {%>
				mapdiv.style.width = '100%';
				mapdiv.style.height = '100%';
			<% } else if(isAndroid) { %>
				mapdiv.style.width = '100%';
				mapdiv.style.height = '100%';
			<% } } else { %>
				mapdiv.style.width = '95%';
				mapdiv.style.height = '350px';
				//document.getElementById("report").style.height = mapdiv.style.height;
		  <% } %>
		}
		//]]>
	</script>
	<script type="text/javascript">
		window.scrollTo(80, 0);
	</script>
		
<% if(containFrames=="No") { %>	
	<%@ include file="bottom.jsp" %>
	<% } %>