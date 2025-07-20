CREATE PROCEDURE DeleteRole
    @Id_Role TINYINT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Role]
        WHERE [Id_Role] = @Id_Role
    )
    BEGIN
        PRINT 'Erreur : Aucun role trouvée avec cet ID.';
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Role]
        WHERE [Id_Role] = @Id_Role;

        PRINT 'Role supprimée avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;