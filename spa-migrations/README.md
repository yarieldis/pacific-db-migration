# SPA Database Migration Scripts

These scripts migrate an existing old-structure (Tuvalu) database IN-PLACE to match the SPA schema (Argentina/Lomas de Zamora instance).

## Pre-requisites

1. **Back up your database** before running any scripts
2. Ensure no active connections to the database during migration
3. Document current row counts for key tables (for post-migration comparison)
4. Scripts are designed for execution in **SQL Server Management Studio (SSMS)**

## Execution Order

Run each script in SSMS against the target database, in this exact order:

| # | Script | Description |
|---|--------|-------------|
| 1 | `010_add_new_columns.sql` | Adds columns to 11 existing tables (Admin_Step, EntityInCharge, GenericRequirement, UnitInCharge, Media_i18n, Feedback, Filter, Admin_StepSectionVisibility, Snapshot_Step, Snapshot_StepSectionVisibility, Admin_Step_i18n) |
| 2 | `011_remove_columns.sql` | Backs up Law table to `Law_PreSPA_Backup`, removes 53 columns from Law, removes 1 column from Admin_Menu |
| 3 | `020_create_new_tables.sql` | Creates 5 new tables (Admin_ObjectiveSectionVisibility, Snapshot_ObjectiveSectionVisibility, FilterOption_Product, GenericRequirement_Cost, Snapshot_StepRequirementCost) |
| 4 | `030_drop_ntm_tables.sql` | Archives 10 NTM/Law tables to `ntm_backup` schema, then drops them |
| 5 | `040_update_views.sql` | Creates 18 new views + replaces 2 existing views (v_law, v_public_review) |
| 6 | `050_update_stored_procedures.sql` | Drops and recreates 39 stored procedures across 6 categories |
| 7 | `060_drop_obsolete_procedures.sql` | Drops `sp_publish_legislation` |
| 8 | `070_add_foreign_keys.sql` | Adds 5 foreign key constraints for the new tables |
| 9 | `080_validate_migration.sql` | Validates the entire migration (run last to verify) |

## What the scripts do NOT change

- **33 stored procedures** that are already identical between old and SPA schemas
- **22 views** that are already identical between old and SPA schemas
- **Community-layer objects** (excluded from scope)
- **Public_* denormalized tables** (excluded from scope)

## Post-migration notes

- New columns will have `NULL` or default values (no data migration included)
- New tables will be empty (structure only)
- `Law_PreSPA_Backup` table preserves the original Law data before column removal
- `ntm_backup` schema preserves archived NTM table data before table drops
- The 080 validation script prints a summary with pass/fail counts at the end

## Rollback

There is no automated rollback script. To revert:

- **Law columns**: Restore from `Law_PreSPA_Backup` table (created by script 011)
- **NTM tables**: Restore from `ntm_backup` schema (created by script 030)
- **Full rollback**: Restore from the database backup taken before migration
