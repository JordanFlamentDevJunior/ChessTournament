CREATE TABLE [dbo].[Place]
(
	[Id_Place] INT NOT NULL PRIMARY KEY, 
    [Name_Place] NCHAR(100) NOT NULL, 
    [Address] NCHAR(500) NOT NULL,
    -- soit postale soit web

    CONSTRAINT [CK_Place_Name] CHECK (LEN([Name_Place]) BETWEEN 2 AND 100),
    CONSTRAINT [CK_Place_Address] CHECK (LEN([Address]) BETWEEN 7 AND 500)
)
