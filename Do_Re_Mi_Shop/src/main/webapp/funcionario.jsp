<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Funcionário</title>
  <link rel="stylesheet" href="login.css">
</head>
<body>

	<header>
      <div class="logo" style="font-size: 24px; font-weight: bold;">Do Re Mi Shop</div>
    
      <nav class="menu">
        <a href="produtos.jsp">Adicionar produtos</a>
        <a href="registoVendas.jsp">Registar vendas</a>
        <a href="inventario.jsp">Inventário</a>
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
    <h1>Funcionário</h1>
    <p>Selecione a página que deseja aceder:</p>

    <div class="roles">
      <a href="produtos.jsp" class="role-btn admin">Adicionar produtos</a>
      <a href="registoVendas.jsp" class="role-btn admin">Registar vendas</a>
      <a href="inventario.jsp" class="role-btn fornecedor">Inventário</a>
    </div>
  </div>

  <footer>
    <p>&copy; 2025 Do Re Mi Shop. Todos os direitos reservados.</p>
    <p>
      <a href="#">Política de Privacidade</a> | 
      <a href="#">Termos de Serviço</a>
    </p>
  </footer>
	<script>
    const userIcon = document.getElementById('userIcon');
    const userMenu = document.getElementById('userMenu');
    userIcon.addEventListener('mouseover', () => userMenu.style.display = 'block');
    userIcon.addEventListener('mouseleave', () => userMenu.style.display = 'none');
  </script>
</body>
</html>
