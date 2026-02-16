-- =============================================
-- Migration: 080_validate_migration
-- Date: 2026-02-16
-- Description: Post-migration validation script.
--   Verifies all SPA migration changes have been applied correctly.
--   Run after all migration scripts (010-070) have completed.
-- Execution: Run in SSMS against the migrated database
-- Dependencies: All previous migration scripts (010-070)
-- =============================================

SET NOCOUNT ON;

PRINT '============================================='
PRINT '  SPA Migration Validation'
PRINT '  Started at: ' + CONVERT(varchar(30), GETDATE(), 120)
PRINT '============================================='
PRINT ''

DECLARE @pass int = 0
DECLARE @fail int = 0
DECLARE @total int = 0

-- Helper: Check column exists
-- We'll accumulate results manually

-- =========================================
-- SECTION 1: New Column Checks (~40 columns on 22 tables)
-- =========================================

PRINT '--- Section 1: New Column Existence Checks ---'
PRINT ''

-- Base tables (12)
-- Admin_Step: Level_Id, NumberOfUsers, Summary, IsReachingOffice
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Level_Id' AND object_id = OBJECT_ID('dbo.Admin_Step'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Admin_Step.Level_Id missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfUsers' AND object_id = OBJECT_ID('dbo.Admin_Step'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Admin_Step.NumberOfUsers missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Admin_Step'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Admin_Step.Summary missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsReachingOffice' AND object_id = OBJECT_ID('dbo.Admin_Step'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Admin_Step.IsReachingOffice missing' END
SET @total += 1

-- Admin_Step_i18n: Summary
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Admin_Step_i18n'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Admin_Step_i18n.Summary missing' END
SET @total += 1

-- Admin_StepRequirement: IsEmittedByInstitution
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsEmittedByInstitution' AND object_id = OBJECT_ID('dbo.Admin_StepRequirement'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Admin_StepRequirement.IsEmittedByInstitution missing' END
SET @total += 1

-- Admin_StepSectionVisibility: IsSummaryVisible
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsSummaryVisible' AND object_id = OBJECT_ID('dbo.Admin_StepSectionVisibility'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Admin_StepSectionVisibility.IsSummaryVisible missing' END
SET @total += 1

-- EntityInCharge: Zone_Id
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.EntityInCharge'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: EntityInCharge.Zone_Id missing' END
SET @total += 1

-- Feedback: Status
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Status' AND object_id = OBJECT_ID('dbo.Feedback'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Feedback.Status missing' END
SET @total += 1

-- Filter: IsProductRelated
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsProductRelated' AND object_id = OBJECT_ID('dbo.Filter'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Filter.IsProductRelated missing' END
SET @total += 1

-- GenericRequirement: NumberOfPages
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfPages' AND object_id = OBJECT_ID('dbo.GenericRequirement'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: GenericRequirement.NumberOfPages missing' END
SET @total += 1

-- Media_i18n: FileName, Extention, Description, Length, PreviewImageName
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'FileName' AND object_id = OBJECT_ID('dbo.Media_i18n'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Media_i18n.FileName missing' END
SET @total += 1
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Extention' AND object_id = OBJECT_ID('dbo.Media_i18n'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Media_i18n.Extention missing' END
SET @total += 1
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Description' AND object_id = OBJECT_ID('dbo.Media_i18n'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Media_i18n.Description missing' END
SET @total += 1
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Length' AND object_id = OBJECT_ID('dbo.Media_i18n'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Media_i18n.Length missing' END
SET @total += 1
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'PreviewImageName' AND object_id = OBJECT_ID('dbo.Media_i18n'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Media_i18n.PreviewImageName missing' END
SET @total += 1

-- Public_Team_Member: Phone, Email
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Phone' AND object_id = OBJECT_ID('dbo.Public_Team_Member'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Public_Team_Member.Phone missing' END
SET @total += 1
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Email' AND object_id = OBJECT_ID('dbo.Public_Team_Member'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Public_Team_Member.Email missing' END
SET @total += 1

-- UnitInCharge: Website
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.UnitInCharge'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: UnitInCharge.Website missing' END
SET @total += 1

-- UnitInCharge_i18n: Website
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.UnitInCharge_i18n'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: UnitInCharge_i18n.Website missing' END
SET @total += 1

-- Snapshot tables (10)
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ExplanatoryText' AND object_id = OBJECT_ID('dbo.Snapshot_Objective'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_Objective.ExplanatoryText missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Level_Id' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_Step.Level_Id missing' END
SET @total += 1
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NumberOfUsers' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_Step.NumberOfUsers missing' END
SET @total += 1
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Summary' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_Step.Summary missing' END
SET @total += 1
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsReachingOffice' AND object_id = OBJECT_ID('dbo.Snapshot_Step'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_Step.IsReachingOffice missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.Snapshot_StepEntityInCharge'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_StepEntityInCharge.Zone_Id missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.Snapshot_StepRecourseEntityInCharge'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_StepRecourseEntityInCharge.Zone_Id missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.Snapshot_StepRecourseUnitInCharge'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_StepRecourseUnitInCharge.Website missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'GoogleMapsURL' AND object_id = OBJECT_ID('dbo.Snapshot_StepRegionalEntityInCharge'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_StepRegionalEntityInCharge.GoogleMapsURL missing' END
SET @total += 1
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Zone_Id' AND object_id = OBJECT_ID('dbo.Snapshot_StepRegionalEntityInCharge'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_StepRegionalEntityInCharge.Zone_Id missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.Snapshot_StepRegionalUnitInCharge'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_StepRegionalUnitInCharge.Website missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'GenericRequirement_NumberOfPages' AND object_id = OBJECT_ID('dbo.Snapshot_StepRequirement'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_StepRequirement.GenericRequirement_NumberOfPages missing' END
SET @total += 1
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsEmittedByInstitution' AND object_id = OBJECT_ID('dbo.Snapshot_StepRequirement'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_StepRequirement.IsEmittedByInstitution missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsSummaryVisible' AND object_id = OBJECT_ID('dbo.Snapshot_StepSectionVisibility'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_StepSectionVisibility.IsSummaryVisible missing' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Website' AND object_id = OBJECT_ID('dbo.Snapshot_StepUnitInCharge'))
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_StepUnitInCharge.Website missing' END
SET @total += 1

PRINT '  Column checks: ' + CAST(@pass AS varchar(10)) + ' passed, ' + CAST(@fail AS varchar(10)) + ' failed (of ' + CAST(@total AS varchar(10)) + ')'

-- =========================================
-- SECTION 2: Column Type Modifications (2 checks)
-- =========================================

PRINT ''
PRINT '--- Section 2: Column Type Modification Checks ---'

-- Feedback.Email should be nvarchar(100) = 200 bytes max_length
IF EXISTS (SELECT 1 FROM sys.columns c WHERE c.name = 'Email' AND c.object_id = OBJECT_ID('dbo.Feedback') AND c.max_length = 200)
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Feedback.Email not nvarchar(100)' END
SET @total += 1

-- Feedback.Type should be NOT NULL
IF EXISTS (SELECT 1 FROM sys.columns c WHERE c.name = 'Type' AND c.object_id = OBJECT_ID('dbo.Feedback') AND c.is_nullable = 0)
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Feedback.Type still nullable' END
SET @total += 1

PRINT '  Type modification checks: ' + CAST(@pass AS varchar(10)) + ' total passed so far'

-- =========================================
-- SECTION 3: Law Table Structure (12 columns expected)
-- =========================================

PRINT ''
PRINT '--- Section 3: Law Table Column Count ---'

DECLARE @lawColCount int
SELECT @lawColCount = COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Law')
IF @lawColCount = 12
BEGIN SET @pass += 1 PRINT '  PASS: Law table has 12 columns' END
ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Law table has ' + CAST(@lawColCount AS varchar(10)) + ' columns (expected 12)' END
SET @total += 1

-- Snapshot_StepLaw.IsLegislation should NOT exist
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsLegislation' AND object_id = OBJECT_ID('dbo.Snapshot_StepLaw'))
BEGIN SET @pass += 1 PRINT '  PASS: Snapshot_StepLaw.IsLegislation removed' END
ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Snapshot_StepLaw.IsLegislation still exists' END
SET @total += 1

-- =========================================
-- SECTION 4: New Tables (5 tables)
-- =========================================

PRINT ''
PRINT '--- Section 4: New Table Existence ---'

DECLARE @newTables TABLE (TableName nvarchar(128), ExpectedCols int)
INSERT INTO @newTables VALUES
    ('Admin_ObjectiveSectionVisibility', 11),
    ('Snapshot_ObjectiveSectionVisibility', 11),
    ('FilterOption_Product', 4),
    ('GenericRequirement_Cost', 11),
    ('Snapshot_StepRequirementCost', 10)

DECLARE @ntName nvarchar(128), @ntExpCols int, @ntActCols int
DECLARE nt_cursor CURSOR FOR SELECT TableName, ExpectedCols FROM @newTables
OPEN nt_cursor
FETCH NEXT FROM nt_cursor INTO @ntName, @ntExpCols
WHILE @@FETCH_STATUS = 0
BEGIN
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = @ntName AND type = 'U')
    BEGIN
        SELECT @ntActCols = COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID('dbo.' + @ntName)
        IF @ntActCols = @ntExpCols
        BEGIN SET @pass += 1 PRINT '  PASS: ' + @ntName + ' exists (' + CAST(@ntActCols AS varchar(5)) + ' cols)' END
        ELSE BEGIN SET @fail += 1 PRINT '  FAIL: ' + @ntName + ' has ' + CAST(@ntActCols AS varchar(5)) + ' cols (expected ' + CAST(@ntExpCols AS varchar(5)) + ')' END
    END
    ELSE
    BEGIN SET @fail += 1 PRINT '  FAIL: ' + @ntName + ' does not exist' END
    SET @total += 1
    FETCH NEXT FROM nt_cursor INTO @ntName, @ntExpCols
END
CLOSE nt_cursor
DEALLOCATE nt_cursor

-- =========================================
-- SECTION 5: Dropped Tables (10 NTM tables should NOT exist)
-- =========================================

PRINT ''
PRINT '--- Section 5: Dropped Table Checks ---'

DECLARE @droppedTables TABLE (TableName nvarchar(128))
INSERT INTO @droppedTables VALUES
    ('NtmCountry'), ('NtmNotification'), ('NtmSubject'), ('NtmUser'),
    ('Imported_Tariff'), ('Law_ConditionMeasure'), ('Law_RelatedLaw'),
    ('Snapshot_Law'), ('Snapshot_Law_ConditionMeasure'), ('Snapshot_Law_RelatedLaw')

DECLARE @dtName nvarchar(128)
DECLARE dt_cursor CURSOR FOR SELECT TableName FROM @droppedTables
OPEN dt_cursor
FETCH NEXT FROM dt_cursor INTO @dtName
WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = @dtName AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
    BEGIN SET @pass += 1 END
    ELSE BEGIN SET @fail += 1 PRINT '  FAIL: ' + @dtName + ' still exists in dbo' END
    SET @total += 1
    FETCH NEXT FROM dt_cursor INTO @dtName
END
CLOSE dt_cursor
DEALLOCATE dt_cursor

PRINT '  Dropped table checks complete'

-- =========================================
-- SECTION 6: Views (25 total expected)
-- =========================================

PRINT ''
PRINT '--- Section 6: View Checks ---'

DECLARE @viewCount int
SELECT @viewCount = COUNT(*) FROM sys.views WHERE schema_id = SCHEMA_ID('dbo')
IF @viewCount = 25
BEGIN SET @pass += 1 PRINT '  PASS: 25 views exist' END
ELSE BEGIN SET @fail += 1 PRINT '  FAIL: ' + CAST(@viewCount AS varchar(5)) + ' views exist (expected 25)' END
SET @total += 1

-- Specific view checks
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_law')
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: v_law does not exist' END
SET @total += 1

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_public_review')
BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: v_public_review does not exist' END
SET @total += 1

-- =========================================
-- SECTION 7: Stored Procedures (3 new + 28 updated + 1 dropped)
-- =========================================

PRINT ''
PRINT '--- Section 7: Stored Procedure Checks ---'

-- 3 new SPs should exist
DECLARE @newSPs TABLE (SPName nvarchar(128))
INSERT INTO @newSPs VALUES
    ('sp_on_updated_StepRequirement'),
    ('sp_Public_GetFullReviews'),
    ('sp_snapshot_getStepRequirementCosts')

DECLARE @spName nvarchar(128)
DECLARE sp_cursor CURSOR FOR SELECT SPName FROM @newSPs
OPEN sp_cursor
FETCH NEXT FROM sp_cursor INTO @spName
WHILE @@FETCH_STATUS = 0
BEGIN
    IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = @spName)
    BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: New SP ' + @spName + ' does not exist' END
    SET @total += 1
    FETCH NEXT FROM sp_cursor INTO @spName
END
CLOSE sp_cursor
DEALLOCATE sp_cursor

-- 28 updated SPs should exist
DECLARE @updatedSPs TABLE (SPName nvarchar(128))
INSERT INTO @updatedSPs VALUES
    ('sp_feedback_menu_get_children'), ('sp_feedback_menu_get_first_level'),
    ('sp_feedback_objective_get_children'), ('sp_feedback_objective_get_first_level'),
    ('sp_on_updated_entityInCharge'), ('sp_on_updated_genericRequirement'),
    ('sp_on_updated_law'), ('sp_on_updated_media'),
    ('sp_on_updated_menu'), ('sp_on_updated_menu_tree'),
    ('sp_on_updated_objective'), ('sp_on_updated_personInCharge'),
    ('sp_on_updated_unitInCharge'), ('sp_snapshot_getStep'),
    ('sp_snapshot_getStepEICs'), ('sp_snapshot_getStepRecourses'),
    ('sp_snapshot_getStepRecourseUICs'), ('sp_snapshot_getStepRegionalEICs'),
    ('sp_snapshot_getStepRegionalPICs'),
    ('sp_snapshot_getStepRequirements'), ('sp_snapshot_getStepResults'),
    ('sp_snapshot_getStepSectionVisibility'), ('sp_snapshot_getStepUICs'),
    ('sp_take_snapshot_objective'), ('sp_take_snapshot_step'),
    ('sp_update_snapshot_block'), ('sp_update_snapshot_recourse'),
    ('sp_update_snapshot_step')

DECLARE usp_cursor CURSOR FOR SELECT SPName FROM @updatedSPs
OPEN usp_cursor
FETCH NEXT FROM usp_cursor INTO @spName
WHILE @@FETCH_STATUS = 0
BEGIN
    IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = @spName)
    BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Updated SP ' + @spName + ' does not exist' END
    SET @total += 1
    FETCH NEXT FROM usp_cursor INTO @spName
END
CLOSE usp_cursor
DEALLOCATE usp_cursor

-- 1 dropped SP should NOT exist
IF NOT EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_publish_legislation')
BEGIN SET @pass += 1 PRINT '  PASS: sp_publish_legislation dropped' END
ELSE BEGIN SET @fail += 1 PRINT '  FAIL: sp_publish_legislation still exists' END
SET @total += 1

-- =========================================
-- SECTION 8: Foreign Key Constraints (6)
-- =========================================

PRINT ''
PRINT '--- Section 8: Foreign Key Constraint Checks ---'

DECLARE @fkNames TABLE (FKName nvarchar(128))
INSERT INTO @fkNames VALUES
    ('FK_Admin_Step_Level'),
    ('FK_EntityInCharge_Zone'),
    ('FK_Admin_ObjectiveSectionVisibility_Objective'),
    ('FK_FilterOption_Product_FilterOption'),
    ('FK_GenericRequirement_Id'),
    ('FK_Level_Id')

DECLARE @fkName nvarchar(128)
DECLARE fk_cursor CURSOR FOR SELECT FKName FROM @fkNames
OPEN fk_cursor
FETCH NEXT FROM fk_cursor INTO @fkName
WHILE @@FETCH_STATUS = 0
BEGIN
    IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = @fkName)
    BEGIN SET @pass += 1 END ELSE BEGIN SET @fail += 1 PRINT '  FAIL: FK ' + @fkName + ' does not exist' END
    SET @total += 1
    FETCH NEXT FROM fk_cursor INTO @fkName
END
CLOSE fk_cursor
DEALLOCATE fk_cursor

-- =========================================
-- SECTION 9: Backup Verification
-- =========================================

PRINT ''
PRINT '--- Section 9: Backup Verification ---'

-- Law_PreSPA_Backup should exist
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Law_PreSPA_Backup' AND type = 'U')
BEGIN SET @pass += 1 PRINT '  PASS: Law_PreSPA_Backup exists' END
ELSE BEGIN SET @fail += 1 PRINT '  FAIL: Law_PreSPA_Backup does not exist' END
SET @total += 1

-- ntm_backup schema should exist
IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'ntm_backup')
BEGIN SET @pass += 1 PRINT '  PASS: ntm_backup schema exists' END
ELSE BEGIN SET @fail += 1 PRINT '  FAIL: ntm_backup schema does not exist' END
SET @total += 1

-- =========================================
-- SUMMARY
-- =========================================

PRINT ''
PRINT '============================================='
PRINT '  VALIDATION SUMMARY'
PRINT '============================================='
PRINT '  Total checks: ' + CAST(@total AS varchar(10))
PRINT '  Passed:       ' + CAST(@pass AS varchar(10))
PRINT '  Failed:       ' + CAST(@fail AS varchar(10))
PRINT ''

IF @fail = 0
    PRINT '  RESULT: ALL CHECKS PASSED - Migration validated successfully!'
ELSE
    PRINT '  RESULT: ' + CAST(@fail AS varchar(10)) + ' CHECK(S) FAILED - Review failures above'

PRINT ''
PRINT '  Finished at: ' + CONVERT(varchar(30), GETDATE(), 120)
PRINT '============================================='
GO
