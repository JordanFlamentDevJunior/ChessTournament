CREATE PROCEDURE AddGender
    @ValueGender NCHAR(5) NOT NULL
AS
BEGIN
    DECLARE 
        @Id_Gender TINYINT NOT NULL,
        @CleanedValueName NCHAR(5) NOT NULL = LOWER(TRIM(@ValueGender)),
        @conflictName BIT NOT NULL;

    -- Vérifier le nombre total de catégories existantes
    IF (SELECT COUNT(*) FROM [dbo].[Gender]) > 2
    BEGIN
        SELECT 255 AS Id_Gender, 'Erreur : Limite de 2 genre atteinte.' AS ErrorMessage;
        RETURN;
    END

    -- Définir l'ID selon le nom
    SET @Id_Gender = 
        CASE @CleanedValueName
            WHEN N'femme' THEN 0
            WHEN N'homme' THEN 1
            WHEN N'autre' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    -- s'assurer que l'ID est valide
    IF @Id_Gender NOT BETWEEN 0 AND 1
    BEGIN
        SELECT 255 AS Id_Genre, 'Erreur : Nom du genre non reconnu.' AS ErrorMessage;
        RETURN;
    END

    -- Vérifier si le nom de genre existe déjà
    EXEC @conflictName = CheckGenNameExists @Id_Gender, @CleanedValueName;
    IF @conflictName = 1
    BEGIN
        SELECT 255 AS Id_Gender, 'Erreur : Un genre avec cet ID ou ce nom existe déjà.' AS ErrorMessage;
        RETURN;
    END

    -- Insertion sécurisée
    BEGIN TRY
        INSERT INTO [dbo].[Gender] ([Id_Gender], [ValueGender])
        VALUES (@Id_Gender, @CleanedValueName);

        SELECT @Id_Gender AS Id_Gender;
    END TRY

    BEGIN CATCH
        SELECT 255 AS Id_Status, 'Erreur : ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;