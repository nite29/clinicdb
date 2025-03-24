<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>

<html>
<head>
    <title>Most Common Treatments for Diagnoses</title>
</head>
<body>
    <h2>Most Common Treatments for Each Diagnosis</h2>

    <table border="1">
        <tr>
            <th>Diagnosis</th>
            <th>Most Common Medication</th>
            <th>Times Used</th>
        </tr>

        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

                // Query to get the most common treatment per diagnosis
                String query = "SELECT d.diagnosis, t.medication, COUNT(t.medication) AS usage_count " +
                               "FROM treatment t " +
                               "JOIN diagnosis d ON t.diagnosis_id = d.diagnosis_id " +
                               "GROUP BY d.diagnosis, t.medication " +
                               "ORDER BY d.diagnosis ASC, usage_count DESC";

                pstmt = conn.prepareStatement(query);
                rs = pstmt.executeQuery();

                String currentDiagnosis = "";
                boolean firstRow = true;

                while (rs.next()) {
                    String diagnosis = rs.getString("diagnosis");
                    String medication = rs.getString("medication");
                    int usageCount = rs.getInt("usage_count");

                    // Only show the most common medication for each diagnosis
                    if (!diagnosis.equals(currentDiagnosis)) {
                        if (!firstRow) { 
        %>
                            <tr><td colspan="3"></td></tr>
        <%
                        }
                        currentDiagnosis = diagnosis;
                        firstRow = false;
        %>
                        <tr>
                            <td><%= diagnosis %></td>
                            <td><%= medication %></td>
                            <td><%= usageCount %></td>
                        </tr>
        <%
                    }
                }

                if (firstRow) {
        %>
                    <tr><td colspan="3" style="color: red;">No data available.</td></tr>
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
    </table>
</body>
</html>