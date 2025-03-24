<!DOCTYPE html>
<html>
    <head>
        <title>Add Lab Report</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <h1>Add Lab Report</h1>
        <form action="labreport_process.jsp" method="post">
            
            <label for="lab_request_id" >Select the Lab Request</label>
            <select name="lab_request_id" id="lab_request_id" required>
                <jsp:include page="helper_select_labrequest.jsp"></jsp:include>
            </select><br>
            
            <label for="mrn" >Select the Patient</label>
            <select name="mrn" id="mrn" required>
                <jsp:include page="helper_select_patient.jsp"></jsp:include>
            </select><br>
            
            <label for="npi">Select the Attending Doctor</label>
            <select name="npi" id="npi" required>
                <jsp:include page="helper_select_doctor.jsp"></jsp:include>
            </select><br>
            
    
            <label for="findings">Findings</label>
            <input type="text" id="findings" name="findings" required><br>            

            <!-- html date format: "YYYY-MM-DD"  -->
            <label for="date">Enter Lab Report Date</label>
            <input type="date" name="date" id="date" required><br>

            <!-- html time format: "HH:MI"  -->
            <!-- sql DATETIME actually has seconds "HH:MI:SS"  -->
            <label for="time">Enter Start Time</label>
            <input type="time" name="time" id="time" required><br>

            <!-- dont forget to calculate total fees (appointment fee + lab report fee) -->
            <!-- also html hates decimal types so just parse this string later -->
            <label for="lab_fees">Enter Lab Fees</label>
            <input type="number" id="lab_fees" name="lab_fees" required><br>
            
            <label for="lab_results">Lab Results</label>
            <input type="text" id="lab_results" name="lab_results" ><br>
            
            <label for="report_status">Report Status</label>
            <select id="report_status" name="report_status" required>
                <option value="">Select</option>
                <option value="Pending">Pending</option>
                <option value="Completed">Completed</option>
            </select>
            <br>
            
            <label for="payment">Payment Status</label>
            <select id="payment_status" name="payment_status" required>
                <option value="">Select</option>
                <option value="Unpaid">Unpaid</option>
                <option value="Paid">Paid</option>
            </select>
            <br>
            
            <button type="submit">Submit Lab Report</button>
        </form>
    </body
</html>
