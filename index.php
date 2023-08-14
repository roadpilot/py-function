
<!--
<textarea name="plan" style="width:290px;height:70px" rows="1" cols="20">Preflight done.  Take off in a few.  Alpha-pop is on the go!</textarea>
<input class="button" type="button" onclick="sms('wife')" value="Notify your wife!" style="font-weight:bold;height:50px;width:95%"><br><br>
-->
<script>
function sms(who){
//plan=document.forms[0].plan.value;
plan="test";
if (who=="wife") {
	numbers='3038292715';
	plan+="  L/M.";
}
if (who=="wifereturn") {
	numbers='3038292715';
	plan="Sagely hone. Lug ewe.";
}
location.href='sms:'+numbers+'?body='+plan;
}
</script>

<html>

<head>
<META content=True name=HandheldFriendly>
<META content=user-scalable=no,width=device-width name=viewport>
<META http-equiv=expires content=0>
<META http-equiv=cache-control content=no-cache>
<META http-equiv=pragma content=no-cache>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 12.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>E-Checklist</title>

<style>
td,div,a {font-family: Arial; font-size: 12pt}

input {font-family: Arial; font-size: 12pt; background-color:#000080; color: white}
.topic {font-family: Arial; font-size: 26pt; color: white}
.instrux {font-family: Arial; font-size: 12pt; color: silver}
body {background-color:#000080}
.button {font-family: Arial; font-weight:bold; background-color:silver; color:black; font-size: 12pt; height: 45pt}

</style>
</head>
<body>
<!--<input type="button" value="RELOAD" onclick="self.location.reload()">-->

	<div class="topic">
	<input type="hidden" name="item_topic" value="1">
	
		<img id="img" border="0" src="checkbox-unchecked-gray-md.png" style="height:25px;width:25px">&nbsp;Pedals
	</div>
	<div class="instrux">
	Free moving and adjusted for height
	</div>

