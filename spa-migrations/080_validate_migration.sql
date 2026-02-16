-- =============================================
-- Migration: 080_validate_migration
-- Date: 2026-02-16
-- Description: Post-migration validation script.
--   Verifies all migration changes have been applied correctly.
-- =============================================

PRINT '========================================='
PRINT 'SPA Migration Validation'
PRINT '========================================='
PRINT ''

DECLARE @errors INT = 0

-- =============================================
-- 1. Verify new columns exist
-- =============================================
PRINT '--- Verifying new columns ---'

-- Admin_Step columns
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Level_Id' AND object_id = OBJECT_ID('dbo.Admin_Step'))
BEGIN PRINT 'FAIL: Admin_Step.Level_Id missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Admin_Step.Level_Id'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfUsers' AND object_id = OBJECT_ID('dbo.Admin_Step'))
BEGIN PRINT 'FAIL: Admin_Step.NumberOfUsers missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Admin_Step.NumberOfUsers'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Admin_Step'))
BEGIN PRINT 'FAIL: Admin_Step.Summary missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Admin_Step.Summary'

-- Admin_Step_i18n
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Admin_Step_i18n'))
BEGIN PRINT 'FAIL: Admin_Step_i18n.Summary missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Admin_Step_i18n.Summary'

-- EntityInCharge
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.EntityInCharge'))
BEGIN PRINT 'FAIL: EntityInCharge.Zone_Id missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: EntityInCharge.Zone_Id'

-- GenericRequirement
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsEmittedByInstitution' AND object_id = OBJECT_ID('dbo.GenericRequirement'))
BEGIN PRINT 'FAIL: GenericRequirement.IsEmittedByInstitution missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: GenericRequirement.IsEmittedByInstitution'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfPages' AND object_id = OBJECT_ID('dbo.GenericRequirement'))
BEGIN PRINT 'FAIL: GenericRequirement.NumberOfPages missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: GenericRequirement.NumberOfPages'

-- UnitInCharge
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.UnitInCharge'))
BEGIN PRINT 'FAIL: UnitInCharge.Website missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: UnitInCharge.Website'

-- Media_i18n
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'FileName' AND object_id = OBJECT_ID('dbo.Media_i18n'))
BEGIN PRINT 'FAIL: Media_i18n.FileName missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Media_i18n.FileName'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Extention' AND object_id = OBJECT_ID('dbo.Media_i18n'))
BEGIN PRINT 'FAIL: Media_i18n.Extention missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Media_i18n.Extention'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Description' AND object_id = OBJECT_ID('dbo.Media_i18n'))
BEGIN PRINT 'FAIL: Media_i18n.Description missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Media_i18n.Description'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Length' AND object_id = OBJECT_ID('dbo.Media_i18n'))
BEGIN PRINT 'FAIL: Media_i18n.Length missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Media_i18n.Length'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'PreviewImageName' AND object_id = OBJECT_ID('dbo.Media_i18n'))
BEGIN PRINT 'FAIL: Media_i18n.PreviewImageName missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Media_i18n.PreviewImageName'

-- Feedback
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Status' AND object_id = OBJECT_ID('dbo.Feedback'))
BEGIN PRINT 'FAIL: Feedback.Status missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Feedback.Status'

-- Filter
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsProductRelated' AND object_id = OBJECT_ID('dbo.Filter'))
BEGIN PRINT 'FAIL: Filter.IsProductRelated missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Filter.IsProductRelated'

-- Admin_StepSectionVisibility
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsSummaryVisible' AND object_id = OBJECT_ID('dbo.Admin_StepSectionVisibility'))
BEGIN PRINT 'FAIL: Admin_StepSectionVisibility.IsSummaryVisible missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Admin_StepSectionVisibility.IsSummaryVisible'

-- Snapshot_Step
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Level_Id' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
BEGIN PRINT 'FAIL: Snapshot_Step.Level_Id missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Snapshot_Step.Level_Id'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfUsers' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
BEGIN PRINT 'FAIL: Snapshot_Step.NumberOfUsers missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Snapshot_Step.NumberOfUsers'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
BEGIN PRINT 'FAIL: Snapshot_Step.Summary missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Snapshot_Step.Summary'

-- Snapshot_StepSectionVisibility
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsSummaryVisible' AND object_id = OBJECT_ID('dbo.Snapshot_StepSectionVisibility'))
BEGIN PRINT 'FAIL: Snapshot_StepSectionVisibility.IsSummaryVisible missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Snapshot_StepSectionVisibility.IsSummaryVisible'

PRINT ''

-- =============================================
-- 2. Verify columns removed
-- =============================================
PRINT '--- Verifying removed columns ---'

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsLegislation' AND object_id = OBJECT_ID('dbo.Law'))
BEGIN PRINT 'FAIL: Law.IsLegislation still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Law.IsLegislation removed'

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'PublishedStatus' AND object_id = OBJECT_ID('dbo.Law'))
BEGIN PRINT 'FAIL: Law.PublishedStatus still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Law.PublishedStatus removed'

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsVisibleInPublicHomePage' AND object_id = OBJECT_ID('dbo.Admin_Menu'))
BEGIN PRINT 'FAIL: Admin_Menu.IsVisibleInPublicHomePage still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Admin_Menu.IsVisibleInPublicHomePage removed'

-- Verify Law table has exactly 12 columns
DECLARE @lawColCount INT
SELECT @lawColCount = COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Law')
IF @lawColCount <> 12
BEGIN PRINT 'FAIL: Law table has ' + CAST(@lawColCount AS VARCHAR) + ' columns (expected 12)'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Law table has 12 columns'

PRINT ''

-- =============================================
-- 3. Verify new tables exist
-- =============================================
PRINT '--- Verifying new tables ---'

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Admin_ObjectiveSectionVisibility' AND type = 'U')
BEGIN PRINT 'FAIL: Admin_ObjectiveSectionVisibility missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Admin_ObjectiveSectionVisibility exists'

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_ObjectiveSectionVisibility' AND type = 'U')
BEGIN PRINT 'FAIL: Snapshot_ObjectiveSectionVisibility missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Snapshot_ObjectiveSectionVisibility exists'

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'FilterOption_Product' AND type = 'U')
BEGIN PRINT 'FAIL: FilterOption_Product missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: FilterOption_Product exists'

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'GenericRequirement_Cost' AND type = 'U')
BEGIN PRINT 'FAIL: GenericRequirement_Cost missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: GenericRequirement_Cost exists'

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_StepRequirementCost' AND type = 'U')
BEGIN PRINT 'FAIL: Snapshot_StepRequirementCost missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Snapshot_StepRequirementCost exists'

PRINT ''

-- =============================================
-- 4. Verify NTM tables dropped
-- =============================================
PRINT '--- Verifying NTM tables dropped ---'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmCountry' AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
BEGIN PRINT 'FAIL: NtmCountry still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: NtmCountry dropped'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmNotification' AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
BEGIN PRINT 'FAIL: NtmNotification still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: NtmNotification dropped'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmSubject' AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
BEGIN PRINT 'FAIL: NtmSubject still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: NtmSubject dropped'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmUser' AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
BEGIN PRINT 'FAIL: NtmUser still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: NtmUser dropped'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Imported_Tariff' AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
BEGIN PRINT 'FAIL: Imported_Tariff still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Imported_Tariff dropped'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Law_ConditionMeasure' AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
BEGIN PRINT 'FAIL: Law_ConditionMeasure still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Law_ConditionMeasure dropped'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Law_RelatedLaw' AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
BEGIN PRINT 'FAIL: Law_RelatedLaw still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Law_RelatedLaw dropped'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_Law' AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
BEGIN PRINT 'FAIL: Snapshot_Law still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Snapshot_Law dropped'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_Law_ConditionMeasure' AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
BEGIN PRINT 'FAIL: Snapshot_Law_ConditionMeasure still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Snapshot_Law_ConditionMeasure dropped'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_Law_RelatedLaw' AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
BEGIN PRINT 'FAIL: Snapshot_Law_RelatedLaw still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Snapshot_Law_RelatedLaw dropped'

PRINT ''

-- =============================================
-- 5. Verify backup data exists
-- =============================================
PRINT '--- Verifying backups ---'

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Law_PreSPA_Backup' AND type = 'U')
BEGIN PRINT 'FAIL: Law_PreSPA_Backup missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: Law_PreSPA_Backup exists (' + CAST((SELECT COUNT(*) FROM [dbo].[Law_PreSPA_Backup]) AS VARCHAR) + ' rows)'

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'ntm_backup')
BEGIN PRINT 'FAIL: ntm_backup schema missing'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: ntm_backup schema exists'

PRINT ''

-- =============================================
-- 6. Verify views exist
-- =============================================
PRINT '--- Verifying views ---'

DECLARE @viewNames TABLE (ViewName NVARCHAR(200))
INSERT INTO @viewNames VALUES
    ('Public_Medias'), ('view_Public_Menu_Mono'), ('view_Public_Objectives_Current'),
    ('view_Public_Regulations_Blocks'), ('view_Public_Treeview_For_Summary'),
    ('view_sub_Public_Menu_Level1'), ('view_sub_Public_Menu_Level2'),
    ('view_sub_Public_Menu_Level3'), ('view_sub_Public_Menu_Level4'),
    ('view_sub_Public_Menu_Level5'),
    ('v_translation_item'), ('Transfert'), ('VIEW_step_dbl'),
    ('VIEW2'), ('VIEW3'), ('VIEW4'), ('VIEW5'), ('VIEW6'),
    ('v_law'), ('v_public_review')

DECLARE @vName NVARCHAR(200)
DECLARE v_cursor CURSOR FOR SELECT ViewName FROM @viewNames
OPEN v_cursor
FETCH NEXT FROM v_cursor INTO @vName
WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.views WHERE name = @vName)
    BEGIN PRINT 'FAIL: View ' + @vName + ' missing'; SET @errors = @errors + 1 END
    ELSE PRINT 'OK: View ' + @vName + ' exists'
    FETCH NEXT FROM v_cursor INTO @vName
END
CLOSE v_cursor
DEALLOCATE v_cursor

PRINT ''

-- =============================================
-- 7. Verify stored procedures exist
-- =============================================
PRINT '--- Verifying stored procedures ---'

DECLARE @spNames TABLE (SpName NVARCHAR(200))
INSERT INTO @spNames VALUES
    ('sp_auditRecord_dynamic_search'), ('sp_entityincharge_dynamic_search'),
    ('sp_genericrequirement_dynamic_search'), ('sp_law_dynamic_search'),
    ('sp_media_dynamic_search'), ('sp_menu_dynamic_search'),
    ('sp_partner_dynamic_search'), ('sp_personincharge_dynamic_search'),
    ('sp_recourse_dynamic_search'), ('sp_regulation_dynamic_search'),
    ('sp_requirement_dynamic_search'), ('sp_translation_dynamic_search'),
    ('sp_translation_menu_dynamic_search'), ('sp_unitincharge_dynamic_search'),
    ('sp_xmlSerializedItem_dynamic_search'), ('sp_public_reviews_dynamic_search'),
    ('sp_cost_variables_translation_search'), ('sp_filter_translation_search'),
    ('sp_filteroption_translation_search'), ('sp_options_translation_search'),
    ('sp_site_menu_translation_search'),
    ('sp_feedback_menu_get_children'), ('sp_feedback_menu_get_first_level'),
    ('sp_feedback_objective_get_children'), ('sp_feedback_objective_get_first_level'),
    ('sp_on_published_block'), ('sp_on_published_step'), ('sp_on_published_recourse'),
    ('sp_on_updated_unitInCharge'), ('sp_on_updated_media'),
    ('sp_on_updated_entityInCharge'), ('sp_on_updated_genericRequirement'),
    ('sp_on_updated_law'), ('sp_snapshot_getStep'),
    ('sp_take_snapshot_objective'), ('sp_take_snapshot_step'),
    ('sp_update_snapshot_block'), ('sp_update_snapshot_recourse'),
    ('sp_update_snapshot_step')

DECLARE @spName NVARCHAR(200)
DECLARE sp_cursor CURSOR FOR SELECT SpName FROM @spNames
OPEN sp_cursor
FETCH NEXT FROM sp_cursor INTO @spName
WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = @spName AND type = 'P')
    BEGIN PRINT 'FAIL: Procedure ' + @spName + ' missing'; SET @errors = @errors + 1 END
    ELSE PRINT 'OK: Procedure ' + @spName + ' exists'
    FETCH NEXT FROM sp_cursor INTO @spName
END
CLOSE sp_cursor
DEALLOCATE sp_cursor

-- Verify sp_publish_legislation is dropped
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_publish_legislation' AND type = 'P')
BEGIN PRINT 'FAIL: sp_publish_legislation still exists'; SET @errors = @errors + 1 END
ELSE PRINT 'OK: sp_publish_legislation dropped'

PRINT ''

-- =============================================
-- 8. Verify foreign key constraints
-- =============================================
PRINT '--- Verifying foreign keys ---'

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Admin_ObjectiveSectionVisibility_Objective')
BEGIN PRINT 'WARN: FK_Admin_ObjectiveSectionVisibility_Objective missing (may need parent table)' END
ELSE PRINT 'OK: FK_Admin_ObjectiveSectionVisibility_Objective'

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FilterOption_Product_FilterOption')
BEGIN PRINT 'WARN: FK_FilterOption_Product_FilterOption missing (may need parent table)' END
ELSE PRINT 'OK: FK_FilterOption_Product_FilterOption'

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_GenericRequirement_Cost_GenericRequirement')
BEGIN PRINT 'WARN: FK_GenericRequirement_Cost_GenericRequirement missing (may need parent table)' END
ELSE PRINT 'OK: FK_GenericRequirement_Cost_GenericRequirement'

PRINT ''

-- =============================================
-- Summary
-- =============================================
PRINT '========================================='
IF @errors = 0
    PRINT 'VALIDATION PASSED: All checks successful'
ELSE
    PRINT 'VALIDATION FAILED: ' + CAST(@errors AS VARCHAR) + ' error(s) found'
PRINT '========================================='
GO
