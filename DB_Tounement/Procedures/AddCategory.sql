CREATE PROCEDURE AddCategory
    @Name_Category NCHAR(7),
    @MinAge TINYINT,
    @MaxAge TINYINT
AS
BEGIN
    DECLARE @Id_Category TINYINT;

    -- Définir l'ID selon le nom
    SET @Id_Category = 
        CASE @Name_Category
            WHEN N'junior' THEN 0
            WHEN N'senior' THEN 1
            WHEN N'veteran' THEN 2
            ELSE 255 -- Valeur invalide, déclenchera une erreur
        END;

    IF @Id_Category = 255
    BEGIN
        PRINT 'Erreur : Nom de catégorie non reconnu.';
        RETURN;
    END

    -- Vérifier le nombre total de catégories existantes
    IF (SELECT COUNT(*) FROM [dbo].[Category]) > 3
    BEGIN
        PRINT 'Erreur : Limite de 3 catégories atteinte.';
        RETURN;
    END

    -- Vérifier si la catégorie existe déjà
    IF EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] = @Id_Category
           OR [Name_Category] = @Name_Category
    )
    BEGIN
        PRINT 'Erreur : Une catégorie avec cet ID ou ce nom existe déjà.';
        RETURN;
    END

     -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    IF EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] <> @Id_Category
            AND (
                [MinAge] = @MinAge
                OR [MaxAge] = @MaxAge
            )
    )
    BEGIN
        PRINT 'Erreur : L’âge minimum ou maximum est déjà utilisé par une autre catégorie.';
        RETURN;
    END

    -- Insertion sécurisée
    BEGIN TRY
        INSERT INTO [dbo].[Category] ([Id_Category], [Name_Category], [MinAge], [MaxAge])
        VALUES (@Id_Category, @Name_Category, @MinAge, @MaxAge);

        PRINT 'Catégorie insérée avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;