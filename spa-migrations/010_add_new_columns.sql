-- =============================================
-- Migration: 010_add_new_columns
-- Date: 2026-02-16
-- Description: Add new columns to 22 existing tables (12 base + 10 snapshot)
--              and modify 2 column types on Feedback table.
--              Based on Libya SPA schema (30-dbe-Libya, compat 110).
-- Execution: Run in SSMS against the old-structure database
-- Dependencies: None (first migration script)
-- =============================================

SET NOCOUNT ON;

PRINT '=== Migration 010: Add New Columns ==='
PRINT 'Started at: ' + CONVERT(varchar(30), GETDATE(), 120)
PRINT ''

BEGIN TRANSACTION
BEGIN TRY

    -- =========================================
    -- SECTION 1: Base Tables (12 tables)
    -- =========================================

    PRINT '--- Section 1: Base Table Column Additions ---'

    -- 1. Admin_Step: +Level_Id (int NULL), +NumberOfUsers (int NULL), +Summary (ntext NULL), +IsReachingOffice (bit NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Level_Id' AND object_id = OBJECT_ID('dbo.Admin_Step'))
    BEGIN
        ALTER TABLE [dbo].[Admin_Step] ADD [Level_Id] [int] NULL
        PRINT '  Added Admin_Step.Level_Id'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfUsers' AND object_id = OBJECT_ID('dbo.Admin_Step'))
    BEGIN
        ALTER TABLE [dbo].[Admin_Step] ADD [NumberOfUsers] [int] NULL
        PRINT '  Added Admin_Step.NumberOfUsers'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Admin_Step'))
    BEGIN
        ALTER TABLE [dbo].[Admin_Step] ADD [Summary] [ntext] NULL
        PRINT '  Added Admin_Step.Summary'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsReachingOffice' AND object_id = OBJECT_ID('dbo.Admin_Step'))
    BEGIN
        ALTER TABLE [dbo].[Admin_Step] ADD [IsReachingOffice] [bit] NULL
        PRINT '  Added Admin_Step.IsReachingOffice'
    END

    -- 2. Admin_Step_i18n: +Summary (ntext NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Admin_Step_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Admin_Step_i18n] ADD [Summary] [ntext] NULL
        PRINT '  Added Admin_Step_i18n.Summary'
    END

    -- 3. Admin_StepRequirement: +IsEmittedByInstitution (bit NOT NULL DEFAULT 0)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsEmittedByInstitution' AND object_id = OBJECT_ID('dbo.Admin_StepRequirement'))
    BEGIN
        ALTER TABLE [dbo].[Admin_StepRequirement] ADD [IsEmittedByInstitution] [bit] NOT NULL CONSTRAINT [DF_Admin_StepRequirement_IsEmittedByInstitution] DEFAULT (0)
        PRINT '  Added Admin_StepRequirement.IsEmittedByInstitution'
    END

    -- 4. Admin_StepSectionVisibility: +IsSummaryVisible (bit NOT NULL DEFAULT 1)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsSummaryVisible' AND object_id = OBJECT_ID('dbo.Admin_StepSectionVisibility'))
    BEGIN
        ALTER TABLE [dbo].[Admin_StepSectionVisibility] ADD [IsSummaryVisible] [bit] NOT NULL CONSTRAINT [DF_Admin_StepSectionVisibility_IsSummaryVisible] DEFAULT (1)
        PRINT '  Added Admin_StepSectionVisibility.IsSummaryVisible'
    END

    -- 5. EntityInCharge: +Zone_Id (int NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.EntityInCharge'))
    BEGIN
        ALTER TABLE [dbo].[EntityInCharge] ADD [Zone_Id] [int] NULL
        PRINT '  Added EntityInCharge.Zone_Id'
    END

    -- 6. Feedback: +Status (int NOT NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Status' AND object_id = OBJECT_ID('dbo.Feedback'))
    BEGIN
        ALTER TABLE [dbo].[Feedback] ADD [Status] [int] NOT NULL CONSTRAINT [DF_Feedback_Status] DEFAULT (0)
        PRINT '  Added Feedback.Status'
    END

    -- 7. Filter: +IsProductRelated (bit NOT NULL DEFAULT 0)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsProductRelated' AND object_id = OBJECT_ID('dbo.Filter'))
    BEGIN
        ALTER TABLE [dbo].[Filter] ADD [IsProductRelated] [bit] NOT NULL CONSTRAINT [DF_Filter_IsProductRelated] DEFAULT (0)
        PRINT '  Added Filter.IsProductRelated'
    END

    -- 8. GenericRequirement: +NumberOfPages (int NOT NULL DEFAULT 1)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfPages' AND object_id = OBJECT_ID('dbo.GenericRequirement'))
    BEGIN
        ALTER TABLE [dbo].[GenericRequirement] ADD [NumberOfPages] [int] NOT NULL CONSTRAINT [DF_GenericRequirement_NumberOfPages] DEFAULT (1)
        PRINT '  Added GenericRequirement.NumberOfPages'
    END

    -- 9. Media_i18n: +FileName, +Extention, +Description, +Length, +PreviewImageName
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'FileName' AND object_id = OBJECT_ID('dbo.Media_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Media_i18n] ADD [FileName] [nvarchar](500) NULL
        PRINT '  Added Media_i18n.FileName'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Extention' AND object_id = OBJECT_ID('dbo.Media_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Media_i18n] ADD [Extention] [nvarchar](15) NULL
        PRINT '  Added Media_i18n.Extention'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Description' AND object_id = OBJECT_ID('dbo.Media_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Media_i18n] ADD [Description] [ntext] NULL
        PRINT '  Added Media_i18n.Description'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Length' AND object_id = OBJECT_ID('dbo.Media_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Media_i18n] ADD [Length] [decimal](18, 0) NULL
        PRINT '  Added Media_i18n.Length'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'PreviewImageName' AND object_id = OBJECT_ID('dbo.Media_i18n'))
    BEGIN
        ALTER TABLE [dbo].[Media_i18n] ADD [PreviewImageName] [nvarchar](100) NULL
        PRINT '  Added Media_i18n.PreviewImageName'
    END

    -- 10. Public_Team_Member: +Phone (nvarchar(50) NULL), +Email (nvarchar(100) NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Phone' AND object_id = OBJECT_ID('dbo.Public_Team_Member'))
    BEGIN
        ALTER TABLE [dbo].[Public_Team_Member] ADD [Phone] [nvarchar](50) NULL
        PRINT '  Added Public_Team_Member.Phone'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Email' AND object_id = OBJECT_ID('dbo.Public_Team_Member'))
    BEGIN
        ALTER TABLE [dbo].[Public_Team_Member] ADD [Email] [nvarchar](100) NULL
        PRINT '  Added Public_Team_Member.Email'
    END

    -- 11. UnitInCharge: +Website (nvarchar(255) NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.UnitInCharge'))
    BEGIN
        ALTER TABLE [dbo].[UnitInCharge] ADD [Website] [nvarchar](255) NULL
        PRINT '  Added UnitInCharge.Website'
    END

    -- 12. UnitInCharge_i18n: +Website (nvarchar(255) NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.UnitInCharge_i18n'))
    BEGIN
        ALTER TABLE [dbo].[UnitInCharge_i18n] ADD [Website] [nvarchar](255) NULL
        PRINT '  Added UnitInCharge_i18n.Website'
    END

    -- =========================================
    -- SECTION 2: Snapshot Tables (10 tables)
    -- =========================================

    PRINT ''
    PRINT '--- Section 2: Snapshot Table Column Additions ---'

    -- 13. Snapshot_Objective: +ExplanatoryText (ntext NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ExplanatoryText' AND object_id = OBJECT_ID('dbo.Snapshot_Objective'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_Objective] ADD [ExplanatoryText] [ntext] NULL
        PRINT '  Added Snapshot_Objective.ExplanatoryText'
    END

    -- 14. Snapshot_Step: +Level_Id, +NumberOfUsers, +Summary, +IsReachingOffice
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Level_Id' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_Step] ADD [Level_Id] [int] NULL
        PRINT '  Added Snapshot_Step.Level_Id'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfUsers' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_Step] ADD [NumberOfUsers] [int] NULL
        PRINT '  Added Snapshot_Step.NumberOfUsers'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_Step] ADD [Summary] [ntext] NULL
        PRINT '  Added Snapshot_Step.Summary'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsReachingOffice' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_Step] ADD [IsReachingOffice] [bit] NULL
        PRINT '  Added Snapshot_Step.IsReachingOffice'
    END

    -- 15. Snapshot_StepEntityInCharge: +Zone_Id (int NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.Snapshot_StepEntityInCharge'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepEntityInCharge] ADD [Zone_Id] [int] NULL
        PRINT '  Added Snapshot_StepEntityInCharge.Zone_Id'
    END

    -- 16. Snapshot_StepRecourseEntityInCharge: +Zone_Id (int NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.Snapshot_StepRecourseEntityInCharge'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepRecourseEntityInCharge] ADD [Zone_Id] [int] NULL
        PRINT '  Added Snapshot_StepRecourseEntityInCharge.Zone_Id'
    END

    -- 17. Snapshot_StepRecourseUnitInCharge: +Website (nvarchar(255) NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.Snapshot_StepRecourseUnitInCharge'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepRecourseUnitInCharge] ADD [Website] [nvarchar](255) NULL
        PRINT '  Added Snapshot_StepRecourseUnitInCharge.Website'
    END

    -- 18. Snapshot_StepRegionalEntityInCharge: +GoogleMapsURL, +Zone_Id
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'GoogleMapsURL' AND object_id = OBJECT_ID('dbo.Snapshot_StepRegionalEntityInCharge'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepRegionalEntityInCharge] ADD [GoogleMapsURL] [nvarchar](800) NULL
        PRINT '  Added Snapshot_StepRegionalEntityInCharge.GoogleMapsURL'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.Snapshot_StepRegionalEntityInCharge'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepRegionalEntityInCharge] ADD [Zone_Id] [int] NULL
        PRINT '  Added Snapshot_StepRegionalEntityInCharge.Zone_Id'
    END

    -- 19. Snapshot_StepRegionalUnitInCharge: +Website (nvarchar(255) NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.Snapshot_StepRegionalUnitInCharge'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepRegionalUnitInCharge] ADD [Website] [nvarchar](255) NULL
        PRINT '  Added Snapshot_StepRegionalUnitInCharge.Website'
    END

    -- 20. Snapshot_StepRequirement: +GenericRequirement_NumberOfPages (int NOT NULL DEFAULT 1), +IsEmittedByInstitution (bit NOT NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'GenericRequirement_NumberOfPages' AND object_id = OBJECT_ID('dbo.Snapshot_StepRequirement'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepRequirement] ADD [GenericRequirement_NumberOfPages] [int] NOT NULL CONSTRAINT [DF_Snapshot_StepRequirement_GenReqNumberOfPages] DEFAULT (1)
        PRINT '  Added Snapshot_StepRequirement.GenericRequirement_NumberOfPages'
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsEmittedByInstitution' AND object_id = OBJECT_ID('dbo.Snapshot_StepRequirement'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepRequirement] ADD [IsEmittedByInstitution] [bit] NOT NULL CONSTRAINT [DF_Snapshot_StepRequirement_IsEmittedByInstitution] DEFAULT (0)
        PRINT '  Added Snapshot_StepRequirement.IsEmittedByInstitution'
    END

    -- 21. Snapshot_StepSectionVisibility: +IsSummaryVisible (bit NOT NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsSummaryVisible' AND object_id = OBJECT_ID('dbo.Snapshot_StepSectionVisibility'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepSectionVisibility] ADD [IsSummaryVisible] [bit] NOT NULL CONSTRAINT [DF_Snapshot_StepSectionVisibility_IsSummaryVisible] DEFAULT (0)
        PRINT '  Added Snapshot_StepSectionVisibility.IsSummaryVisible'
    END

    -- 22. Snapshot_StepUnitInCharge: +Website (nvarchar(255) NULL)
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.Snapshot_StepUnitInCharge'))
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepUnitInCharge] ADD [Website] [nvarchar](255) NULL
        PRINT '  Added Snapshot_StepUnitInCharge.Website'
    END

    -- =========================================
    -- SECTION 3: Column Type Modifications
    -- =========================================

    PRINT ''
    PRINT '--- Section 3: Column Type Modifications ---'

    -- 23. Feedback.Email: nvarchar(30) -> nvarchar(100)
    IF EXISTS (SELECT 1 FROM sys.columns c WHERE c.name = 'Email' AND c.object_id = OBJECT_ID('dbo.Feedback') AND c.max_length = 60)  -- 60 bytes = 30 nvarchar chars
    BEGIN
        ALTER TABLE [dbo].[Feedback] ALTER COLUMN [Email] [nvarchar](100) NULL
        PRINT '  Modified Feedback.Email from nvarchar(30) to nvarchar(100)'
    END

    -- 24. Feedback.Type: int NULL -> int NOT NULL
    IF EXISTS (SELECT 1 FROM sys.columns c WHERE c.name = 'Type' AND c.object_id = OBJECT_ID('dbo.Feedback') AND c.is_nullable = 1)
    BEGIN
        -- First set any NULL values to 0 to avoid conversion errors
        UPDATE [dbo].[Feedback] SET [Type] = 0 WHERE [Type] IS NULL
        ALTER TABLE [dbo].[Feedback] ALTER COLUMN [Type] [int] NOT NULL
        PRINT '  Modified Feedback.Type from int NULL to int NOT NULL'
    END

    COMMIT TRANSACTION
    PRINT ''
    PRINT '=== Migration 010 completed successfully ==='
    PRINT 'Finished at: ' + CONVERT(varchar(30), GETDATE(), 120)

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT ''
    PRINT '=== Migration 010 FAILED ==='
    PRINT 'Error: ' + ERROR_MESSAGE()
    PRINT 'Line: ' + CAST(ERROR_LINE() AS varchar(10))
    DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE()
    DECLARE @ErrorSeverity int = ERROR_SEVERITY()
    DECLARE @ErrorState int = ERROR_STATE()
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
END CATCH
GO
