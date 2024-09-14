-- Criação do banco de dados
CREATE DATABASE db_treinamento;
USE db_treinamento;

--  -------------------------TABELAS-----------------------------------

-- Tabela de Clientes
CREATE TABLE Cliente (
    Id_Cliente INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Cidade VARCHAR(255) NOT NULL,
    Telefone VARCHAR(20) NOT NULL
);
-- Tabela de Produtos
CREATE TABLE Produtos (
    Id_Produto INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Categoria VARCHAR(100) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL,
    Fornecedor VARCHAR(100) NOT NULL
);
-- Tabela de Pedidos
CREATE TABLE Pedidos (
  Id_Pedido INT PRIMARY KEY AUTO_INCREMENT,
  Data DATE NOY NULL,
  Regiao VARCHAR(100) NOT NULL,	
  Valor DECIMAL(10,2) NOT NULL
  Id_Cliente INT,
  FOREIGN KEY(Id_Cliente) REFERENCES Clientes(Id_Cliente)
);
-- Tabela de Funcionarios
CREATE TABLE Funcionarios (
 Id_Funcionario INT PRIMARY KEY AUTO_INCREMENT,	
 Nome VARCHAR(100) NOT NULL,
 Salario DECIMAL(10,2) NOT NULL,
 Departamento VARCHAR(100) NOT NULL
);
-- Tabela de Pagamentos
CREATE TABLE Pagamentos (
    Id_Pagamento INT PRIMARY KEY AUTO_INCREMENT,
    Id_Pedido INT,
    Data_Pagamento DATE NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    FOREIGN KEY(Id_Pedido) REFERENCES Pedidos(Id_Pedido)
);
-- Tabela de Despesas
CREATE TABLE Despesas (
    Id_Despesa INT PRIMARY KEY AUTO_INCREMENT,
    Categoria VARCHAR(100) NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    Data DATE NOT NULL
);

--  -------------------------TABELAS-----------------------------------


--  --------------------- Group By e Count ----------------------------

-- 1 Agrupe os clientes por cidade e conte quantos clientes há em cada cidade.

SELECT Cidade, COUNT (*) AS Clientes_Por_Cidade
FROM Clientes 
GROUP BY Cidade;

-- 2 Agrupe os produtos por categoria e conte quantos produtos pertencem a cada categoria.
SELECT Categoria, COUNT(Id_Produto) AS Produtos_Por_Categoria
FROM Produtos
GROUP BY Categoria
ORDER BY COUNT Produtos_Por_Categoria DESC;

-- 3 Agrupe os pedidos por ano e conte quantos pedidos foram feitos em cada ano.
SELECT YEAR(Data) AS Ano, COUNT (*) AS Pedidos_Por_Ano
FROM Pedidos
GROUP BY YEAR(Data)
ORDER BY Pedidos_Por_Ano DESC;

-- 4 Agrupe as vendas por região e conte quantas vendas foram feitas em cada região.
SELECT Regiao, COUNT(Id_Pedido) AS Vendas_Por_Regiao
FROM Pedidos
GROUP BY Regiao
ORDER BY Vendas_Por_Regiao DESC;


-- 5 Agrupe os funcionários por departamento e conte quantos funcionários há em cada departamento.

SELECT Departamento, COUNT(Id_Funcionario) AS Funcionario_Por_Departamento
FROM Funcionarios
GROUP BY Departamento
ORDER BY Funcionario_Por_Departamento DESC;


--  --------------------- Group By e Count ----------------------------


--  ---------------------------- SUM ----------------------------------

-- 6 Agrupe os pedidos por cliente e calcule o valor total de pedidos para cada cliente.

SELECT Id_Cliente, SUM(Valor) AS Total_Valor_Cliente
FROM Pedidos
GROUP BY Id_Cliente
ORDER BY Total_Valor_Cliente DESC;


-- 7 Agrupe as vendas por mês e calcule o total vendido em cada mês.

SELECT YEAR(Data) AS Ano, MONTH(DATA) AS Mes, SUM(Valor) AS Vendas_Total_Mes
From Pedidos
GROUP BY YEAR(Data), MONTH(Data)
ORDER BY Ano DESC, Mes DESC;


-- 8 Agrupe os produtos por fornecedor e calcule o valor total de produtos fornecidos por cada fornecedor.

SELECT Fornecedor, SUM(Valor) AS Total_Por_Fornecedor
FROM Produtos
GROUP BY Fornecedor
ORDER BY Total_Por_Fornecedor;

-- 9 Agrupe os pagamentos por ano e calcule o total de pagamentos recebidos em cada ano.

SELECT YEAR(Data_Pagamento) AS Ano, SUM(Valor) AS Total_Pagamentos
FROM  Pagamentos
GROUP BY YEAR(Data_Pagamento)
ORDER BY  Ano;

-- 10 Agrupe as despesas por categoria e calcule o total gasto em cada categoria.

SELECT Categoria, SUM(Valor) AS Total_Gasto
FROM Despesas
GROUP BY Categoria
ORDER BY Total_Gasto DESC;

--  ---------------------------- SUM ----------------------------------

--  ---------------------------- Subquery -----------------------------

-- 11 Exiba os produtos cujo preço é superior à média dos preços de todos os produtos.

SELECT  * 
FROM Produtos 
WHERE Preco > (SELECT AVG (Preco) FROM Produtos);

-- 12 Liste os funcionários que ganham acima da média salarial do departamento ao qual pertencem.

SELECT * 
FROM Funcionarios 
WHERE Salario > (SELECT AVG (SALARIO) FROM Departamento);

-- 13 Retorne os clientes que realizaram mais de 5 pedidos.

SELECT Id_Cliente, COUNT(Id_Pedido) AS Total_Pedidos
FROM Pedidos
GROUP BY Id_Cliente
HAVING COUNT(Id_Pedido) > 5;

-- 14 Exiba as vendas cujo valor total seja maior que a média das vendas realizadas no mês anterior.

SELECT Id_Pedido, Valor
FROM Pedidos
WHERE Valor > (
    SELECT AVG(Valor)
    FROM Pedidos
    WHERE MONTH(Data) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
    AND YEAR(Data) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
);

-- 15 Liste os produtos que pertencem à mesma categoria do produto mais caro.

WITH ProdutoMaisCaro AS (
    SELECT Categoria
    FROM Produtos
    WHERE Preco = (SELECT MAX(Preco) FROM Produtos)
)
SELECT Id_Produto, Nome, Categoria, Preco
FROM Produtos
WHERE Categoria = (SELECT Categoria FROM ProdutoMaisCaro);
