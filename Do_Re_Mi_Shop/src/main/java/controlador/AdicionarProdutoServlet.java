package controlador;

import modelo.Produto;
import modelo.ProdutoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/adicionarProduto")
public class AdicionarProdutoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Configurar a codificação do request para UTF-8
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        try {
            String nome = req.getParameter("Nome");
            String categoria = req.getParameter("Categoria");
            double preco = Double.parseDouble(req.getParameter("Preco"));
            int stock = Integer.parseInt(req.getParameter("Stock"));
            String imagem = req.getParameter("Imagem");

            if (imagem == null || imagem.trim().isEmpty()) {
                imagem = "default.jpg";
            }

            Produto produto = new Produto(0, nome, preco, stock,categoria, imagem,0.0);
            ProdutoDAO dao = new ProdutoDAO();
            dao.adicionarProduto(produto);

            resp.sendRedirect("produtos.jsp?sucesso=Produto+adicionado");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("produtos.jsp?erro=Erro+ao+adicionar+produto");
        }
    }
}