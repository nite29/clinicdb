<!DOCTYPE html>
<html>
    <head>
        <title>Cancel Appointment</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <h1>Cancel Appointment</h1>
        <form action="appointment_cancel_result.jsp" method="post">
            <label for="appointment_id" >Select Appointment</label>
            <select name="appointment_id" id="appointment_id" required>
                <jsp:include page="helper_select_appointment.jsp"></jsp:include>
            </select><br>

            <button type="submit">Cancel Appointment</button>
        </form>
    </body>
</html>
