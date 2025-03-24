<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>

<html>
<head>
    <title>Most Common Lab Tests Requested (Last 2 Years)</title>
</head>
<body>
    <h2>Most Common Lab Tests Requested (Last 2 Years)</h2>

    <table border="1">
        <tr>
            <th>Lab Test Reason</th>
            <th>Request Count</th>
        </tr>

    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

            // Query to count the most requested lab tests in the past 2 years
            String query = "SELECT lr.reason, COUNT(*) AS request_count " +
                           "FROM lab_requests lr " +
                           "JOIN lab_reports lrp ON lr.lab_request_id = lrp.lab_request_id " +
                           "WHERE lrp.lab_test_datetime >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR) " +
                           "GROUP BY lr.reason " +
                           "ORDER BY request_count DESC " +
                           "LIMIT 10"; // Show top 10 most requested tests

            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();

            while (rs.next()) {
    %>
        <tr>
            <td><%= rs.getString("reason") %></td>
            <td><%= rs.getInt("request_count") %></td>
        </tr>
    <%
            }
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
    </table>

</body>
</html>
