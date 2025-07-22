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
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] DROP CONSTRAINT [CK_Category_MinAge];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Adress]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Adress];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Name]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Name];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Category_Id]...';


GO
ALTER TABLE [dbo].[Category] DROP CONSTRAINT [CK_Category_Id];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Category_Name]...';


GO
ALTER TABLE [dbo].[Category] DROP CONSTRAINT [CK_Category_Name];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Gender_Id]...';


GO
ALTER TABLE [dbo].[Gender] DROP CONSTRAINT [CK_Gender_Id];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Genre_ValueGender]...';


GO
ALTER TABLE [dbo].[Gender] DROP CONSTRAINT [CK_Genre_ValueGender];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Historic_Id_Status]...';


GO
ALTER TABLE [dbo].[Historic_Tournament] DROP CONSTRAINT [CK_Historic_Id_Status];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_MAJ_Id]...';


GO
ALTER TABLE [dbo].[Historic_Tournament] DROP CONSTRAINT [CK_MAJ_Id];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_meet_Id_B]...';


GO
ALTER TABLE [dbo].[meet] DROP CONSTRAINT [CK_meet_Id_B];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_meet_Id_W]...';


GO
ALTER TABLE [dbo].[meet] DROP CONSTRAINT [CK_meet_Id_W];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_meet_IdMeet_pos]...';


GO
ALTER TABLE [dbo].[meet] DROP CONSTRAINT [CK_meet_IdMeet_pos];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_meet_IdTournament_pos]...';


GO
ALTER TABLE [dbo].[meet] DROP CONSTRAINT [CK_meet_IdTournament_pos];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_meet_numRonde_coherence]...';


GO
ALTER TABLE [dbo].[meet] DROP CONSTRAINT [CK_meet_numRonde_coherence];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Participation_IdPart]...';


GO
ALTER TABLE [dbo].[Participation] DROP CONSTRAINT [CK_Participation_IdPart];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Participation_IdPerson]...';


GO
ALTER TABLE [dbo].[Participation] DROP CONSTRAINT [CK_Participation_IdPerson];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Participation_IdTournament]...';


GO
ALTER TABLE [dbo].[Participation] DROP CONSTRAINT [CK_Participation_IdTournament];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Person_Gender]...';


GO
ALTER TABLE [dbo].[Person] DROP CONSTRAINT [CK_Person_Gender];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Person_Id]...';


GO
ALTER TABLE [dbo].[Person] DROP CONSTRAINT [CK_Person_Id];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Person_Role]...';


GO
ALTER TABLE [dbo].[Person] DROP CONSTRAINT [CK_Person_Role];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Id]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Id];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Role_Id]...';


GO
ALTER TABLE [dbo].[Role] DROP CONSTRAINT [CK_Role_Id];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Role_ValueRole]...';


GO
ALTER TABLE [dbo].[Role] DROP CONSTRAINT [CK_Role_ValueRole];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Status_Id]...';


GO
ALTER TABLE [dbo].[Status] DROP CONSTRAINT [CK_Status_Id];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Status_Value]...';


GO
ALTER TABLE [dbo].[Status] DROP CONSTRAINT [CK_Status_Value];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Tournament_Id]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [CK_Tournament_Id];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Tournament_Place]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [CK_Tournament_Place];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Tournament_Status]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [CK_Tournament_Status];


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] WITH NOCHECK
    ADD CONSTRAINT [CK_Category_MinAge] CHECK ([MinAge] BETWEEN 4 AND [MaxAge]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Adress]...';


GO
ALTER TABLE [dbo].[Place] WITH NOCHECK
    ADD CONSTRAINT [CK_Place_Adress] CHECK (LEN([Adresse]) BETWEEN 7 AND 500);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Name]...';


GO
ALTER TABLE [dbo].[Place] WITH NOCHECK
    ADD CONSTRAINT [CK_Place_Name] CHECK (LEN([Nom]) BETWEEN 3 AND 100);


GO
PRINT N'Modification de Procédure [dbo].[AddCategory]...';


GO
ALTER PROCEDURE AddCategory
    @Name_Category NCHAR(7),
    @MinAge TINYINT,
    @MaxAge TINYINT
AS
BEGIN
    DECLARE 
    @Id_Category TINYINT,
    @CleanedValueName NCHAR(7) = LOWER(TRIM(@Name_Category)),
    @conflictName BIT,
    @conflictAge BIT;

    -- Définir l'ID selon le nom
    SET @Id_Category = 
        CASE @CleanedValueName
            WHEN N'junior' THEN 0
            WHEN N'senior' THEN 1
            WHEN N'veteran' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    -- s'assurer que l'ID est valide
    IF @Id_Category = -1
    BEGIN
        SELECT NULL AS Id_Category, 'Erreur : Nom de catégorie non reconnu.' AS ErrorMessage;
        RETURN;
    END


    -- Vérifier si le nom de catégorie existe déjà
    EXEC @conflictName = CheckCatNameExists @Id_Category, @CleanedValueName;
    IF @conflictName = 1
    BEGIN
        SELECT NULL AS Id_Category, 'Erreur : Une catégorie avec cet ID ou ce nom existe déjà.' AS ErrorMessage;
        RETURN;
    END

        -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC @conflictAge = CheckCategoryAgeExists @Id_Category, @MinAge, @MaxAge;
    IF @conflictAge = 1
    BEGIN
        SELECT NULL AS Id_Category, 'Erreur : Tranche d’âge déjà utilisée par une autre catégorie.' AS ErrorMessage;
        RETURN;
    END

    -- Insertion sécurisée
    BEGIN TRY
        -- Insertion de la nouvelle catégorie
        INSERT INTO [dbo].[Category] ([Id_Category], [Name_Category], [MinAge], [MaxAge])
        VALUES (@Id_Category, @CleanedValueName, @MinAge, @MaxAge);

        -- Retourner l'ID de la catégorie insérée
        SELECT @Id_Category AS Id_Category;
    END TRY

    BEGIN CATCH
        -- Retourne l'ID 255 en cas d'erreur + message d'erreur
        SELECT NULL AS Id_Category, 'Erreur : ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Category] WITH CHECK CHECK CONSTRAINT [CK_Category_MinAge];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Adress];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Name];


GO
PRINT N'Mise à jour terminée.';


GO
