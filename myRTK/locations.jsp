<%@page contentType="text/xml" pageEncoding="UTF-8"%>
<%@ page import="javax.naming.Context,
         javax.naming.InitialContext,
         java.lang.Boolean,java.sql.*,
         java.lang.Object,java.io.*,
         java.net.URLEncoder,
         java.util.Date,
         java.text.SimpleDateFormat,
         java.util.HashMap ,org.apache.http.client.* ,org.apache.http.*, net.sf.json.*,org.apache.commons.io.* "%>
         <%@ include file="langpage.jsp" %>
<%
          	
            try {
			java.util.Properties property = null;
		ServletContext context = getServletContext();

		InputStream inputStream =context.getResourceAsStream("/WEB-INF/AppProperties.property");
                       
		
		property =new Properties();
		property.load(inputStream );
		String locsql1= property.getProperty("locsql1"); 
		String locsql2= property.getProperty("locsql2"); 
		
		
                Context initContext = new InitialContext();
                Context envContext = (Context) initContext.lookup("java:/comp/env");
                

                

                String swlat = request.getParameter("swlat");
                String swlng = request.getParameter("swlng");
                String nelat = request.getParameter("nelat");
                String nelng = request.getParameter("nelng");

           
                   String sql = null;
                
                    int RScnt = 0;
						String uri ="";
               if (swlat == null) {
                     uri = locsql1;
					
                    } else {
                        //prevent sql injection via conversion, due bug in parameters preparation, expand window
                       // double deltalat   = Double.parseDouble(nelat) - Double.parseDouble(swlat);
                      //  double deltalng = Double.parseDouble(nelng) - Double.parseDouble(swlng);
			
						//bug = "alpha branch 2";
						double deltalat   = 0.021850728332065 * 2;
						double deltalng = 0.0274658203125 * 2;

                        swlat = Double.toString(Double.parseDouble(swlat) - deltalat);
                        swlng = Double.toString(Double.parseDouble(swlng) - deltalng);
                        nelat = Double.toString(Double.parseDouble(nelat) + deltalat);
                        nelng = Double.toString(Double.parseDouble(nelng) + deltalng);
						locsql2 = locsql2+"DEM_LRTLAT/>=/"+swlat+"/DEM_LRTLONG/>=/"+swlng+"/DEM_LRTLAT/<=/"+nelat+"/DEM_LRTLONG/<=/"+nelng+"/JSON";
                        uri= locsql2;
                  
                    }
                   System.out.println("here="+uri);
             		URL url = new URL(uri);
					HttpURLConnection connection =
    				(HttpURLConnection) url.openConnection();
					connection.setRequestMethod("GET");
					connection.setRequestProperty("Accept", "application/json");
		
						InputStream is = connection.getInputStream();
						String jsonTxt = IOUtils.toString( is );
        
      			  		JSONArray json = (JSONArray) JSONSerializer.toJSON( jsonTxt ); 
						connection.disconnect();
					out.println("<markers>");
					for(int i = 0;i<json.size();i++)
					{   
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
                            strname = java.net.URLEncoder.encode(rs.getString("NAME"));
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
						
						
                        out.println("<marker name=\"" + strname +
                                "\" address=\"" + straddress +
                                "\" city=\"" + strcity +
                                "\" state=\"" + strstate +
                                "\" zip=\"" + strzip +
                                "\" triid=\"" + strtriid +
                                "\" frs=\"" + strfrs +
                                "\" sector=\"" + strsector +
                                "\" istri=\"" + stristri +
                                "\" lat=\"" + strlat + "\" lng=\"" + strlong +"\" />");
                        RScnt++;
                   }
                    out.println("</markers>");
                  

            } catch (Exception ex) {
                String ermsg = "    Error: " + ex.getLocalizedMessage() + " - " + ex.getMessage();
                out.println("Error");  // outputs oracle messages
                log("    Error: " + ex.getLocalizedMessage() + "<br> " + ex.getMessage());
            }
%>