CREATE TABLE [dbo].[Category]
(
	[Id_Category] TINYINT NOT NULL PRIMARY KEY,
	[Name_Category] NCHAR(7) NOT NULL UNIQUE, 
	[MinAge] TINYINT NOT NULL,
	[MaxAge] TINYINT NOT NULL,

	CONSTRAINT [CK_Category_Id] CHECK ([Id_Category] BETWEEN 0 AND 2),
	CONSTRAINT [CK_Category_Name] CHECK ([Name_Category] IN (N'Junior', N'Senior', N'Veteran')),
	CONSTRAINT [CK_Category_MinAge] CHECK ([MinAge] BETWEEN 4 AND [MaxAge]),
	CONSTRAINT [CK_Category_MaxAge_positif] CHECK ([MaxAge] > [MinAge]),
	CONSTRAINT [CK_Category_MaxAge] CHECK ([MaxAge] <= 130)
)
