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
La colonne [dbo].[Place].[Adress] est en cours de suppression, des données risquent d'être perdues.

La colonne [dbo].[Place].[Address] de la table [dbo].[Place] doit être ajoutée mais la colonne ne comporte pas de valeur par défaut et n'autorise pas les valeurs NULL. Si la table contient des données, le script ALTER ne fonctionnera pas. Pour éviter ce problème, vous devez ajouter une valeur par défaut à la colonne, la marquer comme autorisant les valeurs Null ou activer la génération de smart-defaults en tant qu'option de déploiement.
*/

IF EXISTS (select top 1 1 from [dbo].[Place])
    RAISERROR (N'Lignes détectées. Arrêt de la mise à jour du schéma en raison d''''un risque de perte de données.', 16, 127) WITH NOWAIT

GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] DROP CONSTRAINT [CK_Category_MinAge];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Name]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Name];


GO
PRINT N'Suppression de Contrainte de validation [dbo].[CK_Place_Adress]...';


GO
ALTER TABLE [dbo].[Place] DROP CONSTRAINT [CK_Place_Adress];


GO
PRINT N'Modification de Table [dbo].[Place]...';


GO
ALTER TABLE [dbo].[Place] DROP COLUMN [Adress];


GO
ALTER TABLE [dbo].[Place]
    ADD [Address] NCHAR (500) NOT NULL;


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category] WITH NOCHECK
    ADD CONSTRAINT [CK_Category_MinAge] CHECK ([MinAge] BETWEEN 4 AND [MaxAge]);


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
PRINT N'Création de Procédure [dbo].[CheckPlaceAddressExist]...';


GO
CREATE PROCEDURE [dbo].[CheckPlaceAddressExist]
	@Id_Place INT,
	@Address NVARCHAR(500)
AS
BEGIN
	IF EXISTS (
		SELECT 1 
		FROM [dbo].[Place]
		WHERE [Address] = @Address
		AND [Id_Place] <> @Id_Place
	)
	BEGIN
		RETURN 1; -- Addresse de lieu existe déjà
	END
	return 0; -- Addresse de lieu n'existe pas
END;
GO
PRINT N'Modification de Procédure [dbo].[UpdatePlace]...';


GO
ALTER PROCEDURE [dbo].[UpdatePlace]
	@Id_Place INT,
	@Name_Place NVARCHAR(100),
	@Address NVARCHAR(500)
AS
BEGIN 
	DECLARE 
	@CleanedValueName NVARCHAR(100) = LOWER(TRIM(@Name_Place)),
	@CleanedValueAddress NVARCHAR(500) = LOWER(TRIM(@Address)),
	@CurrentName NVARCHAR(100),
	@CurrentAddress NVARCHAR(500),
	@conflictName BIT,
	@conflictAddress BIT;

	SELECT
		@CurrentName = [Name_Place],
		@CurrentAddress = [Address]
	FROM [dbo].[Place]
	WHERE [Id_Place] = @Id_Place;

	-- Vérifier si une modification est nécessaire
	IF @CurrentName = @CleanedValueName AND @CurrentAddress = @CleanedValueAddress
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
	EXEC @conflictAddress = CheckPlaceAddressExist @Id_Place, @CleanedValueAddress;
	IF @conflictAddress = 1
	BEGIN
		RAISERROR ('Erreur : Un lieu avec cette addresse existe déjà.', 16, 1);
		RETURN;
	END

	-- Mise à jour sécurisée
	BEGIN TRY
		UPDATE [dbo].[Place]
			SET [Name_Place] = @CleanedValueName,
				[Address] = @CleanedValueAddress
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
PRINT N'Modification de Procédure [dbo].[AddPlace]...';


GO
ALTER PROCEDURE [dbo].[AddPlace]
	@Name_Place NVARCHAR(100),
	@Address NVARCHAR(500),
	@Id_Place INT OUTPUT
AS
BEGIN
	DECLARE 
		@CleanedValueName NVARCHAR(100) = LOWER(TRIM(@Name_Place)),
		@CleanedValueAddress NVARCHAR(500) = LOWER(TRIM(@Address)),
		@conflictName BIT,
		@conflictAddress BIT;

	-- Vérifier si le nom de lieu existe déjà
	EXEC @conflictName = CheckPlaceNameExist @CleanedValueName;
	IF @conflictName = 1
	BEGIN
		RAISERROR ('Erreur : Un lieu avec ce nom existe déjà.', 16, 1);
		RETURN;
	END

	-- Vérifier si l'adresse existe déjà
	EXEC @conflictAddress = CheckPlaceAddressExist @CleanedValueAddress;
	IF @conflictAddress = 1
	BEGIN
		RAISERROR ('Erreur : Un lieu avec cette addresse existe déjà.', 16, 1);
		RETURN;
	END

	-- Insertion sécurisée
	BEGIN TRY
		SET @Id_Place = (SELECT ISNULL(MAX([Id_Place]), 0) + 1 FROM [dbo].[Place]);
		
		INSERT INTO [dbo].[Place] ([Id_Place], [Name_Place], [Address])
		VALUES (@Id_Place, @CleanedValueName, @CleanedValueAddress);

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
PRINT N'Actualisation de Procédure [dbo].[CheckPlaceNameExist]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[CheckPlaceNameExist]';


GO
PRINT N'Actualisation de Procédure [dbo].[DeletePlace]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[DeletePlace]';


GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Category] WITH CHECK CHECK CONSTRAINT [CK_Category_MinAge];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Name];

ALTER TABLE [dbo].[Place] WITH CHECK CHECK CONSTRAINT [CK_Place_Address];


GO
PRINT N'Mise à jour terminée.';


GO
