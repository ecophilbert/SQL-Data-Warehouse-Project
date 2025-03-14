USE ZenixST
GO
/*
=============================================================================================
Stored Procedure: 
	DLM Script: Extract and Laod Staging (Source -> Staging)
=============================================================================================
Objetivo do Script: 
	Este Procedure extrai Dados das fontes e carrega para staging.
	Executa as seguintes acções:
		Create tabelas de staging se ainda não existem
		Truncate as Tabelas de stage antes de carregar os dados
		Utiliza o comando INSERT INTO para carregar dados das fontes para tabelas do staging.

Parâmetros:
	Nenhum.
	Este Stored Procedure não aceita nenhum parâmetro ou retorna nenhum valor

Exemplo de uso:
	EXEC USP_ExtractST
=============================================================================================
*/

CREATE OR ALTER PROCEDURE USP_ExtractST AS

BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';
			
		PRINT '>> Creating no existing tables';
		PRINT '>> -------------';
		EXEC USP_CreateTableSTG;
-------------------------------------------------------------------------------------------------------------------

	--*** DML Script: Carrega dados para tabelas de staging ***--
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdClientes';
		TRUNCATE TABLE STdClientes;

		PRINT '>> Inserting Data Into: STdClientes';
		INSERT INTO STdClientes(
				COD_CLIENTE ,
				NOME ,
				INSCRICAO_FEDERAL ,
				ATIVO,
				COD_CLASSIFICACAO
			)

		SELECT
			ENTIDADE,
			NOME,
			INSCRICAO_FEDERAL,
			ATIVO,
			CLASSIFICACAO_CLIENTE
		FROM PBS_PROCFIT_DADOS.dbo.ENTIDADES;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-------------------------------------------------------------------------------------------------------------------
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdClassificacoesClients';
		TRUNCATE TABLE STdClassificacoesClients;

		PRINT '>> Inserting Data Into: STdClassificacoesClients';				
		INSERT INTO STdClassificacoesClients(
			COD_CLASSIFICACAO,
			CLASSIFICACAO
		)
	
		SELECT 
			CLASSIFICACAO_CLIENTE,
			DESCRICAO
		FROM PBS_PROCFIT_DADOS.dbo.CLASSIFICACOES_CLIENTES;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
------------------------------------------------------------------------------------------------------------
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdEnderecos';
		TRUNCATE TABLE STdEnderecos;

		PRINT '>> Inserting Data Into: STdEnderecos';
		INSERT INTO STdEnderecos(
			COD_CLIENTE,
			UF, 
			CIDADE
		)

		SELECT 
			ENTIDADE,
			ESTADO,
			CIDADE
		FROM PBS_PROCFIT_DADOS.dbo.ENDERECOS;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdEstados';
		TRUNCATE TABLE STdEstados;

		PRINT '>> Inserting Data Into: STdEstados';
		INSERT INTO STdEstados(
			UF,
			ESTADO
		)
		SELECT 
			ESTADO,
			NOME
		FROM PBS_PROCFIT_DADOS.dbo.ESTADOS;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdEmpresas';
		TRUNCATE TABLE STdEmpresas;

		PRINT '>> Inserting Data Into: STdEmpresas';
		INSERT INTO STdEmpresas(
			COD_EMPRESA,
			NOME,
			NOME_FANTASIA
			)

		SELECT
			EMPRESA_USUARIA AS COD_EMPRESA,
			NOME,
			NOME_FANTASIA
		FROM PBS_PROCFIT_DADOS.dbo.EMPRESAS_USUARIAS;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdProdutos';
		TRUNCATE TABLE STdProdutos;

		PRINT '>> Inserting Data Into: STdProdutos';
		INSERT INTO STdProdutos(
			COD_PRODUTO,
			DESCRICAO,
			DESCRICAO_REDUZIDA,
			COD_FAMILIA,
			COD_SECAO,
			COD_GRUPO,
			COD_SUBGRUPO,
			COD_MARCA
			)

		SELECT 
			PRODUTO,
			DESCRICAO,
			DESCRICAO_REDUZIDA,
			FAMILIA_PRODUTO,
			SECAO_PRODUTO,
			GRUPO_PRODUTO,
			SUBGRUPO_PRODUTO,
			MARCA
		FROM PBS_PROCFIT_DADOS.dbo.PRODUTOS;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-----------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdFamiliasProdutos';
		TRUNCATE TABLE STdFamiliasProdutos;

		PRINT '>> Inserting Data Into: STdFamiliasProdutos';
		INSERT INTO STdFamiliasProdutos(
			COD_FAMILIA,
			DESCRICAO
		)

		SELECT 
			FAMILIA_PRODUTO, 
			DESCRICAO
		FROM PBS_PROCFIT_DADOS.dbo.FAMILIAS_PRODUTOS;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdSecoesProdutos';
		TRUNCATE TABLE STdSecoesProdutos;

		PRINT '>> Inserting Data Into: STdSecoesProdutos';
		INSERT INTO STdSecoesProdutos(
			COD_SECAO,
			DESCRICAO
		)			

		SELECT 
			SECAO_PRODUTO,
			DESCRICAO
		FROM PBS_PROCFIT_DADOS.dbo.SECOES_PRODUTOS;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
------------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdGruposProdutos';
		TRUNCATE TABLE STdGruposProdutos;

		PRINT '>> Inserting Data Into: STdGruposProdutos';
		INSERT INTO STdGruposProdutos(
			COD_GRUPO,
			DESCRICAO
		)

		SELECT
			GRUPO_PRODUTO,
			DESCRICAO
		FROM PBS_PROCFIT_DADOS.dbo.GRUPOS_PRODUTOS;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
----------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdSubgruposProdutos';
		TRUNCATE TABLE STdSubgruposProdutos;

		PRINT '>> Inserting Data Into: STdSubgruposProdutos';
		INSERT INTO STdSubgruposProdutos(
			COD_SUBGRUPO,
			DESCRICAO
		)

		SELECT
			SUBGRUPO_PRODUTO,
			DESCRICAO
		FROM PBS_PROCFIT_DADOS.dbo.SUBGRUPOS_PRODUTOS;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
----------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdMarcas';
		TRUNCATE TABLE STdMarcas;

		PRINT '>> Inserting Data Into: STdMarcas';		
		INSERT INTO STdMarcas(
			COD_MARCA,
			DESCRICAO
		)

		SELECT 
			MARCA, 
			DESCRICAO
		FROM PBS_PROCFIT_DADOS.dbo.MARCAS;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
------------------------------------------------------------------------------------------------------------------
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdVendedores';
		TRUNCATE TABLE STdVendedores;

		PRINT '>> Inserting Data Into: STdVendedores';
		INSERT INTO STdVendedores(
			COD_VENDEDOR,
			NOME
		)

		SELECT 
			VENDEDOR,
			NOME
		FROM PBS_PROCFIT_DADOS.dbo.VENDEDORES;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-----------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STfVendas';
		TRUNCATE TABLE STfVendas;

		PRINT '>> Inserting Data Into: STfVendas';
		INSERT INTO STfVendas(
			No_DOC,
			COD_EMPRESA,
			MOVIMENTO,
			COD_PRODUTO ,
			COD_VENDEDOR,
			COD_CLIENTE,
			QUANTIDADE,
			VENDA_BRUTA,
			DESCONTO,
			VENDA_LIQUIDA ,
			IMPOSTOS
		)

		SELECT 
			DOCUMENTO_NUMERO
			,EMPRESA
			,MOVIMENTO
			,PRODUTO
			,VENDEDOR
			,CLIENTE
			,QUANTIDADE
			,VENDA_BRUTA
			,DESCONTO + DESCONTO_NEGOCIADO AS DESCONTO
			,VENDA_LIQUIDA
			,IMPOSTOS
		FROM PBS_PROCFIT_DADOS.dbo.VENDAS_ANALITICAS;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-----------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STfcotacoes';
		TRUNCATE TABLE STfcotacoes

		PRINT '>> Inserting Data Into: STfcotacoes';
		INSERT INTO STfcotacoes(
			cotacaoCompra, 
			cotacaoVenda, 
			dataHoraCotacao
		)

		--SELECT * FROM dbo.FN_EXTRACT_API_BCB('01-01-2019', FORMAT( CAST(GETDATE() AS DATE), 'dd-MM-yyy'))
		SELECT * FROM dbo.FN_EXTRACT_API_BCB('01-01-2019', '31-12-2020');
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-----------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: STdFeriados_Brasil';
		TRUNCATE TABLE STdFeriados_Brasil;

		PRINT '>> Inserting Data Into: STdFeriados_Brasil';
		BULK INSERT STdFeriados_Brasil
		FROM 'E:\Downloads\feriados_brasil_f.csv'
		WITH (
			FORMAT ='CSV',
			CODEPAGE = '65001',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2 -- Ignora a primeira linha for cabeçalho
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
-----------------------------------------------------------------------------------------------------------------

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH;
END;
GO