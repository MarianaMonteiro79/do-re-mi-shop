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
    <title>Registar de vendas</title>
    <link rel="stylesheet" href="vendas.css">

    <script>
        function toggleForm(id) {
            const form = document.getElementById(id);
            form.style.display = form.style.display === 'none' ? 'block' : 'none';
        }
    </script>

</head>
<body>
    <header>
    <div class="logo"><a style="text-decoration: none; color: white" href="index.jsp">Do Re Mi Shop</a></div>
    <div class="search-bar">
      <input type="text" placeholder="Pesquisar produtos...">
      <button>Pesquisar</button>
    </div>
    <nav class="menu">
           
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

    <main class="vendas">
        <h1 class="vendas__title">Registar de vendas</h1>

        <form action="tabelaVendas.jsp" method="post">
		  <!-- Produto -->
		  <div class="section">
		    <div class="section-header" onclick="toggleForm('product-form')">
		      <span>Selecionar Produto</span><span>▼</span>
		    </div>
		    <div id="product-form" class="form-content">
		      <label for="product">Produto:</label><br>
		      <input type="text" id="product" name="product"><br>
		      <label for="quantity">Quantidade:</label><br>
		      <input type="number" id="quantity" name="quantity"><br>
		    </div>
		  </div>
		
		  <!-- Cliente -->
		  <div class="section">
		    <div class="section-header" onclick="toggleForm('client-info-form')">
		      <span>Informações do Cliente</span><span>▼</span>
		    </div>
		    <div id="client-info-form" class="form-content">
		      <label for="client-name">Nome do Cliente:</label><br>
		      <input type="text" id="client-name" name="clientName"><br>
		      <label for="client-contact">Contacto:</label><br>
		      <input type="text" id="client-contact" name="clientContact"><br>
		    </div>
		  </div>
		
		  <!-- Pagamento -->
		  <div class="section">
		    <div class="section-header" onclick="toggleForm('payment-method-form')">
		      <span>Forma de Pagamento</span><span>▼</span>
		    </div>
		    <div id="payment-method-form" class="form-content">
		      <label for="payment-method">Método:</label><br>
		      <select id="payment-method" name="paymentMethod">
		        <option value="cartao">Cartão</option>
		        <option value="dinheiro">Dinheiro</option>
		        <option value="transferencia">Transferência</option>
		      </select>
		    </div>
		  </div>
		
		  <!-- Entrega -->
		  <div class="section">
		    <div class="section-header" onclick="toggleForm('delivery-info-form')">
		      <span>Informações de Entrega</span><span>▼</span>
		    </div>
		    <div id="delivery-info-form" class="form-content">
		      <label for="delivery-address">Endereço de Entrega:</label><br>
		      <input type="text" id="delivery-address" name="deliveryAddress"><br>
		      <label for="delivery-date">Data de Entrega:</label><br>
		      <input type="date" id="delivery-date" name="deliveryDate"><br>
		    </div>
		  </div>
		
		  <!-- Botões -->
		  <div class="vendas__actions">
		    <button type="button" class="vendas__button">Voltar</button>
		    <button type="submit" class="vendas__button vendas__button--primary">Registar venda</button>
		  </div>
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
  </script> 
    
</body>
</html>
