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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Création de la base de données $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Impossible de modifier les paramètres de base de données. Vous devez être administrateur système pour appliquer ces paramètres.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Impossible de modifier les paramètres de base de données. Vous devez être administrateur système pour appliquer ces paramètres.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO

IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Création de Table [dbo].[Category]...';


GO
CREATE TABLE [dbo].[Category] (
    [Id_Category]   TINYINT   NOT NULL,
    [Name_Category] NCHAR (7) NOT NULL,
    [MinAge]        TINYINT   NOT NULL,
    [MaxAge]        TINYINT   NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Category] ASC),
    UNIQUE NONCLUSTERED ([Name_Category] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Table [dbo].[Gender]...';


GO
CREATE TABLE [dbo].[Gender] (
    [Id_Gender]   TINYINT   NOT NULL,
    [ValueGender] NCHAR (6) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Gender] ASC),
    UNIQUE NONCLUSTERED ([ValueGender] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Table [dbo].[Historic_Tournament]...';


GO
CREATE TABLE [dbo].[Historic_Tournament] (
    [Id_MAJ]        INT     NOT NULL,
    [Id_Tournament] TINYINT NOT NULL,
    [MajDate]       DATE    NOT NULL,
    [Id_Status]     TINYINT NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_MAJ] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Table [dbo].[meet]...';


GO
CREATE TABLE [dbo].[meet] (
    [Id_Meeting]    INT     NOT NULL,
    [Id_Tournament] TINYINT NOT NULL,
    [Num_Ronde]     INT     NOT NULL,
    [Id_P_White]    INT     NOT NULL,
    [Id_P_Black]    INT     NOT NULL,
    [Point_Blanc]   BIT     NOT NULL,
    [Point_Black]   BIT     NOT NULL,
    [equality]      BIT     NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Meeting] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Table [dbo].[Participation]...';


GO
CREATE TABLE [dbo].[Participation] (
    [Id_participation] INT     NOT NULL,
    [Id_Person]        INT     NOT NULL,
    [Id_Tournament]    TINYINT NOT NULL,
    [SubscribDate]     DATE    NOT NULL,
    [UnsubscribDate]   DATE    NULL,
    PRIMARY KEY CLUSTERED ([Id_participation] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Table [dbo].[Person]...';


GO
CREATE TABLE [dbo].[Person] (
    [Id_Person]     INT          NOT NULL,
    [Pseudo]        NCHAR (100)  NOT NULL,
    [Gender]        TINYINT      NOT NULL,
    [Mail]          NCHAR (300)  NOT NULL,
    [BirthDate]     DATETIME     NOT NULL,
    [DateRegist]    DATETIME     NOT NULL,
    [Password]      NCHAR (1000) NOT NULL,
    [Role]          TINYINT      NOT NULL,
    [Elo]           INT          NOT NULL,
    [NbrPartPlayed] INT          NOT NULL,
    [NbrPartWin]    INT          NOT NULL,
    [NbrPartLost]   INT          NOT NULL,
    [NbrPartDraw]   INT          NOT NULL,
    [Score]         INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Person] ASC),
    UNIQUE NONCLUSTERED ([Mail] ASC),
    UNIQUE NONCLUSTERED ([Pseudo] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Table [dbo].[Place]...';


GO
CREATE TABLE [dbo].[Place] (
    [Id_Place] TINYINT     NOT NULL,
    [Nom]      NCHAR (100) NOT NULL,
    [Adresse]  NCHAR (500) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Place] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Table [dbo].[Role]...';


GO
CREATE TABLE [dbo].[Role] (
    [Id_Role]   TINYINT   NOT NULL,
    [ValueRole] NCHAR (9) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Role] ASC),
    UNIQUE NONCLUSTERED ([ValueRole] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Table [dbo].[Status]...';


GO
CREATE TABLE [dbo].[Status] (
    [Id_Status]    TINYINT    NOT NULL,
    [Value_Status] NCHAR (21) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Status] ASC),
    UNIQUE NONCLUSTERED ([Value_Status] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Table [dbo].[Tournament]...';


GO
CREATE TABLE [dbo].[Tournament] (
    [Id_Tournament]        TINYINT     NOT NULL,
    [Name_Tournament]      NCHAR (100) NOT NULL,
    [WomenOnly]            BIT         NOT NULL,
    [PlayerMin]            TINYINT     NOT NULL,
    [PlayerMax]            TINYINT     NOT NULL,
    [NbrPlayerRegistered]  TINYINT     NOT NULL,
    [MinElo]               INT         NOT NULL,
    [MaxElo]               INT         NOT NULL,
    [DateCreation]         DATE        NOT NULL,
    [DateLastMaj]          DATE        NOT NULL,
    [DateEndRegisteration] DATE        NOT NULL,
    [Nbr_Ronde]            INT         NOT NULL,
    [Id_Place]             TINYINT     NOT NULL,
    [Id_Status]            TINYINT     NOT NULL,
    PRIMARY KEY CLUSTERED ([Id_Tournament] ASC),
    UNIQUE NONCLUSTERED ([Name_Tournament] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Historic_Tournament]...';


GO
ALTER TABLE [dbo].[Historic_Tournament]
    ADD DEFAULT GETDATE() FOR [MajDate];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[meet]...';


GO
ALTER TABLE [dbo].[meet]
    ADD DEFAULT 0 FOR [Num_Ronde];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[meet]...';


GO
ALTER TABLE [dbo].[meet]
    ADD DEFAULT 0 FOR [Point_Blanc];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[meet]...';


GO
ALTER TABLE [dbo].[meet]
    ADD DEFAULT 0 FOR [Point_Black];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[meet]...';


GO
ALTER TABLE [dbo].[meet]
    ADD DEFAULT 0 FOR [equality];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Participation]...';


GO
ALTER TABLE [dbo].[Participation]
    ADD DEFAULT GETDATE() FOR [SubscribDate];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Participation]...';


GO
ALTER TABLE [dbo].[Participation]
    ADD DEFAULT NULL FOR [UnsubscribDate];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Person]...';


GO
ALTER TABLE [dbo].[Person]
    ADD DEFAULT GETDATE() FOR [DateRegist];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Person]...';


GO
ALTER TABLE [dbo].[Person]
    ADD DEFAULT 2 FOR [Role];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Person]...';


GO
ALTER TABLE [dbo].[Person]
    ADD DEFAULT 1200 FOR [Elo];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Person]...';


GO
ALTER TABLE [dbo].[Person]
    ADD DEFAULT 0 FOR [NbrPartPlayed];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Person]...';


GO
ALTER TABLE [dbo].[Person]
    ADD DEFAULT 0 FOR [NbrPartWin];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Person]...';


GO
ALTER TABLE [dbo].[Person]
    ADD DEFAULT 0 FOR [NbrPartLost];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Person]...';


GO
ALTER TABLE [dbo].[Person]
    ADD DEFAULT 0 FOR [NbrPartDraw];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Person]...';


GO
ALTER TABLE [dbo].[Person]
    ADD DEFAULT 0 FOR [Score];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD DEFAULT 0 FOR [WomenOnly];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD DEFAULT 2 FOR [PlayerMin];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD DEFAULT 32 FOR [PlayerMax];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD DEFAULT 0 FOR [NbrPlayerRegistered];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD DEFAULT 0 FOR [MinElo];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD DEFAULT 3000 FOR [MaxElo];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD DEFAULT GETDATE() FOR [DateCreation];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD DEFAULT GETDATE() FOR [DateLastMaj];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD DEFAULT 0 FOR [Nbr_Ronde];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD DEFAULT 0 FOR [Id_Place];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Tournament]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD DEFAULT 0 FOR [Id_Status];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Historic_Id_Tournament]...';


GO
ALTER TABLE [dbo].[Historic_Tournament]
    ADD CONSTRAINT [FK_Historic_Id_Tournament] FOREIGN KEY ([Id_Tournament]) REFERENCES [dbo].[Tournament] ([Id_Tournament]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Historic_Id_Status]...';


GO
ALTER TABLE [dbo].[Historic_Tournament]
    ADD CONSTRAINT [FK_Historic_Id_Status] FOREIGN KEY ([Id_Status]) REFERENCES [dbo].[Status] ([Id_Status]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Clé étrangère [dbo].[FK_meet_Id_P_W]...';


GO
ALTER TABLE [dbo].[meet]
    ADD CONSTRAINT [FK_meet_Id_P_W] FOREIGN KEY ([Id_P_White]) REFERENCES [dbo].[Person] ([Id_Person]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Clé étrangère [dbo].[FK_meet_Id_P_B]...';


GO
ALTER TABLE [dbo].[meet]
    ADD CONSTRAINT [FK_meet_Id_P_B] FOREIGN KEY ([Id_P_Black]) REFERENCES [dbo].[Person] ([Id_Person]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Participation_IdPerson]...';


GO
ALTER TABLE [dbo].[Participation]
    ADD CONSTRAINT [FK_Participation_IdPerson] FOREIGN KEY ([Id_Person]) REFERENCES [dbo].[Person] ([Id_Person]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Participation_IdTournament]...';


GO
ALTER TABLE [dbo].[Participation]
    ADD CONSTRAINT [FK_Participation_IdTournament] FOREIGN KEY ([Id_Tournament]) REFERENCES [dbo].[Tournament] ([Id_Tournament]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Person_Gender]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [FK_Person_Gender] FOREIGN KEY ([Gender]) REFERENCES [dbo].[Gender] ([Id_Gender]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Person_Role]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [FK_Person_Role] FOREIGN KEY ([Role]) REFERENCES [dbo].[Role] ([Id_Role]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Tournament_Place]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [FK_Tournament_Place] FOREIGN KEY ([Id_Place]) REFERENCES [dbo].[Place] ([Id_Place]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Tournament_Status]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [FK_Tournament_Status] FOREIGN KEY ([Id_Status]) REFERENCES [dbo].[Status] ([Id_Status]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_Id]...';


GO
ALTER TABLE [dbo].[Category]
    ADD CONSTRAINT [CK_Category_Id] CHECK ([Id_Category] BETWEEN 0 AND 2);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_Name]...';


GO
ALTER TABLE [dbo].[Category]
    ADD CONSTRAINT [CK_Category_Name] CHECK ([Name_Category] IN (N'Junior', N'Senior', N'Veteran'));


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MinAge]...';


GO
ALTER TABLE [dbo].[Category]
    ADD CONSTRAINT [CK_Category_MinAge] CHECK ([MinAge] BETWEEN 4 AND [MaxAge]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MaxAge_positif]...';


GO
ALTER TABLE [dbo].[Category]
    ADD CONSTRAINT [CK_Category_MaxAge_positif] CHECK ([MaxAge] > [MinAge]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Category_MaxAge]...';


GO
ALTER TABLE [dbo].[Category]
    ADD CONSTRAINT [CK_Category_MaxAge] CHECK ([MaxAge] <= 127);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Gender_Id]...';


GO
ALTER TABLE [dbo].[Gender]
    ADD CONSTRAINT [CK_Gender_Id] CHECK ([Id_Gender] BETWEEN 0 AND 1);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Genre_ValueGender]...';


GO
ALTER TABLE [dbo].[Gender]
    ADD CONSTRAINT [CK_Genre_ValueGender] CHECK ([ValueGender] IN (N'Homme', N'Femme'));


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_MAJ_Id]...';


GO
ALTER TABLE [dbo].[Historic_Tournament]
    ADD CONSTRAINT [CK_MAJ_Id] CHECK ([Id_Maj] BETWEEN 0 AND 3);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Historic_MajDate]...';


GO
ALTER TABLE [dbo].[Historic_Tournament]
    ADD CONSTRAINT [CK_Historic_MajDate] CHECK ([MajDate] <= GETDATE());


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Historic_Id_Status]...';


GO
ALTER TABLE [dbo].[Historic_Tournament]
    ADD CONSTRAINT [CK_Historic_Id_Status] CHECK ([Id_Status] IN (0,1,2,3));


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_meet_IdMeet_pos]...';


GO
ALTER TABLE [dbo].[meet]
    ADD CONSTRAINT [CK_meet_IdMeet_pos] CHECK ([Id_Meeting] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_meet_IdTournament_pos]...';


GO
ALTER TABLE [dbo].[meet]
    ADD CONSTRAINT [CK_meet_IdTournament_pos] CHECK ([Id_Tournament] BETWEEN 0 AND 128);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_meet_numRonde_coherence]...';


GO
ALTER TABLE [dbo].[meet]
    ADD CONSTRAINT [CK_meet_numRonde_coherence] CHECK ([Num_Ronde] BETWEEN 0 AND [Id_Meeting]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_meet_Id_W]...';


GO
ALTER TABLE [dbo].[meet]
    ADD CONSTRAINT [CK_meet_Id_W] CHECK ([Id_P_White] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_meet_Id_B]...';


GO
ALTER TABLE [dbo].[meet]
    ADD CONSTRAINT [CK_meet_Id_B] CHECK ([Id_P_Black] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_meet_coherence_player]...';


GO
ALTER TABLE [dbo].[meet]
    ADD CONSTRAINT [CK_meet_coherence_player] CHECK ([Id_P_White] != [Id_P_Black]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Participation_IdPart]...';


GO
ALTER TABLE [dbo].[Participation]
    ADD CONSTRAINT [CK_Participation_IdPart] CHECK ([Id_Participation] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Participation_IdPerson]...';


GO
ALTER TABLE [dbo].[Participation]
    ADD CONSTRAINT [CK_Participation_IdPerson] CHECK ([Id_Person] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Participation_IdTournament]...';


GO
ALTER TABLE [dbo].[Participation]
    ADD CONSTRAINT [CK_Participation_IdTournament] CHECK ([Id_Tournament] BETWEEN 0 AND 128);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Participation_Subscrib]...';


GO
ALTER TABLE [dbo].[Participation]
    ADD CONSTRAINT [CK_Participation_Subscrib] CHECK ([SubscribDate] = GETDATE());


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Participation_Unsubscrib]...';


GO
ALTER TABLE [dbo].[Participation]
    ADD CONSTRAINT [CK_Participation_Unsubscrib] CHECK ([UnsubscribDate] >= [SubscribDate]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Id]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Id] CHECK ([Id_Person] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Pseudo]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Pseudo] CHECK (LEN([Pseudo]) >= 3);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Mail]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Mail] CHECK (LEN([Mail]) >= 5);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_BirthDatee_Min]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_BirthDatee_Min] CHECK ([BirthDate] >= GETDATE() - 365 * 10);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_BirthDate_Max]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_BirthDate_Max] CHECK ([BirthDate] <= GETDATE() - 365 * 120);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_DateRegist_Min]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_DateRegist_Min] CHECK ([DateRegist] > GETDATE() - 365 * 10);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_DateRegist_Max]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_DateRegist_Max] CHECK ([DateRegist] < GETDATE());


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Password]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Password] CHECK (LEN([Password]) >= 8);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Elo_Min]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Elo_Min] CHECK ([ELO] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Elo_Max]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Elo_Max] CHECK ([ELO] <= 3000);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_NbrPartPlayed_Min]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_NbrPartPlayed_Min] CHECK ([NbrPartPlayed] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_NbrPartWin_Min]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_NbrPartWin_Min] CHECK ([NbrPartWin] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_NbrPartWin_Max]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_NbrPartWin_Max] CHECK ([NbrPartWin] <= [NbrPartPlayed]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_NbrPartLost_Min]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_NbrPartLost_Min] CHECK ([NbrPartLost] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_NbrPartLost_Max]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_NbrPartLost_Max] CHECK ([NbrPartLost] <= [NbrPartPlayed]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_NbrPartDraw_Min]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_NbrPartDraw_Min] CHECK ([NbrPartDraw] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_NbrPartDraw_Max]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_NbrPartDraw_Max] CHECK ([NbrPartDraw] <= [NbrPartPlayed]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Score_Min]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Score_Min] CHECK ([Score] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Score_Max_A]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Score_Max_A] CHECK ([Score] <= 30000);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Score_Max_B]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Score_Max_B] CHECK ([Score] <= [NbrPartPlayed]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Score_Max_Total]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Score_Max_Total] CHECK ([Score] = ([NbrPartWin]+[NbrPartLost]+[NbrPartDraw]));


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Gender]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Gender] CHECK ([Gender] IN (0, 1));


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Person_Role]...';


GO
ALTER TABLE [dbo].[Person]
    ADD CONSTRAINT [CK_Person_Role] CHECK ([Role] IN (0, 1, 2));


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Id]...';


GO
ALTER TABLE [dbo].[Place]
    ADD CONSTRAINT [CK_Place_Id] CHECK ([Id_Place] BETWEEN 0 AND 128);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Name]...';


GO
ALTER TABLE [dbo].[Place]
    ADD CONSTRAINT [CK_Place_Name] CHECK (LEN([Nom]) BETWEEN 3 AND 100);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Place_Adress]...';


GO
ALTER TABLE [dbo].[Place]
    ADD CONSTRAINT [CK_Place_Adress] CHECK (LEN([Adresse]) BETWEEN 7 AND 500);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Role_Id]...';


GO
ALTER TABLE [dbo].[Role]
    ADD CONSTRAINT [CK_Role_Id] CHECK ([Id_Role] BETWEEN 0 AND 2);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Role_ValueRole]...';


GO
ALTER TABLE [dbo].[Role]
    ADD CONSTRAINT [CK_Role_ValueRole] CHECK ([ValueRole] IN (N'CheckMate', N'Player', N'User'));


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Status_Id]...';


GO
ALTER TABLE [dbo].[Status]
    ADD CONSTRAINT [CK_Status_Id] CHECK ([Id_Status] BETWEEN 0 AND 3);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Status_Value]...';


GO
ALTER TABLE [dbo].[Status]
    ADD CONSTRAINT [CK_Status_Value] CHECK ([Value_Status] IN (N'En attente de joueurs', N'en cours', N'terminé', N'annulé'));


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Id]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_Id] CHECK ([Id_Tournament] >=0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Name]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_Name] CHECK (LEN([Name_Tournament]) >= 2);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_PlayMin]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_PlayMin] CHECK ([PlayerMin] >= 2);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_PlayMax_min]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_PlayMax_min] CHECK ([PlayerMax] >= [PlayerMin]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_PlayMax_max]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_PlayMax_max] CHECK ([PlayerMax] <= 32);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Regist_min]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_Regist_min] CHECK ([NbrPlayerRegistered] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Regist_max]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_Regist_max] CHECK ([NbrPlayerRegistered] <= [PlayerMax]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_MinElo_min]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_MinElo_min] CHECK ([MinElo] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_MinElo_max]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_MinElo_max] CHECK ([MinElo] <= [MaxElo]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_MaxElo_min]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_MaxElo_min] CHECK ([MaxElo] >= [MinElo]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_MaxElo_max]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_MaxElo_max] CHECK ([MaxElo] <= 3000);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_DateCreation_A]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_DateCreation_A] CHECK ([DateCreation] <= GETDATE());


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_DateCreation_B]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_DateCreation_B] CHECK ([DateCreation] <= [DateEndRegisteration]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_DateLastMaj_A]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_DateLastMaj_A] CHECK ([DateLastMaj] <= GETDATE());


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_DateLastMaj_B]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_DateLastMaj_B] CHECK ([DateLastMaj] >= [DateCreation]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_DateEnd]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_DateEnd] CHECK ([DateEndRegisteration] > ([DateCreation]+[PlayerMax]));


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Nbr_Ronde_A]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_Nbr_Ronde_A] CHECK ([Nbr_Ronde] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Nbr_Ronde_B]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_Nbr_Ronde_B] CHECK ([Nbr_Ronde] <= (([PlayerMax]*[PlayerMax])-1));


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Place]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_Place] CHECK ([Id_Place] >= 0);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Tournament_Status]...';


GO
ALTER TABLE [dbo].[Tournament]
    ADD CONSTRAINT [CK_Tournament_Status] CHECK ([Id_Status] BETWEEN 0 AND 3);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Vue [dbo].[ViewCategory]...';


GO
CREATE VIEW [dbo].[ViewCategory]
	AS SELECT * FROM [dbo].[Category]
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Procédure [dbo].[CheckCategoryAgeExists]...';


GO
CREATE PROCEDURE CheckCategoryAgeExists
    @ExcludeId TINYINT,
    @MinAge TINYINT,
    @MaxAge TINYINT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] <> @ExcludeId AND
              ([MinAge] = @MinAge OR [MaxAge] = @MaxAge)
    )
    BEGIN
        PRINT 'Erreur : Âge minumum ou maximul déjà utilisé dans une autre catégorie.';
        RETURN;
    END
END;
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Procédure [dbo].[CheckCatNameExists]...';


GO
CREATE PROCEDURE CheckCatNameExists
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
        PRINT 'Erreur : Une catégorie avec cet ID ou ce nom existe déjà.';
        RETURN;
    END
END;
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Procédure [dbo].[DeleteCategory]...';


GO
CREATE PROCEDURE DeleteCategory
    @Id_Category TINYINT
AS
BEGIN
    -- Vérifier si la catégorie existe
    IF NOT EXISTS (
        SELECT 1 FROM [dbo].[Category]
        WHERE [Id_Category] = @Id_Category
    )
    BEGIN
        PRINT 'Erreur : Aucune catégorie trouvée avec cet ID.';
        RETURN;
    END

    -- Suppression
    BEGIN TRY
        DELETE FROM [dbo].[Category]
        WHERE [Id_Category] = @Id_Category;

        PRINT 'Catégorie supprimée avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Procédure [dbo].[UpdateCategory]...';


GO
CREATE PROCEDURE UpdateCategory
    @Id_Category TINYINT,
    @Name_Category NCHAR(7),
    @MinAge TINYINT,
    @MaxAge TINYINT
AS
BEGIN
    DECLARE @CurrentName NCHAR(7), @CurrentMinAge TINYINT, @CurrentMaxAge TINYINT;

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
        PRINT 'Erreur : Aucune catégorie trouvée avec cet ID.';
        RETURN;
    END

    -- Vérifier si les nouvelles valeurs sont différentes
    IF @CurrentName = @Name_Category AND @CurrentMinAge = @MinAge AND @CurrentMaxAge = @MaxAge
    BEGIN
        PRINT 'Aucune modification à apporter : les valeurs sont identiques.';
        RETURN;
    END

    -- Vérification que le nom n’est pas utilisé par une autre catégorie
    EXEC CheckCatNameExists @Id_Category, @Name_Category;

    -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC CheckCategoryAgeExists  @Id_Category, @MinAge, @MaxAge;


    -- Mise à jour
    BEGIN TRY
        UPDATE [dbo].[Category]
        SET [Name_Category] = @Name_Category,
            [MinAge] = @MinAge,
            [MaxAge] = @MaxAge
        WHERE [Id_Category] = @Id_Category;

        PRINT 'Catégorie mise à jour avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Création de Procédure [dbo].[AddCategory]...';


GO
CREATE PROCEDURE AddCategory
    @Name_Category NCHAR(7),
    @MinAge TINYINT,
    @MaxAge TINYINT
AS
BEGIN
    DECLARE @Id_Category TINYINT;

    -- Définir l'ID selon le nom
    SET @Id_Category = 
        CASE @Name_Category
            WHEN N'junior' THEN 0
            WHEN N'senior' THEN 1
            WHEN N'veteran' THEN 2
            ELSE -1 -- Valeur invalide, déclenchera une erreur
        END;

    IF @Id_Category = -1
    BEGIN
        PRINT 'Erreur : Nom de catégorie non reconnu.';
        RETURN;
    END

    -- Vérifier le nombre total de catégories existantes
    IF (SELECT COUNT(*) FROM [dbo].[Category]) > 3
    BEGIN
        PRINT 'Erreur : Limite de 3 catégories atteinte.';
        RETURN;
    END

    -- Vérifier si le nom de catégorie existe déjà
    EXEC CheckCatNameExists @Id_Category, @Name_Category;

     -- Vérification que MinAge ou MaxAge est déjà utilisé par une autre catégorie
    EXEC CheckCategoryAgeExists @MinAge, @MaxAge, @Id_Category;


    -- Insertion sécurisée
    BEGIN TRY
        INSERT INTO [dbo].[Category] ([Id_Category], [Name_Category], [MinAge], [MaxAge])
        VALUES (@Id_Category, @Name_Category, @MinAge, @MaxAge);

        PRINT 'Catégorie insérée avec succès.';
    END TRY
    BEGIN CATCH
        PRINT 'Erreur : ' + ERROR_MESSAGE();
    END CATCH
END;
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF OBJECT_ID(N'tempdb..#tmpErrors') IS NULL
    CREATE TABLE [#tmpErrors] (
        Error INT
    );

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'Succès de la mise à jour de la portion de base de données traitée.'
COMMIT TRANSACTION
END
ELSE PRINT N'Échec de la mise à jour de la portion de base de données traitée.'
GO
IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
GO
-- Étape de refactorisation pour mettre à jour le serveur cible avec des journaux de transactions déployés

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'bf9a652c-8804-4b3a-abf9-37083c750b9f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('bf9a652c-8804-4b3a-abf9-37083c750b9f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '54c8a616-92fa-4e6b-9259-0abb755c0e8a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('54c8a616-92fa-4e6b-9259-0abb755c0e8a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd17f169f-e11f-463d-aa37-f92b2521a9d0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d17f169f-e11f-463d-aa37-f92b2521a9d0')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '59bde7e4-8640-4617-8d15-9949603565fc')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('59bde7e4-8640-4617-8d15-9949603565fc')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '59a86454-d725-4997-bf89-cbb3b859e468')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('59a86454-d725-4997-bf89-cbb3b859e468')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e69976ed-f10d-48b6-9794-a97d27aa6c97')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e69976ed-f10d-48b6-9794-a97d27aa6c97')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd8b07b7a-95b1-4f94-a479-6f62ed855679')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d8b07b7a-95b1-4f94-a479-6f62ed855679')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd6934b1f-7075-43a7-8249-bafe5f92299a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d6934b1f-7075-43a7-8249-bafe5f92299a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b32eead0-7371-434a-b6b4-e52b771a5c90')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b32eead0-7371-434a-b6b4-e52b771a5c90')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ea465fda-ed3b-45fa-af33-d9c07bc111f5')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ea465fda-ed3b-45fa-af33-d9c07bc111f5')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '4d397606-ca2b-4e41-a7d6-0871c72e9911')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('4d397606-ca2b-4e41-a7d6-0871c72e9911')

GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Mise à jour terminée.';


GO
