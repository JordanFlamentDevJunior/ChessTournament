﻿CREATE PROCEDURE [dbo].[CheckCatNameExists]
    @ExcludeId INT,
    @Name NCHAR(7)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] = @ExcludeId
            OR [Name_Category] = @Name
    )
    BEGIN
        RETURN 1;
    END
    RETURN 0;
END;