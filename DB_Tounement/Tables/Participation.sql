CREATE TABLE [dbo].[Participation]
(
	[Id_participation] INT NOT NULL PRIMARY KEY, 
    [Id_Person] INT NOT NULL, 
    [Id_Tournament] INT NOT NULL, 
    [SubscribDate] DATE NOT NULL DEFAULT GETDATE(), 
    [UnsubscribDate] DATE NULL DEFAULT NULL,

    CONSTRAINT [CK_Participation_Subscrib] CHECK ([SubscribDate] = GETDATE()),
    CONSTRAINT [CK_Participation_Unsubscrib] CHECK ([UnsubscribDate] >= [SubscribDate]),

    CONSTRAINT [FK_Participation_IdPerson] FOREIGN KEY ([Id_Person]) REFERENCES [dbo].[Person]([Id_Person]),
    CONSTRAINT [FK_Participation_IdTournament] FOREIGN KEY ([Id_Tournament]) REFERENCES [dbo].[Tournament]([Id_Tournament])
)
