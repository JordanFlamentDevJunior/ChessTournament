CREATE TABLE [dbo].[Gender]
(
	[Id_Gender] TINYINT NOT NULL PRIMARY KEY,
	[ValueGender] NCHAR(6) NOT NULL UNIQUE,

	CONSTRAINT [CK_Gender_Id] CHECK ([Id_Gender] BETWEEN 0 AND 1),
	CONSTRAINT [CK_Genre_ValueGender] CHECK ([ValueGender] IN (N'Homme', N'Femme')) -- Genre doit être Homme, Femme ou Autre
)
