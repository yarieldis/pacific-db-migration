# Design: SPA Database Migration Scripts

## Context
The ePacific/eRegulations system needs to be upgraded from the legacy database schema (Tuvalu instance, compatibility level 100) to the SPA (Single Page Application) database structure (Argentina/Lomas de Zamora instance). This migration covers schema-level changes (adding/removing columns, creating/dropping tables), updating views, and updating 39 existing stored procedures whose definitions differ between the two schemas. The NTM module is removed entirely.

### Key Differences Between Schemas

| Aspect | Old Schema (Tuvalu) | SPA Schema (Argentina) |
|--------|---------------------|------------------------|
| Compatibility Level | 100 (SQL 2008) | 100 (SQL 2008) |
| NTM Module | Present (7 tables) | Removed |
| Law Table | 65 columns | 12 columns (stripped) |
| PK Naming | `PK_TableName` | `PK_TableName` (unchanged) |
| Views (shared) | 25 | 22 identical, 2 structural changes, 1 cosmetic |
| Stored Procedures (shared) | 74 | 33 identical, 39 updated, 1 dropped, 1 env-specific |

### Stored Procedure Change Patterns
A detailed body-level comparison revealed 6 categories of changes across 39 procedures:
1. **varchar -> nvarchar** (16 procs): Unicode compatibility upgrade for dynamic search parameters
2. **varchar -> nvarchar + NULL i18n fallback** (5 procs): Translation search improvements with NULL handling
3. **IsVisibleToGuest filter** (4 procs): Feedback procedures now filter by guest visibility
4. **SystemLanguage reformatting** (3 procs): Query source/formatting changes
5. **New column support** (2 procs): UnitInCharge.Website, media i18n-aware fields
6. **Major structural** (9 procs): New snapshot columns, new table sync, algorithm changes

### Relationship to Existing EF6 Migration
The existing `create-database-migration` proposal targets the EF6/SouthSudan schema. This SPA migration targets a different schema (Argentina) that:
- Does NOT use `PK_dbo.TableName` EF6 convention (keeps `PK_TableName`)
- Does NOT include `__MigrationHistory` table
- Has `IsEmittedByInstitution` on GenericRequirement (EF6 does not)
- Does NOT have `IsReachingOffice` on Admin_Step (EF6 does)

## Goals / Non-Goals

### Goals
- Create idempotent migration scripts that can be safely re-run
- Preserve all existing data during migration (except NTM data which is intentionally removed)
- Add new columns with appropriate NULL/default values
- Create 5 new tables required by SPA schema
- Safely drop 10 NTM/Law-related tables after data backup
- Restructure the Law table (remove 53 columns)
- Create 18 new views
- Update 2 existing views with structural changes
- Update 39 existing stored procedures to match SPA definitions
- Drop 1 obsolete stored procedure
- Support rollback through pre-migration backups

### Non-Goals
- Migrate data between different databases (same database upgrade only)
- Change application code (database-only migration)
- Upgrade SQL Server version or compatibility level
- Modernize deprecated data types (ntext, text, image) - SPA schema still uses these
- Rename primary keys to EF6 convention (SPA does not use this convention)
- Create Community-layer stored procedures, functions, or views (out of scope)
- Create Public_* denormalized tables or ObjectTemplate (out of scope)
- Update environment-specific server names in procedures (skip `sp_Public_GetListOfStatusForUser_v4`)
- Optimize existing queries beyond what SPA schema requires

## Decisions

### Decision 1: Migration Script Organization
**What**: Organize migration into numbered sequential scripts, grouped by operation type
**Why**: Allows controlled execution, easier debugging, and selective re-runs

Structure:
```
spa-migrations/
├── 010_add_new_columns.sql                  # Add columns to existing tables
├── 011_remove_columns.sql                   # Remove columns (Law table restructure)
├── 020_create_new_tables.sql                # Create 5 new tables
├── 030_drop_ntm_tables.sql                  # Drop 10 NTM/Law tables (with safety checks)
├── 040_update_views.sql                     # Create 18 new views + update 2 existing
├── 050_update_stored_procedures.sql         # Update 39 existing stored procedures
├── 060_drop_obsolete_procedures.sql         # Drop sp_publish_legislation
└── 070_add_foreign_keys.sql                 # Add FK constraints for new tables
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
**What**: Use DROP and CREATE pattern for all 39 updated stored procedures
**Why**: ALTER PROCEDURE could work but DROP/CREATE is cleaner for large changes and ensures the full new definition replaces the old one. Procedure bodies are extracted verbatim from new-spa-structure.sql.

Batching by change category:
1. Dynamic search procedures (16) - varchar -> nvarchar conversion
2. Translation search procedures (5) - varchar -> nvarchar + NULL fallback
3. Feedback procedures (4) - IsVisibleToGuest filter
4. Published procedures (3) - SystemLanguage reformatting
5. Column-aware procedures (2) - New column support
6. Structural procedures (9) - Major logic changes

### Decision 8: View Update Strategy
**What**: DROP and CREATE for the 2 structurally changed views; leave cosmetic-only view (`v_personInCharge`) unchanged
**Why**: `v_law` and `v_public_review` have functional differences that must be applied. `v_personInCharge` has only comment/whitespace changes with no functional impact.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Law table data loss (53 columns removed) | Create Law_PreSPA_Backup table before any column drops |
| NTM data loss (10 tables dropped) | Create ntm_backup schema with full data copies |
| Admin_Menu column removal breaks app | Verify application doesn't rely on IsVisibleInPublicHomePage before removing |
| Foreign key violations during drops | Map all FK dependencies before dropping tables/columns |
| Stored procedure updates break app logic | Extract SP bodies verbatim from SPA structure; test thoroughly |
| sp_on_published_recourse references community_lang | Verify community_lang table/view exists or adjust |
| v_public_review INNER JOIN is more restrictive | Verify no data is lost by excluding step tickets without Snapshot_Step rows |

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
1. Run `010_add_new_columns.sql` - Add columns to existing tables
2. Run `011_remove_columns.sql` - Remove columns (Law restructure, Admin_Menu cleanup)
3. Run `020_create_new_tables.sql` - Create 5 new tables
4. Run `030_drop_ntm_tables.sql` - Drop 10 NTM/Law tables
5. Run `040_update_views.sql` - Create 18 new views + update 2 existing
6. Run `050_update_stored_procedures.sql` - Update 39 stored procedures
7. Run `060_drop_obsolete_procedures.sql` - Drop sp_publish_legislation
8. Run `070_add_foreign_keys.sql` - Add FK constraints

### Post-Migration
1. Verify row counts match pre-migration (except dropped tables)
2. Run integrity checks on foreign keys
3. Test all new and updated views return data correctly
4. Test updated stored procedures (especially the 9 structurally changed ones)
5. Test application functionality

### Rollback
1. Stop application
2. Restore from pre-migration backup
3. Restart application

## Open Questions

1. **View definitions**: The remaining 22 identical views don't need updates. Should we still DROP and CREATE them for consistency?
2. **Admin_Menu.IsVisibleInPublicHomePage**: Is the application currently using this column? Removing it is a breaking change.
3. **Law table column removal**: Should we migrate any Law column data to other tables before dropping, or is all NTM-related data simply discarded?
4. **Deprecated data types**: The SPA schema still uses ntext/text/image. Should we take this opportunity to modernize to nvarchar(max)/varchar(max)/varbinary(max)?
5. **sp_on_published_recourse**: The SPA version references `community_lang` instead of `SystemLanguage`. Does this table/view need to be created as part of this migration, or does it already exist?
6. **v_public_review JOIN change**: The LEFT -> INNER JOIN on Snapshot_Step is more restrictive. Is this intentional, and will any step tickets be lost?
