CREATE PROCEDURE [dbo].[CheckStatNameExist]
	@ExistingId INT,
	@Name_Status NCHAR(8)
AS
BEGIN
	IF EXISTS (
		SELECT 1 FROM [dbo].[Status]
		WHERE [Id_Status] = @ExistingId
			OR [ValueStatus] = @Name_Status
	)
	BEGIN
		RETURN 1; -- Le nom de status existe déjà
	END
	RETURN 0; -- Le nom de status n'existe pas
END;