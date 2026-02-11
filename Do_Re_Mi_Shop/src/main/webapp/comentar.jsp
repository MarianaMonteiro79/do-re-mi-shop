<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
    String atual = request.getRequestURI();
    session.setAttribute("ultimaPagina", atual);
%>

    
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Avalie seu Pedido</title>
    <link rel="stylesheet" href="stylecomentar.css">
</head>
<body>
    <header>
    <div class="logo"><a style="text-decoration: none; color: white" href="index.jsp">Do Re Mi Shop</a></div>
   
    <nav class="menu">
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

    <main class="review">
    <h1 class="review__title">Avalie seu pedido</h1>
    
    <form action="avaliarProduto.jsp" method="post" onsubmit="return validarAvaliacao();">
        <div class="review__stars">
            <input type="hidden" name="estrelas" id="estrelasSelecionadas">
            <span class="star" data-value="1">★</span>
            <span class="star" data-value="2">★</span>
            <span class="star" data-value="3">★</span>
            <span class="star" data-value="4">★</span>
            <span class="star" data-value="5">★</span>
        </div>

        <div class="review__comment-section">
            <label for="comment" class="review__label">Adicione um comentário:</label>
            <textarea id="comment" name="comentario" class="review__textarea" placeholder="..."></textarea>
        </div>

        <button type="submit" class="review__submit">Enviar Avaliação</button>
    </form>
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
    
    const estrelas = document.querySelectorAll('.review__stars .star');
    const inputEstrelas = document.getElementById('estrelasSelecionadas');

    let estrelasSelecionadas = 0;

    // Remove a seleção de todas
    function limparSelecao() {
      estrelas.forEach(e => e.classList.remove('selecionada'));
    }

    // Marca até a estrela n (índice)
    function marcarEstrelas(n) {
      limparSelecao();
      for(let i = 0; i < n; i++) {
        estrelas[i].classList.add('selecionada');
      }
    }

    // Clique: define a seleção definitiva
    estrelas.forEach((estrela, i) => {
      estrela.addEventListener('click', () => {
        estrelasSelecionadas = i + 1;
        inputEstrelas.value = estrelasSelecionadas;
        marcarEstrelas(estrelasSelecionadas);
      });

      // Hover: mostra visual temporário
      estrela.addEventListener('mouseenter', () => {
        marcarEstrelas(i + 1);
      });

      // Sai do hover: volta à seleção atual
      estrela.addEventListener('mouseleave', () => {
        marcarEstrelas(estrelasSelecionadas);
      });
    });

    // Inicializa visual de acordo com valor já selecionado (se houver)
    if (inputEstrelas.value) {
      estrelasSelecionadas = parseInt(inputEstrelas.value);
      marcarEstrelas(estrelasSelecionadas);
    }

  </script>   

</body>
</html>
