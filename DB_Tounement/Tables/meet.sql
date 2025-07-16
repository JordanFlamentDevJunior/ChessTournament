CREATE TABLE [dbo].[meet]
(
	[Id_Meeting] INT NOT NULL PRIMARY KEY, 
    [Id_Tournament] TINYINT NOT NULL, 
    [Num_Ronde] INT NOT NULL DEFAULT 0, 
    [Id_P_White] INT NOT NULL, 
    [Id_P_Black] INT NOT NULL, 
    [Point_Blanc] BIT NOT NULL DEFAULT 0, 
    [Point_Black] BIT NOT NULL DEFAULT 0, 
    [equality] BIT NOT NULL DEFAULT 0

    CONSTRAINT [CK_meet_IdMeet_pos] CHECK ([Id_Meeting] >= 0),
    CONSTRAINT [CK_meet_IdTournament_pos] CHECK ([Id_Tournament] BETWEEN 0 AND 128),
    CONSTRAINT [CK_meet_numRonde_coherence] CHECK ([Num_Ronde] BETWEEN 0 AND [Id_Meeting]),
    CONSTRAINT [CK_meet_Id_W] CHECK ([Id_P_White] >= 0),
    CONSTRAINT [CK_meet_Id_B] CHECK ([Id_P_Black] >= 0),
    CONSTRAINT [CK_meet_coherence_player] CHECK ([Id_P_White] != [Id_P_Black]),

    CONSTRAINT [FK_meet_Id_P_W] FOREIGN KEY ([Id_P_White]) REFERENCES [dbo].[Person]([Id_Person]),
    CONSTRAINT [FK_meet_Id_P_B] FOREIGN KEY ([Id_P_Black]) REFERENCES [dbo].[Person]([Id_Person]),
)
