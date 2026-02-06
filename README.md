# Pacific Database Migration

Migrate Pacific/eRegulations database from legacy structure to Entity Framework 6 (EF6) schema.

## Overview

This project contains migration scripts to upgrade an existing old-structure database (e.g., Tuvalu instance) to the new EF6-based schema (e.g., SouthSudan instance).

**Key Changes:**
- SQL Server compatibility level 100 → 150
- Primary key naming: `PK_TableName` → `PK_dbo.TableName`
- New columns on existing tables
- New tables for extended functionality
- Updated views and stored procedures

## Migration Scripts

Execute these scripts **in order** in SQL Server Management Studio (SSMS) against the old-structure database:

| Script | Description |
|--------|-------------|
| `001_add_new_columns.sql` | Adds new columns to Admin_Step, EntityInCharge, GenericRequirement, Admin_StepResult, Admin_StepRequirement, and Snapshot tables |
| `002_create_new_tables.sql` | Creates Admin_ObjectiveSectionVisibility, Snapshot_ObjectiveSectionVisibility, FilterOption_Product, GenericRequirement_Cost, Snapshot_StepRequirementCost |
| `003_rename_primary_keys.sql` | Renames PKs to EF6 convention (PK_dbo.TableName) |
| `004_update_views.sql` | Updates v_requirement, v_genericrequirement, v_entityInCharge |
| `005_update_stored_procedures.sql` | Updates stored procedures for new schema |
| `006_add_foreign_keys.sql` | Adds FK constraints for new tables |
| `007_create_migration_history.sql` | Creates __MigrationHistory table for EF6 |

## How to Use

### Pre-Migration Checklist

1. **Backup the database** before running any scripts
2. Document current row counts for key tables
3. Ensure no active connections during migration
4. Test scripts on a development/staging environment first

### Execution Steps

1. Open SQL Server Management Studio (SSMS)
2. Connect to the target database (old structure)
3. Open each script in order (001 through 007)
4. Execute each script and verify completion messages
5. After script 005, manually recreate complex stored procedures from `new-structure.sql`:
   - `sp_take_snapshot_objective`
   - `sp_update_snapshot_block`
   - `sp_update_snapshot_recourse`
   - `sp_update_snapshot_step`

### Post-Migration

1. Verify all scripts completed without errors
2. Run validation queries to confirm data integrity
3. Test application connectivity
4. Optionally update database compatibility level:
   ```sql
   ALTER DATABASE [YourDatabase] SET COMPATIBILITY_LEVEL = 150
   ```

## Project Structure

```
pacific-db-migration/
├── README.md                 # This file
├── CLAUDE.md                 # AI assistant instructions
├── old-structure.sql         # Source: Legacy database schema
├── new-structure.sql         # Target: EF6-based database schema
├── migrations/               # Migration scripts
│   ├── 001_add_new_columns.sql
│   ├── 002_create_new_tables.sql
│   ├── 003_rename_primary_keys.sql
│   ├── 004_update_views.sql
│   ├── 005_update_stored_procedures.sql
│   ├── 006_add_foreign_keys.sql
│   └── 007_create_migration_history.sql
└── openspec/                 # Design documentation
```

## Schema Changes Summary

### New Columns

| Table | Column | Type |
|-------|--------|------|
| Admin_Step | Level_Id | int NULL |
| Admin_Step | NumberOfUsers | int NULL |
| Admin_Step | Summary | nvarchar(max) NULL |
| Admin_Step | IsReachingOffice | bit NULL |
| EntityInCharge | Zone_Id | int NULL |
| GenericRequirement | NumberOfPages | int NOT NULL |
| Admin_StepResult | Document_Id | int NULL |
| Admin_StepRequirement | IsEmittedByInstitution | bit NOT NULL |

### New Tables

- `Admin_ObjectiveSectionVisibility`
- `Snapshot_ObjectiveSectionVisibility`
- `FilterOption_Product`
- `GenericRequirement_Cost`
- `Snapshot_StepRequirementCost`

## Notes

- All scripts are **idempotent** (safe to re-run)
- Scripts include existence checks before modifications
- Orphan records are cleaned up before adding FK constraints
- Progress is displayed via PRINT statements during execution
