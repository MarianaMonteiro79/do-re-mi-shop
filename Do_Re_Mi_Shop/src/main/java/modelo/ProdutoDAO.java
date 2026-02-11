package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProdutoDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/Do_Re_Mi_Shop?useSSL=false"; 
    private String jdbcUsername = "root";
    private String jdbcPassword = "M15C16_mr";

    // Lista estática de IDs de produtos em promoção (exemplo: IDs 5 e 8)
    private static final List<Integer> PROMOCOES_IDS = new ArrayList<>(List.of(1, 4));

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Carrega o driver explicitamente
            Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
            System.out.println("Conexão com o banco de dados estabelecida com sucesso.");
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("Driver JDBC não encontrado: " + e.getMessage());
            throw new SQLException("Driver JDBC não encontrado", e);
        } catch (SQLException e) {
            System.err.println("Erro ao conectar ao banco de dados: " + e.getMessage());
            throw e;
        }
    }

    public List<Produto> listarProdutos() {
        List<Produto> produtos = new ArrayList<>();
        String sql = "SELECT * FROM Produto";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Produto p = new Produto();
                p.setId(rs.getInt("ID"));
                p.setNome(rs.getString("Nome"));
                p.setCategoria(rs.getString("Categoria"));
                p.setPreco(rs.getDouble("Preco"));
                p.setStock(rs.getInt("Stock"));
                p.setImagem(rs.getString("Imagem"));
                produtos.add(p);

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return produtos;
    }

    public void adicionarProduto(Produto produto) {
        String sql = "INSERT INTO Produto (Nome, Categoria, Preco, Stock, Imagem) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, produto.getNome());
            stmt.setString(2, produto.getCategoria());
            stmt.setDouble(3, produto.getPreco());
            stmt.setInt(4, produto.getStock());
            stmt.setString(5, produto.getImagem());
            stmt.executeUpdate();
            
            System.out.println("Produto inserido com sucesso na base de dados.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void removerProduto(int id) {
        String sql = "DELETE FROM Produto WHERE ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Produto removido com sucesso. Linhas afetadas: " + rowsAffected);
            if (rowsAffected == 0) {
                System.out.println("Nenhum produto encontrado com ID: " + id);
            }
        } catch (SQLException e) {
            System.err.println("Erro ao remover produto: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Erro ao remover produto", e); 
        }
    }
    
    public void atualizarProduto(Produto produto) {
        String sql = "UPDATE Produto SET Nome = ?, Categoria = ?, Preco = ?, Stock = ?, Imagem = ? WHERE ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, produto.getNome());
            stmt.setString(2, produto.getCategoria());
            stmt.setDouble(3, produto.getPreco());
            stmt.setInt(4, produto.getStock());
            stmt.setString(5, produto.getImagem());
            stmt.setInt(6, produto.getId());
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Produto atualizado com sucesso. Linhas afetadas: " + rowsAffected);
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar produto: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    public List<Produto> buscarProdutosPorNome(String termoPesquisa) {
        List<Produto> produtos = new ArrayList<>();
        String sql = "SELECT * FROM Produto WHERE Nome LIKE ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + (termoPesquisa != null ? termoPesquisa.trim() : "") + "%"); // Busca parcial
            System.out.println("Executando busca: " + sql + " com termo: " + termoPesquisa);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Produto p = new Produto();
                    p.setId(rs.getInt("ID"));
                    p.setNome(rs.getString("Nome"));
                    p.setCategoria(rs.getString("Categoria"));
                    p.setPreco(rs.getDouble("Preco"));
                    p.setStock(rs.getInt("Stock"));
                    p.setImagem(rs.getString("Imagem"));
                    produtos.add(p);
                    System.out.println("Produto encontrado na busca: " + p.getNome());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Erro ao buscar produtos: " + e.getMessage());
        }

        System.out.println("Total de produtos encontrados: " + produtos.size());
        return produtos;
    }

    // Método para buscar novidades (os 4 produtos com maior ID)
    public List<Produto> buscarNovidades() throws SQLException {
        List<Produto> novidades = new ArrayList<>();
        String sql = "SELECT * FROM Produto ORDER BY Id DESC LIMIT 4"; // Ordena por ID decrescente

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Produto p = new Produto();
                p.setId(rs.getInt("Id"));
                p.setNome(rs.getString("Nome"));
                p.setCategoria(rs.getString("Categoria"));
                p.setPreco(rs.getDouble("Preco"));
                p.setStock(rs.getInt("Stock"));
                p.setImagem(rs.getString("Imagem"));
                novidades.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar novidades: " + e.getMessage());
            throw e;
        }

        return novidades;
    }

    // Método para buscar promoções (usa lista estática de IDs)
    public List<Produto> buscarPromocoes() throws SQLException {
        List<Produto> promocoes = new ArrayList<>();
        List<Integer> promocoesIds = PROMOCOES_IDS;

        if (promocoesIds.isEmpty()) {
            return promocoes; // Retorna lista vazia se não houver promoções
        }

        // Monta a query para buscar produtos com os IDs da lista
        String sql = "SELECT * FROM Produto WHERE Id IN (";
        for (int i = 0; i < promocoesIds.size(); i++) {
            sql += "?";
            if (i < promocoesIds.size() - 1) {
                sql += ",";
            }
        }
        sql += ") LIMIT 2"; // Limite de 2 produtos em promoção

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Preenche os parâmetros da query com os IDs
            for (int i = 0; i < promocoesIds.size(); i++) {
                stmt.setInt(i + 1, promocoesIds.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Produto p = new Produto();
                    p.setId(rs.getInt("Id"));
                    p.setNome(rs.getString("Nome"));
                    p.setCategoria(rs.getString("Categoria"));
                    p.setPreco(rs.getDouble("Preco"));
                    p.setStock(rs.getInt("Stock"));
                    p.setImagem(rs.getString("Imagem"));
                    p.setDesconto(20.0); // Desconto fixo de 20%
                    promocoes.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar promoções: " + e.getMessage());
            throw e;
        }

        return promocoes;
    }
    
    public Produto buscarPorId(int id) {
        Produto produto = null;
        String sql = "SELECT * FROM Produto WHERE Id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    produto = new Produto();
                    produto.setId(rs.getInt("Id"));
                    produto.setNome(rs.getString("Nome"));
                    produto.setCategoria(rs.getString("Categoria"));
                    produto.setPreco(rs.getDouble("Preco"));
                    produto.setStock(rs.getInt("Stock"));
                    produto.setImagem(rs.getString("Imagem"));
                    produto.setDesconto(rs.getDouble("Desconto")); // Se a coluna Desconto existir no banco
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return produto;
    }
}