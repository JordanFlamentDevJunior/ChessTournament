CREATE TABLE [dbo].[Category]
(
	[Id_Category] INT NOT NULL PRIMARY KEY,
	[Name_Category] NCHAR(7) NOT NULL UNIQUE, 
	[MinAge] INT NOT NULL,
	[MaxAge] INT NOT NULL,

	CONSTRAINT [CK_Category_MinAge] CHECK ([MinAge] BETWEEN 4 AND [MaxAge]),
	CONSTRAINT [CK_Category_MaxAge_positif] CHECK ([MaxAge] > [MinAge]),
	CONSTRAINT [CK_Category_MaxAge] CHECK ([MaxAge] <= 127)
);