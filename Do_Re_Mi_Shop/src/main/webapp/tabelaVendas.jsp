<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    try {
        // Receber os dados do formulário
        String produto = request.getParameter("product");
        int quantidade = Integer.parseInt(request.getParameter("quantity"));
        String cliente = request.getParameter("clientName");
        String contacto = request.getParameter("clientContact");
        String pagamento = request.getParameter("paymentMethod");
        String endereco = request.getParameter("deliveryAddress");
        String dataEntrega = request.getParameter("deliveryDate");

        // Conexão com BD
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Do_Re_Mi_Shop", "root", "M15C16_mr");

        String sql = "INSERT INTO registoVendas (nome_produto, qtd, nome_cliente, contacto, metodoPagamento, end_entrega, data) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, produto);
        stmt.setInt(2, quantidade);
        stmt.setString(3, cliente);
        stmt.setString(4, contacto);
        stmt.setString(5, pagamento);
        stmt.setString(6, endereco);
        stmt.setString(7, dataEntrega);

        int linhasAfetadas = stmt.executeUpdate();

        stmt.close();
        con.close();

        if (linhasAfetadas > 0) {
            response.sendRedirect("inventario.jsp");
        } else {
            response.sendRedirect("erro.jsp");
        }

    } catch (Exception e) {
        out.println("<h2>Erro ao registar venda</h2>");
        out.println("<p>" + e.getMessage() + "</p>");
    }
%>
