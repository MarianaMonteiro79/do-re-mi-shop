<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String nome = request.getParameter("nome");
    String email = request.getParameter("email");
    String mensagem = request.getParameter("mensagem");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/do_re_mi_shop", "root", "M15C16_mr");

        PreparedStatement pst = con.prepareStatement("INSERT INTO Contactos (nome, email, mensagem) VALUES (?, ?, ?)");
        pst.setString(1, nome);
        pst.setString(2, email);
        pst.setString(3, mensagem);

        int linhasAfetadas = pst.executeUpdate();

        if (linhasAfetadas > 0) {
            out.println("<script>alert('Mensagem enviada com sucesso!'); window.location='index.jsp#contacto';</script>");
        } else {
            out.println("<script>alert('Erro ao enviar a mensagem. Tente novamente.'); window.location='index.jsp#contacto';</script>");
        }

        pst.close();
        con.close();

    } catch (Exception e) {
        out.println("<h2>Erro ao processar contacto</h2>");
        out.println("<p>" + e.getMessage() + "</p>");
    }
%>
