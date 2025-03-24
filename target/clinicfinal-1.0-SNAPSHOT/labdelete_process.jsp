<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mycompany.clinicdb.LabReport" %>
<%@ page import="java.sql.*" %>

<jsp:useBean id="A" class="com.mycompany.clinicdb.LabReport" scope="session"/>

<!DOCTYPE html>
<html>
<head>
    <title>Lab Report Deletion Result</title>
</head>
<body>

    <h2>Lab Report Deletion Result</h2>

    <%
        String labReportId = request.getParameter("lab_report_id");

        if (labReportId != null && !labReportId.trim().isEmpty()) {
            try {
                int reportId = Integer.parseInt(labReportId); // Ensure it's a valid number
                int result = A.cascadeDeleteLabReport(labReportId); // Call the deletion method

                if (result == 1) {
    %>
                    <p style="color: green;">Lab report and related records deleted successfully.</p>
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
            } catch (NumberFormatException e) {
    %>
                <p style="color: red;">Invalid Lab Report ID. Please enter a valid number.</p>
    <%
            }
        } else {
    %>
            <p style="color: red;">Lab Report ID is required.</p>
    <%
        }
    %>

    <a href="delete_lab_report.jsp">Go Back</a>

</body>
</html>