<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mycompany.clinicdb.Doctor" %>

<jsp:useBean id="A" class="com.mycompany.clinicdb.Doctor" scope="page"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Doctor Record</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <script>
        function confirmDeletion() {
            return confirm("Are you sure you want to delete this doctor record? This action cannot be undone.");
        }
    </script>
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow-lg">
        <div class="card-header bg-danger text-white text-center">
            <h2>Delete Doctor Record</h2>
        </div>
        <div class="card-body">
            
            <form method="POST" action="doctor_delete.jsp" onsubmit="return confirmDeletion();">
                <div class="mb-3">
                    <label for="npi" class="form-label">Enter Doctor's NPI:</label>
                    <input type="text" id="npi" name="npi" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-danger w-100">Delete</button>
            </form>

            <hr>

            <%
                String npi = request.getParameter("npi");

                if (npi != null && !npi.trim().isEmpty()) {
                    int result = A.deleteDoctor(npi);
                    
                    if (result == 1) {
            %>
                        <div class="alert alert-success text-center" role="alert">
                            Doctor record deleted successfully.
                        </div>
            <%
                    } else if (result == 0) {
            %>
                        <div class="alert alert-warning text-center" role="alert">
                            No doctor found with the given NPI.
                        </div>
            <%
                    } else {
            %>
                        <div class="alert alert-danger text-center" role="alert">
                            An error occurred while deleting the record. Please try again.
                        </div>
            <%
                    }
                }
            %>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
