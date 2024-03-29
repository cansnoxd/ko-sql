USE KN_online
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[ACCOUNT_LOGIN]') AND OBJECTPROPERTY(ID, 'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[ACCOUNT_LOGIN]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Pretty much everything fixed here*/
/****** Object:  Stored Procedure dbo.ACCOUNT_LOGIN    Script Date: 6/6/2006 6:03:33 PM ******/
-- 2023 can_snoxd
CREATE PROCEDURE [dbo].[ACCOUNT_LOGIN]
@AccountID		varchar(21),
@Password		varchar(13),
@nRet			smallint	OUTPUT
AS
DECLARE @pwd varchar(13), @Authority int, @count int, @Nation int, @CharNum int
BEGIN
--Update PremiumExpire (3 Day Premium)
UPDATE TB_USER SET PremiumExpire = GETDATE()+3 WHERE PremiumExpire = NULL
--Retrieve Account Data
SELECT @pwd = strPasswd, @Authority = strAuthority FROM TB_USER WHERE strAccountID = @AccountID
-- Account Does not Exist
IF @@ROWCOUNT = 0 
BEGIN
SET @nRet = 0
RETURN
END
-- Banned
IF @Authority = 255
BEGIN
SET @nRet = 0
RETURN
END
-- Empty Pass
ELSE IF @pwd IS NULL
BEGIN
SET @nRet = 0
RETURN
END
--Retrieve Nation and Character Count
SELECT @Nation = bNation, @CharNum = bCharNum FROM ACCOUNT_CHAR WHERE strAccountID = @AccountID
--No Nation Selected
IF @@ROWCOUNT = 0 OR @CharNum = 0
BEGIN
SET @nRet = 1
END
ELSE
--Nation Already Selected
BEGIN
SET @nRet = @Nation + 1
END
END
GO
Print 'Procedure Fixed'
Print 'DONE'