<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String nome = request.getParameter("nome");
    String email = request.getParameter("email").replaceAll("\\s+", "").toLowerCase();
    String senha = request.getParameter("senha");
    String tipo = request.getParameter("tipo"); // "Administrador", "Funcionário", "Fornecedor"

    String URL = "jdbc:mysql://localhost:3306/Do_Re_Mi_Shop?useSSL=false";
    String username = "root";
    String password = "M15C16_mr";
    Connection con = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(URL, username, password);

        // Verificar se email já existe
        PreparedStatement checkStmt = con.prepareStatement("SELECT COUNT(*) FROM Login WHERE Email = ?");
        checkStmt.setString(1, email);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next() && rs.getInt(1) > 0) {
            response.sendRedirect("Cria_admin.jsp?erro=email&valorEmail=" + email);
            return;
        }

        // Inicializar todas as flags a 0
        int isAdmin = 0, isFuncionario = 0, isFornecedor = 0, isCliente = 0;

        // Determinar o tipo com base na escolha
        if ("Administrador".equals(tipo)) {
            isAdmin = 1;
        } else if ("Funcionário".equals(tipo)) {
            isFuncionario = 1;
        } else if ("Fornecedor".equals(tipo)) {
            isFornecedor = 1;
        } else {
            isCliente = 1; // fallback (pode não ser necessário)
        }

        // Inserir novo utilizador com flags corretas
        PreparedStatement insertStmt = con.prepareStatement(
            "INSERT INTO Login (Utilizador, Senha, Email, E_admin, E_cliente, E_fornecedor, E_funcionario) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)"
        );
        insertStmt.setString(1, nome);
        insertStmt.setString(2, senha);
        insertStmt.setString(3, email);
        insertStmt.setInt(4, isAdmin);
        insertStmt.setInt(5, isCliente);
        insertStmt.setInt(6, isFornecedor);
        insertStmt.setInt(7, isFuncionario);

        int i = insertStmt.executeUpdate();

        if (i > 0) {
            response.sendRedirect("Cria_admin.jsp"); // Redireciona após registo com sucesso
        } else {
            response.sendRedirect("Cria_admin.jsp?erro=registo");
        }

        con.close();
    } catch(Exception e) {
        out.print("<h2>Erro ao ligar à base de dados</h2>");
        out.print("<p>" + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>
