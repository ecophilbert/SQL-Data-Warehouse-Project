USE ZenixODS
GO

CREATE OR ALTER FUNCTION FN_CAP_FIRST(@inputstr VARCHAR(MAX))

	RETURNS VARCHAR(MAX) AS
	BEGIN

	--DECLARE @inputstr VARCHAR(MAX) = 'je suis le meilleur'
	DECLARE @outputstr VARCHAR(MAX)
	DECLARE @i INT = 1
	DECLARE @char char(1)
	DECLARE @prev_char CHAR(1) =' '

	WHILE @i <= LEN(@inputstr)

	BEGIN
		SET @char = SUBSTRING(@inputstr, @i, 1)

		IF @prev_char IN(' ') SET @char = UPPER(@char)
		ELSE SET @char = LOWER(@char)

		SET @outputstr = CONCAT( @outputstr, @char)
		SET @prev_char = @char
		SET @i = @i + 1

	END
	RETURN @outputstr
END

--PRINT dbo.FN_CAP_FIRST('je suis le meilleur')

--DROP FUNCTION DBO.FN_CAP_FIRST
/*
Pode utilizar CASE WHEN no lugar de if.
SET @char = CASE WHEN @prev_char IN(' ') THEN UPPER(@char)
				ELSE LOWER(@char)
				END;
*/