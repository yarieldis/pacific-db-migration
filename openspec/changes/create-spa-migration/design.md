# Design: SPA Database Migration Scripts

## Context
The ePacific/eRegulations system needs to be upgraded from the legacy database schema (Tuvalu instance, compatibility level 100) to the SPA (Single Page Application) database structure (Libya instance, compatibility level 110). This migration covers schema-level changes (adding/removing columns, creating/dropping tables), updating views, creating 3 new stored procedures, updating 28 existing stored procedures, and dropping 1 obsolete procedure. The NTM module is removed entirely.

### Key Differences Between Schemas

| Aspect | Old Schema (Tuvalu) | SPA Schema (Libya) |
|--------|---------------------|--------------------------|
| Database | 30-dbe-Tradeportal-Tuvalu | 30-dbe-Libya |
| Compatibility Level | 100 (SQL 2008) | 110 (SQL 2012) |
| NTM Module | Present (7 tables) | Removed |
| Law Table | 65 columns | 12 columns (stripped) |
| Admin_Step | Basic columns | +Level_Id, NumberOfUsers, Summary, IsReachingOffice |
| Admin_StepRequirement | Basic columns | +IsEmittedByInstitution |
| PK Naming | `PK_TableName` | `PK_TableName` (unchanged) |
| Tables | 97 | 93 (5 new, 10 dropped, 24 altered) |
| Views (shared) | 25 | 22 identical, 2 structural changes, 1 cosmetic |
| Stored Procedures | 50 | 52 (21 identical, 28 updated, 3 new, 1 dropped) |

### Stored Procedure Change Patterns
A detailed body-level comparison revealed 8 categories of changes across 28 procedures:
1. **IsVisibleToGuest filter** (6 procs): Feedback/menu/objective procedures add guest visibility filtering
2. **GoogleMapsURL + Zone_Id** (6 procs): EntityInCharge-related snapshot procedures add new columns
3. **Level_Id, NumberOfUsers, Summary, IsReachingOffice** (3 procs): Admin_Step snapshot procedures add new step columns
4. **GenericRequirement_NumberOfPages** (4 procs): Requirement procedures add pages column
5. **Snapshot_StepRequirementCost** (4 procs): New cost table sync in snapshot procedures
6. **i18n-aware media handling** (7 procs): ISNULL fallback pattern for media fields
7. **OnlineStepURL logic** (1 proc): EntityInCharge procedure adds online step URL handling
8. **IsSummaryVisible** (1 proc): Section visibility procedure adds summary visibility

### Relationship to Existing EF6 Migration
The existing `create-database-migration` proposal targets the EF6/SouthSudan schema. This SPA migration targets a different schema (Libya) that:
- Does NOT use `PK_dbo.TableName` EF6 convention (keeps `PK_TableName`)
- Does NOT include `__MigrationHistory` table
- Has `IsEmittedByInstitution` on Admin_StepRequirement (NOT on GenericRequirement)
- Has `IsReachingOffice` on Admin_Step (EF6 also has it)
- Has compatibility level 110 (EF6 has 150)

## Goals / Non-Goals

### Goals
- Create idempotent migration scripts that can be safely re-run
- Preserve all existing data during migration (except NTM data which is intentionally removed)
- Add new columns with appropriate NULL/default values to 24 existing tables (12 base + 10 snapshot + 2 type changes/removals)
- Create 5 new tables required by SPA schema
- Safely drop 10 NTM/Law-related tables after data backup
- Restructure the Law table (remove 53 columns)
- Update 2 existing views with structural changes
- Create 3 new stored procedures
- Update 28 existing stored procedures to match SPA definitions
- Drop 1 obsolete stored procedure
- Add 6 new foreign key constraints
- Support rollback through pre-migration backups

### Non-Goals
- Migrate data between different databases (same database upgrade only)
- Change application code (database-only migration)
- Upgrade SQL Server version or compatibility level
- Modernize deprecated data types (ntext, text, image) - SPA schema still uses these
- Rename primary keys to EF6 convention (SPA does not use this convention)
- Create Community-layer stored procedures, functions, or views (out of scope)
- Create Public_* denormalized tables or ObjectTemplate (out of scope)
- Create new views (SPA has the same 25 views, no new ones needed)
- Optimize existing queries beyond what SPA schema requires

## Decisions

### Decision 1: Migration Script Organization
**What**: Organize migration into numbered sequential scripts, grouped by operation type
**Why**: Allows controlled execution, easier debugging, and selective re-runs

Structure:
```
spa-migrations/
├── 010_add_new_columns.sql                  # Add columns to ~13 existing tables
├── 011_remove_columns.sql                   # Remove columns (Law table restructure)
├── 020_create_new_tables.sql                # Create 5 new tables
├── 030_drop_ntm_tables.sql                  # Drop 10 NTM/Law tables (with safety checks)
├── 040_update_views.sql                     # Update 2 existing views (structural changes)
├── 050_create_new_stored_procedures.sql     # Create 3 new stored procedures
├── 051_update_stored_procedures.sql         # Update 28 existing stored procedures
├── 060_drop_obsolete_procedures.sql         # Drop sp_publish_legislation
├── 070_add_foreign_keys.sql                 # Add 6 FK constraints
└── 080_validate_migration.sql               # Post-migration validation
```

### Decision 2: Idempotent Scripts
**What**: All scripts check for existence before making changes
**Why**: Safe to re-run without errors; supports partial recovery

### Decision 3: Transaction Handling
**What**: Wrap each logical unit in a transaction with TRY/CATCH
**Why**: Ensures atomic operations; enables rollback on failure

### Decision 4: Law Table Restructuring Strategy
**What**: Back up Law data before removing columns, then ALTER TABLE to drop columns
**Why**: The Law table loses 53 columns - this is destructive and must be handled carefully

Steps:
1. Create a backup table `Law_PreSPA_Backup` with full Law data
2. Remove foreign keys referencing columns being dropped
3. Drop the 53 columns in batches
4. Verify remaining columns match SPA schema

### Decision 5: NTM Table Removal Strategy
**What**: Back up NTM data before dropping tables, then DROP TABLE
**Why**: NTM module is completely removed; data should be preserved for reference

Steps:
1. Create backup schema `ntm_backup`
2. Copy all NTM table data to backup schema
3. Drop foreign key constraints
4. Drop NTM tables

### Decision 6: Column Removal Approach
**What**: Use ALTER TABLE DROP COLUMN after removing dependent constraints
**Why**: Direct column removal is cleaner than recreating tables; preserves data in remaining columns

### Decision 7: Stored Procedure Update Strategy
**What**: Use DROP and CREATE pattern for all 28 updated stored procedures; CREATE for 3 new ones
**Why**: ALTER PROCEDURE could work but DROP/CREATE is cleaner for large changes and ensures the full new definition replaces the old one. Procedure bodies are extracted verbatim from new-spa-structure.sql.

Categories:
1. IsVisibleToGuest filter (6 procs) - Guest visibility filtering
2. GoogleMapsURL + Zone_Id (6 procs) - New EIC columns
3. Admin_Step new columns (3 procs) - Level_Id, NumberOfUsers, Summary, IsReachingOffice
4. GenericRequirement_NumberOfPages (4 procs) - Pages column
5. Snapshot_StepRequirementCost (4 procs) - New cost table sync
6. i18n-aware media handling (7 procs) - ISNULL fallback pattern
7. OnlineStepURL (1 proc) - Online step URL logic
8. IsSummaryVisible (1 proc) - Summary visibility

### Decision 8: View Update Strategy
**What**: DROP and CREATE for the 2 structurally changed views; leave cosmetic-only view (`v_personInCharge`) unchanged
**Why**: `v_law` and `v_public_review` have functional differences that must be applied. `v_personInCharge` has only comment/whitespace/casing changes with no functional impact.

### Decision 9: No New Views
**What**: Do NOT create any new views - both old and SPA schemas have exactly the same 25 views
**Why**: The previous analysis incorrectly identified 18 new views from the Argentina instance. The Libya SPA structure has identical view names to the old structure.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Law table data loss (53 columns removed) | Create Law_PreSPA_Backup table before any column drops |
| NTM data loss (10 tables dropped) | Create ntm_backup schema with full data copies |
| Foreign key violations during drops | Map all FK dependencies before dropping tables/columns |
| Stored procedure updates break app logic | Extract SP bodies verbatim from SPA structure; test thoroughly |
| v_public_review INNER JOIN is more restrictive | Verify no data is lost by excluding step tickets without Snapshot_Step rows |
| IsEmittedByInstitution on wrong table | Confirmed on Admin_StepRequirement (not GenericRequirement) in Libya schema |
| NumberOfPages DEFAULT value | Libya uses DEFAULT 1 (not 0); ensure migration script matches |

## Migration Plan

### Execution Environment
- **Tool**: SQL Server Management Studio (SSMS)
- **Target Database**: The existing old-structure database (NOT creating a new one)
- **Approach**: In-place modification - scripts ALTER the existing database to match SPA schema
- **Connection**: Connect SSMS to the old database, then execute scripts sequentially

### Pre-Migration
1. Take full database backup of the OLD database
2. Document current row counts for all tables
3. Ensure no active connections (maintenance mode)
4. Verify disk space for transaction logs
5. Back up NTM data separately for archival
6. Back up full Law table data separately

### Execution Order (in SSMS against the old database)
1. Run `010_add_new_columns.sql` - Add columns to ~13 existing tables
2. Run `011_remove_columns.sql` - Remove 53 columns from Law table
3. Run `020_create_new_tables.sql` - Create 5 new tables
4. Run `030_drop_ntm_tables.sql` - Drop 10 NTM/Law tables
5. Run `040_update_views.sql` - Update 2 existing views
6. Run `050_create_new_stored_procedures.sql` - Create 3 new stored procedures
7. Run `051_update_stored_procedures.sql` - Update 28 stored procedures
8. Run `060_drop_obsolete_procedures.sql` - Drop sp_publish_legislation
9. Run `070_add_foreign_keys.sql` - Add 6 FK constraints
10. Run `080_validate_migration.sql` - Validate migration

### Post-Migration
1. Verify row counts match pre-migration (except dropped tables)
2. Run integrity checks on foreign keys
3. Test updated views return data correctly
4. Test updated stored procedures (especially the structurally changed ones)
5. Test application functionality

### Rollback
1. Stop application
2. Restore from pre-migration backup
3. Restart application

## Open Questions

1. **Admin_StepRequirement.IsEmittedByInstitution**: This column exists on Admin_StepRequirement in Libya (not GenericRequirement as in Argentina). The sp_on_updated_StepRequirement procedure syncs this to snapshots. Should we verify this is the correct placement?
2. **Law table column removal**: Should we migrate any Law column data to other tables before dropping, or is all NTM-related data simply discarded?
3. **Deprecated data types**: The SPA schema still uses ntext/text/image. Should we take this opportunity to modernize to nvarchar(max)/varchar(max)/varbinary(max)?
4. **v_public_review JOIN change**: The LEFT OUTER -> INNER JOIN on Snapshot_Step is more restrictive. Is this intentional, and will any step tickets be lost?
5. **v_personInCharge cosmetic changes**: Should we apply the cosmetic-only changes (comment fix, casing) for consistency, or leave unchanged since there's no functional impact?
