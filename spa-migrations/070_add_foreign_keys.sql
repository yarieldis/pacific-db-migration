-- =============================================
-- Migration: 070_add_foreign_keys
-- Date: 2026-02-16
-- Description: Add 6 new foreign key constraints for new columns and tables.
--   FK definitions extracted verbatim from new-spa-structure.sql (Libya).
-- Execution: Run in SSMS against the old-structure database
-- Dependencies: 010_add_new_columns.sql, 020_create_new_tables.sql
-- =============================================

SET NOCOUNT ON;

PRINT '=== Migration 070: Add Foreign Keys ==='
PRINT 'Started at: ' + CONVERT(varchar(30), GETDATE(), 120)
PRINT ''

-- =========================================
-- 1. FK_Admin_Step_Level: Admin_Step.Level_Id -> Option.Id
-- =========================================

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Admin_Step_Level')
BEGIN
    ALTER TABLE [dbo].[Admin_Step] WITH CHECK ADD CONSTRAINT [FK_Admin_Step_Level] FOREIGN KEY([Level_Id])
    REFERENCES [dbo].[Option] ([Id])

    ALTER TABLE [dbo].[Admin_Step] CHECK CONSTRAINT [FK_Admin_Step_Level]
    PRINT '  Added FK_Admin_Step_Level'
END
ELSE
    PRINT '  FK_Admin_Step_Level already exists - skipped'
GO

-- =========================================
-- 2. FK_EntityInCharge_Zone: EntityInCharge.Zone_Id -> Option.Id
-- =========================================

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_EntityInCharge_Zone')
BEGIN
    ALTER TABLE [dbo].[EntityInCharge] WITH CHECK ADD CONSTRAINT [FK_EntityInCharge_Zone] FOREIGN KEY([Zone_Id])
    REFERENCES [dbo].[Option] ([Id])

    ALTER TABLE [dbo].[EntityInCharge] CHECK CONSTRAINT [FK_EntityInCharge_Zone]
    PRINT '  Added FK_EntityInCharge_Zone'
END
ELSE
    PRINT '  FK_EntityInCharge_Zone already exists - skipped'
GO

-- =========================================
-- 3. FK_Admin_ObjectiveSectionVisibility_Objective: Objective_Id -> Admin_Objective.Id
-- =========================================

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Admin_ObjectiveSectionVisibility_Objective')
BEGIN
    ALTER TABLE [dbo].[Admin_ObjectiveSectionVisibility] WITH CHECK ADD CONSTRAINT [FK_Admin_ObjectiveSectionVisibility_Objective] FOREIGN KEY([Objective_Id])
    REFERENCES [dbo].[Admin_Objective] ([Id])

    ALTER TABLE [dbo].[Admin_ObjectiveSectionVisibility] CHECK CONSTRAINT [FK_Admin_ObjectiveSectionVisibility_Objective]
    PRINT '  Added FK_Admin_ObjectiveSectionVisibility_Objective'
END
ELSE
    PRINT '  FK_Admin_ObjectiveSectionVisibility_Objective already exists - skipped'
GO

-- =========================================
-- 4. FK_FilterOption_Product_FilterOption: FilterOption_Id -> FilterOption.Id
-- =========================================

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FilterOption_Product_FilterOption')
BEGIN
    ALTER TABLE [dbo].[FilterOption_Product] WITH CHECK ADD CONSTRAINT [FK_FilterOption_Product_FilterOption] FOREIGN KEY([FilterOption_Id])
    REFERENCES [dbo].[FilterOption] ([Id])

    ALTER TABLE [dbo].[FilterOption_Product] CHECK CONSTRAINT [FK_FilterOption_Product_FilterOption]
    PRINT '  Added FK_FilterOption_Product_FilterOption'
END
ELSE
    PRINT '  FK_FilterOption_Product_FilterOption already exists - skipped'
GO

-- =========================================
-- 5. FK_GenericRequirement_Id: GenericRequirement_Cost.GenericRequirement_Id -> GenericRequirement.Id
-- =========================================

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_GenericRequirement_Id')
BEGIN
    ALTER TABLE [dbo].[GenericRequirement_Cost] WITH CHECK ADD CONSTRAINT [FK_GenericRequirement_Id] FOREIGN KEY([GenericRequirement_Id])
    REFERENCES [dbo].[GenericRequirement] ([Id])

    ALTER TABLE [dbo].[GenericRequirement_Cost] CHECK CONSTRAINT [FK_GenericRequirement_Id]
    PRINT '  Added FK_GenericRequirement_Id'
END
ELSE
    PRINT '  FK_GenericRequirement_Id already exists - skipped'
GO

-- =========================================
-- 6. FK_Level_Id: GenericRequirement_Cost.Level_Id -> Option.Id
-- =========================================

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Level_Id')
BEGIN
    ALTER TABLE [dbo].[GenericRequirement_Cost] WITH CHECK ADD CONSTRAINT [FK_Level_Id] FOREIGN KEY([Level_Id])
    REFERENCES [dbo].[Option] ([Id])

    ALTER TABLE [dbo].[GenericRequirement_Cost] CHECK CONSTRAINT [FK_Level_Id]
    PRINT '  Added FK_Level_Id'
END
ELSE
    PRINT '  FK_Level_Id already exists - skipped'
GO

PRINT ''
PRINT '=== Migration 070 completed successfully ==='
PRINT 'Finished at: ' + CONVERT(varchar(30), GETDATE(), 120)
GO
