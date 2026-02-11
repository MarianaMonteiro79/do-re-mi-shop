<%@ page import="java.sql.*, java.util.*, modelo.ItemCarrinho" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
    if (carrinho == null || carrinho.isEmpty()) {
        out.println("<script>alert('Carrinho está vazio.'); window.location='carrinho.jsp';</script>");
        return;
    }

    String nomeCliente = (String) session.getAttribute("Nome");
    if (nomeCliente == null) nomeCliente = "Desconhecido";

    String contactoStr = request.getParameter("contacto");
    String metodo = request.getParameter("metodoPagamento");
    String endereco = request.getParameter("endereco");

    try {
        int contacto = Integer.parseInt(contactoStr);

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Do_Re_Mi_Shop", "root", "M15C16_mr");

        String sql = "INSERT INTO registoVendas (nome_produto, qtd, nome_cliente, contacto, metodoPagamento, end_entrega, data) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        PreparedStatement pst = con.prepareStatement(sql);

        for (ItemCarrinho item : carrinho) {
            pst.setString(1, item.getProduto().getNome());
            pst.setInt(2, item.getQuantidade());
            pst.setString(3, nomeCliente);
            pst.setInt(4, contacto);
            pst.setString(5, metodo);
            pst.setString(6, endereco);
            pst.executeUpdate();
        }

        pst.close();
        con.close();

        session.removeAttribute("carrinho");

        out.println("<script>alert('Compra efetuada com sucesso!'); window.location='index.jsp';</script>");
    } catch (Exception e) {
        out.println("<script>alert('Erro: " + e.getMessage().replace("'", "\\'") + "'); window.location='carrinho.jsp';</script>");
    }
%>
