CREATE PROCEDURE DeleteGender
    @Id_Gender TINYINT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Gender]
        WHERE [Id_Gender] = @Id_Gender
    )
    BEGIN
        PRINT 'Erreur : Aucun genre trouvée avec cet ID.';
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Gender]
        WHERE [Id_Gender] = @Id_Gender;

        PRINT 'Genre supprimée avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;