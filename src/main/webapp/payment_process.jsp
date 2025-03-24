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
        String paid_amount = request.getParameter("paid_amount");
            
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
                try (Connection conn = DriverManager.getConnection(DBConnection.URL,
                     DBConnection.USER, DBConnection.PASSWORD);
                     PreparedStatement ps = conn.prepareStatement(query)) {
                     
                     A.get_appointment(request.getParameter("appointment_id"));
                ps.setInt(1,Integer.parseInt(A.lab_report_id));
                ps.setInt(2,Integer.parseInt(A.mrn));
                ps.setInt(3,Integer.parseInt(A.appointment_id));
                
                if (paid_amount.equals(A.total_fees)){
                    ps.executeUpdate();
                    PreparedStatement ps2 = conn.prepareStatement("UPDATE appointments SET payment_status = 'paid' WHERE appointment_id = ?;");
                    ps.setInt(1,Integer.parseInt(A.appointment_id));
                    ps2.executeUpdate();
                }
                
                } catch (Exception e) {
                    e.printStackTrace();
                }
        } catch (Exception e) {
                    e.printStackTrace();
        }
            
    %>
    </body>
</html>
