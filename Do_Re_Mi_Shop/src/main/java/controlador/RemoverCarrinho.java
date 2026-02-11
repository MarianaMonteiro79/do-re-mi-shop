package controlador;

import modelo.ItemCarrinho;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/RemoverCarrinho")
public class RemoverCarrinho extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");

        if (carrinho != null) {
            int produtoId = Integer.parseInt(request.getParameter("produtoId"));
            carrinho.removeIf(item -> item.getProduto().getId() == produtoId);
            session.setAttribute("carrinho", carrinho);
        }

        // Redireciona de volta para o carrinho
        response.sendRedirect("carrinho.jsp");
    }
}