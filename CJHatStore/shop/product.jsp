<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.util.HashMap, java.text.NumberFormat, java.net.URLEncoder, java.sql.*" %>


<html>
<head>
<title>C&J's Tasty Hats - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background-color: #fff333;">


<%@ include file="header.jsp" %>

<%
String productId = request.getParameter("id");
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

String sql = "SELECT productId, productName, productPrice, productImageURL, productImage, productDesc from product where productId = ?";
String url = "jdbc:sqlserver://c-jhatstore.database.windows.net:1433;"
           + "databaseName=CJ Hat Store;"
           + "encrypt=true;"
           + "trustServerCertificate=true;"; // safe for testing

String user = "cjadmin@c-jhatstore";   // include server name
String pw = "$HD*(*&BCVIUOI!@#hoiqe23PPOWWD"; 

try (Connection con = DriverManager.getConnection(url, user, pw);
    PreparedStatement pstmt = con.prepareStatement(sql)) {
        pstmt.setInt(1, Integer.parseInt(productId));
        ResultSet result = pstmt.executeQuery();

        if(result.next()){
            int pid = result.getInt("productId");
            String name = result.getString("productName");
            String desc = result.getString("productDesc");
            String price = result.getString("productPrice");
            String imageURL = result.getString("productImageURL");
            byte[] imgData = result.getBytes("productImage");

            out.println("<h2 align='center'>" + name + "</h2>");
            out.println("<p align='center'>Price: $" + price + "</p>");
            out.println("<p align='center'>" + desc + " to wear on your head!</p>");

            if(imageURL != null && !imageURL.isEmpty()){
                out.println("<p class='text-center'><img src='" + imageURL + "' class='img-fluid'/></p>");
            }
            if(imgData != null){
                out.println("<p class='text-center'><img src='displayImage.jsp?id=" + productId + "'/></p>");
            }
            String link = "<a href=\"addcart.jsp?id=" + pid + "&amp;name=" + URLEncoder.encode(name, "UTF-8") + "&amp;price=" + price + "\">Add to Cart</a>";
		    out.println("<p align='center'>" + link + "</p>");
            
            String shopLink = "<a href=\"listprod.jsp\">Continue Shopping </a>";
            out.println("<p align='center'>" + shopLink + "</p>");
        }

    } catch (Exception e) {
    out.println("Error: " + e.getMessage());
}

%>

</body>
</html>

