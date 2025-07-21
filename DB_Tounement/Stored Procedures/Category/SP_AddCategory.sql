CREATE PROCEDURE AddCategory
    @Name_Category NCHAR(7) NOT NULL,
    @MinAge TINYINT NOT NULL,
    @MaxAge TINYINT NOT NULL
AS
BEGIN
    DECLARE 
    @Id_Category TINYINT NOT NULL,
    @CleanedValueName NCHAR(7) NOT NULL = LOWER(TRIM(@Name_Category)),
    @conflictName BIT NOT NULL,
    @conflictAge BIT NOT NULL;

    -- Vérifier le nombre total de catégories existantes
    IF (SELECT COUNT(*) FROM [dbo].[Category]) > 3
    BEGIN
        SELECT 255 AS Id_Category, 'Erreur : Limite de 3 catégories atteinte.' AS ErrorMessage;
        RETURN;
    END
        
    -- Définir l'ID selon le nom
    SET @Id_Category = 
        CASE @CleanedValueName
            WHEN N'junior' THEN 0
            WHEN N'senior' THEN 1
            WHEN N'veteran' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    -- s'assurer que l'ID est valide
    IF @Id_Category NOT BETWEEN 0 AND 2
    BEGIN
        SELECT 255 AS Id_Category, 'Erreur : Nom de catégorie non reconnu.' AS ErrorMessage;
        RETURN;
    END


    -- Vérifier si le nom de catégorie existe déjà
    EXEC @conflictName = CheckCatNameExists @Id_Category, @CleanedValueName;
    IF @conflictName = 1
    BEGIN
        SELECT 255 AS Id_Category, 'Erreur : Une catégorie avec cet ID ou ce nom existe déjà.' AS ErrorMessage;
        RETURN;
    END

        -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC @conflictAge = CheckCategoryAgeExists @Id_Category, @MinAge, @MaxAge;
    IF @conflictAge = 1
    BEGIN
        SELECT 255 AS Id_Category, 'Erreur : Tranche d’âge déjà utilisée par une autre catégorie.' AS ErrorMessage;
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
        -- Retourne l'ID 255 en cas d'erreur + message d'erreur
        SELECT 255 AS Id_Category, 'Erreur : ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;