<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>
<jsp:useBean id="A" class="com.mycompany.clinicdb.Patient" scope="page"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Patient Search</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .container {
            width: 100%;
            max-width: 600px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        select, input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .button-container {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
        }
        button {
            width: 48%;
            background: #007bff;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background: #0056b3;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #007bff;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Search for a Patient</h2>
    <form method="GET" action="patient_view.jsp">
        <label for="category">Search By:</label>
        <select id="category" name="category">
            <option value="mrn">MRN</option>
            <option value="name">Name</option>
            <option value="birth_date">Birth Date</option>
            <option value="contact_no">Contact No.</option>
        </select>

        <input type="text" id="search_value" name="search_value" required placeholder="Enter search value">
        <div class="button-container">
            <button type="submit">Search</button>
            <button type="submit" name="view_all" value="true">View All Patients</button>
        </div>
    </form>

    <hr>

    <%
        String category = request.getParameter("category");
        String searchValue = request.getParameter("search_value");
        String viewAll = request.getParameter("view_all");

        if (viewAll != null && viewAll.equals("true")) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                String query = "SELECT * FROM patients";
                PreparedStatement ps = conn.prepareStatement(query);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
    %>
                    <h2>All Patients</h2>
                    <table>
                        <tr>
                            <th>MRN</th>
                            <th>Last Name</th>
                            <th>First Name</th>
                            <th>Middle Name</th>
                            <th>Sex</th>
                            <th>Birth Date</th>
                            <th>Contact No.</th>
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
                    <p class="error">No patients found.</p>
                <%
                }
                rs.close();
                ps.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
        %>
                <p class="error">Error: <%= e.getMessage() %></p>
        <%
            }
        } else if (category != null && searchValue != null && !searchValue.trim().isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                String query = "";
                if ("name".equals(category)) {
                    query = "SELECT * FROM patients WHERE last_name LIKE ? OR first_name LIKE ?";
                } else if ("birth_date".equals(category)) {
                    query = "SELECT * FROM patients WHERE birth_date LIKE ?";
                } else if ("contact_no".equals(category)) {
                    query = "SELECT * FROM patients WHERE contact_no LIKE ?";
                } 

                PreparedStatement ps = conn.prepareStatement(query);
                if ("name".equals(category)) {
                    ps.setString(1, "%" + searchValue + "%");
                    ps.setString(2, "%" + searchValue + "%");
                } else {
                    ps.setString(1, "%" + searchValue + "%");
                }

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
    %>
                    <h2>Search Results</h2>
                    <table>
                        <tr>
                            <th>MRN</th>
                            <th>Last Name</th>
                            <th>First Name</th>
                            <th>Middle Name</th>
                            <th>Sex</th>
                            <th>Birth Date</th>
                            <th>Contact No.</th>
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
                    <p class="error">No matching patients found.</p>
    <%
                    }
                    rs.close();
                    ps.close();
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
    %>
                    <p class="error">Error: <%= e.getMessage() %></p>
    <%
                }
            }
    %>
</div>

</body>
</html>
