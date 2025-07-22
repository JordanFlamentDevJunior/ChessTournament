CREATE PROCEDURE [dbo].[DeletePlace]
	@Id_Place INT
AS
BEGIN
	-- Vérifier si le lieu existe
	IF NOT EXISTS (
		SELECT 1 FROM [dbo].[Place]
		WHERE [Id_Place] = @Id_Place
	)
	BEGIN
		RAISERROR ('Erreur : Aucun lieu trouvé avec cet ID.', 16, 1);
		RETURN;
	END

	-- Suppression
	BEGIN TRY
		DELETE FROM [dbo].[Place]
		WHERE [Id_Place] = @Id_Place;
	END TRY

	BEGIN CATCH
		 DECLARE 
			@ErrorMessage NVARCHAR(4000),
			@ErrorSeverity INT,
			@ErrorState INT;
		SELECT
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();
		RAISERROR (
			@ErrorMessage, -- Message text.
			@ErrorSeverity, -- Severity.
			@ErrorState -- State.
		);
	END CATCH
END;
