-- =============================================
-- Migration: 070_add_foreign_keys
-- Date: 2026-02-16
-- Description: Add foreign key constraints for the 5 new tables.
--   Admin_ObjectiveSectionVisibility -> Admin_Objective
--   Snapshot_ObjectiveSectionVisibility -> Registry
--   FilterOption_Product -> FilterOption
--   GenericRequirement_Cost -> GenericRequirement
--   Snapshot_StepRequirementCost -> Registry
-- =============================================

BEGIN TRANSACTION
BEGIN TRY

    -- =============================================
    -- 1. Admin_ObjectiveSectionVisibility.Objective_Id -> Admin_Objective.Id
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Admin_ObjectiveSectionVisibility_Objective')
    AND EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Admin_ObjectiveSectionVisibility' AND type = 'U')
    AND EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Admin_Objective' AND type = 'U')
    BEGIN
        ALTER TABLE [dbo].[Admin_ObjectiveSectionVisibility]
        ADD CONSTRAINT [FK_Admin_ObjectiveSectionVisibility_Objective]
        FOREIGN KEY ([Objective_Id]) REFERENCES [dbo].[Admin_Objective]([Id])
        PRINT 'Added FK: Admin_ObjectiveSectionVisibility.Objective_Id -> Admin_Objective.Id'
    END

    -- =============================================
    -- 2. Snapshot_ObjectiveSectionVisibility.Registry_Id -> Registry.Id
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Snapshot_ObjectiveSectionVisibility_Registry')
    AND EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_ObjectiveSectionVisibility' AND type = 'U')
    AND EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Registry' AND type = 'U')
    BEGIN
        ALTER TABLE [dbo].[Snapshot_ObjectiveSectionVisibility]
        ADD CONSTRAINT [FK_Snapshot_ObjectiveSectionVisibility_Registry]
        FOREIGN KEY ([Registry_Id]) REFERENCES [dbo].[Registry]([Id])
        PRINT 'Added FK: Snapshot_ObjectiveSectionVisibility.Registry_Id -> Registry.Id'
    END

    -- =============================================
    -- 3. FilterOption_Product.FilterOption_Id -> FilterOption.Id
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FilterOption_Product_FilterOption')
    AND EXISTS (SELECT 1 FROM sys.objects WHERE name = 'FilterOption_Product' AND type = 'U')
    AND EXISTS (SELECT 1 FROM sys.objects WHERE name = 'FilterOption' AND type = 'U')
    BEGIN
        ALTER TABLE [dbo].[FilterOption_Product]
        ADD CONSTRAINT [FK_FilterOption_Product_FilterOption]
        FOREIGN KEY ([FilterOption_Id]) REFERENCES [dbo].[FilterOption]([Id])
        PRINT 'Added FK: FilterOption_Product.FilterOption_Id -> FilterOption.Id'
    END

    -- =============================================
    -- 4. GenericRequirement_Cost.GenericRequirement_Id -> GenericRequirement.Id
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_GenericRequirement_Cost_GenericRequirement')
    AND EXISTS (SELECT 1 FROM sys.objects WHERE name = 'GenericRequirement_Cost' AND type = 'U')
    AND EXISTS (SELECT 1 FROM sys.objects WHERE name = 'GenericRequirement' AND type = 'U')
    BEGIN
        ALTER TABLE [dbo].[GenericRequirement_Cost]
        ADD CONSTRAINT [FK_GenericRequirement_Cost_GenericRequirement]
        FOREIGN KEY ([GenericRequirement_Id]) REFERENCES [dbo].[GenericRequirement]([Id])
        PRINT 'Added FK: GenericRequirement_Cost.GenericRequirement_Id -> GenericRequirement.Id'
    END

    -- =============================================
    -- 5. Snapshot_StepRequirementCost.Registry_Id -> Registry.Id
    -- =============================================
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Snapshot_StepRequirementCost_Registry')
    AND EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_StepRequirementCost' AND type = 'U')
    AND EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Registry' AND type = 'U')
    BEGIN
        ALTER TABLE [dbo].[Snapshot_StepRequirementCost]
        ADD CONSTRAINT [FK_Snapshot_StepRequirementCost_Registry]
        FOREIGN KEY ([Registry_Id]) REFERENCES [dbo].[Registry]([Id])
        PRINT 'Added FK: Snapshot_StepRequirementCost.Registry_Id -> Registry.Id'
    END

    COMMIT TRANSACTION
    PRINT '========================================='
    PRINT 'Migration 070_add_foreign_keys completed successfully'
    PRINT '========================================='
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Migration 070_add_foreign_keys FAILED: ' + ERROR_MESSAGE()
    ;THROW
END CATCH
GO
