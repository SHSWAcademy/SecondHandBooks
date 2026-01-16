<%@ page isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
	<title>Error 500</title>
</head>
<body>
<h1>Internal Server Error</h1>
<h2>Exception Details:</h2>
<pre>
Type: <%= exception != null ? exception.getClass().getName() : "No exception" %>
Message: <%= exception != null ? exception.getMessage() : "No message" %>

Stack Trace:
<% if (exception != null) {
    java.io.StringWriter sw = new java.io.StringWriter();
    java.io.PrintWriter pw = new java.io.PrintWriter(sw);
    exception.printStackTrace(pw);
    out.println(sw.toString());
} %>
</pre>

<!--
<h1>
Your computer is under control of an attacker.
</h1>
<br>
<h5>The following is Morse code.</h5>
<br>
<h5>
-.-- --- ..- .-.   -.-. --- -- .--. ..- - . .-.   .... .- ...   -... . . -.   -.-. --- -- .--. .-. --- -- .. ... . -..
</h5>
-->

</body>
</html>
