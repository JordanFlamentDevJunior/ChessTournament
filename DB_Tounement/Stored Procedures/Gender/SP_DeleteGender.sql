CREATE PROCEDURE [dbo].[SP_DeleteGender]
    @Id_Gender INT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Gender]
        WHERE [Id_Gender] = @Id_Gender
    )
    BEGIN
        RAISERROR ('Erreur : Aucune catégorie trouvée avec cet ID.', 16, 1);
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Gender]
        WHERE [Id_Gender] = @Id_Gender;
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