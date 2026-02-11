package controlador;

import modelo.Produto;
import modelo.ProdutoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/pesquisarProduto")
public class PesquisarProdutoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String termoPesquisa = req.getParameter("termoPesquisa");
        System.out.println("Pesquisa recebida: " + termoPesquisa);

        ProdutoDAO dao = new ProdutoDAO();
        List<Produto> produtos = dao.buscarProdutosPorNome(termoPesquisa != null ? termoPesquisa.trim() : "");
        System.out.println("Produtos encontrados: " + produtos.size());
        for (Produto p : produtos) {
            System.out.println("Produto: " + p.getNome() + ", ID: " + p.getId() + ", Imagem: " + p.getImagem());
        }

        // Verificar se a requisição é AJAX
        String isAjax = req.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(isAjax)) {
            // Retornar apenas a seção de resultados como HTML para AJAX
            try (PrintWriter out = resp.getWriter()) {
                out.println("<section id=\"resultados-pesquisa\" class=\"secao\">");
                if (produtos != null && !produtos.isEmpty()) {
                    out.println("<h2 class=\"title\">Resultados da Pesquisa para \"" + (termoPesquisa != null ? termoPesquisa : "") + "\"</h2>");
                    out.println("<div class=\"grid\">");
                    for (Produto p : produtos) {
                        out.println("<div class=\"item\">");
                        out.println("<div class=\"image\">");
                        out.println("<img class=\"foto\" src=\"" + (p.getImagem() != null ? p.getImagem() : "default.jpg") + "\" alt=\"" + p.getNome() + "\">");
                        out.println("</div>");
                        out.println("<div class=\"name\">" + p.getNome() + "</div>");
                        out.println("<p>Preço: " + String.format("%.2f", p.getPreco()) + "€</p><br>");
                        out.println("<form method=\"post\" action=\"AdicionarCarrinho\">");
                        out.println("<input type=\"hidden\" name=\"produtoId\" value=\"" + p.getId() + "\">");
                        out.println("<button type=\"submit\">Adicionar ao Carrinho</button>");
                        out.println("</form>");
                        out.println("</div>");
                    }
                    out.println("</div>");
                } else if (termoPesquisa != null && !termoPesquisa.trim().isEmpty()) {
                    out.println("<h2 class=\"title\">Nenhum resultado encontrado para \"" + termoPesquisa + "\"</h2>");
                    out.println("<div class=\"grid\"></div>"); // Garante que .grid existe mesmo sem resultados
                } else {
                    out.println("<div class=\"grid\"></div>"); // Garante que .grid existe para termos vazios
                }
                out.println("</section>");
            }
        } else {
            // Para requisições não-AJAX, redirecionar para index.jsp com os resultados
            req.setAttribute("produtosPesquisados", produtos);
            req.setAttribute("termoPesquisa", termoPesquisa);
            req.getRequestDispatcher("index.jsp").forward(req, resp);
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}