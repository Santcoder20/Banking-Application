<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            padding: 20px;
            background-color: #f8d7da;
            color: #721c24;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #f5c6cb;
            border-radius: 5px;
            background-color: #f8d7da;
        }
        h1 {
            font-size: 24px;
            margin-bottom: 10px;
        }
        p {
            font-size: 18px;
            margin-bottom: 20px;
        }
        a {
            color: #155724;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
    <script type="text/javascript">
        window.onload = function() {
            var urlParams = new URLSearchParams(window.location.search);
            var errorMessage = urlParams.get('errorMessage');
            var balance = urlParams.get('balance');

            if (errorMessage && balance) {
                alert(errorMessage + " Your current balance is: " + balance);
                window.location.href = 'customerDashboard.jsp'; // Redirect to withdraw.jsp after the alert
            }
        };
    </script>
</head>
<body>
</body>
</html>
