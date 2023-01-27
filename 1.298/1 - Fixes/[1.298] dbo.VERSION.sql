USE KN_online
GO
IF EXISTS (SELECT * FROM dbo.SYSOBJECTS WHERE ID = OBJECT_ID('[dbo].[VERSION]') AND OBJECTPROPERTY(ID, 'ISUSERTABLE') = 1)
DROP TABLE [dbo].[VERSION]
GO
/* Version/Launcher Fix 1.298
VersionTable = "1" must be 0 in login-server.conf settings */
/****** Object:  Table [dbo].[VERSION]    Script Date: 08/18/2022 15:36:44 ******/
-- 2022 can_snoxd
SET NOCOUNT ON
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
Print 'Table Procedure Fixed'
CREATE TABLE [dbo].[VERSION](
[version] [smallint] NULL,
[filename] [varchar](50) NULL,
[compname] [varchar](50) NULL,
[hisversion] [smallint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
Print 'Table Data Fixed'
INSERT [dbo].[VERSION] ([version], [filename], [compname], [hisversion]) VALUES (1298,'1298.zip','1298.zip',1297)
Print 'DONE'