CREATE PROCEDURE [dbo].[AddStatus]
	@Name_Status NCHAR(8),
	@Id_Status INT OUTPUT
AS
BEGIN
	DECLARE 
		@CleanedValueName NCHAR(8) = LOWER(TRIM(@Name_Status)),
		@conflictName BIT

	-- Définir l'ID selon le nom
	SET @Id_Status = 
		CASE @CleanedValueName
			WHEN N'waiting' THEN 0
			WHEN N'ongoing' THEN 1
			WHEN N'finished' THEN 2
			WHEN N'canceled' THEN 3
			ELSE -1 -- Valeur invalide, déclenchera une erreur
		END;

	-- s'assurer que l'ID est valide
	IF @Id_Status = -1
	BEGIN
		RAISERROR ('Erreur : Nom de status non reconnu.', 16, 1);
		RETURN;
	END

	-- Vérifier si le nom de status existe déjà
	EXEC @conflictName = CheckStatNameExist @Id_Status, @CleanedValueName;
	IF @conflictName = 1
	BEGIN
		RAISERROR ('Erreur : Un status avec cet ID ou ce nom existe déjà.', 16, 1);
		RETURN;
	
	-- Retourner l'ID du status inséré
		SELECT @Id_Status AS Id_Status;
	END

	-- Insertion sécurisée
	BEGIN TRY
		-- Insertion du nouveau status
		INSERT INTO [dbo].[Status] ([Id_Status], [ValueStatus])
		 VALUES (@Id_Status, @CleanedValueName);
		
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