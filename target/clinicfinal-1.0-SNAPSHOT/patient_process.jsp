<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Patient Process</title>
    </head>
    <body>
        <jsp:useBean id="A" class="com.mycompany.clinicdb.Patient" scope="page"/>
        <%
            int patients = A.add_patient(request.getParameter("last_name"),
                                            request.getParameter("first_name"),
                                            request.getParameter("middle_name"),
                                            request.getParameter("sex"),
                                            request.getParameter("birth_date"),
                                            request.getParameter("contact_no"));

            if (patients == 1){out.println("<h1>Successfully added patient.</h1><br>"); }
            else if (patients == -1) {
                out.println("<h1>Failed to add patient.</h1><br>"
                + "<p>Patient adding failed</p>");
            } 
            else if (patients == 0) {
                out.println("<h1>Failed to do anything.</h1><br>"
                + "<p>Failed to do anything</p>");
            }
    %>
            


    </body>
</html>
