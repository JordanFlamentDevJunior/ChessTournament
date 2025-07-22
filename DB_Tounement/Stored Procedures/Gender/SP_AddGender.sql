CREATE PROCEDURE [dbo].[AddGender]
    @Name_Gender NCHAR(5),
    @Id_Gender INT OUTPUT
AS
BEGIN
    DECLARE 
        @CleanedValueName NCHAR(7) = LOWER(TRIM(@Name_Gender)),
        @conflictName BIT

    -- Définir l'ID selon le nom
    SET @Id_Gender = 
        CASE @CleanedValueName
            WHEN N'femme' THEN 0
            WHEN N'homme' THEN 1
            WHEN N'autre' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    -- s'assurer que l'ID est valide
    IF @Id_Gender = -1
    BEGIN
        RAISERROR ('Erreur : Nom du genre non reconnu.', 16, 1);
        RETURN;
    END


    -- Vérifier si le nom de catégorie existe déjà
    EXEC @conflictName = CheckGenNameExists @Id_Gender, @CleanedValueName;
    IF @conflictName = 1
    BEGIN
        RAISERROR ('Erreur : Un genre avec cet ID ou ce nom existe déjà.', 16, 1);
        RETURN;
    END

    -- Insertion sécurisée
    BEGIN TRY
        -- Insertion de la nouvelle catégorie
        INSERT INTO [dbo].[Gender] ([Id_Gender], [ValueGender])
        VALUES (@Id_Gender, @CleanedValueName);

        -- Retourner l'ID de la catégorie insérée
        SELECT @Id_Gender AS Id_Gender;
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