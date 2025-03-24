<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mycompany.clinicdb.Doctor" %>

<jsp:useBean id="A" class="com.mycompany.clinicdb.Doctor" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Doctor Record</title>
    <script>
        function confirmDeletion() {
            let firstConfirm = confirm("Are you sure you want to delete this doctor record?");
            if (firstConfirm) {
                let secondConfirm = confirm("This action cannot be undone. Are you absolutely sure?");
                return secondConfirm; // Only submits if the second confirmation is also OK
            }
            return false;
        }
    </script>
</head>
<body>

    <h2>Delete Doctor Record</h2>

    <form method="POST" action="doctor_delete.jsp" onsubmit="return confirmDeletion();">
        <label for="npi">Enter Doctor's NPI:</label>
        <input type="text" id="npi" name="npi" required>
        <button type="submit">Delete</button>
    </form>

    <hr>

    <%
        String npi = request.getParameter("npi");

        if (npi != null && !npi.trim().isEmpty()) {
            int result = A.deleteDoctor(npi);
            
            if (result == 1) {
    %>
                <p style="color: green;">Doctor record deleted successfully.</p>
    <%
            } else if (result == 0) {
    %>
                <p style="color: red;">No doctor found with the given NPI.</p>
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