CREATE PROCEDURE [dbo].[CheckRoleNameExist]
    @ExcludeId TINYINT,
    @Name NCHAR(9)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Role]
        WHERE [Id_Role] = @ExcludeId
            OR [ValueRole] = @Name
    )
    BEGIN
        PRINT 'Erreur : Un role avec cet ID ou ce nom existe déjà.';
        RETURN;
    END
END;