<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="modelo.ProdutoDAO, modelo.Produto, java.util.List" %>
<%@ page import="java.util.Base64" %>

<%
    String atual = request.getRequestURI();
    session.setAttribute("ultimaPagina", atual);
    
    Integer isAdmin = (Integer) session.getAttribute("E_admin");
    Integer isCliente = (Integer) session.getAttribute("E_cliente");

    if (isAdmin == null) isAdmin = 0;
    if (isCliente == null) isCliente = 0;

    List<Produto> produtosPesquisados = (List<Produto>) request.getAttribute("produtosPesquisados");
    String termoPesquisa = (String) request.getAttribute("termoPesquisa");
    String escapedTermoPesquisa = (termoPesquisa != null) ? termoPesquisa.replaceAll("'", "\\\\'").replaceAll("\"", "\\\\\"").replaceAll("\n", "\\\\n") : "";

    ProdutoDAO produtoDAO = new ProdutoDAO();
    List<Produto> novidades = null;
    List<Produto> promocoes = null;
    try {
        novidades = produtoDAO.buscarNovidades();
        promocoes = produtoDAO.buscarPromocoes();
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    if (novidades == null || promocoes == null) { %>
    <p style="color: red;">Erro ao carregar novidades ou promoções. Verifique o console do servidor.</p>
<% } 
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Do Re Mi Shop</title>
    <link rel="stylesheet" href="style.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        const userType = {
            admin: <%= isAdmin %>,
            cliente: <%= isCliente %>,
        };

        window.onload = function () {
            document.querySelectorAll('.menu').forEach(menu => menu.style.display = 'none');

            if (userType.admin === 1) {
                document.getElementById('menu-administrador').style.display = 'block';
            } else if (userType.cliente === 1) {
                document.getElementById('menu-cliente').style.display = 'block';
            } else {
                document.getElementById('menu-cliente').style.display = 'block';
            }

            const searchInput = document.querySelector('.search-bar input');
            searchInput.focus();

            function toggleSections(showResults) {
                const novidades = document.getElementById('novidades');
                const promocoes = document.getElementById('promocoes');
                const contacto = document.getElementById('contacto');
                const resultados = document.getElementById('resultados-pesquisa');

                if (showResults) {
                    novidades.style.display = 'none';
                    promocoes.style.display = 'none';
                    contacto.style.display = 'none';
                    resultados.style.display = 'block';
                } else {
                    novidades.style.display = 'block';
                    promocoes.style.display = 'block';
                    contacto.style.display = 'block';
                    resultados.style.display = 'block';
                }
            }

            const initialTermo = "<%= escapedTermoPesquisa %>";
            if (initialTermo.trim().length > 0) {
                toggleSections(true);
                document.getElementById("resultados-pesquisa").innerHTML = "<p class='loading'>A pesquisar...</p>";
                realizarPesquisa(initialTermo);
            } else {
                toggleSections(false);
                document.getElementById("resultados-pesquisa").innerHTML = '<div class="grid"></div>';
            }

            function realizarPesquisa(termo) {
                if (termo.length > 0) {
                    toggleSections(true);
                    $.ajax({
                        url: 'pesquisarProduto',
                        method: 'POST',
                        data: { termoPesquisa: termo },
                        cache: false,
                        timeout: 5000,
                        beforeSend: function() {
                            document.getElementById("resultados-pesquisa").innerHTML = "<p class='loading'>A pesquisar...</p>";
                        },
                        success: function(response) {
                            console.log('Resposta do AJAX:', response);
                            $('#resultados-pesquisa').html(response);
                        },
                        error: function(xhr, status, error) {
                            console.error('Erro no AJAX:', status, error);
                            $('#resultados-pesquisa').html('<p>Erro ao buscar produtos. Tente novamente.</p>');
                        }
                    });
                } else {
                    toggleSections(false);
                    $('#resultados-pesquisa').html('<div class="grid"></div>');
                }
            }

            let timeout;
            searchInput.addEventListener('input', function() {
                clearTimeout(timeout);
                timeout = setTimeout(() => {
                    const termo = this.value.trim();
                    realizarPesquisa(termo);
                }, 300);
            });

            document.getElementById('searchForm').addEventListener('submit', function(event) {
                event.preventDefault();
                const termo = searchInput.value.trim();
                realizarPesquisa(termo);
            });
        };
    </script>
</head>
<body>
    <header>
        <div class="logo"><a style="text-decoration: none; color: white" href="index.jsp">Do Re Mi Shop</a></div>
        <div class="search-bar">
            <form id="searchForm" style="display: inline;">
                <input type="text" name="termoPesquisa" placeholder="Pesquisar produtos..." value="<%= termoPesquisa != null ? termoPesquisa : "" %>">
            </form>
        </div>
        <nav id="menu-cliente" style="display:none;" class="menu">
            <a href="#home">Início</a>
            <a href="#novidades">Novidades</a>
            <a href="#promocoes">Promoções</a>
            <a href="#contacto">Contacto</a>
            <a href="carrinho.jsp">Carrinho</a>      
        </nav>   
        
        <nav id="menu-administrador" style="display:none;" class="menu">
            <a href="Cria_admin.jsp">Contas</a>
            <a href="registoVendas.jsp" class="role-btn admin">Vendas</a>
            <a href="sistemaReserva.jsp" class="role-btn funcionario">Encomendas</a>
            <a href="inventario.jsp" class="role-btn fornecedor">Inventário</a>
            <a href="produtos.jsp">Produtos</a>
            <a href="carrinho.jsp">Carrinho</a>     
        </nav>
        
        <div class="header__user-icon" id="userIcon">
            👤
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

    <section id="home" class="banner">
        <div class="banner-content">
            <h1>Bem-vindo à Do Re Mi Shop!</h1>
            <p>Encontra os melhores instrumentos musicais ao melhor preço!</p>
        </div>
    </section>

    <main>
        <section id="resultados-pesquisa" class="secao">
            <h2 class="title" id="resultados-titulo"></h2>
            <div class="grid">
                <% if (produtosPesquisados != null && !produtosPesquisados.isEmpty()) { %>
                    <% for (Produto p : produtosPesquisados) { %>
                        <div class="item">
                            <div class="image">
                                <img class="foto" src="<%= p.getImagem() != null ? p.getImagem() : "default.jpg" %>" alt="<%= p.getNome() %>">
                            </div>
                            <div class="name"><%= p.getNome() %></div>
                            <p><%= String.format("%.2f", p.getPreco()) %>€</p><br>
                            <% if (p.getStock() > 0) { %>
                                    <form method="post" action="adicionarCarrinho">
                                        <input type="hidden" name="produtoId" value="<%= p.getId() %>">
                                        <button type="submit">Adicionar ao Carrinho</button>
                                    </form>
                                <% } else { %>
                                    <form method="post" action="adicionarProduto">
									    <input type="hidden" name="produtoId" value="<%= p.getId() %>">
									    <button type="submit" style="background-color: orange;">Encomendar</button>
									</form>

                                <% } %>
                        </div>
                    <% } %>
                <% } else if (termoPesquisa != null && !termoPesquisa.trim().isEmpty()) { %>
                    <p>Nenhum resultado encontrado para "<%= termoPesquisa %>"</p>
                <% } %>
            </div>
        </section>

        <!-- Seção de Novidades -->
        <section id="novidades" class="secao">
            <h2 class="title">Novidades</h2>
            <div class="grid">
                <% if (novidades != null && !novidades.isEmpty()) { %>
                    <% for (Produto p : novidades) { %>
                        <div class="item">
                            <div class="image">
                                <img class="foto" src="<%= p.getImagem() != null ? p.getImagem() : "default.jpg" %>" alt="<%= p.getNome() %>">
                            </div>
                            <div class="name"><%= p.getNome() %></div>
                            <p><%= String.format("%.2f", p.getPreco()) %>€</p><br>
                            <% if (p.getStock() > 0) { %>
                                    <form method="post" action="adicionarCarrinho">
                                        <input type="hidden" name="produtoId" value="<%= p.getId() %>">
                                        <button type="submit">Adicionar ao Carrinho</button>
                                    </form>
                                <% } else { %>
                                    <form method="post" action="adicionarProduto">
									    <input type="hidden" name="produtoId" value="<%= p.getId() %>">
									    <button type="submit" style="background-color: orange;">Encomendar</button>
									</form>

                                <% } %>
                        </div>
                    <% } %>
                <% } else { %>
                    <p>Nenhum produto novo disponível no momento.</p>
                <% } %>
            </div>
        </section>
        
        <!-- Seção de Promoções -->
        <section id="promocoes" class="secao secao-fullwidth">
            <div class="secao-content">
                <h2 class="title">Promoções</h2>
                <div class="grid">
                    <% if (promocoes != null && !promocoes.isEmpty()) { %>
                        <% for (Produto p : promocoes) { %>
                            <div class="item">
                                <div class="image">
                                    <img class="foto" src="<%= p.getImagem() != null ? p.getImagem() : "default.jpg" %>" alt="<%= p.getNome() %>">
                                </div>
                                <div class="name"><%= p.getNome() %> - <%= String.format("%.0f", p.getDesconto()) %>% OFF</div>
                                <p><s><%= String.format("%.2f", p.getPreco()) %>€</s></p>
                                <p><%= String.format("%.2f", p.getPrecoComDesconto()) %>€</p><br>
                                <% if (p.getStock() > 0) { %>
                                    <form method="post" action="adicionarCarrinho">
                                        <input type="hidden" name="produtoId" value="<%= p.getId() %>">
                                        <button type="submit">Adicionar ao Carrinho</button>
                                    </form>
                                <% } else { %>
                                    <form method="post" action="adicionarProduto">
									    <input type="hidden" name="produtoId" value="<%= p.getId() %>">
									    <button type="submit" style="background-color: orange;">Encomendar</button>
									</form>

                                <% } %>
                            </div>
                        <% } %>
                    <% } else { %>
                        <p>Nenhuma promoção disponível no momento.</p>
                    <% } %>
                </div>
            </div>
        </section>

        <section id="contacto" class="secao">
            <h2 class="title">Contacto</h2>
            <form class="contato-form" action="contacto_processa.jsp" method="post">
                <label for="nome">Nome</label>
			    <input type="text" id="nome" name="nome" placeholder="Digite o seu nome" required/>
			
			    <label for="email">Email</label>
			    <input type="email" id="email" name="email" placeholder="Digite o seu email" required/>
			
			    <label for="mensagem">Mensagem</label>
			    <textarea id="mensagem" name="mensagem" rows="4" placeholder="Escreva a sua mensagem..." required></textarea>
			
			    <button type="submit">Enviar</button>
            </form>
        </section>
    </main>

    <footer>
        <p>© 2025 Do Re Mi Shop. Todos os direitos reservados.</p>
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
