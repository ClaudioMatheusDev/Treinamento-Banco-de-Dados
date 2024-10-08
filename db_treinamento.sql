-- Criação do banco de dados
CREATE DATABASE db_treinamento;
USE db_treinamento;

--  -------------------------TABELAS-----------------------------------

-- Tabela de Clientes
CREATE TABLE Cliente (
    Id_Cliente INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Cidade VARCHAR(255) NOT NULL,
    Pais VARCHAR(255) NOT NULL,
    Idade INT NOT NULL,  
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
  Data DATE NOT NULL,
  Regiao VARCHAR(100) NOT NULL,	
  Valor DECIMAL(10,2) NOT NULL,
  Status VARCHAR(100) NOT NULL,
  Quantidade INT NOT NULL,
  Id_Cliente INT NOT NULL,
  Id_Funcionario INT NOT NULL,
  FOREIGN KEY(Id_Funcionario) REFERENCES Funcionarios(Id_Funcionario),
  FOREIGN KEY(Id_Cliente) REFERENCES Clientes(Id_Cliente)
);
-- Tabela de Funcionarios
CREATE TABLE Funcionarios (
 Id_Funcionario INT PRIMARY KEY AUTO_INCREMENT,	
 Nome VARCHAR(100) NOT NULL,
 Idade INT NOT NULL,
 Salario DECIMAL(10,2) NOT NULL,
 Cargo Varchar(100) NOT NULL,
 Regiao VARCHAR(100) NOT NULL,
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
-- Tabela de Historico Salario
CREATE TABLE HistoricoSalario (
    Id_Historico INT PRIMARY KEY AUTO_INCREMENT,
    Id_Funcionario INT NOT NULL,
    Salario DECIMAL(10, 2) NOT NULL,
    DataAlteracao DATE NOT NULL,
    FOREIGN KEY (Id_Funcionario) REFERENCES Funcionarios(Id_Funcionario)
);
-- Tabela de Alunos
CREATE TABLE Alunos (
    Id_Aluno INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Data_Nascimento DATE NOT NULL
);
-- Tabela de Disciplinas
CREATE TABLE Disciplinas (
    Id_Disciplina INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Creditos INT NOT NULL
);
-- Tabela de Matriculas
CREATE TABLE Matriculas (
    Id_Matricula INT PRIMARY KEY AUTO_INCREMENT,
    Id_Aluno INT NOT NULL,
    Id_Disciplina INT NOT NULL,
    FOREIGN KEY (Id_Aluno) REFERENCES Alunos(Id_Aluno),
    FOREIGN KEY (Id_Disciplina) REFERENCES Disciplinas(Id_Disciplina)
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

--  ---------------------------- Subquery -----------------------------

--  ------------------------- Having Count -----------------------------

-- 16 Agrupe os clientes por país e exiba apenas os países que possuem mais de 100 clientes.

SELECT Pais, COUNT(*) AS NumeroClientes
FROM Cliente
GROUP BY Pais
HAVING COUNT(*) > 100;

-- 17 Agrupe os funcionários por cargo e exiba apenas os cargos que possuem mais de 5 funcionários.

SELECT Cargo, COUNT(*) AS FuncionarioPorCargo
From Funcionario
GROUP BY Cargo
HAVING COUNT(*) > 5;

--18 Agrupe os fornecedores por região e exiba apenas as regiões que possuem mais de 10 fornecedores.

SELECT Fornecedor, COUNT(*) AS TotalFornecedores
FROM Produtos
GROUP BY Fornecedor
HAVING COUNT(*) > 10;

--19 Agrupe os pedidos por status e exiba apenas os status que possuem mais de 50 pedidos.

SELECT Status, COUNT(*) AS TotalPedidos
FROM Pedidos
GROUP BY Status
HAVING COUNT(*) > 50;

--20 Agrupe os clientes por idade e exiba apenas as faixas etárias que possuem mais de 20 clientes.

SELECT Idade, COUNT(*) AS ClientesPorIdade
FROM Cliente
GROUP BY Idade
HAVING COUNT(*) > 20;

--  ------------------------- Having Count -----------------------------

--  ----------------------------- Max ----------------------------------
-- 21 Encontre o maior salário por departamento.

SELECT Departamento, MAX(Salario) AS MaiorSalario
FROM Funcionarios
GROUP BY Departamento;

-- 22 Descubra o maior valor de venda por cliente.

SELECT Id_Cliente, MAX(Valor) AS MaiorValor
FROM Pedidos
GROUP BY Id_Cliente;

-- 23 Encontre a maior quantidade de um produto vendido em uma única transação.

SELECT Id_Produto, MAX(Quantidade) AS MaisVendido
FROM Pedidos
GROUP BY Id_Produto;

-- 24 Exiba o maior preço de produto por fornecedor.

SELECT Fornecedor, MAX(Preco) AS ProdutoValor
FROM Produtos
GROUP BY Fornecedor;

-- 25 Retorne a data mais recente de pedido por cliente.

SELECT Id_Cliente, MAX(Data) AS PedidoRecente
FROM Pedidos
GROUP BY Id_Cliente;

--  ----------------------------- Max ----------------------------------

--  ----------------------------- Min ----------------------------------
-- 26 Encontre o menor salário por cargo.

SELECT Cargo, MIN(Salario) AS MenorSalario
FROM Funcionarios
GROUP BY Cargo;

-- 27 Descubra o menor valor de venda por mês.

SELECT MONTH(Data) AS Mes, MIN(Valor) AS MenorVenda
FROM Pedidos
GROUP BY MONTH(Data);

-- 28 Encontre a menor quantidade de um produto vendido em uma única transação.

SELECT Id_Produto, MIN(Quantidade) AS MenorQuantidade
FROM Pedidos
GROUP BY Id_Produto;

-- 29 Exiba o menor preço de produto por categoria.

SELECT Categoria, MIN(Preco) AS MenorPreco
FROM Produtos
GROUP BY Categoria;

-- 30 Retorne a data mais antiga de pedido por região.

SELECT Regiao, MIN(Data) AS PedidoAntigo
FROM Pedidos
GROUP BY Regiao;

--  ----------------------------- Min ----------------------------------

--  ----------------------------- Average ------------------------------
-- 31 Calcule a média salarial por cargo.

SELECT Cargo, AVG(Salario) AS MediaSalario
FROM Funcionarios
GROUP BY Cargo;

-- 32 Calcule o valor médio de vendas por cliente.

SELECT Id_Cliente, AVG(Valor) AS MediaVenda
FROM Pedidos
GROUP BY Id_Cliente;

-- 33 Calcule a quantidade média de produtos vendidos por pedido.

SELECT Id_Produto, AVG(Quantidade) AS MediaProduto
FROM Pedidos
GROUP BY Id_Produto;

-- 34 Calcule o preço médio de produtos por fornecedor.

SELECT Fornecedor, AVG(Preco) AS MediaPreco
FROM Produtos
GROUP BY Fornecedor;

-- 35 Calcule a média de idade dos funcionários por departamento.

SELECT Departamento, AVG(Idade) AS MediaIdade
FROM Funcionarios
GROUP BY Departamento;

--  ----------------------------- Average ------------------------------

--  ------------------------------ Top ---------------------------------
-- 36 Exiba os 5 produtos mais caros.

SELECT TOP 5 Id_Produto, Preco
FROM Produtos
ORDER BY Preco DESC;

-- 37 Liste os 3 clientes que mais compraram.

SELECT TOP 3 Id_Cliente, COUNT(Id_Pedido) AS TotalCompras
FROM Pedidos
GROUP BY Id_Cliente
ORDER BY TotalCompras DESC;

-- 38 Exiba os 10 maiores pedidos em termos de valor total.

SELECT TOP 10 Id_Pedido, Valor AS TotalValor
FROM Pedidos
ORDER BY Valor DESC;

-- 39 Liste os 5 fornecedores com maior quantidade de produtos fornecidos.

SELECT TOP 5 Fornecedor, SUM(Quantidade) AS TotalFornecido
FROM Produtos
GROUP BY Fornecedor
ORDER BY TotalFornecido DESC;

-- 40 Exiba os 3 funcionários com maior número de vendas.

SELECT TOP 3 Id_Funcionario, COUNT(Id_Pedido) AS MaiorNumeroDeVendas
FROM Pedidos
GROUP BY Id_Funcionario
ORDER BY MaiorNumeroDeVendas DESC;

--  ------------------------------ Top ---------------------------------

--  ----------------------- Stored Procedure ---------------------------

-- 41 Crie uma stored procedure que receba o ID de um cliente e retorne todas as vendas realizadas para esse cliente.

GO
CREATE PROCEDURE TodasVendas
    @Id_Cliente INT
AS
BEGIN
    SELECT *
    FROM Pedidos
    WHERE Id_Cliente = @Id_Cliente;
END;
GO

EXEC TodasVendas @Id_Cliente = 1;

-- 42 Crie uma stored procedure que receba o ID de um produto e retorne todas as informações desse produto.

GO
CREATE PROCEDURE InformaProduto
    @Id_Produto INT
AS
BEGIN
    SELECT *
    FROM Produtos
    WHERE Id_Produto = @Id_Produto;
END;
GO

EXEC InformaProduto @Id_Produto = 1;
    
-- 43 Crie uma stored procedure que receba uma data e retorne todos os pedidos realizados naquela data.

GO
CREATE PROCEDURE PedidoPorData
    @Data Date
AS
BEGIN
    SELECT *
    FROM Pedidos
    WHERE Data = @Data;
End;
GO

EXEC PedidoPorData @Data = '2024-09-18';

-- 44 Crie uma stored procedure que receba o ID de um funcionário e retorne o histórico salarial desse funcionário.

GO
CREATE PROCEDURE SalarioFuncionario
   @Id_Funcionario INT
AS
BEGIN
    SELECT Salario, DataAlteracao
    FROM HistoricoSalario
    WHERE Id_Funcionario = @Id_Funcionario;
    ORDER BY DataAlteracao DESC;
END;
GO

EXEC SalarioFuncionario @Id_Funcionario = 1;

-- 45 Crie uma stored procedure que receba o ID de um pedido e retorne todos os produtos associados a esse pedido.

GO
CREATE PROCEDURE ItensPedidos
    @Id_Pedido
AS
BEGIN
    SELECT Id_Produto, Nome
    FROM Pedidos
    WHERE Id_Pedido = Id_Pedido;
END;
GO

EXEC ItensPedidos @Id_Pedido = 1;

--  ----------------------- Stored Procedure ---------------------------

--  ---------------------------- Inner Join ----------------------------
-- 1 Liste todos os clientes e os pedidos realizados por eles, utilizando um inner join.

SELECT Cliente.Nome, Pedidos.Id_Pedido
FROM Cliente
INNER JOIN Pedidos
ON Cliente.Id_Cliente = Pedidos.Id_Cliente;

-- 2 Exiba todos os produtos e seus respectivos fornecedores, utilizando um inner join.

SELECT Produtos.Nome, Produtos.Fornecedor
FROM Produtos
INNER JOIN Fornecedores
ON Produtos.Fornecedor = Fornecedores.Nome;

-- 3 Liste todos os funcionários e seus departamentos, utilizando um inner join.

SELECT Funcionarios.Nome AS FuncionarioNome, Departamentos.Nome AS DepartamentoNome
FROM Funcionarios
INNER JOIN Departamentos
ON Funcionarios.Departamento = Departamentos.Id_Departamento;

-- 4  Liste todos os pedidos e os produtos associados a esses pedidos utilizando um inner join.

SELECT Pedidos.Id_Pedido, Produtos.Nome AS ProdutoNome
FROM Pedidos
INNER JOIN Itens_Pedido ON Pedidos.Id_Pedido = Itens_Pedido.Id_Pedido
INNER JOIN Produtos ON Itens_Pedido.Id_Produto = Produtos.Id_Produto;

-- 5 Exiba todos os funcionários e os departamentos aos quais estão alocados utilizando um inner join.

SELECT Funcionarios.Nome AS FuncionarioNome, Departamentos.Nome AS DepartamentoNome
FROM Funcionarios
INNER JOIN Departamentos ON Funcionarios.Id_Departamento = Departamentos.Id_Departamento;

-- 6 Liste todos os clientes e os pedidos realizados por eles utilizando um inner join.

SELECT Cliente.Nome AS ClienteNome, Pedidos.Id_Pedido
FROM Cliente
INNER JOIN Pedidos ON Cliente.Id_Cliente = Pedidos.Id_Cliente;

-- 7 Liste todos os alunos e as disciplinas em que estão matriculados utilizando um inner join.

SELECT Alunos.Nome AS AlunoNome, Disciplinas.Nome AS DisciplinaNome
FROM Alunos
INNER JOIN Matriculas ON Alunos.Id_Aluno = Matriculas.Id_Aluno
INNER JOIN Disciplinas ON Matriculas.Id_Disciplina = Disciplinas.Id_Disciplina;

--  ---------------------------- Inner Join ----------------------------

--  ---------------------------- Left Join -----------------------------

-- 1 Liste todos os clientes e, se houver, os pedidos realizados por eles, utilizando um left join.

SELECT Cliente.Nome AS ClienteNome, Pedidos.Id_Pedido
FROM Cliente
LEFT JOIN Pedidos ON Cliente.Id_Cliente = Pedidos.Id_Cliente;


-- 2 Exiba todos os produtos e, se houver, os pedidos em que foram incluídos, utilizando um left join.

SELECT Produtos.Nome AS ProdutoNome, Pedidos.Id_Pedido
FROM Produtos
LEFT JOIN Itens_Pedido ON Produtos.Id_Produto = Itens_Pedido.Id_Produto
LEFT JOIN Pedidos ON Itens_Pedido.Id_Pedido = Pedidos.Id_Pedido;

-- 3 Liste todos os funcionários e, se houver, os projetos em que estão trabalhando utilizando um left join.

SELECT Funcionarios.Nome AS FuncionarioNome, Projetos.Nome AS ProjetoNome
FROM Funcionarios
LEFT JOIN Projetos ON Funcionarios.Id_Funcionario = Projetos.Id_Funcionario;


-- 4 Exiba todos os fornecedores e, se houver, os produtos fornecidos por eles utilizando um left join.

SELECT Fornecedores.Nome AS FornecedorNome, Produtos.Nome AS ProdutoNome
FROM Fornecedores
LEFT JOIN Produtos ON Fornecedores.Nome = Produtos.Fornecedor; 

-- 5 Liste todos os cursos e, se houver, os alunos matriculados neles utilizando um left join.

SELECT Cursos.Nome AS CursoNome, Alunos.Nome AS AlunoNome
FROM Cursos
LEFT JOIN Matriculas ON Cursos.Id_Curso = Matriculas.Id_Curso
LEFT JOIN Alunos ON Matriculas.Id_Aluno = Alunos.Id_Aluno;


--  ---------------------------- Left Join -----------------------------


--  --------------------------- Right Join -----------------------------

-- 1 Exiba todos os pedidos e, se houver, os clientes que os realizaram utilizando um right join.

SELECT Pedidos.Id_Pedido, Clientes.Nome AS ClienteNome
FROM Pedidos
RIGHT JOIN Clientes ON Pedidos.Id_Cliente = Clientes.Id_Cliente;

-- 2 Liste todos os departamentos e, se houver, os funcionários alocados a eles utilizando um right join.

SELECT Departamentos.Nome AS DepartamentoNome, Funcionarios.Nome AS FuncionarioNome
FROM Departamentos
RIGHT JOIN Funcionarios ON Departamentos.Id_Departamento = Funcionarios.Id_Departamento;

-- 3 Exiba todas as vendas e, se houver, os produtos vendidos utilizando um right join.

SELECT Vendas.Id_Venda, Produtos.Nome AS ProdutoNome
FROM Vendas
RIGHT JOIN Produtos ON Vendas.Id_Produto = Produtos.Id_Produto;

-- 4 Liste todos os professores e, se houver, as disciplinas que eles lecionam utilizando um right join.

SELECT Professores.Nome AS ProfessorNome, Disciplinas.Nome AS DisciplinaNome
FROM Professores
RIGHT JOIN Disciplinas ON Professores.Id_Professor = Disciplinas.Id_Professor;

-- 5 Exiba todos os contratos e, se houver, as empresas contratadas utilizandoum right join.

SELECT Contratos.Id_Contrato, Empresas.Nome AS EmpresaNome
FROM Contratos
RIGHT JOIN Empresas ON Contratos.Id_Empresa = Empresas.Id_Empresa;

--  --------------------------- Right Join -----------------------------

--  ----------------------- Full Outer Join ----------------------------

-- 1 Liste todos os funcionários e todos os projetos, mesmo que não estejam associados, utilizando um full outer join.
-- 2 Exiba todos os clientes e todos os pedidos, mesmo que não estejam relacionados, utilizando um full outer join.
-- 3 Liste todos os produtos e todos os fornecedores, mesmo que não haja associação entre eles, utilizando um full outer join.
-- 4 Exiba todas as turmas e todos os alunos, mesmo que não estejam associados, utilizando um full outer join.
-- 5 Liste todos os vendedores e todas as vendas, mesmo que não estejam conectados, utilizando um full outer join.

--  ----------------------- Full Outer Join ----------------------------


