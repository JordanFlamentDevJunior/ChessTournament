CREATE PROCEDURE AddRole
    @ValueRole NCHAR(9)
AS
BEGIN
    DECLARE 
        @Id_Role TINYINT,
        @CleanedValueName NCHAR(9) = LOWER(TRIM(@ValueRole));

    -- Définir l'ID selon le nom
    SET @Id_Role = 
        CASE @CleanedValueName
            WHEN N'checkmate' THEN 0
            WHEN N'player' THEN 1
            WHEN N'user' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    IF @Id_Role = -1
    BEGIN
        SELECT 255 AS Id_Role;
        RETURN;
    END

    -- Vérifier le nombre total de catégories existantes
    IF (SELECT COUNT(*) FROM [dbo].[Role]) > 3
    BEGIN
        PRINT 'Erreur : Limite de 3 role atteinte.';
        RETURN;
    END

    -- Vérifier si le nom de catégorie existe déjà
    EXEC CheckRoleNameExists @Id_Role, @CleanedValueName;

    -- Insertion sécurisée
    BEGIN TRY
        INSERT INTO [dbo].[Role] ([Id_Role], [ValueRole])
        VALUES (@Id_Role, @CleanedValueName);

        -- Après insertion, renvoyer l’ID réel
        SELECT @Id_Role AS Id_Role;
    END TRY
    BEGIN CATCH
        -- En cas d’erreur SQL, renvoyer 255
        SELECT 255 AS Id_Status;
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;