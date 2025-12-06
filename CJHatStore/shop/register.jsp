<!DOCTYPE html>
<html>
<head>
    <title>Register New Account</title>
</head>
<body style="background-color: #fff333; font-family: Arial, sans-serif; padding: 20px;">

<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<h1>Register New Account</h1>

<%
    String userid = request.getParameter("userid");
    String password = request.getParameter("password");

    if (userid != null && password != null) {
        userid = userid.trim();
        password = password.trim();

        if (userid.isEmpty() || password.isEmpty()) {
            out.println("<p style='color:red;'>Please fill in all fields.</p>");
        } else {
            try {
                getConnection();

                
                String checkSql = "SELECT COUNT(*) FROM customer WHERE userid = ?";
                PreparedStatement checkStmt = con.prepareStatement(checkSql);
                checkStmt.setString(1, userid);
                ResultSet rs = checkStmt.executeQuery();
                rs.next();
                int count = rs.getInt(1);
                rs.close();
                checkStmt.close();

                if (count > 0) {
                    out.println("<p style='color:red;'>Username '" + userid + "' is already taken. Please choose a different username.</p>");
                } else {
                    
                    String insertSql = "INSERT INTO customer (userid, password) VALUES (?, ?)";
                    PreparedStatement insertStmt = con.prepareStatement(insertSql);
                    insertStmt.setString(1, userid);
                    insertStmt.setString(2, password);  // For production, hash passwords!
                    int rows = insertStmt.executeUpdate();
                    insertStmt.close();

                    if (rows > 0) {
                        out.println("<p style='color:green;'>Created, You can now <a href='login.jsp'>log in</a>.</p>");
                    } else {
                        out.println("<p style='color:red;'>Error creating account.</p>");
                    }
                }

            } catch (SQLException ex) {
                out.println("<p style='color:red;'>Database error: " + ex.getMessage() + "</p>");
            } finally {
                closeConnection();
            }
        }
    } else {
%>
        
        <form action="register.jsp" method="post">
            <label for="firstName">Username:</label>
            <input type="text" id="firstName" name="firstName" required><br><br>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required><br><br>

            <button type="submit">Register</button>
        </form>
<%
    }
%>

<form action="index.jsp" method="get" style="margin-top:20px;">
    <button type="submit">Back to Home</button>
</form>

</body>
</html>
