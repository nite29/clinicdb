<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.mycompany.clinicdb.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Appointment Process</title>
    </head>
    <body>
        <jsp:useBean id="A" class="com.mycompany.clinicdb.Appointments" scope="page"/>
        <%
            String query = "INSERT INTO payments (lab_report_id, mrn, appointment_id) VALUES (?,?,?);";
            String updateQuery = "UPDATE appointments SET payment_status = 'paid' WHERE appointment_id = ?;";
            String paid_amount = request.getParameter("paid_amount");
            String appointment_id = request.getParameter("appointment_id");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
                try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD)) {
                    
                    A.get_appointment(appointment_id); // Retrieve appointment details

                    try (PreparedStatement ps = conn.prepareStatement(query)) {
                        ps.setInt(1, Integer.parseInt(A.lab_report_id));
                        ps.setInt(2, Integer.parseInt(A.mrn));
                        ps.setInt(3, Integer.parseInt(A.appointment_id));

                        if (Double.parseDouble(paid_amount) == Double.parseDouble(A.total_fees)) {
                            ps.executeUpdate();

                            try (PreparedStatement ps2 = conn.prepareStatement(updateQuery)) {
                                ps2.setInt(1, Integer.parseInt(A.appointment_id));
                                ps2.executeUpdate();
                            }
                        }
                    }

                    out.println("<p>Payment Processed Successfully</p>");

                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p>Error processing payment: " + e.getMessage() + "</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Database connection error: " + e.getMessage() + "</p>");
            }
        %>
    </body>
</html>