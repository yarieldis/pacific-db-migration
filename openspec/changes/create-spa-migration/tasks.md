# Tasks: SPA Database Migration Scripts

> **Execution Model**: All migration scripts are T-SQL files designed to be executed in SQL Server Management Studio (SSMS) against an existing OLD-structure database. The scripts modify the database IN-PLACE to match the SPA schema (Argentina/Lomas de Zamora instance). Community-layer objects and Public_* denormalized tables are excluded from this migration scope.

## 1. Analysis & Preparation
- [x] 1.1 Complete detailed column-by-column comparison between old and SPA schemas
- [x] 1.2 Identify all columns that need to be added to existing tables (9 tables, ~15 columns)
- [x] 1.3 Identify all columns that need to be removed (Admin_Menu: 1, Law: 53)
- [x] 1.4 Identify all new tables to be created (5 tables)
- [x] 1.5 Identify all tables to be dropped (10 NTM/Law tables)
- [x] 1.6 Document all new views (18)
- [x] 1.7 Map foreign key dependencies for safe drop operations
- [x] 1.8 Compare view body content between old and SPA (22 identical, 2 structural, 1 cosmetic)
- [x] 1.9 Compare stored procedure body content between old and SPA (33 identical, 39 differ, 1 env-specific)

## 2. Migration Script: Add New Columns (010_add_new_columns.sql)
- [x] 2.1 Create script header with metadata and pre-conditions
- [x] 2.2 Add `Level_Id` (int NULL) to Admin_Step
- [x] 2.3 Add `NumberOfUsers` (int NULL) to Admin_Step
- [x] 2.4 Add `Summary` (ntext NULL) to Admin_Step
- [x] 2.5 Add `Summary` (ntext NULL) to Admin_Step_i18n
- [x] 2.6 Add `Zone_Id` (int NULL) to EntityInCharge
- [x] 2.7 Add `IsEmittedByInstitution` (bit NOT NULL DEFAULT 0) to GenericRequirement
- [x] 2.8 Add `NumberOfPages` (int NOT NULL DEFAULT 0) to GenericRequirement
- [x] 2.9 Add `Website` (nvarchar NULL) to UnitInCharge
- [x] 2.10 Add `FileName` (nvarchar NULL), `Extention` (nvarchar NULL), `Description` (ntext NULL), `Length` (decimal(18,0) NULL), `PreviewImageName` (nvarchar NULL) to Media_i18n
- [x] 2.11 Add `Status` (int NULL) to Feedback
- [x] 2.12 Add `IsProductRelated` (bit NOT NULL DEFAULT 0) to Filter
- [x] 2.13 Add `IsSummaryVisible` (bit NOT NULL DEFAULT 1) to Admin_StepSectionVisibility
- [x] 2.14 Add corresponding columns to Snapshot tables where applicable (Snapshot_Step: Level_Id, NumberOfUsers, Summary; Snapshot_StepSectionVisibility: IsSummaryVisible)

## 3. Migration Script: Remove Columns (011_remove_columns.sql)
- [x] 3.1 Create script header with metadata and pre-conditions
- [x] 3.2 Back up Law table data to `Law_PreSPA_Backup`
- [x] 3.3 Remove dependent constraints from Law table columns
- [x] 3.4 Remove 53 NTM/legislation columns from Law table (batch operation in 6 batches)
- [x] 3.5 Remove `IsVisibleInPublicHomePage` from Admin_Menu
- [x] 3.6 Verify remaining columns match SPA schema

## 4. Migration Script: Create New Tables (020_create_new_tables.sql)
- [x] 4.1 Create `Admin_ObjectiveSectionVisibility` table (10 columns)
- [x] 4.2 Create `Snapshot_ObjectiveSectionVisibility` table (10 columns, no PK - snapshot table)
- [x] 4.3 Create `FilterOption_Product` table (4 columns)
- [x] 4.4 Create `GenericRequirement_Cost` table (11 columns)
- [x] 4.5 Create `Snapshot_StepRequirementCost` table (10 columns, no PK - snapshot table)

## 5. Migration Script: Drop NTM Tables (030_drop_ntm_tables.sql)
- [x] 5.1 Create `ntm_backup` schema
- [x] 5.2 Copy NTM table data to backup schema (cursor-based archive)
- [x] 5.3 Drop foreign key constraints on NTM tables (dynamic FK discovery)
- [x] 5.4 Drop `NtmCountry`, `NtmNotification`, `NtmSubject`, `NtmUser`
- [x] 5.5 Drop `Imported_Tariff`
- [x] 5.6 Drop `Law_ConditionMeasure`, `Law_RelatedLaw`
- [x] 5.7 Drop `Snapshot_Law`, `Snapshot_Law_ConditionMeasure`, `Snapshot_Law_RelatedLaw`

## 6. Migration Script: Update Views (040_update_views.sql)
- [x] 6.1 Create 18 new views (Public_Medias, VIEW*, view_sub_*, view_Public_*, v_translation_item, Transfert, VIEW_step_dbl)
- [x] 6.2 DROP and CREATE `v_law` with SPA definition (15 columns removed, EntityInCharge JOIN removed)
- [x] 6.3 DROP and CREATE `v_public_review` with SPA definition (LEFT->INNER JOIN, legislation UNION removed)
- [x] 6.4 Verify all views exist (verification section included in script)

## 7. Migration Script: Update Stored Procedures (050_update_stored_procedures.sql)
- [x] 7.1 Update 16 dynamic search procedures (varchar -> nvarchar conversion)
  - `sp_auditRecord_dynamic_search`, `sp_entityincharge_dynamic_search`, `sp_genericrequirement_dynamic_search`, `sp_law_dynamic_search`, `sp_media_dynamic_search`, `sp_menu_dynamic_search`, `sp_partner_dynamic_search`, `sp_personincharge_dynamic_search`, `sp_recourse_dynamic_search`, `sp_regulation_dynamic_search`, `sp_requirement_dynamic_search`, `sp_translation_dynamic_search`, `sp_translation_menu_dynamic_search`, `sp_unitincharge_dynamic_search`, `sp_xmlSerializedItem_dynamic_search`, `sp_public_reviews_dynamic_search`
- [x] 7.2 Update 5 translation search procedures (varchar -> nvarchar + NULL i18n fallback)
  - `sp_cost_variables_translation_search`, `sp_filter_translation_search`, `sp_filteroption_translation_search`, `sp_options_translation_search`, `sp_site_menu_translation_search`
- [x] 7.3 Update 4 feedback procedures (add IsVisibleToGuest filter)
  - `sp_feedback_menu_get_children`, `sp_feedback_menu_get_first_level`, `sp_feedback_objective_get_children`, `sp_feedback_objective_get_first_level`
- [x] 7.4 Update 3 published procedures (SystemLanguage reformatting)
  - `sp_on_published_block`, `sp_on_published_step`, `sp_on_published_recourse`
- [x] 7.5 Update 2 column-aware procedures (new column support)
  - `sp_on_updated_unitInCharge` (Website), `sp_on_updated_media` (i18n-aware media fields)
- [x] 7.6 Update 9 structurally changed procedures
  - `sp_on_updated_entityInCharge` (GoogleMapsURL, Zone_Id, Snapshot_Object_Media, OnlineStepURL)
  - `sp_on_updated_genericRequirement` (NumberOfPages, IsEmittedByInstitution, StepRequirementCost sync)
  - `sp_on_updated_law` (removed IsLegislation, i18n media, Public_Generate_ALL call)
  - `sp_snapshot_getStep` (ROW_NUMBER windowed function replaces MAX/GROUP BY)
  - `sp_take_snapshot_objective` (StepRequirementCost/ObjectiveSectionVisibility sync, new columns)
  - `sp_take_snapshot_step` (Zone_Id, i18n media, StepRequirementCost, Website)
  - `sp_update_snapshot_block` (snapshot logic changes)
  - `sp_update_snapshot_recourse` (snapshot logic changes)
  - `sp_update_snapshot_step` (snapshot logic changes)

## 8. Migration Script: Drop Obsolete Procedures (060_drop_obsolete_procedures.sql)
- [x] 8.1 Drop `sp_publish_legislation`

## 9. Migration Script: Add Foreign Keys (070_add_foreign_keys.sql)
- [x] 9.1 Add FK for Admin_ObjectiveSectionVisibility -> Admin_Objective
- [x] 9.2 Add FK for Snapshot_ObjectiveSectionVisibility -> Registry
- [x] 9.3 Add FK for FilterOption_Product -> FilterOption
- [x] 9.4 Add FK for GenericRequirement_Cost -> GenericRequirement
- [x] 9.5 Add FK for Snapshot_StepRequirementCost -> Registry

## 10. Testing & Validation (080_validate_migration.sql)
- [x] 10.1 Create validation script to verify all new columns exist (20 column checks)
- [x] 10.2 Create script to verify removed columns are gone (4 checks including Law has exactly 12 columns)
- [x] 10.3 Create script to verify all 5 new tables exist
- [x] 10.4 Create script to verify all 10 NTM tables are dropped
- [x] 10.5 Create script to verify Law table has exactly 12 columns
- [x] 10.6 Create script to verify all 20 views exist (cursor-based check)
- [x] 10.7 Create script to verify all 39 updated stored procedures exist (cursor-based check)
- [x] 10.8 Verify backup tables (Law_PreSPA_Backup, ntm_backup schema) contain expected data

## 11. Documentation
- [x] 11.1 Document pre-migration checklist (embedded in 080_validate_migration.sql header)
- [x] 11.2 Document execution steps (script headers contain execution order 010-080)
- [x] 11.3 Document post-migration validation (080_validate_migration.sql)
- [x] 11.4 Document rollback procedure (011 creates Law_PreSPA_Backup, 030 creates ntm_backup schema)
- [x] 11.5 Document NTM data archival procedure (030_drop_ntm_tables.sql archive section)
- [x] 11.6 Document Law table restructuring rationale (011_remove_columns.sql header)
- [x] 11.7 Document stored procedure change categories and rationale (050 script header with 6 categories)
