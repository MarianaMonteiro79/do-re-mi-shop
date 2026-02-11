<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    try {
        String email = request.getParameter("email").toLowerCase().trim();
        String pwd = request.getParameter("password").trim();

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/do_re_mi_shop", "root", "M15C16_mr");
        Statement stat = con.createStatement();
        ResultSet rset = stat.executeQuery("SELECT * FROM Login WHERE Email='" + email + "' AND Senha='" + pwd + "'");

        if (rset.next()) {
            session.setAttribute("Email", email);
            session.setAttribute("Nome", rset.getString("Utilizador"));
            session.setAttribute("E_admin", rset.getInt("E_admin"));
            session.setAttribute("E_cliente", rset.getInt("E_cliente"));
            session.setAttribute("E_fornecedor", rset.getInt("E_fornecedor"));
            session.setAttribute("E_funcionario", rset.getInt("E_funcionario"));

            int isAdmin = rset.getInt("E_admin");
            int isCliente = rset.getInt("E_cliente");
            int isFornecedor = rset.getInt("E_fornecedor");
            int isFuncionario = rset.getInt("E_funcionario");

            if (isAdmin == 1) {
                response.sendRedirect("index.jsp");
            } else if (isFornecedor == 1) {
                response.sendRedirect("sistemaReserva.jsp");
            } else if (isFuncionario == 1) {
                response.sendRedirect("funcionario.jsp");
            } else if (isCliente == 1) {
                // Redireciona para a página anterior ou index.jsp
                String destino = (String) session.getAttribute("ultimaPagina");
                if (destino == null || destino.contains("login.jsp")) {
                    destino = "index.jsp";
                }
                response.sendRedirect(destino);
            } else {
                response.sendRedirect("index.jsp");
            }

        } else {
            request.setAttribute("erroLogin", "Email ou senha inválidos.");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        }

    } catch (Exception e) {
        out.println("<h2>Erro de conexão</h2>");
        out.println("<p>" + e.getMessage() + "</p>");
    }
%>
