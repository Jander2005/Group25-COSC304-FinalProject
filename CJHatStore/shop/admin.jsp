<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body style="background-color: #fff333;">

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%

// TODO: Write SQL query that prints out total order amount by day
try 
		{
			getConnection();
            String sql = "SELECT CONVERT(date,orderDate) as orderDay, SUM(totalAmount) AS totalSales FROM ordersummary GROUP BY CONVERT(date, orderDate) ORDER BY orderDay DESC";
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(sql);



            
            out.println("<h1>Daily Sales Report</h1>");
            out.println("<table border='1' style=\"background-color: #FFFF88; color: black; border: 1px solid #3399FF;\"><tr><th>Order Date</th><th>Total Sales</th></tr>");
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            while (rs.next()) {
                Date orderDate = rs.getDate("orderDay");
                double totalSales = rs.getDouble("totalSales");
                out.println("<tr><td>" + orderDate + "</td><td>" + currFormat.format(totalSales) + "</td></tr>");
            }
            out.println("</table>");
        }
        catch (SQLException ex) {
            out.println(ex);
        }

%>

<a href="addProduct.jsp"
   style="
       display: inline-block;
       margin: 40px auto;
       font-size: 40px;
       padding: 12px 22px;
       background-color: #5b5c3d;
       color: white;
       font-weight: bold;
       text-decoration: none;
       border-radius: 8px;
       box-shadow: 0 4px 10px rgba(0,0,0,0.2);
       text-align: center;
   ">
    + Add New Product
</a>
<br><br>

</body>
</html>

