CREATE PROCEDURE UpdateCategory
    @Id_Category TINYINT NOT NULL,
    @Name_Category NCHAR(7) NOT NULL,
    @MinAge TINYINT NOT NULL,
    @MaxAge TINYINT NOT NULL
AS
BEGIN
    DECLARE 
    @CurrentName NCHAR(7) NOT NULL, 
    @CurrentMinAge TINYINT NOT NULL, 
    @CurrentMaxAge TINYINT NOT NULL,
    @CleanedValueName NCHAR(7) NOT NULL = LOWER(TRIM(@Name_Category)),
    @ConflictName BIT NOT NULL,
    @conflictAge BIT NOT NULL ;

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
        -- Si aucune catégorie n'est trouvée, retourner un message d'erreur et 0 pour le boolean
        SELECT CAST(0 AS BIT) AS Result, 'Erreur : Aucune catégorie trouvée avec cet ID.' AS ErrorMessage;
        RETURN;
    END

    -- Vérifier si les nouvelles valeurs sont différentes
    IF @CurrentName = @CleanedValueName AND @CurrentMinAge = @MinAge AND @CurrentMaxAge = @MaxAge
    BEGIN
        SELECT CAST(0 AS BIT) AS Result, 'Aucune modification à apporter : les valeurs sont identiques.' AS ErrorMessage;
        RETURN;
    END

    -- Vérification que le nom n’est pas utilisé par une autre catégorie
    EXEC @ConflictName = CheckCatNameExists @Id_Category, @CleanedValueName;
    IF @ConflictName = 1
    BEGIN
        SELECT CAST(0 AS BIT) AS Result, 'Erreur : Une catégorie avec cet ID ou ce nom existe déjà.' AS ErrorMessage;
        RETURN;
    END

    -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC @conflictAge = CheckCategoryAgeExists  @Id_Category, @MinAge, @MaxAge;
    IF @conflictAge = 1
    BEGIN
        SELECT CAST(0 AS BIT) AS Result, 'Erreur : Tranche d’âge déjà utilisée par une autre catégorie.' AS ErrorMessage;
        RETURN;
    END

    -- Mise à jour
    BEGIN TRY
        UPDATE [dbo].[Category]
        SET [Name_Category] = @CleanedValueName,
            [MinAge] = @MinAge,
            [MaxAge] = @MaxAge
        WHERE [Id_Category] = @Id_Category;

        SELECT CAST(1 AS BIT);
    END TRY

    BEGIN CATCH
        -- En cas d'erreur, retourner 0 et le message d'erreur
        SELECT CAST(0 AS BIT) AS Result, 'Erreur lors de la mise à jour de la catégorie : ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;