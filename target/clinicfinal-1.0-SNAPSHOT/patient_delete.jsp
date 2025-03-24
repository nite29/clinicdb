<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mycompany.clinicdb.Doctor" %>

<jsp:useBean id="A" class="com.mycompany.clinicdb.Patient" scope="page"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Patient Record</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 500px;
            margin: 50px auto;
            text-align: center;
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #d9534f;
        }
        form {
            background: #fff;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
        }
        label {
            font-weight: bold;
        }
        input[type="text"] {
            width: 80%;
            padding: 8px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            background-color: #d9534f;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 4px;
        }
        button:hover {
            background-color: #c9302c;
        }
        .message {
            font-weight: bold;
            margin-top: 15px;
        }
        .success {
            color: green;
        }
        .error {
            color: red;
        }
    </style>
    <script>
        function confirmDeletion() {
            let firstConfirm = confirm("Are you sure you want to delete this patient record?");
            if (firstConfirm) {
                let secondConfirm = confirm("This action cannot be undone. Are you absolutely sure?");
                return secondConfirm; // Only submits if the second confirmation is also OK
            }
            return false;
        }
    </script>
</head>
<body>

    <h2>Delete Patient Record</h2>

    <form method="POST" action="patient_delete.jsp" onsubmit="return confirmDeletion();">
        <label for="mrn">Enter Patient's MRN:</label><br>
        <input type="text" id="mrn" name="mrn" required><br>
        <button type="submit">Delete</button>
    </form>

    <hr>

    <%
        String mrn = request.getParameter("mrn");

        if (mrn != null && !mrn.trim().isEmpty()) {
            int result = A.deletePatient(mrn);
            
            if (result == 1) {
    %>
                <p class="message success">Patient record deleted successfully.</p>
    <%
            } else if (result == 0) {
    %>
                <p class="message error">No patient found with the given MRN.</p>
    <%
            } else {
    %>
                <p class="message error">An error occurred while deleting the record.</p>
    <%
            }
        }
    %>

</body>
</html>