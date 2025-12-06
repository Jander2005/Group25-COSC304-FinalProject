<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>

<%
String id = request.getParameter("removeId");

@SuppressWarnings("unchecked")
HashMap<String, ArrayList<Object>> productList = 
       (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null && id != null) {
    productList.remove(id);
    session.setAttribute("productList", productList);
}

// Redirect back to cart
response.sendRedirect("/shop/showcart.jsp");  // <-- change to your cart page name
%>
