# Tasks: Database Migration Script

## 1. Analysis & Preparation
- [ ] 1.1 Complete detailed column-by-column comparison between old and new schemas
- [ ] 1.2 Identify all columns that need to be added to existing tables
- [ ] 1.3 Identify all new tables that need to be created
- [ ] 1.4 Document all primary key naming changes required
- [ ] 1.5 Document all view definitions that need updating

## 2. Migration Script: Add New Columns (001_add_new_columns.sql)
- [ ] 2.1 Create script header with metadata and pre-conditions
- [ ] 2.2 Add `Level_Id` (int NULL) to Admin_Step
- [ ] 2.3 Add `NumberOfUsers` (int NULL) to Admin_Step
- [ ] 2.4 Add `Summary` (ntext NULL) to Admin_Step
- [ ] 2.5 Add `IsReachingOffice` (bit NULL) to Admin_Step
- [ ] 2.6 Add `Zone_Id` (int NULL) to EntityInCharge
- [ ] 2.7 Add `NumberOfPages` (int NOT NULL DEFAULT 0) to GenericRequirement
- [ ] 2.8 Add `Document_Id` (int NULL) to Admin_StepResult
- [ ] 2.9 Add `IsEmittedByInstitution` (bit NOT NULL DEFAULT 0) to Admin_StepRequirement
- [ ] 2.10 Add corresponding columns to Snapshot tables

## 3. Migration Script: Create New Tables (002_create_new_tables.sql)
- [ ] 3.1 Create `__MigrationHistory` table for EF6 tracking
- [ ] 3.2 Create `Admin_ObjectiveSectionVisibility` table
- [ ] 3.3 Create `Snapshot_ObjectiveSectionVisibility` table
- [ ] 3.4 Create `FilterOption_Product` table
- [ ] 3.5 Create `GenericRequirement_Cost` table
- [ ] 3.6 Create `Snapshot_StepRequirementCost` table

## 4. Migration Script: Rename Primary Keys (003_rename_primary_keys.sql)
- [ ] 4.1 Create script to rename all PKs from `PK_TableName` to `PK_dbo.TableName`
- [ ] 4.2 Include idempotent checks (skip if already renamed)
- [ ] 4.3 Handle all core tables
- [ ] 4.4 Handle all i18n tables
- [ ] 4.5 Handle all snapshot tables

## 5. Migration Script: Update Views (004_update_views.sql)
- [ ] 5.1 Create/update `v_requirement` view
- [ ] 5.2 Create/update `v_genericrequirement` view
- [ ] 5.3 Update `v_entityInCharge` view
- [ ] 5.4 Update `v_unitInCharge` view
- [ ] 5.5 Update `v_personInCharge` view
- [ ] 5.6 Update `v_menu_tree` view
- [ ] 5.7 Update `v_public_menu_tree` view

## 6. Migration Script: Add Foreign Keys (005_add_foreign_keys.sql)
- [ ] 6.1 Add FK for Admin_Step.Level_Id (if Level table exists)
- [ ] 6.2 Add FK for EntityInCharge.Zone_Id (if Zone table exists)
- [ ] 6.3 Add FK for Admin_StepResult.Document_Id to GenericRequirement
- [ ] 6.4 Add any other missing FK constraints from new schema

## 7. Migration Script: EF Migration History (006_create_migration_history.sql)
- [ ] 7.1 Create `__MigrationHistory` table with EF6 schema
- [ ] 7.2 Insert initial migration record to mark baseline

## 8. Testing & Validation
- [ ] 8.1 Create validation script to compare row counts
- [ ] 8.2 Create script to verify all new columns exist
- [ ] 8.3 Create script to verify all new tables exist
- [ ] 8.4 Create script to verify PK naming convention
- [ ] 8.5 Create script to test view queries

## 9. Documentation
- [ ] 9.1 Document pre-migration checklist
- [ ] 9.2 Document execution steps
- [ ] 9.3 Document post-migration validation
- [ ] 9.4 Document rollback procedure
