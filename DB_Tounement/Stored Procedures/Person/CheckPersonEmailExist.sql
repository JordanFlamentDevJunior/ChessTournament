CREATE PROCEDURE [dbo].[CheckPersonEmailExist]
	@mail NVARCHAR(300)
AS
BEGIN
	IF EXISTS (
		SELECT 1 
		FROM [dbo].[Person]
		WHERE [Mail] = @mail
	)
	BEGIN
		RETURN 1; -- Email existe déjà
	END
	RETURN 0; -- Email n'existe pas
END;