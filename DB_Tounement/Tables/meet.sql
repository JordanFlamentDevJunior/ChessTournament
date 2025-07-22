CREATE TABLE [dbo].[meet]
(
	[Id_Meeting] INT NOT NULL PRIMARY KEY, 
    [Id_Tournament] INT NOT NULL, 
    [Num_Ronde] INT NOT NULL DEFAULT 0, 
    [Id_P_White] INT NOT NULL, 
    [Id_P_Black] INT NOT NULL, 
    [Point_Blanc] BIT NOT NULL DEFAULT 0, 
    [Point_Black] BIT NOT NULL DEFAULT 0, 
    [equality] BIT NOT NULL DEFAULT 0

    CONSTRAINT [CK_meet_coherence_player] CHECK ([Id_P_White] != [Id_P_Black]),

    CONSTRAINT [FK_meet_Id_P_W] FOREIGN KEY ([Id_P_White]) REFERENCES [dbo].[Person]([Id_Person]),
    CONSTRAINT [FK_meet_Id_P_B] FOREIGN KEY ([Id_P_Black]) REFERENCES [dbo].[Person]([Id_Person])
)
