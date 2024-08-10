<form id="withdrawForm" onsubmit="return submitWithdrawForm()">
    <div class="form-group">
        <label for="withdrawAmount">Amount:</label>
        <input type="text" id="withdrawAmount" name="amount" required>
    </div>
    <input type="submit" value="Withdraw" class="button">
</form>

<script>
function submitWithdrawForm() {
    var amount = parseFloat(document.getElementById('withdrawAmount').value);
    var currentBalance = parseFloat(<%= rs.getDouble("initial_balance") %>);  // Assuming you're passing the current balance from JSP

    if (amount <= 0) {
        alert("Amount must be greater than 0.");
        return false;
    }

    if (amount > currentBalance) {
        alert("Insufficient balance. Please enter a smaller amount.");
        return false;
    }

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
