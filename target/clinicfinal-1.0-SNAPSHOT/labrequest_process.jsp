<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Process Lab Request</title>
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
            background-color: #007bff;
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
            background-color: #0056b3;
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
        <h2>Process Lab Request</h2>
        
        <form method="POST">
            <label for="mrn">MRN:</label>
            <input type="text" id="mrn" name="mrn" required>
            
            <label for="npi">NPI:</label>
            <input type="text" id="npi" name="npi" required>
            
            <label for="reason">Reason:</label>
            <input type="text" id="reason" name="reason" required>
            
            <label for="request_date">Request Date:</label>
            <input type="date" id="request_date" name="request_date" required>
            
            <button type="submit">Submit</button>
        </form>

        <hr>

        <%
            String mrn = request.getParameter("mrn");
            String npi = request.getParameter("npi");
            String reason = request.getParameter("reason");
            String requestDate = request.getParameter("request_date");

            if (mrn != null && npi != null && reason != null && requestDate != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                         PreparedStatement ps = conn.prepareStatement("INSERT INTO lab_requests (npi, mrn, reason, request_date) VALUES (?, ?, ?, ?)")) {

                        ps.setString(1, npi);
                        ps.setString(2, mrn);
                        ps.setString(3, reason);
                        ps.setString(4, requestDate);

                        int rowsAffected = ps.executeUpdate();
                        if (rowsAffected > 0) {
        %>
                            <p class="success">Lab request added successfully!</p>
        <%
                        } else {
        %>
                            <p class="error">Failed to add lab request. Please try again.</p>
        <%
                        }
                    }
                } catch (Exception e) {
        %>
                    <p class="error">Error: <%= e.getMessage() %></p>
        <%
                }
            } else if (request.getMethod().equalsIgnoreCase("POST")) {
        %>
                <p class="error">All fields are required.</p>
        <%
            }
        %>

    </div>

</body>
</html>
