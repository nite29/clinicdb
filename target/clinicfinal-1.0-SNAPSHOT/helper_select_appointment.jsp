<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>

<%
Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    try {
        conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
        String query = "SELECT " +
    "a.appointment_id, " +
    "CONCAT(COALESCE(p.first_name, ''), ' ', " +
    "COALESCE(NULLIF(p.middle_name, ''), ''), ' ', " +
    "COALESCE(p.last_name, '')) AS patient_name, " +
    "p.sex, " +
    "p.birth_date, " +
    "p.contact_no, " +
    "CONCAT(COALESCE(d.first_name, ''), ' ', " +
    "COALESCE(NULLIF(d.middle_name, ''), ''), ' ', " +
    "COALESCE(d.last_name, '')) AS attending_doctor, " +
    "d.specialization, " +
    "a.purpose, " +
    "a.start_datetime, " +
    "a.end_datetime, " +
    "COALESCE(lr.report_status, 'No Report') AS lab_report_status, " +
    "COALESCE(a.appointment_fees, 0) AS appointment_fees, " +
    "COALESCE(lr.lab_fees, 0) AS lab_fees, " +
    "(COALESCE(a.appointment_fees, 0) + COALESCE(lr.lab_fees, 0)) AS total_fees, " +
    "a.payment_status " +
    "FROM appointments a " +
    "JOIN patients p ON a.mrn = p.mrn " +
    "JOIN doctors d ON a.npi = d.npi " +
    "LEFT JOIN lab_reports lr ON a.lab_report_id = lr.lab_report_id;";

        stmt = conn.prepareStatement(query);
        rs = stmt.executeQuery();

        while (rs.next()) {
    %>
        <option value="<%= rs.getString("appointment_id") %>">
            <%= rs.getString("patient_name") %>
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
