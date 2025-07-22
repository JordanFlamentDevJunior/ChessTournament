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
PRINT N'Suppression de Clé étrangère [dbo].[FK_Tournament_Place]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [FK_Tournament_Place];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Name]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Name];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Address]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Address];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] DROP CONSTRAINT [CK_Category_MinAge];


GO
PRINT N'Début de la régénération de la table [dbo].[Place]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Place] (
    [Id_Place]   INT         IDENTITY (1, 1) NOT NULL,
    [Name_Place] NCHAR (100) NOT NULL,
    [Address]    NCHAR (500) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Place] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Place])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Place] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Place] ([Id_Place], [Name_Place], [Address])
        SELECT   [Id_Place],
                 [Name_Place],
                 [Address]
        FROM     [dbo].[Place]
        ORDER BY [Id_Place] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Place] OFF;
    END

DROP TABLE [dbo].[Place];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Place]', N'Place';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Tournament_Place]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [FK_Tournament_Place] FOREIGN KEY ([Id_Place]) REFERENCES [dbo].[Place] ([Id_Place]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Name]...';


GO
ALTER TABLE [dbo].[Place] WITH NOCHECK
    ADD CONSTRAINT [CK_Place_Name] CHECK (LEN([Name_Place]) BETWEEN 2 AND 100);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Address]...';


GO
ALTER TABLE [dbo].[Place] WITH NOCHECK
    ADD CONSTRAINT [CK_Place_Address] CHECK (LEN([Address]) BETWEEN 7 AND 500);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] WITH NOCHECK
    ADD CONSTRAINT [CK_Category_MinAge] CHECK ([MinAge] BETWEEN 4 AND [MaxAge]);


GO
PRINT N'Actualisation de Procédure [dbo].[CheckPlaceAddressExist]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[CheckPlaceAddressExist]';


GO
PRINT N'Actualisation de Procédure [dbo].[CheckPlaceNameExist]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[CheckPlaceNameExist]';


GO
PRINT N'Actualisation de Procédure [dbo].[DeletePlace]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[DeletePlace]';


GO
PRINT N'Actualisation de Procédure [dbo].[UpdatePlace]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[UpdatePlace]';


GO
PRINT N'Actualisation de Procédure [dbo].[AddPlace]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[AddPlace]';


GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [FK_Tournament_Place];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Name];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Address];

ALTER TABLE [dbo].[Category] WITH CHECK CHECK CONSTRAINT [CK_Category_MinAge];


GO
PRINT N'Mise à jour terminée.';


GO
