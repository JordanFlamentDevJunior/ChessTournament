CREATE TABLE [dbo].[Status]
(
	[Id_Status] TINYINT NOT NULL PRIMARY KEY, 
    [Value_Status] NCHAR(21) NOT NULL UNIQUE,

	CONSTRAINT [CK_Status_Id] CHECK ([Id_Status] BETWEEN 0 AND 3),
	CONSTRAINT [CK_Status_Value] CHECK ([Value_Status] IN (N'En attente de joueurs', N'en cours', N'terminé', N'annulé'))
)
