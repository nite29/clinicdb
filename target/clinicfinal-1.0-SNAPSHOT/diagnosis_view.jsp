<%@ page import="com.mycompany.clinicdb.Diagnosis" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.clinicdb.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Diagnosis</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow-lg">
        <div class="card-header bg-primary text-white text-center">
            <h2>View Diagnosis</h2>
        </div>
        <div class="card-body">
            
            <form method="POST" action="diagnosis_view.jsp" class="mb-4">
                <div class="mb-3">
                    <label for="diagnosis_id" class="form-label">Enter Diagnosis ID:</label>
                    <input type="text" name="diagnosis_id" id="diagnosis_id" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Search</button>
            </form>

            <% 
                String diagnosisID = request.getParameter("diagnosis_id");
                if (diagnosisID != null && !diagnosisID.isEmpty()) {
                    Diagnosis diagnosis = new Diagnosis();
                    int result = diagnosis.view_diagnosis(diagnosisID);
                    
                    if (result == 1) { %>

                        <h3 class="text-success text-center">Diagnosis Details</h3>
                        <ul class="list-group mb-4">
                            <li class="list-group-item"><strong>Diagnosis ID:</strong> <%= diagnosis.diagnosis_id %></li>
                            <li class="list-group-item"><strong>Appointment ID:</strong> <%= diagnosis.appointment_id %></li>
                            <li class="list-group-item"><strong>Diagnosis:</strong> <%= diagnosis.diagnosis %></li>
                        </ul>

                        <h3 class="text-info">Medications & Dosages</h3>
                        <table class="table table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th>Medication</th>
                                    <th>Dosage</th>
                                </tr>
                            </thead>
                            <tbody>
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
                                        <tr>
                                            <td><%= rs.getString("medication") %></td>
                                            <td><%= rs.getString("dosage") %></td>
                                        </tr>
                            <%
                                    }

                                    if (!hasTreatments) {
                            %>
                                        <tr>
                                            <td colspan="2" class="text-danger text-center">No treatments found for this diagnosis.</td>
                                        </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                            %>
                                    <tr>
                                        <td colspan="2" class="text-danger text-center">Error retrieving data.</td>
                                    </tr>
                            <%
                                } finally {
                                    if (rs != null) rs.close();
                                    if (pstmt != null) pstmt.close();
                                    if (conn != null) conn.close();
                                }
                            %>
                            </tbody>
                        </table>

                    <% } else { %>
                        <p class="text-danger text-center">No diagnosis found for ID <strong><%= diagnosisID %></strong>.</p>
                    <% } 
                } 
            %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
