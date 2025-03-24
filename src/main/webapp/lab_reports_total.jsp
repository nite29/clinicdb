<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>

<html>
<head>
    <title>Total Lab Tests Conducted</title>
</head>
<body>
    <h2>Total Lab Tests Conducted</h2>

    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int totalLabTests = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

            // Query to count all lab reports
            String query =  "SELECT COUNT(*) AS total FROM lab_reports " +
                            "WHERE lab_test_datetime >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR) ";
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                totalLabTests = rs.getInt("total");
            }
    %>
            <p><strong>Total Lab Tests:</strong> <%= totalLabTests %></p>
    <%
        } catch (Exception e) {
            e.printStackTrace();
    %>
            <p style="color:red;">Error retrieving data.</p>
    <%
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    %>

</body>
</html>