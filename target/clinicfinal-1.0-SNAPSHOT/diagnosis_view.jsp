<%@ page import="com.mycompany.clinicdb.Diagnosis" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>

<html>
<head>
    <title>View Diagnosis</title>
</head>
<body>
    <h2>View Diagnosis</h2>
    <form method="POST" action="diagnosis_view.jsp">
        Enter Diagnosis ID: <input type="text" name="diagnosis_id" required>
        <input type="submit" value="Search">
    </form>

    <% 
        String diagnosisID = request.getParameter("diagnosis_id");
        if (diagnosisID != null && !diagnosisID.isEmpty()) {
            Diagnosis diagnosis = new Diagnosis();
            int result = diagnosis.view_diagnosis(diagnosisID);
            
            if (result == 1) { %>
                <h3>Diagnosis Details</h3>
                <p><strong>Diagnosis ID:</strong> <%= diagnosis.diagnosis_id %></p>
                <p><strong>Appointment ID:</strong> <%= diagnosis.appointment_id %></p>
                <p><strong>Diagnosis:</strong> <%= diagnosis.diagnosis %></p>
                
                <h3>Medications & Dosages</h3>
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);

                        String query = "SELECT medication, dosage FROM treatment WHERE diagnosis_id = ?";
                        pstmt = conn.prepareStatement(query);
                        pstmt.setInt(1, Integer.parseInt(diagnosisID));
                        rs = pstmt.executeQuery();
                        
                        boolean hasTreatments = false;
                        while (rs.next()) {
                            hasTreatments = true;
                %>
                            <p><strong>Medication:</strong> <%= rs.getString("medication") %> | 
                               <strong>Dosage:</strong> <%= rs.getString("dosage") %></p>
                <%
                        }
                        
                        if (!hasTreatments) {
                %>
                            <p style="color: red;">No treatments found for this diagnosis.</p>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            <% } else { %>
                <p style="color: red;">No diagnosis found for ID <%= diagnosisID %>.</p>
            <% } 
        } 
    %>
</body>
</html>