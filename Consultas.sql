--1.	Listar o código e o nome dos vendedores que efetuaram vendas para o cliente com código 10.
-- Junção
SELECT p.cod_vendedor, v.nome_vendedor
FROM pedido p
INNER JOIN vendedor v ON v.cod_vendedor = p.cod_vendedor
WHERE p.cod_cliente = 10;

-- IN
SELECT v.cod_vendedor, v.nome_vendedor
FROM vendedor v
WHERE v.cod_vendedor IN (
    SELECT p.cod_vendedor
    FROM pedido p
    WHERE p.cod_cliente = 10
);

-- EXISTS
SELECT v.cod_vendedor, v.nome_vendedor
FROM vendedor v
WHERE EXISTS (
    SELECT 1
    FROM pedido p
    WHERE p.cod_cliente = 10 AND v.cod_vendedor = p.cod_vendedor
);

--2.	Listar o número do pedido, data de entrega, a quantidade e a descrição do produto com código 2.
-- Junção
SELECT p.Num_pedido, p.data_entrega, ip.quantidade, pr.descricao
FROM pedido p
INNER JOIN item_pedido ip ON ip.num_pedido = p.Num_pedido
INNER JOIN produto pr ON pr.cod_produto = ip.cod_produto
WHERE ip.cod_produto = 2;

--3.	Quais os vendedores (código e nome) fizeram pedidos para o cliente 'Marcelo Cruz'.
-- Junção
SELECT p.cod_vendedor, v.nome_vendedor
FROM pedido p
INNER JOIN vendedor v ON v.cod_vendedor = p.cod_vendedor
INNER JOIN cliente c ON c.Cod_cliente = p.cod_cliente
WHERE c.Nome_cliente = 'Marcelo Cruz';

-- IN
SELECT v.cod_vendedor, v.nome_vendedor
FROM vendedor v
WHERE v.cod_vendedor IN (
    SELECT p.cod_vendedor
    FROM pedido p
    WHERE p.cod_cliente IN (
        SELECT c.cod_cliente
        FROM cliente c
        WHERE c.Nome_cliente = 'Marcelo Cruz'
    )
);

-- EXISTS
SELECT v.cod_vendedor, v.nome_vendedor
FROM vendedor v
WHERE EXISTS (
    SELECT 1
    FROM pedido p
    WHERE p.cod_vendedor = v.cod_vendedor
    AND EXISTS (
        SELECT 1
        FROM cliente c
        WHERE p.cod_cliente = c.Cod_cliente AND c.Nome_cliente = 'Marcelo Cruz'
    )
);

--4.	Quais produtos (código, descrição, unidade e quantidade) cuja quantidade seja maior que 50 e menor que 100.
-- Junção
SELECT pr.cod_produto, pr.descricao, pr.Unidade, SUM(ip.quantidade) AS totalQuantidade
FROM produto pr
INNER JOIN item_pedido ip ON ip.cod_produto = pr.cod_produto
GROUP BY pr.cod_produto, pr.descricao, pr.Unidade
HAVING SUM(ip.quantidade) BETWEEN 51 AND 99
ORDER BY totalQuantidade ASC;

--5.	Listar o número do pedido, o código do produto, a descrição do produto, o código do vendedor, o nome do vendedor, o nome do cliente, 
--para todos os clientes que moram em São Paulo.
-- Junção
SELECT p.Num_pedido, ip.cod_produto, pr.descricao, p.cod_vendedor, v.nome_vendedor, c.Nome_cliente
FROM pedido p
INNER JOIN cliente c ON c.Cod_cliente = p.cod_cliente
INNER JOIN vendedor v ON v.cod_vendedor = p.cod_vendedor
INNER JOIN item_pedido ip ON ip.num_pedido = p.Num_pedido
INNER JOIN produto pr ON pr.cod_produto = ip.cod_produto
WHERE c.Cidade = 'São Paulo';

--6.	Listar todos os dados dos clientes cujo nome comece por “Maria” e que tenha o código do cliente entre 1 e 4, que morem em Sorocaba, 
--que tenham realizado compra em setembro deste ano, por ordem alfabetica de nome do cliente.
-- Junção
SELECT c.*
FROM cliente c
INNER JOIN pedido p ON p.Cod_cliente = c.Cod_cliente
WHERE c.Nome_cliente LIKE 'Maria%'
    AND c.Cod_cliente BETWEEN 1 AND 4
    AND c.Cidade = 'Sorocaba'
    AND MONTH(p.data_compra) = 9
    AND YEAR(p.data_compra) = YEAR(GETDATE())
ORDER BY c.Nome_cliente ASC;

-- IN
SELECT c.*
FROM cliente c
WHERE c.Cod_cliente IN (
    SELECT p.cod_cliente
    FROM pedido p
    WHERE c.Nome_cliente LIKE 'Maria%'
    AND c.Cod_cliente BETWEEN 1 AND 4
    AND c.Cidade = 'Sorocaba'
    AND MONTH(p.data_compra) = 9
    AND YEAR(p.data_compra) = YEAR(GETDATE())
)
ORDER BY c.Nome_cliente ASC;

-- EXISTS
SELECT c.*
FROM cliente c
WHERE EXISTS (
    SELECT 1
    FROM pedido p
    WHERE p.cod_cliente = c.Cod_cliente
    AND c.Nome_cliente LIKE 'Maria%'
    AND c.Cod_cliente BETWEEN 1 AND 4
    AND c.Cidade = 'Sorocaba'
    AND MONTH(p.data_compra) = 9
    AND YEAR(p.data_compra) = YEAR(GETDATE())
)
ORDER BY c.Nome_cliente ASC;

--7.	Listar o código e o nome dos clientes que tem data de entrega para 03/04/2011.

-- Junção
SELECT c.Cod_cliente, c.Nome_cliente
FROM cliente c
INNER JOIN pedido p ON p.cod_cliente = c.Cod_cliente
WHERE p.data_entrega = '2011-04-03';

-- IN
SELECT c.Cod_cliente, c.Nome_cliente
FROM cliente c
WHERE c.Cod_cliente IN (
    SELECT p.cod_cliente
    FROM pedido p
    WHERE p.data_entrega = '2011-04-03'
);

-- EXISTS
SELECT c.Cod_cliente, c.Nome_cliente
FROM cliente c
WHERE EXISTS (
    SELECT 1
    FROM pedido p
    WHERE p.data_entrega = '2011-04-03' AND p.cod_cliente = c.Cod_cliente
);

--8.	Listar o código do produto, a descrição, a quantidade pedida e o data de entrega para o pedido número 12.

-- Junção
SELECT p.Num_pedido, pr.cod_produto, pr.descricao, SUM(ip.quantidade) AS totalQuantidade, p.data_entrega
FROM produto pr
INNER JOIN item_pedido ip ON ip.cod_produto = pr.cod_produto
INNER JOIN pedido p ON p.Num_pedido = ip.num_pedido
WHERE ip.num_pedido = 12
GROUP BY p.Num_pedido, pr.cod_produto, pr.descricao, p.data_entrega
ORDER BY totalQuantidade ASC;

--9.	Listar o nome dos clientes do estado de São Paulo (UF ='SP')  que têm data de entrega até o dia 03-12-2011 e fizeram pedido com 
--o vendedor com código 20.

-- Junção
SELECT c.Nome_cliente, c.Cidade, p.cod_vendedor
FROM cliente c
INNER JOIN pedido p ON p.cod_cliente = c.Cod_cliente
WHERE p.cod_vendedor = 20 AND c.UF = 'SP' AND p.data_entrega <= '2011-12-03';

-- IN
SELECT c.Nome_cliente, c.Cidade
FROM cliente c
WHERE c.Cod_cliente IN (
    SELECT p.cod_cliente
    FROM pedido p
    WHERE p.cod_vendedor = 20 AND c.UF = 'SP' AND p.data_entrega <= '2011-12-03'
);

-- EXISTS
SELECT c.Nome_cliente, c.Cidade
FROM cliente c
WHERE EXISTS (
    SELECT 1
    FROM pedido p
    WHERE p.cod_cliente = c.Cod_cliente AND p.cod_vendedor = 20 AND c.UF = 'SP' AND p.data_entrega <= '2011-12-03'
);

--10.	Quais os clientes (nome e endereço) da cidade de Itu ou Sorocaba tiveram seus pedidos tirados com o vendedor 'Alôncio Pimentão'.

-- Junção
SELECT c.Nome_cliente, c.Endereco
FROM cliente c
INNER JOIN pedido p ON p.cod_cliente = c.Cod_cliente
INNER JOIN vendedor v ON v.cod_vendedor = p.cod_vendedor
WHERE c.Cidade IN ('Itu', 'Sorocaba') AND v.nome_vendedor = 'Alôncio Pimentão'
ORDER BY c.Nome_cliente;

-- IN
SELECT c.Nome_cliente, c.Endereco
FROM cliente c
WHERE c.Cod_cliente IN (
    SELECT p.cod_cliente
    FROM pedido p
    WHERE p.cod_vendedor IN (
        SELECT v.cod_vendedor
        FROM vendedor v
        WHERE v.nome_vendedor = 'Alôncio Pimentão'
    ) AND c.Cidade IN ('Itu', 'Sorocaba')
)
ORDER BY c.Nome_cliente;

-- EXISTS
SELECT c.Nome_cliente, c.Endereco
FROM cliente c
WHERE EXISTS (
    SELECT 1
    FROM pedido p
    WHERE p.cod_cliente = c.Cod_cliente AND EXISTS (
        SELECT 1
        FROM vendedor v
        WHERE v.cod_vendedor = p.cod_vendedor AND v.nome_vendedor = 'Alôncio Pimentão'
    ) AND c.Cidade IN ('Itu', 'Sorocaba')
)
ORDER BY c.Nome_cliente;

--11. Quais produtos (código, descrição, unidade) cuja quantidade vendida seja maior que 50 e tenha sido vendida pelo vendedor 'Fulano Antonio'.

-- Junção
SELECT pr.cod_produto, pr.descricao, pr.Unidade, SUM(ip.quantidade) AS totalQuantidade
FROM produto pr
INNER JOIN item_pedido ip ON ip.cod_produto = pr.cod_produto
INNER JOIN pedido p ON p.Num_pedido = ip.num_pedido
INNER JOIN vendedor v ON v.cod_vendedor = p.cod_vendedor
WHERE v.nome_vendedor = 'Fulano Antonio'
GROUP BY pr.cod_produto, pr.descricao, pr.Unidade
HAVING SUM(ip.quantidade) > 50
ORDER BY totalQuantidade ASC;

-- IN
SELECT pr.cod_produto, pr.descricao, pr.Unidade
FROM produto pr
WHERE pr.cod_produto IN (
    SELECT ip.cod_produto
    FROM item_pedido ip
    WHERE ip.num_pedido IN (
        SELECT p.Num_pedido
        FROM pedido p
        WHERE p.cod_vendedor IN (
            SELECT v.cod_vendedor
            FROM vendedor v
            WHERE v.nome_vendedor = 'Fulano Antonio'
        )
    )
    GROUP BY ip.cod_produto
    HAVING SUM(ip.quantidade) > 50
)
ORDER BY pr.descricao ASC;

-- EXISTS
SELECT pr.cod_produto, pr.descricao, pr.Unidade
FROM produto pr
WHERE EXISTS (
    SELECT 1
    FROM item_pedido ip
    WHERE ip.cod_produto = pr.cod_produto
    AND EXISTS (
        SELECT 1
        FROM pedido p
        WHERE p.Num_pedido = ip.num_pedido
        AND EXISTS (
            SELECT 1
            FROM vendedor v
            WHERE v.cod_vendedor = p.cod_vendedor
            AND v.nome_vendedor = 'Fulano Antonio'
        )
    )
    GROUP BY ip.cod_produto
    HAVING SUM(ip.quantidade) > 50
)
ORDER BY pr.descricao ASC;

--12. Listar o número do pedido, o código do produto, a descrição do produto, o código do vendedor, o nome do vendedor, o nome do cliente, para todos os clientes que moram em Itu.

-- Junção
SELECT p.Num_pedido, ip.cod_produto, pr.descricao, p.cod_vendedor, v.nome_vendedor, c.Nome_cliente
FROM pedido p
INNER JOIN item_pedido ip ON ip.num_pedido = p.Num_pedido
INNER JOIN produto pr ON pr.cod_produto = ip.cod_produto
INNER JOIN vendedor v ON v.cod_vendedor = p.cod_vendedor
INNER JOIN cliente c ON c.Cod_cliente = p.cod_cliente
WHERE c.Cidade = 'Itu';

--13. Listar todos os clientes (nome do cliente e cidade) que moram na mesma cidade que 'João da Silva'.

-- Junção
SELECT c.Nome_cliente, c.Cidade
FROM cliente c
INNER JOIN cliente c2 ON c2.Cidade = c.Cidade
WHERE c2.Nome_cliente = 'João da Silva';

-- IN
SELECT c.Nome_cliente, c.Cidade
FROM cliente c
WHERE c.Cidade IN (
    SELECT c2.Cidade
    FROM cliente c2
    WHERE c2.Nome_cliente = 'João da Silva'
);

-- EXISTS
SELECT c.Nome_cliente, c.Cidade
FROM cliente c
WHERE EXISTS (
    SELECT 1
    FROM cliente c2
    WHERE c2.Nome_cliente = 'João da Silva'
    AND c2.Cidade = c.Cidade
);

--14. Alterar os preço unitário dos produtos: reduzir em 8% o valor dos produtos que não tenham sido vendido no segundo semestre deste ano.

-- Consulta produtos que não atingiram a meta
SELECT DISTINCT pr.cod_produto, pr.descricao, (pr.Valor_unitario - (pr.Valor_unitario * 0.08)) AS valorReduzido, pr.Valor_unitario
FROM produto pr
WHERE pr.cod_produto NOT IN (
    SELECT ip.cod_produto
    FROM item_pedido ip
    INNER JOIN pedido p ON p.Num_pedido = ip.num_pedido
    WHERE MONTH(p.data_compra) >= 7 AND YEAR(p.data_compra) = YEAR(GETDATE())
)
ORDER BY pr.cod_produto ASC;

-- Update
UPDATE produto
SET Valor_unitario = Valor_unitario * 0.92 -- 0.92 para reduzir em 8%
WHERE cod_produto NOT IN (
    SELECT DISTINCT pr.cod_produto
    FROM produto pr
    INNER JOIN item_pedido ip ON ip.cod_produto = pr.cod_produto
    INNER JOIN pedido p ON p.Num_pedido = ip.num_pedido
    WHERE MONTH(p.data_compra) >= 7 AND YEAR(p.data_compra) = YEAR(GETDATE())
);

--15. Aumentar em 5% o salario base dos vendedores com somatória de valores de vendas superior a 10.000, no mês de outubro deste ano.

-- Consulta vendedores que atingiram a meta
SELECT v.nome_vendedor, SUM(ip.quantidade * pr.Valor_unitario) AS vendasTotal
FROM vendedor v
INNER JOIN pedido p ON p.cod_vendedor = v.cod_vendedor
INNER JOIN item_pedido ip ON ip.num_pedido = p.Num_pedido
INNER JOIN produto pr ON pr.cod_produto = ip.cod_produto
WHERE MONTH(p.data_compra) = 10 AND YEAR(p.data_compra) = YEAR(GETDATE())
GROUP BY v.nome_vendedor
HAVING SUM(ip.quantidade * pr.Valor_unitario) > 10000;

-- Update
UPDATE vendedor
SET salario_fixo = salario_fixo * 1.05
WHERE cod_vendedor IN (
    SELECT v.cod_vendedor
    FROM vendedor v
    INNER JOIN pedido p ON p.cod_vendedor = v.cod_vendedor
    INNER JOIN item_pedido ip ON ip.num_pedido = p.Num_pedido
    INNER JOIN produto pr ON pr.cod_produto = ip.cod_produto
    WHERE MONTH(p.data_compra) = 10 AND YEAR(p.data_compra) = YEAR(GETDATE())
    GROUP BY v.cod_vendedor
    HAVING SUM(ip.quantidade * pr.Valor_unitario) > 10000
);

--16. Apagar da tabela vendedores aqueles vendedores que não realizaram nenhuma venda.

DELETE FROM vendedor
WHERE cod_vendedor NOT IN (
    SELECT DISTINCT p.cod_vendedor
    FROM pedido p
);

--17. Apagar da tabela vendedores aqueles vendedores que não realizaram nenhuma venda NO MÊS DE ABRIL DE 2018.

DELETE FROM vendedor
WHERE cod_vendedor NOT IN (
    SELECT DISTINCT p.cod_vendedor
    FROM pedido p
    WHERE MONTH(p.data_compra) = 4 AND YEAR(p.data_compra) = 2018
);

--18. Listar o nome dos vendedores com média de valor de vendas superior à média de todos os vendedores.

-- Junção
SELECT v.nome_vendedor, AVG(ip.quantidade * pr.Valor_unitario) AS mediaVendas
FROM vendedor v
INNER JOIN pedido p ON p.cod_vendedor = v.cod_vendedor
INNER JOIN item_pedido ip ON ip.num_pedido = p.Num_pedido
INNER JOIN produto pr ON pr.cod_produto = ip.cod_produto
GROUP BY v.nome_vendedor
HAVING AVG(ip.quantidade * pr.Valor_unitario) > (
    SELECT AVG(mediaVendas)
    FROM (
        SELECT AVG(ip.quantidade * pr.Valor_unitario) AS mediaVendas
        FROM vendedor v
        INNER JOIN pedido p ON p.cod_vendedor = v.cod_vendedor
        INNER JOIN item_pedido ip ON ip.num_pedido = p.Num_pedido
        INNER JOIN produto pr ON pr.cod_produto = ip.cod_produto
        GROUP BY v.cod_vendedor
    ) AS subquery
);

--19. Listar nome dos clientes que realizaram compra com o vendedor 'Ciclano Alberto', no mês de maio deste ano.

SELECT c.Nome_cliente
FROM cliente c
INNER JOIN pedido p ON p.cod_cliente = c.Cod_cliente
INNER JOIN vendedor v ON v.cod_vendedor = p.cod_vendedor
WHERE v.nome_vendedor = 'Ciclano Alberto'
AND MONTH(p.data_compra) = 5
AND YEAR(p.data_compra) = YEAR(GETDATE());

--20. Listar nome dos clientes que só realizaram compra com o vendedor 'Ciclano Alberto', no mês de maio deste ano.

SELECT DISTINCT c.Nome_cliente
FROM cliente c
INNER JOIN pedido p ON p.cod_cliente = c.Cod_cliente
INNER JOIN vendedor v ON v.cod_vendedor = p.cod_vendedor
WHERE v.nome_vendedor = 'Ciclano Alberto'
AND MONTH(p.data_compra) = 5
AND YEAR(p.data_compra) = YEAR(GETDATE())
AND NOT EXISTS (
    SELECT 1
    FROM pedido p2
    INNER JOIN vendedor v2 ON v2.cod_vendedor = p2.cod_vendedor
    WHERE p2.cod_cliente = c.Cod_cliente
    AND v2.nome_vendedor <> 'Ciclano Alberto'
    AND MONTH(p2.data_compra) = 5
    AND YEAR(p2.data_compra) = YEAR(GETDATE())
);

--21. Listar nome dos vendedores que só realizaram venda para o cliente 'Fulano Eraldo'.

SELECT v.nome_vendedor
FROM vendedor v
INNER JOIN pedido p ON p.cod_vendedor = v.cod_vendedor
INNER JOIN cliente c ON c.Cod_cliente = p.cod_cliente
WHERE c.Nome_cliente = 'Fulano Eraldo'
AND NOT EXISTS (
    SELECT 1
    FROM pedido p2
    INNER JOIN cliente c2 ON c2.Cod_cliente = p2.cod_cliente
    WHERE p2.cod_vendedor = v.cod_vendedor
    AND c2.Nome_cliente <> 'Fulano Eraldo'
);
