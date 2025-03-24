<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Process Lab Request</title>
</head>
<body>

<%
    String mrn = request.getParameter("mrn");
    String npi = request.getParameter("npi");
    String reason = request.getParameter("reason");
    String requestDate = request.getParameter("request_date");

    if (mrn != null && npi != null && reason != null && requestDate != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

            String query = "INSERT INTO lab_requests (npi, mrn, reason, request_date) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, npi);
            ps.setString(2, mrn);
            ps.setString(3, reason);
            ps.setString(4, requestDate);

            int rowsAffected = ps.executeUpdate();
            ps.close();
            conn.close();

            if (rowsAffected > 0) {
%>
                <p style="color: green;">Lab request added successfully!</p>
<%
            } else {
%>
                <p style="color: red;">Failed to add lab request. Please try again.</p>
<%
            }
        } catch (Exception e) {
            e.printStackTrace();
%>
            <p style="color: red;">Error: <%= e.getMessage() %></p>
<%
        }  // **Missing bracket added here**
    } else {  // **This else belongs to the first if condition**
%>
        <p style="color: red;">All fields are required.</p>
<%
    }
%>

</body>
</html>
