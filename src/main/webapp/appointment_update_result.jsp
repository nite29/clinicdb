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
        String appointmentId = request.getParameter("appointment_id");
        String purpose = request.getParameter("purpose");
        String date = request.getParameter("date");
        String startTime = request.getParameter("start_time");
        String endTime = request.getParameter("end_time");
        String appointmentFee = request.getParameter("appointment_fees");
        String paymentStatus = request.getParameter("payment_status");

        int appointment = A.update_appointment(appointmentId, purpose, date,
                startTime, endTime, appointmentFee, paymentStatus);

        if (appointment == 1) {out.println("<h1>Sucessfully Updated Appointment"); }
        else {out.println("<h1>Failed to Update Appointment"); }
        %>

    </body>
</html>
