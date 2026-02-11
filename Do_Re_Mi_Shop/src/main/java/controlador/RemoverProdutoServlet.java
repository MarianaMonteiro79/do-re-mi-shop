package controlador;

import modelo.ProdutoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/removerProduto")
public class RemoverProdutoServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    	System.out.println("Servlet removerProduto chamado. Parâmetro id: " + req.getParameter("id"));
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            ProdutoDAO dao = new ProdutoDAO();
            dao.removerProduto(id);
            resp.sendRedirect("produtos.jsp?sucesso=Produto+removido");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("produtos.jsp?erro=Erro+ao+remover+produto");
        }
    }
}