CREATE PROCEDURE CheckCatNameExists
    @ExcludeId TINYINT,
    @Name NCHAR(7)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] = @ExcludeId
            OR [Name_Category] = @Name
    )
    BEGIN
        PRINT 'Erreur : Une catégorie avec cet ID ou ce nom existe déjà.';
        RETURN;
    END
END;