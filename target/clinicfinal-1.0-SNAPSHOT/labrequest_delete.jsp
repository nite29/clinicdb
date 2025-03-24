<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>

<%
    // Database connection setup
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

            // Check if lab request is linked to a lab report
            String checkQuery = "SELECT COUNT(*) FROM lab_reports WHERE lab_request_id = ?";
            checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setInt(1, requestId);
            rs = checkStmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                message = "<p class='error'>Cannot delete: This Lab Request is linked to a Lab Report.</p>";
            } else {
                // Proceed with deletion
                String deleteQuery = "DELETE FROM lab_requests WHERE lab_request_id = ?";
                deleteStmt = conn.prepareStatement(deleteQuery);
                deleteStmt.setInt(1, requestId);

                int rowsDeleted = deleteStmt.executeUpdate();
                if (rowsDeleted > 0) {
                    message = "<p class='success'>Lab Request deleted successfully.</p>";
                } else {
                    message = "<p class='error'>Lab Request not found.</p>";
                }
            }
        } catch (NumberFormatException e) {
            message = "<p class='error'>Invalid Lab Request ID. Please enter a valid number.</p>";
        } catch (SQLException e) {
            message = "<p class='error'>Database error: " + e.getMessage() + "</p>";
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (checkStmt != null) checkStmt.close(); } catch (SQLException ignored) {}
            try { if (deleteStmt != null) deleteStmt.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Lab Request</title>
    <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
            color: #555;
            text-align: left;
        }

        input {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        button {
            width: 100%;
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 12px;
            margin-top: 15px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background-color: #a71d2a;
        }

        .success {
            color: green;
            font-weight: bold;
        }

        .error {
            color: red;
            font-weight: bold;
        }

        hr {
            margin: 20px 0;
            border: 0;
            height: 1px;
            background: #ddd;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Delete Lab Request</h2>
        <form method="POST">
            <label for="lab_request_id">Enter Lab Request ID:</label>
            <input type="number" id="lab_request_id" name="lab_request_id" required>
            <button type="submit">Delete</button>
        </form>

        <hr>

        <%= message %>
    </div>

</body>
</html>
