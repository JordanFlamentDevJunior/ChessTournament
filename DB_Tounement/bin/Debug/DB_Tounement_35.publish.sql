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
Le type de la colonne ValueStatus dans la table [dbo].[Status] est actuellement  NCHAR (21) NOT NULL, mais est remplacé par  NCHAR (8) NOT NULL. Une perte de données peut se produire et le déploiement risque d'échouer si la colonne contient des données incompatibles avec le type  NCHAR (8) NOT NULL.
*/

IF EXISTS (select top 1 1 from [dbo].[Status])
    RAISERROR (N'Lignes détectées. Arrêt de la mise à jour du schéma en raison d''''un risque de perte de données.', 16, 127) WITH NOWAIT

GO
PRINT N'L''opération suivante a été générée à partir d''un fichier journal de refactorisation aa6d2335-da2d-40d4-8525-96b8026d72be';

PRINT N'Renommer [dbo].[Status].[Value_Status] en ValueStatus';


GO
EXECUTE sp_rename @objname = N'[dbo].[Status].[Value_Status]', @newname = N'ValueStatus', @objtype = N'COLUMN';


GO
PRINT N'Suppression de Contrainte unique contrainte sans nom sur [dbo].[Status]...';


GO
ALTER TABLE [dbo].[Status] DROP CONSTRAINT [UQ__tmp_ms_x__187098D5FC55BE63];


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
PRINT N'Modification de Table [dbo].[Status]...';


GO
ALTER TABLE [dbo].[Status] ALTER COLUMN [ValueStatus] NCHAR (8) NOT NULL;


GO
PRINT N'Création de Contrainte unique contrainte sans nom sur [dbo].[Status]...';


GO
ALTER TABLE [dbo].[Status]
    ADD UNIQUE NONCLUSTERED ([ValueStatus] ASC);


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
PRINT N'Modification de Procédure [dbo].[DeleteStatus]...';


GO
ALTER PROCEDURE [dbo].[DeleteStatus]
	@Id_Status INT
AS
BEGIN
	-- Vérifier si le status existe
	IF NOT EXISTS (
		SELECT 1 FROM [dbo].[Status] 
		WHERE [Id_Status] = @Id_Status
		)
	BEGIN
		RAISERROR ('Erreur : Status non trouvé.', 16, 1);
		RETURN;
	END

	-- Supprimer le status
	BEGIN TRY
		DELETE FROM [dbo].[Status]
		WHERE [Id_Status] = @Id_Status;
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
        SELECT @Id_Category AS Id_Category;
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
        SELECT @Id_Gender AS Id_Gender;
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
PRINT N'Création de Procédure [dbo].[CheckStatNameExist]...';


GO
CREATE PROCEDURE [dbo].[CheckStatNameExist]
	@ExistingId INT,
	@Name_Status NCHAR(8)
AS
BEGIN
	IF EXISTS (
		SELECT 1 FROM [dbo].[Status]
		WHERE [Id_Status] = @ExistingId
			OR [ValueStatus] = @Name_Status
	)
	BEGIN
		RETURN 1; -- Le nom de status existe déjà
	END
	RETURN 0; -- Le nom de status n'existe pas
END;
GO
PRINT N'Modification de Procédure [dbo].[AddStatus]...';


GO
ALTER PROCEDURE [dbo].[AddStatus]
	@Name_Status NCHAR(8),
	@Id_Status INT OUTPUT
AS
BEGIN
	DECLARE 
		@CleanedValueName NCHAR(8) = LOWER(TRIM(@Name_Status)),
		@conflictName BIT

	-- Définir l'ID selon le nom
	SET @Id_Status = 
		CASE @CleanedValueName
			WHEN N'waiting' THEN 0
			WHEN N'ongoing' THEN 1
			WHEN N'finished' THEN 2
			WHEN N'canceled' THEN 3
			ELSE -1 -- Valeur invalide, déclenchera une erreur
		END;

	-- s'assurer que l'ID est valide
	IF @Id_Status = -1
	BEGIN
		RAISERROR ('Erreur : Nom de status non reconnu.', 16, 1);
		RETURN;
	END

	-- Vérifier si le nom de status existe déjà
	EXEC @conflictName = CheckStatNameExist @Id_Status, @CleanedValueName;
	IF @conflictName = 1
	BEGIN
		RAISERROR ('Erreur : Un status avec cet ID ou ce nom existe déjà.', 16, 1);
		RETURN;
	
	-- Retourner l'ID du status inséré
		SELECT @Id_Status AS Id_Status;
	END

	-- Insertion sécurisée
	BEGIN TRY
		-- Insertion du nouveau status
		INSERT INTO [dbo].[Status] ([Id_Status], [ValueStatus])
		 VALUES (@Id_Status, @CleanedValueName);
		
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
-- Étape de refactorisation pour mettre à jour le serveur cible avec des journaux de transactions déployés
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'aa6d2335-da2d-40d4-8525-96b8026d72be')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('aa6d2335-da2d-40d4-8525-96b8026d72be')

GO

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
