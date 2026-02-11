<%@ page import="java.sql.*" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
int id = Integer.parseInt(request.getParameter("id"));

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Do_Re_Mi_Shop", "root", "M15C16_mr");

        PreparedStatement stmt = con.prepareStatement("SELECT * FROM registoVendas WHERE Id_vendas = ?");
        stmt.setInt(1, id);
		ResultSet rs = stmt.executeQuery();

		if (rs.next()) {
%>
<p><strong>Produto:</strong> <%= rs.getString("nome_produto") %></p>
<p><strong>Quantidade:</strong> <%= rs.getInt("qtd") %></p>
<p><strong>Cliente:</strong> <%= rs.getString("nome_cliente") %></p>
<p><strong>Contacto:</strong> <%= rs.getString("contacto") %></p>
<p><strong>Pagamento:</strong> <%= rs.getString("metodoPagamento") %></p>
<p><strong>Endereço:</strong> <%= rs.getString("end_entrega") %></p>
<p><strong>Data de Entrega:</strong> <%= rs.getDate("data") %></p>
<%
        } else {
            out.print("<p>Venda não encontrada.</p>");
        }

        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        out.print("<p>Erro: " + e.getMessage() + "</p>");
    }
%>
