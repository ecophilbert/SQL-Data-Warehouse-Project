USE ZenixODS
GO

/*
========================================================================
DDL Script: Criar as tabelas de ODS
========================================================================
Script ojebtivo:
	Este script cria as tabelas no ODS se ainda não existem
		Run este script para redefinir as tabelas do ODS.

Exemplo de uso:
	EXEC USP_CreateTableODS
========================================================================
*/
CREATE OR ALTER PROCEDURE USP_CreateTableODS AS
BEGIN

	IF OBJECT_ID('ODSdClientes') IS NULL
	
	CREATE TABLE ODSdClientes 
		(
		COD_CLIENTE NUMERIC(15),
		NOME VARCHAR(80),
		INSCRICAO_FEDERAL VARCHAR(18),
		ATIVO CHAR(1),
		CLASSIFICACAO VARCHAR(60),
		CIDADE VARCHAR(60),
		ESTADO VARCHAR(30),
		UF CHAR(2)
		);

	IF OBJECT_ID('ODSdEmpresas') IS NULL
	
	CREATE TABLE ODSdEmpresas
		(COD_EMPRESA NUMERIC(15),
		NOME VARCHAR(80),
		NOME_FANTASIA VARCHAR(60)
		);

	IF OBJECT_ID('ODSdProdutos') IS NULL

	CREATE TABLE ODSdProdutos 
		(
		COD_PRODUTO	NUMERIC(15),
		DESCRICAO VARCHAR(100),
		DESCRICAO_REDUZIDA  VARCHAR(60),
		FAMILIA_PRODUTO	VARCHAR(80),
		SECAO_PRODUTO VARCHAR(80),
		GRUPO_PRODUTO VARCHAR(80),
		SUBGRUPO_PRODUTO VARCHAR(80),
		MARCA VARCHAR(80)
		);

	IF OBJECT_ID('ODSdVendedores') IS NULL

	CREATE TABLE ODSdVendedores(

		COD_VENDEDOR	NUMERIC(15),
		NOME			VARCHAR(80)
	);

	IF OBJECT_ID('ODSfVendas') IS NULL

	CREATE TABLE ODSfVendas(
		No_DOC NUMERIC(15),
		COD_EMPRESA NUMERIC(15),
		MOVIMENTO DATE,
		COD_COTACAO NUMERIC(6),
		COD_PRODUTO NUMERIC(15),
		COD_VENDEDOR NUMERIC(15),
		COD_CLIENTE NUMERIC(15),
		QUANTIDADE INT,
		VENDA_BRUTA MONEY,
		DESCONTO MONEY,
		VENDA_LIQUIDA MONEY,
		IMPOSTOS MONEY
	);

	IF OBJECT_ID('ODSfcotacoes') IS NULL
	
	CREATE TABLE ODSfcotacoes(
		dataCotacao DATE,
		AnoMes INT,
		cotacaoMediaMes MONEY,
		cotacaoInicioMes MONEY, 
		cotacoaFimMes MONEY,
		cotacaoMediaAno MONEY,
		cotacaoInicioAno MONEY,
		cotacoaFimAno MONEY
	);

	IF OBJECT_ID('ODSdCalender') IS NULL

	CREATE TABLE ODSdcalender(
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
--TRUNCATE TABLE ODSdClientes;
--TRUNCATE TABLE ODSdEmpresas;
--TRUNCATE TABLE ODSdProdutos;
--TRUNCATE TABLE ODSdVendedores;
--TRUNCATE TABLE ODSfVendas;
GO

--DROP TABLE ODSClientes
--DROP TABLE ODSEmpresas
--DROP TABLE ODSProdutos
--DROP TABLE ODSVendedores
--DROP TABLE ODSVendas
--DROP TABLE ODSfcotacoes
--DROP TABLE ODSdCalender
