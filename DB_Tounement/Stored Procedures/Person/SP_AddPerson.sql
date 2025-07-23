CREATE PROCEDURE [dbo].[AddPerson]
	@Pseudo NVARCHAR(100),
	@Gender INT,
	@Email NVARCHAR(300),
	@Password NVARCHAR(1000),
	@BirthDate DATETIME,
	@Role INT,
	@Elo INT,
	@Id_Person INT OUTPUT
AS
BEGIN
	DECLARE 
		@CleanedValuePseudonym NVARCHAR(100) = LOWER(TRIM(@Pseudo)),
		@CleanedValueEmail NVARCHAR(300) = LOWER(TRIM(@Email)),
		@CleanedValuePassword NVARCHAR(1000) = TRIM(@Password),
		@DateRegist DATETIME = GETDATE(),
		@conflictPseudo BIT,
		@conflictEmail BIT;

	-- Vérifier si le pseudo existe déjà
	EXEC @conflictPseudo = CheckPersonPseudoExist @CleanedValuePseudonym;
	IF @conflictPseudo = 1
	BEGIN
		RAISERROR ('Erreur : Un utilisateur avec ce pseudo existe déjà.', 16, 1);
		RETURN;
	END

	-- Vérifier si l'email existe déjà
	EXEC @conflictEmail = CheckPersonEmailExist @CleanedValueEmail;
	IF @conflictEmail = 1
	BEGIN
		RAISERROR ('Erreur : Un utilisateur avec cet email existe déjà.', 16, 1);
		RETURN;
	END

	-- insertion sécurisée
	BEGIN TRY
		-- Insertion de la nouvelle personne
		INSERT INTO [dbo].[Person] ([Pseudo],[Gender],[Mail],[BirthDate],[DateRegist],[Password],[Role],[Elo])
		VALUES (@CleanedValuePseudonym, @Gender, @CleanedValueEmail, @BirthDate, @DateRegist, @CleanedValuePassword, @Role, @Elo);

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