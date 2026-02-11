<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Criar conta</title>
  <link rel="stylesheet" href="login.css">
</head>
<body>
  <main>
    <header>
      <div class="logo">
        <a href="index.jsp">Do Re Mi Shop</a>
      </div>
      <div class="search-bar">
        <input type="text" placeholder="Pesquisar produtos...">
        <button>Pesquisar</button>
      </div>
      <nav class="menu">
      	<a href="registoVendas.jsp" class="role-btn admin">Vendas</a>
      	<a href="sistemaReserva.jsp" class="role-btn funcionario">Encomendas</a>
      	<a href="inventario.jsp" class="role-btn fornecedor">Inventário</a>
      	<a href="#">Produtos</a>
      	<a href="carrinho.jsp">Carrinho</a>  
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
      <h1>Criar conta</h1>

      <section class="formulario">
        <form action="RegistarConta_Admin.jsp" method="post">
            <section class="perg_pessoais">
                <label for="nome">Nome:</label> <br>
                <input type="text" id="nome" name="nome"> <br><br>

                <label for="email">Email:</label> <br>
                <input type="email" id="email" name="email" 
                       value="<%= request.getParameter("valorEmail") != null ? request.getParameter("valorEmail") : "" %>"> <br>

                <% if ("email".equals(request.getParameter("erro"))) { %>
                  <label style="color: red; font-size: 12px;">Email existente</label>
                <% } %>
                <br>

                <label for="password">Senha:</label> <br>
                <input type="password" id="senha" name="senha"> <br><br>
            </section>

            <section>
                <label>Selecione o tipo de acesso:</label> <br>

                <input type="radio" name="tipo" value="Administrador"> 
				<label for="g1">Administrador</label> <br>

				<input type="radio" name="tipo" value="Funcionário">
				<label for="g2">Funcionário</label> <br>
				
				<input type="radio" name="tipo" value="Fornecedor">
				<label for="g3">Fornecedor</label> <br>

            </section> <br>

            <input type="submit" value="Registar"> <br>
        </form> 
      </section>

    </div>
  </main>

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
  
    userIcon.addEventListener('mouseover', () => {
      userMenu.style.display = 'block';
    });
  
    userIcon.addEventListener('mouseleave', () => {
      userMenu.style.display = 'none';
    });
  </script>  
</body>
</html>
