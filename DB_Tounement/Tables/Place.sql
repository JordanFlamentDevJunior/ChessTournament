CREATE TABLE [dbo].[Place]
(
	[Id_Place] TINYINT NOT NULL PRIMARY KEY, 
    [Nom] NCHAR(100) NOT NULL, 
    [Adresse] NCHAR(500) NOT NULL,
    -- soit postale soit web

    CONSTRAINT [CK_Place_Id] CHECK ([Id_Place] BETWEEN 0 AND 128),
    CONSTRAINT [CK_Place_Name] CHECK (LEN([Nom]) BETWEEN 3 AND 100),
    CONSTRAINT [CK_Place_Adress] CHECK (LEN([Adresse]) BETWEEN 7 AND 500)
)
