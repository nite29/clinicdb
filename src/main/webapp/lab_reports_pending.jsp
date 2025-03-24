<%@ page import="java.sql.*" %>
<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>

<html>
<head>
    <title>Pending Lab Reports (Last 2 Years)</title>
</head>
<body>
    <h2>Pending Lab Reports (Last 2 Years)</h2>

    <table border="1">
        <tr>
            <th>Lab Report ID</th>
            <th>Patient Name</th>
            <th>Doctor Name</th>
            <th>Findings</th>
            <th>Lab Test Date</th>
            <th>Report Status</th>
        </tr>

        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

                String query = "SELECT lr.lab_report_id, " +
                               "CONCAT(p.first_name, ' ', p.middle_name, ' ', p.last_name) AS patient_name, " +
                               "CONCAT(d.first_name, ' ', d.middle_name, ' ', d.last_name) AS doctor_name, " +
                               "lr.findings, lr.lab_test_datetime, lr.report_status " +
                               "FROM lab_reports lr " +
                               "JOIN patients p ON lr.mrn = p.mrn " +
                               "JOIN doctors d ON lr.npi = d.npi " +
                               "WHERE lr.report_status = 'pending' " +
                               "AND lr.lab_test_datetime >= DATE_SUB(NOW(), INTERVAL 2 YEAR)";

                stmt = conn.prepareStatement(query);
                rs = stmt.executeQuery();

                while (rs.next()) {
        %>
                    <tr>
                        <td><%= rs.getInt("lab_report_id") %></td>
                        <td><%= rs.getString("patient_name") %></td>
                        <td><%= rs.getString("doctor_name") %></td>
                        <td><%= rs.getString("findings") %></td>
                        <td><%= rs.getTimestamp("lab_test_datetime") %></td>
                        <td><%= rs.getString("report_status") %></td>
                    </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
                <tr>
                    <td colspan="6" style="color: red;">Error retrieving data.</td>
                </tr>
        <%
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
</body>
</html>