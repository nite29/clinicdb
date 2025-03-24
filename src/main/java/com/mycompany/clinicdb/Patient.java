package com.mycompany.clinicdb;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.logging.Level;
import java.util.logging.Logger;
import java.io.IOException;
import java.util.logging.LogManager;


public class Patient {
    public String mrn = null;
    public String last_name = null;
    public String first_name = null;
    public String middle_name = null;
    public String sex = null;
    public String birth_date = null;
    public String contact_no = null;

    // logger code
    private static final Logger logger = Logger.getLogger(Patient.class.getName());   
    static {
        try {
            // Load logging configuration
            LogManager.getLogManager().readConfiguration(Patient.class.getResourceAsStream("/logging.properties"));
        } catch (IOException e) {
            // Log the error using the logger
            logger.severe("Failed to load logging configuration: " + e.getMessage());
            e.printStackTrace(); // Optional: Print stack trace for debugging
        } catch (NullPointerException e) {
            // Handle the case where the resource is not found
            logger.severe("Logging properties file not found: " + e.getMessage());
        }
    }

    // Returns int
    // -1 : patient overlaps with another
    // -2 : doctor is already booked at the same time
    // 1 : it worked
    // 0 idk wtf happened
    public static int add_patient(String last_name, String first_name,
                                      String middle_name,
                                      String sex, String birthday,
                                      String contact_no){
        // sql query
        String query = "INSERT INTO `clinic`.`patients` (last_name, first_name, "
                + "middle_name, sex, birth_date, contact_no) "
                + "VALUES (?,?,?,?,?,?);";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
            try {
                Connection conn = DriverManager.getConnection(DBConnection.URL,
                        DBConnection.USER, DBConnection.PASSWORD);
                
                PreparedStatement ps; // note: rs doesnt exist
                
                // MAIN INSERT SQL QUERY
                ps = conn.prepareStatement(query);
                ps.setString(1, last_name);
                ps.setString(2, first_name);
                ps.setString(3, middle_name);
                ps.setString(4, sex);
                ps.setString(5, birthday);
                ps.setString(6, contact_no);
                
                ps.executeUpdate();
                ps.close();
                conn.close();

                return 1;
                
            } catch (Exception e){
                e.printStackTrace();
                System.err.println("SQL Error: " + e.getMessage());
                logger.log(Level.SEVERE, "SQL Error: " + e.getMessage(), e);
                return -1;
            }
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "JDBC Driver not found: " + e.getMessage(), e);
            e.printStackTrace();
            return 0;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "An unexpected error occurred: " + e.getMessage(), e);
            e.printStackTrace();
            return 0;
        }
    }

    public int view_patient(String value) {
        String query = "SELECT * FROM patients WHERE mrn = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
            try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
            PreparedStatement ps = conn.prepareStatement(query)) {
    
                // Convert value to integer if searching by mrn
                ps.setString(1,value);
    
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        this.mrn = rs.getString("mrn");  // ✅ Correctly assigning mrn
                        this.last_name = rs.getString("last_name");
                        this.first_name = rs.getString("first_name"); // ✅ Fixed capitalization
                        this.middle_name = rs.getString("middle_name");
                        this.sex = rs.getString("sex");
                        this.birth_date = rs.getString("birth_date");
                        this.contact_no = rs.getString("contact_no");
                        return 1; // Doctor found
                    } else {
                        this.mrn = "No Doctor found";
                        return 0; // Doctor not found
                    }
                }
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid MRN format: " + value);
            return -1;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
            return -1;
        }
    }


    public int deletePatient(String value){
        

        String query = "DELETE FROM patients WHERE mrn = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
            try {
                Connection conn = DriverManager.getConnection(DBConnection.URL,
                        DBConnection.USER, DBConnection.PASSWORD);
                
                PreparedStatement ps;
                
                ps = conn.prepareStatement(query);
                ps.setString(1, value);
                ps.executeUpdate();
                
                return 1;
   
            } catch (Exception e){
                e.printStackTrace();
                System.err.println("SQL Error: " + e.getMessage());
                return -1;
            }
        } catch (Exception e){
            e.printStackTrace();
            return 0;
        
        }
    
    }
}
