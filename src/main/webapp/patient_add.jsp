<!DOCTYPE html>
<html lang="en">
<head>
    <title>Add Patient</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            width: 100%;
            max-width: 400px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        input, select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            width: 100%;
            background: #007bff;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 15px;
            font-size: 16px;
        }
        button:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Add Patient</h1>
    <form action="patient_process.jsp" method="post">
        <label for="last_name">Last Name:</label>
        <input type="text" id="last_name" name="last_name" required>

        <label for="first_name">First Name:</label>
        <input type="text" id="first_name" name="first_name" required>

        <label for="middle_name">Middle Name:</label>
        <input type="text" id="middle_name" name="middle_name">

        <label for="sex">Sex:</label>
        <select id="sex" name="sex" required>
            <option value="">Select</option>
            <option value="M">Male</option>
            <option value="F">Female</option>
        </select>

        <label for="birth_date">Birthdate:</label>
        <input type="date" name="birth_date" id="birth_date" required>

        <label for="contact_no">Contact No.:</label>
        <input type="tel" id="contact_no" name="contact_no" pattern="\d{10,15}" required 
               title="Contact number must be between 10 and 15 digits.">

        <button type="submit">Submit Patient</button>
    </form>
</div>

</body>
</html>
