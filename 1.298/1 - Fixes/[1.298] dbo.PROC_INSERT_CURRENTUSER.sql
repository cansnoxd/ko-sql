USE KN_online
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[PROC_INSERT_CURRENTUSER]') AND OBJECTPROPERTY(ID, 'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[PROC_INSERT_CURRENTUSER]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_CURRENTUSER]    Script Date: 6/6/2006 6:03:33 PM ******/
-- scripted by samma
-- 2002 samma
-- 2003 sungyong
-- 2022 can_snoxd
CREATE PROCEDURE [dbo].[PROC_INSERT_CURRENTUSER]
@AccountID			varchar(50),
@CharID				varchar(50),
@ServerNo			int, 
@ServerIP			varchar(50),
@ClientIP			varchar(50),
@nret				smallint output 
AS
BEGIN
INSERT INTO CURRENTUSER (nServerNo, strServerIP,  strAccountID, strCharID, strClientIP )  Values  (@ServerNo, @ServerIP, @AccountID, @CharID, @ClientIP )
--Name change hack packet block
DECLARE @RAccountID char(21)
SELECT @RAccountID = strAccountID FROM ACCOUNT_CHAR WHERE strCharID1 = @CharID and strCharID1 IS NOT NULL
SELECT @RAccountID = strAccountID FROM ACCOUNT_CHAR WHERE strCharID2 = @CharID and strCharID2 IS NOT NULL
SELECT @RAccountID = strAccountID FROM ACCOUNT_CHAR WHERE strCharID3 = @CharID and strCharID3 IS NOT NULL
IF @RAccountID IS NULL
BEGIN
SET @nRet = 0
RETURN
END
ELSE IF @RAccountID = ''
BEGIN
SET @nRet = 0
RETURN
END
ELSE IF @RAccountID <> @AccountID
BEGIN
SET @nRet = 0
RETURN
END
ELSE
BEGIN
SET @nRet = 1
RETURN
END      
RETURN
END
GO
Print 'Procedure Fixed'
Print 'DONE'