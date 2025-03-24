<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>

<%
    // Database connection details

    Connection conn = null;
    PreparedStatement checkStmt = null;
    PreparedStatement deleteStmt = null;
    ResultSet rs = null;
    
    String message = "";
    
    String labRequestId = request.getParameter("lab_request_id");

    if (labRequestId != null && !labRequestId.trim().isEmpty()) {
        try {
            int requestId = Integer.parseInt(labRequestId); // Validate input as number

            conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

            // Check if the lab request is linked to any lab report
            String checkQuery = "SELECT COUNT(*) FROM lab_reports WHERE lab_request_id = ?";
            checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setInt(1, requestId);
            rs = checkStmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                message = "<p style='color: red;'>Cannot delete: This Lab Request is linked to a Lab Report.</p>";
            } else {
                // Proceed with deletion if no lab report is linked
                String deleteQuery = "DELETE FROM lab_requests WHERE lab_request_id = ?";
                deleteStmt = conn.prepareStatement(deleteQuery);
                deleteStmt.setInt(1, requestId);

                int rowsDeleted = deleteStmt.executeUpdate();
                if (rowsDeleted > 0) {
                    message = "<p style='color: green;'>Lab Request deleted successfully.</p>";
                } else {
                    message = "<p style='color: red;'>Lab Request not found.</p>";
                }
            }
        } catch (NumberFormatException e) {
            message = "<p style='color: red;'>Invalid Lab Request ID. Please enter a valid number.</p>";
        } catch (SQLException e) {
            message = "<p style='color: red;'>Database error: " + e.getMessage() + "</p>";
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (checkStmt != null) checkStmt.close(); } catch (SQLException ignored) {}
            try { if (deleteStmt != null) deleteStmt.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Lab Request</title>
</head>
<body>

    <h2>Delete Lab Request</h2>

    <form method="POST">
        <label for="lab_request_id">Enter Lab Request ID:</label>
        <input type="number" id="lab_request_id" name="lab_request_id" required>
        <button type="submit">Delete</button>
    </form>

    <hr>

    <%= message %>

</body>
</html>