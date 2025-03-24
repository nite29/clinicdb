<!DOCTYPE html>
<html>
    <head>
        <title>Update Appointment</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <h1>Update Appointment</h1>
        <form action="appointment_update_result.jsp" method="post">
            <input type="hidden" name="appointment_id" value="<%= request.getParameter("appointment_id") %>">
            
            <jsp:useBean id="A" class="com.mycompany.clinicdb.Appointments" scope="page"/>
            <%
                A.get_appointment(request.getParameter("appointment_id"));
            %>
            
            <label for="date">Update Purpose</label>
            <input type="text" name="purpose" id="purpose" value="<%=A.purpose%>" placeholder="<%=A.purpose%>"><br>
            
            <%
            String start_datetime = A.start_datetime;
            String date = "";
            if (start_datetime != null && start_datetime.contains(" ")) {
                date = start_datetime.split(" ")[0];
            }
            %>
            <label for="date">Update Appointment Date</label>
            <input type="date" name="date" id="date" value="<%=date%>" placeholder="<%=date%>"><br>

            <%
            String start_time = "";
            if (start_datetime != null && start_datetime.contains(" ")) {
                start_time = start_datetime.split(" ")[1].substring(0,5);
            }
            %>
            <label for="start_time">Update Start Time</label>
            <input type="time" name="start_time" id="start_time" value="<%=start_time%>" placeholder="<%=start_time%>"><br>
            
            <%
            String end_datetime = A. end_datetime;
            String end_time = "";
            if (start_datetime != null && start_datetime.contains(" ")) {
                end_time = end_datetime.split(" ")[1].substring(0,5);
            }
            %>
            <label for="end_time">Update End Time</label>
            <input type="time" name="end_time" id="end_time" value="<%=end_time%>" placeholder="<%=end_time%>"><br>

            <label for="appointment_fees">Update Appointment Fee</label>
            <input type="text" name="appointment_fees" id="appointment_fees" value="<%=A.appointment_fees%>" placeholder="<%=A.appointment_fees%>"><br>
            
            <button type="submit">Update Appointment</button><br>
            
            <a href="appointment_update.jsp">
                <button type="button">Go Back</button>
            </a>
        </form>
    </body>
</html>
