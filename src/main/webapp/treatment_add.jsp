<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>
<html>
<head>
    <title>Add Treatment</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
        }
        .container {
            max-width: 500px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            margin: auto;
        }
        h2, h3 {
            text-align: center;
            color: #333;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            width: 100%;
            background: #007bff;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover {
            background: #0056b3;
        }
        .success {
            color: green;
            text-align: center;
            font-weight: bold;
            margin-top: 10px;
        }
        .error {
            color: red;
            text-align: center;
            font-weight: bold;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Add Treatment</h2>
    
    <form method="post">
        <label for="diagnosis_id">Enter Diagnosis ID:</label>
        <input type="text" name="diagnosis_id" required>
        <button type="submit" name="fetch">Fetch Diagnosis</button>
    </form>

    <%
        String diagnosis_id = request.getParameter("diagnosis_id");
        String diagnosis = "";
        String doctorName = "";
        String patientName = "";

        if (request.getParameter("fetch") != null && diagnosis_id != null && !diagnosis_id.isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

                String query = "SELECT d.diagnosis, p.first_name AS patient_first, p.last_name AS patient_last, " +
                               "doc.first_name AS doctor_first, doc.last_name AS doctor_last " +
                               "FROM diagnosis d " +
                               "JOIN appointments a ON d.appointment_id = a.appointment_id " +
                               "JOIN patients p ON a.mrn = p.mrn " +
                               "JOIN doctors doc ON a.npi = doc.npi " +
                               "WHERE d.diagnosis_id = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, Integer.parseInt(diagnosis_id));
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    diagnosis = rs.getString("diagnosis");
                    patientName = rs.getString("patient_first") + " " + rs.getString("patient_last");
                    doctorName = rs.getString("doctor_first") + " " + rs.getString("doctor_last");
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error fetching diagnosis!</p>");
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        }

        if (!diagnosis.isEmpty()) {
    %>
        <h3>Diagnosis Details</h3>
        <p><strong>Diagnosis:</strong> <%= diagnosis %></p>
        <p><strong>Doctor:</strong> <%= doctorName %></p>
        <p><strong>Patient:</strong> <%= patientName %></p>

        <form method="post">
            <input type="hidden" name="diagnosis_id" value="<%= diagnosis_id %>">
            <label for="medication">Medication:</label>
            <input type="text" name="medication" required>
            <label for="dosage">Dosage:</label>
            <input type="text" name="dosage" required>
            <button type="submit" name="add">Add Treatment</button>
        </form>
    <%
        }

        if (request.getParameter("add") != null) {
            String medication = request.getParameter("medication");
            String dosage = request.getParameter("dosage");

            if (diagnosis_id != null && medication != null && dosage != null) {
                Connection conn = null;
                PreparedStatement pstmt = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

                    String insertQuery = "INSERT INTO treatment (diagnosis_id, medication, dosage) VALUES (?, ?, ?)";
                    pstmt = conn.prepareStatement(insertQuery);
                    pstmt.setInt(1, Integer.parseInt(diagnosis_id));
                    pstmt.setString(2, medication);
                    pstmt.setString(3, dosage);

                    int rowsAffected = pstmt.executeUpdate();
                    if (rowsAffected > 0) {
                        out.println("<p class='success'>Treatment added successfully!</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error adding treatment!</p>");
                    e.printStackTrace();
                } finally {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            }
        }
    %>
</div>

</body>
</html>