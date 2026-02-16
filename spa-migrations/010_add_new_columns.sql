-- =============================================
-- Migration: 010_add_new_columns
-- Date: 2026-02-16
-- Description: Add new columns to existing tables to match SPA schema.
--   Adds columns to: Admin_Step, Admin_Step_i18n, EntityInCharge,
--   GenericRequirement, UnitInCharge, Media_i18n, Feedback, Filter,
--   Admin_StepSectionVisibility, Snapshot_Step, Snapshot_StepSectionVisibility
-- =============================================

BEGIN TRANSACTION
BEGIN TRY

    -- =============================================
    -- 1. Admin_Step: Add Level_Id, NumberOfUsers, Summary
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Level_Id' AND object_id = OBJECT_ID('dbo.Admin_Step'))
    BEGIN
        ALTER TABLE [dbo].[Admin_Step] ADD [Level_Id] [int] NULL
        PRINT 'Added Level_Id to Admin_Step'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfUsers' AND object_id = OBJECT_ID('dbo.Admin_Step'))
    BEGIN
        ALTER TABLE [dbo].[Admin_Step] ADD [NumberOfUsers] [int] NULL
        PRINT 'Added NumberOfUsers to Admin_Step'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Admin_Step'))
    BEGIN
        ALTER TABLE [dbo].[Admin_Step] ADD [Summary] [ntext] NULL
        PRINT 'Added Summary to Admin_Step'
    END

    -- =============================================
    -- 2. Admin_Step_i18n: Add Summary
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Admin_Step_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Admin_Step_i18n] ADD [Summary] [ntext] NULL
        PRINT 'Added Summary to Admin_Step_i18n'
    END

    -- =============================================
    -- 3. EntityInCharge: Add Zone_Id
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.EntityInCharge'))
    BEGIN
        ALTER TABLE [dbo].[EntityInCharge] ADD [Zone_Id] [int] NULL
        PRINT 'Added Zone_Id to EntityInCharge'
    END

    -- =============================================
    -- 4. GenericRequirement: Add IsEmittedByInstitution, NumberOfPages
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsEmittedByInstitution' AND object_id = OBJECT_ID('dbo.GenericRequirement'))
    BEGIN
        ALTER TABLE [dbo].[GenericRequirement] ADD [IsEmittedByInstitution] [bit] NOT NULL CONSTRAINT [DF_GenericRequirement_IsEmittedByInstitution] DEFAULT (0)
        PRINT 'Added IsEmittedByInstitution to GenericRequirement'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfPages' AND object_id = OBJECT_ID('dbo.GenericRequirement'))
    BEGIN
        ALTER TABLE [dbo].[GenericRequirement] ADD [NumberOfPages] [int] NOT NULL CONSTRAINT [DF_GenericRequirement_NumberOfPages] DEFAULT (0)
        PRINT 'Added NumberOfPages to GenericRequirement'
    END

    -- =============================================
    -- 5. UnitInCharge: Add Website
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.UnitInCharge'))
    BEGIN
        ALTER TABLE [dbo].[UnitInCharge] ADD [Website] [nvarchar](255) NULL
        PRINT 'Added Website to UnitInCharge'
    END

    -- =============================================
    -- 6. Media_i18n: Add FileName, Extention, Description, Length, PreviewImageName
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'FileName' AND object_id = OBJECT_ID('dbo.Media_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Media_i18n] ADD [FileName] [nvarchar](500) NULL
        PRINT 'Added FileName to Media_i18n'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Extention' AND object_id = OBJECT_ID('dbo.Media_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Media_i18n] ADD [Extention] [nvarchar](15) NULL
        PRINT 'Added Extention to Media_i18n'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Description' AND object_id = OBJECT_ID('dbo.Media_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Media_i18n] ADD [Description] [ntext] NULL
        PRINT 'Added Description to Media_i18n'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Length' AND object_id = OBJECT_ID('dbo.Media_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Media_i18n] ADD [Length] [decimal](18, 0) NULL
        PRINT 'Added Length to Media_i18n'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'PreviewImageName' AND object_id = OBJECT_ID('dbo.Media_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Media_i18n] ADD [PreviewImageName] [nvarchar](100) NULL
        PRINT 'Added PreviewImageName to Media_i18n'
    END

    -- =============================================
    -- 7. Feedback: Add Status
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Status' AND object_id = OBJECT_ID('dbo.Feedback'))
    BEGIN
        ALTER TABLE [dbo].[Feedback] ADD [Status] [int] NULL
        PRINT 'Added Status to Feedback'
    END

    -- =============================================
    -- 8. Filter: Add IsProductRelated
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsProductRelated' AND object_id = OBJECT_ID('dbo.Filter'))
    BEGIN
        ALTER TABLE [dbo].[Filter] ADD [IsProductRelated] [bit] NOT NULL CONSTRAINT [DF_Filter_IsProductRelated] DEFAULT (0)
        PRINT 'Added IsProductRelated to Filter'
    END

    -- =============================================
    -- 9. Admin_StepSectionVisibility: Add IsSummaryVisible
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsSummaryVisible' AND object_id = OBJECT_ID('dbo.Admin_StepSectionVisibility'))
    BEGIN
        ALTER TABLE [dbo].[Admin_StepSectionVisibility] ADD [IsSummaryVisible] [bit] NOT NULL CONSTRAINT [DF_Admin_StepSectionVisibility_IsSummaryVisible] DEFAULT (1)
        PRINT 'Added IsSummaryVisible to Admin_StepSectionVisibility'
    END

    -- =============================================
    -- 10. Snapshot_Step: Add Level_Id, NumberOfUsers, Summary
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Level_Id' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_Step] ADD [Level_Id] [int] NULL
        PRINT 'Added Level_Id to Snapshot_Step'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfUsers' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_Step] ADD [NumberOfUsers] [int] NULL
        PRINT 'Added NumberOfUsers to Snapshot_Step'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_Step] ADD [Summary] [ntext] NULL
        PRINT 'Added Summary to Snapshot_Step'
    END

    -- =============================================
    -- 11. Snapshot_StepSectionVisibility: Add IsSummaryVisible
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsSummaryVisible' AND object_id = OBJECT_ID('dbo.Snapshot_StepSectionVisibility'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepSectionVisibility] ADD [IsSummaryVisible] [bit] NOT NULL CONSTRAINT [DF_Snapshot_StepSectionVisibility_IsSummaryVisible] DEFAULT (1)
        PRINT 'Added IsSummaryVisible to Snapshot_StepSectionVisibility'
    END

    COMMIT TRANSACTION
    PRINT '========================================='
    PRINT 'Migration 010_add_new_columns completed successfully'
    PRINT '========================================='
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Migration 010_add_new_columns FAILED: ' + ERROR_MESSAGE()
    ;THROW
END CATCH
GO
