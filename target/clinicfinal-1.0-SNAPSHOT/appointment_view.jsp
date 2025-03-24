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
        <form action="appointment_view.jsp" method="post">
            <label for="category">Search By:</label>
            <select id="category" name="category" required>
                <option value="patient_name">Patient Name</option>
                <option value="doctor_name">Doctor Name</option>
                <option value="contact_no">Patient Contact Number</option>
                <option value="appointment_id">Appointment ID</option>
                <option value="payment_status">Payment Status</option>
            </select>

            <input type="text" id="search_value" name="search_value">
            <button type="submit">Search</button>
        </form>

        <hr>

        <h2>Appointments</h2>
        <table border="1">
            <tr>
                <th>Appointment ID</th>
                <th>Patient Name</th>
                <th>Doctor Name</th>
                <th>Patient Contact No</th>
                <th>Lab Report ID</th>
                <th>Purpose</th>
                <th>Start Date and Time</th>
                <th>End Date and Time</th>
                <th>Appointment Fees</th>
                <th>Payment Status</th>
            </tr>

            <%
            String category = request.getParameter("category");
            String searchValue = request.getParameter("search_value");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

                // Base query
                String query = "SELECT a.appointment_id, " +
                               "CONCAT(p.first_name, ' ', COALESCE(NULLIF(p.middle_name, ''), ''), ' ', p.last_name) AS patient_name, " +
                               "CONCAT(d.first_name, ' ', COALESCE(NULLIF(d.middle_name, ''), ''), ' ', d.last_name) AS doctor_name, " +
                               "p.contact_no, a.lab_report_id, a.purpose, a.start_datetime, a.end_datetime, " +
                               "a.appointment_fees, a.payment_status " +
                               "FROM appointments a " +
                               "JOIN patients p ON a.mrn = p.mrn " +
                               "JOIN doctors d ON a.npi = d.npi ";

                PreparedStatement ps;

                // If user provides search input, modify the query
                if (category != null && searchValue != null && !searchValue.trim().isEmpty()) {
                    if (category.equals("patient_name")) {
                        query += "WHERE CONCAT(p.first_name, ' ', p.last_name) LIKE ?";
                    } else if (category.equals("doctor_name")) {
                        query += "WHERE CONCAT(d.first_name, ' ', d.last_name) LIKE ?";
                    } else if (category.equals("contact_no")) {
                        query += "WHERE p.contact_no LIKE ?";
                    } else if (category.equals("appointment_id")) {
                        query += "WHERE a.appointment_id = ?";
                    } else if (category.equals("payment_status")) {
                        query += "WHERE a.payment_status = ?";
                    }

                    ps = conn.prepareStatement(query);
                    
                    if (category.equals("appointment_id")) {
                        ps.setInt(1, Integer.parseInt(searchValue));
                    } else {
                        ps.setString(1, "%" + searchValue + "%");
                    }
                } else {
                    // If no search criteria provided, retrieve all appointments
                    ps = conn.prepareStatement(query);
                }

                ResultSet rs = ps.executeQuery();

                if (!rs.isBeforeFirst()) { // Check if result set is empty
            %>
                    <tr><td colspan="10">No appointments found.</td></tr>
            <%
                } else {
                    while (rs.next()) {
            %>
                        <tr>
                            <td><%= rs.getInt("appointment_id") %></td>
                            <td><%= rs.getString("patient_name") %></td>
                            <td><%= rs.getString("doctor_name") %></td>
                            <td><%= rs.getString("contact_no") %></td>
                            <td><%= rs.getString("lab_report_id") %></td>
                            <td><%= rs.getString("purpose") %></td>
                            <td><%= rs.getString("start_datetime") %></td>
                            <td><%= rs.getString("end_datetime") %></td>
                            <td><%= rs.getDouble("appointment_fees") %></td>
                            <td><%= rs.getString("payment_status") %></td>
                        </tr>
            <%
                    }
                }

                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            %>
        </table>
    </body>
</html>
