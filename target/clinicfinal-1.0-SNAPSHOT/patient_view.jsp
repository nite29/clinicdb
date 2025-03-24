<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>
<jsp:useBean id="A" class="com.mycompany.clinicdb.Patient" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Patient Search</title>
</head>
<body>

    <h2>Search for a Patient</h2>
    <form method="GET" action="patient_view.jsp">
        <label for="category">Search By:</label>
        <select id="category" name="category">
            <option value="mrn">MRN</option>
            <option value="name">Name</option>
            <option value="birth_date">Birth Date</option>
            <option value="contact_no">Contact No.</option>
        </select>

        <input type="text" id="search_value" name="search_value" required>
        <button type="submit">Search</button>
    </form>

    <form method="GET" action="patient_view.jsp">
        <button type="submit" name="view_all" value="true">View All Patients</button>
    </form>
    
    <hr>

    <%
        // Check if the view_all parameter is present or if the page is loaded for the first time
        String category = request.getParameter("category");
        String searchValue = request.getParameter("search_value");
        String viewAll = request.getParameter("view_all");

        // If no search is performed, show all patients by default
        if (viewAll != null && viewAll.equals("true")) {
            // View all patients
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                String query = "SELECT * FROM patients";
                PreparedStatement ps = conn.prepareStatement(query);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
    %>
                    <h2>All Patients</h2>
                    <table border="1">
                        <tr>
                            <th>MRN</th>
                            <th>Last Name</th>
                            <th>First Name</th>
                            <th>Middle Name</th>
                            <th>Sex</th>
                            <th>Birth Date</th>
                            <th>Contact No</th>
                        </tr>
                 <%
                    do {
                %>
                        <tr>
                            <td><%= rs.getString("mrn") %></td>
                            <td><%= rs.getString("last_name") %></td>
                            <td><%= rs.getString("first_name") %></td>
                            <td><%= rs.getString("middle_name") %></td>
                            <td><%= rs.getString("sex") %></td>
                            <td><%= rs.getString("birth_date") %></td>
                            <td><%= rs.getString("contact_no") %></td>
                        </tr>
                <%
                    } while (rs.next());
                %>
                    </table>
                <%
                    } else {
                %>
                    <p>No patients found.</p>
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
            // Search for a specific patient
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                PreparedStatement ps;
                ResultSet rs;

                if ("mrn".equals(category)) { 
                    int found = A.view_patient(searchValue);
                    if (found == 1) {
    %>
                        <h2>Patient Details</h2>
                        <table border="1">
                            <tr>
                                <th>MRN</th>
                                <th>Last Name</th>
                                <th>First Name</th>
                                <th>Middle Name</th>
                                <th>Sex</th>
                                <th>Birth Date</th>
                                <th>Contact No.</th>
                            </tr>
                            <tr>
                                <td><%= A.mrn %></td>
                                <td><%= A.last_name %></td>
                                <td><%= A.first_name %></td>
                                <td><%= A.middle_name %></td>
                                <td><%= A.sex %></td>
                                <td><%= A.birth_date %></td>
                                <td><%= A.contact_no %></td>
                            </tr>
                        </table>
    <%
                    } else {
    %>
                        <p>No patient found with that MRN.</p>
    <%
                    }
                } else { // If searching by name or other criteria
                    String query = "";
                    if ("name".equals(category)) {
                        query = "SELECT * FROM patients WHERE last_name LIKE ? OR first_name LIKE ?";
                    } else if ("birth_date".equals(category)) {
                        query = "SELECT * FROM patients WHERE birth_date LIKE ?";
                    } else if ("contact_no".equals(category)) {
                        query = "SELECT * FROM patients WHERE contact_no LIKE ?";
                    } 

                    ps = conn.prepareStatement(query);
                    if ("name".equals(category)) {
                        ps.setString(1, "%" + searchValue + "%");
                        ps.setString(2, "%" + searchValue + "%");
                    } else {
                        ps.setString(1, "%" + searchValue + "%");
                    }

                    rs = ps.executeQuery();

                    if (rs.next()) {
    %>
                        <h2>Patient Found</h2>
                        <table border="1">
                            <tr>
                                <th>MRN</th>
                                <th>Last Name</th>
                                <th>First Name</th>
                                <th>Middle Name</th>
                                <th>Sex</th>
                                <th>Birth Date</th>
                                <th>Contact No</th>
                            </tr>
    <%
                        do {
    %>
                            <tr>
                                <td><%= rs.getString("mrn") %></td>
                                <td><%= rs.getString("last_name") %></td>
                                < td><%= rs.getString("first_name") %></td>
                                <td><%= rs.getString("middle_name") %></td>
                                <td><%= rs.getString("sex") %></td>
                                <td><%= rs.getString("birth_date") %></td>
                                <td><%= rs.getString("contact_no") %></td>
                            </tr>
    <%
                        } while (rs.next());
    %>
                        </table>
    <%
                    } else {
    %>
                        <p>No patients found matching your search criteria.</p>
    <%
                    }
                    rs.close();
                    ps.close();
                }
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
    %>
                <p>Error: <%= e.getMessage() %></p>
    <%
            }
        } else {
            // Default action to show all patients when the page loads
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                String query = "SELECT * FROM patients";
                PreparedStatement ps = conn.prepareStatement(query);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
    %>
                    <h2>All Patients</h2>
                    <table border="1">
                        <tr>
                            <th>MRN</th>
                            <th>Last Name</th>
                            <th>First Name</th>
                            <th>Middle Name</th>
                            <th>Sex</th>
                            <th>Birth Date</th>
                            <th>Contact No</th>
                        </tr>
    <%
                    do {
    %>
                        <tr>
                            <td><%= rs.getString("mrn") %></td>
                            <td><%= rs.getString("last_name") %></td>
                            <td><%= rs.getString("first_name") %></td>
                            <td><%= rs.getString("middle_name") %></td>
                            <td><%= rs.getString("sex") %></td>
                            <td><%= rs.getString("birth_date") %></td>
                            <td><%= rs.getString("contact_no") %></td>
                        </tr>
    <%
                    } while (rs.next());
    %>
                    </table>
    <%
                } else {
    %>
                    <p>No patients found.</p>
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