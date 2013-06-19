<%--
    Document   : chems
    Created on : Apr 23, 2010, 9:33:37 AM
    Author     : BellfeinsD
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
	java.util.HashMap, java.util.*,net.sf.json.*,org.apache.commons.io.* "%>
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

	String containFramesHeader ="";

	if(request.getParameter("containFrame") !=null)
	{
  		containFramesHeader = request.getParameter("containFrame");
	}
	String containFrames="No";
	if(containFramesHeader.indexOf("containFrames") != -1)
	{
		containFrames ="Yes";
	}

	
	response.setHeader( "Vary", "User-Agent" );
	String title ="Chemical Information";
	String nav = "";
	if(DS1) { nav = "navigation"; } else { nav="portalMenu-tabs"; }
         
	
	try {
			java.util.Properties property = null;
		ServletContext context = getServletContext();

		InputStream inputStream =context.getResourceAsStream("/WEB-INF/AppProperties.property");
                       
		
		property =new Properties();
		property.load(inputStream );

		Context initContext = new InitialContext();
		

		String CAS = request.getParameter("ID");
		String str_ID="";
		String str_CHEMICAL="";
		String str_CHEMICAL_SHORT="";
		String str_CAS="";
		String str_CARCINOGEN="";
		String str_CANCER_SOURCE="";
		String str_CANCER_TEXT="";
		String str_DISPLAY_TEXT="";
		
		String str_NON_CARCINOGEN="";
		String str_BODY_WEIGHT="";
		String str_CARDIOVASCULAR="";
		String str_DERMAL="";
		String str_DEVELOPMENTAL="";
		String str_ENDOCRINE="";
		String str_GASTROINTESTINAL="";
		String str_HEMATOLOGICAL="";
		String str_HEPATIC="";
		String str_IMMUNOLOGICAL="";
		String str_METABOLIC="";
		String str_MUSCULOSKELETAL="";
		String str_NEUROLOGICAL="";
		String str_OCULAR="";
		String str_OTHER_SYSTEMIC="";
		String str_RENAL="";
		String str_REPRODUCTIVE="";
		String str_RESPIRATORY="";
		String str_ATSDR="";
		String str_HSDB="";

		
		String chemuri= property.getProperty("chemuri"); 
		String uri = chemuri+CAS+"/JSON";
			URL url = new URL(uri);
		HttpURLConnection connection =
    			(HttpURLConnection) url.openConnection();
		connection.setRequestMethod("GET");
		connection.setRequestProperty("Accept", "application/json");
		String id1 = "";

		InputStream is = connection.getInputStream();
		String jsonTxt = IOUtils.toString( is );
        
        	JSONArray json = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
        	
         
		connection.disconnect();

		
			int i = 0;
    			JSONObject rs = json.getJSONObject(i);
    			
			str_ID=rs.getString("ID");
			str_CHEMICAL=rs.getString("CHEMICAL");
			str_CHEMICAL_SHORT=rs.getString("CHEMICAL_SHORT");

			if (str_CHEMICAL_SHORT=="null") {
				str_CHEMICAL_SHORT = str_CHEMICAL;
			};

			str_CAS=rs.getString("CAS");
			str_CARCINOGEN=rs.getString("CARCINOGEN");

			str_CANCER_SOURCE=rs.getString("CANCER_SOURCE");
			str_CANCER_TEXT=rs.getString("CANCER_TEXT");
			str_DISPLAY_TEXT=rs.getString("DISPLAY_TEXT");

			str_NON_CARCINOGEN=rs.getString("NON_CARCINOGEN");
			str_BODY_WEIGHT=rs.getString("BODY_WEIGHT");
			str_CARDIOVASCULAR=rs.getString("CARDIOVASCULAR");
			str_DERMAL=rs.getString("DERMAL");
			str_DEVELOPMENTAL=rs.getString("DEVELOPMENTAL");
			str_ENDOCRINE=rs.getString("ENDOCRINE");
			str_GASTROINTESTINAL=rs.getString("GASTROINTESTINAL");
			str_HEMATOLOGICAL=rs.getString("HEMATOLOGICAL");
			str_HEPATIC=rs.getString("HEPATIC");
			str_IMMUNOLOGICAL=rs.getString("IMMUNOLOGICAL");
			str_METABOLIC=rs.getString("METABOLIC");
			str_MUSCULOSKELETAL=rs.getString("MUSCULOSKELETAL");
			str_NEUROLOGICAL=rs.getString("NEUROLOGICAL");
			str_OCULAR=rs.getString("OCULAR");
			str_OTHER_SYSTEMIC=rs.getString("OTHER_SYSTEMIC");
			str_RENAL=rs.getString("RENAL");
			str_REPRODUCTIVE=rs.getString("REPRODUCTIVE");
			str_RESPIRATORY=rs.getString("RESPIRATORY");
			str_ATSDR=rs.getString("ATSDR");
			str_HSDB=rs.getString("HSDB");
		
		
%>
<%@ include file="top.jsp" %>
	<!--<meta name="DC.description" content="myRTK is an EPA website designed for mobile devices. For any address, the map displays nearby facilities regulated under federal environmental laws. Facility reports provide summaries of chemical/pollutant releases, chemical effects, and compliance history from numerous data systems." />

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

<body class="apps" >
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
		 listtab="" ;
		 maptab="" ;
		 infotab="" ;
		info2tab="" ;
		%>
		<% } %>
		<% if( DS1||DS3) {  %>
		<% srchtab="" ;
		listtab="" ;
		maptab="" ;
		infotab="" ;
		info2tab="" ;
		%>
		<% } %>
		
	
		<% if(containFrames=="No") { %>	
	 		<%@ include file="toplinks.jsp" %>
	 	<%} %>
			
	<% if( DS1||DS3) { %>
	<div id="content">
	<% } %>
	<% if(DS1||DS2) { %>
		<div class="back"><a href="#" onclick="return_referrer()">&laquo;<u> <%=back1%></u></a></div>
	<% } %>
		<div class="chems_report">
			<b><%=str_CHEMICAL_SHORT%></b>
			<p><%=adversehltheff%>.</p>
	

		







		<% if (str_NON_CARCINOGEN !=null && str_NON_CARCINOGEN.equalsIgnoreCase("Yes")||
				str_CARCINOGEN.equalsIgnoreCase("YES")) { %>
			<h2><%=otherhltheff%></h2>
			<% String noeffect = toxinfonotavail+"."; %>
			<dl id="chem_gloss">
			<% if (str_CARCINOGEN.equalsIgnoreCase("YES")) { %>
			
			<dt><%=cancer%></dt><dd><%=str_DISPLAY_TEXT%>.</dd>
			<% noeffect = ""; } %>
			<% if (str_BODY_WEIGHT !=null && str_BODY_WEIGHT.equalsIgnoreCase("Yes")) { %>
				<dt><%=bodywgt%></dt><dd><%=altavgmass%>.</dd>
			<% noeffect = ""; } %>
			
			<% if (str_CARDIOVASCULAR !=null && str_CARDIOVASCULAR.equalsIgnoreCase("Yes")) { %>
				<dt><%=cardio%></dt><dd><%=refheartbld%>.</dd>
			<% noeffect = ""; } %>
				
			<% if (str_DERMAL !=null && str_DERMAL.equalsIgnoreCase("Yes")) { %>
				<dt><%=dermal%></dt><dd><%=refskinscalp%>.</dd>
			<% noeffect = ""; } %>
			
			<% if (str_DEVELOPMENTAL !=null && str_DEVELOPMENTAL.equalsIgnoreCase("Yes")) { %>
				<dt><%=develop1%></dt><dd><%=refgrowth%>.</dd>
			<% noeffect = ""; } %>
				
			<% if (str_ENDOCRINE !=null && str_ENDOCRINE.equalsIgnoreCase("Yes")) { %>
				<dt><%=endoc%></dt><dd><%=refhorm%>.</dd>
			<% noeffect = ""; } %>
			
			<% if (str_GASTROINTESTINAL !=null && str_GASTROINTESTINAL.equalsIgnoreCase("Yes")) { %>
				<dt><%=gastro%></dt><dd><%=refallparts%>.</dd>
			<% noeffect = ""; } %>

			<% if (str_HEMATOLOGICAL !=null && str_HEMATOLOGICAL.equalsIgnoreCase("Yes")) { %>
				<dt><%=hemato%></dt><dd><%=refblood%>.</dd>
			<% noeffect = ""; } %>
				
			<% if (str_HEPATIC !=null && str_HEPATIC.equalsIgnoreCase("Yes")) { %>
				<dt><%=hepatic%></dt><dd><%=refliver%>.</dd>
			<% noeffect = ""; } %>
				
			<% if (str_IMMUNOLOGICAL !=null && str_IMMUNOLOGICAL.equalsIgnoreCase("Yes")) { %>
				<dt><%=immuno%></dt><dd><%=refimmune%>.</dd>
			<% noeffect = ""; } %>
				
			<% if (str_METABOLIC !=null && str_METABOLIC.equalsIgnoreCase("Yes")) { %>
				<dt><%=metabolic%></dt><dd><%=refbiochem%>.</dd>
			<% noeffect = ""; } %>
				
			<% if (str_MUSCULOSKELETAL !=null && str_MUSCULOSKELETAL.equalsIgnoreCase("Yes")) { %>
				<dt><%=muscoskel%></dt><dd><%=refmuscles%>.</dd>
			<% noeffect = ""; } %>
				
			<% if (str_NEUROLOGICAL !=null && str_NEUROLOGICAL.equalsIgnoreCase("Yes")) { %>
				<dt><%=neurolog%></dt><dd><%=refbrain%>.</dd>
			<% noeffect = ""; } %>

			<% if (str_OCULAR !=null && str_OCULAR.equalsIgnoreCase("Yes")) { %>
				<dt><%=ocular%></dt><dd><%=refeye%>.</dd>
			<% noeffect = ""; } %>
				
			<% if (str_OTHER_SYSTEMIC !=null && str_OTHER_SYSTEMIC.equalsIgnoreCase("Yes")) { %>
				<dt><%=othersys%></dt><dd><%=effnotcat%>.</dd>
			<% noeffect = ""; } %>
				
			<% if (str_RENAL !=null && str_RENAL.equalsIgnoreCase("Yes")) { %>
				<dt><%=renal%></dt><dd><%=refkidneys%>.</dd>
			<% noeffect = ""; } %>
				
			<% if (str_REPRODUCTIVE !=null && str_REPRODUCTIVE.equalsIgnoreCase("Yes")) { %>
			<dt><%=reproductive%></dt><dd><%=refsystreq%>.</dd>
			<% noeffect = ""; } %>
				
			<% if (str_RESPIRATORY !=null && str_RESPIRATORY.equalsIgnoreCase("Yes")) { %>
				<dt><%=respiratory%></dt><dd><%=refexchoxy%>.</dd>
			<% noeffect = ""; } %>
		</dl>
			<% } else { %>

			<h2><%=otherhltheff%></h2>
			<p><%=toxinfonotavail%>.</p>

			<% } %>
		</div>
		<% if(DS1) { %>
			<div class="back"><a href="#" onclick="return_referrer()">&laquo; <u><%=back1%></u></a></div>
		<% } %>
		<% if(containFrames=="Yes") { %>	
			<p class="footnote"> <a href="http://www.epa.gov/tri/tri-chip/index.html" target="_blank"><%=chemtoxinfo%>.</a> </p>
		<% }else { %>
			<p class="footnote"> <a href="http://www.epa.gov/tri/tri-chip/index.html"><%=chemtoxinfo%>.</a> </p>
		<% } %>
		
	</div>
     <% if(containFrames=="No") { %>	

		<%@ include file="abovefooter.jsp" %>
		<div id="footer">
  			<p><a id="feedback_menu" href="http://m.epa.gov/privacy.html">Privacy</a><span class="key">[+]</span><a id="contact_menu" href="http://m.epa.gov/contact/index.html" accesskey="+">Contact</a><span class="key">[#]</span><a href="http://www.epa.gov/?m_rd=false" accesskey="#" title="EPA.gov Full Site">EPA.Gov</a><a id="desktop" href="http://www.epa.gov/?m_rd=false">Full site</a></p>
		</div>
	
		<script type="text/javascript">
		
			window.scrollTo(80, 0);
		</script>
		<%@ include file="bottom.jsp" %>
  <% } %>

 <% 
	} catch (Exception ex) {
		String emessage = ex.getMessage();
		log("    Error: " + ex.getLocalizedMessage() + ex.getMessage());
	}
%>