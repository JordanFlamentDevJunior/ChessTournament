CREATE PROCEDURE CheckStatNameExists
    @ExcludeId TINYINT,
    @Name NCHAR(21)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Status]
        WHERE [Id_Status] = @ExcludeId
            OR [Value_Status] = @Name
    )
    BEGIN
        SELECT 255 AS Id_Status;
        RETURN;
    END
END;