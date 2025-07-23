CREATE PROCEDURE [dbo].[UpdatePerson]
	@Id_Person INT,
	@Elo INT,
	@NbrPartPlayed INT,
	@NbrPartWin INT,
	@NbrPartLost INT,
	@NbrPartDraw INT,
	@Score INT
AS
BEGIN
	DECLARE 
		@CurrentElo INT,
		@CurrentNbrPartPlayed INT,
		@CurrentNbrPartWin INT,
		@CurrentNbrPartLost INT,
		@CurrentNbrPartDraw INT,
		@CurrentScore INT;

	-- Récupérer les valeurs actuelles
	SELECT 
		@CurrentElo = [Elo],
		@CurrentNbrPartPlayed = [NbrPartPlayed],
		@CurrentNbrPartWin = [NbrPartWin],
		@CurrentNbrPartLost = [NbrPartLost],
		@CurrentNbrPartDraw = [NbrPartDraw],
		@CurrentScore = [Score]
	FROM [dbo].[Person]
	WHERE [Id_Person] = @Id_Person;

	-- Vérifier si les nouvelles valeurs sont différentes
	IF @CurrentElo = @Elo AND 
	   @CurrentNbrPartPlayed = @NbrPartPlayed AND 
	   @CurrentNbrPartWin = @NbrPartWin AND 
	   @CurrentNbrPartLost = @NbrPartLost AND 
	   @CurrentNbrPartDraw = @NbrPartDraw AND 
	   @CurrentScore = @Score
	BEGIN
		RAISERROR ('Aucune modification à apporter : les valeurs sont identiques.', 16, 1);
		RETURN;
	END

	-- Mise à jour
	BEGIN TRY
		UPDATE [dbo].[Person]
		SET [Elo] = @Elo,
			[NbrPartPlayed] = @NbrPartPlayed,
			[NbrPartWin] = @NbrPartWin,
			[NbrPartLost] = @NbrPartLost,
			[NbrPartDraw] = @NbrPartDraw,
			[Score] = @Score
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