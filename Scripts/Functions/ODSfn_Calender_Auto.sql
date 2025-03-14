USE ZenixODS;
GO

CREATE OR ALTER FUNCTION FN_CALENDER_AUTO(
							@start_date DATE,
							@end_date DATE,
							@closed_year BIT,
							@start_fiscal_year TINYINT
						)


RETURNS @calender TABLE(
	  [date] DATE PRIMARY KEY
	, [year] INT
	, [start_of_year] DATE
	, [end_of_year] DATE
	, [month] TINYINT
	, [star_of_month] DATE
	, [end_of_month] DATE
	, [day_in_month] TINYINT
	, [year_month_number] INT
	, [year_month_name] VARCHAR(8)
	, [day] TINYINT
	, [day_name] VARCHAR(15)
	, [day_name_short] CHAR(3)
	, [day_of_week] TINYINT
	, [day_of_year] SMALLINT
	, [month_name] VARCHAR(15)
	, [month_name_short] CHAR(3)
	, [quarter] TINYINT
	, [quarter_name] CHAR(2)
	, [year_quarter_number] INT
	, [year_quarter_name] VARCHAR(7)
	, [start_of_quarter] DATE
	, [end_of_quarter] DATE
	, [week_of_year] TINYINT 
	, [star_of_week] DATE
	, [end_of_week] DATE
	, [fiscal_year] INT
	, [fiscal_quarter] TINYINT
	, [fiscal_month] TINYINT
	, [day_offset] INT
	, [month_offset] INT
	, [quarter_offset] INT
	, [year_offset] INT
)
AS

BEGIN
--DECLARE @start_date DATE = '2019-01-01'
--DECLARE @end_date DATE = '2022-11-01'
--DECLARE @closed_year BIT = 1
--DECLARE @start_fiscal_year TINYINT = 7
DECLARE @duration INT
DECLARE @i INT = 1

	--PRINT DATEDIFF(DAY, @start_date, @end_date) +1
DECLARE @today DATE = CAST(GETDATE() AS DATE)

DECLARE @date_list TABLE([date] DATE)

DECLARE @first_day DATE
DECLARE @last_day DATE

SET @first_day = CAST(CONCAT(YEAR(@start_date), '-01-01') AS DATE)
SET @last_day = CASE WHEN @closed_year = 1 THEN CAST(CONCAT(YEAR(@end_date), '-12-31') AS DATE) ELSE @end_date END


SET @duration = DATEDIFF(DAY, @first_day, @last_day) + 1

	WHILE @i <= @duration
	BEGIN
		INSERT INTO @date_list([date])

		SELECT DATEADD(DAY, @i -1, @start_date) AS [date]

		
		SET @i = @i + 1
	END

INSERT INTO @calender

SELECT A.[date]                                                                     AS [date]
     , DATEPART( yy , A.[date] )                                                    AS [year]
     , DATEFROMPARTS( YEAR( A.[date] ) , 1 , 1 )                                    AS [start_of_year]
     , DATEFROMPARTS( YEAR( A.[date] ) , 12 , 31 )                                  AS [end_of_year]
	 , DATEPART( mm , A.[date] )                                                    AS [month]
	 , DATEFROMPARTS( YEAR( A.[date] ) , MONTH( A.[date] ) , 1 )                    AS [star_of_month]
	 , EOMONTH( A.[date] )                                                          AS [end_of_month]
	 , DATEPART( dd , EOMONTH( A.[date] ) )                                         AS [day_in_month]

     , CONCAT( 
			YEAR( A.[date] ) , 
			CONCAT(
				REPLICATE( '0' , 2 - LEN( MONTH( A.[date] ) ) ) ,
				MONTH( A.[date] )
			)
	   )                                                                            AS [year_month_number]
	 
	 , CONCAT( 
			DATEPART( yy , A.[date] ) , 
			'-' ,  
			LOWER( LEFT( DATENAME( mm , A.[date] ) , 3 ) )  )                       AS [year_month_name]
	 
	 
	 , DATEPART( dd , A.[date] )                                                    AS [day]
	 , LOWER( DATENAME( dw , A.[date] ) )                                           AS [day_name]
	 , LOWER( LEFT( DATENAME( dw , A.[date] ) , 3 ) )                               AS [day_name_short]
	 , DATEPART( [weekday] , A.[date] )                                             AS [day_of_week]
	 , DATEPART( dy , A.[date] )                                                    AS [day_of_year]
	 , LOWER( DATENAME( mm , A.[date] ) )                                           AS [month_name]
	 , LOWER( LEFT( DATENAME( mm , A.[date] ) , 3 ) )                               AS [month_name_short]
	 , DATEPART( qq , A.[date] )                                                    AS [quarter]
	 , CONCAT( 'Q' , DATEPART( qq , A.[date] ) )                                    AS [quarter_name]
	 , CONCAT( DATEPART( yy , A.[date] ) , DATEPART( qq , A.[date] ) )              AS [year_quarter_number]
	 , CONCAT( DATEPART( yy , A.[date] ) , ' Q' , DATEPART( qq , A.[date] ) )       AS [year_quarter_name]
	 , DATEFROMPARTS( YEAR( A.[date] ), (DATEPART( qq , A.[date] )*3)-2, 1)         AS [start_of_quarter]
	 , EOMONTH( DATEFROMPARTS( YEAR( A.[date] ), (DATEPART( qq , A.[date] ))*3, 1),0) AS [end_of_quarter]
	 , DATEPART( wk , A.[date] )                                                    AS [week_of_year]
	 , DATEADD( DAY , - ( DATEPART( [weekday] , A.[date] ) - 1 ) , A.[date] )       AS [star_of_week]
	 , DATEADD( DAY , 7 - DATEPART( [weekday] , A.[date] ) , A.[date] )             AS [end_of_week]
	 
	 , CASE @start_fiscal_year
	        WHEN 1 
			THEN YEAR( A.[date] ) 
			ELSE YEAR( A.[date] ) + CAST( ( MONTH( A.[date] ) + ( 13 - @start_fiscal_year ) ) / 13 AS INT ) 
	   END                                                                          AS [fiscal_year]

     , DATEPART( 
			qq , 
			DATEFROMPARTS( 
				YEAR( A.[date] ) , 
				( ( MONTH( A.[date] ) + (13 - @start_fiscal_year) - 1 ) % 12 ) + 1 , 
				1 
			) 
		)                                                                           AS [fiscal_quarter]

	 
	 , ( ( MONTH( A.[date] ) + (13 - @start_fiscal_year) - 1 ) % 12 ) + 1           AS [fiscal_month]
	 , DATEDIFF( DAY     , @today , A.[date] )                                       AS [day_offset]
     , DATEDIFF( MONTH   , @today , A.[date] )                                       AS [month_offset]
	 , DATEDIFF( QUARTER , @today , A.[date] )                                       AS [quarter_offset]
	 , DATEDIFF( YEAR    , @today , A.[date] )                                       AS [year_offset]


  FROM @date_list                A --WITH(NOLOCK)
 ORDER
    BY 1

	RETURN
END
--ALTER TABLE @date_list
--ADD COLUMN(PPP CHAR(1))

--SELECT 
--A.*, COALESCE(B.NOME, 'None') AS isholiday
--FROM
--	dbo.FN_CALENDER_AUTO('2019-01-01', '2022-11-01', 1, 7) A
--LEFT JOIN
--ZenixST.DBO.STdFeriados_Brasil B
--ON A.date = B.DATA
--	DROP FUNCTION dbo.FN_CALENDER_AUTO