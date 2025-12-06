<!DOCTYPE html>
<html>
<head>
        <title>C&J's Tasty Hats Main Page</title>
	<style>
	    @keyframes colorChange {
	        0% { color: #3399FF; }
	        33% { color: #FF33CC; }
	        66% { color: #33FF99; }
	        100% { color: #3399FF; }
	    }
	    @keyframes wiggle {
	        25% { transform: rotate(3deg); }
	        75% { transform: rotate(-3deg); }
	    }
	    .changer {
	        text-align: center;
	        font-family: cursive;
	        font-size: 50px;
	        animation: colorChange 50s infinite, wiggle 10s infinite ease-in-out;
	    }
	    .changer a {
	        text-decoration: none;
	        color: inherit;
    	}
	</style>
</head>
<body class ="animated-background">

<h1 class="changer"><a href="index.jsp">C&J's Tasty Hats Main Page</a></h1>

<h2 class ="left-offset"><a href="/shop/login.jsp">Login</a></h2>

<h2 class ="left-offset"><a href="/shop/listprod.jsp">Begin Shopping</a></h2>

<h2 class ="left-offset"><a href="/shop/listorder.jsp">List All Orders</a></h2>

<h2 class ="left-offset"><a href="/shop/customer.jsp">Customer Info</a></h2>

<h2 class ="left-offset"><a href="/shop/admin.jsp">Administrators</a></h2>

<h2 class ="left-offset"><a href="/shop/logout.jsp">Log out</a></h2>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null)
		out.println("<h3 class =\"left-offset\">Signed in as: "+userName+"</h3>");
%>

<h4 class ="left-offset"><a href="/shop/ship.jsp?orderId=1">Test Ship orderId=1</a></h4>

<h4 class ="left-offset"><a href="/shop/ship.jsp?orderId=3">Test Ship orderId=3</a></h4>

</body>

<style>
    .left-offset {
        text-align: left;
        margin-left: 100px;
		line-height: 2;
    }
</style>

<style>
        @keyframes backgroundChange {
			0% { background-image: url('images/logo.png'); }
            49% { background-image: url('images/logo.png'); }
            50% { background-image: url('images/logo2.png'); }
			51% { background-image: url('images/logo2.png'); }
            52% { background-image: url('images/logo.png'); }
			100% { background-image: url('images/logo.png');}
        }
        
        .animated-background {
            background-color: yellow;
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center 100px;
			background-attachment: fixed;
            animation: backgroundChange 10s infinite ease-in-out;
        }
 </style>
