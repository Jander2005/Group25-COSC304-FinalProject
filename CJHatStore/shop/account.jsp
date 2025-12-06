<!DOCTYPE html>
<html>
<head>
<title>C&J's Tasty Accounts</title>
</head>
<body style="background-color: #fff333;">
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%
    String userName = (String) session.getAttribute("authenticatedUser");
%>

<h1 style="text-align: center; font-family: cursive; font-size: 50px;">Welcome <%=userName%></h1>

<%
try
    {
    getConnection();
    String sql = "SELECT orderDate, totalAmount FROM ordersummary WHERE customerID = (SELECT customerId FROM customer WHERE firstname = ?)";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, userName);
    ResultSet rs = pstmt.executeQuery();

    out.println("<h2>Your Order History:</h2>");
    out.println("<table border='1' style=\"background-color: #FFFF88; color: black; border: 1px solid #3399FF;\"><tr><th>Order Date</th><th>Total Amount</th></tr>");
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    while (rs.next()) {
        Date orderDate = rs.getDate("orderDate");
        double totalAmount = rs.getDouble("totalAmount");
        out.println("<tr><td>" + orderDate + "</td><td>" + currFormat.format(totalAmount) + "</td></tr>");
    }
    out.println("</table>");
    con.close();
}
catch (SQLException ex) {
    out.println(ex);
}

    


%>

<h2>Account Settings</h2>
    <form action="changeUsername.jsp" method="post" style="margin-bottom:20px;">
        <label for="newUsername">New Username:</label>
        <input type="text" id="newUsername" name="newUsername" required>
        <input type="submit" value="Change Username">
    </form>

    <form action="changePassword.jsp" method="post">
        <label for="currentPassword">Current Password:</label>
        <input type="password" id="currentPassword" name="currentPassword" required><br><br>
        <label for="newPassword">New Password:</label>
        <input type="password" id="newPassword" name="newPassword" required>
        <input type="submit" value="Change Password">
    </form>
    
    <form action="index.jsp" method="post">
        <input type="submit" value="Back to Home">
    </form>

</body>
</html>

