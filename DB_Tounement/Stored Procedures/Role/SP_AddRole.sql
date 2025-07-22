CREATE PROCEDURE [dbo].[AddRole]
	@Name_Role NCHAR(9),
    @Id_Role INT OUTPUT
AS
BEGIN
    DECLARE 
        @CleanedValueName NCHAR(9) = LOWER(TRIM(@Name_Role)),
        @conflictName BIT

    -- Définir l'ID selon le nom
    SET @Id_Role = 
        CASE @CleanedValueName
            WHEN N'checkmate' THEN 0
            WHEN N'player' THEN 1
            WHEN N'user' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    -- s'assurer que l'ID est valide
    IF @Id_Role = -1
    BEGIN
        RAISERROR ('Erreur : Nom de role non reconnu.', 16, 1);
        RETURN;
    END


    -- Vérifier si le nom de catégorie existe déjà
    EXEC @conflictName = CheckRolNameExist @Id_Role, @CleanedValueName;
    IF @conflictName = 1
    BEGIN
        RAISERROR ('Erreur : Un role avec cet ID ou ce nom existe déjà.', 16, 1);
        RETURN;
    
    -- Retourner l'ID de la catégorie insérée
        SELECT @Id_Role AS Id_Role;
    END

    -- Insertion sécurisée
    BEGIN TRY
        -- Insertion de la nouvelle catégorie
        INSERT INTO [dbo].[Role] ([Id_Role], [ValueRole])
        VALUES (@Id_Role, @CleanedValueName);
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