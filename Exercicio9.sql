CREATE DATABASE exercicio09
GO 
USE exercicio09

CREATE TABLE editora (
codigo INT NOT NULL,
nome VARCHAR(50) NOT NULL,
sites VARCHAR (100) NULL,
PRIMARY KEY (codigo)
)

INSERT INTO editora VALUES
(1,	'Pearson',	'www.pearson.com.br'),
(2,	'Civilização Brasileira', NULL),	
(3,	'Makron Books',	'www.mbooks.com.br'),
(4,	'LTC',	'www.ltceditora.com.br'),
(5,	'Atual',	'www.atualeditora.com.br'),
(6,	'Moderna',	'www.moderna.com.br')

CREATE TABLE autor (
codigo INT NOT NULL,
nome VARCHAR(100) NOT NULL,
breve_biografia VARCHAR(100) NOT NULL,
PRIMARY KEY (codigo)
)

INSERT INTO editora VALUES
(1,	'Pearson',	'www.pearson.com.br'),
(2,	'Civilização Brasileira', NULL),	
(3,	'Makron Books',	'www.mbooks.com.br'),
(4,	'LTC',	'www.ltceditora.com.br'),
(5,	'Atual',	'www.atualeditora.com.br'),
(6,	'Moderna',	'www.moderna.com.br')



CREATE TABLE autor (
codigo INT NOT NULL,
nome VARCHAR(100) NOT NULL,
breve_biografia VARCHAR(100) NOT NULL,
PRIMARY KEY (codigo)
)

INSERT INTO autor VALUES 
(101,	'Andrew Tannenbaun',	'Desenvolvedor do Minix'),
(102,	'Fernando Henrique Cardoso',	'Ex-Presidente do Brasil'),
(103,	'Diva Marília Flemming',	'Professora adjunta da UFSC'),
(104,	'David Halliday',	'Ph.D. da University of Pittsburgh'),
(105,	'Alfredo Steinbruch',	'Professor de Matemática da UFRS e da PUCRS'),
(106,	'Willian Roberto Cereja',	'Doutorado em Lingüística Aplicada e Estudos da Linguagem'),
(107,	'William Stallings',	'Doutorado em Ciências da Computacão pelo MIT'),
(108,	'Carlos Morimoto',	'Criador do Kurumin Linux')


CREATE TABLE estoque (
codigo INT NOT NULL,
nome VARCHAR(100) NOT NULL UNIQUE,
quantidade INT NOT NULL,
valor DECIMAL(7,2) NOT NULL CHECK( valor > 0 ),
cod_editora INT NOT NULL,
cod_autor INT NOT NULL,
PRIMARY KEY (codigo),
FOREIGN KEY (cod_editora) REFERENCES editora (codigo),
FOREIGN KEY (cod_autor) REFERENCES autor (codigo)
)

INSERT INTO estoque VALUES 
(10001,	'Sistemas Operacionais Modernos', 	4,	108.00,	1,	101),
(10002,	'A Arte da Política',	2,	55.00,	2,	102),
(10003,	'Calculo A',	12,	79.00,	3,	103),
(10004,	'Fundamentos de Física I',	26,	68.00,	4,	104),
(10005,	'Geometria Analítica',	1,	95.00,	3,	105),
(10006,	'Gramática Reflexiva',	10,	49.00,	5,	106),
(10007,	'Fundamentos de Física III',	1,	78.00,	4,	104),
(10008,	'Calculo B',	3,	95.00,	3,	103)


CREATE TABLE compras (
codigo INT NOT NULL,
cod_livro INT NOT NULL,
qtd_comprada INT NOT NULL CHECK ( qtd_comprada > 0 ),
valor DECIMAL(7,2) NOT NULL, CHECK ( valor > 0 ), 
data_compra DATE NOT NULL,
PRIMARY KEY (codigo, cod_livro),
FOREIGN KEY (cod_livro) REFERENCES estoque (codigo)
)

INSERT INTO compras VALUES
(15051,	10003,	2,	158.00,	'04/07/2020'),
(15051,	10008,	1,	95.00,	'04/07/2020'),
(15051,	10004,	1,	68.00,	'04/07/2020'),
(15051,	10007,	1,	78.00,	'04/07/2020'),
(15052,	10006,	1,	49.00,	'05/07/2020'),
(15052,	10002,	3,	165.00,	'05/07/2020'),
(15053,	10001,	1,	108.00,	'05/07/2020'),
(15054,	10003,	1,	79.00,	'06/08/2020'),
(15054,	10008,	1,	95.00,	'06/08/2020')

select distinct e.nome,e.valor,ed.nome,au.nome from compras a, estoque e,editora ed,autor au
where e.codigo = a.cod_livro and e.cod_editora = ed.codigo and e.cod_autor = au.codigo



select distinct e.nome,c.qtd_comprada,c.valor, from compras c, estoque e
where c.codigo = 15051

SELECT e.nome AS LIVRO, 
	CASE WHEN (LEN(ed.sites) > 10)
			THEN
			SUBSTRING(ed.sites,5 ,13)
			ELSE 
			ed.sites 
			END AS SITE_EDITORA
FROM estoque e, editora ed
where e.cod_editora = ed.codigo and ed.nome = 'Makron books'

SELECT e.nome AS LIVRO, a.breve_biografia AS BREVE_BIOGRAFIA
FROM estoque e, autor a WHERE e.cod_autor = a.codigo and a.nome = 'David Halliday'	


SELECT c.codigo AS CODIGO, c.qtd_comprada AS QUANTIDADE
FROM compras c, estoque e where e.codigo = c.cod_livro and e.nome = 'Sistemas Operacionais Modernos'

SELECT e.nome AS Não_foi_vendido
FROM estoque e LEFT OUTER JOIN compras c
ON 	e.codigo = c.cod_livro
WHERE c.cod_livro IS NULL

SELECT  e.nome AS LIVRO_VENDIDO_NÃO_CADASTRADO
FROM estoque e INNER JOIN compras c
ON e.codigo = c.cod_livro
WHERE e.quantidade - c.qtd_comprada < 0


SELECT ed.nome AS EDITORA,
	CASE WHEN (LEN(ed.sites) > 10)
		THEN
		RTRIM(SUBSTRING(ed.sites,5 ,14))
		END AS SITE_EDITORA
FROM estoque e RIGHT OUTER JOIN editora ed
ON e.cod_editora = ed.codigo
WHERE e.cod_editora IS null


SELECT a.nome AS AUTOR, 
	CASE WHEN (a.breve_biografia LIKE 'doutorado%')
		THEN 'Ph.D.'+ SUBSTRING(a.breve_biografia, 10, 50)
		ELSE a.breve_biografia
		END AS BIOGRAFIA
FROM autor a LEFT OUTER JOIN estoque e
ON a.codigo = e.cod_autor	
WHERE e.cod_autor IS NULL


SELECT a.nome AS AUTOR, MAX(e.valor) AS VALOR_LIVROS  
FROM autor a, estoque e where e.cod_autor = a.codigo
GROUP BY a.nome, e.valor
ORDER BY e.valor DESC


SELECT codigo AS CODIGO, SUM (qtd_comprada) AS TOTAL_LIVROS, SUM (valor) AS SOMA_VALORES FROM compras 		
GROUP BY codigo		
ORDER BY codigo ASC

SELECT ed.nome AS EDITORA, CAST(AVG (e.valor) AS DECIMAL(7,2)) AS MEDIA
FROM editora ed, estoque e where e.cod_editora = ed.codigo
GROUP BY ed.nome
ORDER BY MEDIA ASC

SELECT e.nome AS LIVRO, e.quantidade AS ESTOQUE, ed.nome AS EDITORA, 
		CASE WHEN (LEN(ed.sites) > 10)
			THEN
			SUBSTRING(ed.sites,5 ,50)
			ELSE 
			ed.sites 
			END AS SITES,
		CASE WHEN (e.quantidade < 5)
			THEN
			'Produto em Ponto de Pedido'
			WHEN (e.quantidade >= 5 AND e.quantidade <= 10 )
			THEN
			'Produto Acabando'
			WHEN (e.quantidade > 10)
			THEN
			'Estoque Suficiente'
			END AS SITUAÇÃO
FROM estoque e, editora ed where e.cod_editora = ed.codigo
ORDER BY e.quantidade ASC


SELECT e.codigo AS CODIGO, e.nome AS LIVRO, a.nome AS AUTOR, 
		CASE WHEN (ed.sites IS NOT NULL)
		THEN 
		(ed.nome + ' ( ' + ed.sites + ' )') 
		ELSE
		(ed.nome + ' ( ------ )')
		END AS INFO_EDITORA
FROM estoque e, autor a,editora ed
where e.cod_autor = a.codigo and e.cod_editora = ed.codigo	

SELECT codigo AS CODIGO, DATEDIFF (DAY, data_compra, GETDATE()) AS DIAS, DATEDIFF (MONTH, data_compra, GETDATE()) AS MESES
FROM compras


SELECT codigo AS CODIGO, SUM (valor) AS SOMA
FROM compras
GROUP BY codigo
HAVING SUM (valor) > 200 





