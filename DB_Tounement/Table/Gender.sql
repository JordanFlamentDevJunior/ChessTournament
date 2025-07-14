CREATE TABLE [dbo].[Gender]
(
	[Id_Gender] TINYINT NOT NULL PRIMARY KEY,
	[ValueGender] NCHAR(50) NOT NULL,

	CONSTRAINT [UQ_Genre_ValueGender] UNIQUE ([ValueGender]),
	CONSTRAINT [CK_Genre_ValueGender] CHECK ([ValueGender] IN (N'Homme', N'Femme')) -- Genre doit être Homme, Femme ou Autre
)
