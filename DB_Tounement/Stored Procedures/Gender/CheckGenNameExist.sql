CREATE PROCEDURE CheckGenNameExists
    @ExcludeId TINYINT,
    @Name NCHAR(6)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Gender]
        WHERE [Id_Gender] = @ExcludeId
            OR [ValueGender] = @Name
    )
    BEGIN
        PRINT 'Erreur : Une catégorie avec cet ID ou ce nom existe déjà.';
        RETURN;
    END
END;