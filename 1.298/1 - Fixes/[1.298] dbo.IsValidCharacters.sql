USE KN_online
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[IsValidCharacters]') AND OBJECTPROPERTY(ID, 'ISSCALARFUNCTION') = 1)
DROP FUNCTION [dbo].[IsValidCharacters]
GO
/* ASCI Dupe Fix (AKA Turkish Name Abuse)*/
/****** Object:  Stored Procedure dbo.CREATE_NEW_CHAR    Script Date: 6/6/2006 6:03:33 PM ******/
-- Kofans
-- 2022 can_snoxd
CREATE FUNCTION [dbo].[IsValidCharacters](@SData varchar(8000))
RETURNS INT 
AS
BEGIN
DECLARE @SDataLen int
DECLARE @Loop int
DECLARE @Letter varchar(1)
DECLARE @RXLetters varchar(8000)
DECLARE @Match tinyint
--Characters Allowed
SET @RXLetters = 'qwertyuopasdfghjklizxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890_'
SET @SDataLen = LEN(@SData)
SET @Loop = 1
SET @Match = 0
WHILE @Loop <= (@SDataLen)
BEGIN
SET @Letter = RTRIM(LTRIM(SUBSTRING(@SData,@Loop,1)))
IF CHARINDEX(@Letter,@RXLetters) = 0
BEGIN
SET @Match = 1
BREAK
END
SET @Loop = @Loop + 1
END
RETURN @Match
END
GO
Print 'Table Procedure Fixed'
Print 'DONE'