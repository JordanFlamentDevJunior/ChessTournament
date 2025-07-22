CREATE PROCEDURE [dbo].[DeleteStatus]
	@Id_Status INT
AS
BEGIN
	-- Vérifier si le status existe
	IF NOT EXISTS (
		SELECT 1 FROM [dbo].[Status] 
		WHERE [Id_Status] = @Id_Status
		)
	BEGIN
		RAISERROR ('Erreur : Status non trouvé.', 16, 1);
		RETURN;
	END

	-- Supprimer le status
	BEGIN TRY
		DELETE FROM [dbo].[Status]
		WHERE [Id_Status] = @Id_Status;
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