<%@ page import="java.sql.*" %>
<%
    String accountNo = (String) session.getAttribute("account_no");
    String newPassword = request.getParameter("new_password");

    if (newPassword != null && !newPassword.isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Update to the correct driver class name if needed
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "2004");
            PreparedStatement ps = con.prepareStatement("UPDATE Customer SET password=?, first=1 WHERE account_no=?");
            ps.setString(1, newPassword);
            ps.setString(2, accountNo);
            ps.executeUpdate();
            response.sendRedirect("customerLogin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<html>
<head>
    <title>Change Password</title>
</head>
<body>
    <form action="password.jsp" method="post">
        <label for="new_password">New Password:</label>
        <input type="password" id="new_password" name="new_password" required>
        <button type="submit">Change Password</button>
    </form>
</body>
</html>
