CREATE DATABASE exercicio12
GO
USE exercicio12

CREATE TABLE planos (
cod_plano INT NOT NULL,
nome_plano VARCHAR(50) NOT NULL,
valor_plano INT NOT NULL,
PRIMARY KEY (cod_plano)
)

INSERT INTO planos VALUES
(1,	'100 Minutos',	80),
(2,	'150 Minutos',	130),
(3,	'200 Minutos',	160),
(4,	'250 Minutos',	220),
(5,	'300 Minutos',	260),
(6,	'600 Minutos',	350)

CREATE TABLE servicos (
cod_servico INT NOT NULL,
nome_servico VARCHAR(50) NOT NULL,
valor_servico INT NOT NULL,
PRIMARY KEY (cod_servico)
)

INSERT INTO servicos VALUES
(1,	'100 SMS',	10),
(2,	'SMS Ilimitado',	30),
(3,	'Internet 500 MB',	40),
(4,	'Internet 1 GB',	60),
(5,	'Internet 2 GB',	70)

CREATE TABLE cliente (
cod_cliente INT NOT NULL,
nome_cliente VARCHAR(50) NOT NULL,
data_inicio CHAR(10) NOT NULL,
PRIMARY KEY (cod_cliente)
)

INSERT INTO cliente VALUES
(1234,	'Cliente A',	'15/10/2012'),
(2468,	'Cliente B',	'20/11/2012'),
(3702,	'Cliente C',	'25/11/2012'),
(4936,	'Cliente D',	'01/12/2012'),
(6170,	'Cliente E',	'18/12/2012'),
(7404,	'Cliente F',	'20/01/2013'),
(8638,	'Cliente G',	'25/01/2013')

CREATE TABLE contratos (
cod_cliente INT NOT NULL,
cod_plano INT NOT NULL,
cod_servico INT NOT NULL,
status_contrato CHAR(1) NOT NULL,
dat date NOT NULL,
PRIMARY KEY (cod_cliente, cod_plano, cod_servico, status_contrato),
FOREIGN KEY (cod_cliente) REFERENCES cliente (cod_cliente),
FOREIGN KEY (cod_plano) REFERENCES planos (cod_plano),
FOREIGN KEY (cod_servico) REFERENCES servicos (cod_servico)
)

INSERT INTO contratos VALUES 
(1234,	3,	1,	'E',	'15/10/2012'),
(1234,	3,	3,	'E',	'15/10/2012'),
(1234,	3,	3,	'A',	'16/10/2012'),
(1234,	3,	1,	'A',	'16/10/2012'),
(2468,	4,	4,	'E',	'20/11/2012'),
(2468,	4,	4,	'A',	'21/11/2012'),
(6170,	6,	2,	'E',	'18/12/2012'),
(6170,	6,	5,	'E',	'19/12/2012'),
(6170,	6,	2,	'A',	'20/12/2012'),
(6170,	6,	5,	'A',	'21/12/2012'),
(1234,	3,	1,	'D',	'10/01/2013'),
(1234,	3,	3,	'D',	'10/01/2013'),
(1234,	2,	1,	'E',	'10/01/2013'),
(1234,	2,	1,	'A',	'11/01/2013'),
(2468,	4,	4,	'D',	'25/01/2013'),
(7404,	2,	1,	'E',	'20/01/2013'),
(7404,	2,	5,	'E',	'20/01/2013'),
(7404,	2,	5,	'A',	'21/01/2013'),
(7404,	2,	1,	'A',	'22/01/2013'),
(8638,	6,	5,	'E',	'25/01/2013'),
(8638,	6,	5,	'A',	'26/01/2013'),
(7404,	2,	5,	'D',	'03/02/2013')


SELECT c.nome_cliente AS CLIENTE, p.nome_plano AS PLANO, COUNT (co.status_contrato) AS PLANOS_CANCELADOS
FROM cliente c, contratos co, planos p
where c.cod_cliente = co.cod_cliente and p.cod_plano = co.cod_plano and co.status_contrato like 'D'
GROUP BY c.nome_cliente, p.nome_plano, co.status_contrato
ORDER BY c.nome_cliente


SELECT DISTINCT c.nome_cliente AS CLIENTE, p.nome_plano AS PLANO, s.valor_servico AS VALOR,  
		CASE WHEN (s.valor_servico > 40.00)
		THEN 
		(s.valor_servico * 0.92)
		WHEN (s.valor_servico >= 30.00 AND s.valor_servico <= 40.00)
		THEN
		(s.valor_servico * 0.95)
		WHEN (s.valor_servico >= 20.00 AND s.valor_servico <= 30.00)
		THEN 
		(s.valor_servico * 0.97)
		ELSE 
		NULL 
		END AS DESCONTO 
FROM cliente c, contratos co, planos p, servicos s
WHERE c.cod_cliente = co.cod_cliente and p.cod_plano = co.cod_plano and s.cod_servico = co.cod_servico and
co.status_contrato = 'A' OR co.status_contrato = 'E'


SELECT DISTINCT c.cod_cliente,c.nome_cliente AS CLIENTE, s.nome_servico AS SERVIÇO, DATEDIFF(MONTH, CONVERT(DATE, co.dat, 103), GETDATE()) AS DURAÇÃO_MESES
FROM cliente c INNER JOIN contratos co
ON c.cod_cliente = co.cod_cliente INNER JOIN servicos s
ON s.cod_servico = co.cod_servico
WHERE c.cod_cliente not in(
	select cod_cliente from contratos
	where status_contrato = 'D'
	group by cod_cliente, status_contrato
)







