CREATE PROCEDURE CheckCategoryAgeExists
    @ExcludeId TINYINT,
    @MinAge TINYINT,
    @MaxAge TINYINT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] <> @ExcludeId AND
              ([MinAge] = @MinAge OR [MaxAge] = @MaxAge)
    )
    BEGIN
        PRINT 'Erreur : Âge minumum ou maximul déjà utilisé dans une autre catégorie.';
        RETURN;
    END
END;