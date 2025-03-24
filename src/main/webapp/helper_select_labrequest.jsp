<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>

<%
Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    try {
        conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
        String query = "select lab_request_id from lab_requests;";

        stmt = conn.prepareStatement(query);
        rs = stmt.executeQuery();

        while (rs.next()) {
    %>
        <option value="<%= rs.getString("lab_request_id") %>">
            <%= rs.getString("lab_request_id") %>
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
