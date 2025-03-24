<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Appointment Process</title>
    </head>
    <body>
        <jsp:useBean id="A" class="com.mycompany.clinicdb.Appointments" scope="page"/>
        <%
            int appointment = A.add_appointment(request.getParameter("mrn"),
                                            request.getParameter("npi"),
                                            request.getParameter("lab_report_id"),
                                            request.getParameter("purpose"),
                                            request.getParameter("date"),
                                            request.getParameter("start_time"),
                                            request.getParameter("end_time"),
                                            request.getParameter("appointment_fees"));
                                            
            if (appointment == 1){out.println("<h1>Successfully added appointment.</h1><br>"); }
            else if (appointment == -1) {
                out.println("<h1>Failed to add appointment.</h1><br>"
                + "<p>Appointment overlaps with another appointment on the same date.</p>");
            } else if (appointment == -2) {
                out.println("<h1>Failed to add appointment.</h1><br>"
                + "<p>Doctor is already booked on this date.</p>");
            } else if (appointment == 0) {out.println("<h1>Bomboclat</h1><br>");
            }
            
    %>
            


    </body>
</html>
