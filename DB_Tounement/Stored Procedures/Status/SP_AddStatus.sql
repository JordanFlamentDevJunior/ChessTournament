CREATE PROCEDURE AddStatus
    @ValueStatus NVARCHAR(21)
AS
BEGIN
    DECLARE 
        @Id_Status TINYINT,
        @CleanedValueName NCHAR(21) = LOWER(TRIM(@ValueStatus));

    -- 1. Déterminer l’ID
    SET @Id_Status =
        CASE @CleanedValueName
            WHEN N'en attente de joueurs' THEN 0
            WHEN N'en cours'               THEN 1
            WHEN N'terminé'               THEN 2
            WHEN N'annulé'                THEN 3
            ELSE -1
        END;

    -- 2. Si nom non reconnu, renvoyer 255 et sortir
    IF @Id_Status = -1
    BEGIN
        SELECT 255 AS Id_Status;
        RETURN;       -- quitte la proc après le SELECT
    END

     -- Vérifier le nombre total de catégories existantes
    IF (SELECT COUNT(*) FROM [dbo].[Status]) > 4
    BEGIN
        PRINT 'Erreur : Limite de 4 status atteinte.';
        RETURN;
    END

    -- 3. Si déjà existant, renvoyer 255 et sortir

    EXEC CheckStatNameExists @Id_Status, @CleanedValueName;

    -- 4. Insertion
    BEGIN TRY
        INSERT INTO [dbo].[Status] ([Id_Status], [Value_Status])
        VALUES (@Id_Status, @CleanedValueName);

        -- 5. Après insertion, renvoyer l’ID réel
        SELECT @Id_Status AS Id_Status;
    END TRY
    BEGIN CATCH
        -- En cas d’erreur SQL, renvoyer 255
        SELECT 255 AS Id_Status;
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;