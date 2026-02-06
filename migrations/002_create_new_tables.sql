-- =============================================
-- Migration: 002_create_new_tables
-- Description: Create new tables required by EF6 schema
-- Target: Old-structure database (run in SSMS)
-- =============================================

PRINT 'Starting migration 002_create_new_tables...'
PRINT 'Target: Create new tables that do not exist in old schema'
PRINT ''

-- =============================================
-- ADMIN_OBJECTIVESECTIONVISIBILITY TABLE
-- =============================================
PRINT 'Processing Admin_ObjectiveSectionVisibility table...'

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Admin_ObjectiveSectionVisibility' AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[Admin_ObjectiveSectionVisibility](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [IsExpectedResultsVisible] [bit] NOT NULL,
        [IsEntitiesInChargeVisible] [bit] NOT NULL,
        [IsRequirementsVisible] [bit] NOT NULL,
        [IsCostsVisible] [bit] NOT NULL,
        [IsTimeframeVisible] [bit] NOT NULL,
        [IsLegalJustificationVisible] [bit] NOT NULL,
        [IsAdditionalInfoVisible] [bit] NOT NULL,
        [IsAdministrativeBurdenVisible] [bit] NOT NULL,
        [Objective_Id] [int] NOT NULL,
        [IsAllSectionsVisible] [bit] NOT NULL,
        CONSTRAINT [PK_dbo.Admin_ObjectiveSectionVisibility] PRIMARY KEY CLUSTERED ([Id] ASC)
    )
    PRINT '  Created table: Admin_ObjectiveSectionVisibility'
END
ELSE
    PRINT '  Table already exists: Admin_ObjectiveSectionVisibility'
GO

-- =============================================
-- SNAPSHOT_OBJECTIVESECTIONVISIBILITY TABLE
-- =============================================
PRINT ''
PRINT 'Processing Snapshot_ObjectiveSectionVisibility table...'

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_ObjectiveSectionVisibility' AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[Snapshot_ObjectiveSectionVisibility](
        [ObjectiveSectionVisibilityId] [int] IDENTITY(1,1) NOT NULL,
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
        [IsAllSectionsVisible] [bit] NOT NULL,
        CONSTRAINT [PK_dbo.Snapshot_ObjectiveSectionVisibility] PRIMARY KEY CLUSTERED ([ObjectiveSectionVisibilityId] ASC)
    )
    PRINT '  Created table: Snapshot_ObjectiveSectionVisibility'
END
ELSE
    PRINT '  Table already exists: Snapshot_ObjectiveSectionVisibility'
GO

-- =============================================
-- FILTEROPTION_PRODUCT TABLE
-- =============================================
PRINT ''
PRINT 'Processing FilterOption_Product table...'

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'FilterOption_Product' AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[FilterOption_Product](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [FilterOption_Id] [int] NOT NULL,
        [ProductCode] [nvarchar](10) NOT NULL,
        [ProductName] [nvarchar](300) NOT NULL,
        CONSTRAINT [PK_dbo.FilterOption_Product] PRIMARY KEY CLUSTERED ([Id] ASC)
    )
    PRINT '  Created table: FilterOption_Product'
END
ELSE
    PRINT '  Table already exists: FilterOption_Product'
GO

-- =============================================
-- GENERICREQUIREMENT_COST TABLE
-- =============================================
PRINT ''
PRINT 'Processing GenericRequirement_Cost table...'

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
        CONSTRAINT [PK_dbo.GenericRequirement_Cost] PRIMARY KEY CLUSTERED ([Id] ASC)
    )
    PRINT '  Created table: GenericRequirement_Cost'
END
ELSE
    PRINT '  Table already exists: GenericRequirement_Cost'
GO

-- =============================================
-- SNAPSHOT_STEPREQUIREMENTCOST TABLE
-- =============================================
PRINT ''
PRINT 'Processing Snapshot_StepRequirementCost table...'

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_StepRequirementCost' AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[Snapshot_StepRequirementCost](
        [StepRequirementCostId] [int] IDENTITY(1,1) NOT NULL,
        [Registry_Id] [int] NOT NULL,
        [Objective_Id] [int] NOT NULL,
        [Block_Id] [int] NOT NULL,
        [Step_Id] [int] NOT NULL,
        [Id] [int] NOT NULL,
        [Type] [nvarchar](30) NOT NULL,
        [Level_Id] [int] NOT NULL,
        [TimeOfStaff] [numeric](5, 2) NOT NULL,
        [Automated] [numeric](5, 2) NULL,
        [GenericRequirement_Id] [int] NOT NULL,
        CONSTRAINT [PK_dbo.Snapshot_StepRequirementCost] PRIMARY KEY CLUSTERED ([StepRequirementCostId] ASC)
    )
    PRINT '  Created table: Snapshot_StepRequirementCost'
END
ELSE
    PRINT '  Table already exists: Snapshot_StepRequirementCost'
GO

PRINT ''
PRINT '============================================='
PRINT 'Migration 002_create_new_tables completed!'
PRINT '============================================='
GO
