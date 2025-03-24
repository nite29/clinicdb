<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Appointment Process</title>
    </head>
    <body>
        <jsp:useBean id="A" class="com.mycompany.clinicdb.LabReport" scope="page"/>
        <%
            int labreport = A.add_labreport(request.getParameter("lab_request_id"),
                                            request.getParameter("mrn"),
                                            request.getParameter("npi"),
                                            request.getParameter("payment_id"),
                                            request.getParameter("findings"),
                                            request.getParameter("date"),
                                            request.getParameter("time"),
                                            request.getParameter("lab_fees"),
                                            request.getParameter("lab_results"),
                                            request.getParameter("report_status"),
                                            request.getParameter("payment_status"));
                                            
            if (labreport == 1){out.println("<h1>Successfully added lab report.</h1><br>"); }
            else if (labreport == -1) {
                out.println("<h1>Failed to add lab report.</h1><br>"
                + "<p>Lab Report overlaps with another lab report on the same date.</p>");
            } else if (labreport == -2) {
                out.println("<h1>Failed to add lab report.</h1><br>"
                + "<p>Doctor is already booked on this date.</p>");
            } else if (labreport == 0) {out.println("<h1>Bomboclat</h1><br>");
            }
            
    %>
            


    </body>
</html>
