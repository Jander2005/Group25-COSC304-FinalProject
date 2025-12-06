<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order List</title>
</head>
<body style="background-color: #fff333;">

<h1>Order List</h1>

<%
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}


String url = "jdbc:sqlserver://c-jhatstore.database.windows.net:1433;"
           + "databaseName=CJ Hat Store;"
           + "encrypt=true;"
           + "trustServerCertificate=true;"; // safe for testing

String user = "cjadmin@c-jhatstore";   // include server name
String pw = "$HD*(*&BCVIUOI!@#hoiqe23PPOWWD";

try ( Connection con = DriverManager.getConnection(url, user, pw);
	Statement stmt = con.createStatement()){
	
	
	ResultSet rst = stmt.executeQuery("SELECT orderId, orderDate, customer.customerId, firstName, totalAmount FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId"); 
	
	String detailsQuery = "SELECT product.productId, productName, quantity, price FROM orderproduct JOIN product On orderproduct.productId = product.productId WHERE orderId = ?"; 
	PreparedStatement pstmt = con.prepareStatement(detailsQuery);
	
	out.println("<table border=\"1\", style=\"background-color: #FFFF88; color: black; border: 1px solid #3399FF;\">");
	out.println("<tr><th>Order ID</th><th>Order Date</th><th>Customer ID</th><th>Customer Name</th><th>Total Amount</th></tr>");
	while (rst.next()) {
		int orderId = rst.getInt("orderId");
		Date orderDate = rst.getDate("orderDate");
		int customerId = rst.getInt("customerId");
		String firstName = rst.getString("firstName");
		double totalAmount = rst.getDouble("totalAmount");
		
		out.println("<tr><td>" + orderId + "</td><td>" + orderDate + "</td><td>" +
                    customerId + "</td><td>" + firstName + "</td><td>" +
                    NumberFormat.getCurrencyInstance().format(totalAmount) + "</td></tr>");

		pstmt.setInt(1, orderId);
		ResultSet detailSet = pstmt.executeQuery();

		out.println("<tr align = 'right'><td colspan = '4'><table border=\"1\", style=\"background-color: #FFFF88; color: black; border: 1px solid #3399FF;\">");
        out.println("<tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th></tr>");
        while (detailSet.next()) {
			int productId = detailSet.getInt("productId");
			String productName = detailSet.getString("productName");
			int quantity = detailSet.getInt("quantity");
			double price = detailSet.getDouble("price");
			
			out.println("<tr><td>" + productId + "</td><td>" + productName + "</td><td>" + quantity + "</td><td>" + NumberFormat.getCurrencyInstance().format(price) + "</td></tr>");
        }
		out.println("</table></td></tr>");

		detailSet.close();
	}

	out.println("</table>");
	pstmt.close();
	stmt.close();
	con.close();

} catch (SQLException ex) {
	out.println("SQLException: " + ex);
	}
%>

</body>
</html>