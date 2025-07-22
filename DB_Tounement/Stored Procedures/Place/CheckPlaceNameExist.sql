CREATE PROCEDURE [dbo].[CheckPlaceNameExist]
	@id_Place INT,
	@Name_Place NVARCHAR(100)
AS
BEGIN
	IF EXISTS (
		SELECT 1 
		FROM [dbo].[Place]
		WHERE [Name_Place] = @Name_Place
		AND [Id_Place] <> @id_Place
	)
	BEGIN
		RETURN 1; -- Nom de lieu existe déjà
	END
	return 0; -- Nom de lieu n'existe pas
END;