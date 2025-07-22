CREATE PROCEDURE [dbo].[CheckCategoryAgeExists]
    @Id_Category INT,
    @MinAge INT,
    @MaxAge INT
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