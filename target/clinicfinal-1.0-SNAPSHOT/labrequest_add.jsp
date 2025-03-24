<!DOCTYPE html>
<html>
<head>
    <title>Add Lab Request</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <h1>Add Lab Request</h1>
    <form action="labrequest_process.jsp" method="post">
        
        <label for="mrn">Select the Patient</label>
        <select name="mrn" id="mrn" required>
            <jsp:include page="helper_select_patient.jsp"></jsp:include>
        </select><br>
        
        <label for="npi">Select the Attending Doctor</label>
        <select name="npi" id="npi" required>
            <jsp:include page="helper_select_doctor.jsp"></jsp:include>
        </select><br>
        
        <label for="reason">Reason for Lab Request</label>
        <input type="text" id="reason" name="reason" required><br>
        
        <label for="request_date">Request Date</label>
        <input type="date" id="request_date" name="request_date" required><br>
        
        <button type="submit">Submit Lab Request</button>
    </form>
</body>
</html>