<%@ page import="java.sql.*" %>
<%
    String user = request.getParameter("nome");
    String email = request.getParameter("email").replaceAll("\\s+", "").toLowerCase();
    String pwd = request.getParameter("password");

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
            // Redirecionar com mensagem de erro e valor do email preenchido
            response.sendRedirect("criar.jsp?erro=email&valorEmail=" + email);
            return;
        }

        // Inserir novo utilizador
        PreparedStatement insertStmt = con.prepareStatement("INSERT INTO Login(Utilizador, Senha, Email) VALUES (?, ?, ?)");
        insertStmt.setString(1, user);
        insertStmt.setString(2, pwd);
        insertStmt.setString(3, email);

        int i = insertStmt.executeUpdate();

        if (i > 0) {
            session.setAttribute("Id", user);
            response.sendRedirect("login.jsp");
        } else {
            response.sendRedirect("index.jsp");
        }

        con.close();
    } catch(Exception e) {
        out.print("<h2>Erro ao ligar à base de dados</h2>");
        out.print("<p>" + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>
