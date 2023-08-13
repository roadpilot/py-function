<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Session.Timeout = 1000 %>
<!-- #include file="sqlencode.xinc"-->
<html>

<head>
<META content=True name=HandheldFriendly>
<META content=user-scalable=no,width=device-width name=viewport>
<META http-equiv=expires content=0>
<META http-equiv=cache-control content=no-cache>
<META http-equiv=pragma content=no-cache>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Fuel Calculator</title>
<!--#include file="sqlencode.xinc"-->
<style>
td,div,a {font-family: Arial; font-size: 12pt}
input {font-family: Arial; font-size: 12pt; background-color:#000080; color: white}
.topic {font-family: Arial; font-size: 20pt; color: white}
.instrux {font-family: Arial; font-size: 12pt; color: silver}
body {background-color:#000080}
.button {font-family: Arial; font-weight:bold; background-color:silver; color:black; font-size: 12pt; height: 45pt}
</style>
</head>
<form>
<input style="font-size:26pt;text-align:right" value="<%=item_val%>" name="aux_val" type="tel" size="2" onkeyup="setFuel(this)">
<span class="topic">/16 Aux (17.0 Gal)
</span>
<br>
<input style="font-size:26pt;text-align:right" value="<%=item_val%>" name="main_val" type="tel" size="2" onkeyup="setFuel(this)">
<span class="topic">/16 Main (29.5 Gal)
</span>
</form>
<hr>
<div class="instrux" style="font-size:26pt" id="fuelinstrux">
</div>
<script>
function setFuel(val){
i=((document.forms[0].aux_val.value/16)*17)+((document.forms[0].main_val.value/16)*29.5);
i=i.toFixed(2);
document.all('fuelinstrux').innerText=i+" Gal";
document.all('fuelinstrux').innerText+="";
}
<%if item_val<>"" then%>
setFuel("<%=item_val%>");
<%end if%>
</script>
</html>



































