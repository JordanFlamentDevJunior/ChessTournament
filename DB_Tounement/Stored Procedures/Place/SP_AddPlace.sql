CREATE PROCEDURE [dbo].[AddPlace]
	@Name_Place NVARCHAR(100),
	@Address NVARCHAR(500),
	@Id_Place INT OUTPUT
AS
BEGIN
	DECLARE 
		@CleanedValueName NVARCHAR(100) = LOWER(TRIM(@Name_Place)),
		@CleanedValueAddress NVARCHAR(500) = LOWER(TRIM(@Address)),
		@conflictName BIT,
		@conflictAddress BIT;

	SET @Id_Place = (SELECT ISNULL(MAX([Id_Place]), 0) + 1 FROM [dbo].[Place]);

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

	-- Insertion sécurisée
	BEGIN TRY
		INSERT INTO [dbo].[Place] ([Id_Place], [Name_Place], [Address])
		VALUES (@Id_Place, @CleanedValueName, @CleanedValueAddress);

		SELECT @Id_Place AS Id_Place;
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