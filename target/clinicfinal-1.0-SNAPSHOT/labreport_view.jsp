<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>
<jsp:useBean id="A" class="com.mycompany.clinicdb.LabReport" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Lab Report Search</title>
</head>
<body>

    <h2>Search for a Lab Report</h2>
    <form method="GET" action="labreport_view.jsp">
        <label for="category">Search By:</label>
        <select id="category" name="category">
            <option value="lab_report_id">Lab Report ID</option>
            <option value="lab_request_id">Lab Request ID</option>
            <option value="patient_name">Patient Name</option>
            <option value="doctor_name">Doctor Name</option>
            <option value="lab_test_datetime">Lab Test Datetime</option>
        </select>
        
        <input type="text" id="search_value" name="search_value" required>
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

        if (viewAll != null && viewAll.equals("true")) {
            // View all lab reports
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                String query = "SELECT lr.*, p.first_name AS patient_first_name, p.last_name AS patient_last_name, " +
                               "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                               "FROM lab_reports lr " +
                               "JOIN patients p ON lr.mrn = p.mrn " +
                               "JOIN doctors d ON lr.npi = d.npi";
                PreparedStatement ps = conn.prepareStatement(query);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
    %>
                    <h2>All Lab Reports</h2>
                    <table border="1">
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
            } catch (Exception e) {
                e.printStackTrace();
    %>
                <p>Error: <%= e.getMessage() %></p>
    <%
            }
        } else if (category != null && searchValue != null && !searchValue.trim().isEmpty()) {
            // Search for a specific lab report
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                PreparedStatement ps;
                ResultSet rs;

                String query = "";
                if ("lab_report_id".equals(category)) {
                    query = "SELECT lr.*, p.first_name AS patient_first_name, p.last_name AS patient_last_name, " +
                             "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                             "FROM lab_reports lr " +
                             "JOIN patients p ON lr.mrn = p.mrn " +
                             "JOIN doctors d ON lr.npi = d.npi WHERE lr.lab_report_id = ?";
                } else if ("lab_request_id".equals(category)) {
                    query = "SELECT lr.*, p.first_name AS patient_first_name, p.last_name AS patient_last_name, " +
                             "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                             "FROM lab_reports lr " +
                             "JOIN patients p ON lr.mrn = p.mrn " +
                             "JOIN doctors d ON lr.npi = d.npi WHERE lr.lab_request_id = ?";
                } else if ("patient_name".equals(category)) {
                    query = "SELECT lr.*, p.first_name AS patient_first_name, p.last_name AS patient_last_name, " +
                             "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                             "FROM lab_reports lr " +
                             "JOIN patients p ON lr.mrn = p.mrn " +
                             "JOIN doctors d ON lr.npi = d.npi WHERE p.first_name LIKE ? OR p.last_name LIKE ?";
                } else if ("doctor_name".equals(category)) {
                    query = "SELECT lr.*, p.first_name AS patient_first_name, p.last_name AS patient_last_name, " +
                             "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                             "FROM lab_reports lr " +
                             "JOIN patients p ON lr.mrn = p.mrn " +
                             "JOIN doctors d ON lr.npi = d.npi WHERE d.first_name LIKE ? OR d.last_name LIKE ?";
                } else if ("lab_test_datetime".equals(category)) {
                    query = "SELECT lr.*, p.first_name AS patient_first_name, p.last_name AS patient_last_name, " +
                             "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                             "FROM lab_reports lr " +
                             "JOIN patients p ON lr.mrn = p.mrn " +
                             "JOIN doctors d ON lr.npi = d.npi WHERE lr.lab_test_datetime = ?";
                }

                ps = conn.prepareStatement(query);
                if ("patient_name".equals(category) || "doctor_name".equals(category)) {
                    ps.setString(1, "%" + searchValue + "%");
                    ps.setString(2, "%" + searchValue + "%");
                } else {
                    ps.setString(1, searchValue);
                }

                rs = ps.executeQuery();

                if (rs.next()) { %>
                    <h2>Lab Reports Found</h2>
                    <table border="1">
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
                    <p>No lab reports found matching your search criteria.</p>
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
        } else {
            // Default action to show all lab reports when the page loads
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                String query = "SELECT lr.*, p.first_name AS patient_first_name, p.last_name AS patient_last_name, " +
                               "d.first_name AS doctor_first_name, d.last_name AS doctor_last_name " +
                               "FROM lab_reports lr " +
                               "JOIN patients p ON lr.mrn = p.mrn " +
                               "JOIN doctors d ON lr.npi = d.npi";
                PreparedStatement ps = conn.prepareStatement(query);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
    %>
                    <h2>All Lab Reports</h2>
                    <table border="1">
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
            } catch (Exception e) {
                e.printStackTrace();
    %>
                <p>Error: <%= e.getMessage() %></p>
    <%
            }
        }
    %>

</body>
</html>