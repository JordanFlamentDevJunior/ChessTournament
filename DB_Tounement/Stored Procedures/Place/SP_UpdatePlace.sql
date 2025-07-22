CREATE PROCEDURE [dbo].[UpdatePlace]
	@Id_Place INT,
	@Name_Place NVARCHAR(100),
	@Address NVARCHAR(500)
AS
BEGIN 
	DECLARE 
	@CleanedValueName NVARCHAR(100) = LOWER(TRIM(@Name_Place)),
	@CleanedValueAddress NVARCHAR(500) = LOWER(TRIM(@Address)),
	@CurrentName NVARCHAR(100),
	@CurrentAddress NVARCHAR(500),
	@conflictName BIT,
	@conflictAddress BIT;

	SELECT
		@CurrentName = [Name_Place],
		@CurrentAddress = [Address]
	FROM [dbo].[Place]
	WHERE [Id_Place] = @Id_Place;

	-- Vérifier si une modification est nécessaire
	IF @CurrentName = @CleanedValueName AND @CurrentAddress = @CleanedValueAddress
	BEGIN
		RAISERROR ('Aucune modification à apporter : les valeurs sont identiques.', 16, 1);
		RETURN;
	END

	-- Vérifier si le nom de lieu existe déjà
	EXEC @conflictName = CheckPlaceNameExist @Id_Place, @CleanedValueName;
	IF @conflictName = 1
	BEGIN
		RAISERROR ('Erreur : Un lieu avec ce nom existe déjà.', 16, 1);
		RETURN;
	END

	-- Vérifier si l'adresse existe déjà
	EXEC @conflictAddress = CheckPlaceAddressExist @Id_Place, @CleanedValueAddress;
	IF @conflictAddress = 1
	BEGIN
		RAISERROR ('Erreur : Un lieu avec cette addresse existe déjà.', 16, 1);
		RETURN;
	END

	-- Mise à jour sécurisée
	BEGIN TRY
		UPDATE [dbo].[Place]
			SET [Name_Place] = @CleanedValueName,
				[Address] = @CleanedValueAddress
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