CREATE TABLE [dbo].[Role]
(
	[Id_Role] TINYINT NOT NULL PRIMARY KEY,
	[ValueRole] NCHAR(9) NOT NULL UNIQUE,

	CONSTRAINT [CK_Role_Id] CHECK ([Id_Role] BETWEEN 0 AND 2),
	CONSTRAINT [CK_Role_ValueRole] CHECK ([ValueRole] IN (N'checkmate', N'player', N'user')) -- Role doit être Joueur, Admin ou Moderateur
)
