CREATE TABLE [dbo].[Role]
(
	[Id] INT NOT NULL PRIMARY KEY,
	[ValueRole] NCHAR(50) NOT NULL,

	CONSTRAINT [UQ_Role_ValueRole] UNIQUE ([ValueRole]),
	CONSTRAINT [CK_Role_ValueRole] CHECK ([ValueRole] IN (N'CheckMate', N'Joeur', N'Utilisateur')) -- Role doit être Joueur, Admin ou Moderateur
)
