create table cliente (
cod_cliente INT PRIMARY KEY IDENTITY(1,1),
Nome_cliente VARCHAR(50) NOT NULL,
Endereco VARCHAR (50),
Cidade VARCHAR(20),
Cep CHAR(8),
UF CHAR(2),
CPF_CGC CHAR(14),
IE CHAR(12)
)

create table vendedor (
cod_vendedor INT,
nome_vendedor VARCHAR (50) NOT NULL,
faixa_comissao CHAR(1),
salario_fixo MONEY,
CONSTRAINT PK_VENDEDOR PRIMARY KEY (COD_VENDEDOR)
)

create table pedido (
num_pedido INT PRIMARY KEY IDENTITY(1,1),
data_compra DATETIME,
data_entrega DATETIME,
cod_cliente INT NOT NULL REFERENCES CLIENTE,
cod_vendedor INT NOT NULL REFERENCES VENDEDOR
)

create table produto (
cod_produto INT PRIMARY KEY IDENTITY(1,1),
descricao VARCHAR(20),
Unidade CHAR(2),
Valor_unitario MONEY
)

create table item_pedido (
num_pedido INT REFERENCES pedido,
cod_produto INT REFERENCES produto,
quantidade INT,
PRIMARY KEY (num_pedido, cod_produto)
)