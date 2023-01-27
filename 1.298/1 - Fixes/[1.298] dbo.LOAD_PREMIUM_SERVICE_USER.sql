USE KN_online
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[LOAD_PREMIUM_SERVICE_USER]') AND OBJECTPROPERTY(ID, 'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[LOAD_PREMIUM_SERVICE_USER]
GO
/****** Object:  StoredProcedure [dbo].[LOAD_PREMIUM_SERVICE_USER]    Script Date: 06/30/2009 01:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LOAD_PREMIUM_SERVICE_USER] 
@account		varchar(21),
@kofans			int OUTPUT,
@day			int OUTPUT
/* Premium Fixed by can_snoxd make sure add PremiumType column on TB_USER (int) */
AS 
BEGIN
-- If premium type is null set to bronze premium (3 day beginner premium fix)
UPDATE TB_USER SET PremiumType = '1' WHERE PremiumType = NULL
-- Declare the variable @PremiumExpire (the date when the premium service expires)
DECLARE @type int , @tian datetime
-- Retrieve the date the premium service expires
SELECT @tian=PremiumExpire,@type=premiumtype from TB_USER WHERE straccountid=@account
-- Set the number of days left to
-- the day difference between the current time 
-- and the date the premium service expires
SET @day = DateDiff(dd, getDate(), @tian)
-- This part adds PremiumType (1 Bronze , 2 Silver , 3 Gold)
SET @kofans=@type
-- If the days are 0
-- or there's some error
-- or the day count for whatever reason is empty/null
IF @day <= 0 or @@ERROR <> 0 or @day is null
BEGIN
-- House cleaning:
-- Setting the two below variables to 0 just in case.
SET @type = 0
SET @day = 0
END
RETURN 
END 
GO
Print 'Procedure Fixed'
Print 'DONE'