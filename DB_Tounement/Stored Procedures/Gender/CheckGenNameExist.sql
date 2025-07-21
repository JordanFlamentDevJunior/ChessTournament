CREATE PROCEDURE CheckGenNameExists
    @ExcludeId TINYINT NOT NULL,
    @Name NCHAR(5) NOT NULL
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Gender]
        WHERE [Id_Gender] = @ExcludeId
            OR [ValueGender] = @Name
    )
    BEGIN
        RETURN 1;
    END
    return 0;
END;