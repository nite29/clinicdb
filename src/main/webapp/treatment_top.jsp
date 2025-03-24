<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>

<html>
<head>
    <title>Top 10 Most Frequently Prescribed Medications</title>
</head>
<body>
    <h2>Top 10 Most Frequently Prescribed Medications</h2>

    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

            // Query to get the top 10 most frequently prescribed medications
            String query = "SELECT medication, COUNT(*) AS prescription_count " +
                           "FROM treatment " +
                           "GROUP BY medication " +
                           "ORDER BY prescription_count DESC " +
                           "LIMIT 10";

            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
    %>

    <table border="1">
        <tr>
            <th>Rank</th>
            <th>Medication Name</th>
            <th>Times Prescribed</th>
        </tr>

    <%
        int rank = 1;
        while (rs.next()) {
    %>
        <tr>
            <td><%= rank++ %></td>
            <td><%= rs.getString("medication") %></td>
            <td><%= rs.getInt("prescription_count") %></td>
        </tr>
    <%
        }
    %>
    </table>

    <%
        } catch (Exception e) {
            e.printStackTrace();
    %>
            <p style="color: red;">Error fetching medication data.</p>
    <%
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    %>

</body>
</html>