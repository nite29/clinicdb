<!DOCTYPE html>
<html>
    <head>
        <title>Add patient</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <h1>Add Patient</h1>
        <form action="patient_process.jsp" method="post">
            <label for="last_name">Last Name:</label>
            <input type="text" id="last_name" name="last_name" required><br>

            <label for="first_name">First Name:</label>
            <input type="text" id="first_name" name="first_name" required><br>
            
            <label for="middle_name">Middle_name:</label>
            <input type="text" id="middle_name" name="middle_name" ><br>
            
            <label for="sex">Sex</label>
            <select id="sex" name="sex" required>
                <option value="">Select</option>
                <option value="M">M</option>
                <option value="F">F</option>
            </select>
            <br>
            
            <!-- html date format: "YYYY-MM-DD"  -->
            <label for="birth_date">Select Birthdate</label>
            <input type="date" name="birth_date" id="birth_date" required><br>
            
            <label for="contact_no">Contact No.</label>
            <input type="number" id="contact_no" name="contact_no" pattern="\d{10,15}" required title="Contact number must be between 10 and 15 digits."><br>

            <button type="submit">Submit Patient</button>
        </form>
    </body
</html>
