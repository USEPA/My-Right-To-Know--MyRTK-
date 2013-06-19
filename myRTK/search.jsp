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
    String containFramesHeader ="";
    String Url = request.getRequestURL().toString();
    String indexPage = request.getRequestURL().toString();
  if(request.getParameter("containFrame") !=null)
  {
	  containFramesHeader = request.getParameter("containFrame");
  }
    String containFrames="No";
    if(containFramesHeader.indexOf("containFrames") != -1 )
    {
    	containFrames ="Yes";
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
	String title ="Search";
	String nav = "";
	if(DS1) { nav = "navigation"; } else { nav="portalMenu-tabs"; }
	
%>

<%@ include file="langpage.jsp" %>
<%@ include file="top.jsp" %>





	<!--<meta name="DC.description" content="myRTK is an EPA website designed for mobile devices. For any address, the map displays nearby facilities regulated under federal environmental laws. Facility reports provide summaries of chemical/pollutant releases, chemical effects, and compliance history from numerous data systems." />

	<meta name="keywords" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />

	<meta name="DC.Subject" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />
	
	<title>myRTK - <%=stitle%></title>
	-->
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
	<% if(langparm1.trim().equalsIgnoreCase("eng")) { %>
	<script type="text/javascript" src="js/geolocate.js"></script>
	<% } else { %>
	<script type="text/javascript" src="js/geolocatespn.js"></script>
	<% } %>


<!-- InstanceEndEditable -->
<!-- InstanceParam name="bodyClass" type="text" value="apps" -->

<% if(containFrames=="No") { %>	
<body class="apps"  onload="initialize();">

<%@ include file="justbanner.jsp" %>
<%} else { %>
<body class="apps" id="appSearch" onload="initialize();">
<% } %>


	
	<%@ include file="langpage-2.jsp" %>
	<% String srchtab="" ;
		String listtab="" ;
		String maptab="" ;
		String infotab="" ;
		String info2tab="" ;
	%>
	<% if( DS2) { %>
        <%  srchtab="style=\"background: url(images/tab-right-current.gif)\"" ;
		 listtab="" ;
		 maptab="" ;
		 infotab="" ;
		info2tab="" ;
	%>
	<% } %>
	<% if( DS1||DS3) {  %>
	<% srchtab="class=\"active\"" ;
		listtab="" ;
		maptab="" ;
		infotab="" ;
		info2tab="" ;
	%>
	<% } %>
	<% if(containFrames=="No") { %>	
	 <%@ include file="toplinks.jsp" %>
	 <% } %>
	
<!-- InstanceBeginEditable name="content" -->
	<% if( DS1||DS3||DS2) { %>
	<div id="contentSearch">
	<% } %>
        	<% if(containFrames=="No") { %>	
	<p><b><%=stitle%></b></p>
<% } %>
		
		<p><%=sinfotext1%></p>
		<% if( DS1||DS3) { %>
		<p><%=sinfotext2%></p>
		<% } %>
		<% if( DS2) { %>
		<p><%=sinfotextbrow%></p>
		<% } %>
		
		
		
		<form  id="searchform" action="#" method="POST" onsubmit="showAddressBasedOnURL(); return false;">
		
			<ul id="searchform" >
				<li><b><label for="Street"><%=street%></label></b><input  class="searchbox"   <% if(DS1) { %>value="<%=street%>"<% } %> name="street" type="text" > </input></li>
				<li><b><label for="City"><%=city%></label></b><input class="searchbox"  <% if(DS1) { %>value="<%=city%>"<% } %> name="city" type="text"></input></li>
				<li><b><label for="State"><%=state%></label></b><input class="searchbox"   <% if(DS1) { %>value="<%=state%>"<% } %> name="state" type="text"></input></li>
				<li><b><label for="Zip"><%=zip%></label></b><input class="searchbox"  <% if(DS1) { %>value="<%=zip%>"<% } %> name="zip" type="text"></input></li>
				
				
			</ul>
			
		<br/>
		
		<% if( DS1||DS3||DS2) { %><center><% } %>
		
		
		<input id="submit_form"  type="submit" value="<%=find_fac%>"></input>

		<% if( DS1||DS3||DS2) { %></center><% } %>		
		</form>
		
<% if(containFrames=="No") { %>			
<br></br>
<% } %>	
 </div>
 <% if(containFrames=="No") { %>			
<hr/>
<% } %>	

<% if(containFrames=="No") { %>	
    <%@ include file="abovefooter.jsp" %>
	<div id="footer">
  		<p><a id="feedback_menu" href="http://m.epa.gov/privacy.html">Privacy</a><span class="key">[+]</span><a id="contact_menu" href="http://m.epa.gov/contact/index.html" accesskey="+">Contact</a><span class="key">[#]</span><a href="http://www.epa.gov/?m_rd=false" accesskey="#" title="EPA.gov Full Site">EPA.Gov</a><a id="desktop" href="http://www.epa.gov/?m_rd=false">Full site</a></p>
	</div>
	<% }%>	
	
     
	<script type="text/javascript">
		var map = null;
		var geocoder = null;
		
		function initialize() {
			<%	if(DS1) { %>
				activatePlaceholders();
			<% } %>
			
				geocoder = new google.maps.Geocoder();
		}
		
		function showAddressBasedOnURL() {
			<% if(containFrames=="No") { %>	
			showAddress();
			<%}else{ %>
			showAddressinIndexPage();
			<%} %>
			}
	
		
		function showAddress() {
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
					
					window.location = "map.jsp?point="+results[0].geometry.location.toUrlValue();
					<% } else { %>
					var lat = results[0].geometry.location.lat();
					var lng = results[0].geometry.location.lng();
					window.location = "list.jsp?lat="+lat+"&lng="+lng;
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
	<% if(containFrames=="No") { %>	
	<%@ include file="bottom.jsp" %>
<% } %>
	