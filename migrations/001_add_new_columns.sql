-- =============================================
-- Migration: 001_add_new_columns
-- Description: Add new columns to existing tables to match EF6 schema
-- Target: Old-structure database (run in SSMS)
-- =============================================

PRINT 'Starting migration 001_add_new_columns...'
PRINT 'Target: Add new columns to existing tables'
PRINT ''

-- =============================================
-- ADMIN_STEP TABLE
-- =============================================
PRINT 'Processing Admin_Step table...'

-- Add Level_Id column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Level_Id' AND object_id = OBJECT_ID('dbo.Admin_Step'))
BEGIN
    ALTER TABLE [dbo].[Admin_Step] ADD [Level_Id] [int] NULL
    PRINT '  Added column: Level_Id'
END
ELSE
    PRINT '  Column already exists: Level_Id'
GO

-- Add NumberOfUsers column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfUsers' AND object_id = OBJECT_ID('dbo.Admin_Step'))
BEGIN
    ALTER TABLE [dbo].[Admin_Step] ADD [NumberOfUsers] [int] NULL
    PRINT '  Added column: NumberOfUsers'
END
ELSE
    PRINT '  Column already exists: NumberOfUsers'
GO

-- Add Summary column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Admin_Step'))
BEGIN
    ALTER TABLE [dbo].[Admin_Step] ADD [Summary] [ntext] NULL
    PRINT '  Added column: Summary'
END
ELSE
    PRINT '  Column already exists: Summary'
GO

-- Add IsReachingOffice column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsReachingOffice' AND object_id = OBJECT_ID('dbo.Admin_Step'))
BEGIN
    ALTER TABLE [dbo].[Admin_Step] ADD [IsReachingOffice] [bit] NULL
    PRINT '  Added column: IsReachingOffice'
END
ELSE
    PRINT '  Column already exists: IsReachingOffice'
GO

-- =============================================
-- ENTITYINCHARGE TABLE
-- =============================================
PRINT ''
PRINT 'Processing EntityInCharge table...'

-- Add Zone_Id column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.EntityInCharge'))
BEGIN
    ALTER TABLE [dbo].[EntityInCharge] ADD [Zone_Id] [int] NULL
    PRINT '  Added column: Zone_Id'
END
ELSE
    PRINT '  Column already exists: Zone_Id'
GO

-- =============================================
-- GENERICREQUIREMENT TABLE
-- =============================================
PRINT ''
PRINT 'Processing GenericRequirement table...'

-- Add NumberOfPages column with default value
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfPages' AND object_id = OBJECT_ID('dbo.GenericRequirement'))
BEGIN
    ALTER TABLE [dbo].[GenericRequirement] ADD [NumberOfPages] [int] NOT NULL CONSTRAINT [DF_GenericRequirement_NumberOfPages] DEFAULT (0)
    PRINT '  Added column: NumberOfPages (with default 0)'
END
ELSE
    PRINT '  Column already exists: NumberOfPages'
GO

-- =============================================
-- ADMIN_STEPRESULT TABLE
-- =============================================
PRINT ''
PRINT 'Processing Admin_StepResult table...'

-- Add Document_Id column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Document_Id' AND object_id = OBJECT_ID('dbo.Admin_StepResult'))
BEGIN
    ALTER TABLE [dbo].[Admin_StepResult] ADD [Document_Id] [int] NULL
    PRINT '  Added column: Document_Id'
END
ELSE
    PRINT '  Column already exists: Document_Id'
GO

-- =============================================
-- ADMIN_STEPREQUIREMENT TABLE
-- =============================================
PRINT ''
PRINT 'Processing Admin_StepRequirement table...'

-- Add IsEmittedByInstitution column with default value
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsEmittedByInstitution' AND object_id = OBJECT_ID('dbo.Admin_StepRequirement'))
BEGIN
    ALTER TABLE [dbo].[Admin_StepRequirement] ADD [IsEmittedByInstitution] [bit] NOT NULL CONSTRAINT [DF_Admin_StepRequirement_IsEmittedByInstitution] DEFAULT (0)
    PRINT '  Added column: IsEmittedByInstitution (with default 0)'
END
ELSE
    PRINT '  Column already exists: IsEmittedByInstitution'
GO

-- =============================================
-- ADMIN_STEP_I18N TABLE (Summary column for translations)
-- =============================================
PRINT ''
PRINT 'Processing Admin_Step_i18n table...'

-- Add Summary column to i18n table
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Admin_Step_i18n'))
BEGIN
    ALTER TABLE [dbo].[Admin_Step_i18n] ADD [Summary] [ntext] NULL
    PRINT '  Added column: Summary'
END
ELSE
    PRINT '  Column already exists: Summary'
GO

-- =============================================
-- SNAPSHOT_STEP TABLE
-- =============================================
PRINT ''
PRINT 'Processing Snapshot_Step table...'

-- Add Level_Id column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Level_Id' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
BEGIN
    ALTER TABLE [dbo].[Snapshot_Step] ADD [Level_Id] [int] NULL
    PRINT '  Added column: Level_Id'
END
ELSE
    PRINT '  Column already exists: Level_Id'
GO

-- Add NumberOfUsers column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfUsers' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
BEGIN
    ALTER TABLE [dbo].[Snapshot_Step] ADD [NumberOfUsers] [int] NULL
    PRINT '  Added column: NumberOfUsers'
END
ELSE
    PRINT '  Column already exists: NumberOfUsers'
GO

-- Add Summary column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
BEGIN
    ALTER TABLE [dbo].[Snapshot_Step] ADD [Summary] [ntext] NULL
    PRINT '  Added column: Summary'
END
ELSE
    PRINT '  Column already exists: Summary'
GO

-- Add IsReachingOffice column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsReachingOffice' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
BEGIN
    ALTER TABLE [dbo].[Snapshot_Step] ADD [IsReachingOffice] [bit] NULL
    PRINT '  Added column: IsReachingOffice'
END
ELSE
    PRINT '  Column already exists: IsReachingOffice'
GO

-- =============================================
-- SNAPSHOT_STEPENTITYINCHARGE TABLE
-- =============================================
PRINT ''
PRINT 'Processing Snapshot_StepEntityInCharge table...'

-- Add Zone_Id column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.Snapshot_StepEntityInCharge'))
BEGIN
    ALTER TABLE [dbo].[Snapshot_StepEntityInCharge] ADD [Zone_Id] [int] NULL
    PRINT '  Added column: Zone_Id'
END
ELSE
    PRINT '  Column already exists: Zone_Id'
GO

-- =============================================
-- SNAPSHOT_STEPRESULT TABLE
-- =============================================
PRINT ''
PRINT 'Processing Snapshot_StepResult table...'

-- Add Document_Id column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Document_Id' AND object_id = OBJECT_ID('dbo.Snapshot_StepResult'))
BEGIN
    ALTER TABLE [dbo].[Snapshot_StepResult] ADD [Document_Id] [int] NULL
    PRINT '  Added column: Document_Id'
END
ELSE
    PRINT '  Column already exists: Document_Id'
GO

-- Add Document_Type column (from new schema)
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Document_Type' AND object_id = OBJECT_ID('dbo.Snapshot_StepResult'))
BEGIN
    ALTER TABLE [dbo].[Snapshot_StepResult] ADD [Document_Type] [nvarchar](50) NULL
    PRINT '  Added column: Document_Type'
END
ELSE
    PRINT '  Column already exists: Document_Type'
GO

-- =============================================
-- SNAPSHOT_STEPREQUIREMENT TABLE
-- =============================================
PRINT ''
PRINT 'Processing Snapshot_StepRequirement table...'

-- Add IsEmittedByInstitution column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsEmittedByInstitution' AND object_id = OBJECT_ID('dbo.Snapshot_StepRequirement'))
BEGIN
    ALTER TABLE [dbo].[Snapshot_StepRequirement] ADD [IsEmittedByInstitution] [bit] NOT NULL CONSTRAINT [DF_Snapshot_StepRequirement_IsEmittedByInstitution] DEFAULT (0)
    PRINT '  Added column: IsEmittedByInstitution (with default 0)'
END
ELSE
    PRINT '  Column already exists: IsEmittedByInstitution'
GO

PRINT ''
PRINT '============================================='
PRINT 'Migration 001_add_new_columns completed!'
PRINT '============================================='
GO
