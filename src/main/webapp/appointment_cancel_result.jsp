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
            int appointment = A.cancel_appointment(Integer.parseInt(request.getParameter("appointment_id")));
            if (appointment == 1) {out.println("<h1>Sucessfully Cancelled Appointment"); }
            else if (appointment == 0) {out.println("<h1>Error Cancelling. Rolling Back Changes."); }
            else {out.println("<h1>Failed to Cancel Appointment. Some data may be lost."); }
    %>
            


    </body>
</html>
