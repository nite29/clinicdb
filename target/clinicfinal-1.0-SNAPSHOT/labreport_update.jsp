<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>
<jsp:useBean id="A" class="com.mycompany.clinicdb.LabReport" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Update Lab Report Information</title>
</head>
<body>

    <h2>Update Lab Report Information</h2>

    <!-- Step 1: Ask for Lab Report ID -->
    <form method="GET" action="labreport_update.jsp">
        <label for="lab_report_id">Enter Lab Report ID:</label>
        <input type="text" id="lab_report_id" name="lab_report_id" required>
        <button type="submit">Find Lab Report</button>
    </form>

    <hr>

    <%
        String labReportId = request.getParameter("lab_report_id");
        if (labReportId != null && !labReportId.trim().isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

                // Query to find the lab report by ID
                String query = "SELECT lr.*, p.first_name AS patient_first_name, p.last_name AS patient_last_name, " +
                               "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                               "FROM lab_reports lr " +
                               "JOIN patients p ON lr.mrn = p.mrn " +
                               "JOIN doctors d ON lr.npi = d.npi " +
                               "WHERE lr.lab_report_id = ?";
                PreparedStatement ps = conn.prepareStatement(query);
                ps.setString(1, labReportId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    // Populate the LabReport bean with the retrieved data
                    A.lab_report_id = rs.getString("lab_report_id");
                    A.lab_request_id = rs.getString("lab_request_id");
                    A.mrn = rs.getString("mrn");
                    A.npi = rs.getString("npi");
                    A.findings = rs.getString("findings");
                    A.lab_test_datetime = rs.getString("lab_test_datetime");
                    A.lab_fees = rs.getString("lab_fees");
                    A.lab_results = rs.getString("lab_results");
                    A.report_status = rs.getString("report_status");
                    A.payment_status = rs.getString("payment_status");
    %>
        <h3>Lab Report Found: <%= A.lab_report_id %></h3>

        <!-- Step 2: Select Field to Update -->
        <form method="POST" action="labreport_update.jsp">
            <input type="hidden" name="lab_report_id" value="<%= labReportId %>">

            <label for="field">Select Field to Update:</label>
            <select id="field" name="field" onchange="this.form.submit()">
                <option value="">-- Choose a Field --</option>
                <option value="findings" <%= "findings".equals(request.getParameter("field")) ? "selected" : "" %>>Findings</option>
                <option value="lab_test_datetime" <%= "lab_test_datetime".equals(request.getParameter("field")) ? "selected" : "" %>>Lab Test Datetime</option>
                <option value="lab_fees" <%= "lab_fees".equals(request.getParameter("field")) ? "selected" : "" %>>Lab Fees</option>
                <option value="lab_results" <%= "lab_results".equals(request.getParameter("field")) ? "selected" : "" %>>Lab Results</option>
                <option value="report_status" <%= "report_status".equals(request.getParameter("field")) ? "selected" : "" %>>Report Status</option>
                <option value="payment_status" <%= "payment_status".equals(request.getParameter("field")) ? "selected" : "" %>>Payment Status</option>
            </select>
        </form>

        <%
            String field = request.getParameter("field");
            String currentValue = "";

            if (field != null && !field.isEmpty()) {
                // Get the current value dynamically based on selected field
                switch (field) {
                    case "findings": currentValue = A.findings; break;
                    case "lab_test_datetime": currentValue = A.lab_test_datetime; break;
                    case "lab_fees": currentValue = String.valueOf(A.lab_fees); break;
                    case "lab_results": currentValue = A.lab_results; break;
                    case "report_status": currentValue = A.report_status; break;
                    case "payment_status": currentValue = A.payment_status; break;
                }
        %>

        <!-- Step 3: Show Current Value & Ask for New Value -->
        <form method="POST" action="labreport_update.jsp">
            <input type="hidden" name="lab_report_id" value="<%= labReportId %>">
            <input type="hidden" name="field" value="<%= field %>">

            <p><strong>Current Value:</strong> <%= currentValue %></p>

            <label for="new_value">Enter New Value:</label>
            <input type="text" id="new_value" name="new_value" required>

            <button type="submit">Update</button>
        </form>

        <%
            }
        %>

    <%
                } else {
    %>
        <p>No lab report found with the given ID.</p>
    <%
                }
                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
    %>
                <p>Error: <%= e.getMessage() %></p>
    <%
            }
        }
    %>

    <hr>

    <%
        // Step 4: Process Update Submission
        String field = request.getParameter("field");
        String newValue = request.getParameter("new_value");

        if (labReportId != null && field != null && newValue != null && !newValue.trim().isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

                String updateQuery = "UPDATE lab_reports SET " + field + " = ? WHERE lab_report_id = ?";
                PreparedStatement ps = conn.prepareStatement(updateQuery);
                ps.setString(1, newValue);
                ps.setString(2, labReportId);

                int rowsAffected = ps.executeUpdate();
                ps.close();
                conn.close();

                if (rowsAffected > 0) {
    %>
                    <p style="color: green;">Lab report information updated successfully!</p>
    <%
                } else {
    %>
                    <p style="color: red;">Update failed. Please try again.</p>
    <%
                }
            } catch (Exception e) {
                e.printStackTrace();
    %>
                <p style="color: red;">Error: <%= e.getMessage() %></p>
    <%
            }
        }
    %>

</body>
</html>