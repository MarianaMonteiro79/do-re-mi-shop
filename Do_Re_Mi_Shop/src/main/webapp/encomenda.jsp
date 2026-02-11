<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="modelo.ProdutoDAO, modelo.Produto, modelo.ItemCarrinho, java.util.List, java.util.ArrayList" %>
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

    // Obter o carrinho da sessão
    List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
    if (carrinho == null) {
        carrinho = new ArrayList<>();
        session.setAttribute("carrinho", carrinho);
    }

    // Calcular totais
    double subtotal = 0.0;
    for (ItemCarrinho item : carrinho) {
        subtotal += item.getSubtotal();
    }
    double iva = subtotal * 0.2; // 20% de IVA
    double total = subtotal + iva;
    
    
%>
<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Do Re Mi Shop - Carrinho</title>
    <link rel="stylesheet" href="styles.css">
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
                const cartSection = document.querySelector('.cart');
                const resultados = document.getElementById('resultados-pesquisa');

                if (showResults) {
                    cartSection.style.display = 'none';
                    resultados.style.display = 'block';
                } else {
                    cartSection.style.display = 'block';
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
    <header class="header">
        <div class="logo"><a style="text-decoration: none; color: white" href="index.jsp">Do Re Mi Shop</a></div>
        <div class="search-bar">
            <form id="searchForm" style="display: inline;">
                <input type="text" name="termoPesquisa" placeholder="Pesquisar produtos..." value="<%= termoPesquisa != null ? termoPesquisa : "" %>">
            </form>
        </div>
        <nav id="menu-cliente" style="display:none;" class="menu">
            <a href="index.jsp">Início</a>
            <a href="index.jsp#novidades">Novidades</a>
            <a href="index.jsp#promocoes">Promoções</a>
            <a href="index.jsp#contacto">Contacto</a>
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
                            <form method="post" action="AdicionarCarrinho">
                                <input type="hidden" name="produtoId" value="<%= p.getId() %>">
                                <button type="submit">Adicionar ao Carrinho</button>
                            </form>
                        </div>
                    <% } %>
                <% } else if (termoPesquisa != null && !termoPesquisa.trim().isEmpty()) { %>
                    <p>Nenhum resultado encontrado para "<%= termoPesquisa %>"</p>
                <% } %>
            </div>
        </section>

        <section class="cart">
            <h1 class="cart__title">Carrinho</h1>
            <% if (carrinho.isEmpty()) { %>
                <p>O seu carrinho está vazio.</p>
            <% } else { %>
                <table class="cart__table">
                    <thead>
                        <tr>
                            <th>Imagem</th>
                            <th>Produto</th>
                            <th>Quantidade</th>
                            <th>Preço Unitário</th>
                            <th>Total</th>
                            <th>Ação</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (ItemCarrinho item : carrinho) { %>
                            <tr>
                                <td><img src="<%= item.getProduto().getImagem() != null ? item.getProduto().getImagem() : "default.jpg" %>" alt="<%= item.getProduto().getNome() %>" class="cart__image"></td>
                                <td><%= item.getProduto().getNome() %></td>
                                <td>
                                    <form method="post" action="AtualizarCarrinho">
                                        <input type="hidden" name="produtoId" value="<%= item.getProduto().getId() %>">
										<input type="number" class="cart__quantity" name="quantidade" value="<%= item.getQuantidade() %>" readonly>

                                    </form>
                                </td>
                                <td><%= String.format("%.2f", item.getProduto().getPrecoComDesconto()) %>€</td>
                                <td><%= String.format("%.2f", item.getSubtotal()) %>€</td>
                                <td>
                                    <form method="post" action="RemoverCarrinho">
                                        <input type="hidden" name="produtoId" value="<%= item.getProduto().getId() %>">
                                        <button type="submit" class="remover-produto">Remover</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>

                <div class="cart__summary">
                    <div class="cart__summary-item">
                        <span>Subtotal:</span>
                        <span><%= String.format("%.2f", subtotal) %>€</span>
                    </div>
                    <div class="cart__summary-item">
                        <span>Entrega:</span>
                        <span>0.00€</span>
                    </div>
                    <div class="cart__summary-item">
                        <span>IVA (20%):</span>
                        <span><%= String.format("%.2f", iva) %>€</span>
                    </div>
                    <div class="cart__summary-total">
                        <span>Total:</span>
                        <span><%= String.format("%.2f", total) %>€</span>
                    </div>
                </div>

                <div class="cart__options">
                    <div class="cart__shipping">
                        <h2>Envio</h2>
                        <label>
                            <input type="radio" name="shipping" value="domicilio">
                            Entrega ao domicílio
                        </label>
                        <label>
                            <input type="radio" name="shipping" value="loja">
                            Levantamento em loja
                        </label>
                    </div>

                    <div class="cart__payment">
                        <h2>Forma de Pagamento</h2>
                        <label>
                            <input type="radio" name="payment" value="mbway">
                            MB WAY
                        </label>
                        <label>
                            <input type="radio" name="payment" value="multibanco">
                            Multibanco
                        </label>
                        <label>
                            <input type="radio" name="payment" value="cartao">
                            Cartão de Crédito
                        </label>
                    </div>
                </div>

                <div class="cart__actions">
                    <button class="cart__comment">
                        <a href="comentar.jsp" style="text-decoration: none; color: black;">Comentar</a>
                    </button>
                    <button class="cart__confirm">Confirmar Compra</button>
                </div>
            <% } %>
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