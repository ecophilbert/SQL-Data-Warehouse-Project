USE ZenixST
GO

/*
========================================================================
DDL Script: Criar tabelas de Staging
========================================================================
Script ojebtivo:
	Este script cria as tabelas no Staging se ainda não existem
		Run este script para redefinir as tabelas do Stage.
========================================================================
*/
CREATE OR ALTER PROCEDURE USP_CreateTableSTG AS

BEGIN
	IF OBJECT_ID('STdClientes') IS NULL
	
		CREATE TABLE STdClientes(
			COD_CLIENTE NUMERIC(15),
			NOME VARCHAR(80),
			INSCRICAO_FEDERAL VARCHAR(18),
			ATIVO CHAR(1),
			COD_CLASSIFICACAO NUMERIC(15),
		);

	IF OBJECT_ID('STdClassificacoesClients') IS NULL

		CREATE TABLE STdClassificacoesClients(
			COD_CLASSIFICACAO NUMERIC(15),
			CLASSIFICACAO VARCHAR(80)
		);


	IF OBJECT_ID('STdEnderecos') IS NULL
		CREATE TABLE STdEnderecos(
			COD_CLIENTE NUMERIC(15),
			UF CHAR(2), 
			CIDADE VARCHAR(80)
		);

	IF OBJECT_ID('STdEstados') IS NULL
		
		CREATE TABLE STdEstados(
			UF CHAR(2),
			ESTADO VARCHAR(80)
		);

	IF OBJECT_ID('STdEmpresas') IS NULL
	
		CREATE TABLE STdEmpresas(
			COD_EMPRESA NUMERIC(15),
			NOME VARCHAR(80),
			NOME_FANTASIA VARCHAR(60)
		);

	IF OBJECT_ID('STdProdutos') IS NULL

		CREATE TABLE STdProdutos(
			COD_PRODUTO	NUMERIC(15),
			DESCRICAO	VARCHAR(100),
			DESCRICAO_REDUZIDA  VARCHAR(60),
			COD_FAMILIA NUMERIC(15)	,
			COD_SECAO NUMERIC(15)	,
			COD_GRUPO NUMERIC(15)	,
			COD_SUBGRUPO NUMERIC(15),
			COD_MARCA NUMERIC(15)	
		);

	IF OBJECT_ID('STdFamiliasProdutos') IS NULL

		CREATE TABLE STdFamiliasProdutos(
			COD_FAMILIA NUMERIC(15),
			DESCRICAO VARCHAR(80)
		);

	IF OBJECT_ID('STdSecoesProdutos') IS NULL
		
		CREATE TABLE STdSecoesProdutos(
			COD_SECAO NUMERIC(15),
			DESCRICAO VARCHAR(80)
		);

	IF OBJECT_ID('STdGruposProdutos') IS NULL

		CREATE TABLE STdGruposProdutos(
			COD_GRUPO NUMERIC(15),
			DESCRICAO VARCHAR(80)
		);

	IF OBJECT_ID('STdSubgruposProdutos') IS NULL

		CREATE TABLE STdSubgruposProdutos(
			COD_SUBGRUPO NUMERIC(15),
			DESCRICAO VARCHAR(80)
		);

	IF OBJECT_ID('STdMarcas')  IS NULL
		CREATE TABLE STdMarcas(
			COD_MARCA NUMERIC(15),
			DESCRICAO VARCHAR(80)
		);

	IF OBJECT_ID('STdVendedores') IS NULL

	CREATE TABLE STdVendedores(

		COD_VENDEDOR	NUMERIC(15),
		NOME			VARCHAR(80)
	);

	IF OBJECT_ID('STfVendas') IS NULL

	CREATE TABLE STfVendas
		(
		No_DOC NUMERIC(15),
		COD_EMPRESA NUMERIC(15),
		MOVIMENTO DATE,
		COD_PRODUTO NUMERIC(15),
		COD_VENDEDOR NUMERIC(15),
		COD_CLIENTE NUMERIC(15),
		QUANTIDADE NUMERIC(10),
		VENDA_BRUTA NUMERIC(10),
		DESCONTO NUMERIC(10),
		VENDA_LIQUIDA NUMERIC(10),
		IMPOSTOS NUMERIC(10)
		);
	IF OBJECT_ID('STfcotacoes') IS NULL
	
	CREATE TABLE STfcotacoes(
		cotacaoCompra VARCHAR(10), 
		cotacaoVenda Varchar(10), 
		dataHoraCotacao Varchar(100) 
	)
		
	IF OBJECT_ID('STdFeriados_Brasil') IS NULL    

	CREATE TABLE STdFeriados_Brasil(
		[DATA] DATE,
		DESCRICAO VARCHAR(50)
	);
END;
GO