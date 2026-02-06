-- =============================================
-- Migration: 003_rename_primary_keys
-- Description: Rename primary keys to EF6 convention (PK_dbo.TableName)
-- Target: Old-structure database (run in SSMS)
-- =============================================

PRINT 'Starting migration 003_rename_primary_keys...'
PRINT 'Target: Rename PKs from PK_TableName to PK_dbo.TableName format'
PRINT ''

-- Helper: Check if PK exists with old name before renaming
-- sp_rename will fail if the constraint doesn't exist

-- =============================================
-- CORE TABLES
-- =============================================
PRINT 'Processing core tables...'

-- SystemLanguage (PK_SystemLanguages -> PK_dbo.SystemLanguage)
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_SystemLanguages' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_SystemLanguages', N'PK_dbo.SystemLanguage', N'OBJECT'
    PRINT '  Renamed: PK_SystemLanguages -> PK_dbo.SystemLanguage'
END
GO

-- Admin_Menu
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_Menu' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_Menu', N'PK_dbo.Admin_Menu', N'OBJECT'
    PRINT '  Renamed: PK_Admin_Menu -> PK_dbo.Admin_Menu'
END
GO

-- Admin_MenuPerLangVisibility
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_MenuPerLangVisibility' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_MenuPerLangVisibility', N'PK_dbo.Admin_MenuPerLangVisibility', N'OBJECT'
    PRINT '  Renamed: PK_Admin_MenuPerLangVisibility -> PK_dbo.Admin_MenuPerLangVisibility'
END
GO

-- Admin_MenuHierarchicalData
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_MenuHierarchicalData' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_MenuHierarchicalData', N'PK_dbo.Admin_MenuHierarchicalData', N'OBJECT'
    PRINT '  Renamed: PK_Admin_MenuHierarchicalData -> PK_dbo.Admin_MenuHierarchicalData'
END
GO

-- Admin_Step
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_Step' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_Step', N'PK_dbo.Admin_Step', N'OBJECT'
    PRINT '  Renamed: PK_Admin_Step -> PK_dbo.Admin_Step'
END
GO

-- Admin_Objective
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_Objective' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_Objective', N'PK_dbo.Admin_Objective', N'OBJECT'
    PRINT '  Renamed: PK_Admin_Objective -> PK_dbo.Admin_Objective'
END
GO

-- Admin_Block
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_Block' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_Block', N'PK_dbo.Admin_Block', N'OBJECT'
    PRINT '  Renamed: PK_Admin_Block -> PK_dbo.Admin_Block'
END
GO

-- Admin_ObjectiveHierarchicalData
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_ObjectiveHierarchicalData' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_ObjectiveHierarchicalData', N'PK_dbo.Admin_ObjectiveHierarchicalData', N'OBJECT'
    PRINT '  Renamed: PK_Admin_ObjectiveHierarchicalData -> PK_dbo.Admin_ObjectiveHierarchicalData'
END
GO

-- Admin_Objective_Block
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_Objective_Block' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_Objective_Block', N'PK_dbo.Admin_Objective_Block', N'OBJECT'
    PRINT '  Renamed: PK_Admin_Objective_Block -> PK_dbo.Admin_Objective_Block'
END
GO

-- Admin_Step_Recourse
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_Step_Recourse' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_Step_Recourse', N'PK_dbo.Admin_Step_Recourse', N'OBJECT'
    PRINT '  Renamed: PK_Admin_Step_Recourse -> PK_dbo.Admin_Step_Recourse'
END
GO

-- Admin_Block_Step
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_Block_Step' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_Block_Step', N'PK_dbo.Admin_Block_Step', N'OBJECT'
    PRINT '  Renamed: PK_Admin_Block_Step -> PK_dbo.Admin_Block_Step'
END
GO

-- Admin_ObjectivePerLangVisibility
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_ObjectivePerLangVisibility' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_ObjectivePerLangVisibility', N'PK_dbo.Admin_ObjectivePerLangVisibility', N'OBJECT'
    PRINT '  Renamed: PK_Admin_ObjectivePerLangVisibility -> PK_dbo.Admin_ObjectivePerLangVisibility'
END
GO

-- Admin_Object_Media
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_Object_Media' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_Object_Media', N'PK_dbo.Admin_Object_Media', N'OBJECT'
    PRINT '  Renamed: PK_Admin_Object_Media -> PK_dbo.Admin_Object_Media'
END
GO

-- Admin_StepResult
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_StepResult' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_StepResult', N'PK_dbo.Admin_StepResult', N'OBJECT'
    PRINT '  Renamed: PK_Admin_StepResult -> PK_dbo.Admin_StepResult'
END
GO

-- Admin_StepRequirement
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_StepRequirement' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_StepRequirement', N'PK_dbo.Admin_StepRequirement', N'OBJECT'
    PRINT '  Renamed: PK_Admin_StepRequirement -> PK_dbo.Admin_StepRequirement'
END
GO

-- Admin_StepLaw
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_StepLaw' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_StepLaw', N'PK_dbo.Admin_StepLaw', N'OBJECT'
    PRINT '  Renamed: PK_Admin_StepLaw -> PK_dbo.Admin_StepLaw'
END
GO

-- Admin_StepCost
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_StepCost' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_StepCost', N'PK_dbo.Admin_StepCost', N'OBJECT'
    PRINT '  Renamed: PK_Admin_StepCost -> PK_dbo.Admin_StepCost'
END
GO

-- Admin_StepSectionVisibility
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_StepSectionVisibility' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_StepSectionVisibility', N'PK_dbo.Admin_StepSectionVisibility', N'OBJECT'
    PRINT '  Renamed: PK_Admin_StepSectionVisibility -> PK_dbo.Admin_StepSectionVisibility'
END
GO

-- Admin_StepRegionalEntityInCharge
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_StepRegionalEntity' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_StepRegionalEntity', N'PK_dbo.Admin_StepRegionalEntityInCharge', N'OBJECT'
    PRINT '  Renamed: PK_Admin_StepRegionalEntity -> PK_dbo.Admin_StepRegionalEntityInCharge'
END
GO

-- Admin_StepRegionalPersonInCharge
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_StepRegionalPerson' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_StepRegionalPerson', N'PK_dbo.Admin_StepRegionalPersonInCharge', N'OBJECT'
    PRINT '  Renamed: PK_Admin_StepRegionalPerson -> PK_dbo.Admin_StepRegionalPersonInCharge'
END
GO

-- Admin_StepRegionalUnitInCharge
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Admin_StepRegionalUnit' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Admin_StepRegionalUnit', N'PK_dbo.Admin_StepRegionalUnitInCharge', N'OBJECT'
    PRINT '  Renamed: PK_Admin_StepRegionalUnit -> PK_dbo.Admin_StepRegionalUnitInCharge'
END
GO

-- =============================================
-- ENTITY TABLES
-- =============================================
PRINT ''
PRINT 'Processing entity tables...'

-- EntityInCharge
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_EntityInCharge' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_EntityInCharge', N'PK_dbo.EntityInCharge', N'OBJECT'
    PRINT '  Renamed: PK_EntityInCharge -> PK_dbo.EntityInCharge'
END
GO

-- UnitInCharge
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_UnitInCharge' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_UnitInCharge', N'PK_dbo.UnitInCharge', N'OBJECT'
    PRINT '  Renamed: PK_UnitInCharge -> PK_dbo.UnitInCharge'
END
GO

-- PersonInCharge
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_PersonInCharge' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_PersonInCharge', N'PK_dbo.PersonInCharge', N'OBJECT'
    PRINT '  Renamed: PK_PersonInCharge -> PK_dbo.PersonInCharge'
END
GO

-- Law
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Law' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Law', N'PK_dbo.Law', N'OBJECT'
    PRINT '  Renamed: PK_Law -> PK_dbo.Law'
END
GO

-- GenericRequirement
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_GenericRequirement' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_GenericRequirement', N'PK_dbo.GenericRequirement', N'OBJECT'
    PRINT '  Renamed: PK_GenericRequirement -> PK_dbo.GenericRequirement'
END
GO

-- Media
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Media' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Media', N'PK_dbo.Media', N'OBJECT'
    PRINT '  Renamed: PK_Media -> PK_dbo.Media'
END
GO

-- =============================================
-- SUPPORTING TABLES
-- =============================================
PRINT ''
PRINT 'Processing supporting tables...'

-- Partner
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Partner_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Partner_Id', N'PK_dbo.Partner', N'OBJECT'
    PRINT '  Renamed: PK_Partner_Id -> PK_dbo.Partner'
END
GO

-- XMLSerializedItem
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_XMLSerializedItem' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_XMLSerializedItem', N'PK_dbo.XMLSerializedItem', N'OBJECT'
    PRINT '  Renamed: PK_XMLSerializedItem -> PK_dbo.XMLSerializedItem'
END
GO

-- Option
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Option_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Option_Id', N'PK_dbo.Option', N'OBJECT'
    PRINT '  Renamed: PK_Option_Id -> PK_dbo.Option'
END
GO

-- AuditRecords
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_AuditRecords' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_AuditRecords', N'PK_dbo.AuditRecords', N'OBJECT'
    PRINT '  Renamed: PK_AuditRecords -> PK_dbo.AuditRecords'
END
GO

-- AuditRecordFields (was AuditValues)
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_AuditValues' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_AuditValues', N'PK_dbo.AuditRecordFields', N'OBJECT'
    PRINT '  Renamed: PK_AuditValues -> PK_dbo.AuditRecordFields'
END
GO

-- CostVariable
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Cost_Variable_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Cost_Variable_Id', N'PK_dbo.CostVariable', N'OBJECT'
    PRINT '  Renamed: PK_Cost_Variable_Id -> PK_dbo.CostVariable'
END
GO

-- Feedback
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Feedback_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Feedback_Id', N'PK_dbo.Feedback', N'OBJECT'
    PRINT '  Renamed: PK_Feedback_Id -> PK_dbo.Feedback'
END
GO

-- Filter
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Filter_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Filter_Id', N'PK_dbo.Filter', N'OBJECT'
    PRINT '  Renamed: PK_Filter_Id -> PK_dbo.Filter'
END
GO

-- FilterOption
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_FilterOption_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_FilterOption_Id', N'PK_dbo.FilterOption', N'OBJECT'
    PRINT '  Renamed: PK_FilterOption_Id -> PK_dbo.FilterOption'
END
GO

-- Objective_Filter
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Objective_Filter_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Objective_Filter_Id', N'PK_dbo.Objective_Filter', N'OBJECT'
    PRINT '  Renamed: PK_Objective_Filter_Id -> PK_dbo.Objective_Filter'
END
GO

-- Objective_FilterOption
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Objective_FilterOption_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Objective_FilterOption_Id', N'PK_dbo.Objective_FilterOption', N'OBJECT'
    PRINT '  Renamed: PK_Objective_FilterOption_Id -> PK_dbo.Objective_FilterOption'
END
GO

-- ProcedureContext
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_ProcedureContext' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_ProcedureContext', N'PK_dbo.ProcedureContext', N'OBJECT'
    PRINT '  Renamed: PK_ProcedureContext -> PK_dbo.ProcedureContext'
END
GO

-- Process
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Process_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Process_Id', N'PK_dbo.Process', N'OBJECT'
    PRINT '  Renamed: PK_Process_Id -> PK_dbo.Process'
END
GO

-- ProcessDetails
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_ProcessDetails_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_ProcessDetails_Id', N'PK_dbo.ProcessDetails', N'OBJECT'
    PRINT '  Renamed: PK_ProcessDetails_Id -> PK_dbo.ProcessDetails'
END
GO

-- Public_Team
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Public_Team_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Public_Team_Id', N'PK_dbo.Public_Team', N'OBJECT'
    PRINT '  Renamed: PK_Public_Team_Id -> PK_dbo.Public_Team'
END
GO

-- Public_Team_Member
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Public_Team_Member_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Public_Team_Member_Id', N'PK_dbo.Public_Team_Member', N'OBJECT'
    PRINT '  Renamed: PK_Public_Team_Member_Id -> PK_dbo.Public_Team_Member'
END
GO

-- SiteMenu
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_SiteMenu_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_SiteMenu_Id', N'PK_dbo.SiteMenu', N'OBJECT'
    PRINT '  Renamed: PK_SiteMenu_Id -> PK_dbo.SiteMenu'
END
GO

-- NTM tables
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_NtmCountry_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_NtmCountry_Id', N'PK_dbo.NtmCountry', N'OBJECT'
    PRINT '  Renamed: PK_NtmCountry_Id -> PK_dbo.NtmCountry'
END
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_NtmNotification_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_NtmNotification_Id', N'PK_dbo.NtmNotification', N'OBJECT'
    PRINT '  Renamed: PK_NtmNotification_Id -> PK_dbo.NtmNotification'
END
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_NtmSubject_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_NtmSubject_Id', N'PK_dbo.NtmSubject', N'OBJECT'
    PRINT '  Renamed: PK_NtmSubject_Id -> PK_dbo.NtmSubject'
END
GO

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_NtmUser_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_NtmUser_Id', N'PK_dbo.NtmUser', N'OBJECT'
    PRINT '  Renamed: PK_NtmUser_Id -> PK_dbo.NtmUser'
END
GO

-- Imported_Tariff
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Imported_tariffs_Id' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Imported_tariffs_Id', N'PK_dbo.Imported_Tariff', N'OBJECT'
    PRINT '  Renamed: PK_Imported_tariffs_Id -> PK_dbo.Imported_Tariff'
END
GO

-- =============================================
-- SNAPSHOT TABLES
-- =============================================
PRINT ''
PRINT 'Processing snapshot tables...'

-- Snapshot_Registry
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_Snapshot_Registry' AND type = 'PK')
BEGIN
    EXEC sp_rename N'PK_Snapshot_Registry', N'PK_dbo.Snapshot_Registry', N'OBJECT'
    PRINT '  Renamed: PK_Snapshot_Registry -> PK_dbo.Snapshot_Registry'
END
GO

PRINT ''
PRINT '============================================='
PRINT 'Migration 003_rename_primary_keys completed!'
PRINT '============================================='
GO
