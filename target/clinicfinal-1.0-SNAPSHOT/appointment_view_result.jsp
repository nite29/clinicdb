<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList" %>
<%@page import="com.mycompany.clinicdb.Appointments" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Appointment Details</title>
    </head>
    <body>
        <form action="payment_process.jsp" method="post">
        <h2>Appointment Details</h2>
        <table border="1">
            <tr>
                <th>Appointment ID</th>
                <th>Patient Name</th>
                <th>Sex</th>
                <th>Birth Date</th>
                <th>Contact Number</th>
                <th>Attending Doctor</th>
                <th>Specialization</th>
                <th>Purpose</th>
                <th>Start Date and Time</th>
                <th>End Date and Time</th>
                <th>Lab Report Status</th>
                <th>Appointment Fees</th>
                <th>Lab Fees</th>
                <th>Total Fees</th>
                <th>Payment Status</th>
            </tr>

            <jsp:useBean id="A" class="com.mycompany.clinicdb.Appointments" scope="page"/>
            
            <%
                String category = request.getParameter("category");
                String value = request.getParameter(category);

                ArrayList<Appointments> appointmentsList = new ArrayList<>();

                if (category != null && value != null) {
                    appointmentsList = A.view_appointment(category, value); // Ensure this returns an ArrayList<Appointments>
                }

                for (Appointments appt : appointmentsList) { 
            %>
                <tr>
                    <td><%= appt.appointment_id %></td>
                        <td><%= appt.patient_name %></td>
                        <td><%= appt.sex %></td>
                        <td><%= appt.birth_date %></td>
                        <td><%= appt.contact_no %></td>
                        <td><%= appt.attending_doctor %></td>
                        <td><%= appt.specialization %></td>
                        <td><%= appt.purpose %></td>
                        <td><%= appt.start_datetime %></td>
                        <td><%= appt.end_datetime %></td>
                        <td><%= appt.lab_report_status %></td>
                        <td><%= appt.appointment_fees %></td>
                        <td><%= appt.lab_fees %></td>
                        <td><%= appt.total_fees %></td>
                        <td><%= appt.payment_status %></td>
                </tr>
            <%
                }
            %>
        </table> <br>
        
        <label for="appointment_id">Select Appointment:</label>
        <select name="appointment_id" id="appointment_id" required>
            <% for (Appointments appt : appointmentsList) { %>
                <option value="<%= appt.appointment_id %>"><%= appt.appointment_id %></option>
            <% } %>
        </select>
        <label for="amount_paid">Enter Amount Paid</label>
            <input type="text" name="amount_paid" id="amount_paid" required><br>
            
        <button type="submit">Proceed to Payment</button>
    </body>
</html>
