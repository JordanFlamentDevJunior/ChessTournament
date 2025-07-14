CREATE TABLE [dbo].[Role]
(
	[Id_Role] TINYINT NOT NULL PRIMARY KEY,
	[ValueRole] NCHAR(9) NOT NULL,

	CONSTRAINT [UQ_Role_ValueRole] UNIQUE ([ValueRole]),
	CONSTRAINT [CK_Role_ValueRole] CHECK ([ValueRole] IN (N'CheckMate', N'Player', N'User')) -- Role doit être Joueur, Admin ou Moderateur
)
