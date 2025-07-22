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
/*
Le type de la colonne ValueGender dans la table [dbo].[Gender] est actuellement  NCHAR (6) NOT NULL, mais est remplacé par  NCHAR (5) NOT NULL. Une perte de données peut se produire et le déploiement risque d'échouer si la colonne contient des données incompatibles avec le type  NCHAR (5) NOT NULL.
*/

IF EXISTS (select top 1 1 from [dbo].[Gender])
    RAISERROR (N'Lignes détectées. Arrêt de la mise à jour du schéma en raison d''''un risque de perte de données.', 16, 127) WITH NOWAIT

GO
PRINT N'Suppression de Contrainte unique contrainte sans nom sur [dbo].[Gender]...';


GO
ALTER TABLE [dbo].[Gender] DROP CONSTRAINT [UQ__Gender__26C900D583B8D27D];


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
PRINT N'Modification de Table [dbo].[Gender]...';


GO
ALTER TABLE [dbo].[Gender] ALTER COLUMN [ValueGender] NCHAR (5) NOT NULL;


GO
PRINT N'Création de Contrainte unique contrainte sans nom sur [dbo].[Gender]...';


GO
ALTER TABLE [dbo].[Gender]
    ADD UNIQUE NONCLUSTERED ([ValueGender] ASC);


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
PRINT N'Modification de Procédure [dbo].[CheckGenNameExists]...';


GO
ALTER PROCEDURE [dbo].[CheckGenNameExists]
    @ExcludeId INT,
    @Name NCHAR(5)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Gender]
        WHERE [Id_Gender] = @ExcludeId
            OR [ValueGender] = @Name
    )
    BEGIN
        RETURN 1;
    END
    RETURN 0;
END;
GO
PRINT N'Modification de Procédure [dbo].[CheckCategoryAgeExists]...';


GO
ALTER PROCEDURE [dbo].[CheckCategoryAgeExists]
    @Id_Category INT,
    @MinAge INT,
    @MaxAge INT
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
PRINT N'Modification de Procédure [dbo].[UpdateCategory]...';


GO
ALTER PROCEDURE [dbo].[UpdateCategory]
    @Id_Category INT,
    @MinAge INT,
    @MaxAge INT
AS
BEGIN
    DECLARE 
    @CurrentMinAge INT, 
    @CurrentMaxAge INT,
    @conflictAge BIT;

    -- Récupérer les valeurs actuelles
    SELECT 
        @CurrentMinAge = [MinAge],
        @CurrentMaxAge = [MaxAge]
    FROM [dbo].[Category]
    WHERE [Id_Category] = @Id_Category;

    -- Vérifier si les nouvelles valeurs sont différentes
    IF @CurrentMinAge = @MinAge AND @CurrentMaxAge = @MaxAge
    BEGIN
        RAISERROR ('Aucune modification à apporter : les valeurs sont identiques.', 16, 1);
        RETURN;
    END

    -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC @conflictAge = CheckCategoryAgeExists  @Id_Category, @MinAge, @MaxAge;
    IF @conflictAge = 1
    BEGIN
        RAISERROR ('Erreur : Tranche d’âge déjà utilisée par une autre catégorie.', 16, 1);
        RETURN;
    END

    -- Mise à jour
    BEGIN TRY
        UPDATE [dbo].[Category]
        SET [MinAge] = @MinAge,
            [MaxAge] = @MaxAge
        WHERE [Id_Category] = @Id_Category;
    END TRY

    BEGIN CATCH
          DECLARE 
            @ErrorMessage NVARCHAR(4000),
            @ErrorSeverity INT,
            @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (
            @ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
        );
    END CATCH
END;
GO
PRINT N'Modification de Procédure [dbo].[CheckCatNameExists]...';


GO
ALTER PROCEDURE [dbo].[CheckCatNameExists]
    @ExcludeId INT,
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
PRINT N'Modification de Procédure [dbo].[DeleteCategory]...';


GO
ALTER PROCEDURE [dbo].[DeleteCategory]
    @Id_Category INT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] = @Id_Category
    )
    BEGIN
        RAISERROR ('Erreur : Aucune catégorie trouvée avec cet ID.', 16, 1);
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Category]
        WHERE [Id_Category] = @Id_Category;
    END TRY

    BEGIN CATCH
     DECLARE 
            @ErrorMessage NVARCHAR(4000),
            @ErrorSeverity INT,
            @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (
            @ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
        );
    END CATCH
END;
GO
PRINT N'Création de Procédure [dbo].[SP_DeleteGender]...';


GO
CREATE PROCEDURE [dbo].[SP_DeleteGender]
    @Id_Gender INT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Gender]
        WHERE [Id_Gender] = @Id_Gender
    )
    BEGIN
        RAISERROR ('Erreur : Aucune catégorie trouvée avec cet ID.', 16, 1);
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Gender]
        WHERE [Id_Gender] = @Id_Gender;
    END TRY

    BEGIN CATCH
     DECLARE 
            @ErrorMessage NVARCHAR(4000),
            @ErrorSeverity INT,
            @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (
            @ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
        );
    END CATCH
END;
GO
PRINT N'Modification de Procédure [dbo].[AddGender]...';


GO
ALTER PROCEDURE [dbo].[AddGender]
    @Name_Gender NCHAR(5),
    @Id_Gender INT OUTPUT
AS
BEGIN
    DECLARE 
        @CleanedValueName NCHAR(7) = LOWER(TRIM(@Name_Gender)),
        @conflictName BIT

    -- Définir l'ID selon le nom
    SET @Id_Gender = 
        CASE @CleanedValueName
            WHEN N'femme' THEN 0
            WHEN N'homme' THEN 1
            WHEN N'autre' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    -- s'assurer que l'ID est valide
    IF @Id_Gender = -1
    BEGIN
        RAISERROR ('Erreur : Nom du genre non reconnu.', 16, 1);
        RETURN;
    END


    -- Vérifier si le nom de catégorie existe déjà
    EXEC @conflictName = CheckGenNameExists @Id_Gender, @CleanedValueName;
    IF @conflictName = 1
    BEGIN
        RAISERROR ('Erreur : Un genre avec cet ID ou ce nom existe déjà.', 16, 1);
        RETURN;
    END

    -- Insertion sécurisée
    BEGIN TRY
        -- Insertion de la nouvelle catégorie
        INSERT INTO [dbo].[Gender] ([Id_Gender], [ValueGender])
        VALUES (@Id_Gender, @CleanedValueName);

        -- Retourner l'ID de la catégorie insérée
        SELECT @Id_Gender AS Id_Gender, NULL AS ErrorMessage;
    END TRY

    BEGIN CATCH
        DECLARE 
            @ErrorMessage NVARCHAR(4000),
            @ErrorSeverity INT,
            @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (
            @ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
        );
    END CATCH;
END;
GO
PRINT N'Modification de Procédure [dbo].[AddCategory]...';


GO
ALTER PROCEDURE [dbo].[AddCategory]
    @Name_Category NCHAR(7),
    @MinAge INT,
    @MaxAge INT,
    @Id_Category INT OUTPUT
AS
BEGIN
    DECLARE 
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
        RAISERROR ('Erreur : Nom de catégorie non reconnu.', 16, 1);
        RETURN;
    END


    -- Vérifier si le nom de catégorie existe déjà
    EXEC @conflictName = CheckCatNameExists @Id_Category, @CleanedValueName;
    IF @conflictName = 1
    BEGIN
        RAISERROR ('Erreur : Une catégorie avec cet ID ou ce nom existe déjà.', 16, 1);
        RETURN;
    END

        -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC @conflictAge = CheckCategoryAgeExists @Id_Category, @MinAge, @MaxAge;
    IF @conflictAge = 1
    BEGIN
        RAISERROR ('Erreur : Tranche d’âge déjà utilisée par une autre catégorie.', 16, 1);
        RETURN;
    END

    -- Insertion sécurisée
    BEGIN TRY
        -- Insertion de la nouvelle catégorie
        INSERT INTO [dbo].[Category] ([Id_Category], [Name_Category], [MinAge], [MaxAge])
        VALUES (@Id_Category, @CleanedValueName, @MinAge, @MaxAge);

        -- Retourner l'ID de la catégorie insérée
        SELECT @Id_Category AS Id_Category, NULL AS ErrorMessage;
    END TRY

    BEGIN CATCH
        DECLARE 
            @ErrorMessage NVARCHAR(4000),
            @ErrorSeverity INT,
            @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (
            @ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
        );
    END CATCH;
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
