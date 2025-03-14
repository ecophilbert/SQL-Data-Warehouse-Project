USE ZenixODS
GO
/*
=============================================================================================
Stored Procedure: Transform and Laod ODS (STG -> OSD)
=============================================================================================
Objetivo do Script: 
	Este Procedure Transforma Dados de staging depois carregar para ODS.
	Executa as seguintes acções:
		Cria Tabelas da ODS caso não existem
		Transforma os Dados das Tabelas de stage.
		Utiliza o comando INSERT INTO para carregar dados para ODS.

Parâmetros:
	Nenhum.
	Este Stored Procedure não aceita nenhum parâmetro ou retorna nenhum valor

Exemplo de uso:
	EXEC USP_TransformODS
=============================================================================================
*/

CREATE OR ALTER PROCEDURE USP_TransformODS AS

BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Operatinal Data Stored (ODS)';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading Staging Tables';
		PRINT '------------------------------------------------';

		PRINT '>> Creating no existing tables';
		PRINT '>> -------------'
		EXEC USP_CreateTableODS
--------------------------------------------------------------------------------------------------------

	--*** DDL Script: Carrega dados para tabelas de staging ***--

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: ODSdClientes';
		TRUNCATE TABLE ODSdClientes

	PRINT '>> Inserting Data Into: ODSdClientes';
	INSERT INTO ZenixODS.dbo.ODSdClientes

	SELECT 
		0 AS COD_CLIENTE,
		'Não informado' AS NOME,
		'ND' AS PERSOA,
		'N' AS ATIVO,
		'Não informado' AS CLASSIFICACAO,
		'Não informado' AS CIDADE,
		'Não informado' AS ESTADO,
		'ND' AS UF

	UNION ALL

	SELECT
		A.COD_CLIENTE,
		A.NOME,
		CASE WHEN LEN(A.INSCRICAO_FEDERAL) <= 14 THEN 'PF'
			 WHEN LEN(A.INSCRICAO_FEDERAL) <= 18 THEN 'PJ' 
			 ELSE 'ND' 
		END AS PERSOA,
		COALESCE(A.ATIVO, 'N') AS ATIVO,
		COALESCE(dbo.FN_CAP_FIRST(B.CLASSIFICACAO), 'Não informado') AS CLASSIFICACAO,
		COALESCE(dbo.FN_CAP_FIRST(C.CIDADE), 'Não informado') AS CIDADE,
		COALESCE(dbo.FN_CAP_FIRST(D.ESTADO), 'Não informado') AS ESTADO,
		COALESCE(D.UF, 'ND') AS UF	
	FROM ZenixST.dbo.STdClientes A
	LEFT JOIN ZenixST.dbo.STdClassificacoesClients B ON A.COD_CLASSIFICACAO = B.COD_CLASSIFICACAO
	LEFT JOIN ZenixST.dbo.STdEnderecos C ON A.COD_CLIENTE = C.COD_CLIENTE
	LEFT JOIN ZenixST.dbo.STdEstados D ON C.UF = D.UF;
--------------------------------------------------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: ODSdEmpresas';
	TRUNCATE TABLE ODSdEmpresas;

	PRINT '>> Inserting Data Into: ODSdEmpresas';
	INSERT INTO ODSdEmpresas 

	SELECT
		COD_EMPRESA,
		dbo.FN_CAP_FIRST(NOME) AS NOME,
		dbo.FN_CAP_FIRST(NOME_FANTASIA) AS NOME_FANTASIA
	FROM ZenixST.dbo.STdEmpresas;
	SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
--------------------------------------------------------------------------------------------------------

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: ODSdProdutos';
	TRUNCATE TABLE ODSdProdutos;

	PRINT '>> Inserting Data Into: ODSdProdutos';
	INSERT INTO ODSdProdutos

		SELECT
		0 AS COD_PRODUTO,
		'Não informado' AS DESCRICAO,
		'Não informado' AS DESCRICAO_REDUZIDA,
		'Não informado' AS FAMILA_PRODUTO,
		'Não informado' AS SECAO_PRODUTO,
		'Não informado' AS GRUPO_PRODUTO,
		'Não informado' AS SUBGRUPO_PRODUTO,
		'Não informado' AS MARCA

	UNION ALL

	SELECT 
		A.COD_PRODUTO,
		dbo.FN_CAP_FIRST(A.DESCRICAO) AS DESCRICAO,
		dbo.FN_CAP_FIRST(A.DESCRICAO_REDUZIDA) AS DESCRICAO_REDUZIDA,
		COALESCE(dbo.FN_CAP_FIRST(B.DESCRICAO), 'Não informado') AS FAMILIA_PRODUTO,
		COALESCE(dbo.FN_CAP_FIRST(C.DESCRICAO), 'Não informado') AS SECAO_PRODUTO,
		COALESCE(dbo.FN_CAP_FIRST(D.DESCRICAO), 'Não informado') AS GRUPO_PRODUTO,
		COALESCE(dbo.FN_CAP_FIRST(E.DESCRICAO), 'Não informado') AS SUBGRUPO_PRODUTO,
		COALESCE(dbo.FN_CAP_FIRST(F.DESCRICAO), 'Não informado') AS MARCA
	FROM ZenixST.dbo.STdProdutos A
	LEFT JOIN ZenixST.dbo.STdFamiliasProdutos B ON A.COD_FAMILIA = B.COD_FAMILIA
	LEFT JOIN ZenixST.dbo.STdSecoesProdutos C ON A.COD_SECAO = C.COD_SECAO
	LEFT JOIN ZenixST.dbo.STdGruposProdutos D ON A.COD_GRUPO = D.COD_GRUPO
	LEFT JOIN ZenixST.dbo.STdSubgruposProdutos E ON A.COD_SUBGRUPO = E.COD_SUBGRUPO
	LEFT JOIN ZenixST.dbo.STdMarcas F ON A.COD_MARCA = F.COD_MARCA;
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -------------';
--------------------------------------------------------------------------------------------------------

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: ODSdVendedores';
	TRUNCATE TABLE ODSdVendedores;

	PRINT '>> Inserting Data Into: ODSdVendedores';
	INSERT INTO ODSdVendedores

	SELECT 
		0 AS COD_VENDEDOR,
		'Não informado' AS NOME

	UNION ALL

	SELECT 
		COD_VENDEDOR,
		dbo.FN_CAP_FIRST(NOME) AS VENDEDOR
	FROM ZenixST.dbo.STdVendedores;
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -------------';
--------------------------------------------------------------------------------------------------------

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: ODSfVendas';
	TRUNCATE TABLE ODSfVendas;
	
	PRINT '>> Inserting Data Into: ODSfVendas';
	INSERT INTO ODSfVendas

	SELECT 
		COALESCE(No_DOC, 0) AS No_DOC,
		COALESCE(COD_EMPRESA, 0) AS COD_EMPRESA,
		MOVIMENTO,
		YEAR(MOVIMENTO) * 100 + MONTH(MOVIMENTO) AS COD_COTACAO,
		COALESCE(COD_PRODUTO, 0) AS COD_PRODUTO,
		COALESCE(COD_VENDEDOR, 0) AS COD_VENDEDOR,
		COALESCE(COD_CLIENTE, 0) AS COD_CLIENTE,
		QUANTIDADE,
		VENDA_BRUTA,
		DESCONTO,
		VENDA_LIQUIDA,
		IMPOSTOS
	FROM ZenixST.dbo.STfVendas;
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -------------';
--------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: ODSfcotacoes';
		TRUNCATE TABLE ODSfcotacoes

		PRINT '>> Inserting Data Into: ODSfcotacoes';
		INSERT INTO ODSfcotacoes(
			dataCotacao,
			AnoMes,
			cotacaoMediaMes,
			cotacaoInicioMes,
			cotacoaFimMes,
			cotacaoMediaAno,
			cotacaoInicioAno,
			cotacoaFimAno
			
		)

		SELECT 
			CONCAT('01-', RIGHT(B.AnoMes, 2), '-', C.Ano) AS [data],
			B.AnoMes,
			B.cotacaoMediaMes,
			B.cotacaoInicioMes,
			B.cotacoaFimMes,
			C.cotacaoMediaAno,
			C.cotacaoInicioAno,
			C.cotacoaFimAno
		FROM
			(SELECT DISTINCT 
				YEAR(CAST(dataHoraCotacao AS DATE)) as Ano,
				YEAR(CAST(dataHoraCotacao AS DATE)) *100 +
				MONTH(CAST(dataHoraCotacao AS DATE)) AS AnoMes	
			FROM ZenixST.dbo.STfcotacoes
			) A 

		LEFT JOIN

			(SELECT 
				YEAR(CAST(dataHoraCotacao AS DATE)) *100 +
				MONTH(CAST(dataHoraCotacao AS DATE)) AS AnoMes,
				AVG(CAST(cotacaoCompra AS MONEY)) AS cotacaoMediaMes,
				MIN(CAST(cotacaoCompra AS MONEY)) AS cotacaoInicioMes,
				MAX(CAST(cotacaoCompra AS MONEY)) AS cotacoaFimMes
	
			FROM ZenixST.dbo.STfcotacoes
				GROUP BY 
					YEAR(CAST(dataHoraCotacao AS DATE)) * 100 +
					MONTH(CAST(dataHoraCotacao AS DATE))
			) B 
		ON A.AnoMes = B.AnoMes

		LEFT JOIN

			(SELECT 
				YEAR(CAST(dataHoraCotacao AS DATE)) AS Ano,
				AVG(CAST(cotacaoCompra AS MONEY)) AS cotacaoMediaAno,
				MIN(CAST(cotacaoCompra AS MONEY)) AS cotacaoInicioAno,
				MAX(CAST(cotacaoCompra AS MONEY)) AS cotacoaFimAno
				FROM 
					ZenixST.dbo.STfcotacoes
				GROUP BY 
					YEAR(CAST(dataHoraCotacao AS DATE))
			) C 
		ON A.Ano = C.Ano;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

-----------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: ODSdCalender';
		TRUNCATE TABLE ODSdCalender;

		PRINT '>> Inserting Data Into: ODSdCalender';
		INSERT INTO ODSdCalender

		SELECT 
			A.*, 
			COALESCE(B.NOME, 'None') AS isholiday
		FROM
			dbo.FN_CALENDER_AUTO('2019-01-01', '2022-11-01', 1, 7) A
		LEFT JOIN
			ZenixST.DBO.STdFeriados_Brasil B
		ON A.[date] = B.[DATA];
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

-----------------------------------------------------------------------------------------------------------------

	SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Operationa Data Stored is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING OPERATINAL DATA STORED'
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH;

END;
GO