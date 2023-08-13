<!-- #include file="sqlencode.xinc"-->
<%
response.write "<code>"
if request.form="" then
	set form=request.querystring
else
	set form=request.form
end if

%>
-----------FIELDS AND VALUES<BR>
<%
i=0
for each x in form
	response.write x & "=" & sqlencode(trim(form(x))) & " (" & form(x)& ")<BR>"
	if i>0 then url = url & "&"
	url = url & x & "=" & form(x)
	i=i+1
next

%>
<hr>
-----------QUERY STRING<BR>
<%=url%>
<hr>
-----------UPDATE QUERY<BR>
sql = "UPDATE {TABLE} SET "<BR>
<%
i=1
for each x in form
	response.write "sql = sql & """
	if i>1 then response.write ","
	response.write "[" & x & "]="" & sqlencode(trim(request(""" & x & """)))<BR>"
	i=i+1
next
%>
sql = sql & " WHERE {field}={criteria}" <hr>
-----------INSERT QUERY<BR>
sql = "INSERT INTO {TABLE} ("<BR>
<%
i=1
for each x in form
	response.write "sql = sql & """
	if i>1 then response.write ","
	response.write "[" & x & "]""<BR>"
	i=i+1
next
%>
sql = sql & ") VALUES ("<BR>
<%
i=1
for each x in form
	response.write "sql = sql & "
	if i>1 then response.write ""","" & "
	response.write "sqlencode(trim(request(""" & x & """)))<BR>"
	i=i+1
next
%>
sql = sql & ")"<BR>
<%
if i<1 then response.write "NO FORM RESULTS"
%>
