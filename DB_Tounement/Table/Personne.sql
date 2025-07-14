CREATE TABLE [dbo].[Personne]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [Pseudo] NCHAR(50) NOT NULL, 
    [Mail] NCHAR(300) NOT NULL, 
    [Password] NCHAR(1000) NOT NULL, 
    [DateNaissance] DATETIME NOT NULL, 
    [Elo] INT NOT NULL, 
    [Genre] INT NOT NULL, 
    [Role] INT NOT NULL,

    -- contraintes de base
    CONSTRAINT [UQ_Personne_Pseudo] UNIQUE ([Pseudo]),
    ConSTRAINT [UQ_Personne_Mail] UNIQUE ([Mail]),
    CONSTRAINT [CK_Personne_DateNaissance_Max] CHECK ([DateNaissance] <= GETDATE() - 365 * 120), -- 120 ans max
    CONSTRAINT [CK_Personne_DateNaissance_Min] CHECK ([DateNaissance] >= GETDATE() - 365 * 10), -- 10 ans min
    CONSTRAINT [CK_Personne_Elo_Min] CHECK ([ELO] >= 0), -- ELO ne peut pas être négatif
    CONSTRAINT [CK_Personne_Elo_Max] CHECK ([ELO] <= 3000), -- ELO ne peut pas dépasser 5000
    

    -- contraintes de clé étrangères
    Constraint [CK_Personne_Genre] CHECK ([Genre] IN (0, 1)),
    Constraint [CK_Personne_Role] CHECK ([Role] IN (0, 1, 2)),

    CONSTRAINT [FK_Personne_Genre] FOREIGN KEY ([Genre]) REFERENCES [dbo].[Genre]([Id]),
    CONSTRAINT [FK_Personne_Role] FOREIGN KEY ([Role]) REFERENCES [dbo].[Role]([Id])
)
