USE ZenixDW
GO

/*
=============================================================================
Stored Procedure: Load Data Warehouse (ODS -> Data Warehouse)
=============================================================================
Script do Ojebtivo:
	Este Procedure carrega para Data Warehouse
	Excuta as seguintes acções:
		Criar tabelas de Data Warehouse caso não existem.
		Drop Constraint Foreign Key.
		Truncate as tabelas de Data Warehouse antes de carregar os dados
		Utiliza comand INSERT INTO para carregar dados para Data Warehouse
		ADD Constraint Foreign Key.

Parâmetros:
	Nenhum
	Este Stored Procedure não aceita nenhum parâmetro ou retorna nenhum valor

Exemplo de uso:
	EXEC USP_LoadDW
=============================================================================
*/
CREATE OR ALTER PROCEDURE USP_LoadDW AS

BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
	BEGIN TRANSACTION;

        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Data Warehouse DB';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading ODS Tables';
		PRINT '------------------------------------------------';
		
		PRINT '>> Creating no existing tables';
		EXEC USP_CreateTableDW;

		PRINT '>> Drop Foreigns Keys: DWfVendas';
		PRINT '>> -------------';
		ALTER TABLE DWfVendas
		DROP CONSTRAINT FK_cliente_venda,
			 CONSTRAINT FK_produto_venda,
			 CONSTRAINT FK_vendedor_venda,
			 CONSTRAINT FK_empresa_venda;
-------------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: DWdClientes';
		TRUNCATE TABLE DWdClientes;

		PRINT '>> Inserting Data Into: DWdClientes';
		INSERT INTO DWdClientes

		SELECT * FROM ZenixODS.dbo.ODSdClientes;
		SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';
-------------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: DWdProdutos';
		TRUNCATE TABLE DWdProdutos

		PRINT '>> Inserting Data Into: DWdProdutos';
		INSERT INTO DWdProdutos

		SELECT * FROM ZenixODS.dbo.ODSdProdutos;
		SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';
-------------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: DWdVendedores';
		TRUNCATE TABLE DWdVendedores;

		PRINT '>> Inserting Data Into: DWdVendedores'
		INSERT INTO DWdVendedores

		SELECT * FROM ZenixODS.dbo.ODSdVendedores;
		SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';
-------------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: DWdEmpresas';
		TRUNCATE TABLE DWdEmpresas;

		PRINT '>> Inserting Data Into: DWdEmpresas';
		INSERT INTO DWdEmpresas

		SELECT * FROM ZenixODS.dbo.ODSdEmpresas;
		SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';
-------------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: DWfVendas';
		TRUNCATE TABLE DWfVendas;
	
		PRINT '>> Inserting Data Into: DWfVendas';
		INSERT INTO DWfVendas

		SELECT * FROM ZenixODS.dbo.ODSfVendas;
		SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';
-------------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: DWdCalender';
		TRUNCATE TABLE DWdCalender;
	
		PRINT '>> Inserting Data Into: DWdCalender';
		INSERT INTO DWdCalender

		SELECT * FROM ZenixODS.dbo.ODSdCalender;
		SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';

-------------------------------------------------------------------------------------------------------------------

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: DWfcotacoes';
		TRUNCATE TABLE DWfcotacoes

		PRINT '>> Inserting Data Into: DWfcotacoes';
		INSERT INTO DWfcotacoes

		SELECT * FROM ZenixODS.dbo.ODSfcotacoes;
		SET @end_time = GETDATE();
			PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '>> -------------';
-------------------------------------------------------------------------------------------------------------------

		PRINT '>> Add Constraint Foreign Key: DWfVendas'

		ALTER TABLE DWfVendas 
		ADD CONSTRAINT FK_cliente_venda FOREIGN KEY (COD_CLIENTE) REFERENCES DWdClientes(COD_CLIENTE),
			CONSTRAINT FK_produto_venda FOREIGN KEY (COD_PRODUTO) REFERENCES DWdProdutos(COD_PRODUTO),
			CONSTRAINT FK_vendedor_venda FOREIGN KEY (COD_VENDEDOR) REFERENCES DWdVendedores(COD_VENDEDOR),
			CONSTRAINT FK_empresa_venda FOREIGN KEY (COD_EMPRESA) REFERENCES DWdEmpresas(COD_EMPRESA);
----------------------------------------------------------------------------------------------------------------
			
			COMMIT;
			PRINT '------------------------------------------'
			PRINT 'Commit Transaction'
			PRINT '------------------------------------------'
		SET @batch_end_time = GETDATE();
			PRINT '=========================================='
			PRINT 'Loading Data Warehouse is Completed';
			PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
			PRINT '=========================================='
			
			
	END TRY
	BEGIN CATCH
		ROLLBACK;
		PRINT '------------------------------------------'
		PRINT 'Rollback Transaction'
		PRINT '------------------------------------------'

		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING DATA WAREHOUSE'
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
	
END;


--DROP PROCEDURE USP_LoadDW