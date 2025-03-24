<!DOCTYPE html>
<html>
    <head>
        <title>Add doctor</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <h1>Add doctor</h1>
        <form action="doctor_process.jsp" method="post">
            <label for="last_name">Last Name:</label>
            <input type="text" id="last_name" name="last_name" required><br>

            <label for="First_name">First Name:</label>
            <input type="text" id="First_name" name="First_name" required><br>
            
            <label for="purpose">middle_name:</label>
            <input type="text" id="middle_name" name="middle_name" ><br>

            <label for="Sex">Sex</label>
            <select id="sex" name="sex" required>
                <option value="">Select</option>
                <option value="M">M</option>
                <option value="F">F</option>
            </select>
            <br>

            <!-- html date format: "YYYY-MM-DD"  -->
            <label for="date">Select Birthday</label>
            <input type="date" name="birth_date" id="birth_date" required><br>

            <label for="purpose">Medical Certification:</label>
            <input type="text" id="medical_certification" name="medical_certification" required><br>

            <label for="purpose">Years in Service:</label>
            <input type="text" id="years_of_service" name="years_of_service" required><br>

            <label for="purpose">Specialization:</label>
            <input type="text" id="specialization" name="specialization" required><br>
            
            
            <button type="submit">Submit Doctor</button>
        </form>
    </body
</html>
