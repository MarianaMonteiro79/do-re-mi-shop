<%@ page import="java.sql.*, java.time.LocalDate" %>
<%
    String nomeCliente = (String) session.getAttribute("Nome");
    String comentario = request.getParameter("comentario");
    String estrelasStr = request.getParameter("estrelas");

    if (nomeCliente == null) nomeCliente = "Anônimo";

    try {
        int estrelas = Integer.parseInt(estrelasStr);

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/do_re_mi_shop", "root", "M15C16_mr");

        PreparedStatement pst = con.prepareStatement(
            "INSERT INTO avaliacoes (nome_cliente, estrelas, comentario, data_avaliacao) VALUES (?, ?, ?, ?)"
        );
        pst.setString(1, nomeCliente);
        pst.setInt(2, estrelas);
        pst.setString(3, comentario);
        pst.setDate(4, Date.valueOf(LocalDate.now()));

        pst.executeUpdate();
        pst.close();
        con.close();

        out.println("<script>alert('Obrigado pela sua avaliação!'); window.location='index.jsp';</script>");
    } catch (Exception e) {
        out.println("<script>alert('Erro ao enviar avaliação: " + e.getMessage().replace("'", "\\'") + "'); window.location='comentar.jsp';</script>");
    }
%>
