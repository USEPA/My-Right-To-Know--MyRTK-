		<div id="<%=nav%>">
		<noscript id="jsdetect">This website requires JavaScript to function properly. Please enable JavaScript and try again.</noscript>
		<ol>
                       <li><a <%=srchtab%> href="search.jsp"><%=search%></a></li>
			<% if(DS1 || DS2) { %>
			<li><a <%=maptab%>  href="#" onclick="findUserLocationMap('No')"><%=map%></a></li>
			<% } %>
		<li><a <%=info2tab%> href="maplegend.jsp"><%=infocontent2%></a></li>
			<li><a <%=listtab%> href="#" onclick="findUserLocationList('No')"><%=list%></a></li>
			
			<li><a <%=infotab%> href="info.jsp"><%=information%></a></li>
			
		</ol>
		</div>

