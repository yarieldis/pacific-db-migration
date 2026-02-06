-- =============================================
-- Migration: 006_add_foreign_keys
-- Description: Add new foreign key constraints for EF6 schema
-- Target: Old-structure database (run in SSMS)
-- =============================================

PRINT 'Starting migration 006_add_foreign_keys...'
PRINT 'Target: Add new foreign key constraints'
PRINT ''

-- =============================================
-- ADMIN_OBJECTIVESECTIONVISIBILITY FOREIGN KEYS
-- =============================================
PRINT 'Processing Admin_ObjectiveSectionVisibility foreign keys...'

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_dbo.Admin_ObjectiveSectionVisibility_dbo.Admin_Objective_Objective_Id')
BEGIN
    -- First check for orphan records
    IF EXISTS (
        SELECT 1 FROM [dbo].[Admin_ObjectiveSectionVisibility] osv
        WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Admin_Objective] o WHERE o.Id = osv.Objective_Id)
    )
    BEGIN
        PRINT '  WARNING: Orphan records found in Admin_ObjectiveSectionVisibility'
        PRINT '  Cleaning up orphan records...'
        DELETE FROM [dbo].[Admin_ObjectiveSectionVisibility]
        WHERE Objective_Id NOT IN (SELECT Id FROM [dbo].[Admin_Objective])
    END

    ALTER TABLE [dbo].[Admin_ObjectiveSectionVisibility]
    ADD CONSTRAINT [FK_dbo.Admin_ObjectiveSectionVisibility_dbo.Admin_Objective_Objective_Id]
    FOREIGN KEY ([Objective_Id]) REFERENCES [dbo].[Admin_Objective]([Id])
    ON DELETE CASCADE

    PRINT '  Added FK: FK_dbo.Admin_ObjectiveSectionVisibility_dbo.Admin_Objective_Objective_Id'
END
ELSE
    PRINT '  FK already exists: FK_dbo.Admin_ObjectiveSectionVisibility_dbo.Admin_Objective_Objective_Id'
GO

-- =============================================
-- SNAPSHOT_OBJECTIVESECTIONVISIBILITY FOREIGN KEYS
-- =============================================
PRINT ''
PRINT 'Processing Snapshot_ObjectiveSectionVisibility foreign keys...'

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_dbo.Snapshot_ObjectiveSectionVisibility_dbo.Snapshot_Registry_Registry_Id')
BEGIN
    -- First check for orphan records
    IF EXISTS (
        SELECT 1 FROM [dbo].[Snapshot_ObjectiveSectionVisibility] sosv
        WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Snapshot_Registry] sr WHERE sr.Id = sosv.Registry_Id)
    )
    BEGIN
        PRINT '  WARNING: Orphan records found in Snapshot_ObjectiveSectionVisibility'
        PRINT '  Cleaning up orphan records...'
        DELETE FROM [dbo].[Snapshot_ObjectiveSectionVisibility]
        WHERE Registry_Id NOT IN (SELECT Id FROM [dbo].[Snapshot_Registry])
    END

    ALTER TABLE [dbo].[Snapshot_ObjectiveSectionVisibility]
    ADD CONSTRAINT [FK_dbo.Snapshot_ObjectiveSectionVisibility_dbo.Snapshot_Registry_Registry_Id]
    FOREIGN KEY ([Registry_Id]) REFERENCES [dbo].[Snapshot_Registry]([Id])
    ON DELETE CASCADE

    PRINT '  Added FK: FK_dbo.Snapshot_ObjectiveSectionVisibility_dbo.Snapshot_Registry_Registry_Id'
END
ELSE
    PRINT '  FK already exists: FK_dbo.Snapshot_ObjectiveSectionVisibility_dbo.Snapshot_Registry_Registry_Id'
GO

-- =============================================
-- FILTEROPTION_PRODUCT FOREIGN KEYS
-- =============================================
PRINT ''
PRINT 'Processing FilterOption_Product foreign keys...'

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_dbo.FilterOption_Product_dbo.FilterOption_FilterOption_Id')
BEGIN
    -- Check if FilterOption table exists
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'FilterOption' AND type = 'U')
    BEGIN
        -- First check for orphan records
        IF EXISTS (
            SELECT 1 FROM [dbo].[FilterOption_Product] fop
            WHERE NOT EXISTS (SELECT 1 FROM [dbo].[FilterOption] fo WHERE fo.Id = fop.FilterOption_Id)
        )
        BEGIN
            PRINT '  WARNING: Orphan records found in FilterOption_Product'
            PRINT '  Cleaning up orphan records...'
            DELETE FROM [dbo].[FilterOption_Product]
            WHERE FilterOption_Id NOT IN (SELECT Id FROM [dbo].[FilterOption])
        END

        ALTER TABLE [dbo].[FilterOption_Product]
        ADD CONSTRAINT [FK_dbo.FilterOption_Product_dbo.FilterOption_FilterOption_Id]
        FOREIGN KEY ([FilterOption_Id]) REFERENCES [dbo].[FilterOption]([Id])
        ON DELETE CASCADE

        PRINT '  Added FK: FK_dbo.FilterOption_Product_dbo.FilterOption_FilterOption_Id'
    END
    ELSE
        PRINT '  SKIPPED: FilterOption table does not exist'
END
ELSE
    PRINT '  FK already exists: FK_dbo.FilterOption_Product_dbo.FilterOption_FilterOption_Id'
GO

-- =============================================
-- GENERICREQUIREMENT_COST FOREIGN KEYS
-- =============================================
PRINT ''
PRINT 'Processing GenericRequirement_Cost foreign keys...'

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_dbo.GenericRequirement_Cost_dbo.GenericRequirement_GenericRequirement_Id')
BEGIN
    -- First check for orphan records
    IF EXISTS (
        SELECT 1 FROM [dbo].[GenericRequirement_Cost] grc
        WHERE NOT EXISTS (SELECT 1 FROM [dbo].[GenericRequirement] gr WHERE gr.Id = grc.GenericRequirement_Id)
    )
    BEGIN
        PRINT '  WARNING: Orphan records found in GenericRequirement_Cost'
        PRINT '  Cleaning up orphan records...'
        DELETE FROM [dbo].[GenericRequirement_Cost]
        WHERE GenericRequirement_Id NOT IN (SELECT Id FROM [dbo].[GenericRequirement])
    END

    ALTER TABLE [dbo].[GenericRequirement_Cost]
    ADD CONSTRAINT [FK_dbo.GenericRequirement_Cost_dbo.GenericRequirement_GenericRequirement_Id]
    FOREIGN KEY ([GenericRequirement_Id]) REFERENCES [dbo].[GenericRequirement]([Id])
    ON DELETE CASCADE

    PRINT '  Added FK: FK_dbo.GenericRequirement_Cost_dbo.GenericRequirement_GenericRequirement_Id'
END
ELSE
    PRINT '  FK already exists: FK_dbo.GenericRequirement_Cost_dbo.GenericRequirement_GenericRequirement_Id'
GO

-- =============================================
-- SNAPSHOT_STEPREQUIREMENTCOST FOREIGN KEYS
-- =============================================
PRINT ''
PRINT 'Processing Snapshot_StepRequirementCost foreign keys...'

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_dbo.Snapshot_StepRequirementCost_dbo.Snapshot_Registry_Registry_Id')
BEGIN
    -- First check for orphan records
    IF EXISTS (
        SELECT 1 FROM [dbo].[Snapshot_StepRequirementCost] ssrc
        WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Snapshot_Registry] sr WHERE sr.Id = ssrc.Registry_Id)
    )
    BEGIN
        PRINT '  WARNING: Orphan records found in Snapshot_StepRequirementCost'
        PRINT '  Cleaning up orphan records...'
        DELETE FROM [dbo].[Snapshot_StepRequirementCost]
        WHERE Registry_Id NOT IN (SELECT Id FROM [dbo].[Snapshot_Registry])
    END

    ALTER TABLE [dbo].[Snapshot_StepRequirementCost]
    ADD CONSTRAINT [FK_dbo.Snapshot_StepRequirementCost_dbo.Snapshot_Registry_Registry_Id]
    FOREIGN KEY ([Registry_Id]) REFERENCES [dbo].[Snapshot_Registry]([Id])
    ON DELETE CASCADE

    PRINT '  Added FK: FK_dbo.Snapshot_StepRequirementCost_dbo.Snapshot_Registry_Registry_Id'
END
ELSE
    PRINT '  FK already exists: FK_dbo.Snapshot_StepRequirementCost_dbo.Snapshot_Registry_Registry_Id'
GO

PRINT ''
PRINT '============================================='
PRINT 'Migration 006_add_foreign_keys completed!'
PRINT '============================================='
GO
