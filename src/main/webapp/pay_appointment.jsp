<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.mycompany.clinicdb.DBConnection" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pay Appointment</title>
    </head>
    <body>
        <h2>Pay Appointment</h2>

        <!-- Form to select appointment -->
        <form method="post" action="pay_appointment.jsp">
            <label for="appointment_id">Enter Appointment ID:</label>
            <input type="text" name="appointment_id" id="appointment_id" required>
            <button type="submit">Mark as Paid</button>
        </form>

        <%
            // Process payment update if form is submitted
            String appointment_id = request.getParameter("appointment_id");

            if (appointment_id != null && !appointment_id.trim().isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL Driver
                    try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD)) {

                        // Update the payment status
                        String updateQuery = "UPDATE appointments SET payment_status = 'paid' WHERE appointment_id = ?";
                        try (PreparedStatement ps = conn.prepareStatement(updateQuery)) {
                            ps.setInt(1, Integer.parseInt(appointment_id));

                            int updatedRows = ps.executeUpdate();

                            if (updatedRows > 0) {
                                out.println("<p>✅ Appointment ID " + appointment_id + " has been successfully marked as PAID.</p>");
                            } else {
                                out.println("<p>⚠️ Appointment ID not found or already paid.</p>");
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p>❌ Error processing payment: " + e.getMessage() + "</p>");
                }
            }
        %>

        <br>
    </body>
</html>