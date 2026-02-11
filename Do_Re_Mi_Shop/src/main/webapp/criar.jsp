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
        <a href="#home">Início</a>
        <a href="#novidades">Novidades</a>
        <a href="#promocoes">Promoções</a>
        <a href="#contacto">Contacto</a>
      </nav>
      <div class="header__user-icon" id="userIcon">
        &#x1F464;
        <div class="user-menu" id="userMenu">
          <a href="login.jsp">Login</a>
          <a href="criar.jsp">Criar Conta</a>
        </div>
      </div>
    </header>

    <div class="login-container">
      <h1>Criar conta</h1>

      <section class="formulario">
        <form action="registar_conta.jsp" method="post">
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
                <input type="password" id="password" name="password"> <br><br>
            </section>

            <section>
                <label>Género favorito:</label> <br>

                <input type="radio" id="g1" name="genero" value="Pop"> 
                <label for="g1">Pop</label> <br>
                <input type="radio" id="g2" name="genero" value="Jazz">
                <label for="g2">Jazz</label> <br>
                <input type="radio" id="g3" name="genero" value="Eletrônica">
                <label for="g3">Eletrônica</label> <br>
                <input type="radio" id="g4" name="genero" value="Hip Hop">
                <label for="g4">Hip Hop</label> <br>
                <input type="radio" id="g5" name="genero" value="Outro">
                <label for="g5">Outro</label> <br>
            </section> <br>

            <input type="submit" value="Regista-te"> <br>
        </form> 
      </section>

      <a href="login.jsp" style="font-size: 10px;">Já tens conta?</a>
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
