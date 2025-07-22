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
PRINT N'Modification de Procédure [dbo].[AddGender]...';


GO
ALTER PROCEDURE AddGender
    @ValueGender NCHAR(5)
AS
BEGIN
    DECLARE 
        @Id_Gender TINYINT,
        @CleanedValueName NCHAR(5) = LOWER(TRIM(@ValueGender)),
        @conflictName BIT;

    -- Vérifier le nombre total de catégories existantes
    IF (SELECT COUNT(*) FROM [dbo].[Gender]) > 2
    BEGIN
        SELECT 255 AS Id_Gender, 'Erreur : Limite de 2 genre atteinte.' AS ErrorMessage;
        RETURN;
    END

    -- Définir l'ID selon le nom
    SET @Id_Gender = 
        CASE @CleanedValueName
            WHEN N'femme' THEN 0
            WHEN N'homme' THEN 1
            WHEN N'autre' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    -- s'assurer que l'ID est valide
    IF @Id_Gender NOT BETWEEN 0 AND 1
    BEGIN
        SELECT 255 AS Id_Genre, 'Erreur : Nom du genre non reconnu.' AS ErrorMessage;
        RETURN;
    END

    -- Vérifier si le nom de genre existe déjà
    EXEC @conflictName = CheckGenNameExists @Id_Gender, @CleanedValueName;
    IF @conflictName = 1
    BEGIN
        SELECT 255 AS Id_Gender, 'Erreur : Un genre avec cet ID ou ce nom existe déjà.' AS ErrorMessage;
        RETURN;
    END

    -- Insertion sécurisée
    BEGIN TRY
        INSERT INTO [dbo].[Gender] ([Id_Gender], [ValueGender])
        VALUES (@Id_Gender, @CleanedValueName);

        SELECT @Id_Gender AS Id_Gender;
    END TRY

    BEGIN CATCH
        SELECT 255 AS Id_Status, 'Erreur : ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO
PRINT N'Modification de Procédure [dbo].[CheckCategoryAgeExists]...';


GO
ALTER PROCEDURE CheckCategoryAgeExists
    @Id_Category TINYINT,
    @MinAge TINYINT,
    @MaxAge TINYINT
AS
BEGIN
   IF EXISTS (
    SELECT 1
    FROM [dbo].[Category]
    WHERE [Id_Category] <> @Id_Category
      AND (
          (@MinAge BETWEEN [MinAge] AND [MaxAge])
          OR (@MaxAge BETWEEN [MinAge] AND [MaxAge])
          OR ([MinAge] BETWEEN @MinAge AND @MaxAge)
          OR ([MaxAge] BETWEEN @MinAge AND @MaxAge)
      )
    )
    BEGIN
        RETURN 1;
    END
    RETURN 0;
END;
GO
PRINT N'Modification de Procédure [dbo].[CheckCatNameExists]...';


GO
ALTER PROCEDURE CheckCatNameExists
    @ExcludeId TINYINT,
    @Name NCHAR(7)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] = @ExcludeId
            OR [Name_Category] = @Name
    )
    BEGIN
        RETURN 1;
    END
    RETURN 0;
END;
GO
PRINT N'Modification de Procédure [dbo].[CheckStatNameExists]...';


GO
ALTER PROCEDURE CheckStatNameExists
    @ExcludeId TINYINT,
    @Name NCHAR(21)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Status]
        WHERE [Id_Status] = @ExcludeId
            OR [Value_Status] = @Name
    )
    BEGIN
        SELECT 255 AS Id_Status;
        RETURN;
    END
END;
GO
PRINT N'Modification de Procédure [dbo].[DeleteCategory]...';


GO
ALTER PROCEDURE DeleteCategory
    @Id_Category TINYINT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] = @Id_Category
    )
    BEGIN
        SELECT CAST(0 AS BIT) AS Result, 'Erreur : Aucune catégorie trouvée avec cet ID.' AS ErrorMessage;
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Category]
        WHERE [Id_Category] = @Id_Category;

        SELECT CAST(1 AS BIT) AS Result;
    END TRY

    BEGIN CATCH
        SELECT CAST(0 AS BIT) AS Result, 'Erreur lors de la suppression de la catégorie.' AS ErrorMessage;
    END CATCH
END;
GO
PRINT N'Modification de Procédure [dbo].[DeleteGender]...';


GO
ALTER PROCEDURE DeleteGender
    @Id_Gender TINYINT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Gender]
        WHERE [Id_Gender] = @Id_Gender
    )
    BEGIN
        PRINT 'Erreur : Aucun genre trouvée avec cet ID.';
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Gender]
        WHERE [Id_Gender] = @Id_Gender;

        PRINT 'Genre supprimée avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;
GO
PRINT N'Modification de Procédure [dbo].[DeleteRole]...';


GO
ALTER PROCEDURE DeleteRole
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
PRINT N'Modification de Procédure [dbo].[DeleteStatus]...';


GO
ALTER PROCEDURE DeleteStatus
    @Id_Status TINYINT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Status]
        WHERE [Id_Status] = @Id_Status
    )
    BEGIN
        PRINT 'Erreur : Aucun status trouvée avec cet ID.';
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Status]
        WHERE [Id_Status] = @Id_Status;

        PRINT 'Status supprimée avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;
GO
PRINT N'Création de Procédure [dbo].[CheckRoleNameExist]...';


GO
CREATE PROCEDURE [dbo].[CheckRoleNameExist]
    @ExcludeId TINYINT,
    @Name NCHAR(9)
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

    -- Vérifier le nombre total de catégories existantes
    IF (SELECT COUNT(*) FROM [dbo].[Category]) > 3
    BEGIN
        SELECT 255 AS Id_Category, 'Erreur : Limite de 3 catégories atteinte.' AS ErrorMessage;
        RETURN;
    END
        
    -- Définir l'ID selon le nom
    SET @Id_Category = 
        CASE @CleanedValueName
            WHEN N'junior' THEN 0
            WHEN N'senior' THEN 1
            WHEN N'veteran' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    -- s'assurer que l'ID est valide
    IF @Id_Category NOT BETWEEN 0 AND 2
    BEGIN
        SELECT 255 AS Id_Category, 'Erreur : Nom de catégorie non reconnu.' AS ErrorMessage;
        RETURN;
    END


    -- Vérifier si le nom de catégorie existe déjà
    EXEC @conflictName = CheckCatNameExists @Id_Category, @CleanedValueName;
    IF @conflictName = 1
    BEGIN
        SELECT 255 AS Id_Category, 'Erreur : Une catégorie avec cet ID ou ce nom existe déjà.' AS ErrorMessage;
        RETURN;
    END

        -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC @conflictAge = CheckCategoryAgeExists @Id_Category, @MinAge, @MaxAge;
    IF @conflictAge = 1
    BEGIN
        SELECT 255 AS Id_Category, 'Erreur : Tranche d’âge déjà utilisée par une autre catégorie.' AS ErrorMessage;
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
        SELECT 255 AS Id_Category, 'Erreur : ' + ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO
PRINT N'Modification de Procédure [dbo].[AddStatus]...';


GO
ALTER PROCEDURE AddStatus
    @ValueStatus NVARCHAR(21)
AS
BEGIN
    DECLARE 
        @Id_Status TINYINT,
        @CleanedValueName NCHAR(21) = LOWER(TRIM(@ValueStatus));

    -- 1. Déterminer l’ID
    SET @Id_Status =
        CASE @CleanedValueName
            WHEN N'en attente de joueurs' THEN 0
            WHEN N'en cours'               THEN 1
            WHEN N'terminé'               THEN 2
            WHEN N'annulé'                THEN 3
            ELSE -1
        END;

    -- 2. Si nom non reconnu, renvoyer 255 et sortir
    IF @Id_Status = -1
    BEGIN
        SELECT 255 AS Id_Status;
        RETURN;       -- quitte la proc après le SELECT
    END

     -- Vérifier le nombre total de catégories existantes
    IF (SELECT COUNT(*) FROM [dbo].[Status]) > 4
    BEGIN
        PRINT 'Erreur : Limite de 4 status atteinte.';
        RETURN;
    END

    -- 3. Si déjà existant, renvoyer 255 et sortir

    EXEC CheckStatNameExists @Id_Status, @CleanedValueName;

    -- 4. Insertion
    BEGIN TRY
        INSERT INTO [dbo].[Status] ([Id_Status], [Value_Status])
        VALUES (@Id_Status, @CleanedValueName);

        -- 5. Après insertion, renvoyer l’ID réel
        SELECT @Id_Status AS Id_Status;
    END TRY
    BEGIN CATCH
        -- En cas d’erreur SQL, renvoyer 255
        SELECT 255 AS Id_Status;
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;
GO
PRINT N'Modification de Procédure [dbo].[UpdateCategory]...';


GO
ALTER PROCEDURE UpdateCategory
    @Id_Category TINYINT,
    @Name_Category NCHAR(7),
    @MinAge TINYINT,
    @MaxAge TINYINT
AS
BEGIN
    DECLARE 
    @CurrentName NCHAR(7), 
    @CurrentMinAge TINYINT, 
    @CurrentMaxAge TINYINT,
    @CleanedValueName NCHAR(7) = LOWER(TRIM(@Name_Category)),
    @ConflictName BIT,
    @conflictAge BIT;

    -- Récupérer les valeurs actuelles
    SELECT 
        @CurrentName = [Name_Category],
        @CurrentMinAge = [MinAge],
        @CurrentMaxAge = [MaxAge]
    FROM [dbo].[Category]
    WHERE [Id_Category] = @Id_Category;

    -- Vérifier si la catégorie existe
    IF @CurrentName IS NULL
    BEGIN
        -- Si aucune catégorie n'est trouvée, retourner un message d'erreur et 0 pour le boolean
        SELECT CAST(0 AS BIT) AS Result, 'Erreur : Aucune catégorie trouvée avec cet ID.' AS ErrorMessage;
        RETURN;
    END

    -- Vérifier si les nouvelles valeurs sont différentes
    IF @CurrentName = @CleanedValueName AND @CurrentMinAge = @MinAge AND @CurrentMaxAge = @MaxAge
    BEGIN
        SELECT CAST(0 AS BIT) AS Result, 'Aucune modification à apporter : les valeurs sont identiques.' AS ErrorMessage;
        RETURN;
    END

    -- Vérification que le nom n’est pas utilisé par une autre catégorie
    EXEC @ConflictName = CheckCatNameExists @Id_Category, @CleanedValueName;
    IF @ConflictName = 1
    BEGIN
        SELECT CAST(0 AS BIT) AS Result, 'Erreur : Une catégorie avec cet ID ou ce nom existe déjà.' AS ErrorMessage;
        RETURN;
    END

    -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC @conflictAge = CheckCategoryAgeExists  @Id_Category, @MinAge, @MaxAge;
    IF @conflictAge = 1
    BEGIN
        SELECT CAST(0 AS BIT) AS Result, 'Erreur : Tranche d’âge déjà utilisée par une autre catégorie.' AS ErrorMessage;
        RETURN;
    END

    -- Mise à jour
    BEGIN TRY
        UPDATE [dbo].[Category]
        SET [Name_Category] = @CleanedValueName,
            [MinAge] = @MinAge,
            [MaxAge] = @MaxAge
        WHERE [Id_Category] = @Id_Category;

        SELECT CAST(1 AS BIT);
    END TRY

    BEGIN CATCH
        -- En cas d'erreur, retourner 0 et le message d'erreur
        SELECT CAST(0 AS BIT) AS Result, 'Erreur lors de la mise à jour de la catégorie : ' + ERROR_MESSAGE() AS ErrorMessage;
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
