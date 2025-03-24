<%@ page import="java.sql.*, com.mycompany.clinicdb.DBConnection" %>
<html>
<head>
    <title>Add Treatment</title>
</head>
<body>
    <h2>Add Treatment</h2>
    
    <form method="post">
        <label for="diagnosis_id">Enter Diagnosis ID:</label>
        <input type="text" name="diagnosis_id" required>
        <input type="submit" name="fetch" value="Fetch Diagnosis">
    </form>

    <%
        String diagnosis_id = request.getParameter("diagnosis_id");
        String diagnosis = "";
        String doctorName = "";
        String patientName = "";
        
        if (diagnosis_id != null && !diagnosis_id.isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                
                // Fetch diagnosis details along with doctor and patient name
                String query = "SELECT d.diagnosis, p.first_name AS patient_first, p.last_name AS patient_last, " +
                               "doc.First_name AS doctor_first, doc.last_name AS doctor_last " +
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
            <input type="submit" name="add" value="Add Treatment">
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
    %>
                        <p style="color: green;">Treatment added successfully!</p>
    <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            }
        }
    %>
</body>
</html>