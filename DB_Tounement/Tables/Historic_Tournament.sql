CREATE TABLE [dbo].[Historic_Tournament]
(
	[Id_MAJ] INT NOT NULL PRIMARY KEY, 
    [Id_Tournament] INT NOT NULL, 
    [MajDate] DATE NOT NULL DEFAULT GETDATE(), 
    [Id_Status] INT NOT NULL,

    CONSTRAINT [CK_Historic_MajDate] CHECK ([MajDate] <= GETDATE()),

    CONSTRAINT [FK_Historic_Id_Tournament] FOREIGN KEY ([Id_Tournament]) REFERENCES [dbo].[Tournament]([Id_Tournament]),
    CONSTRAINT [FK_Historic_Id_Status] FOREIGN KEY ([Id_Status]) REFERENCES [dbo].[Status]([Id_Status])
)
