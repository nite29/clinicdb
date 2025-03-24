<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>
<jsp:useBean id="A" class="com.mycompany.clinicdb.LabReport" scope="page"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lab Report Search</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            padding: 20px;
            background-color: #f4f4f4;
        }
        h2 {
            text-align: center;
        }
        form {
            background: white;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0px 0px 10px gray;
            max-width: 600px;
            margin: auto;
        }
        label, select, input, button {
            display: block;
            width: 100%;
            margin-bottom: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            box-shadow: 0px 0px 10px gray;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
    </style>
</head>
<body>
    <h2>Search for a Lab Report</h2>
    <form method="GET" action="labreport_view.jsp">
        <label for="category">Search By:</label>
        <select id="category" name="category" required>
            <option value="lab_report_id">Lab Report ID</option>
            <option value="lab_request_id">Lab Request ID</option>
            <option value="patient_name">Patient Name</option>
            <option value="doctor_name">Doctor Name</option>
            <option value="lab_test_datetime">Lab Test Datetime</option>
        </select>
        <input type="text" id="search_value" name="search_value" placeholder="Enter search value" required>
        <button type="submit">Search</button>
    </form>
    
    <form method="GET" action="labreport_view.jsp">
        <button type="submit" name="view_all" value="true">View All Lab Reports</button>
    </form>

    <hr>
    
    <%
        String category = request.getParameter("category");
        String searchValue = request.getParameter("search_value");
        String viewAll = request.getParameter("view_all");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
            String query;
            PreparedStatement ps;
            ResultSet rs;

            if (viewAll != null && viewAll.equals("true")) {
                query = "SELECT lr.*, p.first_name AS patient_first_name, p.last_name AS patient_last_name, " +
                        "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                        "FROM lab_reports lr " +
                        "JOIN patients p ON lr.mrn = p.mrn " +
                        "JOIN doctors d ON lr.npi = d.npi";
                ps = conn.prepareStatement(query);
            } else if (category != null && searchValue != null && !searchValue.trim().isEmpty()) {
                query = "SELECT lr.*, p.first_name AS patient_first_name, p.last_name AS patient_last_name, " +
                        "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                        "FROM lab_reports lr " +
                        "JOIN patients p ON lr.mrn = p.mrn " +
                        "JOIN doctors d ON lr.npi = d.npi WHERE " + category + " LIKE ?";
                ps = conn.prepareStatement(query);
                ps.setString(1, "%" + searchValue + "%");
            } else {
                ps = null;
            }

            if (ps != null) {
                rs = ps.executeQuery();
                if (rs.next()) {
    %>
                    <h2>Lab Reports</h2>
                    <table>
                        <tr>
                            <th>Lab Report ID</th>
                            <th>Lab Request ID</th>
                            <th>Patient Name</th>
                            <th>Doctor Name</th>
                            <th>Findings</th>
                            <th>Lab Test Datetime</th>
                            <th>Lab Fees</th>
                            <th>Report Status</th>
                            <th>Payment Status</th>
                        </tr>
    <%
                    do {
    %>
                        <tr>
                            <td><%= rs.getString("lab_report_id") %></td>
                            <td><%= rs.getString("lab_request_id") %></td>
                            <td><%= rs.getString("patient_first_name") + " " + rs.getString("patient_last_name") %></td>
                            <td><%= rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name") %></td>
                            <td><%= rs.getString("findings") %></td>
                            <td><%= rs.getString("lab_test_datetime") %></td>
                            <td><%= rs.getString("lab_fees") %></td>
                            <td><%= rs.getString("report_status") %></td>
                            <td><%= rs.getString("payment_status") %></td>
                        </tr>
    <%
                    } while (rs.next());
    %>
                    </table>
    <%
                } else {
    %>
                    <p>No lab reports found.</p>
    <%
                }
                rs.close();
                ps.close();
                conn.close();
            }
        } catch (Exception e) {
    %>
            <p style="color: red;">Error: <%= e.getMessage() %></p>
    <%
        }
    %>
</body>
</html>
