<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>
<jsp:useBean id="A" class="com.mycompany.clinicdb.Doctor" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Update Doctor Information</title>
</head>
<body>

    <h2>Update Doctor Information</h2>

    <!-- Step 1: Ask for NPI -->
    <form method="GET" action="doctor_update.jsp">
        <label for="npi">Enter Doctor's NPI:</label>
        <input type="text" id="npi" name="npi" required>
        <button type="submit">Find Doctor</button>
    </form>

    <hr>

    <%
        String npi = request.getParameter("npi");
        if (npi != null && !npi.trim().isEmpty()) {
            int found = A.view_doctor(npi);

            if (found == 1) {
    %>
        <h3>Doctor Found: <%= A.First_name %> <%= A.last_name %></h3>

        <!-- Step 2: Select Field to Update -->
        <form method="POST" action="doctor_update.jsp">
            <input type="hidden" name="npi" value="<%= npi %>">

            <label for="field">Select Field to Update:</label>
            <select id="field" name="field" onchange="this.form.submit()">
                <option value="">-- Choose a Field --</option>
                <option value="last_name" <%= "last_name".equals(request.getParameter("field")) ? "selected" : "" %>>Last Name</option>
                <option value="First_name" <%= "first_name".equals(request.getParameter("field")) ? "selected" : "" %>>First Name</option>
                <option value="middle_name" <%= "middle_name".equals(request.getParameter("field")) ? "selected" : "" %>>Middle Name</option>
                <option value="sex" <%= "sex".equals(request.getParameter("field")) ? "selected" : "" %>>Sex</option>
                <option value="birth_date" <%= "birth_date".equals(request.getParameter("field")) ? "selected" : "" %>>Birth Date</option>
                <option value="medical_certification" <%= "medical_certification".equals(request.getParameter("field")) ? "selected" : "" %>>Medical Certification</option>
                <option value="years_of_service" <%= "years_of_service".equals(request.getParameter("field")) ? "selected" : "" %>>Years of Service</option>
                <option value="specialization" <%= "specialization".equals(request.getParameter("field")) ? "selected" : "" %>>Specialization</option>
            </select>
        </form>

        <%
            String field = request.getParameter("field");
            String currentValue = "";

            if (field != null && !field.isEmpty()) {
                // Get the current value dynamically based on selected field
                switch (field) {
                    case "last_name": currentValue = A.last_name; break;
                    case "First_name": currentValue = A.First_name; break;
                    case "middle_name": currentValue = A.middle_name; break;
                    case "sex": currentValue = A.sex; break;
                    case "birth_date": currentValue = A.birth_date; break;
                    case "medical_certification": currentValue = A.medical_certification; break;
                    case "years_of_service": currentValue = String.valueOf(A.years_of_service); break;
                    case "specialization": currentValue = A.specialization; break;
                }
        %>

        <!-- Step 3: Show Current Value & Ask for New Value -->
        <form method="POST" action="doctor_update.jsp">
            <input type="hidden" name="npi" value="<%= npi %>">
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
        <p>No doctor found with the given NPI.</p>
    <%
            }
        }
    %>

    <hr>

    <%
        // Step 4: Process Update Submission
        String field = request.getParameter("field");
        String newValue = request.getParameter("new_value");

        if (npi != null && field != null && newValue != null && !newValue.trim().isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

                String updateQuery = "UPDATE doctors SET " + field + " = ? WHERE npi = ?";
                PreparedStatement ps = conn.prepareStatement(updateQuery);
                ps.setString(1, newValue);
                ps.setString(2, npi);

                int rowsAffected = ps.executeUpdate();
                ps.close();
                conn.close();

                if (rowsAffected > 0) {
    %>
                    <p style="color: green;">Doctor information updated successfully!</p>
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