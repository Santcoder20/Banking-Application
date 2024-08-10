import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/WithdrawServlet")
public class WithdrawServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String accountNo = (String) session.getAttribute("account_no");
        double amount = Double.parseDouble(request.getParameter("amount"));

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "2004");

            PreparedStatement ps = con.prepareStatement("SELECT initial_balance FROM Customer WHERE account_no = ?");
            ps.setString(1, accountNo);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                double currentBalance = rs.getDouble("initial_balance");

                // Validate amount
                if (amount <= 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().print("Amount must be greater than 0.");
                    return;
                }

                if (currentBalance < amount) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().print("Insufficient balance.");
                    return;
                }

                // Deduct amount from initial_balance
                ps = con.prepareStatement("UPDATE Customer SET initial_balance = initial_balance - ? WHERE account_no = ?");
                ps.setDouble(1, amount);
                ps.setString(2, accountNo);
                ps.executeUpdate();

                // Insert transaction with current timestamp
                Timestamp timestamp = new Timestamp(System.currentTimeMillis());
                ps = con.prepareStatement("INSERT INTO Transaction (account_no, amount, type, transaction_date) VALUES (?, ?, 'Withdraw', ?)");
                ps.setString(1, accountNo);
                ps.setDouble(2, amount);
                ps.setTimestamp(3, timestamp);
                ps.executeUpdate();

                response.sendRedirect("withdrawSuccess.jsp");

            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().print("Account not found.");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
