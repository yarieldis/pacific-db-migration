# Change: Create Database Migration Script

## Why
The legacy ePacific/eRegulations database (Tuvalu instance, SQL Server 2008 compatibility level 100) needs to be upgraded to the new Entity Framework 6 schema (SouthSudan instance, SQL Server 2019 compatibility level 150). A migration script is required to transform the old database structure to the new one while preserving all existing data.

## Execution Model
- **Target**: An existing database with the OLD structure (e.g., Tuvalu instance)
- **Tool**: SQL Server Management Studio (SSMS)
- **Action**: Run migration scripts sequentially against the old database
- **Result**: The old database is modified IN-PLACE to match the new structure
- **Data**: All existing data is preserved; only schema is upgraded

The scripts do NOT create a new database. They ALTER the existing old-structure database to add missing columns, create new tables, rename constraints, and update views to match the new EF6 schema.

## What Changes

### Schema Changes
- **Admin_Step**: Add new columns `Level_Id`, `NumberOfUsers`, `Summary`, `IsReachingOffice`
- **EntityInCharge**: Add new column `Zone_Id` (already has `GoogleMapsURL`, `IsOnline`)
- **GenericRequirement**: Add new column `NumberOfPages`
- **Admin_StepResult**: Add new column `Document_Id`
- **Admin_StepRequirement**: Add new column `IsEmittedByInstitution`
- **Primary Key Naming**: Rename from `PK_TableName` to `PK_dbo.TableName` (EF6 convention)

### New Tables (if not exist)
- `__MigrationHistory` (EF6 migration tracking)
- `Admin_ObjectiveSectionVisibility`
- `Snapshot_ObjectiveSectionVisibility`
- `FilterOption_Product`
- `GenericRequirement_Cost`
- `Snapshot_StepRequirementCost`

### New Views
- `v_requirement`
- `v_genericrequirement`

### View Updates
- Update existing views to match new schema structure

### Stored Procedure Updates
The following stored procedures need to be updated/replaced to match new schema:
- `sp_on_updated_genericRequirement` - Update to match new schema
- `sp_on_updated_objective` - Update to match new schema
- `sp_take_snapshot_objective` - Update to match new schema
- `sp_update_snapshot_block` - Update to match new schema
- `sp_update_snapshot_recourse` - Update to match new schema
- `sp_update_snapshot_step` - Update to match new schema

Legacy stored procedures in old schema that are not in new schema will be preserved (no deletion).

## Impact
- **Affected tables**: ~70+ tables (core tables + i18n + snapshot tables)
- **Affected views**: ~10 views
- **Risk level**: High - requires careful transaction handling and data preservation
- **Downtime required**: Yes - recommend maintenance window
- **Rollback strategy**: Full database backup before migration
