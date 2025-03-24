<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>
<jsp:useBean id="A" class="com.mycompany.clinicdb.Doctor" scope="page"/>

<!DOCTYPE html>
<html>
<head>
    <title>Doctor Search</title>
</head>
<body>

    <h2>Search for a Doctor</h2>
    <form method="GET" action="doctor_view.jsp">
        <label for="category">Search By:</label>
        <select id="category" name="category">
            <option value="npi">NPI</option>
            <option value="name">Name</option>
            <option value="specialization">Specialization</option>
        </select>

        <input type="text" id="search_value" name="search_value" required>
        <button type="submit">Search</button>
    </form>

    <hr>

    <%
        String category = request.getParameter("category");
        String searchValue = request.getParameter("search_value");

        if (category != null && searchValue != null && !searchValue.trim().isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                PreparedStatement ps;
                ResultSet rs;

                if ("npi".equals(category)) { 
                    int found = A.view_doctor(searchValue);
                    if (found == 1) {
    %>
                        <h2>Doctor Details</h2>
                        <table border="1">
                            <tr>
                                <th>NPI</th>
                                <th>Last Name</th>
                                <th>First Name</th>
                                <th>Middle Name</th>
                                <th>Sex</th>
                                <th>Birth Date</th>
                                <th>Medical Certification</th>
                                <th>Years of Service</th>
                                <th>Specialization</th>
                            </tr>
                            <tr>
                                <td><%= A.npi %></td>
                                <td><%= A.last_name %></td>
                                <td><%= A.First_name %></td>
                                <td><%= A.middle_name %></td>
                                <td><%= A.sex %></td>
                                <td><%= A.birth_date %></td>
                                <td><%= A.medical_certification %></td>
                                <td><%= A.years_of_service %></td>
                                <td><%= A.specialization %></td>
                            </tr>
                        </table>
    <%
                    } else {
    %>
                        <p>No doctor found with that NPI.</p>
    <%
                    }
                } else { // If searching by name or specialization, retrieve multiple results
                    String query = "";
                    if ("name".equals(category)) {
                        query = "SELECT * FROM doctors WHERE last_name LIKE ? OR first_name LIKE ?";
                    } else if ("specialization".equals(category)) {
                        query = "SELECT * FROM doctors WHERE specialization LIKE ?";
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
                        <h2>Doctors Found</h2>
                        <table border="1">
                            <tr>
                                <th>NPI</th>
                                <th>Last Name</th>
                                <th>First Name</th>
                                <th>Middle Name</th>
                                <th>Sex</th>
                                <th>Birth Date</th>
                                <th>Medical Certification</th>
                                <th>Years of Service</th>
                                <th>Specialization</th>
                            </tr>
    <%
                        do {
    %>
                            <tr>
                                <td><%= rs.getString("npi") %></td>
                                <td><%= rs.getString("last_name") %></td>
                                <td><%= rs.getString("first_name") %></td>
                                <td><%= rs.getString("middle_name") %></td>
                                <td><%= rs.getString("sex") %></td>
                                <td><%= rs.getString("birth_date") %></td>
                                <td><%= rs.getString("medical_certification") %></td>
                                <td><%= rs.getInt("years_of_service") %></td>
                                <td><%= rs.getString("specialization") %></td>
                            </tr>
    <%
                        } while (rs.next());
    %>
                        </table>
    <%
                    } else {
    %>
                        <p>No doctors found matching your search criteria.</p>
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
        }
    %>

</body>
</html>