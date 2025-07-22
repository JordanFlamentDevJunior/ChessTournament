CREATE PROCEDURE [dbo].[CheckRolNameExist]
	@ExcludeId INT,
    @Name NCHAR(9)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Role]
        WHERE [Id_Role] = @ExcludeId
            OR [ValueRole] = @Name
    )
    BEGIN
        RETURN 1;
    END
    RETURN 0;
END;