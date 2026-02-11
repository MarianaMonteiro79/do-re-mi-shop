<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("Email") == null && request.getRequestURI().indexOf("login.jsp") == -1) {
        String urlCompleta = request.getRequestURL().toString();
        String query = request.getQueryString();
        if (query != null) urlCompleta += "?" + query;
        session.setAttribute("ultimaPagina", urlCompleta);
    }
%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <title>Login</title>
  <link rel="stylesheet" href="login.css">
</head>
<body>
  <main>
    <header>
      <div class="logo"><a href="index.jsp">Do Re Mi Shop</a></div>
      
      <nav class="menu">
        <a href="index.jsp">Início</a>
        <a href="#novidades">Novidades</a>
        <a href="#promocoes">Promoções</a>
        <a href="#contacto">Contacto</a>
      </nav>
      <div class="header__user-icon" id="userIcon">
        &#x1F464;
        <% if (session.getAttribute("Nome") != null) { %>
          <span style="margin-left: 5px;"><%= session.getAttribute("Nome") %></span>
        <% } %>
        <div class="user-menu" id="userMenu">
          <% if (session.getAttribute("Email") != null) { %>
            <a href="logout.jsp">Logout</a>
          <% } else { %>
            <a href="login.jsp">Login</a>
            <a href="criar.jsp">Criar Conta</a>
          <% } %>
        </div>
      </div>
    </header>

    <div class="login-container">
      <h1>Login</h1>
      <p>Novo no site? <a href="criar.jsp">Crie uma conta</a></p><br>

      <section class="formulario">
        <form action="realizar_login.jsp" method="post">
          <label for="email">Seu email</label><br>
          <input type="email" id="email" name="email" required><br><br>

          <label for="password">Sua senha</label><br>
          <input type="password" id="password" name="password" required><br>
          <a href="#">Esqueceu a senha?</a><br><br>

          <input type="submit" value="Entrar"><br>
        </form>
        <% if (request.getAttribute("erroLogin") != null) { %>
          <p style="color: red;"><%= request.getAttribute("erroLogin") %></p>
        <% } %>
      </section>
    </div>
  </main>

  <footer>
    <p>&copy; 2025 Do Re Mi Shop. Todos os direitos reservados.</p>
    <p><a href="#">Política de Privacidade</a> | <a href="#">Termos de Serviço</a></p>
  </footer>

  <script>
    const userIcon = document.getElementById('userIcon');
    const userMenu = document.getElementById('userMenu');
    userIcon.addEventListener('mouseover', () => userMenu.style.display = 'block');
    userIcon.addEventListener('mouseleave', () => userMenu.style.display = 'none');
  </script>
</body>
</html>
