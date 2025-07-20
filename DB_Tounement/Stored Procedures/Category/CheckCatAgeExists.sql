CREATE PROCEDURE CheckCategoryAgeExists
    @Id_Category TINYINT NOT NULL,
    @MinAge TINYINT NOT NULL,
    @MaxAge TINYINT NOT NULL
AS
BEGIN
   IF EXISTS (
    SELECT 1
    FROM [dbo].[Category]
    WHERE [Id_Category] <> @Id_Category
      AND (
          (@MinAge BETWEEN [MinAge] AND [MaxAge])
          OR (@MaxAge BETWEEN [MinAge] AND [MaxAge])
          OR ([MinAge] BETWEEN @MinAge AND @MaxAge)
          OR ([MaxAge] BETWEEN @MinAge AND @MaxAge)
      )
    )
    BEGIN
        RETURN 1;
    END
    RETURN 0;
END;