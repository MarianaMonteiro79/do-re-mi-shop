package controlador;

import modelo.ProdutoDAO;
import modelo.Produto;
import modelo.ItemCarrinho;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/adicionarCarrinho")
public class AdicionarCarrinho extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
        
        // Initialize cart if it doesn't exist
        if (carrinho == null) {
            carrinho = new ArrayList<>();
            session.setAttribute("carrinho", carrinho);
        }

        // Get product ID from form
        String produtoIdStr = request.getParameter("produtoId");
        int produtoId;
        try {
            produtoId = Integer.parseInt(produtoIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("index.jsp?erro=ProdutoInvalido");
            return;
        }

        // Fetch product details
        ProdutoDAO produtoDAO = new ProdutoDAO();
        Produto produto;
        try {
            produto = produtoDAO.buscarPorId(produtoId);
            if (produto == null) {
                response.sendRedirect("index.jsp?erro=ProdutoNaoEncontrado");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?erro=ErroAoBuscarProduto");
            return;
        }

        // Check if product is already in cart
        boolean produtoJaNoCarrinho = false;
        for (ItemCarrinho item : carrinho) {
            if (item.getProduto().getId() == produtoId) {
                // Increment quantity if product is already in cart
                item.setQuantidade(item.getQuantidade() + 1);
                produtoJaNoCarrinho = true;
                break;
            }
        }

        // Add new product to cart if not already present
        if (!produtoJaNoCarrinho) {
            // Assuming ItemCarrinho has a constructor ItemCarrinho(Produto, int)
            ItemCarrinho item = new ItemCarrinho(produto, 1);
            carrinho.add(item);
        }

        // Update session
        session.setAttribute("carrinho", carrinho);

        // Redirect to cart page
        response.sendRedirect("carrinho.jsp");
    }
}