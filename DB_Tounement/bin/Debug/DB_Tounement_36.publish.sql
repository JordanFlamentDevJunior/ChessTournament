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
La colonne [dbo].[Place].[Adresse] est en cours de suppression, des données risquent d'être perdues.

La colonne [dbo].[Place].[Nom] est en cours de suppression, des données risquent d'être perdues.

La colonne [dbo].[Place].[Adress] de la table [dbo].[Place] doit être ajoutée mais la colonne ne comporte pas de valeur par défaut et n'autorise pas les valeurs NULL. Si la table contient des données, le script ALTER ne fonctionnera pas. Pour éviter ce problème, vous devez ajouter une valeur par défaut à la colonne, la marquer comme autorisant les valeurs Null ou activer la génération de smart-defaults en tant qu'option de déploiement.

La colonne [dbo].[Place].[Name_Place] de la table [dbo].[Place] doit être ajoutée mais la colonne ne comporte pas de valeur par défaut et n'autorise pas les valeurs NULL. Si la table contient des données, le script ALTER ne fonctionnera pas. Pour éviter ce problème, vous devez ajouter une valeur par défaut à la colonne, la marquer comme autorisant les valeurs Null ou activer la génération de smart-defaults en tant qu'option de déploiement.
*/

IF EXISTS (select top 1 1 from [dbo].[Place])
    RAISERROR (N'Lignes détectées. Arrêt de la mise à jour du schéma en raison d''''un risque de perte de données.', 16, 127) WITH NOWAIT

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
PRINT N'Modification de Table [dbo].[Place]...';


GO
ALTER TABLE [dbo].[Place] DROP COLUMN [Adresse], COLUMN [Nom];


GO
ALTER TABLE [dbo].[Place]
    ADD [Name_Place] NCHAR (100) NOT NULL,
        [Adress]     NCHAR (500) NOT NULL;


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] WITH NOCHECK
    ADD CONSTRAINT [CK_Category_MinAge] CHECK ([MinAge] BETWEEN 4 AND [MaxAge]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Adress]...';


GO
ALTER TABLE [dbo].[Place] WITH NOCHECK
    ADD CONSTRAINT [CK_Place_Adress] CHECK (LEN([Adress]) BETWEEN 7 AND 500);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Name]...';


GO
ALTER TABLE [dbo].[Place] WITH NOCHECK
    ADD CONSTRAINT [CK_Place_Name] CHECK (LEN([Name_Place]) BETWEEN 2 AND 100);


GO
PRINT N'Création de Procédure [dbo].[CheckPlaceAdressExist]...';


GO
CREATE PROCEDURE [dbo].[CheckPlaceAdressExist]
	@Id_Place INT,
	@Adress NVARCHAR(500)
AS
BEGIN
	IF EXISTS (
		SELECT 1 
		FROM [dbo].[Place]
		WHERE [Adress] = @Adress
		AND [Id_Place] <> @Id_Place
	)
	BEGIN
		RETURN 1; -- Adresse de lieu existe déjà
	END
	return 0; -- Adresse de lieu n'existe pas
END;
GO
PRINT N'Création de Procédure [dbo].[CheckPlaceNameExist]...';


GO
CREATE PROCEDURE [dbo].[CheckPlaceNameExist]
	@id_Place INT,
	@Name_Place NVARCHAR(100)
AS
BEGIN
	IF EXISTS (
		SELECT 1 
		FROM [dbo].[Place]
		WHERE [Name_Place] = @Name_Place
		AND [Id_Place] <> @id_Place
	)
	BEGIN
		RETURN 1; -- Nom de lieu existe déjà
	END
	return 0; -- Nom de lieu n'existe pas
END;
GO
PRINT N'Création de Procédure [dbo].[DeletePlace]...';


GO
CREATE PROCEDURE [dbo].[DeletePlace]
	@Id_Place INT
AS
BEGIN
	-- Vérifier si le lieu existe
	IF NOT EXISTS (
		SELECT 1 FROM [dbo].[Place]
		WHERE [Id_Place] = @Id_Place
	)
	BEGIN
		RAISERROR ('Erreur : Aucun lieu trouvé avec cet ID.', 16, 1);
		RETURN;
	END

	-- Suppression
	BEGIN TRY
		DELETE FROM [dbo].[Place]
		WHERE [Id_Place] = @Id_Place;
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
PRINT N'Création de Procédure [dbo].[UpdatePlace]...';


GO
CREATE PROCEDURE [dbo].[UpdatePlace]
	@Id_Place INT,
	@Name_Place NVARCHAR(100),
	@Adress NVARCHAR(500)
AS
BEGIN 
	DECLARE 
	@CleanedValueName NVARCHAR(100) = LOWER(TRIM(@Name_Place)),
	@CleanedValueAdress NVARCHAR(500) = LOWER(TRIM(@Adress)),
	@CurrentName NVARCHAR(100),
	@CurrentAdress NVARCHAR(500),
	@conflictName BIT,
	@conflictAdress BIT;

	SELECT
		@CurrentName = [Name_Place],
		@CurrentAdress = [Adress]
	FROM [dbo].[Place]
	WHERE [Id_Place] = @Id_Place;

	-- Vérifier si une modification est nécessaire
	IF @CurrentName = @CleanedValueName AND @CurrentAdress = @CleanedValueAdress
	BEGIN
		RAISERROR ('Aucune modification à apporter : les valeurs sont identiques.', 16, 1);
		RETURN;
	END

	-- Vérifier si le nom de lieu existe déjà
	EXEC @conflictName = CheckPlaceNameExist @Id_Place, @CleanedValueName;
	IF @conflictName = 1
	BEGIN
		RAISERROR ('Erreur : Un lieu avec ce nom existe déjà.', 16, 1);
		RETURN;
	END

	-- Vérifier si l'adresse existe déjà
	EXEC @conflictAdress = CheckPlaceAdressExist @Id_Place, @CleanedValueAdress;
	IF @conflictAdress = 1
	BEGIN
		RAISERROR ('Erreur : Un lieu avec cette adresse existe déjà.', 16, 1);
		RETURN;
	END

	-- Mise à jour sécurisée
	BEGIN TRY
		UPDATE [dbo].[Place]
			SET [Name_Place] = @CleanedValueName,
				[Adress] = @CleanedValueAdress
			WHERE [Id_Place] = @Id_Place;
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
PRINT N'Création de Procédure [dbo].[AddPlace]...';


GO
CREATE PROCEDURE [dbo].[AddPlace]
	@Name_Place NVARCHAR(100),
	@Adress NVARCHAR(500),
	@Id_Place INT OUTPUT
AS
BEGIN
	DECLARE 
		@CleanedValueName NVARCHAR(100) = LOWER(TRIM(@Name_Place)),
		@CleanedValueAdress NVARCHAR(500) = LOWER(TRIM(@Adress)),
		@conflictName BIT,
		@conflictAdress BIT;

	-- Vérifier si le nom de lieu existe déjà
	EXEC @conflictName = CheckPlaceNameExist @CleanedValueName;
	IF @conflictName = 1
	BEGIN
		RAISERROR ('Erreur : Un lieu avec ce nom existe déjà.', 16, 1);
		RETURN;
	END

	-- Vérifier si l'adresse existe déjà
	EXEC @conflictAdress = CheckPlaceAdressExist @CleanedValueAdress;
	IF @conflictAdress = 1
	BEGIN
		RAISERROR ('Erreur : Un lieu avec cette adresse existe déjà.', 16, 1);
		RETURN;
	END

	-- Insertion sécurisée
	BEGIN TRY
		SET @Id_Place = (SELECT ISNULL(MAX([Id_Place]), 0) + 1 FROM [dbo].[Place]);
		
		INSERT INTO [dbo].[Place] ([Id_Place], [Name_Place], [Adress])
		VALUES (@Id_Place, @CleanedValueName, @CleanedValueAdress);

		SELECT @Id_Place AS Id_Place;
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

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Adress];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Name];


GO
PRINT N'Mise à jour terminée.';


GO
