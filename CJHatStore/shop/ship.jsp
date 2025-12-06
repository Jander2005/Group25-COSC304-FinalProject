<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>C&J's Tasty Hats Shipment Processing</title>
</head>
<body style="background-color: #fff333;">
        
<%@ include file="header.jsp" %>

<%



	//Get order id
    String orderId = request.getParameter("orderId");

	String url = "jdbc:sqlserver://c-jhatstore.database.windows.net:1433;"
           + "databaseName=CJ Hat Store;"
           + "encrypt=true;"
           + "trustServerCertificate=true;"; // safe for testing

	String user = "cjadmin@c-jhatstore";   // include server name
	String pw = "$HD*(*&BCVIUOI!@#hoiqe23PPOWWD";
	String sql = "SELECT Count(*) FROM ordersummary WHERE orderId = ?"; //sql to check if order is in database
	
	try (Connection con = DriverManager.getConnection(url, user, pw); PreparedStatement pstmt = con.prepareStatement(sql);){
		pstmt.setString(1, orderId);
		ResultSet rst = pstmt.executeQuery();
		rst.next();
		int isValid = rst.getInt(1);

		//if order is not in database, print error and stop the rest
		if(isValid>0){
			// Start a transaction (turn-off auto-commit)
			con.setAutoCommit(false);

			//code to insert into shipments relation
			String sqlInsertShipment = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (?, ?, ?)";
			PreparedStatement psShipment = con.prepareStatement(sqlInsertShipment);

			psShipment.setTimestamp(1, new java.sql.Timestamp(System.currentTimeMillis()));
			psShipment.setString(2, "Shipment for order " + orderId);
			psShipment.setInt(3, 1);  // warehouseId = 1 (as your assignment states)

			psShipment.executeUpdate();

			String sql1 = "SELECT * FROM orderproduct WHERE orderId = " + orderId;
			Statement stmt = con.createStatement();
			Statement stmt2 = con.createStatement();
			Statement stmt3 = con.createStatement();
			
			//Retrieve all items in order with given id
			ResultSet products = stmt.executeQuery(sql1);
			ResultSet productInventory;

			String productId;
			int inventory = 0;
			int quantity = 0;
			int newTotal = 0;

			while(products.next()){ //loop to try to order each product in the order
				productId = products.getString("productId");
				quantity = products.getInt("quantity");
				String sql2 = "SELECT quantity FROM productinventory WHERE productId = " + productId;
				productInventory = stmt2.executeQuery(sql2);
				productInventory.next();
				inventory = productInventory.getInt("quantity");

				newTotal = inventory - quantity;
				//If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
				if (newTotal < 0){
					con.rollback();
					out.println("<h1>Shipment not done. Not enough inventory for product id: " + productId + "</h1>");
					break;
				}else{
					out.println("<h2>Ordered product: " + productId + " Qty: " + quantity + " Previous Inventory: " + inventory + " New Inventory: " + newTotal + "</h2>");
					stmt3.execute("UPDATE productinventory SET quantity = " + newTotal + " WHERE productId = " + productId);
				}
			}
			//verify if transaction was completed or not
			if (newTotal >= 0){
				con.commit();
				out.println("<h1>Shipment successfully processed.</h1>");
			}
			// Auto-commit should be turned back on

			con.setAutoCommit(true);

		}else{
			out.println("order is not in database");
		}
	}catch(SQLException ex){
		out.println("SQLException: " + ex);
	}
	
%>                       				

<h2><a href="index.jsp">Back to Main Page</a></h2>

</body>
</html>
