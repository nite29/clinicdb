<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Appointment</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white">
                <h2 class="text-center mb-0">Add Appointment</h2>
            </div>
            <div class="card-body">
                <form action="appointment_add_result.jsp" method="post">
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
                        <label for="lab_report_id" class="form-label">Select the Lab Report</label>
                        <select name="lab_report_id" id="lab_report_id" class="form-select">
                            <option value="">None</option>
                            <jsp:include page="helper_select_report.jsp"></jsp:include>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="purpose" class="form-label">Purpose</label>
                        <input type="text" id="purpose" name="purpose" class="form-control" placeholder="Enter purpose" required>
                    </div>

                    <div class="mb-3">
                        <label for="date" class="form-label">Appointment Date</label>
                        <input type="date" name="date" id="date" class="form-control" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="start_time" class="form-label">Start Time</label>
                            <input type="time" name="start_time" id="start_time" class="form-control" required>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="end_time" class="form-label">End Time</label>
                            <input type="time" name="end_time" id="end_time" class="form-control" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="appointment_fees" class="form-label">Appointment Fee</label>
                        <input type="text" name="appointment_fees" id="appointment_fees" class="form-control" placeholder="Enter fee amount" required>
                    </div>

                    <div class="text-center">
                        <button type="submit" class="btn btn-success px-4">Submit Appointment</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
