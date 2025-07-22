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
PRINT N'Début de la régénération de la table [dbo].[Category]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Category] (
    [Id_Category]   INT       NOT NULL,
    [Name_Category] NCHAR (7) NOT NULL,
    [MinAge]        INT       NOT NULL,
    [MaxAge]        INT       NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Category] ASC),
    UNIQUE NONCLUSTERED ([Name_Category] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Category])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Category] ([Id_Category], [Name_Category], [MinAge], [MaxAge])
        SELECT   [Id_Category],
                 [Name_Category],
                 [MinAge],
                 [MaxAge]
        FROM     [dbo].[Category]
        ORDER BY [Id_Category] ASC;
    END

DROP TABLE [dbo].[Category];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Category]', N'Category';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] WITH NOCHECK
    ADD CONSTRAINT [CK_Category_MinAge] CHECK ([MinAge] BETWEEN 4 AND [MaxAge]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MaxAge_positif]...';


GO
ALTER TABLE [dbo].[Category] WITH NOCHECK
    ADD CONSTRAINT [CK_Category_MaxAge_positif] CHECK ([MaxAge] > [MinAge]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MaxAge]...';


GO
ALTER TABLE [dbo].[Category] WITH NOCHECK
    ADD CONSTRAINT [CK_Category_MaxAge] CHECK ([MaxAge] <= 127);


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
PRINT N'Actualisation de Vue [dbo].[ViewCategory]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ViewCategory]';


GO
PRINT N'Modification de Procédure [dbo].[CheckCategoryAgeExists]...';


GO
ALTER PROCEDURE CheckCategoryAgeExists
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
PRINT N'Modification de Procédure [dbo].[CheckCatNameExists]...';


GO
ALTER PROCEDURE CheckCatNameExists
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
ALTER PROCEDURE DeleteCategory
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
PRINT N'Modification de Procédure [dbo].[AddCategory]...';


GO
ALTER PROCEDURE AddCategory
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
PRINT N'Modification de Procédure [dbo].[UpdateCategory]...';


GO
ALTER PROCEDURE UpdateCategory
    @Id_Category INT,
    @Name_Category NCHAR(7),
    @MinAge INT,
    @MaxAge INT
AS
BEGIN
    DECLARE 
    @CurrentName NCHAR(7), 
    @CurrentMinAge INT, 
    @CurrentMaxAge INT,
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
        RAISERROR ('Erreur : Aucune catégorie trouvée avec cet ID.', 16, 1);
        RETURN;
    END

    -- Vérifier si les nouvelles valeurs sont différentes
    IF @CurrentName = @CleanedValueName AND @CurrentMinAge = @MinAge AND @CurrentMaxAge = @MaxAge
    BEGIN
        RAISERROR ('Aucune modification à apporter : les valeurs sont identiques.', 16, 1);
        RETURN;
    END

    -- Vérification que le nom n’est pas utilisé par une autre catégorie
    EXEC @ConflictName = CheckCatNameExists @Id_Category, @CleanedValueName;
    IF @ConflictName = 1
    BEGIN
        RAISERROR ('Erreur : Une catégorie avec cet ID ou ce nom existe déjà.', 16, 1);
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
        SET [Name_Category] = @CleanedValueName,
            [MinAge] = @MinAge,
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
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Category] WITH CHECK CHECK CONSTRAINT [CK_Category_MinAge];

ALTER TABLE [dbo].[Category] WITH CHECK CHECK CONSTRAINT [CK_Category_MaxAge_positif];

ALTER TABLE [dbo].[Category] WITH CHECK CHECK CONSTRAINT [CK_Category_MaxAge];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Adress];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Name];


GO
PRINT N'Mise à jour terminée.';


GO
