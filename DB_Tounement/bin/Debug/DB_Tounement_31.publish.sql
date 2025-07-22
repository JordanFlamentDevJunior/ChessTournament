/*
Script de déploiement pour API_Tournament

Ce code a été généré par un outil.
La modification de ce fichier peut provoquer un comportement incorrect et sera perdue si
le code est régénéré.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "API_Tournament"
:setvar DefaultFilePrefix "API_Tournament"
:setvar DefaultDataPath "C:\Users\Flame\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\TF_202506_FSDevDotNet2\"
:setvar DefaultLogPath "C:\Users\Flame\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\TF_202506_FSDevDotNet2\"

GO
:on error exit
GO
/*
Détectez le mode SQLCMD et désactivez l'exécution du script si le mode SQLCMD n'est pas pris en charge.
Pour réactiver le script une fois le mode SQLCMD activé, exécutez ce qui suit :
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Le mode SQLCMD doit être activé de manière à pouvoir exécuter ce script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Person]...';


GO
ALTER TABLE [dbo].[Person] DROP CONSTRAINT [DF__Person__Role__571DF1D5];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [DF__Tournamen__Women__5DCAEF64];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [DF__Tournamen__Playe__5EBF139D];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [DF__Tournamen__Playe__5FB337D6];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [DF__Tournamen__NbrPl__60A75C0F];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [DF__Tournamen__MinEl__619B8048];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [DF__Tournamen__MaxEl__628FA481];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [DF__Tournamen__DateC__6383C8BA];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [DF__Tournamen__DateL__6477ECF3];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [DF__Tournamen__Nbr_R__656C112C];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [DF__Tournamen__Id_Pl__66603565];


GO
PRINT N'Suppression de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [DF__Tournamen__Id_St__6754599E];


GO
PRINT N'Suppression de Clé étrangère [dbo].[FK_Person_Gender]...';


GO
ALTER TABLE [dbo].[Person] DROP CONSTRAINT [FK_Person_Gender];


GO
PRINT N'Suppression de Clé étrangère [dbo].[FK_Historic_Id_Status]...';


GO
ALTER TABLE [dbo].[Historic_Tournament] DROP CONSTRAINT [FK_Historic_Id_Status];


GO
PRINT N'Suppression de Clé étrangère [dbo].[FK_Historic_Id_Tournament]...';


GO
ALTER TABLE [dbo].[Historic_Tournament] DROP CONSTRAINT [FK_Historic_Id_Tournament];


GO
PRINT N'Suppression de Clé étrangère [dbo].[FK_Participation_IdTournament]...';


GO
ALTER TABLE [dbo].[Participation] DROP CONSTRAINT [FK_Participation_IdTournament];


GO
PRINT N'Suppression de Clé étrangère [dbo].[FK_Person_Role]...';


GO
ALTER TABLE [dbo].[Person] DROP CONSTRAINT [FK_Person_Role];


GO
PRINT N'Suppression de Clé étrangère [dbo].[FK_Tournament_Place]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [FK_Tournament_Place];


GO
PRINT N'Suppression de Clé étrangère [dbo].[FK_Tournament_Status]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [FK_Tournament_Status];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Name]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Name];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Adress]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Adress];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] DROP CONSTRAINT [CK_Category_MinAge];


GO
PRINT N'Début de la régénération de la table [dbo].[Gender]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Gender] (
    [Id_Gender]   INT       NOT NULL,
    [ValueGender] NCHAR (5) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Gender] ASC),
    UNIQUE NONCLUSTERED ([ValueGender] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Gender])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Gender] ([Id_Gender], [ValueGender])
        SELECT   [Id_Gender],
                 [ValueGender]
        FROM     [dbo].[Gender]
        ORDER BY [Id_Gender] ASC;
    END

DROP TABLE [dbo].[Gender];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Gender]', N'Gender';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Modification de Table [dbo].[Historic_Tournament]...';


GO
ALTER TABLE [dbo].[Historic_Tournament] ALTER COLUMN [Id_Status] INT NOT NULL;

ALTER TABLE [dbo].[Historic_Tournament] ALTER COLUMN [Id_Tournament] INT NOT NULL;


GO
PRINT N'Modification de Table [dbo].[meet]...';


GO
ALTER TABLE [dbo].[meet] ALTER COLUMN [Id_Tournament] INT NOT NULL;


GO
PRINT N'Modification de Table [dbo].[Participation]...';


GO
ALTER TABLE [dbo].[Participation] ALTER COLUMN [Id_Tournament] INT NOT NULL;


GO
PRINT N'Modification de Table [dbo].[Person]...';


GO
ALTER TABLE [dbo].[Person] ALTER COLUMN [Gender] INT NOT NULL;

ALTER TABLE [dbo].[Person] ALTER COLUMN [Role] INT NOT NULL;


GO
PRINT N'Début de la régénération de la table [dbo].[Place]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Place] (
    [Id_Place] INT         NOT NULL,
    [Nom]      NCHAR (100) NOT NULL,
    [Adresse]  NCHAR (500) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Place] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Place])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Place] ([Id_Place], [Nom], [Adresse])
        SELECT   [Id_Place],
                 [Nom],
                 [Adresse]
        FROM     [dbo].[Place]
        ORDER BY [Id_Place] ASC;
    END

DROP TABLE [dbo].[Place];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Place]', N'Place';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Début de la régénération de la table [dbo].[Role]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Role] (
    [Id_Role]   INT       NOT NULL,
    [ValueRole] NCHAR (9) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Role] ASC),
    UNIQUE NONCLUSTERED ([ValueRole] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Role])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Role] ([Id_Role], [ValueRole])
        SELECT   [Id_Role],
                 [ValueRole]
        FROM     [dbo].[Role]
        ORDER BY [Id_Role] ASC;
    END

DROP TABLE [dbo].[Role];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Role]', N'Role';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Début de la régénération de la table [dbo].[Status]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Status] (
    [Id_Status]    INT        NOT NULL,
    [Value_Status] NCHAR (21) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Status] ASC),
    UNIQUE NONCLUSTERED ([Value_Status] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Status])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Status] ([Id_Status], [Value_Status])
        SELECT   [Id_Status],
                 [Value_Status]
        FROM     [dbo].[Status]
        ORDER BY [Id_Status] ASC;
    END

DROP TABLE [dbo].[Status];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Status]', N'Status';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Début de la régénération de la table [dbo].[Tournament]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Tournament] (
    [Id_Tournament]        INT         NOT NULL,
    [Name_Tournament]      NCHAR (100) NOT NULL,
    [WomenOnly]            BIT         DEFAULT 0 NOT NULL,
    [PlayerMin]            INT         DEFAULT 2 NOT NULL,
    [PlayerMax]            INT         DEFAULT 32 NOT NULL,
    [NbrPlayerRegistered]  INT         DEFAULT 0 NOT NULL,
    [MinElo]               INT         DEFAULT 0 NOT NULL,
    [MaxElo]               INT         DEFAULT 3000 NOT NULL,
    [DateCreation]         DATE        DEFAULT GETDATE() NOT NULL,
    [DateLastMaj]          DATE        DEFAULT GETDATE() NOT NULL,
    [DateEndRegisteration] DATE        NOT NULL,
    [Nbr_Ronde]            INT         DEFAULT 0 NOT NULL,
    [Id_Place]             INT         DEFAULT 0 NOT NULL,
    [Id_Status]            INT         DEFAULT 0 NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Tournament] ASC),
    UNIQUE NONCLUSTERED ([Name_Tournament] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Tournament])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Tournament] ([Id_Tournament], [Name_Tournament], [WomenOnly], [PlayerMin], [PlayerMax], [NbrPlayerRegistered], [MinElo], [MaxElo], [DateCreation], [DateLastMaj], [DateEndRegisteration], [Nbr_Ronde], [Id_Place], [Id_Status])
        SELECT   [Id_Tournament],
                 [Name_Tournament],
                 [WomenOnly],
                 [PlayerMin],
                 [PlayerMax],
                 [NbrPlayerRegistered],
                 [MinElo],
                 [MaxElo],
                 [DateCreation],
                 [DateLastMaj],
                 [DateEndRegisteration],
                 [Nbr_Ronde],
                 [Id_Place],
                 [Id_Status]
        FROM     [dbo].[Tournament]
        ORDER BY [Id_Tournament] ASC;
    END

DROP TABLE [dbo].[Tournament];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Tournament]', N'Tournament';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Person]...';


GO
ALTER TABLE [dbo].[Person]
    ADD DEFAULT 2 FOR [Role];


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Person_Gender]...';


GO
ALTER TABLE [dbo].[Person] WITH NOCHECK
    ADD CONSTRAINT [FK_Person_Gender] FOREIGN KEY ([Gender]) REFERENCES [dbo].[Gender] ([Id_Gender]);


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Historic_Id_Status]...';


GO
ALTER TABLE [dbo].[Historic_Tournament] WITH NOCHECK
    ADD CONSTRAINT [FK_Historic_Id_Status] FOREIGN KEY ([Id_Status]) REFERENCES [dbo].[Status] ([Id_Status]);


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Historic_Id_Tournament]...';


GO
ALTER TABLE [dbo].[Historic_Tournament] WITH NOCHECK
    ADD CONSTRAINT [FK_Historic_Id_Tournament] FOREIGN KEY ([Id_Tournament]) REFERENCES [dbo].[Tournament] ([Id_Tournament]);


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Participation_IdTournament]...';


GO
ALTER TABLE [dbo].[Participation] WITH NOCHECK
    ADD CONSTRAINT [FK_Participation_IdTournament] FOREIGN KEY ([Id_Tournament]) REFERENCES [dbo].[Tournament] ([Id_Tournament]);


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Person_Role]...';


GO
ALTER TABLE [dbo].[Person] WITH NOCHECK
    ADD CONSTRAINT [FK_Person_Role] FOREIGN KEY ([Role]) REFERENCES [dbo].[Role] ([Id_Role]);


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Tournament_Place]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [FK_Tournament_Place] FOREIGN KEY ([Id_Place]) REFERENCES [dbo].[Place] ([Id_Place]);


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Tournament_Status]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [FK_Tournament_Status] FOREIGN KEY ([Id_Status]) REFERENCES [dbo].[Status] ([Id_Status]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Name]...';


GO
ALTER TABLE [dbo].[Place] WITH NOCHECK
    ADD CONSTRAINT [CK_Place_Name] CHECK (LEN([Nom]) BETWEEN 3 AND 100);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Adress]...';


GO
ALTER TABLE [dbo].[Place] WITH NOCHECK
    ADD CONSTRAINT [CK_Place_Adress] CHECK (LEN([Adresse]) BETWEEN 7 AND 500);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Name]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_Name] CHECK (LEN([Name_Tournament]) >= 2);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_PlayMin]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_PlayMin] CHECK ([PlayerMin] >= 2);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_PlayMax_min]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_PlayMax_min] CHECK ([PlayerMax] >= [PlayerMin]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_PlayMax_max]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_PlayMax_max] CHECK ([PlayerMax] <= 32);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Regist_min]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_Regist_min] CHECK ([NbrPlayerRegistered] >= 0);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Regist_max]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_Regist_max] CHECK ([NbrPlayerRegistered] <= [PlayerMax]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_MinElo_min]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_MinElo_min] CHECK ([MinElo] >= 0);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_MinElo_max]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_MinElo_max] CHECK ([MinElo] <= [MaxElo]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_MaxElo_min]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_MaxElo_min] CHECK ([MaxElo] >= [MinElo]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_MaxElo_max]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_MaxElo_max] CHECK ([MaxElo] <= 3000);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_DateCreation_A]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_DateCreation_A] CHECK ([DateCreation] <= GETDATE());


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_DateCreation_B]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_DateCreation_B] CHECK ([DateCreation] <= [DateEndRegisteration]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_DateLastMaj_A]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_DateLastMaj_A] CHECK ([DateLastMaj] <= GETDATE());


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_DateLastMaj_B]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_DateLastMaj_B] CHECK ([DateLastMaj] >= [DateCreation]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_DateEnd]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_DateEnd] CHECK ([DateEndRegisteration] > DATEADD(day, [PlayerMax], [DateCreation]));


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Nbr_Ronde_A]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_Nbr_Ronde_A] CHECK ([Nbr_Ronde] >= 0);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Nbr_Ronde_B]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_Nbr_Ronde_B] CHECK ([Nbr_Ronde] <= (([PlayerMax]*[PlayerMax])-1));


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] WITH NOCHECK
    ADD CONSTRAINT [CK_Category_MinAge] CHECK ([MinAge] BETWEEN 4 AND [MaxAge]);


GO
PRINT N'Actualisation de Procédure [dbo].[CheckGenNameExists]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[CheckGenNameExists]';


GO
PRINT N'Actualisation de Procédure [dbo].[SP_DeleteGender]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[SP_DeleteGender]';


GO
PRINT N'Actualisation de Procédure [dbo].[AddGender]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[AddGender]';


GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Person] WITH CHECK CHECK CONSTRAINT [FK_Person_Gender];

ALTER TABLE [dbo].[Historic_Tournament] WITH CHECK CHECK CONSTRAINT [FK_Historic_Id_Status];

ALTER TABLE [dbo].[Historic_Tournament] WITH CHECK CHECK CONSTRAINT [FK_Historic_Id_Tournament];

ALTER TABLE [dbo].[Participation] WITH CHECK CHECK CONSTRAINT [FK_Participation_IdTournament];

ALTER TABLE [dbo].[Person] WITH CHECK CHECK CONSTRAINT [FK_Person_Role];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [FK_Tournament_Place];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [FK_Tournament_Status];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Name];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Adress];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_Name];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_PlayMin];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_PlayMax_min];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_PlayMax_max];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_Regist_min];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_Regist_max];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_MinElo_min];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_MinElo_max];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_MaxElo_min];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_MaxElo_max];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_DateCreation_A];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_DateCreation_B];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_DateLastMaj_A];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_DateLastMaj_B];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_DateEnd];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_Nbr_Ronde_A];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_Nbr_Ronde_B];

ALTER TABLE [dbo].[Category] WITH CHECK CHECK CONSTRAINT [CK_Category_MinAge];


GO
PRINT N'Mise à jour terminée.';


GO
