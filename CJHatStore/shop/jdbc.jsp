<!--
A JSP file that encapsulates database connections.

Public methods:
- public void getConnection() throws SQLException
- public void closeConnection() throws SQLException  
-->

<%@ page import="java.sql.*"%>

<%!
	// User id, password, and server information
	private String url = "jdbc:sqlserver://c-jhatstore.database.windows.net:1433;"
           + "databaseName=CJ Hat Store;"
           + "encrypt=true;"
           + "trustServerCertificate=true;"; // safe for testing

	private String user = "cjadmin@c-jhatstore";   // include server name
	private String pw = "$HD*(*&BCVIUOI!@#hoiqe23PPOWWD";
	
	// Do not modify this url
	private String urlForLoadData = url = "jdbc:sqlserver://c-jhatstore.database.windows.net:1433;"
           + "databaseName=CJ Hat Store;"
           + "encrypt=true;"
           + "trustServerCertificate=true;";
	
	// Connection
	private Connection con = null;
%>

<%!
	public void getConnection() throws SQLException 
	{
		try
		{	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch (java.lang.ClassNotFoundException e)
		{
			throw new SQLException("ClassNotFoundException: " +e);
		}
	
		con = DriverManager.getConnection(url, user, pw);
		Statement stmt = con.createStatement();
	}
   
	public void closeConnection() 
	{
		try {
			if (con != null)
				con.close();
			con = null;
		}
		catch (Exception e)
		{ }
	}
%>
