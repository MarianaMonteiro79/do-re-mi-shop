<%@ page import="java.util.*, modelo.ProdutoDAO, modelo.Produto" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String atual = request.getRequestURI();
    session.setAttribute("ultimaPagina", atual);

    List<Produto> produtos = new ProdutoDAO().listarProdutos();
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Gestão de Produtos</title>
    <link rel="stylesheet" href="produtos.css">
</head>
<body>
    <header class="header">
        <div class="logo">
            <a style="text-decoration: none; color: white" href="index.jsp">Do Re Mi Shop</a>
        </div>
        
        <nav class="menu">
            <a href="Cria_admin.jsp">Contas</a>
            <a href="registoVendas.jsp" class="role-btn admin">Vendas</a>
            <a href="sistemaReserva.jsp" class="role-btn funcionario">Encomendas</a>
            <a href="inventario.jsp" class="role-btn fornecedor">Inventário</a>
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

    <main class="reservas">
        <h1 class="reservas__title">Gestão de Produtos</h1>
        <% String erro = request.getParameter("erro"); %>
        <% String sucesso = request.getParameter("sucesso"); %>
        <% if (erro != null) { %>
            <p style="color: red;">Erro: <%= erro %></p>
        <% } %>
        <% if (sucesso != null) { %>
            <p id="successMessage" style="color: green;">Sucesso: <%= sucesso %></p>
        <% } %>
        <table class="reservas__table">
            <thead>
                <tr>
                    <th>Imagem</th>
                    <th>Nome</th>
                    <th>Categoria</th>
                    <th>Preço (€)</th>
                    <th>Stock</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <% for (Produto p : produtos) { %>
                    <tr>
                        <td><img src="<%= p.getImagem() %>" width="50" height="50"/></td>
                        <td><%= p.getNome() %></td>
                        <td><%= p.getCategoria() %></td>
                        <td><%= p.getPreco() %>€</td>
                        <td><%= p.getStock() %></td>
                        <td>
                            <span class="action-icon edit-icon" onclick="mostrarFormularioEditar(<%= p.getId() %>, '<%= p.getNome() %>', '<%= p.getCategoria() %>', <%= p.getPreco() %>, <%= p.getStock() %>, '<%= p.getImagem() %>')" title="Editar">✎</span>
                            <span class="action-icon remove-icon" onclick="removerProduto(<%= p.getId() %>)" title="Remover">✖</span>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    
        <div class="cart__actions">
            <button onclick="mostrarFormularioAdicionar()">Adicionar produto</button>
        </div>
    
        <div id="modalAdicionar" class="modal" style="display:none;">
            <div class="modal-content">
                <h2>Adicionar Produto</h2>
                <form action="adicionarProduto" method="post" class="add-product-form" accept-charset="UTF-8">
                    <div class="form-group">
                        <label for="addNome">Nome:</label>
                        <input type="text" id="addNome" name="Nome" placeholder="Nome" required>
                    </div>
                    <div class="form-group">
                        <label for="addCategoria">Categoria:</label>
                        <input type="text" id="addCategoria" name="Categoria" placeholder="Categoria" required>
                    </div>
                    <div class="form-group">
                        <label for="addPreco">Preço:</label>
                        <input type="number" step="0.01" id="addPreco" name="Preco" placeholder="Preço" required>
                    </div>
                    <div class="form-group">
                        <label for="addStock">Stock:</label>
                        <input type="number" id="addStock" name="Stock" placeholder="Stock" required>
                    </div>
                    <div class="form-group">
                        <label for="addImagem">URL da imagem:</label>
                        <input type="text" id="addImagem" name="Imagem" placeholder="URL da imagem">
                    </div>
                    <div class="form-buttons">
                        <button type="submit" class="save-button">Guardar</button>
                        <button type="button" class="close-button" onclick="fecharModal('modalAdicionar')">Fechar</button>
                    </div>
                </form>
            </div>
        </div>
    
        <div id="formRemover" style="display:none; margin-top: 20px;">
            <form action="removerProduto" method="post">
                <select name="produtoId">
                    <% for (Produto p : produtos) { %>
                        <option value="<%= p.getId() %>"><%= p.getNome() %></option>
                    <% } %>
                </select>
                <button type="submit">Remover produto</button>
            </form>
        </div>
        <div id="modalEditar" class="modal" style="display:none;">
            <div class="modal-content">
                <h2>Editar Produto</h2>
                <form action="editarProduto" method="post" class="add-product-form" accept-charset="UTF-8">
                    <input type="hidden" name="id" id="editId">
                    <div class="form-group">
                        <label for="editNome">Nome:</label>
                        <input type="text" id="editNome" name="Nome" placeholder="Nome" required>
                    </div>
                    <div class="form-group">
                        <label for="editCategoria">Categoria:</label>
                        <input type="text" id="editCategoria" name="Categoria" placeholder="Categoria" required>
                    </div>
                    <div class="form-group">
                        <label for="editPreco">Preço:</label>
                        <input type="number" step="0.01" id="editPreco" name="Preco" placeholder="Preço" required>
                    </div>
                    <div class="form-group">
                        <label for="editStock">Stock:</label>
                        <input type="number" id="editStock" name="Stock" placeholder="Stock" required>
                    </div>
                    <div class="form-group">
                        <label for="editImagem">URL da imagem:</label>
                        <input type="text" id="editImagem" name="Imagem" placeholder="URL da imagem">
                    </div>
                    <div class="form-buttons">
                        <button type="submit" class="save-button">Guardar</button>
                        <button type="button" class="close-button" onclick="fecharModal('modalEditar')">Fechar</button>
                    </div>
                </form>
            </div>
        </div>
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
        
        function mostrarFormularioAdicionar() {
            document.getElementById("modalAdicionar").style.display = "block";
        }
        
        function mostrarFormularioEditar(id, nome, categoria, preco, stock, imagem) {
            document.getElementById("modalEditar").style.display = "block";
            document.getElementById("editId").value = id;
            document.getElementById("editNome").value = nome;
            document.getElementById("editCategoria").value = categoria;
            document.getElementById("editPreco").value = preco;
            document.getElementById("editStock").value = stock;
            document.getElementById("editImagem").value = imagem;
        }
        
        function fecharModal(modalId) {
            document.getElementById(modalId).style.display = "none";
        }

        window.onclick = function(event) {
            if (event.target.className === "modal") {
                event.target.style.display = "none";
            }
        }
        
        window.onload = function() {
            var successMessage = document.getElementById("successMessage");
            if (successMessage) {
                setTimeout(function() {
                    successMessage.style.display = "none";
                }, 3000);
            }
        };

        function removerProduto(id) {
            console.log("Tentando remover produto com ID: " + id);
            if (confirm("Tem certeza que deseja remover este produto?")) {
                var url = "<%= request.getContextPath() %>/removerProduto?id=" + id;
                console.log("URL de redirecionamento: " + url);
                window.location.href = url;
            }
        }
    </script>  
</body>    
</html>