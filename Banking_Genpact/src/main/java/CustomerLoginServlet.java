import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CustomerLoginServlet")
public class CustomerLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accountNo = request.getParameter("account_no");
        String password = request.getParameter("password");

        CustomerValidationResult result = validateCustomer(accountNo, password);

        if (result.isValidCustomer) {
            HttpSession session = request.getSession();
            session.setAttribute("account_no", accountNo);
            if (!result.isFirst) {
                System.out.println("Redirecting to customerDashboard.jsp");
                response.sendRedirect("customerDashboard.jsp");
            } else {
                System.out.println("Redirecting to password.jsp");
                response.sendRedirect("password.jsp");
            }
        } else {
            System.out.println("Invalid login, redirecting to customerLogin.jsp");
            response.sendRedirect("customerLogin.jsp");
        }
    }

    private CustomerValidationResult validateCustomer(String accountNo, String password) {
        CustomerValidationResult result = new CustomerValidationResult();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Update to the correct driver class name if needed
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "2004");
            PreparedStatement ps = con.prepareStatement("SELECT first FROM Customer WHERE account_no=? AND password=?");
            ps.setString(1, accountNo);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result.isValidCustomer = true;
                // Assuming 'first' column is an integer type and 0 indicates false, any other value indicates true
                int firstColumnValue = rs.getInt("first");
                result.isFirst = (firstColumnValue == 0)?true:false;
                System.out.println("first value: " + result.isFirst);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private class CustomerValidationResult {
        boolean isValidCustomer = false;
        boolean isFirst = false;
    }
}
