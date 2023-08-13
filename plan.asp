<!-- #include file="sqlencode.xinc"-->
<%
Set dbcon = Server.CreateObject("ADODB.Connection")
dbcon.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=d:\websites\www.achtermann-us.com\pf\plan.mdb"
'response.write dbcon.connectionstring
'response.end
dbcon.Open

if request("del")<>"" then
	dbcon.execute("delete from table1 where serial=" & request("del"))
	response.redirect "?id=" & request("id")
end if

plan_id=request("id")

if plan_id="" then
sql = "select plan_id from table1 "
sql = sql & "group by plan_id order by last(serial)"
set rs1 = server.createobject("adodb.recordset")
Set rs1.ActiveConnection = dbcon
Rs1.CursorLocation = 3
rs1.open sql

do while not rs1.eof
response.write "<a href='?id=" & rs1("plan_id") & "'>" & rs1("plan_id") & "<BR>"
rs1.movenext
loop

response.end
end if

if request("action")="reverse" then

sql = "select * from table1 where "
sql = sql & "[plan_id]='" & plan_id & "' "
sql = sql & "order by serial desc"
set rs1 = server.createobject("adodb.recordset")
Set rs1.ActiveConnection = dbcon
Rs1.CursorLocation = 3
rs1.open sql

i=0
do while not rs1.eof
if i>-1 then
sql = "INSERT INTO TABLE1 ("
sql = sql & "[plan_id]"
sql = sql & ",[windDir]"
sql = sql & ",[dest]"
sql = sql & ",[ckpnt]"
sql = sql & ",[temp]"
sql = sql & ",[altstg]"
sql = sql & ",[course]"
sql = sql & ",[IA]"
sql = sql & ",[mvar]"
sql = sql & ",[windSpd]"
sql = sql & ",[dist]"
sql = sql & ",[IAS]"
sql = sql & ") VALUES ("
sql = sql & sqlencode(rs1("plan_id"))
sql = sql & "," & sqlencode(rs1("windDir"))
rs_bookmark=rs1.bookmark
rs1.movenext
if not rs1.eof then 
	sql = sql & "," & sqlencode(rs1("dest"))
	sql = sql & "," & sqlencode(rs1("ckpnt"))
else
	'origin="kbjc"
	'o_desc="KBJC 5673 CTAF: 118.6 GROUND: 121.7 ATIS: 126.25"
	sql = sql & "," & sqlencode(origin)
	sql = sql & "," & sqlencode(o_desc)
end if
rs1.bookmark=rs_bookmark
sql = sql & "," & sqlencode(rs1("temp"))
sql = sql & "," & sqlencode(rs1("altstg"))
sql = sql & "," & sqlencode(rs1("course")+180)
sql = sql & "," & sqlencode(rs1("IA"))
sql = sql & "," & sqlencode(rs1("mvar"))
sql = sql & "," & sqlencode(rs1("windSpd"))
sql = sql & "," & sqlencode(rs1("dist"))
sql = sql & "," & sqlencode(rs1("IAS"))
sql = sql & ")"    

response.write sql & "<HR>"
dbcon.execute(sql)
end if

i=i+1
rs1.movenext
loop

response.end
%>
<script>parent.location.reload();</script>
<%
end if

if request("serial")<>"" then
serial=split(request("serial"),";;")
plan_id=split(request("plan_id"),";;")
windDir=split(request("windDir"),";;")
ckpnt=split(request("ckpnt"),";;")
temp=split(request("temp"),";;")
dest=split(request("dest"),";;")
altstg=split(request("altstg"),";;")
course=split(request("course"),";;")
IA=split(request("IA"),";;")
mvar=split(request("mvar"),";;")
windSpd=split(request("windSpd"),";;")
dist=split(request("dist"),";;")
IAS=split(request("IAS"),";;")

for i=0 to ubound(serial)
sql = ""
  if serial(i)="INSERT" then
sql = "INSERT INTO TABLE1 ("
sql = sql & "[plan_id]"
sql = sql & ",[windDir]"
if 0 then
sql = sql & ",[ckpnt]"
sql = sql & ",[temp]"
sql = sql & ",[dest]"
sql = sql & ",[altstg]"
sql = sql & ",[course]"
sql = sql & ",[IA]"
sql = sql & ",[mvar]"
sql = sql & ",[windSpd]"
sql = sql & ",[dist]"
sql = sql & ",[IAS]"
end if
sql = sql & ") VALUES ("
sql = sql & sqlencode(trim(plan_id(i)))
sql = sql & "," & sqlencode(trim(windDir(i)))
if 0 then
sql = sql & "," & sqlencode(trim(ckpnt(i)))
sql = sql & "," & sqlencode(trim(temp(i)))
sql = sql & "," & sqlencode(trim(dest(i)))
sql = sql & "," & sqlencode(trim(altstg(i)))
sql = sql & "," & sqlencode(trim(course(i)))
sql = sql & "," & sqlencode(trim(IA(i)))
sql = sql & "," & sqlencode(trim(mvar(i)))
sql = sql & "," & sqlencode(trim(windSpd(i)))
sql = sql & "," & sqlencode(trim(dist(i)))
sql = sql & "," & sqlencode(trim(IAS(i)))
end if
sql = sql & ")"    
  else
sql = "UPDATE TABLE1 SET "
sql = sql & "[windDir]=" & sqlencode(trim(windDir(i)))
sql = sql & ",[ckpnt]=" & sqlencode(trim(ckpnt(i)))
sql = sql & ",[temp]=" & sqlencode(trim(temp(i)))
sql = sql & ",[dest]=" & sqlencode(trim(dest(i)))
sql = sql & ",[altstg]=" & sqlencode(trim(altstg(i)))
sql = sql & ",[course]=" & sqlencode(trim(course(i)))
sql = sql & ",[IA]=" & sqlencode(trim(IA(i)))
sql = sql & ",[mvar]=" & sqlencode(trim(mvar(i)))
sql = sql & ",[windSpd]=" & sqlencode(trim(windSpd(i)))
sql = sql & ",[dist]=" & sqlencode(trim(dist(i)))
sql = sql & ",[IAS]=" & sqlencode(trim(IAS(i)))
sql = sql & " WHERE [serial]=" & sqlencode(trim(serial(i)))
  end if
response.write sql & "<HR>"
if sql<>"" then dbcon.execute(sql)
next
'response.end
%>
<script>parent.document.all['savebutton'].disabled=false;</script>
<%
  response.end
end if

sql = "select * from table1 where "
sql = sql & "[plan_id]='" & plan_id & "' "
sql = sql & "order by serial"
set rs1 = server.createobject("adodb.recordset")
Set rs1.ActiveConnection = dbcon
Rs1.CursorLocation = 3
rs1.open sql

urllink=dbcon.execute("select url from table2 where [plan_id]='" & plan_id & "'")
'burnrate=10

'response.write rs1.recordcount
'response.end
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!-- saved from url=(0033)http://indoavis.net/main/tas.html -->
<HTML><HEAD><TITLE>Flight Planner</TITLE>
<META content="text/html; charset=windows-1252" http-equiv=Content-Type><!-- original source: http://www.paragonair.com/public/aircraft/calc_TAS.html --><LINK 
rel=stylesheet type=text/css href="TAS%20Calculator_files/style.css">
<STYLE>INPUT {
	BORDER-BOTTOM: #808080 1px solid; BORDER-LEFT: #808080 1px solid; BORDER-TOP: #808080 1px solid; BORDER-RIGHT: #808080 1px solid
}
BODY {
	FONT-FAMILY: Arial; FONT-SIZE: 10pt
}
DIV {
	FONT-FAMILY: Arial; FONT-SIZE: 10pt
}
TD {
	FONT-FAMILY: Arial; FONT-SIZE: 10pt
}
P {
	FONT-FAMILY: Arial; FONT-SIZE: 10pt
}
.hcell {
	BORDER-BOTTOM: #c0c0c0 1px solid; TEXT-ALIGN: center; BORDER-LEFT: #c0c0c0 1px solid; BACKGROUND-COLOR: #e0e0e0; BORDER-TOP: #c0c0c0 1px solid; FONT-WEIGHT: bold; BORDER-RIGHT: #c0c0c0 1px solid
}
.ro {
	BORDER-BOTTOM: #c0c0c0 1px solid; BORDER-LEFT: #c0c0c0 1px solid; BACKGROUND-COLOR: #f0f0f0; BORDER-TOP: #c0c0c0 1px solid; BORDER-RIGHT: #c0c0c0 1px solid
}
.shd {
	BACKGROUND-COLOR: #c0c0c0
}
.bvl {
	BORDER-BOTTOM: 2px outset; BORDER-LEFT: 2px outset; BACKGROUND-COLOR: #f0f0f0; BORDER-TOP: 2px outset; BORDER-RIGHT: 2px outset
}
</STYLE>

<SCRIPT language=javascript>
<!--
lapserate = 0.0019812;		// degrees / foot std. lapse rate C° in to K° result
tempcorr = 273.15			// deg Kelvin
stdtemp0 = 288.15			// deg Kelvin
wasFeet = true;			// default: feet
wasInches = true;			// default: inches
wasCelsius = true;		// default: Celsius

function twoplace(number)
{
  if(isNaN(number)) return number;

  number = Math.round(100 * number);
  var whole = Math.floor(number / 100);
  var mods = number % 100;
  var decimal = mods.toString();
  if(mods < 10)  decimal = "0" + decimal;
  return whole.toString() + "." + decimal;
}

function roundit(thenum)
{
  return Math.floor(thenum + 0.5);
}

function fixunits(units)
{
  with(document.densalt) {
    isFeet = altunits[0].checked;
    isInches = setunits[0].checked;
    isCelsius = tempunits[0].checked;

    if("alt" == units  &&  isFeet != wasFeet) {
      factor = 3.28084;			// meters to feet
  	  if(!isFeet)  factor = 1. / factor;	// feet to meters
        if(IA.value)  IA.value = roundit(factor * eval(IA.value));
        if(PA.value)  PA.value = roundit(factor * eval(PA.value));
        if(DA.value)  DA.value = roundit(factor * eval(DA.value));
  	  wasFeet = isFeet;
  	  IA.focus();
    }
    else if("set" == units  &&  isInches != wasInches) {
  	  factor = 0.02953;				// hPa to inches
  	  if(!isInches)  factor = 1. / factor;	// inches to hPa
  	  if(altstg.value)
  	    altstg.value = twoplace(factor * eval(altstg.value));
  	  wasInches = isInches;
  	  altstg.focus();
    }
    else if("temp" == units  &&  isCelsius != wasCelsius) {
  	  factor = isCelsius ? 5. / 9:  9. / 5;
  	  if(temp.value) {
  	    theTemp = eval(temp.value);
  	    theTemp = twoplace((theTemp + 40) * factor) - 40;
  		  temp.value = theTemp;
  	  }
  	  wasCelsius = isCelsius;
  	  temp.focus();
    }
  }
  compute();
}

function compute(cForm)
{
/*
  isFeet = document.densalt.altunits[0].checked;
  isInches = document.densalt.setunits[0].checked;
  isCelsius = document.densalt.tempunits[0].checked;
*/

  isFeet = 1;
  isInches = 1;
  isCelsius = 1;

  altFactor = isFeet ? 1.: 3.28084;
  setFactor = isInches ? 1.: 0.02953;

  if (cForm.IA.value) IA = eval(cForm.IA.value);
  if (cForm.altstg.value) altstg = eval(cForm.altstg.value);
  if (cForm.temp.value) temp = eval(cForm.temp.value);
  
/*
  if(cForm.IA.value) IA = eval(cForm.IA.value);
  else IA = 0;
  cForm.IA.value = IA;

  if (cForm.altstg.value) altstg = eval(cForm.altstg.value);
  else altstg = isInches ? 29.92: 1013.25;
  //cForm.altstg.value = altstg;

  if (cForm.temp.value) temp = eval(cForm.temp.value);
  else temp = isCelsius ? 15: 59;

  cForm.temp.value = temp;
*/

  if(!isCelsius) temp =(temp + 40) *(5 / 9) - 40;

  xx = setFactor * altstg / 29.92126;
  PA = IA + 145442.2 * altFactor *(1 - Math.pow(xx, 0.190261));
  //cForm.PA.value = roundit(PA);

  stdtemp = stdtemp0 - PA * lapserate;

  Tratio = stdtemp / altFactor / lapserate;
  xx = stdtemp /(temp + tempcorr);	// for temp in deg C
  DA = PA + Tratio * altFactor *(1 - Math.pow(xx, 0.234969));
  //cForm.DA.value = roundit(DA);

  aa = DA * lapserate;			// Calculate DA temperature
  bb = stdtemp0 - aa;				// Correct DA temp to Kelvin
  cc = bb / stdtemp0;				// Temperature ratio
  cc1 = 1 / 0.234969;				// Used to find .235 root next
  dd = Math.pow(cc, cc1);			// Establishes Density Ratio
  dd = Math.pow(dd, .5);			// For TAS, square root of DR
  ee = 1 / dd;					// For TAS; 1 divided by above
  var cas = cForm.IAS.value;
  ff = ee * cas;
  cForm.TAS.value = roundit(ff);
}


function clearDA()
{ document.densalt.DA.value = ""; }

function clearPA()
{
  document.densalt.PA.value = "";
  clearDA();
}

function calcPlan(cForm){
  compute(cForm);
  crs = (Math.PI/180) * cForm.course.value;
  wd = (Math.PI/180) * cForm.windDir.value;
  swc = (cForm.windSpd.value/cForm.TAS.value) * 
        Math.sin(wd - crs);
  if (Math.abs(swc) > 1){
    alert("Danger!... Course should not be flown... Wind is too strong");
    return;
    }
  hd = crs + Math.asin(swc);
  if (hd < 0) {
    hd = hd + 2 * Math.PI;
    }
  if (hd > 2*Math.PI) {
    hd = hd - 2 * Math.PI;
    }
  cForm.heading.value = Math.round((180/Math.PI) * hd);
  cForm.GS.value = Math.round(cForm.TAS.value * Math.sqrt(1 - Math.pow(swc, 2)) - 
         (cForm.windSpd.value * Math.cos(wd - crs)));
  wca = Math.atan2(cForm.windSpd.value * Math.sin(hd-wd),
                               cForm.TAS.value-cForm.windSpd.value * 
                               Math.cos(hd-wd));
  cForm.WCA.value = Math.round((180/Math.PI) * (wca * -1)); // 6/2/02 CED sign correction

  course = Math.round((180/Math.PI) * crs);
  if (course<1) course+=360;
  if (course>360) course-=360;
  cForm.course.value = course;


  mag_hd = parseInt(cForm.heading.value)+parseInt(cForm.mvar.value);
  if (mag_hd<1) mag_hd+=360;
  if (mag_hd>360) mag_hd-=360;
  cForm.mag_hd.value = mag_hd;

  compass = mag_hd+parseInt(cForm.mag_dev.value);
  if (compass<1) compass+=360;
  if (compass>360) compass-=360;
  cForm.compass.value = compass;

  heading = cForm.heading.value;
  if (heading<1) heading+=360;
  if (heading>360) heading-=360;
  cForm.heading.value = heading;

  windDir = cForm.windDir.value;
  if (windDir<1) windDir+=360;
  if (windDir>360) windDir-=360;
  cForm.windDir.value = windDir;

  cForm.ete.value = ((cForm.dist.value/cForm.GS.value)*60).toFixed(1);
  cForm.fuel.value = ((cForm.ete.value/60)*document.forms['totals'].gph.value).toFixed(1);
  cForm.course.value = (cForm.course.value/1000).toFixed(3).toString().substr(2);
  cForm.mag_hd.value = (cForm.mag_hd.value/1000).toFixed(3).toString().substr(2);
  cForm.compass.value = (cForm.compass.value/1000).toFixed(3).toString().substr(2);
  cForm.heading.value = (cForm.heading.value/1000).toFixed(3).toString().substr(2);
  cForm.windDir.value = (cForm.windDir.value/1000).toFixed(3).toString().substr(2);
  cForm.windSpd.value = (cForm.windSpd.value/100).toFixed(2).toString().substr(2);
  var disttotal=0;
  var etetotal=0;
  var fueltotal=0;
  for (var i=0; i<document.forms.length-1; i++){
    if (document.forms[i].name=='cForm1'){
  	disttotal+=parseFloat(document.forms[i].dist.value);
 	etetotal+=parseFloat(document.forms[i].ete.value);
 	fueltotal+=parseFloat(document.forms[i].fuel.value);
	}
  }
  document.forms['totals'].disttotal.value=disttotal.toFixed(1);
  document.forms['totals'].etetotal.value=etetotal.toFixed(1);
  document.forms['totals'].fueltotal.value=fueltotal.toFixed(1);
  disttotal=0;
  etetotal=0;
  fueltotal=0;
  for (var i=0; i<document.forms.length-1; i++){
    if (document.forms[i].name=='cForm1'){
  	disttotal+=parseFloat(document.forms[i].dist.value);
 	etetotal+=parseFloat(document.forms[i].ete.value);
 	fueltotal+=parseFloat(document.forms[i].fuel.value);
	document.forms[i].dist_rem.value=(document.forms['totals'].disttotal.value-disttotal).toFixed(1);
	document.forms[i].ete_rem.value=etetotal.toFixed(1)+" | "+(document.forms['totals'].etetotal.value-etetotal).toFixed(1);
	document.forms[i].fuel_rem.value=(document.forms['totals'].fueltotal.value-fueltotal).toFixed(1);
	}
  }
//  cForm.submit();
}

function saveForm(formObj){
  formObj.target="submitframe";
  formObj.submit();
}

function _calcPlan(cForm) {
  compute(cForm);
  wd = (Math.PI/180)*cForm.windDir.value
  hd = (Math.PI/180)*cForm.heading.value
  cForm.GS.value = Math.round(Math.sqrt(Math.pow(cForm.windSpd.value, 2) + 
                              Math.pow(cForm.TAS.value, 2)- 2 * cForm.windSpd.value *
                              cForm.TAS.value * Math.cos(hd-wd)));
  wca = Math.atan2(cForm.windSpd.value * Math.sin(hd-wd),
                               cForm.TAS.value-cForm.windSpd.value * 
                               Math.cos(hd-wd));
  wca = wca * -1;
  cForm.WCA.value = Math.round((180/Math.PI) * wca);
  crs = (hd + wca) % (2 * Math.PI);

  course = Math.round((180/Math.PI) * crs);
  if (course<1) course+=360;
  if (course>360) course-=360;
  cForm.course.value = course;

  mag_hd = parseInt(cForm.course.value)+parseInt(cForm.mvar.value);
  if (mag_hd<1) mag_hd+=360;
  if (mag_hd>360) mag_hd-=360;
  cForm.mag_hd.value = mag_hd;

  compass = mag_hd+parseInt(cForm.mag_dev.value);
  if (compass<1) compass+=360;
  if (compass>360) compass-=360;
  cForm.compass.value = compass;

  heading = cForm.heading.value;
  if (heading<1) heading+=360;
  if (heading>360) heading-=360;
  cForm.heading.value = heading;

  windDir = cForm.windDir.value;
  if (windDir<1) windDir+=360;
  if (windDir>360) windDir-=360;
  cForm.windDir.value = windDir;

  cForm.ete.value = ((cForm.dist.value/cForm.GS.value)*60).toFixed(1);
  cForm.fuel.value = ((cForm.ete.value/60)*document.forms['totals'].gph.value).toFixed(1);
  cForm.course.value = (cForm.course.value/1000).toFixed(3).toString().substr(2);
  cForm.mag_hd.value = (cForm.mag_hd.value/1000).toFixed(3).toString().substr(2);
  cForm.compass.value = (cForm.compass.value/1000).toFixed(3).toString().substr(2);
  cForm.heading.value = (cForm.heading.value/1000).toFixed(3).toString().substr(2);
  cForm.windDir.value = (cForm.windDir.value/1000).toFixed(3).toString().substr(2);
  cForm.windSpd.value = (cForm.windSpd.value/100).toFixed(2).toString().substr(2);
  var disttotal=0;
  var etetotal=0;
  var fueltotal=0;
  for (var i=0; i<document.forms.length-1; i++){
  	disttotal+=parseFloat(document.forms[i].dist.value);
 	etetotal+=parseFloat(document.forms[i].ete.value);
 	fueltotal+=parseFloat(document.forms[i].fuel.value);
  }
  document.forms['totals'].disttotal.value=disttotal.toFixed(1);
  document.forms['totals'].etetotal.value=etetotal.toFixed(1);
  document.forms['totals'].fueltotal.value=fueltotal.toFixed(1);
  disttotal=0;
  etetotal=0;
  fueltotal=0;
  for (var i=0; i<document.forms.length-1; i++){
  	disttotal+=parseFloat(document.forms[i].dist.value);
 	etetotal+=parseFloat(document.forms[i].ete.value);
 	fueltotal+=parseFloat(document.forms[i].fuel.value);
	document.forms[i].dist_rem.value=(document.forms['totals'].disttotal.value-disttotal).toFixed(1);
	document.forms[i].ete_rem.value=etetotal.toFixed(1)+" | "+(document.forms['totals'].etetotal.value-etetotal).toFixed(1);
	document.forms[i].fuel_rem.value=(document.forms['totals'].fueltotal.value-fueltotal).toFixed(1);
  }
  cForm.origin.value=document.forms['cform0'].origin.value;
  cForm.o_desc.value=document.forms['cform0'].o_desc.value;
  cForm.submit();
}

function airportInfo(cForm){
	airporttext="";
	if (cForm.dest){
	switch(cForm.dest.value.toLowerCase()){
		case "keik":
			airporttext="CTAF: 123.0 ATIS: 133.825";
			break;
		case "kbjc":
			airporttext="CTAF: 118.6 GROUND: 121.7 ATIS: 126.25";
			break;
		case "klmo":
			airporttext="CTAF: 122.975 ATIS: 118.825";
			break;
		case "kfnl":
			airporttext="CTAF: 122.7 ATIS: 135.075";
			break;
	}
	cForm.ckpnt.value=cForm.dest.value.toUpperCase()+" "+airporttext;
	}
}

function addRow(tableID) {
 
            var table = document.getElementById(tableID);
 
            var rowCount = table.rows.length;
            var row = table.insertRow(rowCount);
 
            var colCount = table.rows[0].cells.length;
 
            for(var i=0; i<colCount; i++) {
 
                var newcell = row.insertCell(i);
 
                newcell.innerHTML = table.rows[1].cells[i].innerHTML;
                //alert(newcell.childNodes);
                switch(newcell.childNodes[0].type) {
                    case "text":
                            //newcell.childNodes[0].value = table.rows[1].cells[i].value;
                            break;
                    case "checkbox":
                            newcell.childNodes[0].checked = false;
                            break;
                    case "select-one":
                            newcell.childNodes[0].selectedIndex = 0;
                            break;
                }
            }
        }
 
        function deleteRow(tableID) {
            try {
            var table = document.getElementById(tableID);
            var rowCount = table.rows.length;
 
            for(var i=0; i<rowCount; i++) {
                var row = table.rows[i];
                var chkbox = row.cells[0].childNodes[0];
                if(null != chkbox && true == chkbox.checked) {
                    if(rowCount <= 1) {
                        alert("Cannot delete all the rows.");
                        break;
                    }
                    table.deleteRow(i);
                    rowCount--;
                    i--;
                }
 
 
            }
            }catch(e) {
                alert(e);
            }
        }

function savePlan(){
  for (var i=0; i<document.forms.length-1; i++){
    if (document.forms[i].name=='cForm1'){
	document.forms['totals'].serial.value=document.forms[i].serial.value+';;';
	document.forms['totals'].plan_id.value=document.forms[i].plan_id.value+';;';
  	document.forms['totals'].dest.value=document.forms[i].dest.value+';;';
  	document.forms['totals'].course.value=document.forms[i].course.value+';;';
  	document.forms['totals'].mvar.value=document.forms[i].mvar.value+';;';
  	document.forms['totals'].altstg.value=document.forms[i].altstg.value+';;';
  	document.forms['totals'].temp.value=document.forms[i].temp.value+';;';
  	document.forms['totals'].windDir.value=document.forms[i].windDir.value+';;';
  	document.forms['totals'].windSpd.value=document.forms[i].windSpd.value+';;';
  	document.forms['totals'].IA.value=document.forms[i].IA.value+';;';
  	document.forms['totals'].IAS.value=document.forms[i].IAS.value+';;';
  	document.forms['totals'].dist.value=document.forms[i].dist.value+';;';
  	document.forms['totals'].ckpnt.value=document.forms[i].ckpnt.value+';;';
  	//alert(document.forms['totals'].serial.value);
	}
  }
  document.forms['totals'].submit();
  //document.forms[i].submit();
}
 // -->
</SCRIPT>

<META name=GENERATOR content="Microsoft FrontPage 4.0"></HEAD>
<BODY topmargin="0" leftmargin="25" rightmargin="0">
<!--
<H2>TAS Calculator 
</h2>
<HR color=#c0c0c0 SIZE=1 noShade>
<FORM name=densalt>
<TABLE class=bvl>
  <TBODY>
  <TR>
    <TD class=shd colSpan=5><BIG><B>True-Air-Speed Calculator</B></BIG></TD></TR>
  <TR>
    <TD noWrap>Indicated Altitude</TD>
    <TD>:</TD>
    <TD><INPUT onfocus=this.select() onblur_=clearPA() onkeyup=compute() class=right name=IA value=5673 
      size=5></TD>
    <TD><INPUT onclick='fixunits("alt")' name=altunits value=0 CHECKED 
      type=radio> feet</TD>
    <TD><INPUT onclick='fixunits("alt")' name=altunits value=1 type=radio> 
      meters</TD></TR>
  <TR>
    <TD noWrap>Altimeter Setting</TD>
    <TD>:</TD>
    <TD><INPUT onfocus=this.select() onblur_=clearPA() onkeyup=compute() class=right tabIndex=2 name=altstg value=29.92 
      size=5></TD>
    <TD><INPUT onclick='fixunits("set")' name=setunits value=0 CHECKED 
      type=radio> inches</TD>
    <TD><INPUT onclick='fixunits("set")' name=setunits value=1 type=radio> 
    hPa</TD></TR>
  <TR>
    <TD noWrap>Temperature</TD>
    <TD>:</TD>
    <TD><INPUT onfocus=this.select() onblur_=clearDA() onkeyup=compute() class=right tabIndex=3 name=temp value=20 
      size=5></TD>
    <TD><INPUT onclick='fixunits("temp")' name=tempunits value=0 CHECKED 
      type=radio> °C</TD>
    <TD><INPUT onclick='fixunits("temp")' name=tempunits value=1 type=radio> 
    °F</TD></TR>
  <TR>
    <TD noWrap>Indicated/Calibrated Airspeed</TD>
    <TD>:</TD>
    <TD><INPUT onfocus=this.select() onblur_=clearIAS() onkeyup=compute() class=right tabIndex=3 name=IAS value=60 
      size=5></TD>
    <TD colSpan=2><SMALL>(KTS or MPH)</SMALL></TD></TR>
  <TR style="display:none">
    <TD colSpan=2></TD>
    <TD colSpan=3><INPUT tabIndex=4 onclick=compute() value=Calculate type=submit> 
    </TD>
  <TR>
    <TD colSpan=5>
      <HR color=#000000 noShade>
    </TD></TR>
  <TR>
    <TD noWrap>True Airspeed (TAS)</TD>
    <TD>:</TD>
    <TD colSpan=3><INPUT class=right name=TAS readOnly size=5></TD></TR>
  <TR>
    <TD noWrap>Pressure Altitude (PA)</TD>
    <TD>:</TD>
    <TD colSpan=3><INPUT class=right name=PA readOnly size=5></TD></TR>
  <TR>
    <TD noWrap>Density Altitude (DA)</TD>
    <TD>:</TD>
    <TD colSpan=3><INPUT class=right name=DA readOnly size=5></TD></TR>
</TBODY></TABLE><SMALL><U>Note:</U> Standard pressure is 
29.92126 inches at altitude 0.</SMALL> 
</form>
<a href="<%'=urllink%>" target="_blank">[LINK TO SKYVECTOR PLAN]</a><BR>
-->
<table cellpadding=0 cellspacing="0">
<tr>
<td><INPUT class=right value=wpt value=000 size=12 tabindex="-1">
<td><INPUT class=right value=tcourse value=000 size=5 style="width:100%" tabindex="-1"></td>
<!--<td><INPUT class=right value=IA value=5673 size=5>-->
<td><INPUT class=right value=windDir value=000 size=5 tabindex="-1">
<td><INPUT class=right value="BARO" value=altstg value=5673 size=5 tabindex="-1">
<td>
<INPUT class=right value=WCA value=0 size=5 tabindex="-1">
<td><INPUT class=right value=mvar value=-9 size=5 tabindex="-1">
<td><INPUT class=right value=mag_dev value=0 size=5 tabindex="-1">
<td><INPUT class=right value=alt value=000 size=5 tabindex="-1">
<td><INPUT class=right value="leg dist" value=0 size=5 tabindex="-1">
<td><INPUT class=right value=TAS value=0 size=5 tabindex="-1">
<td><INPUT class=right value=ete value=0 size=7 tabindex="-1">
<td><INPUT class=right value=fuel value=0 size=6 tabindex="-1">
</tr>
<tr>
<td>
<td>
<td><INPUT class=right value=windSpd value=00 size=5 tabindex="-1">
<td><INPUT class=right value="TEMP(C)" size=5 tabindex="-1">
<td><INPUT class=right value="heading" size=5 tabindex="-1">
<td><INPUT class=right value=mag_hd value=000 size=5 tabindex="-1">
<td>
<INPUT class=right value=compass value=000 size=5 tabindex="-1">
<td>
<INPUT class=right value=CAS value=5673 size=5 tabindex="-1">
<td>
<INPUT class=right value="dist rem" size=5>
<td><INPUT class=right value=GS value=0 size=5 tabindex="-1">
<td><INPUT class=right value="tt | etr" size=7>
<td><INPUT class=right value="fuel rem" size=6>
</tr>
<%
'origin="kbjc"
'o_desc="KBJC 5673 CTAF: 118.6 GROUND: 121.7 ATIS: 126.25"
serial="INSERT"
%>
</table>
<table cellpadding=0 cellspacing="0" width="618" height="26">
<%
count=0
bookmark=1
do while not rs1.eof or count=0
count=count+1
if not rs1.eof then
	serial=rs1("serial")
	dest=rs1("dest")
	course=rs1("course")
	mvar=rs1("mvar")
	altstg=rs1("altstg")
	temp=rs1("temp")
	windDir=rs1("windDir")
	windSpd=rs1("windSpd")
	IA=rs1("IA")
	IAS=rs1("IAS")
	dist=rs1("dist")
	ckpnt=rs1("ckpnt")
	bookmark=rs1.bookmark
else
	serial="INSERT"
	dest=""
	course="000"
	mvar=-9
	altstg=29.92
	temp=15
	windDir="000"
	windSpd="00"
	IA=5673
	IAS=60
	dist=0
	ckpnt=""
end if
if rs1.eof or bookmark=1 then
%>
<form name=foo action="" method="POST">
<input type="hidden" name="serial" value="<%=serial%>">
<input type="hidden" name="plan_id" value="<%=plan_id%>">
<input type="hidden" name="origin" value="null">
<input type="hidden" name="o_desc" value="null">
<input type="hidden" name="windDir" value="null">
<input type="hidden" name="temp" value="null">
<input type="hidden" name="altstg" value="29.92">
<input type="hidden" name="course" value="null">
<input type="hidden" name="IA" value="null">
<input type="hidden" name="mvar" value="null">
<input type="hidden" name="windSpd" value="null">
<input type="hidden" name="dist" value="null">
<input type="hidden" name="IAS" value="null">
<tr>
<td colspan=2 valign="top" width="76" height="1">
    <INPUT onfocus=this.select() onchange=saveForm(this.form) class=right name="dest" value="<%=dest%>" size=9 style="width: 100; color: blue; height: 20">
<td colspan="11" height="1" valign="top">
<input class=right name="ckpnt" value="<%=ckpnt%>" size=5 onchange="saveForm(this.form)" style="width: 602; text-align: right; font-weight: bold; font-size: 11pt; text-transform: uppercase; height: 20" tabindex="">
</tr>

</form>
<%
end if
response.write "<span id=""cForm"">"

if rs1.eof then 
%>
<tr>
<td colspan=3>
Enter an origin to create a new plan.
<%
response.end
end if
'response.write count


%>
<form name=cForm1 action="" method="post" target="submitframe">
<input type="hidden" name="serial" value="<%=serial%>">
<input type="hidden" name="plan_id" value="<%=plan_id%>">
<input type="hidden" name="origin" value="">
<input type="hidden" name="o_desc" value="">
<tr>
<td valign="bottom" width="89" height="53" colspan="2">
<td width="47" height="53">
<INPUT onfocus=this.select() onclick=this.select() onchange="calcPlan(this.form);savePlan()" 
class=right name=course value="<%=course%>" size=5 style="color:blue;border-color:white;">
<td width="43" height="53">
<INPUT onfocus=this.select() onclick=this.select() on_keyup="calcPlan(this.form)" 
onchange="calcPlan(this.form);savePlan()" class=right name=windDir value="<%=windDir%>" 
size=5 style="color:blue;border-color:white;"><INPUT onfocus=this.select() 
onclick=this.select() on_keyup="calcPlan(this.form)" onchange="calcPlan(this.form);savePlan()" 
class=right name=windSpd value="<%=windSpd%>" size=5 style="color:blue;border-color:white;">
<td width="43" height="53">
<INPUT onfocus=this.select() onclick=this.select() on_keyup=calcPlan(this.form) 
onchange="populateDown(<%=count%>,this.name,this.value);calcPlan(this.form);savePlan()" class=right name=altstg value="<%=altstg%>" 
size=5 style="color:blue;border-color:white"><INPUT onfocus=this.select() onclick=this.select() 
on_keyup="calcPlan(this.form)" onchange="populateDown(<%=count%>,this.name,this.value);calcPlan(this.form);savePlan()" class=right name=temp 
value="<%=temp%>" size=5 style="color:blue;border-color:white;">
<td width="43" height="53">
<INPUT onfocus=this.select() onclick=this.select() on_keyup=calcPlan(this.form) 
onchange="calcPlan(this.form);savePlan()" class=right name=WCA value=0 size=5 tabindex="-1" 
style="border-color:white;"><INPUT onfocus=this.select() onclick=this.select() 
on_keyup=calcPlan(this.form) onchange="calcPlan(this.form);savePlan()" class=right name=heading 
value=000 size=5 tabindex="-1" style="border-color:white;">
<td width="43" height="53">
<INPUT onfocus=this.select() onclick=this.select() on_keyup=calcPlan(this.form) 
onchange="calcPlan(this.form);savePlan()" class=right name=mvar value="<%=mvar%>" size=5 
tabindex="" style="color:blue;border-color:white;"><INPUT onfocus=this.select() onclick=this.select() 
on_keyup=calcPlan(this.form) onchange="calcPlan(this.form);savePlan()" class=right name=mag_hd 
value=000 size=5 tabindex="-1" style="border-color:white;">
<td width="43" height="53">
<INPUT onfocus=this.select() onclick=this.select() on_keyup=calcPlan(this.form) 
onchange="calcPlan(this.form);savePlan()" class=right name=mag_dev value=0 size=5 tabindex="-1" 
style="position:relative;top:4;border-color:white;"><INPUT onfocus=this.select() 
onclick=this.select() on_keyup=calcPlan(this.form) onchange="calcPlan(this.form);savePlan()" 
class=right name=compass value=000 size=0 tabindex="-1" 
style="width:100%;font-size:14pt;font-weight:bold;border-color:white">
<td width="46" height="53">
<INPUT onfocus=this.select() onclick=this.select() on_keyup="calcPlan(this.form)" 
onchange="populateDown(<%=count%>,this.name,this.value);calcPlan(this.form);savePlan()" 
class=right name=IA value="<%=IA%>" size=5 style="color:blue;border-color:white;"><INPUT 
onfocus=this.select() onclick=this.select() on_keyup=calcPlan(this.form) 
onchange="populateDown(<%=count%>,this.name,this.value);calcPlan(this.form);savePlan()" class=right name=IAS value="<%=IAS%>" size=5 
style="color:blue;border-color:white">
<td width="43" height="53">
<INPUT onfocus=this.select() onclick=this.select() on_keyup=calcPlan(this.form) 
onchange="calcPlan(this.form);savePlan()" class=right name=dist value="<%=dist%>" size=5 
style="color:blue;border-color:white;"><INPUT onfocus=this.select() onclick=this.select() 
on_keyup=calcPlan(this.form) onchange="calcPlan(this.form);savePlan()" class=right 
name=dist_rem value=0 size=5 tabindex="-1" style="border-color:white;">
<td width="43" height="53">
<INPUT onfocus=this.select() onclick=this.select() on_keyup=calcPlan(this.form) 
onchange="calcPlan(this.form);savePlan()" class=right name=TAS value=0 size=5 tabindex="-1" 
style="border-color:white;"><INPUT onfocus=this.select() onclick=this.select() 
on_keyup=calcPlan(this.form) onchange="calcPlan(this.form);savePlan()" class=right name=GS 
value=0 size=5 tabindex="-1" style="border-color:white;">
<td width="57" height="53">
<INPUT onfocus=this.select() onclick=this.select() on_keyup=calcPlan(this.form) 
onchange="calcPlan(this.form);savePlan()" class=right name=ete value=0 size=7 tabindex="-1" 
style="border-color:white;text-align:right;"><INPUT onfocus=this.select() onclick=this.select() 
on_keyup=calcPlan(this.form) onchange="calcPlan(this.form);savePlan()" class=right name=ete_rem 
value=0 size=7 tabindex="-1" style="border-color:white;text-align:right;">
<td width="54" height="53">
<INPUT onfocus=this.select() onclick=this.select() on_keyup=calcPlan(this.form) 
onchange="calcPlan(this.form);savePlan()" class=right name=fuel value=0 size=5 tabindex="-1" 
style="border-color:white;text-align:right;"><INPUT onfocus=this.select() onclick=this.select() 
on_keyup=calcPlan(this.form) onchange="calcPlan(this.form);savePlan()" class=right 
name=fuel_rem value=0 size=5 tabindex="-1" style="border-color:white;text-align:right;">
</tr>
<tr>
<%if serial="INSERT" then%>
<td valign="middle" width="13" height="1" align="center">
    <b><a href="?del=<%=serial%>&amp;id=<%=plan_id%>" style="text-decoration:none"><font size="4" color="#FF0000">X</font></a> </b>
<td valign="top" width="76" height="1">
    <INPUT onfocus=this.select() onchange=airportInfo(this.form) class=right name="dest" value="<%=dest%>" size=9 style="width: 84; color: blue; height: 20">
<td colspan="11" height="1" valign="top" width="525">
<input class=right name="ckpnt" value="<%=ckpnt%>" size=5 onchange="savePlan()" style="width: 602; text-align: right; font-weight: bold; font-size: 11pt; text-transform: uppercase; height: 20" tabindex="-1">
<%else%>
<td colspan=2 valign="top" width="76" height="1">
    <INPUT onfocus=this.select() onchange=airportInfo(this.form) class=right name="dest" value="<%=dest%>" size=9 style="width: 100; color: blue; height: 20">
<td colspan="11" height="1" valign="top" width="525">
<input class=right name="ckpnt" value="<%=ckpnt%>" size=5 onchange="saveForm(this.form)" style="width: 602; text-align: right; font-weight: bold; font-size: 11pt; text-transform: uppercase; height: 20" tabindex="">
<%end if%>
</tr>
</FORM>
<%
if bookmark=1 then response.write "</span>"
bookmark=bookmark+1
if not rs1.eof then rs1.movenext
loop
%>
</table>
<span id="blankForm"></span>
<table cellpadding=0 cellspacing="0" width="603">
<form name="totals" action="" method="post" target="submitframe">
<input type="hidden" name="serial">
<input type="hidden" name="plan_id">
<input type="hidden" name="dest">
<input type="hidden" name="course">
<input type="hidden" name="mvar">
<input type="hidden" name="altstg">
<input type="hidden" name="temp">
<input type="hidden" name="windDir">
<input type="hidden" name="windSpd">
<input type="hidden" name="IA">
<input type="hidden" name="IAS">
<input type="hidden" name="dist">
<input type="hidden" name="ckpnt">
<input type="hidden" name="origin">
<input type="hidden" name="o_desc">
<tr>
<td width="92"><INPUT class=right style="border-color:white" value="" size=12>
<td width="43"><INPUT class=right style="border-color:white" value="" size=5>
<td width="43"><INPUT class=right style="border-color:white" value="" size=5>
<td width="43"><INPUT class=right style="border-color:white" value="" size=5>
<td width="43"><INPUT class=right style="border-color:white" value="GPH:" size=5 name="label1">
<td width="43"><INPUT class=right value="15" size=5 name="gph" onfocus="this.select()" onkeyup="updatePlan()">
<td width="40"><INPUT class=right style="border-color:white" value="" size=4>
<td width="45"><INPUT class=right style="border-color:white" value="total:" size=5>
<td width="44"><INPUT class=right name="disttotal" value="0" size=5>
<td width="44"><INPUT class=right style="border-color:white" value="totals:" size=5>
<td width="57"><INPUT class=right name="etetotal" value="0" size=7 style="text-align: Right">
<td width="45"><INPUT class=right name="fueltotal" value="0" size=6 style="text-align: Right">
</tr>
</form>
</table>
<input type="button" value="Add leg" onclick="document.all['blankForm'].innerHTML+=document.all['cForm'].innerHTML;document.forms[document.forms.length-2].serial.value='INSERT';savePlan();self.location.reload()">
<input type="button" id="savebutton" value="Save" onclick="savePlan();this.disabled=true;">
<input type="button" id="revbutton" value="Reverse" onclick="document.submitframe.location='?id=<%=request("id")%>&action=reverse';//this.disabled=true;">
<br>
<iframe name="submitframe" style="display:none;height:200px;width:400px"></iframe>
</BODY>
<script deferred>
function updatePlan(){
  for (var i=0; i<document.forms.length-1; i++){
    if (document.forms[i].name=='cForm1'){
     calcPlan(document.forms[i]);
     }
  }
}

updatePlan();

function populateDown(index,field,fvalue){
  for (var i=index+1; i<document.forms.length-1; i++){
    if (document.forms[i].name=='cForm1'){
     document.forms[i].elements[field].value=fvalue;
     }
  }
}
</script>