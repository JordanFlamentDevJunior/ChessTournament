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
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Category_Id]...';


GO
ALTER TABLE [dbo].[Category] DROP CONSTRAINT [CK_Category_Id];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] DROP CONSTRAINT [CK_Category_MinAge];


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
PRINT N'Suppression de Contrainte de validation [dbo].[CK_meet_IdTournament_pos]...';


GO
ALTER TABLE [dbo].[meet] DROP CONSTRAINT [CK_meet_IdTournament_pos];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_meet_numRonde_coherence]...';


GO
ALTER TABLE [dbo].[meet] DROP CONSTRAINT [CK_meet_numRonde_coherence];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Participation_IdTournament]...';


GO
ALTER TABLE [dbo].[Participation] DROP CONSTRAINT [CK_Participation_IdTournament];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Person_Gender]...';


GO
ALTER TABLE [dbo].[Person] DROP CONSTRAINT [CK_Person_Gender];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Person_Role]...';


GO
ALTER TABLE [dbo].[Person] DROP CONSTRAINT [CK_Person_Role];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Adress]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Adress];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Id]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Id];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Name]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Name];


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
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Tournament_Status]...';


GO
ALTER TABLE [dbo].[Tournament] DROP CONSTRAINT [CK_Tournament_Status];


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_Id]...';


GO
ALTER TABLE [dbo].[Category] WITH NOCHECK
    ADD CONSTRAINT [CK_Category_Id] CHECK ([Id_Category] BETWEEN 0 AND 2);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] WITH NOCHECK
    ADD CONSTRAINT [CK_Category_MinAge] CHECK ([MinAge] BETWEEN 4 AND [MaxAge]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_Name]...';


GO
ALTER TABLE [dbo].[Category] WITH NOCHECK
    ADD CONSTRAINT [CK_Category_Name] CHECK ([Name_Category] IN (N'Junior', N'Senior', N'Veteran'));


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Gender_Id]...';


GO
ALTER TABLE [dbo].[Gender] WITH NOCHECK
    ADD CONSTRAINT [CK_Gender_Id] CHECK ([Id_Gender] BETWEEN 0 AND 1);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Genre_ValueGender]...';


GO
ALTER TABLE [dbo].[Gender] WITH NOCHECK
    ADD CONSTRAINT [CK_Genre_ValueGender] CHECK ([ValueGender] IN (N'Homme', N'Femme'));


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Historic_Id_Status]...';


GO
ALTER TABLE [dbo].[Historic_Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Historic_Id_Status] CHECK ([Id_Status] IN (0,1,2,3));


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_MAJ_Id]...';


GO
ALTER TABLE [dbo].[Historic_Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_MAJ_Id] CHECK ([Id_Maj] BETWEEN 0 AND 3);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_meet_IdTournament_pos]...';


GO
ALTER TABLE [dbo].[meet] WITH NOCHECK
    ADD CONSTRAINT [CK_meet_IdTournament_pos] CHECK ([Id_Tournament] BETWEEN 0 AND 128);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_meet_numRonde_coherence]...';


GO
ALTER TABLE [dbo].[meet] WITH NOCHECK
    ADD CONSTRAINT [CK_meet_numRonde_coherence] CHECK ([Num_Ronde] BETWEEN 0 AND [Id_Meeting]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Participation_IdTournament]...';


GO
ALTER TABLE [dbo].[Participation] WITH NOCHECK
    ADD CONSTRAINT [CK_Participation_IdTournament] CHECK ([Id_Tournament] BETWEEN 0 AND 128);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Gender]...';


GO
ALTER TABLE [dbo].[Person] WITH NOCHECK
    ADD CONSTRAINT [CK_Person_Gender] CHECK ([Gender] IN (0, 1));


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Role]...';


GO
ALTER TABLE [dbo].[Person] WITH NOCHECK
    ADD CONSTRAINT [CK_Person_Role] CHECK ([Role] IN (0, 1, 2));


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Adress]...';


GO
ALTER TABLE [dbo].[Place] WITH NOCHECK
    ADD CONSTRAINT [CK_Place_Adress] CHECK (LEN([Adresse]) BETWEEN 7 AND 500);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Id]...';


GO
ALTER TABLE [dbo].[Place] WITH NOCHECK
    ADD CONSTRAINT [CK_Place_Id] CHECK ([Id_Place] BETWEEN 0 AND 128);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Name]...';


GO
ALTER TABLE [dbo].[Place] WITH NOCHECK
    ADD CONSTRAINT [CK_Place_Name] CHECK (LEN([Nom]) BETWEEN 3 AND 100);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Role_Id]...';


GO
ALTER TABLE [dbo].[Role] WITH NOCHECK
    ADD CONSTRAINT [CK_Role_Id] CHECK ([Id_Role] BETWEEN 0 AND 2);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Role_ValueRole]...';


GO
ALTER TABLE [dbo].[Role] WITH NOCHECK
    ADD CONSTRAINT [CK_Role_ValueRole] CHECK ([ValueRole] IN (N'checkmate', N'player', N'user'));


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Status_Id]...';


GO
ALTER TABLE [dbo].[Status] WITH NOCHECK
    ADD CONSTRAINT [CK_Status_Id] CHECK ([Id_Status] BETWEEN 0 AND 3);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Status_Value]...';


GO
ALTER TABLE [dbo].[Status] WITH NOCHECK
    ADD CONSTRAINT [CK_Status_Value] CHECK ([Value_Status] IN (N'En attente de joueurs', N'en cours', N'terminé', N'annulé'));


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Status]...';


GO
ALTER TABLE [dbo].[Tournament] WITH NOCHECK
    ADD CONSTRAINT [CK_Tournament_Status] CHECK ([Id_Status] BETWEEN 0 AND 3);


GO
PRINT N'Création de Procédure [dbo].[AddRole]...';


GO
CREATE PROCEDURE AddRole
    @ValueRole NCHAR(6)
AS
BEGIN
    DECLARE @Id_Role TINYINT;

    -- Définir l'ID selon le nom
    SET @Id_Role = 
        CASE @ValueRole
            WHEN N'checkMate' THEN 0
            WHEN N'player' THEN 1
            WHEN N'user' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    IF @Id_Role = -1
    BEGIN
        PRINT 'Erreur : Nom de role non reconnu.';
        RETURN;
    END

    -- Vérifier le nombre total de catégories existantes
    IF (SELECT COUNT(*) FROM [dbo].[Role]) > 3
    BEGIN
        PRINT 'Erreur : Limite de 3 role atteinte.';
        RETURN;
    END

    -- Vérifier si le nom de catégorie existe déjà
    EXEC CheckRoleNameExists @Id_Role, @ValueRole;

    -- Insertion sécurisée
    BEGIN TRY
        INSERT INTO [dbo].[Role] ([Id_Role], [ValueRole])
        VALUES (@Id_Role, @ValueRole);

        PRINT 'Role insérée avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;
GO
PRINT N'Création de Procédure [dbo].[CheckRolNameExist]...';


GO
CREATE PROCEDURE [dbo].[CheckRolNameExist]
    @ExcludeId TINYINT,
    @Name NCHAR(7)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Role]
        WHERE [Id_Role] = @ExcludeId
            OR [ValueRole] = @Name
    )
    BEGIN
        PRINT 'Erreur : Un role avec cet ID ou ce nom existe déjà.';
        RETURN;
    END
END;
GO
PRINT N'Création de Procédure [dbo].[DeleteRole]...';


GO
CREATE PROCEDURE DeleteRole
    @Id_Role TINYINT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Role]
        WHERE [Id_Role] = @Id_Role
    )
    BEGIN
        PRINT 'Erreur : Aucun role trouvée avec cet ID.';
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Role]
        WHERE [Id_Role] = @Id_Role;

        PRINT 'Role supprimée avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;
GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Category] WITH CHECK CHECK CONSTRAINT [CK_Category_Id];

ALTER TABLE [dbo].[Category] WITH CHECK CHECK CONSTRAINT [CK_Category_MinAge];

ALTER TABLE [dbo].[Category] WITH CHECK CHECK CONSTRAINT [CK_Category_Name];

ALTER TABLE [dbo].[Gender] WITH CHECK CHECK CONSTRAINT [CK_Gender_Id];

ALTER TABLE [dbo].[Gender] WITH CHECK CHECK CONSTRAINT [CK_Genre_ValueGender];

ALTER TABLE [dbo].[Historic_Tournament] WITH CHECK CHECK CONSTRAINT [CK_Historic_Id_Status];

ALTER TABLE [dbo].[Historic_Tournament] WITH CHECK CHECK CONSTRAINT [CK_MAJ_Id];

ALTER TABLE [dbo].[meet] WITH CHECK CHECK CONSTRAINT [CK_meet_IdTournament_pos];

ALTER TABLE [dbo].[meet] WITH CHECK CHECK CONSTRAINT [CK_meet_numRonde_coherence];

ALTER TABLE [dbo].[Participation] WITH CHECK CHECK CONSTRAINT [CK_Participation_IdTournament];

ALTER TABLE [dbo].[Person] WITH CHECK CHECK CONSTRAINT [CK_Person_Gender];

ALTER TABLE [dbo].[Person] WITH CHECK CHECK CONSTRAINT [CK_Person_Role];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Adress];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Id];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Name];

ALTER TABLE [dbo].[Role] WITH CHECK CHECK CONSTRAINT [CK_Role_Id];

ALTER TABLE [dbo].[Role] WITH CHECK CHECK CONSTRAINT [CK_Role_ValueRole];

ALTER TABLE [dbo].[Status] WITH CHECK CHECK CONSTRAINT [CK_Status_Id];

ALTER TABLE [dbo].[Status] WITH CHECK CHECK CONSTRAINT [CK_Status_Value];

ALTER TABLE [dbo].[Tournament] WITH CHECK CHECK CONSTRAINT [CK_Tournament_Status];


GO
PRINT N'Mise à jour terminée.';


GO
