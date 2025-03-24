<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>

<%
Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    try {
        conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
        String query = "SELECT CONCAT( " +
                   "    COALESCE(first_name, ''), ' ', " + 
                   "    CASE " +
                   "        WHEN (middle_name IS NOT NULL AND middle_name <> '') " +
                   "        THEN CONCAT(middle_name, ' ') " +
                   "        ELSE '' " +
                   "    END, " +
                   "    COALESCE(last_name, '') " +
                   ") AS patient, mrn" +
                   "  FROM patients;";

        stmt = conn.prepareStatement(query);
        rs = stmt.executeQuery();

        while (rs.next()) {
    %>
        <option value="<%= rs.getString("mrn") %>">
            <%= rs.getString("patient") %>
        </option>
    <%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } 
}   catch (Exception e) {
        e.printStackTrace();
}
%>
