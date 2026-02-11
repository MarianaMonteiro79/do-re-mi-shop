<%@ page import="modelo.ProdutoDAO, modelo.Produto, java.util.List, java.util.ArrayList" %>
<%
    int produtoId = Integer.parseInt(request.getParameter("produtoId"));

    ProdutoDAO dao = new ProdutoDAO();
    Produto produto = dao.buscarPorId(produtoId);

    if (produto != null) {
        List<Produto> listaEncomendas = (List<Produto>) session.getAttribute("listaEncomendas");
        if (listaEncomendas == null) {
            listaEncomendas = new ArrayList<>();
        }

        listaEncomendas.add(produto);
        session.setAttribute("listaEncomendas", listaEncomendas);
    }

    response.sendRedirect("sistemaReserva.jsp");
%>
