<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>
<jsp:useBean id="A" class="com.mycompany.clinicdb.LabRequest" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Lab Request Search</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container py-4">
    <h2 class="text-center mb-4">Search for a Lab Request</h2>
    
    <form method="GET" action="labrequest_view.jsp" class="mb-3 row g-3">
        <div class="col-md-4">
            <label for="category" class="form-label">Search By:</label>
            <select id="category" name="category" class="form-select">
                <option value="lab_request_id">Lab Request ID</option>
                <option value="patient_name">Patient Name</option>
                <option value="doctor_name">Doctor Name</option>
                <option value="request_date">Request Date</option>
            </select>
        </div>
        <div class="col-md-4">
            <label for="search_value" class="form-label">Search Value:</label>
            <input type="text" id="search_value" name="search_value" class="form-control" required>
        </div>
        <div class="col-md-4 d-flex align-items-end">
            <button type="submit" class="btn btn-primary">Search</button>
        </div>
    </form>
    
    <form method="GET" action="labrequest_view.jsp" class="text-center mb-4">
        <button type="submit" name="view_all" value="true" class="btn btn-secondary">View All Lab Requests</button>
    </form>

    <hr>

    <%  
        String category = request.getParameter("category");
        String searchValue = request.getParameter("search_value");
        String viewAll = request.getParameter("view_all");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
            PreparedStatement ps;
            ResultSet rs;
            
            String query = "SELECT lr.*, p.first_name AS patient_first_name, p.last_name AS patient_last_name, " +
                           "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                           "FROM lab_requests lr " +
                           "JOIN patients p ON lr.mrn = p.mrn " +
                           "JOIN doctors d ON lr.npi = d.npi ";

            if (viewAll == null && category != null && searchValue != null && !searchValue.trim().isEmpty()) {
                if ("lab_request_id".equals(category)) {
                    query += "WHERE lr.lab_request_id = ?";
                } else if ("patient_name".equals(category)) {
                    query += "WHERE p.first_name LIKE ? OR p.last_name LIKE ?";
                } else if ("doctor_name".equals(category)) {
                    query += "WHERE d.first_name LIKE ? OR d.last_name LIKE ?";
                } else if ("request_date".equals(category)) {
                    query += "WHERE lr.request_date = ?";
                }
            }
            
            ps = conn.prepareStatement(query);
            if (category != null && ("patient_name".equals(category) || "doctor_name".equals(category))) {
                ps.setString(1, "%" + searchValue + "%");
                ps.setString(2, "%" + searchValue + "%");
            } else if (category != null) {
                ps.setString(1, searchValue);
            }

            rs = ps.executeQuery();
            
            if (rs.next()) { %>
                <h2 class="text-center mt-4">Lab Requests</h2>
                <table class="table table-bordered table-striped mt-3">
                    <thead class="table-dark">
                        <tr>
                            <th>Lab Request ID</th>
                            <th>Patient Name</th>
                            <th>Doctor Name</th>
                            <th>Reason</th>
                            <th>Request Date</th>
                        </tr>
                    </thead>
                    <tbody>
            <% do { %>
                        <tr>
                            <td><%= rs.getString("lab_request_id") %></td>
                            <td><%= rs.getString("patient_first_name") + " " + rs.getString("patient_last_name") %></td>
                            <td><%= rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name") %></td>
                            <td><%= rs.getString("reason") %></td>
                            <td><%= rs.getString("request_date") %></td>
                        </tr>
            <% } while (rs.next()); %>
                    </tbody>
                </table>
            <% } else { %>
                <p class="text-center text-danger">No lab requests found.</p>
            <% }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace(); %>
            <p class="text-danger">Error: <%= e.getMessage() %></p>
        <% } %>
</body>
</html>