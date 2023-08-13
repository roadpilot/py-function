<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Session.Timeout = 1000 %>
<!-- #include file="sqlencode.xinc"-->
<%
if request("state")<>"" then session("state")=request("state")
if session("state")="" then session("state")="day"

database="pf"
Set dbcon = Server.CreateObject("ADODB.Connection")
dbcon.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=d:\websites\www.achtermann-us.com\database\_private\" & database & ".mdb"
'response.write dbcon.connectionstring
'response.end
dbcon.Open

if request("nf") then
	sql="select max(flight_serial) from flight"
	set rs=dbcon.execute(sql)
	'response.write rs(0)
	sql="insert into flight (flight_serial,item_topic) values (" & rs(0)+1 & ",0)"
	'response.write sql
	set rs=dbcon.execute(sql)
	sql="select max(flight_serial) from flight"
	set rs=dbcon.execute(sql)
	session("flight_serial")=rs(0)
	response.redirect "?ac=" & request("nf") & "&p=1"
end if
%>
<%
if request("flight_serial")<>"" then
	for each field in split(request("item_topic"),",")
	sql = "INSERT into flight (flight_serial,item,item_val) VALUES (" & request("flight_serial") & "," & trim(field) & ",'" & request(trim(field) & "_val") & "')"
%>
<script>
//alert("<%=sql%>");
</script>
<%
	dbcon.execute(sql)
	next
%>
	<script>
	//alert("<%=request("p")+1%>");
	//parent.location.href="?f=1&ac=1&p=<%=request("p")%>";
	parent.location.replace("?ac=1&p=<%=request("p")+1%>");
	self.location.replace("?ac=1&p=<%=request("p")%>");
	self.location.replace("about:blank");
	</script>
	<%response.end%>
<%'else%>
	<script>
//	parent.location.replace("\/pf");
	</script>
<%
end if

if request("ac")="" then
	sql = "select * from ac"
else
	'if session("flight_serial")="" then response.redirect "/pf"
	sql = "select * from pre where topic is not null and page=" & request("p") & " order by [order],serial"
end if
'response.write sql & "<BR>"
'response.end
set rs1 = server.createobject("adodb.recordset")
Set rs1.ActiveConnection = dbcon
Rs1.CursorLocation = 3
rs1.open sql
Set rs1.ActiveConnection = nothing
maxpage=dbcon.execute("select max(page) from pre")(0)
'response.write maxpage>request("p")
'response.end
%>
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
<title>E-Checklist</title>
<!--#include file="sqlencode.xinc"-->
<style>
td,div,a {font-family: Arial; font-size: 12pt}
<%if session("state")="day" then%>
input {font-family: Arial; font-size: 12pt; background-color:#000080; color: white}
.topic {font-family: Arial; font-size: 26pt; color: white}
.instrux {font-family: Arial; font-size: 12pt; color: silver}
body {background-color:#000080}
.button {font-family: Arial; font-weight:bold; background-color:silver; color:black; font-size: 12pt; height: 45pt}
<%else%>
input {font-family: Arial; font-size: 12pt; background-color:black; color: red}
.topic {font-family: Arial; font-size: 26pt; color: red}
.instrux {font-family: Arial; font-size: 12pt; color: red}
body {background-color:black}
.button {font-family: Arial; font-weight:bold; font-size: 12pt; height: 45pt}
<%end if%>
</style>
</head>
<body>
<!--<input type="button" value="RELOAD" onclick="self.location.reload()">-->
<%'do while not rs1.eof%>
<%'rs1.movenext%>
<%'loop%>
<%if request("ac")="" then%>
<%do while not rs1.eof%>
<div class="topic">
Please select aircraft for pre-flight instructions:
<input class="button" style="width:100%;height:50px" name="ac" type="button" id="<%=rs1("serial")%>" value="<%=rs1("name")%>" onclick="if(confirm('Begin new preflight for '+this.value+'?')){location.href='?nf='+this.id}">
<%
switch="Day"
if session("state")="day" then switch="Night"
%>
<input class="button" type="button" style="width:95%;height:50px;position:absolute;bottom:10" value="<%=switch%> Mode" onclick="toggleDayNight()">
<%rs1.movenext%>
<%loop%>
<%else%>
<%
if session("flight_serial")="" then session("flight_serial")=0
sql = "select * from flight where flight_serial=" & session("flight_serial")
set rs2 = server.createobject("adodb.recordset")
Set rs2.ActiveConnection = dbcon
rs2.CursorLocation = 3
rs2.open sql
Set rs2.ActiveConnection = nothing
%>
<form target="procframe">
<input type="hidden" name="flight_serial" value="<%=session("flight_serial")%>">
<input type="hidden" name="p" value="<%=request("p")%>">
<%
i=1
do while not rs1.eof
%>
<div class="topic">
<input type="hidden" name="item_topic" value="<%=rs1("serial")%>">
<%
rs2.filter="flight_serial=" & session("flight_serial") & " and item=" & rs1("serial")
if not rs2.eof then
	timestamp=rs2("timestamp")
	item_val=rs2("item_val")
else
	timestamp=null
end if
if isnull(timestamp) then
%>
<img id="img<%=i%>" border="0" src="checkbox-unchecked-gray-md.png" style="height:25px;width:25px">&nbsp;<%=rs1("topic")%>
<%else%>
<img border="0" src="checkbox-checked-gray-md.png" style="height:25px;width:25px">&nbsp;<%=rs1("topic")%>
<%end if%>
</div>
<div class="instrux">
<%=rs1("instrux")%>
</div>

<%if rs1("topic")="PlanningZ" then%>
<input style="font-size:26pt" value="<%=item_val%>" name="12_val" type="tel" size="2" onkeyup="setFuel(this.value)">
<span class="topic"> Temp C
</span>
<hr>
<div class="instrux" id="fuelinstrux">
</div>
<script>
function setFuel(val){
document.all('fuelinstrux').innerText=val;
document.all('fuelinstrux').innerText+=" gallons of fuel will supply approximately";
document.all('fuelinstrux').innerText+=" " + (val/12).toFixed(1);
document.all('fuelinstrux').innerText+=" hours of flight time.  Regulations require a 20 minute (4 gallon) reserve";
document.all('fuelinstrux').innerText+=" so the actual usable flight time is";
document.all('fuelinstrux').innerText+=" " + ((val-4)/12).toFixed(1);
document.all('fuelinstrux').innerText+=" hours.";
}
<%if item_val<>"" then%>
setFuel("<%=item_val%>");
<%end if%>
</script>
<%end if%>

<%if rs1("topic")="Fuel level" then%>
<input style="font-size:26pt" value="<%=item_val%>" name="12_val" type="tel" size="2" onkeyup="setFuel(this.value)">
<span class="topic"> Gal
</span>
<hr>
<div class="instrux" id="fuelinstrux">
</div>
<script>
function setFuel(val){
document.all('fuelinstrux').innerText=val;
document.all('fuelinstrux').innerText+=" gallons of fuel will supply approximately";
document.all('fuelinstrux').innerText+=" " + (val/12).toFixed(1);
document.all('fuelinstrux').innerText+=" hours of flight time.  Regulations require a 20 minute (4 gallon) reserve";
document.all('fuelinstrux').innerText+=" so the actual usable flight time is";
document.all('fuelinstrux').innerText+=" " + ((val-4)/12).toFixed(1);
document.all('fuelinstrux').innerText+=" hours.";
}
<%if item_val<>"" then%>
setFuel("<%=item_val%>");
<%end if%>
</script>
<%end if%>

<%
input=0
if rs1("serial")=70 then input=1
if rs1("serial")=71 then input=1
if rs1("serial")=73 then input=1
if rs1("serial")=74 then input=1
if (input) then%>
<input style="font-size:26pt" value="<%=item_val%>" name="<%=rs1("serial")%>_val" type="tel" size="6">
<span class="topic">
</span>
<hr>
<div class="instrux" id="fuelinstrux">
</div>
<%end if%>

<%if rs1("topic")="Ready to fly!" then%>
<textarea name="plan" style="width:290px;height:70px" rows="1" cols="20">Preflight done.  Take off in a few.  Alpha-pop is on the go!</textarea>
<input class="button" type="button" onclick="sms('wife')" value="Notify your wife!" style="font-weight:bold;height:50px;width:95%"><br><br>
<input class="button" type="button" onclick="sms('others')" value="Notify others" style="font-weight:bold;height:50px;width:95%"><br><br>
<input class="button" type="button" onclick="sms('wifereturn')" value="Notify your return" style="font-weight:bold;height:50px;width:95%">
<script>
function sms(who){
plan=document.forms[0].plan.value;
if (who=="wife") {
	numbers='3036645377';
	plan+="  L/M.";
}
if (who=="wifereturn") {
	numbers='3036645377';
	plan="Sagely hone. Lug ewe.";
}
if (who=="others") {
numbers='';
//numbers+='3036645394;' //mom
numbers+='7202920469;' //matt n.
numbers+='7202184381' //slider
}
location.href='sms:'+numbers+'?body='+plan;
}
</script>
<%end if%>
<%
i=i+1
rs1.movenext
%>
<%loop%>
</form>
<%'if rs1.eof then%>
<%if cint(request("p"))>maxpage then%>
<%
sql="select * from flight where flight_serial=" & session("flight_serial") & " and item in (70,71,73,74)"
set rs = server.createobject("adodb.recordset")
Set rs.ActiveConnection = dbcon
rs.CursorLocation = 3
rs.open sql
Set rs.ActiveConnection = nothing

rs.filter="item=70"
mhobbs1=rs("item_val")
rs.filter="item=73"
mhobbs2=rs("item_val")
if mhobbs1<>"" then mhobbs=round(mhobbs2-mhobbs1,1)

rs.filter="item=71"
bhobbs1=rs("item_val")
rs.filter="item=74"
bhobbs2=rs("item_val")
if bhobbs1<>"" then bhobbs=round(bhobbs2-bhobbs1,1)

sql="select min(timestamp),max(timestamp) from flight where flight_serial=" & session("flight_serial")
set rs = server.createobject("adodb.recordset")
Set rs.ActiveConnection = dbcon
rs.CursorLocation = 3
rs.open sql
Set rs.ActiveConnection = nothing
durax=round(datediff("n",rs(0),rs(1))/60,1)
%>
<div class="topic">Flight Report</div>
<div class="instrux">Duration: <b><%=durax%> hours</b></div>
<div class="instrux">Maint Hobbs: <b><%=mhobbs%> hours</b></div>
<div class="instrux">Billing Hobbs: <b><%=bhobbs%> hours</b></div>
<hr>
<div class="instrux">Comments:</div>
<textarea name="comments" style="width:290px;height:70px" rows="1" cols="20"></textarea>
<br>
<table border="0" width="100%">
  <tr>
    <td class="instrux"><input type="checkbox" name="C1" value="ON">PIC</td>
    <td class="instrux"><input type="checkbox" name="C1" value="ON" checked>HELO</td>
    <td class="instrux"><input type="checkbox" name="C1" value="ON">DUAL</td>
    <td class="instrux"><input type="checkbox" name="C1" value="ON">NIGHT</td>
  </tr>
  <tr>
    <td class="instrux"><input type="checkbox" name="C1" value="ON">CC</td>
    <td class="instrux"><input type="checkbox" name="C1" value="ON">TURB</td>
    <td class="instrux"><input type="checkbox" name="C1" value="ON"></td>
    <td class="instrux"><input type="checkbox" name="C1" value="ON"></td>
  </tr>
  <tr>
    <td class="instrux"><input type="checkbox" name="C1" value="ON"></td>
    <td class="instrux"><input type="checkbox" name="C1" value="ON"></td>
    <td class="instrux"><input type="checkbox" name="C1" value="ON"></td>
    <td class="instrux"><input type="checkbox" name="C1" value="ON"></td>
  </tr>
</table>
<table width=95% style="position:absolute;top:260pt">
<tr>
<td>
<input class="button" type="button" style="width:100%;height:50px;" value="Save to Logbook" onclick="save();">
</td>
</tr>
</table>
<%else%>
<table width=95% style="position:absolute;top:260pt">
<tr>
<td>
<%
buttonwidth="100"
if request("p")>1 then
buttonwidth="80"
%>
<input class="button" type="button" style="width:<%=98-buttonwidth%>%;height:50px;" value="<<" onclick="pageDown();">
<%end if%>
<input class="button" type="button" style="width:<%=buttonwidth%>%;height:50px;" value="Check all and continue" onclick="pageUp();">
</td>
</tr>
</table>
<%end if%>
<%end if%>
<iframe style="display:none" name="procframe" src=""></iframe>
</body>
<script deferred>
function pageDown(){
	location.replace("?ac=1&p=" + (<%=request("p")%>-1));
}

function pageUp(){
<%if isnull(timestamp) then%>
for (var i=1;i<<%=i%>;i++)
{ 
	document.all('img'+i).src="checkbox-checked-gray-md.png";
}
	document.forms[0].submit();
//	location.reload();
<%else%>
	location.href="?ac=1&p=" + (<%=request("p")%>+1);
<%end if%>
}

function toggleDayNight(){
	var state="<%=session("state")%>"
	if (state=="day"){
		location.replace("?state=night");
	}
	else{
		location.replace("?state=day");
	}
}
</script>
</html>





































































































































































