CREATE PROCEDURE [dbo].[CheckGenNameExists]
    @ExcludeId INT,
    @Name NCHAR(5)
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
    RETURN 0;
END;