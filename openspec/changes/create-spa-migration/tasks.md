# Tasks: SPA Database Migration Scripts

> **Execution Model**: All migration scripts are T-SQL files designed to be executed in SQL Server Management Studio (SSMS) against an existing OLD-structure database. The scripts modify the database IN-PLACE to match the SPA schema (Libya instance). Community-layer objects and Public_* denormalized tables are excluded from this migration scope.

## 1. Analysis & Preparation
- [x] 1.1 Complete detailed column-by-column comparison between old and SPA schemas
- [x] 1.2 Identify all columns that need to be added to existing tables (24 tables, ~40 columns)
- [x] 1.3 Identify all columns that need to be removed (Law: 53, Snapshot_StepLaw: 1)
- [x] 1.3b Identify all column type modifications (Feedback: Email nvarchar(30)->100, Type NULL->NOT NULL)
- [x] 1.4 Identify all new tables to be created (5 tables)
- [x] 1.5 Identify all tables to be dropped (10 NTM/Law tables)
- [x] 1.6 Identify all new FK constraints (6 constraints)
- [x] 1.7 Map foreign key dependencies for safe drop operations
- [x] 1.8 Compare view body content between old and SPA (22 identical, 2 structural, 1 cosmetic)
- [x] 1.9 Compare stored procedure body content between old and SPA (21 identical, 28 differ, 3 new, 1 dropped)

## 2. Migration Script: Add New Columns (010_add_new_columns.sql)
- [ ] 2.1 Create script header with metadata and pre-conditions
### Base tables (12 tables)
- [ ] 2.2 Add `Level_Id` (int NULL), `NumberOfUsers` (int NULL), `Summary` (ntext NULL), `IsReachingOffice` (bit NULL) to Admin_Step
- [ ] 2.3 Add `Summary` (ntext NULL) to Admin_Step_i18n
- [ ] 2.4 Add `IsEmittedByInstitution` (bit NOT NULL DEFAULT 0) to Admin_StepRequirement
- [ ] 2.5 Add `IsSummaryVisible` (bit NOT NULL DEFAULT 1) to Admin_StepSectionVisibility
- [ ] 2.6 Add `Zone_Id` (int NULL) to EntityInCharge
- [ ] 2.7 Add `Status` (int NOT NULL) to Feedback
- [ ] 2.8 Add `IsProductRelated` (bit NOT NULL DEFAULT 0) to Filter
- [ ] 2.9 Add `NumberOfPages` (int NOT NULL DEFAULT 1) to GenericRequirement
- [ ] 2.10 Add `FileName` (nvarchar(500) NULL), `Extention` (nvarchar(15) NULL), `Description` (ntext NULL), `Length` (decimal(18,0) NULL), `PreviewImageName` (nvarchar(100) NULL) to Media_i18n
- [ ] 2.11 Add `Phone` (nvarchar(50) NULL), `Email` (nvarchar(100) NULL) to Public_Team_Member
- [ ] 2.12 Add `Website` (nvarchar(255) NULL) to UnitInCharge
- [ ] 2.13 Add `Website` (nvarchar(255) NULL) to UnitInCharge_i18n
### Snapshot tables (10 tables)
- [ ] 2.14 Add `ExplanatoryText` (ntext NULL) to Snapshot_Objective
- [ ] 2.15 Add `Level_Id` (int NULL), `NumberOfUsers` (int NULL), `Summary` (ntext NULL), `IsReachingOffice` (bit NULL) to Snapshot_Step
- [ ] 2.16 Add `Zone_Id` (int NULL) to Snapshot_StepEntityInCharge
- [ ] 2.17 Add `Zone_Id` (int NULL) to Snapshot_StepRecourseEntityInCharge
- [ ] 2.18 Add `Website` (nvarchar(255) NULL) to Snapshot_StepRecourseUnitInCharge
- [ ] 2.19 Add `GoogleMapsURL` (nvarchar(800) NULL), `Zone_Id` (int NULL) to Snapshot_StepRegionalEntityInCharge
- [ ] 2.20 Add `Website` (nvarchar(255) NULL) to Snapshot_StepRegionalUnitInCharge
- [ ] 2.21 Add `GenericRequirement_NumberOfPages` (int NOT NULL DEFAULT 1), `IsEmittedByInstitution` (bit NOT NULL) to Snapshot_StepRequirement
- [ ] 2.22 Add `IsSummaryVisible` (bit NOT NULL) to Snapshot_StepSectionVisibility
- [ ] 2.23 Add `Website` (nvarchar(255) NULL) to Snapshot_StepUnitInCharge
### Column type modifications (1 table)
- [ ] 2.24 Alter Feedback.Email from nvarchar(30) to nvarchar(100)
- [ ] 2.25 Alter Feedback.Type from int NULL to int NOT NULL

## 3. Migration Script: Remove Columns (011_remove_columns.sql)
- [ ] 3.1 Create script header with metadata and pre-conditions
- [ ] 3.2 Back up Law table data to `Law_PreSPA_Backup`
- [ ] 3.3 Remove dependent constraints from Law table columns
- [ ] 3.4 Remove 53 NTM/legislation columns from Law table (batch operation)
- [ ] 3.5 Verify remaining Law columns match SPA schema (12 columns)
- [ ] 3.6 Remove `IsLegislation` (bit NOT NULL) from Snapshot_StepLaw

## 4. Migration Script: Create New Tables (020_create_new_tables.sql)
- [ ] 4.1 Create `Admin_ObjectiveSectionVisibility` table (11 columns)
- [ ] 4.2 Create `Snapshot_ObjectiveSectionVisibility` table (11 columns)
- [ ] 4.3 Create `FilterOption_Product` table (4 columns)
- [ ] 4.4 Create `GenericRequirement_Cost` table (11 columns)
- [ ] 4.5 Create `Snapshot_StepRequirementCost` table (10 columns)

## 5. Migration Script: Drop NTM Tables (030_drop_ntm_tables.sql)
- [ ] 5.1 Create `ntm_backup` schema
- [ ] 5.2 Copy NTM table data to backup schema (cursor-based archive)
- [ ] 5.3 Drop foreign key constraints on NTM tables (dynamic FK discovery)
- [ ] 5.4 Drop `NtmCountry`, `NtmNotification`, `NtmSubject`, `NtmUser`
- [ ] 5.5 Drop `Imported_Tariff`
- [ ] 5.6 Drop `Law_ConditionMeasure`, `Law_RelatedLaw`
- [ ] 5.7 Drop `Snapshot_Law`, `Snapshot_Law_ConditionMeasure`, `Snapshot_Law_RelatedLaw`

## 6. Migration Script: Update Views (040_update_views.sql)
- [ ] 6.1 DROP and CREATE `v_law` with SPA definition (15 columns removed, EntityInCharge JOIN removed)
- [ ] 6.2 DROP and CREATE `v_public_review` with SPA definition (LEFT OUTER->INNER JOIN, legislation UNION removed)
- [ ] 6.3 Verify all views exist (verification section included in script)

## 7. Migration Script: Create New Stored Procedures (050_create_new_stored_procedures.sql)
- [ ] 7.1 Create `sp_on_updated_StepRequirement` (IsEmittedByInstitution, NumberOfPages sync to snapshots)
- [ ] 7.2 Create `sp_Public_GetFullReviews` (public review retrieval)
- [ ] 7.3 Create `sp_snapshot_getStepRequirementCosts` (step requirement costs from snapshots)

## 8. Migration Script: Update Stored Procedures (051_update_stored_procedures.sql)
- [ ] 8.1 Update 6 IsVisibleToGuest procedures
  - `sp_feedback_menu_get_children`, `sp_feedback_menu_get_first_level`, `sp_feedback_objective_get_children`, `sp_feedback_objective_get_first_level`, `sp_on_updated_menu_tree`, `sp_on_updated_objective`
- [ ] 8.2 Update 6 GoogleMapsURL + Zone_Id procedures
  - `sp_on_updated_entityInCharge`, `sp_snapshot_getStepEICs`, `sp_snapshot_getStepRegionalEICs`, `sp_take_snapshot_step`, `sp_update_snapshot_recourse`, `sp_update_snapshot_step`
- [ ] 8.3 Update 3 Admin_Step new column procedures (Level_Id, NumberOfUsers, Summary, IsReachingOffice)
  - `sp_snapshot_getStep`, `sp_take_snapshot_step`, `sp_update_snapshot_step`
- [ ] 8.4 Update 4 GenericRequirement_NumberOfPages procedures
  - `sp_on_updated_genericRequirement`, `sp_snapshot_getStepRequirements`, `sp_take_snapshot_step`, `sp_update_snapshot_step`
- [ ] 8.5 Update 4 Snapshot_StepRequirementCost procedures
  - `sp_on_updated_genericRequirement`, `sp_take_snapshot_objective`, `sp_take_snapshot_step`, `sp_update_snapshot_step`
- [ ] 8.6 Update 7 i18n-aware media handling procedures
  - `sp_on_updated_entityInCharge`, `sp_on_updated_law`, `sp_on_updated_media`, `sp_on_updated_personInCharge`, `sp_on_updated_unitInCharge`, `sp_take_snapshot_step`, `sp_update_snapshot_step`
- [ ] 8.7 Update remaining changed procedures
  - `sp_on_updated_entityInCharge` (OnlineStepURL), `sp_snapshot_getStepSectionVisibility` (IsSummaryVisible), `sp_on_updated_law` (IsLegislation removal, Public_Generate_ALL), `sp_on_updated_menu` (IsVisibleToGuest), `sp_snapshot_getStepRecourses`, `sp_snapshot_getStepRecourseUICs`, `sp_snapshot_getStepRegionalPICs`, `sp_snapshot_getStepResults`, `sp_snapshot_getStepUICs`, `sp_update_snapshot_block`

## 9. Migration Script: Drop Obsolete Procedures (060_drop_obsolete_procedures.sql)
- [ ] 9.1 Drop `sp_publish_legislation`

## 10. Migration Script: Add Foreign Keys (070_add_foreign_keys.sql)
- [ ] 10.1 Add FK for Admin_Step.Level_Id -> Option.Id (FK_Admin_Step_Level)
- [ ] 10.2 Add FK for EntityInCharge.Zone_Id -> Option.Id (FK_EntityInCharge_Zone)
- [ ] 10.3 Add FK for Admin_ObjectiveSectionVisibility.Objective_Id -> Admin_Objective.Id
- [ ] 10.4 Add FK for FilterOption_Product.FilterOption_Id -> FilterOption.Id
- [ ] 10.5 Add FK for GenericRequirement_Cost.GenericRequirement_Id -> GenericRequirement.Id
- [ ] 10.6 Add FK for GenericRequirement_Cost.Level_Id -> Option.Id

## 11. Testing & Validation (080_validate_migration.sql)
- [ ] 11.1 Create validation script to verify all new columns exist (~40 column checks across 22 tables) and type changes (2 checks)
- [ ] 11.2 Create script to verify Law table has exactly 12 columns
- [ ] 11.3 Create script to verify all 5 new tables exist
- [ ] 11.4 Create script to verify all 10 NTM tables are dropped
- [ ] 11.5 Create script to verify all 25 views exist (unchanged count)
- [ ] 11.6 Create script to verify all 3 new + 28 updated stored procedures exist
- [ ] 11.7 Create script to verify all 6 FK constraints exist
- [ ] 11.8 Verify backup tables (Law_PreSPA_Backup, ntm_backup schema) contain expected data

## 12. Documentation
- [ ] 12.1 Document pre-migration checklist (embedded in 080_validate_migration.sql header)
- [ ] 12.2 Document execution steps (script headers contain execution order 010-080)
- [ ] 12.3 Document post-migration validation (080_validate_migration.sql)
- [ ] 12.4 Document rollback procedure (011 creates Law_PreSPA_Backup, 030 creates ntm_backup schema)
- [ ] 12.5 Document NTM data archival procedure (030_drop_ntm_tables.sql archive section)
- [ ] 12.6 Document Law table restructuring rationale (011_remove_columns.sql header)
- [ ] 12.7 Document stored procedure change categories and rationale (050/051 script headers with 8 categories)
