<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Process</title>
    </head>
    <body>
        <jsp:useBean id="diagnosis_adder" class="com.mycompany.clinicdb.Diagnosis" scope="page"/>
        <%
            int appointment = diagnosis_adder.add_diagnosis(request.getParameter("appointment_id"),
                                            request.getParameter("diagnosis"));
                                            
            if (appointment == 1){out.println("<h1>Successfully added diagnosis.</h1><br>"); }
            else if (appointment == -1) {
                out.println("<h1>Failed to add diagnosis.</h1><br>"
                + "<p>Diagnosis adding failed</p>");
            } 
            else if (appointment == 0) {
                out.println("<h1>Failed to do anything.</h1><br>"
                + "<p>Failed to do anything</p>");
            } 
            
    %>
            


    </body>
</html>