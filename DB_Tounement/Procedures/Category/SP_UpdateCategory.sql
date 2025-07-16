CREATE PROCEDURE UpdateCategory
    @Id_Category TINYINT,
    @Name_Category NCHAR(7),
    @MinAge TINYINT,
    @MaxAge TINYINT
AS
BEGIN
    DECLARE @CurrentName NCHAR(7), @CurrentMinAge TINYINT, @CurrentMaxAge TINYINT;

    -- Récupérer les valeurs actuelles
    SELECT 
        @CurrentName = [Name_Category],
        @CurrentMinAge = [MinAge],
        @CurrentMaxAge = [MaxAge]
    FROM [dbo].[Category]
    WHERE [Id_Category] = @Id_Category;

    -- Vérifier si la catégorie existe
    IF @CurrentName IS NULL
    BEGIN
        PRINT 'Erreur : Aucune catégorie trouvée avec cet ID.';
        RETURN;
    END

    -- Vérifier si les nouvelles valeurs sont différentes
    IF @CurrentName = @Name_Category AND @CurrentMinAge = @MinAge AND @CurrentMaxAge = @MaxAge
    BEGIN
        PRINT 'Aucune modification à apporter : les valeurs sont identiques.';
        RETURN;
    END

    -- Vérification que le nom n’est pas utilisé par une autre catégorie
    EXEC CheckCatNameExists @Id_Category, @Name_Category;

    -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC CheckCategoryAgeExists  @Id_Category, @MinAge, @MaxAge;


    -- Mise à jour
    BEGIN TRY
        UPDATE [dbo].[Category]
        SET [Name_Category] = @Name_Category,
            [MinAge] = @MinAge,
            [MaxAge] = @MaxAge
        WHERE [Id_Category] = @Id_Category;

        PRINT 'Catégorie mise à jour avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;