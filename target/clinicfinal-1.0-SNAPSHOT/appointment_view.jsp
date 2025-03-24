<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>
<!DOCTYPE html>
<html>
    <head>
        <title>View Appointment</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <h2>Search for an Appointment</h2>
        <form action="appointment_view_result.jsp" method="post">
            
            <label for="category">Search By:</label>
            <select id="category" name="category">
                <option value="patient_name">Patient Name</option>
                <option value="contact_no">Contact Number</option>
                <option value="attending_doctor">Attending Doctor</option>
                <option value="lab_report_status">Lab Report Status</option>
                <option value="payment_status">Payment Status</option>
            </select>

            <input type="text" id="search_value" name="search_value" required>
            <button type="submit">Search</button>
            <hr>
    <%        
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                String query = "SELECT * FROM appointments";
                PreparedStatement ps = conn.prepareStatement(query);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
    %>
                    <h2>Appointments</h2>
                    <table border="1">
                        <tr>
                            <th>Appointment ID</th>
                            <th>Patient Medical Record Number</th>
                            <th>Doctor NPI</th>
                            <th>Lab Report ID</th>
                            <th>Purpose</th>
                            <th>Start Date and Time</th>
                            <th>End Date and Time</th>
                            <th>Appointment Fees</th>
                            <th>Payment Status</th>
                        </tr>
                 <%
                    do {
                %>
                        <tr>
                            <td><%= rs.getString("appointment_id") %></td>
                            <td><%= rs.getString("mrn") %></td>
                            <td><%= rs.getString("npi") %></td>
                            <td><%= rs.getString("lab_report_id") %></td>
                            <td><%= rs.getString("purpose") %></td>
                            <td><%= rs.getString("start_datetime") %></td>
                            <td><%= rs.getString("end_datetime") %></td>
                            <td><%= rs.getString("appointment_fees") %></td>
                            <td><%= rs.getString("payment_status") %></td>
                        </tr>
                <%
                    } while (rs.next());
                %>
                    </table>
                <%
                    } else {
                %>
                    <p>No patients found.</p>
                <%
                }
                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace(); }
        %>
        </form>        
    </body>
</html>
