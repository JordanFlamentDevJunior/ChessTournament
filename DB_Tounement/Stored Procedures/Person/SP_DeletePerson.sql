CREATE PROCEDURE [dbo].[DeletePerson]
	@Id_Person INT
AS
BEGIN
	-- Vérifier si la personne existe
	IF NOT EXISTS (
		SELECT 1 FROM [dbo].[Person] 
		WHERE [Id_Person] = @Id_Person
		)
	BEGIN
		RAISERROR ('Erreur : La personne avec l''ID %d n''existe pas.', 16, 1, @Id_Person);
		RETURN;
	END

	-- Suppression sécurisée
	BEGIN TRY
		DELETE FROM [dbo].[Person]
		WHERE [Id_Person] = @Id_Person;		
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