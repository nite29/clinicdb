<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>

<html>
<head>
    <title>Average Number of Medications Per Diagnosis</title>
</head>
<body>
    <h2>Average Number of Medications Per Diagnosis</h2>

    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

            // Query to calculate the average number of medications per diagnosis
            String query = "SELECT AVG(medication_count) AS avg_medications " +
                           "FROM ( " +
                           "    SELECT diagnosis_id, COUNT(*) AS medication_count " +
                           "    FROM treatment " +
                           "    GROUP BY diagnosis_id " +
                           ") AS diagnosis_medications";

            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                double avgMedications = rs.getDouble("avg_medications");
    %>

    <p><strong>Average Number of Medications Per Diagnosis:</strong> <%= String.format("%.2f", avgMedications) %></p>

    <%
            } else {
    %>
            <p style="color: red;">No data available.</p>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
    %>
            <p style="color: red;">Error fetching data.</p>
    <%
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    %>

</body>
</html>
