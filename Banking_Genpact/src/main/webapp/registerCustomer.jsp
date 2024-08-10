<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register Customer</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <script>
    function validateInitialBalance() {
      var initialBalance = document.getElementById("initial_balance").value;
      if (initialBalance < 1000) {
        alert("Initial balance should be at least 1000.");
        return false;
      }
      return true;
    }
  </script> 
</head>
<body>
    <h2>Register Customer</h2>
    <% 
        // Check for errors from the servlet
        String error = (String)request.getAttribute("error");
        String fullName = request.getParameter("full_name");
        String address = request.getParameter("address");
        String mobileNo = request.getParameter("mobile_no");
        String emailId = request.getParameter("email_id");
        String accountType = request.getParameter("account_type");
        String initialBalance = request.getParameter("initial_balance");
        String dateOfBirth = request.getParameter("date_of_birth");
        String idProof = request.getParameter("id_proof");
    %>

    <form action="RegisterCustomerServlet" method="post" onsubmit="return validateInitialBalance()">
        <label for="full_name">Full Name:</label>
        <input type="text" id="full_name" name="full_name" value="<%= fullName %>"><br><br>
        
        <label for="address">Address:</label>
        <textarea id="address" name="address"><%= address %></textarea><br><br>
        
        <label for="mobile_no">Mobile No:</label>
        <input type="text" id="mobile_no" name="mobile_no" value="<%= mobileNo %>"><br><br>
        
        <label for="email_id">Email ID:</label>
        <input type="text" id="email_id" name="email_id" value="<%= emailId %>"><br><br>
        
        <label for="account_type">Account Type:</label>
        <select id="account_type" name="account_type">
            <option value="Saving" <%= "Saving".equals(accountType) ? "selected" : "" %>>Saving</option>
            <option value="Current" <%= "Current".equals(accountType) ? "selected" : "" %>>Current</option>
        </select><br><br>
        
        <label for="initial_balance">Initial Balance:</label>
        <input type="text" id="initial_balance" name="initial_balance" value="<%= initialBalance %>"><br><br>
        
        <label for="date_of_birth">Date of Birth:</label>
        <input type="date" id="date_of_birth" name="date_of_birth" value="<%= dateOfBirth %>"><br><br>
        
        <label for="id_proof">ID Proof:</label>
        <input type="text" id="id_proof" name="id_proof" value="<%= idProof %>"><br><br>
        
        <input type="submit" value="Register">
    </form>
</body>
</html>
