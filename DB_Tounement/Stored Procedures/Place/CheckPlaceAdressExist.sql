CREATE PROCEDURE [dbo].[CheckPlaceAddressExist]
	@Id_Place INT,
	@Address NVARCHAR(500)
AS
BEGIN
	IF EXISTS (
		SELECT 1 
		FROM [dbo].[Place]
		WHERE [Address] = @Address
		AND [Id_Place] <> @Id_Place
	)
	BEGIN
		RETURN 1; -- Addresse de lieu existe déjà
	END
	RETURN 0; -- Addresse de lieu n'existe pas
END;
