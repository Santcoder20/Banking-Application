import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterCustomerServlet")
public class RegisterCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("full_name");
        String address = request.getParameter("address");
        String mobileNo = request.getParameter("mobile_no");
        String emailId = request.getParameter("email_id");
        String accountType = request.getParameter("account_type");
        double initialBalance = Double.parseDouble(request.getParameter("initial_balance"));
        String dateOfBirth = request.getParameter("date_of_birth");
        String idProof = request.getParameter("id_proof");
        String accountNo = generateAccountNo();
        String password = generateRandomPassword();

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bankingdb", "root", "2004");
            ps = con.prepareStatement("INSERT INTO Customer (full_name, address, mobile_no, email_id, account_type, initial_balance, date_of_birth, id_proof, account_no, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            ps.setString(1, fullName);
            ps.setString(2, address);
            ps.setString(3, mobileNo);
            ps.setString(4, emailId);
            ps.setString(5, accountType);
            ps.setDouble(6, initialBalance);
            ps.setDate(7, java.sql.Date.valueOf(dateOfBirth));
            ps.setString(8, idProof);
            ps.setString(9, accountNo);
            ps.setString(10, password);
            ps.executeUpdate();

            response.sendRedirect("registrationSuccess.jsp");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("registrationError.jsp");
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private String generateAccountNo() {
        SecureRandom random = new SecureRandom();
        return  ""+String.format("%8d", random.nextInt(100000000));
    }

    private String generateRandomPassword() {
        String allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder(8);

        for (int i = 0; i < 8; i++) {
            password.append(allowedChars.charAt(random.nextInt(allowedChars.length())));
        }

        return password.toString();
    }
}
