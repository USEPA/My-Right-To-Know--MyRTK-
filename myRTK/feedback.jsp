<%--
	Document   : search
	Created on : Apr 13, 2010, 3:43:37 PM
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
	String title =feedbk;
	String nav = "";
	if(DS1) { nav = "navigation"; } else { nav="portalMenu-tabs"; }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta name="DC.description" content="myRTK is an EPA website designed for mobile devices. For any address, the map displays nearby facilities regulated under federal environmental laws. Facility reports provide summaries of chemical/pollutant releases, chemical effects, and compliance history from numerous data systems." />

	<meta name="keywords" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />

	<meta name="DC.Subject" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />
	
	<title>myRTK - <%=feedbk%></title>
	<link rel="icon" type="image/png" href="favicon.png" />
	
	<% if(DS1) { %>
		<style type="text/css" media="screen">@import 'css/ds1.css';</style>
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
		<meta name="format-detection" content="telephone=no" />
		<link rel="apple-touch-icon" href="index.png" />
	<% } else  if(DS2) { %>
		<style type="text/css" media="screen">@import 'css/ds2.css';</style>
	<% } else if(DS3) { %>
		<style type="text/css" media="screen">@import 'css/ds3.css';</style>
		<meta name="HandheldFriendly" content="True" />
		<meta http-equiv="x-rim-auto-match" content="none" />
	<% } else { %>
		<style type="text/css" media="screen">@import 'css/ds4.css';</style>
	<% } %>
	<script type="text/javascript" src="js/cookies.js"></script>
	<script type="text/javascript" src="js/core.js"></script>
	
	<script type="text/javascript" src="js/gears_init.js"></script>
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>
	<script type="text/javascript" src="js/geolocate.js"></script>
</head>

<body onload="





();">
	<div id="header"></div>
      <div id="<%=nav%>">
		<noscript id="jsdetect">This website requires JavaScript to function properly. Please enable JavaScript and try again.</noscript>
 		<ol>
			<% if(DS1 || DS2) { %>
			<li><a href="#" onclick="findUserLocationMap()"><%=map%></a></li>
			<% } %>
			<li><a href="#" onclick="findUserLocationList()"><%=list%></a></li>
			<li id="current"><a class="active" href="search.jsp"><%=search%></a></li>
			<li><a href="info.jsp"><%=information%></a></li>
		</ol>
		</div>


	<div id="content">
		<h1><%=title%></h1>
			<form action="email.jsp" method="POST" >
			<ul id="searchform" >
			<li>	<label for="Name"><%=name1%></label><br/><input class="searchbox" <% if(DS1) { %>value="Name"<% } %> name="Name" type="text"/></li>
			<li>	<label for="Phone"><%=ph1%></label><br/><input class="searchbox" <% if(DS1) { %>value="Phone"<% } %> name="Phone" type="text"/></li>
			<li>	<label for="email"><%=email1%></label><br/><input class="searchbox" <% if(DS1) { %>value="email"<% } %> name="email" type="text"/></li>
			<!--li>	<label for="comments"><%=comm1%></label><input class="searchbox" <% if(DS1) { %>value="comments"<% } %> name="comments" rows="3" cols="30" type="textarea"/></li-->
			<li style="height:100px">	<label for="comments"><%=comm1%></label><br/><textarea class="searchbox" rows="2" cols="30" <% if(DS1) { %>value="comments"<% } %> name="comments3"> </textarea><br/></li>

                        <li>	<input id="submit_form" type="submit" value="submit"></li>
			</ul>	
			
		</form>
	</div>
		<script type="text/javascript">
		var map = null;
		var geocoder = null;
		
		function initialize() {
			<%	if(DS1) { %>
				activatePlaceholders();
			<% } %>
				geocoder = new google.maps.Geocoder();
				
		}
		
		function showAddress() {
			if (geocoder) {
				var inputs = getElementsByClassName("searchbox");
				var addr = "";
				for (var i=0;i<inputs.length;i++) {
					if(inputs[i].value == "Street" || inputs[i].value == "City" || inputs[i].value == "State" || inputs[i].value == "Zip Code") {
						inputs[i].value = "";
					}
					addr += inputs[i].value+" ";
				}
				
				geocoder.geocode({'address': addr, 'region': 'us'}, function(results, status) {
					if (status == google.maps.GeocoderStatus.OK) {
					<% if(DS1 || DS2) { %>	
					window.location = "map.jsp?point="+results[0].geometry.location.toUrlValue();
					<% } else { %>
					var lat = results[0].geometry.location.lat();
					var lng = results[0].geometry.location.lng();
					window.location = "list.jsp?lat="+lat+"&lng="+lng;
					<% } %>
					return false;
					} else {
						alert("Please enter an address.");
					<%	if(DS1) { %>
						activatePlaceholders();
					<% } %>
					}
				});
			} else { alert("Geocoder is failing"); }
		}

		window.scrollTo(80, 0);
	</script>

	<%@ include file="foot.jsp" %>

</body>
</html>
