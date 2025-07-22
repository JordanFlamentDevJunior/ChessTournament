CREATE PROCEDURE [dbo].[AddCategory]
    @Name_Category NCHAR(7),
    @MinAge INT,
    @MaxAge INT,
    @Id_Category INT OUTPUT
AS
BEGIN
    DECLARE 
        @CleanedValueName NCHAR(7) = LOWER(TRIM(@Name_Category)),
        @conflictName BIT,
        @conflictAge BIT;

    -- Définir l'ID selon le nom
    SET @Id_Category = 
        CASE @CleanedValueName
            WHEN N'junior' THEN 0
            WHEN N'senior' THEN 1
            WHEN N'veteran' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    -- s'assurer que l'ID est valide
    IF @Id_Category = -1
    BEGIN
        RAISERROR ('Erreur : Nom de catégorie non reconnu.', 16, 1);
        RETURN;
    END


    -- Vérifier si le nom de catégorie existe déjà
    EXEC @conflictName = CheckCatNameExists @Id_Category, @CleanedValueName;
    IF @conflictName = 1
    BEGIN
        RAISERROR ('Erreur : Une catégorie avec cet ID ou ce nom existe déjà.', 16, 1);
        RETURN;
    END

        -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC @conflictAge = CheckCategoryAgeExists @Id_Category, @MinAge, @MaxAge;
    IF @conflictAge = 1
    BEGIN
        RAISERROR ('Erreur : Tranche d’âge déjà utilisée par une autre catégorie.', 16, 1);
        RETURN;
    END

    -- Insertion sécurisée
    BEGIN TRY
        -- Insertion de la nouvelle catégorie
        INSERT INTO [dbo].[Category] ([Id_Category], [Name_Category], [MinAge], [MaxAge])
        VALUES (@Id_Category, @CleanedValueName, @MinAge, @MaxAge);

        -- Retourner l'ID de la catégorie insérée
        SELECT @Id_Category AS Id_Category;
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
    END CATCH;
END;