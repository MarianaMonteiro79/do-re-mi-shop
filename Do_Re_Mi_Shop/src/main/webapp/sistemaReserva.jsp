<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="modelo.ProdutoDAO, modelo.Produto, java.util.List" %>
    
<%
    String atual = request.getRequestURI();
    session.setAttribute("ultimaPagina", atual);
%>


<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Reservas</title>
    <link rel="stylesheet" href="tabelas.css">
</head>
<body>
    <header>
    <div class="logo"><a style="text-decoration: none; color: white" href="index.jsp">Do Re Mi Shop</a></div>
    
    
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

    <main class="reservas">
        <h1 class="reservas__title">Sistema de encomendas</h1>
        <table class="reservas__table">
            <thead>
                <tr>
                    <th>Data</th>
                    <th>Produto</th>
                    <th>Nome do cliente</th>
                    <th>Preço</th>
                    <th>Estado da encomenda</th>
                </tr>
            </thead>
            <tbody>
			    <% 
			        List<Produto> listaEncomendas = (List<Produto>) session.getAttribute("listaEncomendas");
			        if (listaEncomendas != null && !listaEncomendas.isEmpty()) {
			            for (Produto p : listaEncomendas) {
			                String nomeCliente = (String) session.getAttribute("Nome"); // Pode pegar o cliente logado
			                String dataAtual = new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date());
			    %>
			        <tr>
			            <td><%= dataAtual %></td>
			            <td><%= p.getNome() %></td>
			            <td><%= nomeCliente != null ? nomeCliente : "Cliente Anónimo" %></td>
			            <td><%= String.format("%.2f€", p.getPreco()) %></td>
			            <td>Não confirmado</td>
			        </tr>
			    <% 
			            }
			        } else { 
			    %>
			        <tr><td colspan="5">Nenhuma encomenda registrada.</td></tr>
			    <% } %>
			</tbody>

        </table>

        <div class="reservas__actions">
            <button class="reservas__button">Voltar</button>
            <button class="reservas__button reservas__button--primary">Ver detalhes</button>
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
