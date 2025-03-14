USE ZenixDW
GO

/*
========================================================================
DDL Script: Criar tabelas de Data Warehouse
========================================================================
Script ojebtivo:
	Este script cria as tabelas no Data Warehouse se ainda não existem
		Run este script para redefinir as tabelas do Data Warehouse.

	Exemplo de uso:
EXEC USP_CreateTableDW
========================================================================
*/
CREATE OR ALTER PROCEDURE USP_CreateTableDW AS
BEGIN

	IF OBJECT_ID('DWdClientes') IS NULL
	
	CREATE TABLE DWdClientes 
		(
		COD_CLIENTE NUMERIC(15) PRIMARY KEY NOT NULL,
		NOME VARCHAR(80),
		INSCRICAO_FEDERAL VARCHAR(18),
		ATIVO CHAR(1),
		CLASSIFICACAO VARCHAR(60),
		CIDADE VARCHAR(60),
		ESTADO VARCHAR(30),
		UF CHAR(2)
		);

	IF OBJECT_ID('DWdEmpresas') IS NULL
	
	CREATE TABLE DWdEmpresas
		(COD_EMPRESA NUMERIC(15) PRIMARY KEY NOT NULL,
		NOME VARCHAR(80),
		NOME_FANTASIA VARCHAR(60)
		);

	IF OBJECT_ID('DWdProdutos') IS NULL

	CREATE TABLE DWdProdutos 
		(
		COD_PRODUTO	NUMERIC(15) PRIMARY KEY NOT NULL,
		DESCRICAO VARCHAR(100),
		DESCRICAO_REDUZIDA  VARCHAR(60),
		FAMILIA_PRODUTO	VARCHAR(80),
		SECAO_PRODUTO VARCHAR(80),
		GRUPO_PRODUTO VARCHAR(80),
		SUBGRUPO_PRODUTO VARCHAR(80),
		MARCA VARCHAR(80)
		);

	IF OBJECT_ID('DWdVendedores') IS NULL

	CREATE TABLE DWdVendedores(

		COD_VENDEDOR	NUMERIC(15) PRIMARY KEY NOT NULL,
		NOME			VARCHAR(80)
	);

	IF OBJECT_ID('DWfVendas') IS NULL

	CREATE TABLE DWfVendas(
		No_DOC NUMERIC(15),
		COD_EMPRESA NUMERIC(15) NOT NULL,
		MOVIMENTO DATE NOT NULL,
		COD_COTACAO NUMERIC(6),
		COD_PRODUTO NUMERIC(15) NOT NULL,
		COD_VENDEDOR NUMERIC(15) ,
		COD_CLIENTE NUMERIC(15) NOT NULL,
		QUANTIDADE INT NOT NULL,
		VENDA_BRUTA MONEY NOT NULL,
		DESCONTO MONEY NOT NULL,
		VENDA_LIQUIDA MONEY NOT NULL,
		IMPOSTOS MONEY,
		CONSTRAINT FK_cliente_venda FOREIGN KEY (COD_CLIENTE) REFERENCES DWdClientes(COD_CLIENTE),
		CONSTRAINT FK_produto_venda FOREIGN KEY (COD_PRODUTO) REFERENCES DWdProdutos(COD_PRODUTO),
		CONSTRAINT FK_vendedor_venda FOREIGN KEY (COD_VENDEDOR) REFERENCES DWdVendedores(COD_VENDEDOR),
		CONSTRAINT FK_empresa_venda FOREIGN KEY (COD_EMPRESA) REFERENCES DWdEmpresas(COD_EMPRESA),
	);

	IF OBJECT_ID('DWfcotacoes') IS NULL
	
	CREATE TABLE DWfcotacoes(
		dataCotacao DATE,
		AnoMes INT PRIMARY KEY,
		cotacaoMediaMes MONEY,
		cotacaoInicioMes MONEY, 
		cotacoaFimMes MONEY,
		cotacaoMediaAno MONEY,
		cotacaoInicioAno MONEY,
		cotacoaFimAno MONEY
	);

	IF OBJECT_ID('DWdCalender') IS NULL

	CREATE TABLE DWdcalender(
	[date] DATE PRIMARY KEY		  , 
	[year] INT					  , 
	[start_of_year] DATE		  , 
	[end_of_year] DATE			  , 
	[month] TINYINT				  , 
	[star_of_month] DATE		  , 
	[end_of_month] DATE			  , 
	[day_in_month] TINYINT		  , 
	[year_month_number] INT		  , 
	[year_month_name] VARCHAR(8)  , 
	[day] TINYINT				  , 
	[day_name] VARCHAR(15)		  , 
	[day_name_short] CHAR(3)	  , 
	[day_of_week] TINYINT		  , 
	[day_of_year] SMALLINT		  , 
	[month_name] VARCHAR(15)	  , 
	[month_name_short] CHAR(3)	  , 
	[quarter] TINYINT			  , 
	[quarter_name] CHAR(2)		  , 
	[year_quarter_number] INT	  , 
	[year_quarter_name] VARCHAR(7), 
	[start_of_quarter] DATE		  , 
	[end_of_quarter] DATE		  , 
	[week_of_year] TINYINT 		  , 
	[star_of_week] DATE			  , 
	[end_of_week] DATE			  , 
	[fiscal_year] INT			  , 
	[fiscal_quarter] TINYINT	  , 
	[fiscal_month] TINYINT		  , 
	[day_offset] INT			  , 
	[month_offset] INT			  , 
	[quarter_offset] INT		  , 
	[year_offset] INT			  , 
	[is_holiday]	VARCHAR(60)
);

END

GO

--TRUNCATE TABLE DWdClientes;
--TRUNCATE TABLE DWdEmpresas;
--TRUNCATE TABLE DWdProdutos;
--TRUNCATE TABLE DWdVendedores;
--TRUNCATE TABLE DWfVendas;
GO


--DROP TABLE DWdClientes
--DROP TABLE DWdEmpresas
--DROP TABLE DWdProdutos
--DROP TABLE DWdVendedores
--DROP TABLE DWfVendas
--DROP TABLE DWfcotacoes
