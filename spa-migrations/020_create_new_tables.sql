-- =============================================
-- Migration: 020_create_new_tables
-- Date: 2026-02-16
-- Description: Create 5 new tables required by SPA schema.
--   Definitions extracted verbatim from new-spa-structure.sql (Libya).
-- Execution: Run in SSMS against the old-structure database
-- Dependencies: 010_add_new_columns.sql
-- =============================================

SET NOCOUNT ON;

PRINT '=== Migration 020: Create New Tables ==='
PRINT 'Started at: ' + CONVERT(varchar(30), GETDATE(), 120)
PRINT ''

-- =========================================
-- 1. Admin_ObjectiveSectionVisibility (11 columns)
-- =========================================

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
        [IsAllSectionsVisible] [bit] NOT NULL,
     CONSTRAINT [PK_Admin_ObjectiveSectionVisibility] PRIMARY KEY CLUSTERED
    (
        [Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    PRINT '  Created Admin_ObjectiveSectionVisibility'
END
ELSE
    PRINT '  Admin_ObjectiveSectionVisibility already exists - skipped'
GO

-- =========================================
-- 2. Snapshot_ObjectiveSectionVisibility (11 columns, NO PK)
-- =========================================

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
        [IsAdministrativeBurdenVisible] [bit] NOT NULL,
        [IsAllSectionsVisible] [bit] NOT NULL
    ) ON [PRIMARY]

    PRINT '  Created Snapshot_ObjectiveSectionVisibility'
END
ELSE
    PRINT '  Snapshot_ObjectiveSectionVisibility already exists - skipped'
GO

-- =========================================
-- 3. FilterOption_Product (4 columns)
-- =========================================

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
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    PRINT '  Created FilterOption_Product'
END
ELSE
    PRINT '  FilterOption_Product already exists - skipped'
GO

-- =========================================
-- 4. GenericRequirement_Cost (11 columns)
-- =========================================

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
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY]

    PRINT '  Created GenericRequirement_Cost'
END
ELSE
    PRINT '  GenericRequirement_Cost already exists - skipped'
GO

-- =========================================
-- 5. Snapshot_StepRequirementCost (10 columns, NO PK)
-- =========================================

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

    PRINT '  Created Snapshot_StepRequirementCost'
END
ELSE
    PRINT '  Snapshot_StepRequirementCost already exists - skipped'
GO

PRINT ''
PRINT '=== Migration 020 completed successfully ==='
PRINT 'Finished at: ' + CONVERT(varchar(30), GETDATE(), 120)
GO
