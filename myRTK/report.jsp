<%--
    Document   : report
    Created on : Apr 23, 2010, 9:33:37 AM
    Author     : MaierA
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.Context,
	javax.naming.InitialContext,
	java.lang.Boolean,java.sql.*,
	java.lang.Object,java.io.*,
	java.net.URLEncoder,
	java.util.Date,
	java.text.SimpleDateFormat,
	java.text.DecimalFormat,
	java.util.HashMap ,java.net.*,org.apache.http.client.* ,org.apache.http.*, net.sf.json.*,org.apache.commons.io.* , java.util.*" %>
<%@ include file="langpage.jsp" %>


<%
String containFramesHeader ="";
StringBuffer Urlb = request.getRequestURL();
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
	String title = facilityreport;
	String nav = "";
	if(DS1) { nav = "navigation"; } else { nav="portalMenu-tabs"; }

	
	

	try {
		java.util.Properties property = null;
		ServletContext context = getServletContext();

		InputStream inputStream =context.getResourceAsStream("/WEB-INF/AppProperties.property");
                       
		
		property =new Properties();
		property.load(inputStream );
		String repsql1= property.getProperty("repsql1"); 
		String repsql2= property.getProperty("repsql2"); 
		String repsql3= property.getProperty("repsql3"); 
		String repsql4= property.getProperty("repsql4"); 
		String repsql5= property.getProperty("repsql5"); 
		String repsql6= property.getProperty("repsql6"); 
		String repsql7= property.getProperty("repsql7"); 
		String repsql8= property.getProperty("repsql8"); 
		String repsql9= property.getProperty("repsql9"); 
		Context initContext = new InitialContext();
		

		boolean isTRI = false;
		String FRSID = "";
		String TRIID = "";

		String addressLine = "";
          
		//String ID = request.getParameter("ID").replaceAll("\\W", "");
		String ID = request.getParameter("ID");

		if ( request.getParameter("IDT").equalsIgnoreCase("TRI") ) {
			isTRI = true;
			TRIID = ID;
		} else {
			FRSID = ID;
		}

		String facilityName = "";
		String Industry = "Industry Category missing";
		String relAir = "0";
		String relWater = "0";
		String relLand = "0";
		Double airRel = 0.0;
		Double waterRel = 0.0;
		Double landRel = 0.0;

		String contextPctCntyRel = "";
		String contextCounty = "";
		int contextOthers = 0;
		String contextRank = "";
		String contextTotal = "";

		String[] releasesChemicals;

		String[] quarters = new String[12];
		String p_caa = "";
		String p_cwa = "";
		String p_rcra = "";
		String p_tri = "";
		int last_inspection = 0;
		String last_inspection_str = "";
		String num_enforcement_actions = "";

		String nonTRIline = "";

		int percentage = 0;
		String uri ="";
		URL url =null;
		HttpURLConnection connection =null;
		String jsonTxt = "";
		JSONArray json = null, jsonch=null;
		JSONObject rs = null;
		JSONObject chemicalresults = null;
		int i = 0;
		//String glyph = "http://labs.google.com/ridefinder/images/mm_20_blue.png";
		String glyph = "images/blue.png";

		if ( !isTRI) {
			FRSID = ID;
			//glyph = "http://labs.google.com/ridefinder/images/mm_20_gray.png";
			glyph = "images/gray.png";
		};
		if (true){
			
			String sql = null;
			
			if ( isTRI ) { //get FRSID if TRI case
				
				sql = repsql1 ;
				sql = sql + TRIID +"/DBAS/TRI/JSON";
				 	uri = sql;
					System.out.println(uri);
             		url = new URL(uri);
					connection =
    				(HttpURLConnection) url.openConnection();
					connection.setRequestMethod("GET");
					connection.setRequestProperty("Accept", "application/json");
		
						InputStream is1 = connection.getInputStream();
						jsonTxt = IOUtils.toString( is1 );
        
      			  		json = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
						connection.disconnect();
					
					
			
					rs = json.getJSONObject(i);
					FRSID = rs.getString("FRS");
					
				
			}

			if ( isTRI ) {
				
					sql = repsql2 ;
					sql = sql + TRIID +"/JSON";
					uri = sql;
					System.out.println(uri);
             				url = new URL(uri);
					connection =
    					(HttpURLConnection) url.openConnection();
					connection.setRequestMethod("GET");
					connection.setRequestProperty("Accept", "application/json");
		
					InputStream is2 = connection.getInputStream();
					jsonTxt = IOUtils.toString( is2 );
        				json = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
					connection.disconnect();
					rs = json.getJSONObject(i);
					
					for(int h = 0;h<json.size();h++)
					{
						rs = json.getJSONObject(h);
						facilityName = rs.getString("NAME");
						Industry = rs.getString("INDUSTRY");
						if (Industry.indexOf(" ")>-1)
					 	{
							Industry = Industry.substring(Industry.indexOf(" ")+1, Industry.length());
							if ( !Industry.isEmpty() ) {
								Industry = industry1+": "+ Industry;
							} else {
								Industry = industry1+": -";
							}
						}
				
						relAir =  rs.getString("REL_AIR") ;
						relWater =  rs.getString("REL_WATER") ;
						relLand =  rs.getString("REL_LAND") ;
				


						percentage = (int)(Double.parseDouble(rs.getString("PCT_CNTY_REL")) * 100);
					
						double pctflt = Double.parseDouble(rs.getString("PCT_CNTY_REL")) * 100;
					
						if (percentage >= 1) 
						{
							contextPctCntyRel = "" + Integer.toString(percentage);

							DecimalFormat df = new DecimalFormat("#");
						
							relAir =  df.format(Double.parseDouble(rs.getString("REL_AIR")));
							relWater =  df.format(Double.parseDouble(rs.getString("REL_WATER")));
							relLand =  df.format(Double.parseDouble(rs.getString("REL_LAND")));
						
						} 
						else {
							if  (percentage==0) { percentage=1; }
							contextPctCntyRel = lthan + " " + Integer.toString(percentage);

							DecimalFormat df = new DecimalFormat("#.###");
							relAir =  df.format(Double.parseDouble(rs.getString("REL_AIR")));
							relWater =  df.format(Double.parseDouble(rs.getString("REL_WATER")));
							relLand =  df.format(Double.parseDouble(rs.getString("REL_LAND")));
						}
						
						if(rs.getString("COUNTYNAME")!= null && rs.getString("COUNTYNAME").trim().length()> 0)
						{
							contextCounty = rs.getString("COUNTYNAME") + " "+county +" , "+ rs.getString("STATEABBR");
						}
						else
						{
							contextCounty =  rs.getString("STATEABBR");
						}
						contextOthers = Math.max(0, Integer.parseInt(rs.getString("CNTY_FACS")));
						contextRank = rs.getString("INDUSTRY_RANK");
						contextTotal = rs.getString("INDUSTRY_CNT");
					}
				
				} else {
				
					sql = repsql3 ;
					sql = sql + FRSID+"/JSON";
					uri = sql;
					System.out.println(uri);
             				url = new URL(uri);
					connection =
    					(HttpURLConnection) url.openConnection();
					connection.setRequestMethod("GET");
					connection.setRequestProperty("Accept", "application/json");
					InputStream is3 = connection.getInputStream();
					jsonTxt = IOUtils.toString( is3 );
        				json = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
					connection.disconnect();
					
					rs = json.getJSONObject(i);
					
					facilityName = rs.getString("FRS_VNAME");
					Industry = "";
					
					}

			if ( isTRI ) {
					sql = repsql4;
					sql = sql + TRIID+"/JSON";
					uri = sql;
					System.out.println(uri);
             				url = new URL(uri);
					connection =
    					(HttpURLConnection) url.openConnection();
					connection.setRequestMethod("GET");
					connection.setRequestProperty("Accept", "application/json");
					InputStream is4 = connection.getInputStream();
					jsonTxt = IOUtils.toString( is4 );
        				jsonch = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
					connection.disconnect();
					
					chemicalresults = json.getJSONObject(i);
				
					}

			if ( isTRI ) {
					sql = repsql5;
					sql = sql+TRIID+"/JSON";
					uri = sql;
					System.out.println(uri);
             				url = new URL(uri);
					connection =
    					(HttpURLConnection) url.openConnection();
					connection.setRequestMethod("GET");
					connection.setRequestProperty("Accept", "application/json");
					InputStream is5 = connection.getInputStream();
					jsonTxt = IOUtils.toString( is5 );
        				json = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
					connection.disconnect();
					
					rs = json.getJSONObject(i);
				
					addressLine = rs.getString("ADDR") + ", " + rs.getString("CITY") + ", " + rs.getString("STATE") + " " + rs.getString("ZIP");
				
					} 
			else {
					sql = repsql6;
					sql = sql + FRSID+"/JSON";
					uri = sql;
					System.out.println(uri);
             				url = new URL(uri);
					connection =
    					(HttpURLConnection) url.openConnection();
					connection.setRequestMethod("GET");
					connection.setRequestProperty("Accept", "application/json");
					InputStream is6 = connection.getInputStream();
					jsonTxt = IOUtils.toString( is6 );
        				json = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
					connection.disconnect();
					
					rs = json.getJSONObject(i);
				
					addressLine = rs.getString("ADDR") + ", " + rs.getString("CITY") + ", " + rs.getString("STATE") + " " + rs.getString("ZIP");
				
				}

			// default unknown
			for (int j = 0; j < 12; j++) {
				quarters[j] = "-1";
			}

			if ( isTRI ) {
					sql = repsql7;
					sql = sql + FRSID+"/JSON";
					uri = sql;
					System.out.println(uri);
             				url = new URL(uri);
					connection =
    					(HttpURLConnection) url.openConnection();
					connection.setRequestMethod("GET");
					connection.setRequestProperty("Accept", "application/json");
					InputStream is7 = connection.getInputStream();
					jsonTxt = IOUtils.toString( is7 );
        				json = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
					connection.disconnect();
					
					rs = json.getJSONObject(i);
					
					last_inspection_str = noinfo;
					num_enforcement_actions = noinfo;
				
					for (int j = 0; j < 12; j++) {
						quarters[j] = rs.getString("QTR" + Integer.toString(1 + i));
					}
					p_caa = rs.getString("CAA");
					p_cwa = rs.getString("CWA");
					p_rcra = rs.getString("RCR");
					p_tri = "";
					if (p_caa.equalsIgnoreCase("1")) {
						p_caa = "<img src=\"images/check.gif\" alt=\"Check\">";
					} else {
						p_caa = "";
					}
					if (p_cwa.equalsIgnoreCase("1")) {
						p_cwa = "<img src=\"images/check.gif\" alt=\"Check\">";
					} else {
						p_cwa = "";
					}
					if (p_rcra.equalsIgnoreCase("1")) {
						p_rcra = "<img src=\"images/check.gif\" alt=\"Check\">";
					} else {
						p_rcra = "";
					}
					if (rs.getString("INSPDAY_MIN") == null) {
						last_inspection_str = noinfo;
					} else {
						last_inspection_str = rs.getString("INSPDAY_MIN") + " "+daysago;
					}
					if (rs.getString("ACTNS_5YR") == null) {
						num_enforcement_actions = noinfo;
					} else {
						num_enforcement_actions = rs.getString("ACTNS_5YR");
					}
				
				} else {
					sql = repsql8;
					sql=sql+FRSID+"/JSON";
					uri = sql;
					System.out.println(uri);
             				url = new URL(uri);
					connection =
    					(HttpURLConnection) url.openConnection();
					connection.setRequestMethod("GET");
					connection.setRequestProperty("Accept", "application/json");
					InputStream is8 = connection.getInputStream();
					jsonTxt = IOUtils.toString( is8 );
        				json = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
					connection.disconnect();
					
					rs = json.getJSONObject(i);
					
					last_inspection_str = noinfo;
					num_enforcement_actions = noinfo;
					
					for (int j = 0; j < 12; j++) {
						quarters[j] = rs.getString("QTR" + Integer.toString(1 + i));
					}
					p_caa = rs.getString("CAA");
					p_cwa = rs.getString("CWA");
					p_rcra = rs.getString("RCR");
					p_tri = "";
					if (p_caa.equalsIgnoreCase("1")) {
						p_caa = "<img src=\"images/check.gif\" alt=\"Check\">";
					} else {
						p_caa = "";
					}
					if (p_cwa.equalsIgnoreCase("1")) {
						p_cwa = "<img src=\"images/check.gif\" alt=\"Check\">";
					} else {
						p_cwa = "";
					}
					if (p_rcra.equalsIgnoreCase("1")) {
						p_rcra = "<img src=\"images/check.gif\" alt=\"Check\">";
					} else {
						p_rcra = "";
					}
					if (rs.getString("INSPDAY_MIN") == null) {
						last_inspection_str = noinfo;
					} else {
						last_inspection_str = rs.getString("INSPDAY_MIN") + " " +daysago;
					}
					if (rs.getString("ACTNS_5YR") == null) {
						num_enforcement_actions = noinfo;
					} else {
						num_enforcement_actions = rs.getString("ACTNS_5YR");
					}
					//build line for context statement
					if (  p_caa.isEmpty() && p_cwa.isEmpty() && p_rcra.isEmpty() ){
						nonTRIline = facnotri;
					} else {
						//nonTRIline = "This facility does not report to the Toxics Release Inventory, but";
						nonTRIline = " ";

					}
				
				}
				String labelAir = "Air";
				String labelWater = "Water";
				String labelLand = "Land";
				airRel = airRel.valueOf(relAir);
				waterRel = waterRel.valueOf(relWater);
				landRel = landRel.valueOf(relLand);
				
				Double pctAir = 0.0;
				Double pctWater = 0.0;
				Double pctLand = 0.0;
				
				Double totRel = airRel + waterRel + landRel;
				if(totRel.equals(0.0)) {
				} else {
					pctAir = (airRel / totRel) * 100;
					pctWater = (waterRel / totRel) * 100;
					pctLand = (landRel / totRel) * 100;
					
					DecimalFormat fourDForm = new DecimalFormat("#.####");
					pctAir = pctAir.valueOf(fourDForm.format(pctAir));
					pctWater = pctWater.valueOf(fourDForm.format(pctWater));
					pctLand = pctLand.valueOf(fourDForm.format(pctLand));
				}
				if(relAir.equals("0")) {
					labelAir = "";
				}
				if(relWater.equals("0")) {
					labelWater = "";
				}
				if(relLand.equals("0")) {
					labelLand = "";
				}
				String chartSrc = "";
				if(relAir.equals("0") && relWater.equals("0") && relLand.equals("0")) {
					chartSrc = "http://chart.apis.google.com/chart?cht=p&chco=898a8b&chs=250x150&chd=t:10,0,0";
				} else {
					chartSrc = "http://chart.apis.google.com/chart?cht=p&chco=ced17b|7ba7d1|C66363&chs=250x150&chd=t:"+pctAir+","+pctWater+","+pctLand+"&chl="+labelAir+"|"+labelWater+"|"+labelLand+"&chds=0,100";
				}
			%>
<%@ include file="top.jsp" %>
	<!-- <meta name="DC.description" content="myRTK is an EPA website designed for mobile devices. For any address, the map displays nearby facilities regulated under federal environmental laws. Facility reports provide summaries of chemical/pollutant releases, chemical effects, and compliance history from numerous data systems." />

	<meta name="keywords" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />

	<meta name="DC.Subject" content="myRTK, TRI, Toxics Release Inventory, Community Right to Know, EPA mobile web, toxic releases, chemical releases, chemical health effects,  enforcement, compliance, compliance history, violations, detailed facility report, inspections, environmental performance" />
	
	<title>myRTK - Facility Report</title>
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
	<script type="text/javascript" src="js/geolocate.js"></script>
	
	<script type="text/javascript" src="js/ajax.js"></script>
<!-- InstanceEndEditable -->
<!-- InstanceParam name="bodyClass" type="text" value="apps" -->


</head>
<% if(containFrames=="No") { %>	
<body class="apps">

<%@ include file="justbanner.jsp" %>
<%}else{ %>
<body class="appReport">
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
		 listtab="" ;
		 maptab="" ;
		 infotab="i" ;
		info2tab="" ;
	%>
	<% } %>
	<% if( DS1||DS3) {  %>
	<% srchtab="" ;
		listtab="" ;
		maptab="" ;
		infotab="i" ;
		info2tab="" ;
	%>
	<% } %>
	
	
	<% if( DS1||DS3) { %>
	<div id="content">
	<% } %>
		
	
<% if(containFrames=="Yes") { %>	
		<%@ include file="toplinks-F.jsp" %>
		<% } %>
		<font size="+1" style="color:black"><b><%=title.toUpperCase()%></b></font><% if( DS2) { %><br/><% } %>
		<div class="content_report" id="facility">
			<% if( DS2) { %><b><% } %>
			<% if( DS1||DS3) { %><h2><% } %>
			<img src="<%=glyph%>" alt="Facility type">&nbsp;<%=facilityName%><% if( DS2) { %></b><% } %>
			<% if( DS1||DS3) { %></h2><% } %>
			<ul><% if ( isTRI) { %>
			<li><%=triid%> = <%=TRIID%></li>
			<% } %>
			<li><%=addressLine%></li>
			<% if ( isTRI) { %><li><%=Industry%></li><% } %>
			</ul>
		</div>

		
	<div class="content_report" id="context">
			<% if( DS2) { %>
			<h2><font style="color:black"><%=context1.toUpperCase()%></font></h2>
			<% } else{%>
			<h2><font style="color:black"><%=context1.toUpperCase()%></font></h2>
			<%}%>
			<% if ( isTRI) { %>
				<% if( DS2) { %><b><% } %>
				<% if( DS1||DS3) { %><h2><% } %>
				<%=county%>
				<% if( DS2) { %></b><% } %>
				<% if( DS1||DS3) { %></h2><% } %>
				<ul>
					<li><%=contextPctCntyRel%>% <%=trireleases%> <%=contextCounty%></li>
					<li><%=Integer.toString(contextOthers)%> <%=triother%> <%=contextCounty%></li>
				</ul>
				<% if( DS2) { %><b><% } %>
				<% if( DS1||DS3) { %><h2><% } %>
				<%=national%></b><% if( DS2) { %></b><% } %>
				<% if( DS1||DS3) { %></h2><% } %>
				<ul>
					<li><%=ranks%> <%=contextRank%> <%=outof%> <%=contextTotal%> <%=trifacsindustry%>  <%=Industry%> </li>
					<li>(<%=rank1%>)</li>
			<% } else { %>
				<ul>
					<li><%=nonTRIline %></li>
					<li><%=facnotri%></li>
			<% if (  !p_caa.isEmpty()) { %>
					<li><%=faclbs1%></li>
			<% } if (  !p_cwa.isEmpty() ){ %>
					<li><%=factxwat%></li>
			<% } if (  !p_rcra.isEmpty() ){ %>
					<li><%=faclbs2%></li>
			<% } 
			}%>
			</ul>
		</div>


	<% if ( isTRI ) { %>
		<div class="content_report" id="releases">
			<h2><font style="color:black"><%=onsitereltot%></font></h2>
			<img class="fromtable" src="<%=chartSrc%>" alt="Releases">
			<table id="mydata" class="tochart" >
				<thead style="background:#FFFFFF;border:none;">
					<tr style="background:#FFFFFF;border:none;">
						<th style="background:#FFFFFF;border:none;"><%=source%></th><th style="background:#FFFFFF;borer:none;"><%=pounds%></th>
					</tr>
				</thead>
				<tbody >
					<tr >
						<td style="background: #ced17b;"><%=air%></td>
						<td style="background: #ced17b;"><%=relAir%></td>
					</tr>
					<tr style="background: #7ba7d1;">
						<td><%=water%></td>
						<td><%=relWater%></td>
					</tr>
					<tr style="background: #C66363;">
						<td><%=land%></td>
						<td><%=relLand%></td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="content_report" id="chemicals">
			<h2><font style="color:black"><%=onsiterelchem%></font></h2>
			<table   id="chems" cellspacing="0" cellpadding="2" >
				<thead style="background:#FFFFFF;">
					<tr style="background:#FFFFFF;border:1px;">
						<th style="background:#FFFFFF;border:none;" colspan="3">&nbsp;</th>
						<th style="background:#FFFFFF;border:none;" colspan="2"><%=healtheff%></th>
					</tr>
					
					<tr style="background:#FFFFFF;border:1px;">
						<th style="background:#FFFFFF;border:none;" colspan="2">&nbsp;</th>
						<th style="background:#FFFFFF;border:none;">(<%=pounds%>)</th>
						<th style="background:#FFFFFF;border:none;"><%=cancer%></th>
						<th style="background:#FFFFFF;border:none;"><%=other%></th>
					</tr>
				</thead>
				<tfoot>
					<tr style="background:#FFFFFF;">
						<td colspan="5">
							<ul class="legend">
								<li><img src="images/bar1.png" alt="Air">&nbsp;<%=air%></li>
								<li><img src="images/bar2.png" alt="Water">&nbsp;<%=water%></li>
								<li><img src="images/bar3.png" alt="Waste">&nbsp;<%=waste%></li>
							</ul>
						</td>
					</tr>
				</tfoot>
				<tbody>
					<%
				if (chemicalresults != null) {
					int loopcnt = 0;
					//while (chemicalresults.next())
					for(int h=0;h<jsonch.size();h++)
					 {  //will catch latest in the bunch
					    chemicalresults = jsonch.getJSONObject(h);
						loopcnt++;
						// get details
						int healthEffects = 0;
						String helink = "#";
					     	String CAS2Find = chemicalresults.getString("TRI_CHEM_ID");
						String carcinogencheck = "";
						String healthcheck = "";


						sql=repsql9;
						sql = sql + CAS2Find +"/JSON";
						
						uri = sql;
					System.out.println("here report = "+uri);
             				url = new URL(uri);
					connection =
    					(HttpURLConnection) url.openConnection();
					connection.setRequestMethod("GET");
					connection.setRequestProperty("Accept", "application/json");
					InputStream is9 = connection.getInputStream();
					jsonTxt = IOUtils.toString( is9 );
        				json = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
					connection.disconnect();
					 i = 0;
					 JSONObject  chemicaldetails = json.getJSONObject(i);
					String acancereffect = chemicaldetails.getString("CARCINOGEN");
                                            if (acancereffect.equalsIgnoreCase("YES")) {
                                                carcinogencheck = "<img src=\"images/check.gif\" alt=\"Check\">";
                                            };
                                            String ahealtheffect = chemicaldetails.getString("NON_CARCINOGEN");
                                            if (ahealtheffect.equalsIgnoreCase("YES")) {
                                                healthcheck = "<img src=\"images/check.gif\" alt=\"Check\">";
                                            };
                                            if (chemicaldetails.getString("CAS") != null)
						 {
						 	if(containFrames=="No") 
							{ 
								helink = "chems.jsp?ID="+CAS2Find;
							}
							else
							{
                                               			helink = "chems.jsp?containFrame=containFrames&ID="+CAS2Find;
							}
						}
					int scale = 40;
						int widthAir = 0;
						int widthWater = 0;
						int widthLand = 0;
						double total =0;
						String strelair = chemicalresults.getString("REL_AIR");
						String strelwater = chemicalresults.getString("REL_WATER");
						String strelland = chemicalresults.getString("REL_LAND") ;
						
						if ( strelair != null ){}else{strelair="0";}
						if ( strelwater != null ){}else{strelwater="0";}
						if ( strelland != null ){}else{strelland="0";}
						
						if (strelair.trim().equalsIgnoreCase("null")){strelair="0";}
						if (strelwater.trim().equalsIgnoreCase("null")){strelwater="0";}
						if (strelland.trim().equalsIgnoreCase("null")){strelland="0";}
						
						
						if (chemicalresults.getString("REL_TOTAL") != null &&
						chemicalresults.getString("REL_TOTAL").trim().equalsIgnoreCase("null")!=true )
						  {total = Double.parseDouble(chemicalresults.getString("REL_TOTAL"));}
						else
						{   total =0 ;}
						
						if (total > 0) {
						    
							widthAir = (int) (Double.parseDouble(strelair) / total * scale);
							widthWater = (int) (Double.parseDouble(strelwater) / total * scale);
							widthLand = (int) (Double.parseDouble(strelland) / total * scale);
						}		
                                           
					%>		
										
						<tr class="chemical">
							<% if ( !helink.equalsIgnoreCase("#") ) { %>
								<td class="chemname">
									<a href="<%=helink%>" class="chem_link"><u><%=chemicalresults.getString("CHEMICAL")%></u></a>
								</td>
							<% } else { %>
								<td class="chemname">
									<%=chemicalresults.getString("CHEMICAL")%>
								</td>
							<% } %>
							<td>
								<img class="bar" src="images/bar1.png" width="<%=widthAir%>" alt="Air"><img class="bar" src="images/bar2.png" width="<%=widthWater%>" alt="Water"><img class="bar" src="images/bar3.png" width="<%=widthLand%>" alt="Waste">
							</td>
							<td>
								
								<%=total%>
							</td>
							<td>
								<%=carcinogencheck%>
							</td>
							<td>
								<%=healthcheck%>
							</td>
						</tr> 
					<%  } }%>
				</tbody>
			</table>
		</div>
		<% } %>

		<div class="content_report" id="compliance">
			<h2><font style="color:black"><%=compli%></font></h2>
			<div id="comp_tbls">
				<table style="border:none;" id="permits">
					<tr style="background:#FFFFFF;"><td colspan=3><%=facpermit%></td></tr>
					<tr style="background:#FFFFFF;border:none;">
						<th style="background:#FFFFFF;border:none;"><%=air%></th>
						<th style="background:#FFFFFF;border:none;"><%=water%></th>
						<th style="background:#FFFFFF;border:none;"><%=waste%></th>
					</tr>
					<tr style="background:#FFFFFF;;border:none;">
						<td><%=p_caa%></td>
						<td><%=p_cwa%></td>
						<td><%=p_rcra%></td>
					</tr>
				</table>
			
				<table style="background:#FFFFFF;" id="comp">
					<caption style="background:#FFFFFF;"><%=compstat%>:</caption>
					<tfoot style="background:#FFFFFF;">
						<tr style="background:#FFFFFF;">
							<td colspan="48">
								<ul class="legend">
									<li><img src="images/comp.png" alt="Compliance">&nbsp;<%=compli1%></li>
									<li><img src="images/snoncomp.png" alt="Significant Non-Compliance">&nbsp;<%=signoncompli%></li>
								</ul>
								<ul class="legend">
									<li><img src="images/noncomp.png" alt="Non-Compliance">&nbsp;<%=noncompli1%></li>
									<li><img src="images/unknown.png" alt="Status Unknown/Unavailable">&nbsp;<%=statunk%></li>
								</ul>
							</td>
						</tr>
					</tfoot>
					
						<tbody>
						<tr style="background:#FFFFFF;">
							<%
							for (int j = 0; j < 12; j++) {
								String color = "#898a8b";
								String cur = quarters[i].toString();
								if (quarters[i].toString().equalsIgnoreCase("0")) {
									color = "#8cc781";
								}
								if (quarters[i].toString().equalsIgnoreCase("1")) {
									color = "#ced17b";
								}
								if (quarters[i].toString().equalsIgnoreCase("2")) {
									color = "#C66363";
								}
								%>
								<td colspan=3 style="background:<%=color%>;">&nbsp;</td>
								<td></td>
								<%
							}
							%>
						</tr>
						</tbody>
					
				</table>

				<table id="inspect">
				<tfoot>
					<tr><td colspan="2"><a href="http://www.epa-echo.gov/cgi-bin/get1cReport.cgi?tool=echo&amp;IDNumber=<%=FRSID%>"><%=more%></a></td></tr>
					<tr><td id="whatcan">
						<% if(containFrames=="No") { %>	
							<a href="whatcan.jsp">
							<u><%=whatcando%></u></a>
						<%}else {%>
							<a href="whatcan.jsp?containFrame=containFrames"><u><%=whatcando%></u></a>
						
					<%} %></td></tr>
						
						
				</tfoot>
				<tbody>
					<tr><td><%=lastfullinsp%> :</td><td><%=last_inspection_str%></td></tr>
					<tr><td><%=formenfact%> :</td><td><%=num_enforcement_actions%></td></tr>
				</tbody>
				</table>
			</div>
		</div>
	</div>
	<% if(containFrames=="No") { %>	
                 <%@ include file="abovefooter.jsp" %>
		<div id="footer">
  			<p><a id="feedback_menu" href="http://m.epa.gov/privacy.html">Privacy</a><span class="key">[+]</span><a id="contact_menu" href="http://m.epa.gov/contact/index.html" accesskey="+">Contact</a><span class="key">[#]</span><a href="http://www.epa.gov/?m_rd=false" accesskey="#" title="EPA.gov Full Site">EPA.Gov</a><a id="desktop" href="http://www.epa.gov/?m_rd=false">Full site</a></p>
		</div>
		<%} %>

	<script type="text/javascript">
		window.scrollTo(80, 0);
                window.focus();
	</script>
	<% if(containFrames=="No") { %>	
	<%@ include file="bottom.jsp" %>
	<%} %>
	
<%
		} // end else
	} catch (Exception ex) {
		String emessage = ex.getMessage();
		out.println("   Error ");
		//out.println("    Error: " + ex.getLocalizedMessage() + "<br> " + emessage + "<br><br>\n");  // outputs oracle messages
		log("    Error: " + ex.getLocalizedMessage() + "<br> " + ex.getMessage());
	}
	
%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    