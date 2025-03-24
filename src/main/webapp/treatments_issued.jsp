<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>

<html>
<head>
    <title>Total Treatments Report (Last 2 Years)</title>
</head>
<body>
    <h2>Total Treatments Issued (Past 2 Years)</h2>

    <%
        Connection conn = null;
        PreparedStatement pstmtTotal = null;
        PreparedStatement pstmtDoctor = null;
        ResultSet rsTotal = null;
        ResultSet rsDoctor = null;
        int totalTreatments = 0;


        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

            String query = "SELECT COUNT(*) AS treatment_count FROM treatment " +
                           "WHERE diagnosis_id IN (SELECT diagnosis_id FROM diagnosis " +
                           "WHERE appointment_id IN (SELECT appointment_id FROM appointments " +
                           "WHERE start_datetime >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)))";

            pstmtTotal = conn.prepareStatement(query);
            rsTotal = pstmtTotal.executeQuery();

            if (rsTotal.next()) {
                totalTreatments = rsTotal.getInt("treatment_count");
            }
    %>

    <h3>Total Treatments Issued in Last 2 Years: <%= totalTreatments %></h3>

    <h2>Treatments Issued Per Doctor (Past 2 Years)</h2>
    <table border="1">
        <tr>
            <th>Doctor Name</th>
            <th>Number of Treatments</th>
        </tr>

    <%
        // Query to get treatments issued per doctor in the past 2 years
        String queryDoctor = "SELECT d.npi, CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, COUNT(t.treament_id) AS treatment_count " +
                             "FROM treatment t " +
                             "JOIN diagnosis diag ON t.diagnosis_id = diag.diagnosis_id " +
                             "JOIN appointments a ON diag.appointment_id = a.appointment_id " +
                             "JOIN doctors d ON a.npi = d.npi " +
                             "WHERE a.start_datetime >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR) " +
                             "GROUP BY d.npi, doctor_name " +
                             "ORDER BY treatment_count DESC";

        pstmtDoctor = conn.prepareStatement(queryDoctor);
        rsDoctor = pstmtDoctor.executeQuery();

        while (rsDoctor.next()) {
    %>
        <tr>
            <td><%= rsDoctor.getString("doctor_name") %></td>
            <td><%= rsDoctor.getInt("treatment_count") %></td>
        </tr>
    <%
        }
    %>
    </table>

    <%
        } catch (Exception e) {
            e.printStackTrace();
    %>
            <p style="color: red;">Error fetching treatment data.</p>
    <%
        } finally {
            if (rsTotal != null) rsTotal.close();
            if (pstmtTotal != null) pstmtTotal.close();
            if (rsDoctor != null) rsDoctor.close();
            if (pstmtDoctor != null) pstmtDoctor.close();
            if (conn != null) conn.close();
        }
    %>

</body>
</html>