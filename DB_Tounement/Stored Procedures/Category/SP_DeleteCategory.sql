CREATE PROCEDURE DeleteCategory
    @Id_Category TINYINT NOT NULL
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] = @Id_Category
    )
    BEGIN
        SELECT CAST(0 AS BIT) AS Result, 'Erreur : Aucune catégorie trouvée avec cet ID.' AS ErrorMessage;
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Category]
        WHERE [Id_Category] = @Id_Category;

        SELECT CAST(1 AS BIT) AS Result;
    END TRY

    BEGIN CATCH
        SELECT CAST(0 AS BIT) AS Result, 'Erreur lors de la suppression de la catégorie.' AS ErrorMessage;
    END CATCH
END;