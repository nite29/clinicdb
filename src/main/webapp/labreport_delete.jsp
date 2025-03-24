<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mycompany.clinicdb.LabReport" %>
<%@ page import="java.sql.*" %>

<jsp:useBean id="A" class="com.mycompany.clinicdb.LabReport" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Lab Report Record</title>
    <script>
        function confirmDeletion() {
            let firstConfirm = confirm("Are you sure you want to delete this lab report record?");
            if (firstConfirm) {
                let secondConfirm = confirm("This action cannot be undone. Are you absolutely sure?");
                return secondConfirm; // Only submits if the second confirmation is also OK
            }
            return false;
        }
    </script>
</head>
<body>

    <h2>Delete Lab Report Record</h2>

    <form method="POST" action="labdelete_process.jsp" onsubmit="return confirmDeletion();">
        <label for="lab_report_id">Enter Lab Report ID:</label>
        <input type="text" id="lab_report_id" name="lab_report_id" required>
        <button type="submit">Delete</button>
    </form>

    <hr>

    <%
        String labReportId = request.getParameter("lab_report_id");

        if (labReportId != null && !labReportId.trim().isEmpty()) {
            int result = A.cascadeDeleteLabReport(labReportId); // Call the cascade delete method
            
            if (result == 1) {
    %>
                <p style="color: green;">Lab report record and related records deleted successfully.</p>
    <%
            } else if (result == 0) {
    %>
                <p style="color: red;">No lab report found with the given ID.</p>
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