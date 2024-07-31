<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Dashboard</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: white;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            width: 80%;
            max-width: 600px;
            text-align: center;
        }
        .container h2 {
            margin-bottom: 20px;
        }
        .account-info {
            margin-bottom: 20px;
            text-align: left;
        }
        .button {
            display: inline-block;
            margin: 10px 5px;
            padding: 10px 20px;
            color: white;
            background-color: #4CAF50;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .button:hover {
            background-color: #45a049;
        }
        .button-secondary {
            background-color: #5bc0de;
        }
        .button-secondary:hover {
            background-color: #31b0d5;
        }
        .fa {
            margin-right: 8px;
        }
        /* Styles for dialogs */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 10% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 400px;
            border-radius: 5px;
            text-align: center;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Welcome, Customer</h2>
        <div class="account-info">
            <% String accountNo = (String) session.getAttribute("account_no");
               Class.forName("com.mysql.jdbc.Driver");
               Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "2004");
               PreparedStatement ps = con.prepareStatement("SELECT * FROM Customer WHERE account_no=?");
               ps.setString(1, accountNo);
               ResultSet rs = ps.executeQuery();
               if (rs.next()) { %>
                Account No: <%= rs.getString("account_no") %> <br>
                Balance: <%= rs.getDouble("initial_balance") %> <br>
            <% } %>
        </div>
        <a href="#" onclick="showDepositDialog()" class="button"><i class="fa fa-plus-circle"></i> Deposit</a>
        <a href="#" onclick="showWithdrawDialog()" class="button"><i class="far fa-minus-circle"></i> Withdraw</a>
        <a href="viewTransactions.jsp" class="button"><i class="fa fa-eye"></i> View Transaction</a>
        <a href="#" onclick="showCloseAccountDialog()" class="button button-secondary"><i class="fa fa-times-circle"></i> Close Account</a>
        <a href="logoutcustomer.jsp" class="button button-secondary"><i class="fa fa-sign-out-alt"></i> Logout</a>
		

    <!-- Deposit Dialog -->
    <div id="depositDialog" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeDialog('depositDialog')">&times;</span>
            <h2>Deposit Amount</h2>
            <form id="depositForm" onsubmit="return submitDepositForm()">
                <div class="form-group">
                    <label for="depositAmount">Amount:</label>
                    <input type="text" id="depositAmount" name="amount" required>
                </div>
                <input type="submit" value="Deposit" class="button">
            </form>
        </div>
    </div>

    <!-- Withdraw Dialog -->
    <div id="withdrawDialog" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeDialog('withdrawDialog')">&times;</span>
            <h2>Withdraw Amount</h2>
            <form id="withdrawForm" onsubmit="return submitWithdrawForm()">
                <div class="form-group">
                    <label for="withdrawAmount">Amount:</label>
                    <input type="text" id="withdrawAmount" name="amount" required>
                </div>
                <input type="submit" value="Withdraw" class="button">
            </form>
        </div>
    </div>

    <!-- Close Account Dialog -->
    <div id="closeAccountDialog" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeDialog('closeAccountDialog')">&times;</span>
            <h2>Close Account</h2>
            <form action="CloseAccountServlet" method="post">
                <label for="confirm">Are you sure you want to close your account?</label><br><br>
                <input type="submit" value="Yes" class="button">
                <a href="#" onclick="closeDialog('closeAccountDialog')" class="button button-secondary"><i class="fa fa-times"></i> No</a>
            </form>
        </div>
    </div>
<!-- Existing HTML and CSS omitted for brevity -->

<!-- Withdraw All Amount Dialog -->
<div id="withdrawAllDialog" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeDialog('withdrawAllDialog')">&times;</span>
        <h2>Withdraw All Amount</h2>
        <p>Current Balance: <span id="currentBalance"></span></p>
        <form action="WithdrawAllServlet" method="post">
            <input type="hidden" id="withdrawAllAmount" name="withdrawAllAmount">
            <input type="submit" value="Withdraw All" class="button">
        </form>
        <a href="#" onclick="closeDialog('withdrawAllDialog')" class="button button-secondary"><i class="fa fa-times"></i> Cancel</a>
    </div>
</div>

<!-- JavaScript to handle dialogs and AJAX requests -->
<script>
    function showWithdrawAllDialog(balance) {
        document.getElementById('currentBalance').innerText = balance;
        document.getElementById('withdrawAllAmount').value = balance;
        document.getElementById('withdrawAllDialog').style.display = 'block';
    }

    function attemptCloseAccount() {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'CloseAccountServlet', true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    if (response.balance > 0) {
                        showWithdrawAllDialog(response.balance);
                    } else {
                        // Balance is zero, proceed to close the account
                        document.getElementById('closeAccountDialog').style.display = 'block';
                    }
                }
            }
        };
        xhr.send();
    }

    // Function to show close account dialog
    function showCloseAccountDialog() {
        attemptCloseAccount();
    }

    // Function to close dialogs
    function closeDialog(dialogId) {
        document.getElementById(dialogId).style.display = 'none';
    }
</script>

    <!-- JavaScript to handle dialogs and AJAX requests -->
    <script>
        // Function to show deposit dialog
        function showDepositDialog() {
            document.getElementById('depositDialog').style.display = 'block';
        }

        // Function to show withdraw dialog
        function showWithdrawDialog() {
            document.getElementById('withdrawDialog').style.display = 'block';
        }

        // Function to show close account dialog
        function showCloseAccountDialog() {
            document.getElementById('closeAccountDialog').style.display = 'block';
        }

        // Function to close dialogs
        function closeDialog(dialogId) {
            document.getElementById(dialogId).style.display = 'none';
        }

        // Function to submit deposit form via AJAX
        function submitDepositForm() {
            var amount = document.getElementById('depositAmount').value;
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'DepositServlet', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        
                        closeDialog('depositDialog');
                        location.reload();
                    } else {
                        alert('Deposit failed: ' + xhr.responseText);
                    }
                }
            };
            xhr.send('amount=' + encodeURIComponent(amount));
            return false;
        }

        // Function to submit withdraw form via AJAX
        function submitWithdrawForm() {
            var amount = document.getElementById('withdrawAmount').value;
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'WithdrawServlet', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        
                        closeDialog('withdrawDialog');
                        location.reload();
                    } else {
                        alert('Withdrawal failed: ' + xhr.responseText);
                    }
                }
            };
            xhr.send('amount=' + encodeURIComponent(amount));
            return false;
        }
    </script>
</body>
</html>
