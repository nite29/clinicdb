<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mycompany.clinicdb.Doctor" %>

<jsp:useBean id="A" class="com.mycompany.clinicdb.Patient" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Patient Record</title>
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
        <label for="mrn">Enter Patient's MRN:</label>
        <input type="text" id="mrn" name="mrn" required>
        <button type="submit">Delete</button>
    </form>

    <hr>

    <%
        String mrn = request.getParameter("mrn");

        if (mrn != null && !mrn.trim().isEmpty()) {
            int result = A.deletePatient(mrn);
            
            if (result == 1) {
    %>
                <p style="color: green;">Patient record deleted successfully.</p>
    <%
            } else if (result == 0) {
    %>
                <p style="color: red;">No patient found with the given MRN.</p>
    <%
            } else {
    %>
                <p style="color: red;">An error occurred while deleting the record.</p>
    <%
            }
        }
    %>

</body>
</html>