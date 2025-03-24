<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Doctor Process</title>
    </head>
    <body>
        <jsp:useBean id="A" class="com.mycompany.clinicdb.Doctor" scope="page"/>
        <%
            int appointment = A.add_doctor(request.getParameter("last_name"),
                                            request.getParameter("First_name"),
                                            request.getParameter("middle_name"),
                                            request.getParameter("sex"),
                                            request.getParameter("birth_date"),
                                            request.getParameter("medical_certification"),
                                            request.getParameter("years_of_service"),
                                            request.getParameter("specialization"));
                                            
            if (appointment == 1){out.println("<h1>Successfully added doctor.</h1><br>"); }
            else if (appointment == -1) {
                out.println("<h1>Failed to add doctor.</h1><br>"
                + "<p>doctor adding failed</p>");
            } 
            else if (appointment == 0) {
                out.println("<h1>Failed to do anything.</h1><br>"
                + "<p>Failed to do anything</p>");
            } 
            
    %>
            


    </body>
</html>
