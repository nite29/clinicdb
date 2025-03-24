package com.mycompany.clinicdb;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class Diagnosis {
    public String diagnosis_id = null;
    public String appointment_id = null;
    public String diagnosis = null;
    public String treatment = null;
    
    // Returns int
    // -1 : appointment overlaps with another
    // -2 : doctor is already booked at the same time
    // 1 : it worked
    // 0 idk wtf happened
    public static int add_diagnosis(String appointment_id,
                                      String diagnosis){
        // sql query
        String query = "INSERT INTO diagnosis (appointment_id, "
                + "diagnosis)"
                + "VALUES (?,?);";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
            try {
                Connection conn = DriverManager.getConnection(DBConnection.URL,
                        DBConnection.USER, DBConnection.PASSWORD);
                
                PreparedStatement ps; // note: rs doesnt exist
                
                
            
                
                // MAIN INSERT SQL QUERY
                ps = conn.prepareStatement(query);
                ps.setString(1, appointment_id);
                ps.setString(2, diagnosis);
                
                ps.executeUpdate();
                ps.close();
                conn.close();

                return 1;
                
            } catch (Exception e){
                e.printStackTrace();
                System.err.println("SQL Error: " + e.getMessage());
                return -1;
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return 0;
    }

    public int view_diagnosis(String value) {
        String query = "SELECT * FROM diagnosis WHERE  diagnosis_id  = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
            try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
            PreparedStatement ps = conn.prepareStatement(query)) {
    
                // Convert value to integer if searching by NPI
                ps.setString(1,value);
    
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        this.diagnosis_id = rs.getString("diagnosis_id");  // ✅ Correctly assigning NPI
                        this.appointment_id = rs.getString("appointment_id");
                        this.diagnosis = rs.getString("diagnosis"); // ✅ Fixed capitalization
                        return 1; // Doctor found
                    } else {
                        this.diagnosis_id = "No Diagnosis found";
                        return 0; // Doctor not found
                    }
                }
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid Diagnosis ID format: " + value);
            return -1;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
            return -1;
        }
        
    }
    public int update_diagnosis(String value, String diagnosis_id, String field) {
        String query = "UPDATE diagnosis SET " + field + " = ? WHERE diagnosis_id = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
            try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(query)) {

                ps.setString(1, value);
                ps.setString(2, diagnosis_id);

                int updatedRows = ps.executeUpdate(); // Use executeUpdate for UPDATE queries
                return updatedRows > 0 ? 1 : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
            return -1;
        }
    }

    
}
