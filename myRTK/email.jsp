
<%--
	Document   : email
	Created on : Aug 13, 2010, 3:43:37 PM
	Author     : mm
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
	java.util.HashMap,
	javax.mail.*,javax.mail.internet.*" %>
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
	String title =commsucc;
	String nav = "";
	if(DS1) { nav = "navigation"; } else { nav="portalMenu-tabs"; }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta name="DC.description" content="myRTK is an EPA website designed for mobile devices. For any address, the map displays nearby facilities regulated under federal environmental laws. Facility reports provide summaries of chemical/pollutant releases, chemical effects, and compliance history from numerous data systems." />

	<meta name="keywords" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />

	<meta name="DC.Subject" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />
	
	<title>myRTK - Feedback</title>
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
	<script type="text/javascript" src="js/geolocate.js"> </script>

<%
      try{
		java.util.Properties property = null;
		ServletContext context = getServletContext();

		InputStream inputStream =context.getResourceAsStream("/WEB-INF/AppProperties.property");
                       
		
		property =new Properties();
		property.load(inputStream );
		
		String mailhost = property.getProperty("mailhost"); 
		String mailreceip = property.getProperty("mailreceip"); 

		String  messageText =  "Name: "+ request.getParameter("Name") + " Phone: "+ request.getParameter("Phone")+" Comments: "+ request.getParameter("comments3");

           String subject = "MyRTK Feedback";
         
           //Get system properties
           Properties props = System.getProperties();

           //Setup mail server
           props.put("mail.smtp.host", mailhost);
 
           // Get session
           Session sesion = Session.getDefaultInstance(props, null);

           // Define message
          MimeMessage message = new MimeMessage(sesion);

          message.setFrom(new InternetAddress( request.getParameter("email")));
          message.addRecipient(Message.RecipientType.TO,
                                             new InternetAddress(mailreceip));
          message.setSubject(subject);
          message.setText(messageText);
       
          // Send message
         Transport.send(message);
	}catch(Exception e)
	{
		title =e.getMessage();
	}
	%>
</head>

<body >
   
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
			
	</div>

<%@ include file="foot.jsp" %>

		
</body>
</html>