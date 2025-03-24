<%@ page import="com.mycompany.clinicdb.Diagnosis" %>
<%@ page import="java.io.*, java.util.*, java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Update Diagnosis</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 20px;
            padding: 20px;
        }
        .container {
            max-width: 500px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            margin: auto;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        input, select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            width: 100%;
            background: #28a745;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover {
            background: #218838;
        }
        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }
        .success {
            color: green;
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Update Diagnosis</h2>
    <form method="POST">
        <label>Enter Diagnosis ID:</label>
        <input type="text" name="diagnosis_id" required>
        <button type="submit" name="search">Search</button>
    </form>

    <%
        String diagnosisId = request.getParameter("diagnosis_id");
        String searchClicked = request.getParameter("search");
        String updateClicked = request.getParameter("update");

        if (searchClicked != null && diagnosisId != null && !diagnosisId.isEmpty()) {
            Diagnosis diag = new Diagnosis();
            int found = diag.view_diagnosis(diagnosisId);

            if (found == 1) {
    %>
        <h3>Diagnosis Details</h3>
        <form method="POST">
            <input type="hidden" name="diagnosis_id" value="<%= diag.diagnosis_id %>">
            <p><strong>Appointment ID:</strong> <%= diag.appointment_id %></p>
            <p><strong>Diagnosis:</strong> <%= diag.diagnosis %></p>

            <label>Update Diagnosis:</label>
            <input type="text" name="new_value" placeholder="Enter new diagnosis" required>
            <button type="submit" name="update">Update</button>
        </form>
    <%
            } else {
                out.println("<p class='error'>Diagnosis not found!</p>");
            }
        }

        // Handle update request
        if (updateClicked != null) {
            String newValue = request.getParameter("new_value");

            if (diagnosisId != null && newValue != null && !newValue.isEmpty()) {
                Diagnosis diag = new Diagnosis();
                int updated = diag.update_diagnosis(newValue, diagnosisId, "diagnosis");

                if (updated == 1) {
                    out.println("<p class='success'>Diagnosis updated successfully!</p>");
                } else {
                    out.println("<p class='error'>Update failed!</p>");
                }
            }
        }
    %>
</div>

</body>
</html>
