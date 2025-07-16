CREATE TABLE [dbo].[Tournament]
(
	[Id_Tournament] TINYINT NOT NULL PRIMARY KEY,
	[Name_Tournament] NCHAR(100) NOT NULL UNIQUE,
    [WomenOnly] BIT NOT NULL DEFAULT 0, 
    [PlayerMin] TINYINT NOT NULL DEFAULT 2, 
    [PlayerMax] TINYINT NOT NULL DEFAULT 32, 
    [NbrPlayerRegistered] TINYINT NOT NULL DEFAULT 0, 
    [MinElo] INT NOT NULL DEFAULT 0, 
    [MaxElo] INT NOT NULL DEFAULT 3000, 
    [DateCreation] DATE NOT NULL DEFAULT GETDATE(), 
    [DateLastMaj] DATE NOT NULL DEFAULT GETDATE(), 
    [DateEndRegisteration] DATE NOT NULL, 
    [Nbr_Ronde] INT NOT NULL DEFAULT 0,
    [Id_Place] TINYINT NOT NULL DEFAULT 0,
    [Id_Status] TINYINT NOT NULL DEFAULT 0,

    CONSTRAINT [CK_Tournament_Id] CHECK ([Id_Tournament] >=0 ),
    CONSTRAINT [CK_Tournament_Name] CHECK (LEN([Name_Tournament]) >= 2),
    CONSTRAINT [CK_Tournament_PlayMin] CHECK ([PlayerMin] >= 2),
    CONSTRAINT [CK_Tournament_PlayMax_min] CHECK ([PlayerMax] >= [PlayerMin]),
    CONSTRAINT [CK_Tournament_PlayMax_max] CHECK ([PlayerMax] <= 32),
    CONSTRAINT [CK_Tournament_Regist_min] CHECK ([NbrPlayerRegistered] >= 0),
    CONSTRAINT [CK_Tournament_Regist_max] CHECK ([NbrPlayerRegistered] <= [PlayerMax]),
    CONSTRAINT [CK_Tournament_MinElo_min] CHECK ([MinElo] >= 0),
    CONSTRAINT [CK_Tournament_MinElo_max] CHECK ([MinElo] <= [MaxElo]),
    CONSTRAINT [CK_Tournament_MaxElo_min] CHECK ([MaxElo] >= [MinElo]),
    CONSTRAINT [CK_Tournament_MaxElo_max] CHECK ([MaxElo] <= 3000),
    CONSTRAINT [CK_Tournament_DateCreation_A] CHECK ([DateCreation] <= GETDATE()),
    CONSTRAINT [CK_Tournament_DateCreation_B] CHECK ([DateCreation] <= [DateEndRegisteration]),
    CONSTRAINT [CK_Tournament_DateLastMaj_A] CHECK ([DateLastMaj] <= GETDATE()), -- Ne peut pas se faire dans le futur
    CONSTRAINT [CK_Tournament_DateLastMaj_B] CHECK ([DateLastMaj] >= [DateCreation]), -- ne peut pas se faire avant la date de creation
    CONSTRAINT [CK_Tournament_DateEnd] CHECK ([DateEndRegisteration] > ([DateCreation]+[PlayerMax])), -- Doit être égale a la date de création + le nombre de joueurs recherché
    CONSTRAINT [CK_Tournament_Nbr_Ronde_A] CHECK ([Nbr_Ronde] >= 0),
    CONSTRAINT [CK_Tournament_Nbr_Ronde_B] CHECK ([Nbr_Ronde] <= (([PlayerMax]*[PlayerMax])-1)), -- ne peut pas être inférieur a PlayerMax²-1
    CONSTRAINT [CK_Tournament_Place] CHECK ([Id_Place] >= 0),
    CONSTRAINT [CK_Tournament_Status] CHECK ([Id_Status] BETWEEN 0 AND 3 ),

    CONSTRAINT [FK_Tournament_Place] FOREIGN KEY ([Id_Place]) REFERENCES [dbo].[Place]([Id_Place]),
    CONSTRAINT [FK_Tournament_Status] FOREIGN KEY ([Id_Status]) REFERENCES [dbo].[Status]([Id_Status])
)