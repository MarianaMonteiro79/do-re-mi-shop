package controlador;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/RegistarVendaServlet")
public class RegistarVendaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Dados de conexão com BD
    private String jdbcURL = "jdbc:mysql://localhost:3306/sua_base";
    private String jdbcUser = "seu_usuario";
    private String jdbcPassword = "sua_senha";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String produto = request.getParameter("nome_produto");
        int quantidade = Integer.parseInt(request.getParameter("qtd"));
        String cliente = request.getParameter("nome_cliente");
        String contacto = request.getParameter("contacto");
        String pagamento = request.getParameter("metodoPagamento");
        String endereco = request.getParameter("end_entrega");
        String dataEntrega = request.getParameter("data");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, jdbcUser, jdbcPassword);

            String sql = "INSERT INTO registoVendas (nome_produto, qtd, nome_cliente, contacto, metodoPagamento, end_entrega, data) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, produto);
            stmt.setInt(2, quantidade);
            stmt.setString(3, cliente);
            stmt.setString(4, contacto);
            stmt.setString(5, pagamento);
            stmt.setString(6, endereco);
            stmt.setString(7, dataEntrega);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

            response.sendRedirect("inventario.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("erro.jsp");
        }
    }
}
