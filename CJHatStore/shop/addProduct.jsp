<%@ page import="java.sql.*, javax.sql.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>
    <style>
        body { background-color: #fff333; font-family: Arial; }
        label, input, select { display: block; margin: 10px 0; }
    </style>
</head>
<body>

<h1>Add New Product</h1>

<form action="insertProduct.jsp" method="post">
    <label>Name:</label>
    <input type="text" name="productName" required>

    <label>Price:</label>
    <input type="text" name="productPrice" required>

    <label>Description:</label>
    <input type="text" name="productDesc" required>

    <label>Category:</label>
    <select name="categoryId" required>
        <option value="">--Select Category--</option>
        <%
            try {
                getConnection(); // from jdbc.jsp
                String sql = "SELECT categoryId, categoryName FROM category";
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                while(rs.next()) {
                    int id = rs.getInt("categoryId");
                    String name = rs.getString("categoryName");
        %>
            <option value="<%=id%>"><%=name%></option>
        <%
                }
                rs.close();
                stmt.close();
                con.close();
            } catch(Exception e) {
                out.println("<option disabled>Error loading categories</option>");
            }
        %>
    </select>

    <button type="submit">Save Product</button>
</form>

</body>
</html>