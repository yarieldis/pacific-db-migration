-- =============================================
-- Migration: 020_create_new_tables
-- Date: 2026-02-16
-- Description: Create 5 new tables required by SPA schema:
--   Admin_ObjectiveSectionVisibility, Snapshot_ObjectiveSectionVisibility,
--   FilterOption_Product, GenericRequirement_Cost, Snapshot_StepRequirementCost
-- =============================================

BEGIN TRANSACTION
BEGIN TRY

    -- =============================================
    -- 1. Admin_ObjectiveSectionVisibility
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Admin_ObjectiveSectionVisibility' AND type = 'U')
    BEGIN
        CREATE TABLE [dbo].[Admin_ObjectiveSectionVisibility](
            [Id] [int] IDENTITY(1,1) NOT NULL,
            [Objective_Id] [int] NOT NULL,
            [IsExpectedResultsVisible] [bit] NOT NULL,
            [IsEntitiesInChargeVisible] [bit] NOT NULL,
            [IsRequirementsVisible] [bit] NOT NULL,
            [IsCostsVisible] [bit] NOT NULL,
            [IsTimeframeVisible] [bit] NOT NULL,
            [IsLegalJustificationVisible] [bit] NOT NULL,
            [IsAdditionalInfoVisible] [bit] NOT NULL,
            [IsAdministrativeBurdenVisible] [bit] NOT NULL,
         CONSTRAINT [PK_Admin_ObjectiveSectionVisibility] PRIMARY KEY CLUSTERED
        (
            [Id] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
        PRINT 'Created table Admin_ObjectiveSectionVisibility'
    END

    -- =============================================
    -- 2. Snapshot_ObjectiveSectionVisibility
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_ObjectiveSectionVisibility' AND type = 'U')
    BEGIN
        CREATE TABLE [dbo].[Snapshot_ObjectiveSectionVisibility](
            [Registry_Id] [int] NOT NULL,
            [Objective_Id] [int] NOT NULL,
            [IsExpectedResultsVisible] [bit] NOT NULL,
            [IsEntitiesInChargeVisible] [bit] NOT NULL,
            [IsRequirementsVisible] [bit] NOT NULL,
            [IsCostsVisible] [bit] NOT NULL,
            [IsTimeframeVisible] [bit] NOT NULL,
            [IsLegalJustificationVisible] [bit] NOT NULL,
            [IsAdditionalInfoVisible] [bit] NOT NULL,
            [IsAdministrativeBurdenVisible] [bit] NOT NULL
        ) ON [PRIMARY]
        PRINT 'Created table Snapshot_ObjectiveSectionVisibility'
    END

    -- =============================================
    -- 3. FilterOption_Product
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'FilterOption_Product' AND type = 'U')
    BEGIN
        CREATE TABLE [dbo].[FilterOption_Product](
            [Id] [int] IDENTITY(1,1) NOT NULL,
            [FilterOption_Id] [int] NOT NULL,
            [ProductCode] [nvarchar](10) NOT NULL,
            [ProductName] [nvarchar](300) NOT NULL,
         CONSTRAINT [PK_FilterOption_Product_Id] PRIMARY KEY CLUSTERED
        (
            [Id] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
        PRINT 'Created table FilterOption_Product'
    END

    -- =============================================
    -- 4. GenericRequirement_Cost
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'GenericRequirement_Cost' AND type = 'U')
    BEGIN
        CREATE TABLE [dbo].[GenericRequirement_Cost](
            [Id] [int] IDENTITY(1,1) NOT NULL,
            [Type] [nvarchar](30) NOT NULL,
            [Level_Id] [int] NOT NULL,
            [TimeOfStaff] [numeric](5, 2) NOT NULL,
            [Automated] [numeric](5, 2) NULL,
            [GenericRequirement_Id] [int] NOT NULL,
            [CreatedDate] [datetime] NOT NULL,
            [CreatedUser] [nvarchar](50) NOT NULL,
            [ModifiedDate] [datetime] NOT NULL,
            [ModifiedUser] [nvarchar](50) NOT NULL,
            [Deleted] [bit] NOT NULL,
         CONSTRAINT [PK_GenericRequirementCost_Id] PRIMARY KEY CLUSTERED
        (
            [Id] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
        PRINT 'Created table GenericRequirement_Cost'
    END

    -- =============================================
    -- 5. Snapshot_StepRequirementCost
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_StepRequirementCost' AND type = 'U')
    BEGIN
        CREATE TABLE [dbo].[Snapshot_StepRequirementCost](
            [Registry_Id] [int] NOT NULL,
            [Objective_Id] [int] NOT NULL,
            [Block_Id] [int] NOT NULL,
            [Step_Id] [int] NOT NULL,
            [Id] [int] NOT NULL,
            [Type] [nvarchar](30) NOT NULL,
            [Level_Id] [int] NOT NULL,
            [TimeOfStaff] [numeric](5, 2) NOT NULL,
            [Automated] [numeric](5, 2) NULL,
            [GenericRequirement_Id] [int] NOT NULL
        ) ON [PRIMARY]
        PRINT 'Created table Snapshot_StepRequirementCost'
    END

    COMMIT TRANSACTION
    PRINT '========================================='
    PRINT 'Migration 020_create_new_tables completed successfully'
    PRINT '========================================='
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Migration 020_create_new_tables FAILED: ' + ERROR_MESSAGE()
    ;THROW
END CATCH
GO
