package controlador;

import modelo.Produto;
import modelo.ProdutoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/editarProduto")
public class EditarProdutoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String nome = req.getParameter("Nome");
            String categoria = req.getParameter("Categoria");
            double preco = Double.parseDouble(req.getParameter("Preco"));
            int stock = Integer.parseInt(req.getParameter("Stock"));
            String imagem = req.getParameter("Imagem");

            // Valor padrão para imagem se vazio
            if (imagem == null || imagem.trim().isEmpty()) {
                imagem = "default.jpg";
            }

            Produto produto = new Produto(id, nome, preco, stock,categoria, imagem, 0.0);
            ProdutoDAO dao = new ProdutoDAO();
            dao.atualizarProduto(produto);

            System.out.println("Produto atualizado com sucesso:");
            System.out.println("ID: " + id);
            System.out.println("Nome: " + nome);
            System.out.println("Categoria: " + categoria);
            System.out.println("Preço: " + preco);
            System.out.println("Stock: " + stock);
            System.out.println("Imagem: " + imagem);

            resp.sendRedirect("produtos.jsp?sucesso=Produto+atualizado");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("produtos.jsp?erro=Erro+ao+atualizar+produto");
        }
    }
}