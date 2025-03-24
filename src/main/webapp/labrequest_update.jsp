<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>
<jsp:useBean id="A" class="com.mycompany.clinicdb.LabRequest" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Update Lab Request</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; padding: 20px; }
        h2, h3 { color: #333; }
        form { margin-bottom: 20px; }
        label { font-weight: bold; }
        input, select, button { margin-top: 5px; padding: 8px; }
        button { background-color: #007BFF; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #0056b3; }
        .message { font-weight: bold; padding: 10px; margin-top: 20px; }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
    <h2>Update Lab Request Information</h2>
    
    <form method="GET" action="labrequest_update.jsp">
        <label for="lab_request_id">Enter Lab Request ID:</label>
        <input type="text" id="lab_request_id" name="lab_request_id" required>
        <button type="submit">Find Lab Request</button>
    </form>
    
    <hr>
    
    <% String labRequestId = request.getParameter("lab_request_id");
    if (labRequestId != null && !labRequestId.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

            String query = "SELECT * FROM lab_requests WHERE lab_request_id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, labRequestId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                A.lab_request_id = rs.getString("lab_request_id");
                A.mrn = rs.getString("mrn");
                A.npi = rs.getString("npi");
                A.reason = rs.getString("reason");
                A.request_date = rs.getString("request_date"); %>

                <h3>Lab Request Found: ID <%= A.lab_request_id %></h3>
                <form method="POST" action="labrequest_update.jsp">
                    <input type="hidden" name="lab_request_id" value="<%= labRequestId %>">
                    <label for="field">Select Field to Update:</label>
                    <select id="field" name="field" onchange="this.form.submit()">
                        <option value="">-- Choose a Field --</option>
                        <option value="mrn" <%= "mrn".equals(request.getParameter("field")) ? "selected" : "" %>>Patient MRN</option>
                        <option value="npi" <%= "npi".equals(request.getParameter("field")) ? "selected" : "" %>>Doctor NPI</option>
                        <option value="reason" <%= "reason".equals(request.getParameter("field")) ? "selected" : "" %>>Reason</option>
                        <option value="request_date" <%= "request_date".equals(request.getParameter("field")) ? "selected" : "" %>>Request Date</option>
                    </select>
                </form>

                <% String field = request.getParameter("field");
                if (field != null && !field.isEmpty()) {
                    String currentValue = switch (field) {
                        case "mrn" -> A.mrn;
                        case "npi" -> A.npi;
                        case "reason" -> A.reason;
                        case "request_date" -> A.request_date;
                        default -> "";
                    }; %>

                    <form method="POST" action="labrequest_update.jsp">
                        <input type="hidden" name="lab_request_id" value="<%= labRequestId %>">
                        <input type="hidden" name="field" value="<%= field %>">
                        <p><strong>Current Value:</strong> <%= currentValue %></p>
                        <label for="new_value">Enter New Value:</label>
                        <input type="text" id="new_value" name="new_value" required>
                        <button type="submit">Update</button>
                    </form>
                <% } %>

            <% } else { %>
                <p class="message error">No lab request found with the given ID.</p>
            <% }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p class='message error'>Error: " + e.getMessage() + "</p>");
        }
    } %>
    
    <hr>
    
    <% String field = request.getParameter("field");
    String newValue = request.getParameter("new_value");
    if (labRequestId != null && field != null && newValue != null && !newValue.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
            
            String updateQuery = "UPDATE lab_requests SET " + field + " = ? WHERE lab_request_id = ?";
            PreparedStatement ps = conn.prepareStatement(updateQuery);
            ps.setString(1, newValue);
            ps.setString(2, labRequestId);
            
            int rowsAffected = ps.executeUpdate();
            ps.close();
            conn.close();
            
            if (rowsAffected > 0) {
                out.println("<p class='message success'>Lab request information updated successfully!</p>");
            } else {
                out.println("<p class='message error'>Update failed. Please try again.</p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p class='message error'>Error: " + e.getMessage() + "</p>");
        }
    } %>
</body>
</html>