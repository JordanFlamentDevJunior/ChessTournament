CREATE PROCEDURE DeleteCategory
    @Id_Category TINYINT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] = @Id_Category
    )
    BEGIN
        PRINT 'Erreur : Aucune catégorie trouvée avec cet ID.';
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Category]
        WHERE [Id_Category] = @Id_Category;

        PRINT 'Catégorie supprimée avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;