<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body style="background-color: #fff333;">

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!


String url = "jdbc:sqlserver://c-jhatstore.database.windows.net:1433;"
           + "databaseName=CJ Hat Store;"
           + "encrypt=true;"
           + "trustServerCertificate=true;"; // safe for testing

String user = "cjadmin@c-jhatstore";   // include server name
String pw = "$HD*(*&BCVIUOI!@#hoiqe23PPOWWD";
// Make the connection
try (Connection con = DriverManager.getConnection(url, user, pw)){
	PreparedStatement pstmt;
	if (name == null || name.isEmpty())
		pstmt = con.prepareStatement("SELECT productId, productName, productPrice FROM product");
	else{
		pstmt = con.prepareStatement("SELECT productId, productName, productPrice FROM product WHERE productName LIKE ?");
		pstmt.setString(1, "%" + name + "%");	
	}
	ResultSet rst = pstmt.executeQuery();
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

// Print out the ResultSet

	
	out.println("<table border=\"1\" style=\"background-color: #FFFF88; color: black; border: 1px solid #3399FF;\"><tr><th></th><th>Product Name</th><th>Price</th></tr>");
	while(rst.next()){
		int pid = rst.getInt("productId");
		String pname = rst.getString("productName");
		double price = rst.getDouble("productPrice");
		// For each product create a link of the form addcart.jsp?id=productId&name=productName&price=productPrice
		String link = "<a href=\"addcart.jsp?id=" + pid + "&amp;name=" + URLEncoder.encode(pname, "UTF-8") + "&amp;price=" + price + "\">Add to Cart</a>";
		String detailsLink = "<a href=\"product.jsp?id=" + pid + "\">" + pname + "</a>";
		out.println("<tr><td>" + link + "</td><td>" + detailsLink + "</td><td>" + currFormat.format(price) + "</td></tr>");
	}
	out.println("</table>");
	rst.close();
	pstmt.close();
}
catch (SQLException ex)
{
	out.println("SQLException: " + ex);
}
// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>