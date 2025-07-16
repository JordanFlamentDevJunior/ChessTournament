CREATE TABLE [dbo].[Historic_Tournament]
(
	[Id_MAJ] INT NOT NULL PRIMARY KEY, 
    [Id_Tournament] TINYINT NOT NULL, 
    [MajDate] DATE NOT NULL DEFAULT GETDATE(), 
    [Id_Status] TINYINT NOT NULL,

    CONSTRAINT [CK_MAJ_Id] CHECK ([Id_Maj] BETWEEN 0 AND 3),
    CONSTRAINT [CK_Historic_MajDate] CHECK ([MajDate] <= GETDATE()),
    CONSTRAINT [CK_Historic_Id_Status] CHECK ([Id_Status] IN (0,1,2,3)),

    CONSTRAINT [FK_Historic_Id_Tournament] FOREIGN KEY ([Id_Tournament]) REFERENCES [dbo].[Tournament]([Id_Tournament]),
    CONSTRAINT [FK_Historic_Id_Status] FOREIGN KEY ([Id_Status]) REFERENCES [dbo].[Status]([Id_Status])
)
