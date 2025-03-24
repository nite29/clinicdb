<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Lab Request</title>
    <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        /* Form Styles */
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
            color: #555;
        }

        select, input {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        /* Button Styles */
        button {
            width: 100%;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 12px;
            margin-top: 15px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>Add Lab Request</h1>
        <form action="labrequest_process.jsp" method="post">
            
            <label for="mrn">Select the Patient</label>
            <select name="mrn" id="mrn" required>
                <jsp:include page="helper_select_patient.jsp"></jsp:include>
            </select>
            
            <label for="npi">Select the Attending Doctor</label>
            <select name="npi" id="npi" required>
                <jsp:include page="helper_select_doctor.jsp"></jsp:include>
            </select>
            
            <label for="reason">Reason for Lab Request</label>
            <input type="text" id="reason" name="reason" placeholder="Enter reason" required>
            
            <label for="request_date">Request Date</label>
            <input type="date" id="request_date" name="request_date" required>
            
            <button type="submit">Submit Lab Request</button>
        </form>
    </div>

</body>
</html>
