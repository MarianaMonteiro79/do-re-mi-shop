<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String atual = request.getRequestURI();
    session.setAttribute("ultimaPagina", atual);
%>

<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <title>Inventário</title>
    <link rel="stylesheet" href="tabelas.css">
    <style>
        .modal {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            display: flex; align-items: center; justify-content: center;
        }
        .modal-content {
            background: white; padding: 20px; border-radius: 8px; width: 500px;
        }
        .close-btn {
            float: right; cursor: pointer; font-size: 20px;
        }
    </style>
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
    <h1 class="reservas__title">Inventário</h1>
    <table class="reservas__table">
        <thead>
            <tr>
                <th>Data</th>
                <th>Produto</th>
                <th>Quantidade Vendida</th>
                <th>Cliente</th>
                <th>Pagamento</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Do_Re_Mi_Shop", "root", "M15C16_mr");

                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM registoVendas ORDER BY data DESC");

                while (rs.next()) {
                    int id = rs.getInt("Id_vendas");
                    String dataEntrega = rs.getString("data");
                    String produto = rs.getString("nome_produto");
                    int quantidade = rs.getInt("qtd");
                    String cliente = rs.getString("nome_cliente");
                    String pagamento = rs.getString("metodoPagamento");
        %>
                <tr>
                    <td><%= dataEntrega %></td>
                    <td><%= produto %></td>
                    <td><%= quantidade %></td>
                    <td><%= cliente %></td>
                    <td><%= pagamento %></td>
                    <td>
                        <button class="detalhes-btn" data-id="<%= id %>">Ver detalhes</button>
                    </td>
                </tr>
        <%
                }

                rs.close();
                stmt.close();
                con.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='6'>Erro ao carregar dados: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>

    <div class="reservas__actions">
        <button class="reservas__button" onclick="window.history.back()">Voltar</button>
    </div>

    <!-- Modal -->
    <div id="detalhesModal" class="modal" style="display:none;">
        <div class="modal-content">
            <span class="close-btn">&times;</span>
            <h2>Detalhes da Venda</h2>
            <div id="detalhesContent">Carregando...</div>
        </div>
    </div>
</main>

<footer>
    <p>&copy; 2025 Do Re Mi Shop. Todos os direitos reservados.</p>
    <p><a href="#">Política de Privacidade</a> | <a href="#">Termos de Serviço</a></p>
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

    // Script para o modal de detalhes
    document.addEventListener("DOMContentLoaded", () => {
        document.querySelectorAll(".detalhes-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                const id = btn.getAttribute("data-id");
                fetch("vendaDetalhesAjax.jsp?id=" + id)
                    .then(res => res.text())
                    .then(html => {
                        document.getElementById("detalhesContent").innerHTML = html;
                        document.getElementById("detalhesModal").style.display = "flex";
                    });
            });
        });

        document.querySelector(".close-btn").addEventListener("click", () => {
            document.getElementById("detalhesModal").style.display = "none";
        });
    });
</script>

</body>
</html>
