package com.mycompany.clinicdb;

import java.sql.*;
import java.util.*;

public class Appointments {
    public String appointment_id;
    public String mrn;
    public String npi;
    public String lab_report_id;
    public String purpose = null;
    public String start_datetime = null;
    public String end_datetime = null;
    public String appointment_fees = null;
    public String payment_status = null;
    public String patient_name = null;
    public String sex = null;
    public String birth_date = null;
    public String contact_no = null;
    public String attending_doctor = null;
    public String specialization = null;
    public String lab_report_status = null;
    public String lab_fees = null;
    public String total_fees = null;
    
            
    public ArrayList<Appointments> view_appointment(String var, String varname){
        String query = "SELECT " 
    + "a.appointment_id AS appointment_id, "
    + "CONCAT(COALESCE(p.first_name, ''), ' ', "
    + "(CASE WHEN (p.middle_name IS NOT NULL AND p.middle_name <> '') "
    + "THEN CONCAT(p.middle_name, ' ') ELSE '' END), "
    + "COALESCE(p.last_name, '')) AS patient_name, "
    + "p.sex AS sex, "
    + "p.birth_date AS birth_date, "
    + "p.contact_no AS contact_no, "
    + "CONCAT(COALESCE(d.first_name, ''), ' ', "
    + "(CASE WHEN (d.middle_name IS NOT NULL AND d.middle_name <> '') "
    + "THEN CONCAT(d.middle_name, ' ') ELSE '' END), "
    + "COALESCE(d.last_name, '')) AS attending_doctor, "
    + "d.specialization AS specialization, "
    + "a.purpose AS purpose, "
    + "a.start_datetime AS start_datetime, "
    + "a.end_datetime AS end_datetime, "
    + "lr.report_status AS lab_report_status, "
    + "a.appointment_fees, "
    + "lr.lab_fees, "
    + "(a.appointment_fees + lr.lab_fees) AS total_fees, "
    + "a.payment_status AS payment_status "
    + "FROM appointments a "
    + "JOIN patients p ON a.mrn = p.mrn "
    + "JOIN doctors d ON a.npi = d.npi "
    + "JOIN lab_reports lr ON a.lab_report_id = lr.lab_report_id "
    + "WHERE ? LIKE CONCAT('%', ?, '%');";
        ArrayList<Appointments> appointmentsList = new ArrayList<>();
        
        try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure MySQL driver is loaded
            try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(query)) {

                ps.setString(1, var);
                ps.setString(2, varname);
                
                ResultSet rs = ps.executeQuery();
                while (rs.next()){
                    Appointments appt = new Appointments();
                        appt.appointment_id = rs.getString("appointment_id");
                        appt.patient_name = rs.getString("patient_name");
                        appt.sex = rs.getString("sex");
                        appt.birth_date = rs.getString("birth_date");
                        appt.contact_no = rs.getString("contact_no");
                        appt.attending_doctor = rs.getString("attending_doctor");
                        appt.specialization = rs.getString("specialization");
                        appt.purpose = rs.getString("purpose");
                        appt.start_datetime = rs.getString("start_datetime");
                        appt.end_datetime = rs.getString("end_datetime");
                        appt.lab_report_status = rs.getString("lab_report_status");
                        appt.appointment_fees = rs.getString("appointment_fees");
                        appt.lab_fees = rs.getString("lab_fees");
                        appt.total_fees = rs.getString("total_fees");
                        appt.payment_status = rs.getString("payment_status");
                        
                        appointmentsList.add(appt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } return appointmentsList;
    } 

    
    public void get_appointment(String appointment_id){
        String query = "SELECT * FROM appointments WHERE appointment_id = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
                try (Connection conn = DriverManager.getConnection(DBConnection.URL,
                     DBConnection.USER, DBConnection.PASSWORD);
                     PreparedStatement ps = conn.prepareStatement(query)) {
                    
                ps.setInt(1, Integer.parseInt(appointment_id));
                
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    this.appointment_id = rs.getString("appointment_id");
                    this.mrn = rs.getString("mrn");
                    this.npi = rs.getString("npi");
                    this.lab_report_id = rs.getString("lab_report_id");
                    this.purpose = rs.getString("purpose");
                    this.start_datetime = rs.getString("start_datetime");
                    this.end_datetime = rs.getString("end_datetime");
                    this.appointment_fees = rs.getString("appointment_fees");
                    this.payment_status = rs.getString("payment_status");
                }
                
                } catch (Exception e) {
                    e.printStackTrace();
                }
        } catch (Exception e) {
                    e.printStackTrace();
        }
    }
    
    // Returns int
    // -1 : appointment overlaps with another
    // -2 : doctor is already booked at the same time
    // 1 : it worked
    // 0 idk wtf happened
    public static int add_appointment(String mrn, String npi,
                                      String lab_report_id,
                                      String purpose, String date,
                                      String start_time, String end_time,
                                      String appointment_fee){
        // sql query
        String query = "INSERT INTO appointments (mrn, npi, "
                + "lab_report_id, purpose, start_datetime, end_datetime, "
                + "appointment_fees, payment_status) "
                + "VALUES (?,?,?,?,?,?,?,?);";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
            try {
                Connection conn = DriverManager.getConnection(DBConnection.URL,
                        DBConnection.USER, DBConnection.PASSWORD);
                
                // due to a severe lack of refactoring, there is no ps2
                PreparedStatement ps, ps3, ps4;
                ResultSet rs3, rs4; // note: rs and rs2 doesnt exist
               
                //Parse html date and time inputs
                String start_datetime = date+" "+start_time;
                String end_datetime = date+" "+end_time;
                
                // Check if appointment overlaps with another
                ps4 = conn.prepareStatement("SELECT a.appointment_id "
                        + "FROM appointments a "
                        + "WHERE a.start_datetime < ? AND a.end_datetime > ? ");
                ps4.setString(1,start_datetime);
                ps4.setString(2,end_datetime);
                rs4 = ps4.executeQuery();
                
                if (rs4.next()){ return -1; }
                
                // Check if doctor is booked
                ps3 = conn.prepareStatement("SELECT d.npi FROM doctors d "
                        + "JOIN appointments a ON d.npi=a.npi "
                        + "WHERE a.start_datetime < ? AND a.end_datetime > ? ");
                ps3.setString(1,start_datetime);
                ps3.setString(2,end_datetime);
                rs3 = ps3.executeQuery();
                
                if (rs3.next()){ return -2; }
                
                // MAIN INSERT SQL QUERY
                ps = conn.prepareStatement(query);
                ps.setString(1, mrn);
                ps.setString(2, npi);
                if (lab_report_id == null || lab_report_id.isEmpty()) {
                    lab_report_id = null;
                }
                ps.setString(3, lab_report_id);
                ps.setString(4, purpose);
                ps.setString(5, start_datetime);
                ps.setString(6, end_datetime);
                ps.setString(7, appointment_fee);
                ps.setString(8, "unpaid"); // hardcoded default
                
                ps.executeUpdate();
                return 1;
                
            } catch (Exception e){
                e.printStackTrace();
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return 0;
    }
    
    public int update_appointment(String appointment_id, String purpose, String date, 
                              String start_time, String end_time, 
                              String appointment_fees, String payment_status) {
    
    String start_datetime = date + " " + start_time;
    String end_datetime = date + " " + end_time;

    String query = "UPDATE appointments SET purpose = ?, start_datetime = ?, "
            + "end_datetime = ?, appointment_fees = ? "
            + "WHERE appointment_id = ?;";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure MySQL driver is loaded
        try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, purpose);
            ps.setString(2, start_datetime);
            ps.setString(3, end_datetime);
            ps.setDouble(4, Double.parseDouble(appointment_fees));
            ps.setInt(5, Integer.parseInt(appointment_id));

            int affectedRows = ps.executeUpdate(); // Check if update was successful
            return affectedRows > 0 ? 1 : 0; // Return 1 if rows were updated, 0 otherwise
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    return -1; // Return -1 if there was an error
    }
    
    public static int cancel_appointment(int appointment_id) {
    String getLabReportQuery = "SELECT lab_report_id FROM appointments WHERE appointment_id = ?";
    String getLabRequestQuery = "SELECT lab_request_id FROM lab_reports WHERE lab_report_id = ?";
    String deletePaymentsQuery = "DELETE FROM payments WHERE lab_report_id = ?";
    String deleteLabReportQuery = "DELETE FROM lab_reports WHERE lab_report_id = ?";
    String deleteLabRequestQuery = "DELETE FROM lab_requests WHERE lab_request_id = ?";
    String deleteAppointmentQuery = "DELETE FROM appointments WHERE appointment_id = ?";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL driver
        try (Connection conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD)) {
            conn.setAutoCommit(false); // Begin transaction

            Integer labReportId = null;
            Integer labRequestId = null;

            // Step 1: Get the associated lab_report_id
            try (PreparedStatement psGetLabReport = conn.prepareStatement(getLabReportQuery)) {
                psGetLabReport.setInt(1, appointment_id);
                ResultSet rsLab = psGetLabReport.executeQuery();
                if (rsLab.next()) {
                    labReportId = rsLab.getInt("lab_report_id");
                }
            }

            if (labReportId != null) {
                // Step 2: Get the associated lab_request_id
                try (PreparedStatement psGetLabRequest = conn.prepareStatement(getLabRequestQuery)) {
                    psGetLabRequest.setInt(1, labReportId);
                    ResultSet rsReq = psGetLabRequest.executeQuery();
                    if (rsReq.next()) {
                        labRequestId = rsReq.getInt("lab_request_id");
                    }
                }

                // Step 3: Delete related payments
                try (PreparedStatement psPay = conn.prepareStatement(deletePaymentsQuery)) {
                    psPay.setInt(1, labReportId);
                    psPay.executeUpdate();
                }

                // Step 4: Delete lab report
                try (PreparedStatement psLab = conn.prepareStatement(deleteLabReportQuery)) {
                    psLab.setInt(1, labReportId);
                    psLab.executeUpdate();
                }

                // Step 5: Delete lab request (if exists)
                if (labRequestId != null) {
                    try (PreparedStatement psLabReq = conn.prepareStatement(deleteLabRequestQuery)) {
                        psLabReq.setInt(1, labRequestId);
                        psLabReq.executeUpdate();
                    }
                }
            }

            // Step 6: Delete the appointment
            try (PreparedStatement psApp = conn.prepareStatement(deleteAppointmentQuery)) {
                psApp.setInt(1, appointment_id);
                int affectedRows = psApp.executeUpdate();

                if (affectedRows > 0) {
                    conn.commit(); // Commit transaction
                    return 1; // Success
                } else {
                    conn.rollback(); // Rollback if no appointment was deleted
                    return 0;
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        return -1; // Error occurred
    }
    }
    

}

        
