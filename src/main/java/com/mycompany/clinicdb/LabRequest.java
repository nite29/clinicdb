package com.mycompany.clinicdb;

import java.sql.*;

public class LabRequest {
    public String lab_request_id = null;
    public String mrn = null;
    public String npi = null;
    public String reason = null;
    public String request_date = null;

    // Add a new lab request
    public static int add_labrequest(String mrn, String npi, String reason, String request_date) {
        // SQL query
        String query = "INSERT INTO lab_requests (mrn, npi, reason, request_date) VALUES (?, ?, ?, ?)";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure the driver is loaded
            try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(query)) {

                // Set parameters for the query
                ps.setString(1, mrn);
                ps.setString(2, npi);
                ps.setString(3, reason);
                ps.setString(4, request_date);

                // Execute the query
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0 ? 1 : 0; // Return 1 if successful, 0 otherwise
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // Return 0 if an error occurred
    }

    // Update a lab request
    public static int update_labrequest(String lab_request_id, String field, String newValue) {
        // SQL query
        String query = "UPDATE lab_requests SET " + field + " = ? WHERE lab_request_id = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure the driver is loaded
            try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(query)) {

                // Set parameters for the query
                ps.setString(1, newValue);
                ps.setString(2, lab_request_id);

                // Execute the query
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0 ? 1 : 0; // Return 1 if successful, 0 otherwise
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // Return 0 if an error occurred
    }

    // Delete a lab request
    public static int delete_labrequest(String lab_request_id) {
        // SQL query
        String query = "DELETE FROM lab_requests WHERE lab_request_id = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure the driver is loaded
            try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(query)) {

                // Set parameters for the query
                ps.setString(1, lab_request_id);

                // Execute the query
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0 ? 1 : 0; // Return 1 if successful, 0 otherwise
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // Return 0 if an error occurred
    }

    // View a lab request by ID
    public int view_labrequest(String lab_request_id) {
        // SQL query
        String query = "SELECT * FROM lab_requests WHERE lab_request_id = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure the driver is loaded
            try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(query)) {

                // Set parameters for the query
                ps.setString(1, lab_request_id);

                // Execute the query
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    // Populate the object with the retrieved data
                    this.lab_request_id = rs.getString("lab_request_id");
                    this.mrn = rs.getString("mrn");
                    this.npi = rs.getString("npi");
                    this.reason = rs.getString("reason");
                    this.request_date = rs.getString("request_date");
                    return 1; // Return 1 if the lab request is found
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // Return 0 if the lab request is not found or an error occurred
    }
}