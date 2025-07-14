CREATE TABLE [dbo].[Personne]
(
	[Id_Person] INT NOT NULL PRIMARY KEY, 
    [Pseudo] NCHAR(100) NOT NULL UNIQUE, 
    [Gender] TINYINT NOT NULL, 
    [Mail] NCHAR(300) NOT NULL UNIQUE, -- sera soumi a une regex pour validation                                  ++tard
    [BirthDate] DATETIME NOT NULL, 
    [DateRegist] DATETIME NOT NULL DEFAULT GETDATE(), -- verif validité de la date 
    [Password] NCHAR(1000) NOT NULL, 
    [Role] TINYINT NOT NULL DEFAULT 2,
    [Elo] INT NOT NULL DEFAULT 1200, 
    [NbrPartPlayed] INT NOT NULL DEFAULT 0,
    [NbrPartWin] INT NOT NULL DEFAULT 0,
    [NbrPartLost] INT NOT NULL DEFAULT 0,
    [NbrPartDraw] INT NOT NULL DEFAULT 0, -- Nombre de parties nulles
    [Score] INT NOT NULL DEFAULT 0,

    -- contraintes de base
    CONSTRAINT [CK_Person_Pseudo] CHECK (LEN([Pseudo]) >= 3 AND LEN([Pseudo]) <= 100), -- Pseudo entre 3 et 100 caractères

    CONSTRAINT [CK_Person_Mail] CHECK (LEN([Mail]) >= 5 AND LEN([Mail]) <= 300), -- Mail entre 5 et 300 caractères

    CONSTRAINT [CK_Person_BirthDatee_Min] CHECK ([BirthDate] >= GETDATE() - 365 * 10), -- 10 ans min
    CONSTRAINT [CK_Person_BirthDate_Max] CHECK ([BirthDate] <= GETDATE() - 365 * 120), -- 120 ans max

    CONSTRAINT [CK_Person_DateRegist_Min] CHECK ([DateRegist] > GETDATE() - 365 * 10), -- 10 ans min
    CONSTRAINT [CK_Person_DateRegist_Max] CHECK ([DateRegist] < GETDATE()), -- Date d'inscription ne peut pas être dans le futur

    CONSTRAINT [CK_Person_Password] CHECK (LEN([Password]) >= 8 AND LEN([Password]) <= 1000), -- Password entre 8 et 1000 caractères

    CONSTRAINT [CK_Person_Elo_Min] CHECK ([ELO] >= 0), -- ELO ne peut pas être négatif
    CONSTRAINT [CK_Person_Elo_Max] CHECK ([ELO] <= 3000), -- ELO ne peut pas dépasser 3000

    CONSTRAINT [CK_Person_NbrPartPlayed_Min] CHECK ([NbrPartPlayed] >= 0), -- NbrPartPlayed ne peut pas être négatif
    -- NbrPartPlayed ne peut pas être inférieur au nombre de partie déja jouées depuis le début de l'évenement (lier autre table)
    CONSTRAINT [CK_Person_NbrPartWin_Min] CHECK ([NbrPartWin] >= 0), -- NbrPartWin ne peut pas être négatif
    -- NbrPartWin ne peut pas être supérieur au nombre de partie jouées
    CONSTRAINT [CK_Person_NbrPartLost_Min] CHECK ([NbrPartLost] >= 0), -- NbrPartLost ne peut pas être négatif
    -- NbrPartLost ne peut pas être supérieur au nombre de partie jouées
    CONSTRAINT [CK_Person_NbrPartDraw_Min] CHECK ([NbrPartDraw] >= 0), -- NbrPartDraw ne peut pas être négatif
    -- NbrPartDraw ne peut pas être supérieur au nombre de partie jouées
    -- trouver un moyen de vérifier que le score est cohérent avec les parties jouées

    CONSTRAINT [CK_Person_Score_Min] CHECK ([Score] >= 0), -- Score ne peut pas être négatif
    CONSTRAINT [CK_Person_Score_Max_A] CHECK ([Score] <= 30000), -- Score ne peut pas dépasser 10000
    CONSTRAINT [CK_Person_Score_Max_B] CHECK ([Score] <= [NbrPartPlayed]), -- Score ne peut pas dépasser le nombre de partie déjà jouées

    -- contraintes de clé étrangères
    CONSTRAINT [CK_Person_Gender] CHECK ([Gender] IN (0, 1)),
    CONSTRAINT [CK_Person_Role] CHECK ([Role] IN (0, 1, 2)),

    CONSTRAINT [FK_Person_Gender] FOREIGN KEY ([Gender]) REFERENCES [dbo].[Gender]([Id_Gender]),
    CONSTRAINT [FK_Person_Role] FOREIGN KEY ([Role]) REFERENCES [dbo].[Role]([Id_Role])
)
