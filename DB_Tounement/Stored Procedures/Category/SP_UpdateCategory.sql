CREATE PROCEDURE [dbo].[UpdateCategory]
    @Id_Category INT,
    @MinAge INT,
    @MaxAge INT
AS
BEGIN
    DECLARE 
    @CurrentMinAge INT, 
    @CurrentMaxAge INT,
    @conflictAge BIT;

    -- Récupérer les valeurs actuelles
    SELECT 
        @CurrentMinAge = [MinAge],
        @CurrentMaxAge = [MaxAge]
    FROM [dbo].[Category]
    WHERE [Id_Category] = @Id_Category;

    -- Vérifier si les nouvelles valeurs sont différentes
    IF @CurrentMinAge = @MinAge AND @CurrentMaxAge = @MaxAge
    BEGIN
        RAISERROR ('Aucune modification à apporter : les valeurs sont identiques.', 16, 1);
        RETURN;
    END

    -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC @conflictAge = CheckCategoryAgeExists  @Id_Category, @MinAge, @MaxAge;
    IF @conflictAge = 1
    BEGIN
        RAISERROR ('Erreur : Tranche d’âge déjà utilisée par une autre catégorie.', 16, 1);
        RETURN;
    END

    -- Mise à jour
    BEGIN TRY
        UPDATE [dbo].[Category]
        SET [MinAge] = @MinAge,
            [MaxAge] = @MaxAge
        WHERE [Id_Category] = @Id_Category;
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