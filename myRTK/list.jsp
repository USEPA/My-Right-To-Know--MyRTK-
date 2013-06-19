<%--
    Document   : facilitylist
    Created on : Nov 5, 2009, 4:34:31 PM
    Author     : MaierA
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.Context,
	javax.naming.InitialContext,
	java.lang.Boolean,java.sql.*,
	java.lang.Object,java.io.*,
	java.net.URLEncoder,
	java.lang.StringBuilder,
	java.util.*,
	java.util.Date,
	java.text.SimpleDateFormat,
	java.text.DecimalFormat,java.math.*,java.lang.*,
	java.util.HashMap ,java.net.*,org.apache.http.client.* ,org.apache.http.*, net.sf.json.*,org.apache.commons.io.* "%>

<%@ include file="langpage.jsp" %>
	
<% 	
String containFramesHeader ="";
String Url = request.getRequestURL().toString();
if(request.getParameter("containFrame") !=null)
{
  containFramesHeader = request.getParameter("containFrame");
}
String containFrames="No";
if(containFramesHeader.indexOf("containFrames") != -1)
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
	String nav = "";
	String title = "";
	if(DS1) { nav = "navigation"; } else { nav="portalMenu-tabs"; }

	String status = "blank";

	String swlat = request.getParameter("swlat");
	String swlng = request.getParameter("swlng");
	String nelat = request.getParameter("nelat");
	String nelng = request.getParameter("nelng");
	String plat = request.getParameter("lat");
	String plng = request.getParameter("lng");
	if (swlat != null) {
		session.setAttribute("swlat", swlat);
		session.setAttribute("swlng", swlng);
		session.setAttribute("nelat", nelat);
		session.setAttribute("nelng", nelng);
		status = "set:"+swlat;
	} else {
		swlat =  (String)session.getAttribute("swlat");
		swlng =  (String)session.getAttribute("swlng");
		nelat =  (String)session.getAttribute("nelat");
		nelng =  (String)session.getAttribute("nelng");
		status = "get:"+swlat;
	}
	
	String bug = "none";
	int RScnt = 0;

	StringBuilder sb_outstr = new StringBuilder();

	try {
		java.util.Properties property = null;
		ServletContext context = getServletContext();
		
		InputStream inputStream =context.getResourceAsStream("/WEB-INF/AppProperties.property");
                     
		
		property =new Properties();
		property.load(inputStream );
		
		String sql1 = property.getProperty("LIST_SQL1"); 
		String sql2 = property.getProperty("LIST_SQL2");
		
		
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:/comp/env");
		//////////////////////////////////////////////////////////////////////////////////
		
			String sql = null;
			//PreparedStatement stmt = null;
			String latmiddle = "";
			String lngmiddle = "";
			if ( (swlat == null)||(plat!=null) ) {
				bug = "alpha branch";
				if (plat==null) {
					// plat = "47.5447569439023";
					// plng = "-122.34254837036134";
				}
				latmiddle =  Double.toString( Double.parseDouble(plat) );
				lngmiddle =  Double.toString( Double.parseDouble(plng) );
				Cookie cookie = new Cookie ("center", latmiddle +"%2C"+ lngmiddle);
				response.addCookie(cookie);
				
				boolean hasZoom = false;
				Cookie cookies [] = request.getCookies ();
				if (cookies != null) {
					for (int i=0;i<cookies.length;i++) {
						if (cookies[i].getName().equals("centerlevel")) {
							hasZoom = true;
						}
					}
				}
				if(hasZoom != true) {
					Cookie cookieb = new Cookie ("centerlevel", "13");
					response.addCookie(cookieb);
				}
							
				bug = "alpha branch 1";
				Double xplat = Double.parseDouble(plat);
				Double xplng = Double.parseDouble(plng);

				bug = "alpha branch 2";
				double deltalat   = 0.021850728332065 * 2;
				double deltalng = 0.0274658203125 * 2;

				bug = "alpha branch 3";
				swlat = Double.toString(xplat - deltalat);
				swlng = Double.toString(xplng - deltalng);
				nelat = Double.toString(xplat + deltalat);
				nelng = Double.toString(xplng + deltalng);
				


				bug = "alpha branch 4";
		
				sql = sql1;
				

				bug = "alpha branch 5";
				
				sql = sql+"DEM_LRTLAT/>=/"+swlat+"/"+"DEM_LRTLONG/>=/"+swlng+"/DEM_LRTLAT/<=/"+nelat+"/"+"DEM_LRTLONG/<=/"+nelng+"/JSON";
				
			} else {
				bug = "beta branch";
				
				//prevent sql injection via conversion, due bug in parameters preparation, expand window
				double deltalat   = Double.parseDouble(nelat) - Double.parseDouble(swlat);
				double deltalng = Double.parseDouble(nelng) - Double.parseDouble(swlng);

	   deltalat = deltalat / 12;
	   deltalng = deltalng / 12;

				latmiddle =  Double.toString( (Double.parseDouble(swlat)+Double.parseDouble(nelat))/2 );
				 lngmiddle =  Double.toString( (Double.parseDouble(swlng)+Double.parseDouble(nelng))/2 );

				swlat = Double.toString(Double.parseDouble(swlat) - deltalat);
				swlng = Double.toString(Double.parseDouble(swlng) - deltalng);
				nelat = Double.toString(Double.parseDouble(nelat) + deltalat);
				nelng = Double.toString(Double.parseDouble(nelng) + deltalng);
				
		
				sql = sql2;
				 sql = sql+"DEM_LRTLAT/>=/"+swlat+"/"+"DEM_LRTLONG/>=/"+swlng+"/DEM_LRTLAT/<=/"+nelat+"/"+"DEM_LRTLONG/<=/"+nelng+"/JSON";
			  

			}
			
                       String uri = sql;
			System.out.println(uri);
             		URL url = new URL(uri);
					HttpURLConnection connection =
    				(HttpURLConnection) url.openConnection();
					connection.setRequestMethod("GET");
					connection.setRequestProperty("Accept", "application/json");
		
						InputStream is = connection.getInputStream();
						String jsonTxt = IOUtils.toString( is );
        
      			  		JSONArray json = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
						connection.disconnect();
					
			for(int i = 0;i<json.size();i++)
			{   
				System.out.println("fac="+i);
					JSONObject rs = json.getJSONObject(i);
				String strtriid = "";
				String strfrs = "";
				String strsector = "";
				String strname = "";
				String straddress = "";
				String strcity = "";
				String strstate = "";
				String strzip = "";
				String strlat = "";
				String strlong = "";
				String stristri = "";
				String strdistance = "";
				String strtotalrelease = "";
				

				if ( rs.getString("TRIID")!=null) {
				 strtriid = java.net.URLEncoder.encode(rs.getString("TRIID"));
				}
				if ( rs.getString("FRS")!=null) {
				 strfrs = java.net.URLEncoder.encode(rs.getString("FRS"));
				}
				if ( rs.getString("TEXTSECTOR")!=null) {
					strsector = java.net.URLEncoder.encode(rs.getString("TEXTSECTOR"));
				}
				if ( rs.getString("NAME")!=null) {
					strname = rs.getString("NAME");
					strname = strname.replace("<", "&lt;").replace("&", "&amp;");
				}
				
				if ( rs.getString("ADDR")!=null) {
					straddress = java.net.URLEncoder.encode(rs.getString("ADDR"));
				}
				if ( rs.getString("CITY")!=null) {
				 strcity = java.net.URLEncoder.encode(rs.getString("CITY"));
				}
				if ( rs.getString("STATE")!=null) {
				 strstate = java.net.URLEncoder.encode(rs.getString("STATE"));
				}
				if ( rs.getString("ZIP")!=null) {
				 strzip = java.net.URLEncoder.encode(rs.getString("ZIP"));
				}
				if ( rs.getString("DEM_LRTLAT")!=null) {
				 strlat = rs.getString("DEM_LRTLAT");
				}
				if ( rs.getString("DEM_LRTLONG")!=null) {
				 strlong = rs.getString("DEM_LRTLONG");
				}
				if ( rs.getString("ISTRI")!=null) {
				 stristri = rs.getString("ISTRI");
				}
				if ( rs.getString("TOTALRELEASE")!=null) 
				{
					String totrel=rs.getString("TOTALRELEASE") ;
					if (totrel.trim().length() <=0)
					{
						totrel="0";
					}
					if(totrel=="null" )
					{
						totrel="0";
					}
					System.out.println("in list4="+totrel);	
					double amount_release = Double.parseDouble(totrel);
		
					if ( amount_release<1 ) {
						DecimalFormat df = new DecimalFormat("#.###");
						strtotalrelease =  df.format(amount_release);
								} 
					else {
						DecimalFormat df = new DecimalFormat("#");
						strtotalrelease =  df.format(amount_release);
						}	
				}
				BigDecimal ENTF = new BigDecimal(1);
				Double stbglat = new Double(strlat);
				Double num1 = new Double(3.14159265/180);
				Double testdbl = stbglat*num1;
				Double testdbl2 = new Double(latmiddle)*num1;
				Float fllatmiddle = new Float(latmiddle);
				BigDecimal bgtemp = new BigDecimal(1);
				
				Double sinlatdbl = Math.sin(((stbglat*num1)-(fllatmiddle*num1))*0.5);
				Double sqrtval = Math.sqrt((Math.pow(sinlatdbl,2))+Math.cos((testdbl2))*Math.cos(testdbl));
				Double powval = Math.pow(Math.sin(((new Float(strlong)*num1)-(new Float(lngmiddle)*num1))*0.5),2);
				 
					// stbglat =  1.multiply(stbglat);
				
				//calculate ENTFERNUNG.
				//6366707.444*2*
				//if ( bug.equalsIgnoreCase("alpha branch 5"))
				
				   BigDecimal bd1 = new BigDecimal(6366707.444*2);
					BigDecimal bd2 = new BigDecimal(Math.asin(sqrtval*powval));
					BigDecimal bd3 = new BigDecimal(1000*0.621371);
					 
					  System.out.println("bd1="+bd1); System.out.println("bd2="+bd2);
					   System.out.println("bd3="+bd3);
					ENTF = bd1.multiply(bd2);
					Integer tempi1 = Integer.valueOf(ENTF.intValue());
					Integer tempi2 = Integer.valueOf(bd3.intValue());
					
					//ENTF = ENTF.divide(bd3);
					System.out.println("entf="+ENTF);
					
					//ENTF = 6366707.444*2*Math.asin(SQRT((Math.pow(Math.sin(((stbglat*3.14159265/180)-(new Float(latmiddle)*3.14159265/180))*0.5),2))+Math.cos((latmiddle*3.14159265/180))*Math.cos(stbglat*3.14159265/180))*Math.pow(Math.sin(((new Float(strlong)*3.14159265/180)-(new Float(lngmiddle)*3.14159265/180))*0.5),2)))/1000*0.621371 ;
				
				
				if ( ENTF != null) 
				{
					
					Integer dist = tempi1/tempi2 ;
				 strdistance = Double.toString( dist );
				}

				if ( stristri.equalsIgnoreCase("yes") ) {
					if(DS1) {
						 if(containFrames=="No") { 
							sb_outstr.append("<li onclick=\"location.href=\'report.jsp?IDT=TRI&amp;ID="+strtriid+"\'\">\n");
						} else { 
							sb_outstr.append("<li onclick=\"location.href=\'report.jsp?containFrame=containFrames&IDT=TRI&amp;ID="+strtriid+"\'\">\n");
						 } 
					} else {
						sb_outstr.append("<li>\n");
					}
					sb_outstr.append("<ul>\n");
					if(DS1) {
						//sb_outstr.append("<li><u><img height=\"15\" src=\"http://labs.google.com/ridefinder/images/mm_20_blue.png\" alt=\"TRI Facility\">&nbsp;"+strname+"</u></li>\n");
						sb_outstr.append("<li><u><img height=\"15\" src=\"images/blue.png\" alt=\"TRI Facility\">&nbsp;"+strname+"</u></li>\n");
					} else {
						 if(containFrames=="No") { 	
						sb_outstr.append("<li><u><a href=\"report.jsp?IDT=TRI&amp;ID="+strtriid+" \"><img height=\"15\" src=\"images/blue.png\" alt=\"TRI Facility\">&nbsp;"+strname+"</a></u></li>\n");
						} else { 
						sb_outstr.append("<li><u><a href=\"report.jsp?containFrame=containFrames&IDT=TRI&amp;ID="+strtriid+" \"><img height=\"15\" src=\"images/blue.png\" alt=\"TRI Facility\">&nbsp;"+strname+"</a></u></li>\n");
						 } 

					}
					sb_outstr.append("<li>"+strdistance+" "+ miles+"</li>\n");
					sb_outstr.append("<li> "+pounds+": "+strtotalrelease+"</li>\n");
					sb_outstr.append("</ul>\n");
					sb_outstr.append("</li>\n");

				} else {
					if(DS1) {
						 if(containFrames=="No") { 	
								sb_outstr.append("<li onclick=\"location.href=\'report.jsp?IDT=FRS&amp;ID="+strfrs+"\'\">\n");
							} else {
								sb_outstr.append("<li onclick=\"location.href=\'report.jsp?containFrame=containFrames&IDT=FRS&amp;ID="+strfrs+"\'\">\n");
						}
					} else {
						sb_outstr.append("<li>\n");
					}
					sb_outstr.append("<ul>\n");
					if(DS1) {
						sb_outstr.append("<li><u><img height=\"15\" src=\"images/gray.png\" alt=\"Non-TRI Facility\">&nbsp;"+strname+"</u></li>\n");
					} else {
						 if(containFrames=="No") { 
							sb_outstr.append("<li><u><a href=\"report.jsp?IDT=FRS&amp;ID="+strfrs+" \"><img height=\"15\" src=\"images/gray.png\" alt=\"FRS Facility\">&nbsp;"+strname+"</a></u></li>\n");
						} else {
							sb_outstr.append("<li><u><a href=\"report.jsp?containFrame=containFrames&IDT=FRS&amp;ID="+strfrs+" \"><img height=\"15\" src=\"images/gray.png\" alt=\"FRS Facility\">&nbsp;"+strname+"</a></u></li>\n");
						}
					}
					sb_outstr.append("<li>"+strdistance+" "+miles+" </li>\n");
					sb_outstr.append("</ul>\n");
					sb_outstr.append("</li>\n");
				}

				RScnt++;
			}
			if ( RScnt==0) {
	sb_outstr.append("<li><a href=\"#\">");
	sb_outstr.append("<h2>0 "+ facs + " </h2></a></li>");
			}


			//rs.close();
			//conn.close();
		//}

	} catch (Exception ex) {
		String ermsg = "    Error: " + bug +ex.getLocalizedMessage() + " - " + ex.getMessage();
		out.println("Error"+ermsg);  // outputs oracle messages REMOVE ON FINAL
		log("    Error: " + ex.getLocalizedMessage() + "<br> " + ex.getMessage());
	}
	if(DS1 || DS2) {
		title = listof+" "+Integer.toString(RScnt)+" "+faconmap;
	} else if (DS3 || DS4) {
		title = listof+" "+Integer.toString(RScnt)+" "+facs;
	}
		//title="abc";


%>


<%@ include file="top.jsp" %>
	
	<!--<title>myRTK - <%=listpage%></title>-->
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
	
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>
	<script type="text/javascript" src="js/gears_init.js"></script>
	<script type="text/javascript" src="js/geolocate.js"></script>
	<script type="text/javascript" src="js/ajax.js"></script>
<!-- InstanceEndEditable -->
<!-- InstanceParam name="bodyClass" type="text" value="apps" -->


</head>

<body class="apps"  <% if(DS3 || DS4) { %> onload="initialize()"<% } %> >
	<% if(containFrames=="No") { %>	
<%@ include file="justbanner.jsp" %>
<%} %>

	<% if( DS2) { %>
	<div id="content">
	<% } %>
	
	
		<% String srchtab="" ;
		String listtab="" ;
		String maptab="" ;
		String infotab="" ;
		String info2tab="" ;
		%>
		<% if( DS2) { %>
        	<%  srchtab="" ;
		 listtab="style=\"background: url(images/tab-right-current.gif)\"" ;
		 maptab="" ;
		 infotab="" ;
		info2tab="" ;
		%>
		<% } %>
		<% if( DS1||DS3) {  %>
		<% srchtab="" ;
		listtab="class=\"active\"" ;
		maptab="" ;
		infotab="" ;
		info2tab="" ;
		%>
		<% } %>
			<% if(containFrames=="No") { %>	
                <%@ include file="toplinks.jsp" %>
                
		 <%}else { %>
		<%@ include file="toplinks-F.jsp" %>
		<%} %>
	
		<% if( DS1||DS3) { %>
		<div id="content">
		<% } %>
	
		<b><%=title%></b>
		<ul id="retrlist">
		<%
			out.println( sb_outstr.toString() );
		%>
		</ul>
	</div>
	<% if(containFrames=="No") { %>	
	   <%@ include file="abovefooter.jsp" %>
		<div id="footer">
  			<p><a id="feedback_menu" href="http://m.epa.gov/privacy.html">Privacy</a><span class="key">[+]</span><a id="contact_menu" href="http://m.epa.gov/contact/index.html" accesskey="+">Contact</a><span class="key">[#]</span><a href="http://www.epa.gov/?m_rd=false" accesskey="#" title="EPA.gov Full Site">EPA.Gov</a><a id="desktop" href="http://www.epa.gov/?m_rd=false">Full site</a></p>
		</div>
		<%} %>

	<script type="text/javascript">
	<% if(DS3 || DS4) { %>
		var geocoder;
		
		var queryString = window.top.location.search.substring(1);
		var paramLat = "lat=";
		var paramLng = "lng=";
		if(queryString.length > 0) {
			var beginLat = queryString.indexOf(paramLat);
			var beginLng = queryString.indexOf(paramLng);
			if(beginLat != -1) {
				beginLat += paramLat.length;
				var endLat = queryString.indexOf("&", beginLat);
				if(endLat == -1) {
					endLat = queryString.length;
				}
				var latVal = queryString.substring(beginLat, endLat);
			}
			if(beginLng != -1) {
				beginLng += paramLng.length;
				var endLng = queryString.indexOf("&", beginLng);
				if(endLng == -1) {
					endLng = queryString.length;
				}
				var lngVal = queryString.substring(beginLng, endLng);
			}
		}

		function initialize() {
			geocoder = new google.maps.Geocoder();
			var latlng = new google.maps.LatLng(latVal, lngVal);
			if (geocoder) {
				geocoder.geocode({'latLng': latlng}, function(results, status) {
					if (status == google.maps.GeocoderStatus.OK) {
						if (results[1]) {
							var returnedGeo = " near "+results[1].formatted_address;
							returnedGeo = returnedGeo.replace(", USA", "");
							//var returnedGeo = results[0].address_components[0].short_name +" "+results[0].address_components[1].short_name+", "+results[0].address_components[2].short_name+", "+results[0].address_components[5].short_name;
							var titleStr = document.getElementById('title').innerHTML;
							document.getElementById('title').innerHTML = titleStr+" "+returnedGeo;
						} else {
						alert("No results found");
						}
					} else {
					alert("Geocoder failed due to: " + status);
					}
				});
			}
		}
	<% } %>
		window.scrollTo(80, 0);
	</script>
	<% if(containFrames=="No") { %>	
	<%@ include file="bottom.jsp" %>
	<%} %>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           