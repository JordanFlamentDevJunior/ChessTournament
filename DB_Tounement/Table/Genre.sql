CREATE TABLE [dbo].[Genre]
(
	[Id] INT NOT NULL PRIMARY KEY,
	[ValueGenre] NCHAR(50) NOT NULL,

	CONSTRAINT [UQ_Genre_ValueGenre] UNIQUE ([ValueGenre]),
	CONSTRAINT [CK_Genre_ValueGenre] CHECK ([ValueGenre] IN (N'Homme', N'Femme')) -- Genre doit être Homme, Femme ou Autre
)
