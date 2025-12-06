<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body style="background-color: #fff333;">

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// TODO: Print Customer information
String url = "jdbc:sqlserver://c-jhatstore.database.windows.net:1433;"
           + "databaseName=CJ Hat Store;"
           + "encrypt=true;"
           + "trustServerCertificate=true;"; // safe for testing

String user = "cjadmin@c-jhatstore";   // include server name
String pw = "$HD*(*&BCVIUOI!@#hoiqe23PPOWWD";
String sql = "SELECT * FROM customer WHERE userid = ?";

// Make the connection
try (Connection con = DriverManager.getConnection(url, user, pw); PreparedStatement pstmt = con.prepareStatement(sql)){
	pstmt.setString(1, userName);
	ResultSet rst = pstmt.executeQuery();
	rst.next();

	String customerId = rst.getString("customerId");
	String firstName = rst.getString("firstName");
	String lastName = rst.getString("lastName");
	String email = rst.getString("email");
	String phonenum = rst.getString("phonenum");
	String address = rst.getString("address");
	String city = rst.getString("city");
	String state = rst.getString("state");
	String postalCode = rst.getString("postalCode");
	String country = rst.getString("country");
	String userid = rst.getString("userid");


	out.println("<table border=\"1\", style=\"background-color: #FFFF88; color: black; border: 1px solid #3399FF;\"><tr><th>CustomerId</th><td>" + customerId + "</td></tr>");
	out.println("<tr><th>First Name</th><td>" + firstName + "</td></tr>");
	out.println("<tr><th>Last Name</th><td>" + lastName + "</td></tr>");
	out.println("<tr><th>Email</th><td>" + email + "</td></tr>");
	out.println("<tr><th>Phone Number</th><td>" + phonenum + "</td></tr>");
	out.println("<tr><th>Address</th><td>" + address + "</td></tr>");
	out.println("<tr><th>City</th><td>" + city + "</td></tr>");
	out.println("<tr><th>State</th><td>" + state + "</td></tr>");
	out.println("<tr><th>Postal Code</th><td>" + postalCode + "</td></tr>");
	out.println("<tr><th>Country</th><td>" + country + "</td></tr>");
	out.println("<tr><th>User Id</th><td>" + userid + "</td></tr></table>");

	
	rst.close();	
	}	
catch (SQLException ex)
{
	out.println("SQLException: " + ex);
}
// Make sure to close connection
%>

</body>
</html>

