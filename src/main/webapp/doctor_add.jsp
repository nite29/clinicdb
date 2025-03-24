<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Doctor</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white">
                <h2 class="text-center mb-0">Add Doctor</h2>
            </div>
            <div class="card-body">
                <form action="doctor_process.jsp" method="post">
                    <div class="mb-3">
                        <label for="last_name" class="form-label">Last Name:</label>
                        <input type="text" id="last_name" name="last_name" class="form-control" placeholder="Enter last name" required>
                    </div>

                    <div class="mb-3">
                        <label for="First_name" class="form-label">First Name:</label>
                        <input type="text" id="First_name" name="First_name" class="form-control" placeholder="Enter first name" required>
                    </div>

                    <div class="mb-3">
                        <label for="middle_name" class="form-label">Middle Name:</label>
                        <input type="text" id="middle_name" name="middle_name" class="form-control" placeholder="Enter middle name (optional)">
                    </div>

                    <div class="mb-3">
                        <label for="sex" class="form-label">Sex:</label>
                        <select id="sex" name="sex" class="form-select" required>
                            <option value="">Select</option>
                            <option value="M">Male</option>
                            <option value="F">Female</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="birth_date" class="form-label">Birth Date:</label>
                        <input type="date" id="birth_date" name="birth_date" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label for="medical_certification" class="form-label">Medical Certification:</label>
                        <input type="text" id="medical_certification" name="medical_certification" class="form-control" placeholder="Enter certification" required>
                    </div>

                    <div class="mb-3">
                        <label for="years_of_service" class="form-label">Years in Service:</label>
                        <input type="number" id="years_of_service" name="years_of_service" class="form-control" min="0" placeholder="Enter years in service" required>
                    </div>

                    <div class="mb-3">
                        <label for="specialization" class="form-label">Specialization:</label>
                        <input type="text" id="specialization" name="specialization" class="form-control" placeholder="Enter specialization" required>
                    </div>

                    <div class="text-center">
                        <button type="submit" class="btn btn-success px-4">Submit Doctor</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>