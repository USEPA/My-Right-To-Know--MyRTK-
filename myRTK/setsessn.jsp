<%	
String lparm = request.getParameter("langparm");
	if(lparm != null&&lparm.trim().length()>0)
	{ session.setAttribute("langparm1", lparm);}
	else
	{ lparm =  (String)session.getAttribute("langparm1");
		if(lparm != null)
		{ 
			session.setAttribute("langparm1", lparm.trim());
		}
		else
		{
			String deflparm = request.getHeader( "Accept-Language" );
			if(deflparm.startsWith("en"))
				{ session.setAttribute("langparm1", "eng");
				}
			else if (deflparm.startsWith("es"))
				{ session.setAttribute("langparm1", "spn");
				}
			else
				{ session.setAttribute("langparm1", "eng");
				}

		}
	}
%>