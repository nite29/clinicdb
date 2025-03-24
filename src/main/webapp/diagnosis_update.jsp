<%@ page import="com.mycompany.clinicdb.Diagnosis" %>
<%@ page import="java.io.*, java.util.*, java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Update Diagnosis</title>
</head>
<body>
    <h2>Update Diagnosis</h2>
    <form method="POST">
        <label>Enter Diagnosis ID:</label>
        <input type="text" name="diagnosis_id" required>
        <input type="submit" value="Search">
    </form>

    <%
        String diagnosisId = request.getParameter("diagnosis_id");
        if (diagnosisId != null && !diagnosisId.isEmpty()) {
            Diagnosis diag = new Diagnosis();
            int found = diag.view_diagnosis(diagnosisId);
            
            if (found == 1) {
    %>
                <h3>Diagnosis Details</h3>
                <form method="POST">
                    <input type="hidden" name="diagnosis_id" value="<%= diag.diagnosis_id %>">
                    <p>Appointment ID: <%= diag.appointment_id %></p>
                    <p>Diagnosis: <%= diag.diagnosis %></p>

                    <label>Choose field to update:</label>
                    <select name="field">
                        <option value="diagnosis">Diagnosis</option>
                    </select>
                    <input type="text" name="new_value" required>
                    <input type="submit" name="update" value="Update">
                </form>
    <%
            } else {
                out.println("<p style='color:red;'>Diagnosis not found!</p>");
            }
        }

        // Handle update request
        if (request.getParameter("update") != null) {
            String field = request.getParameter("field");
            String newValue = request.getParameter("new_value");
            
            if (diagnosisId != null && field != null && newValue != null) {
                Diagnosis diag = new Diagnosis();
                int updated = diag.update_diagnosis(newValue, diagnosisId, field);
                
                if (updated == 1) {
                    out.println("<p style='color:green;'>Diagnosis updated successfully!</p>");
                } else {
                    out.println("<p style='color:red;'>Update failed!</p>");
                }
            }
        }
    %>
</body>
</html>