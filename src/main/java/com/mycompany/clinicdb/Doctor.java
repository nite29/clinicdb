package com.mycompany.clinicdb;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class Doctor {
    public String npi = null;
    public String last_name = null;
    public String First_name = null;
    public String middle_name = null;
    public String sex = null;
    public String birth_date = null;
    public String medical_certification = null;
    public String years_of_service = null;
    public String specialization = null;
    
    // Returns int
    // -1 : appointment overlaps with another
    // -2 : doctor is already booked at the same time
    // 1 : it worked
    // 0 idk wtf happened
    public static int add_doctor(String last_name, String First_name,
                                      String middle_name,
                                      String sex, String birthday,
                                      String medical_certification, String years_of_service,
                                      String specialization){
        // sql query
        String query = "INSERT INTO doctors (last_name, First_name, "
                + "middle_name, sex, birth_date, medical_certification, "
                + "years_of_service, specialization) "
                + "VALUES (?,?,?,?,?,?,?,?);";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
            try {
                Connection conn = DriverManager.getConnection(DBConnection.URL,
                        DBConnection.USER, DBConnection.PASSWORD);
                
                PreparedStatement ps; // note: rs doesnt exist
                
                
            
                
                // MAIN INSERT SQL QUERY
                ps = conn.prepareStatement(query);
                ps.setString(1, last_name);
                ps.setString(2, First_name);
                ps.setString(3, middle_name);
                ps.setString(4, sex);
                ps.setString(5, birthday);
                ps.setString(6, medical_certification);
                ps.setString(7, years_of_service);
                ps.setString(8, specialization); 
                
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

    public int view_doctor(String value) {
        String query = "SELECT * FROM doctors WHERE  npi  = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
            try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
            PreparedStatement ps = conn.prepareStatement(query)) {
    
                // Convert value to integer if searching by NPI
                ps.setString(1,value);
    
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        this.npi = rs.getString("npi");  // ✅ Correctly assigning NPI
                        this.last_name = rs.getString("last_name");
                        this.First_name = rs.getString("First_name"); // ✅ Fixed capitalization
                        this.middle_name = rs.getString("middle_name");
                        this.sex = rs.getString("sex");
                        this.birth_date = rs.getString("birth_date");
                        this.medical_certification = rs.getString("medical_certification");
                        this.years_of_service = rs.getString("years_of_service");
                        this.specialization = rs.getString("specialization");
                        return 1; // Doctor found
                    } else {
                        this.npi = "No Doctor found";
                        return 0; // Doctor not found
                    }
                }
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid NPI format: " + value);
            return -1;
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
            return -1;
        }
    }


    public int deleteDoctor(String value){
        

        String query = "DELETE FROM doctors WHERE npi = ?";

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
