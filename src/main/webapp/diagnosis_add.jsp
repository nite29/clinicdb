<!DOCTYPE html>
<html>
    <head>
        <title>Add diagnosis</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <h1>Add doctor</h1>
        <form action="diagnosis_process.jsp" method="post">
            <label for="appointment_id" >Select the Appointment ID</label>
            <select name="appointment_id" id="appointment_id">
                <jsp:include page="helper_select_appointment.jsp"></jsp:include>
            </select><br>

            <label for="diagnosis">Diagnosis:</label>
            <input type="text" id="diagnosis" name="diagnosis" required><br>
            

        
            <button type="submit">Submit Diagnosis</button>
        </form>
    </body
</html>
