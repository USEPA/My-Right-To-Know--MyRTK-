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
	java.lang.StringBuilder,
	java.text.SimpleDateFormat,
	java.text.DecimalFormat,
	java.util.HashMap ,java.lang.*,java.net.*"%>
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
	String title ="My Right To Know";
	String nav = "";
	if(DS1) { nav = "navigation"; } else { nav="portalMenu-tabs"; }

	

%>
<%
   	String containFramesHeader ="";
	
	if(request.getParameter("containFrame") !=null)
	{
  		containFramesHeader = request.getParameter("containFrame");
	}

	if(containFramesHeader.indexOf("containFrames") != -1)
	{
	}
	else
	{
    		String redirectURL = "search.jsp";
    		response.sendRedirect(redirectURL);
	}
%>
<%@ include file="langpage.jsp" %>
<%@ include file="top.jsp" %>

	<script type="text/javascript">
		var map = null;
		var geocoder = null;

				
		
		function 	showAddressinIndexPage() {
			geocoder = new google.maps.Geocoder();
			
			if (geocoder) {
				var inputs = getElementsByClassName("searchbox");
				var addr = "";
				for (var i=0;i<inputs.length;i++) {
					if(inputs[i].value == "Street" || inputs[i].value == "City" || inputs[i].value == "State" || inputs[i].value == "Zip Code"||
						inputs[i].value == "<%=street%>" || inputs[i].value == "<%=city%>" || inputs[i].value == "<%=state%>" || inputs[i].value == "<%=zip%>") {
						inputs[i].value = "";
						
					}
					addr += inputs[i].value+" ";
				}
				
				geocoder.geocode({'address': addr, 'region': 'us'}, function(results, status) {
					if (status == google.maps.GeocoderStatus.OK) {
					<% if(DS1 || DS2) { %>	
					
					//window.location = "map.jsp?containFrame=containFrames&point="+results[0].geometry.location.toUrlValue();
					window.location = "map.jsp?containFrame=containFrames&lat="+results[0].geometry.location.lat()+"&lng="+results[0].geometry.location.lng();
					<% } else { %>
					var lat = results[0].geometry.location.lat();
					var lng = results[0].geometry.location.lng();
					window.location = "list.jsp?containFrame=containFrames&lat="+lat+"&lng="+lng;
					<% } %>
					return false;
					} else {
						alert("<%=jsm5%>");
					<%	if(DS1) { %>
						activatePlaceholders();
					<% } %>
					}
				});
			} else { alert("<%=jsm6%>"); }
		}

		window.scrollTo(80, 0);
	</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta name="DC.description" content="myRTK is an EPA website designed for mobile devices. For any address, the map displays nearby facilities regulated under federal environmental laws. Facility reports provide summaries of chemical/pollutant releases, chemical effects, and compliance history from numerous data systems." />

	<meta name="keywords" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />

	<meta name="DC.Subject" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />
	
	<title>myRTK - Home</title>
	<link rel="icon" type="image/png" href="favicon.png" />
	
	<title>test</title>                 
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />                 
<style type="text/css">
div.background
  {
 width: 700px;
	height :370px;
  background:url(images/usmap.png) no-repeat ;
  border:2px solid black;
  }
div.transbox
  {
  width:50%;
  height:350px;
  background-color:#ffffff;
  border:1px solid black;
  opacity:0.6;
  filter:alpha(opacity=60); /* For IE8 and earlier */
  }
div.transbox 
  {
  margin:0px 0px; 
  font-weight:bold;
  font-size:10px;
  color:#000000;
  }
</style>

	
	<script type="text/javascript" src="js/showmap.js"></script>
	
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
	
	 <script type="text/javascript" src="http://maps.google.com/maps/api/js?file=api&v=3&sensor=true&language=en"></script>

</head> 

<body id="indexBody">
<div width="100%" height="100%">
	<div id="header"></div>
	<div id="<%=nav%>">
		<noscript id="jsdetect">This website requires JavaScript to function properly. Please enable JavaScript and try again.</noscript>
	
	</div>

	
	<div id="mapBackGroundDiv" class="background">
		<div align="center">
			<div id="searchFrame" class="transbox">
 				<jsp:include page="search.jsp" >
    				<jsp:param name="containFrame" value="containFrames" />

				</jsp:include>
 

			</div>
		</div>
	</div>
              
</div>
	
	<script type="text/javascript">
		window.scrollTo(80, 0);
	</script>
</body>
</html>