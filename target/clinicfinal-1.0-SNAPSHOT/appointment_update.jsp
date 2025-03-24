<!DOCTYPE html>
<html>
    <head>
        <title>Update Appointment</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <h1>Update Appointment</h1>
        <form action="appointment_update_process.jsp" method="post">
            <label for="appointment_id" >Select Appointment</label>
            <select name="appointment_id" id="appointment_id" required>
                <jsp:include page="helper_select_appointment2.jsp"></jsp:include>
            </select><br>
            <button type="submit">Choose Appointment</button>
        </form>
    </body>
</html>
