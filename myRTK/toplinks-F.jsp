
		<noscript id="jsdetect">This website requires JavaScript to function properly. Please enable JavaScript and try again.</noscript>
		<center>
                      <% if(maptab.length()>0)
			{ %>
		
			<a <%=listtab%> href="#" onclick="findUserLocationList('Yes')"><u><%=list%></u></a>
			
			<a <%=infotab%> href="info.jsp?containFrame=containFrames"><u><%=information%></u></a>
			<a <%=srchtab%> href="index.jsp?containFrame=containFrames"><u><%=search%></u></a>
			<% } else if(listtab.length()>0)
			{ %>
			<a <%=maptab%>  href="#" onclick="findUserLocationMap('Yes')"><u><%=map%></u></a>
			<a <%=infotab%> href="info.jsp?containFrame=containFrames"><u><%=information%></u></a>
			<a <%=srchtab%> href="index.jsp?containFrame=containFrames"><u><%=search%></u></a>
			<% } else if(infotab.length()>0)
			{ %>
			<a <%=listtab%> href="#" onclick="findUserLocationList('Yes')"><u><%=list%></u></a>
			<a <%=maptab%>  href="#" onclick="findUserLocationMap('Yes')"><u><%=map%></u></a>
			<a <%=srchtab%> href="index.jsp?containFrame=containFrames"><u><%=search%></u></a>
			<% } %>
		</center>
		