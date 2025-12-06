<%@ page import="java.sql.*, javax.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
String name = request.getParameter("productName");
String price = request.getParameter("productPrice");
String desc = request.getParameter("productDesc");
String cat = request.getParameter("categoryId");

try {
    getConnection(); // from jdbc.jsp

    String sql = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, name);
    pstmt.setBigDecimal(2, new java.math.BigDecimal(price));
    pstmt.setString(3, desc);
    pstmt.setInt(4, Integer.parseInt(cat));

    pstmt.executeUpdate();

    out.println("<h2>Product Added Successfully!</h2>");
    out.println("<a href='addProduct.jsp'>Add Another Product</a>");
    out.println(" | <a href='admin.jsp'>Back to Admin Page</a>");
    pstmt.close();
    con.close();
} catch (Exception e) {
    out.println("<h2>Error: " + e.getMessage() + "</h2>");
    out.println("<a href='addProduct.jsp'>Back</a>");
}
%>