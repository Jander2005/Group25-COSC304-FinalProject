<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>
</head>
<body style="background-color: #fff333; font-family: Arial, sans-serif; padding: 20px;">

<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<h1>Change Password</h1>

<%

    String currentUser = (String) session.getAttribute("authenticatedUser");

    if (currentUser == null) {
        out.println("<p style='color:red;'>You are not logged in. Please log in first.</p>");
    } else {
        String newPassword = request.getParameter("newPassword");

        if (newPassword != null && !newPassword.trim().isEmpty()) {
            try {
                getConnection();

               
                String updateSql = "UPDATE customer SET password = ? WHERE userid = ?";
                PreparedStatement pstmt = con.prepareStatement(updateSql);
                pstmt.setString(1, newPassword);
                pstmt.setString(2, currentUser);

                int rowsAffected = pstmt.executeUpdate();
                pstmt.close();

                if (rowsAffected > 0) {
                    out.println("<p style='color:green;'>Password successfully changed.</p>");
                } else {
                    out.println("<p style='color:red;'>Error: Could not update password. Please try again.</p>");
                }

            } catch (SQLException ex) {
                out.println("<p style='color:red;'>Database error: " + ex.getMessage() + "</p>");
            } finally {
                closeConnection();
            }
        } 
    }
%>

<form action="account.jsp" method="post" style="margin-top:20px;">
    <button type="submit">Back to Account</button>
</form>

</body>
</html>
