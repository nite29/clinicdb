<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>
<html>
<head>
    <title>Average Years of Service</title>
</head>
<body>
    <h2>Overall Average Years of Service</h2>
    <table border="1">
        <tr>
            <th>Overall Average Years</th>
        </tr>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                stmt = conn.createStatement();
                
                String overallQuery = "SELECT AVG(years_of_service) AS overall_avg FROM doctors";
                rs = stmt.executeQuery(overallQuery);
                
                if (rs.next()) {
        %>
        <tr>
            <td><%= rs.getDouble("overall_avg") %></td>
        </tr>
        <%
                }
                rs.close();
                
                String groupQuery = "SELECT specialization, AVG(years_of_service) AS avg_years FROM doctors GROUP BY specialization";
                rs = stmt.executeQuery(groupQuery);
        %>
    </table>
    
    <h2>Average Years of Service by Specialization</h2>
    <table border="1">
        <tr>
            <th>Specialization</th>
            <th>Average Years of Service</th>
        </tr>
        <%
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("specialization") %></td>
            <td><%= rs.getDouble("avg_years") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
</body>
</html>
