USE KN_online
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[CREATE_NEW_CHAR]') AND OBJECTPROPERTY(ID, 'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[CREATE_NEW_CHAR]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.CREATE_NEW_CHAR    Script Date: 6/6/2006 6:03:33 PM ******/
-- scripted by samma
-- 2002 samma
-- 2003 sungyong
-- 2022 can_snoxd
CREATE PROCEDURE [dbo].[CREATE_NEW_CHAR]
@nRet			smallint OUTPUT, 
@AccountID		varchar(21), 
@index			tinyint,
@CharID			varchar(21),
@Race			tinyint, 
@Class			smallint, 
@Hair			tinyint,
@Face			tinyint, 
@Str			tinyint, 
@Sta			tinyint, 
@Dex			tinyint,
@Intel			tinyint, 
@Cha			tinyint
AS
-- Non English Dupe Fix
IF dbo.IsValidCharacters(@AccountID) = 1 or dbo.IsValidCharacters(@CharID) = 1
BEGIN
--Error Number
SET @nRet = 5
RETURN
END
-- Fix Ends
DECLARE @Row tinyint, @bCharNum tinyint, @Nation tinyint, @Zone tinyint, @PosX int, @PosZ int
SELECT @Nation = bNation, @bCharNum = bCharNum FROM ACCOUNT_CHAR WHERE strAccountID = @AccountID
IF @bCharNum >= 3    SET @nRet =  1
IF @Nation = 1 AND @Race > 10    SET @nRet = 2
ELSE IF @Nation = 2 AND @Race < 10    SET @nRet = 2
ELSE IF @Nation <>1 AND @Nation <> 2    SET @nRet = 2
IF @nRet > 0
RETURN
SELECT @Row = COUNT(*) FROM USERDATA WHERE strUserId = @CharID
IF @Row > 0 
BEGIN
SET @nRet =  3
RETURN
END
/*1097 Default spawn , if you want to send users breth/piana*/
--SET @Zone = @Nation
SET @Zone=21
SELECT @PosX = InitX, @PosZ = InitZ  FROM ZONE_INFO WHERE ZoneNo = @Zone
--Lvl 1 Hack Fix (credits TomatoDePotato)
IF @Nation = 1 
IF @Class = 105 
OR @Class = 106 
OR @Class = 107 
OR @Class = 108 
OR @Class = 109 
OR @Class = 110 
OR @Class = 111 
OR @Class = 112 
BEGIN 
SET @nRet = 4 -- Dont allow new KA characters with master status. 
RETURN 
END 
ELSE IF @Nation = 2 
IF @Class = 205 
OR @Class = 206 
OR @Class = 207 
OR @Class = 208 
OR @Class = 209 
OR @Class = 210 
OR @Class = 211 
OR @Class = 212 
BEGIN 
SET @nRet = 4 -- Dont allow new EL characters with master status. 
RETURN 
END
BEGIN TRAN
IF @index = 0
UPDATE ACCOUNT_CHAR SET strCharID1 = @CharID, bCharNum = bCharNum + 1 WHERE strAccountID = @AccountID AND strCharID1 IS NULL
ELSE IF @index = 1
UPDATE ACCOUNT_CHAR SET strCharID2 = @CharID, bCharNum = bCharNum + 1 WHERE strAccountID = @AccountID AND strCharID2 IS NULL
ELSE IF @index = 2
UPDATE ACCOUNT_CHAR SET strCharID3 = @CharID, bCharNum = bCharNum + 1 WHERE strAccountID = @AccountID AND strCharID3 IS NULL
IF ((SELECT bCharNum FROM ACCOUNT_CHAR WHERE strAccountID = @AccountID) != @bCharNum + 1)
BEGIN     
ROLLBACK TRAN 
SET @nRet =  4
RETURN
END
INSERT INTO USERDATA (strUserId, Nation, Race, Class, HairColor, Face, Strong, Sta, Dex, Intel, Cha, Zone, PX, PZ ) 
VALUES     (@CharID, @Nation, @Race, @Class, @Hair, @Face, @Str, @Sta, @Dex, @Intel, @Cha, @Zone, @PosX, @PosZ )
IF @@ERROR <> 0
BEGIN     
ROLLBACK TRAN 
SET @nRet =  4
RETURN
END  
COMMIT TRAN
SET @nRet =  0
GO
Print 'Procedure Fixed'
Print 'DONE'