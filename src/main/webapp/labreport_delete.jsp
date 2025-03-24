<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mycompany.clinicdb.LabReport" %>
<%@ page import="java.sql.*" %>

<jsp:useBean id="A" class="com.mycompany.clinicdb.LabReport" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Lab Report Record</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script>
        function confirmDeletion() {
            let firstConfirm = confirm("Are you sure you want to delete this lab report record?");
            if (firstConfirm) {
                let secondConfirm = confirm("This action cannot be undone. Are you absolutely sure?");
                return secondConfirm;
            }
            return false;
        }
    </script>
</head>
<body class="container mt-5">
    <div class="card shadow p-4">
        <h2 class="text-center text-danger">Delete Lab Report Record</h2>
        <form method="POST" action="labdelete_process.jsp" onsubmit="return confirmDeletion();">
            <div class="mb-3">
                <label for="lab_report_id" class="form-label">Enter Lab Report ID:</label>
                <input type="text" id="lab_report_id" name="lab_report_id" class="form-control" required>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-danger">Delete</button>
            </div>
        </form>
    </div>
    
    <div class="mt-4">
        <% String labReportId = request.getParameter("lab_report_id");
            if (labReportId != null && !labReportId.trim().isEmpty()) {
                int result = A.cascadeDeleteLabReport(labReportId);
                if (result == 1) { %>
                    <div class="alert alert-success text-center">Lab report record and related records deleted successfully.</div>
        <%      } else if (result == 0) { %>
                    <div class="alert alert-warning text-center">No lab report found with the given ID.</div>
        <%      } else { %>
                    <div class="alert alert-danger text-center">An error occurred while deleting the record.</div>
        <%      }
            } %>
    </div>
</body>
</html>
