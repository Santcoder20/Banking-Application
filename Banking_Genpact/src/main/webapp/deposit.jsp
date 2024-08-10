<form id="depositForm" onsubmit="return submitDepositForm()">
    <div class="form-group">
        <label for="depositAmount">Amount:</label>
        <input type="text" id="depositAmount" name="amount" required>
    </div>
    <input type="submit" value="Deposit" class="button">
</form>

<script>
function submitDepositForm() {
    // Parse the entered deposit amount
    var amount = parseFloat(document.getElementById('depositAmount').value);

    // Check if the deposit amount is less than or equal to 0
    if (amount <= 0) {
        alert("Amount must be greater than 0.");
        return false;  // Prevent form submission
    }

    return true;  // Allow form submission if validation passes
}
</script>
