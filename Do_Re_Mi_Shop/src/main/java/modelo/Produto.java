package modelo;

public class Produto {
    private int id;
    private String nome;
    private double preco;
    private int stock;
    private String categoria;
    private String imagem;
    private double desconto; // opcional, valor padrão 0.0

    // Construtor padrão (necessário para usar setters depois de new Produto())
    public Produto() {
        this.desconto = 0.0; // valor padrão para desconto
    }

    // Construtor completo com desconto
    public Produto(int id, String nome, double preco, int stock, String categoria, String imagem, double desconto) {
        this.id = id;
        this.nome = nome;
        this.preco = preco;
        this.stock = stock;
        this.categoria = categoria;
        this.imagem = imagem;
        this.desconto = desconto;
    }

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public double getPreco() { return preco; }
    public void setPreco(double preco) { this.preco = preco; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    public String getImagem() { return imagem; }
    public void setImagem(String imagem) { this.imagem = imagem; }

    public double getDesconto() { return desconto; }
    public void setDesconto(double desconto) { this.desconto = desconto; }
    
    public double getPrecoComDesconto() {
        return preco - (preco * (desconto / 100.0));
    }

}
