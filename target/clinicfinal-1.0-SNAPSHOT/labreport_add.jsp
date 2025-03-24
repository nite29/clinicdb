<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Lab Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
    <h2 class="mb-4 text-center">Add Lab Report</h2>
    <form action="labreport_process.jsp" method="post" class="card p-4 shadow-lg">
        
        <div class="mb-3">
            <label for="lab_request_id" class="form-label">Select the Lab Request</label>
            <select name="lab_request_id" id="lab_request_id" class="form-select" required>
                <jsp:include page="helper_select_labrequest.jsp"></jsp:include>
            </select>
        </div>
        
        <div class="mb-3">
            <label for="mrn" class="form-label">Select the Patient</label>
            <select name="mrn" id="mrn" class="form-select" required>
                <jsp:include page="helper_select_patient.jsp"></jsp:include>
            </select>
        </div>
        
        <div class="mb-3">
            <label for="npi" class="form-label">Select the Attending Doctor</label>
            <select name="npi" id="npi" class="form-select" required>
                <jsp:include page="helper_select_doctor.jsp"></jsp:include>
            </select>
        </div>
        
        <div class="mb-3">
            <label for="findings" class="form-label">Findings</label>
            <input type="text" id="findings" name="findings" class="form-control" required>
        </div>
        
        <div class="mb-3">
            <label for="date" class="form-label">Enter Lab Report Date</label>
            <input type="date" name="date" id="date" class="form-control" required>
        </div>
        
        <div class="mb-3">
            <label for="time" class="form-label">Enter Start Time</label>
            <input type="time" name="time" id="time" class="form-control" required>
        </div>
        
        <div class="mb-3">
            <label for="lab_fees" class="form-label">Enter Lab Fees</label>
            <input type="number" id="lab_fees" name="lab_fees" class="form-control" required>
        </div>
        
        <div class="mb-3">
            <label for="lab_results" class="form-label">Lab Results</label>
            <input type="text" id="lab_results" name="lab_results" class="form-control">
        </div>
        
        <div class="mb-3">
            <label for="report_status" class="form-label">Report Status</label>
            <select id="report_status" name="report_status" class="form-select" required>
                <option value="">Select</option>
                <option value="Pending">Pending</option>
                <option value="Completed">Completed</option>
            </select>
        </div>
        
        <div class="mb-3">
            <label for="payment_status" class="form-label">Payment Status</label>
            <select id="payment_status" name="payment_status" class="form-select" required>
                <option value="">Select</option>
                <option value="Unpaid">Unpaid</option>
                <option value="Paid">Paid</option>
            </select>
        </div>
        
        <button type="submit" class="btn btn-primary w-100">Submit Lab Report</button>
    </form>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
