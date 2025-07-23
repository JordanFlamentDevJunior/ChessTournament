CREATE PROCEDURE [dbo].[CheckPersonPseudoExist]
	@Pseudonym NVARCHAR(100)
AS
BEGIN
	IF EXISTS (
		SELECT 1 
		FROM [dbo].[Person]
		WHERE LOWER(TRIM([Pseudo])) = LOWER(TRIM(@Pseudonym))
	)
	BEGIN
		RETURN 1; -- Pseudo existe déjà
	END
	RETURN 0; -- Pseudo n'existe pas
END;