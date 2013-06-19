<script type="text/javascript">
function fsub(langvar)
{
         
	document.langfrm.action=location.href;
	document.langfrm.langparm.value=langvar ;
	document.langfrm.submit();
	
}
</script>

<form style="margin-bottom:0;" name=langfrm action=langpage.jsp method=post>
 

<table>
<tr>
<td >
<img width=90px src="images/header1.png"></img>
</td>
<td>
<input type=radio name=choice1 onClick="javascript:fsub('eng');" <%if(langparm1.trim().equalsIgnoreCase("eng")){%> checked ></input><font size=-2><strong><%=engl%></strong></font>
										<%}else{ %> ></input><font size=-2><strong><%=engl%></strong></font><%} %>
</td>

<td>

<input  type=radio name=choice1 onClick="javascript:fsub('spn');" <%if(langparm1.trim().equalsIgnoreCase("spn")){%> checked ></input><font size=-2><strong><%=spnl%></strong></font>

										<%}else{ %> ></input><font size=-2><strong><%=spnl%></strong></font>
<%} %>
</td>

</tr>
</table>

<input type=hidden name=langparm value="" />
</form>



