<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body style="background-color: #fff333;">

<% 
// Get customer id
//TO-DO check password and username instead of id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (custId == null || custId.isEmpty()) {
	out.println("Error Customer ID is Required");
} else if (productList == null || productList.isEmpty()) {
	out.println("Error Shopping Cart is Empty");
} else if (!custId.matches("\\d+")) {
	out.println("Error Customer ID Must Be A Number");
} else {
	String url = "jdbc:sqlserver://c-jhatstore.database.windows.net:1433;"
           + "databaseName=CJ Hat Store;"
           + "encrypt=true;"
           + "trustServerCertificate=true;"; // safe for testing

	String user = "cjadmin@c-jhatstore";   // include server name
	String pw = "$HD*(*&BCVIUOI!@#hoiqe23PPOWWD"; 

	try (Connection con = DriverManager.getConnection(url, user, pw)) {
		String idisindb = "SELECT count(customerId) FROM customer WHERE customerId = ?"; //SQL to find if the customer is in the DB
		PreparedStatement ps = con.prepareStatement(idisindb);
		ps.setInt(1, Integer.parseInt(custId)); 
		ResultSet rs = ps.executeQuery();
    	rs.next(); // move to first (and only) row

   		 if (rs.getInt(1) == 0) {
			out.println("Error Customer ID " + custId + " Not Found");
		} else {
		
		// Save order information to database
		String insertsql = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), 0)";
		PreparedStatement pstmt = con.prepareStatement(insertsql, Statement.RETURN_GENERATED_KEYS);
		pstmt.setInt(1, Integer.parseInt(custId));
		pstmt.executeUpdate();

		ResultSet keys = pstmt.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);

		double totalAmount = 0.0;

		String insertProductsql = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
		PreparedStatement pstmt1 = con.prepareStatement(insertProductsql);

		out.println("<h1>Your Order Summary</h1>");
		out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		while (iterator.hasNext())
		{ // Insert each item into OrderProduct table using OrderId from previous INSERT
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
			String productName = (String) product.get(1);
        	String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ( (Integer)product.get(3)).intValue();

			pstmt1.setInt(1, orderId);
			pstmt1.setString(2, productId);
			pstmt1.setInt(3, qty);
			pstmt1.setDouble(4, pr);
			pstmt1.executeUpdate();

			//printing the summary for each line
			out.println("<tr><td>" + productId + "</td><td>" + productName + "</td><td>" + qty + "</td><td>" + NumberFormat.getCurrencyInstance().format(pr) + "</td><td>" + NumberFormat.getCurrencyInstance().format(qty*pr) + "</td></tr>");	

			totalAmount += pr * qty;
		}
		out.println("<tr><th><th><th></th><th>Order Total</th><td>" + NumberFormat.getCurrencyInstance().format(totalAmount) + "</td></tr></table>");
		// Update total amount for order record
		String updatesql = "UPDATE ordersummary SET totalAmount = ? WHERE orderId=?";
		PreparedStatement pstmt2 = con.prepareStatement(updatesql);
		pstmt2.setDouble(1, totalAmount);
		pstmt2.setInt(2, orderId);
		pstmt2.executeUpdate();


		out.println("<h2>Order Placed Successfully!</h2>");
		out.println("<p>Order ID: " + orderId + "<br>");
		out.println("Total Amount: " + NumberFormat.getCurrencyInstance().format(totalAmount) + "</p>");

		session.removeAttribute("productList"); //clears the shopping cart
		
		ps.close();
		pstmt.close();
		pstmt1.close();
		pstmt2.close();
		rs.close();
		keys.close();
		}

	} catch (SQLException e) {
		out.println("Exception: " + e);
	}
	
}


// Print out order summary


%>
</BODY>
</HTML>

