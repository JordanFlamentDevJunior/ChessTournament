CREATE PROCEDURE [dbo].[DeleteRole]
	@Id_Role INT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Role]
        WHERE [Id_Role] = @Id_Role
    )
    BEGIN
        RAISERROR ('Erreur : Aucun role trouvée avec cet ID.', 16, 1);
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Role]
        WHERE [Id_Role] = @Id_Role;
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
    END CATCH
END;