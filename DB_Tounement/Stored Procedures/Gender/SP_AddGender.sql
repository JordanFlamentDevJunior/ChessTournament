CREATE PROCEDURE AddGender
    @ValueGender NCHAR(6)
AS
BEGIN
    DECLARE 
        @Id_Gender TINYINT,
        @CleanedValueName NCHAR(6) = LOWER(TRIM(@ValueGender));

    -- Définir l'ID selon le nom
    SET @Id_Gender = 
        CASE @CleanedValueName
            WHEN N'femme' THEN 0
            WHEN N'homme' THEN 1
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    IF @Id_Gender = -1
    BEGIN
        SELECT 255 AS Id_Gender;
        PRINT 'Erreur : Nom de genre non reconnu.';
        RETURN;
    END

    -- Vérifier le nombre total de catégories existantes
    IF (SELECT COUNT(*) FROM [dbo].[Gender]) > 2
    BEGIN
        PRINT 'Erreur : Limite de 2 genre atteinte.';
        RETURN;
    END

    -- Vérifier si le nom de catégorie existe déjà
    EXEC CheckGenNameExists @Id_Gender, @CleanedValueName;

    -- Insertion sécurisée
    BEGIN TRY
        INSERT INTO [dbo].[Gender] ([Id_Gender], [ValueGender])
        VALUES (@Id_Gender, @CleanedValueName);

        SELECT @Id_Gender AS Id_Gender;
    END TRY
    BEGIN CATCH
        SELECT 255 AS Id_Status;
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;