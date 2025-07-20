CREATE PROCEDURE DeleteStatus
    @Id_Status TINYINT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Status]
        WHERE [Id_Status] = @Id_Status
    )
    BEGIN
        PRINT 'Erreur : Aucun status trouvée avec cet ID.';
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Status]
        WHERE [Id_Status] = @Id_Status;

        PRINT 'Status supprimée avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;