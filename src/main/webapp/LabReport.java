package com.mycompany.clinicdb;

import java.sql.*;

public class LabReport {
    public String lab_report_id = null;
    public String lab_request_id = null;
    public String mrn = null;
    public String npi = null;
    public String payment_id = null;
    public String findings = null;
    public String lab_test_datetime = null;
    public String lab_fees = null;
    public String lab_results = null;
    public String report_status = null;
    public String payment_status = null;
    
    // Returns int
    // -1 : appointment overlaps with another
    // -2 : doctor is already booked at the same time
    // 1 : it worked
    // 0 idk wtf happened
    public static int add_labreport(String lab_request_id, String mrn, String npi,
                                      String payment_id, String findings, String date, String time,
                                      String lab_fees, String lab_results, 
                                      String report_status, String payment_status){
        // sql query
        String query = "INSERT INTO lab_reports (lab_request_id, mrn, npi, "
                + "payment_id, findings, lab_test_datetime, "
                + "lab_fees, lab_results, report_status, payment_status) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?);";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // PLS DONT REMOVE
            try {
                Connection conn = DriverManager.getConnection(DBConnection.URL,
                        DBConnection.USER, DBConnection.PASSWORD);
                
                PreparedStatement ps, ps2, ps3, ps4;
                ResultSet rs2, rs3, rs4; // note: rs doesnt exist
                
                //Parse html date and time inputs
                String datetime = date + " " + time;
                
                // Check if lab report overlaps with another
                ps4 = conn.prepareStatement("SELECT lrp.lab_report_id "
                        + "FROM lab_reports lrp "
                        + "WHERE lrp.lab_test_datetime = ? ");
                ps4.setString(1, datetime); 
                rs4 = ps4.executeQuery();
                
                if (rs4.next()){ return -1; }
                
                // Check if doctor is booked
                ps3 = conn.prepareStatement("SELECT d.npi FROM doctors d "
                        + "JOIN lab_reports lrp ON d.npi=lrp.npi "
                        + "WHERE lrp.lab_test_datetime = ? ");
                ps3.setString(1, datetime);
                rs3 = ps3.executeQuery();
                
                if (rs3.next()){ return -2; }
                
                // MAIN INSERT SQL QUERY
                ps = conn.prepareStatement(query);
                ps.setString(1, lab_request_id);
                ps.setString(2, mrn);
                ps.setString(3, npi);
                ps.setString(4, payment_id);
                ps.setString(5, findings);
                ps.setString(6, datetime);
                ps.setString(7, lab_fees);  
                ps.setString(8, lab_results);
                ps.setString(9, report_status);
                ps.setString(10, payment_status);
                
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
    

    public int cascadeDeleteLabReport(String labReportId) {
    Connection conn = null;
    PreparedStatement deletePaymentsStmt = null;
    PreparedStatement deleteLabReportStmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure MySQL driver is loaded
        conn = DriverManager.getConnection(DBConnection.URL, DBConnection.USER, DBConnection.PASSWORD);
        conn.setAutoCommit(false); // Start transaction

        // Step 1: Delete related payments first
        String deletePaymentsQuery = "DELETE FROM payments WHERE lab_report_id = ?";
        deletePaymentsStmt = conn.prepareStatement(deletePaymentsQuery);
        deletePaymentsStmt.setString(1, labReportId);
        int paymentsDeleted = deletePaymentsStmt.executeUpdate();

        // Step 2: Delete the lab report
        String deleteLabReportQuery = "DELETE FROM lab_reports WHERE lab_report_id = ?";
        deleteLabReportStmt = conn.prepareStatement(deleteLabReportQuery);
        deleteLabReportStmt.setString(1, labReportId);
        int labReportsDeleted = deleteLabReportStmt.executeUpdate();

        conn.commit(); // Commit transaction

        // Return total rows deleted (both from payments and lab_reports)
        return paymentsDeleted + labReportsDeleted;
    } catch (Exception e) {
        if (conn != null) {
            try {
                conn.rollback(); // Rollback transaction in case of error
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }
        e.printStackTrace();
        return -1; // Indicate an error occurred
    } finally {
        // Close resources in reverse order
        try {
            if (deleteLabReportStmt != null) deleteLabReportStmt.close();
            if (deletePaymentsStmt != null) deletePaymentsStmt.close();
            if (conn != null) conn.close();
        } catch (SQLException closeEx) {
            closeEx.printStackTrace();
        }
    }
    }
    
}