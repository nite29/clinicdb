<%@ page import="java.sql.*, java.time.LocalDate, com.mycompany.clinicdb.DBConnection" %>
<html>
<head>
    <title>Total Patients per Doctor (Last 2 Years)</title>
</head>
<body>
    <h2>Total Number of Patients per Doctor (Last 2 Years)</h2>
    <table border="1">
        <tr>
            <th>Doctor Name</th>
            <th>Total Patients</th>
        </tr>
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                
                // Get the date from 2 years ago
                LocalDate twoYearsAgo = LocalDate.now().minusYears(2);
                
                String query = "SELECT d.last_name, d.First_name, COUNT(a.mrn) AS total_patients " +
                               "FROM doctors d " +
                               "LEFT JOIN appointments a ON d.npi = a.npi " +
                               "WHERE a.start_datetime >= ? " +
                               "GROUP BY d.npi, d.last_name, d.First_name";
                
                pstmt = conn.prepareStatement(query);
                pstmt.setDate(1, java.sql.Date.valueOf(twoYearsAgo));
                
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("First_name") + " " + rs.getString("last_name") %></td>
            <td><%= rs.getInt("total_patients") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
</body>
</html>
