<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>
<jsp:useBean id="A" class="com.mycompany.clinicdb.Patient" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Update Patient Information</title>
</head>
<body>
    <h2>Update Patient Information</h2>
    
    <!-- Step 1: Ask for MRN -->
    <form method="GET" action="patient_update.jsp">
        <label for="mrn">Enter Patient's MRN:</label>
        <input type="text" id="mrn" name="mrn" required>
        <button type="submit">Find Patient</button>
    </form>
    
    <hr>
    
    <%
        String mrn = request.getParameter("mrn");
        if (mrn != null && !mrn.trim().isEmpty()) {
            int found = A.view_patient(mrn);
            if (found == 1) {
    %>
        <h3>Patient Found: <%= A.first_name %> <%= A.last_name %></h3>
        
        <!-- Step 2: Select Field to Update -->
        <form method="POST" action="patient_update.jsp">
            <input type="hidden" name="mrn" value="<%= mrn %>">
            <label for="field">Select Field to Update:</label>
            <select id="field" name="field" onchange="this.form.submit()">
                <option value="">-- Choose a Field --</option>
                <option value="last_name" <%= "last_name".equals(request.getParameter("field")) ? "selected" : "" %>>Last Name</option>
                <option value="first_name" <%= "first_name".equals(request.getParameter("field")) ? "selected" : "" %>>First Name</option>
                <option value="middle_name" <%= "middle_name".equals(request.getParameter("field")) ? "selected" : "" %>>Middle Name</option>
                <option value="sex" <%= "sex".equals(request.getParameter("field")) ? "selected" : "" %>>Sex</option>
                <option value="birth_date" <%= "birth_date".equals(request.getParameter("field")) ? "selected" : "" %>>Birth Date</option>
                <option value="contact_no" <%= "contact_no".equals(request.getParameter("field")) ? "selected" : "" %>>Contact No.</option>
            </select>
        </form>
        
        <%
            String field = request.getParameter("field");
            String currentValue = "";
            if (field != null && !field.isEmpty()) {
                switch (field) {
                    case "last_name": currentValue = A.last_name; break;
                    case "first_name": currentValue = A.first_name; break;
                    case "middle_name": currentValue = A.middle_name; break;
                    case "sex": currentValue = A.sex; break;
                    case "birth_date": currentValue = A.birth_date; break;
                    case "contact_no": currentValue = A.contact_no; break;
                }
        %>
        
        <!-- Step 3: Show Current Value & Ask for New Value -->
        <form method="POST" action="patient_update.jsp">
            <input type="hidden" name="mrn" value="<%= mrn %>">
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
        <p>No patient found with the given MRN.</p>
    <%
            }
        }
    %>
    
    <hr>
    
    <%
        // Step 4: Process Update Submission
        String field = request.getParameter("field");
        String newValue = request.getParameter("new_value");
        
        if (mrn != null && field != null && newValue != null && !newValue.trim().isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                
                String updateQuery = "UPDATE patients SET " + field + " = ? WHERE mrn = ?";
                PreparedStatement ps = conn.prepareStatement(updateQuery);
                ps.setString(1, newValue);
                ps.setString(2,  mrn);
                
                int rowsAffected = ps.executeUpdate();
                ps.close();
                conn.close();
                
                if (rowsAffected > 0) {
    %>
                    <p style="color: green;">Patient information updated successfully!</p>
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