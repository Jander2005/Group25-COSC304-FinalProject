<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body style="background-color: #fff333;">



<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp"%>

<%
    String currentUser = (String) session.getAttribute("authenticatedUser");
    String newUsername = request.getParameter("newUsername");
    
    try {
        getConnection();
        String checkSql = "SELECT COUNT(*) FROM customer WHERE userid = ?";
        PreparedStatement checkPstmt = con.prepareStatement(checkSql);
        checkPstmt.setString(1, newUsername); 
        ResultSet checkRs = checkPstmt.executeQuery();
        checkRs.next();
        int count = checkRs.getInt(1);
        checkRs.close();
        checkPstmt.close();

        if (count > 0) {
            out.println("Error: Username '" + newUsername + "' is already taken. Please choose a different username.");
        } else {
            String updateSql = "UPDATE customer SET userid = ? WHERE userid = ?";
            PreparedStatement updatePstmt = con.prepareStatement(updateSql);
            updatePstmt.setString(1, newUsername);
            updatePstmt.setString(2, currentUser);
            int rowsAffected = updatePstmt.executeUpdate();
            updatePstmt.close();

            if (rowsAffected > 0) {
                session.setAttribute("authenticatedUser", newUsername);
                out.println("Username successfully changed to '" + newUsername + "'.");
            } else {
                out.println("Error: Could not update username. Please try again.");
            }
        }
    } catch (SQLException ex) {
        out.println("SQLException: " + ex);
    }
    %>
    <form action="account.jsp" method="post" style="margin-bottom:20px;">
        <input type="submit" value="Back">
    </form>
</body>
</html>