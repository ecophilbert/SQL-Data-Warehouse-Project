USE ZenixST
GO
/*
======================================================================================
Proposta: 
Executar uma chamada "HTTP GET" em uma "URL",
recuperar o resultado em formato JSON e armazenar em uma variável do SQL Server.

Exemplo de uso:
	 SELECT * FROM dbo.FN_EXTRACT_API_BCB('2019-01-01', '2020-12-31')
========================================================================================
*/
CREATE OR ALTER FUNCTION FN_EXTRACT_API_BCB(@startdate DATE, @enddate DATE)
RETURNS
--@cotacao_dolar TABLE ( cotacaoCompra VARCHAR(10) , cotacaoVenda Varchar(10), dataHoraCotacao Varchar(100) )
@ResponseAPI TABLE ( cotacaoCompra VARCHAR(10) , cotacaoVenda Varchar(10), dataHoraCotacao Varchar(100) )
AS
BEGIN


DECLARE @Obj Int, @Url Varchar(4000), @ResponseText VARCHAR(4000);

--Declare @ResponseAPI TABLE ( cotacaoCompra VARCHAR(10) , cotacaoVenda Varchar(10), dataHoraCotacao Varchar(100) );

DECLARE @top TINYINT = 22
DECLARE @dataInicial DATE = @startdate --'01-01-2019'
DECLARE @dataFinalCotacao DATE = DATEADD(DAY, @top + 8, @dataInicial)
DECLARE @dateMax DATE =  @enddate --'31-12-2020'
DECLARE @skip INT --= DATEDIFF(DAY, @dataInicial, @dateMax)
DECLARE @titulo VARCHAR(50) ='CotacaoDolarPeriodo'
DECLARE @select CHAR(42)= ('cotacaoCompra,cotacaoVenda,dataHoraCotacao')

-- Recebe a resposta em partes menores e insere na tabela temporária
WHILE 1=1
BEGIN
	SET @skip = DATEDIFF(DAY, @dataFinalCotacao, @dateMax)
	SET @Url = CONCAT('https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/', 
	@titulo,'(','dataInicial=''', FORMAT(@dataInicial, 'MM-dd-yyy'), ''',','dataFinalCotacao=''', FORMAT(@dataFinalCotacao, 'MM-dd-yyy'),''')?',
	'&$top=', @top, '&$format=json', '&$select=', @select)

-- Cria o objeto de automação HTTP
	EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Obj OUTPUT;

-- Configura a chamada HTTP (neste exemplo, uma requisição GET)
	EXEC sp_OAMethod @Obj, 'open', NULL, 'GET', @Url, 'false';

-- Envia a requisição
	EXEC sp_OAMethod @Obj, 'send';
	
	EXEC sp_OAMethod @Obj, 'responseText', @ResponseText OUTPUT;

	DECLARE @i TINYINT = 0, @nrows TINYINT

	SET @nrows = ( SELECT COUNt([value])
				   FROM OPENJSON(
						(SELECT [value] 
							FROM OPENJSON(@ResponseText) Rjson
							WHERE [key] = 'value')) N1
				)

    -- Insere a parte da resposta na tabela temporária
	
	WHILE @i <= @nrows - 1 
	
	BEGIN
		WITH DATAS AS(
			select [key], [value] from openjson((
				select [value] from openjson((
					SELECT [value] FROM OPENJSON(@ResponseText) Responsejson
				Where [key] = 'value')) Nivel1
			where [key] = @i )) Nivel2
		)
		
		INSERT INTO @ResponseAPI
		
		SELECT
			COALESCE(MAX([cotacaoCompra]), MAX([cotacaoCompra])),
			COALESCE(MAX([cotacaoVenda]),  MAX([cotacaoVenda])),
			COALESCE(MAX([dataHoraCotacao]), MAX([dataHoraCotacao]))
		FROM
			(SELECT * FROM DATAS) AS O
		PIVOT
			( MAX([value]) FOR [key] IN ([cotacaoCompra],[cotacaoVenda],[dataHoraCotacao])) D;

		SET @i = @i +1

	END

-- Verifica se a resposta foi totalmente recebida

	IF @dataFinalCotacao >= @dateMax
        BREAK;

	SET @dataInicial = DATEADD(DAY, 1,  @dataFinalCotacao)

-- Verifica se a resposta foi totalmente recebida
	IF @skip >= @top + 8
		SET @dataFinalCotacao = DATEADD(DAY, @top + 8 ,@dataFinalCotacao)
	ELSE
		SET @dataFinalCotacao = DATEADD(DAY, @skip, @dataFinalCotacao)

-- Libera o objeto de automação
EXEC sp_OADestroy @Obj;
END
	RETURN
END
--SELECT * FROM dbo.FN_EXTRACT_API_BCB('2019-01-01', '2020-12-31')
--SELECT DISTINCT  count([dataHoraCotacao]) FROM @ResponseAPI where [cotacaoCompra] is not null