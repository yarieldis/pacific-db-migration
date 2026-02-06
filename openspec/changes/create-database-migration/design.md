# Design: Database Migration Script

## Context
The ePacific/eRegulations system uses a SQL Server database that needs to be upgraded from the legacy schema (compatibility level 100) to the new EF6-based schema (compatibility level 150). The migration must preserve all existing data while adding new columns, tables, and updating constraints to match EF6 naming conventions.

### Key Differences Between Schemas

| Aspect | Old Schema (Tuvalu) | New Schema (SouthSudan) |
|--------|---------------------|-------------------------|
| Compatibility Level | 100 (SQL 2008) | 150 (SQL 2019) |
| PK Naming | `PK_TableName` | `PK_dbo.TableName` |
| EF Migration History | None | `__MigrationHistory` table |
| Admin_Step columns | Base columns | +Level_Id, NumberOfUsers, Summary, IsReachingOffice |
| EntityInCharge columns | Base + GoogleMapsURL, IsOnline | +Zone_Id |
| GenericRequirement | Base columns | +NumberOfPages |

## Goals / Non-Goals

### Goals
- Create idempotent migration scripts that can be safely re-run
- Preserve all existing data during migration
- Add new columns with appropriate NULL/default values
- Create new tables required by EF6 schema
- Update/recreate views to match new schema
- Rename primary key constraints to EF6 convention
- Support rollback through pre-migration backups

### Non-Goals
- Migrate data between different databases (same database upgrade only)
- Change application code (database-only migration)
- Upgrade SQL Server version (schema changes only)
- Optimize existing queries or indexes

## Decisions

### Decision 1: Migration Script Organization
**What**: Organize migration into numbered sequential scripts
**Why**: Allows controlled execution, easier debugging, and selective re-runs

Structure:
```
migrations/
├── 001_add_new_columns.sql            # Add missing columns to existing tables
├── 002_create_new_tables.sql          # Create tables that don't exist
├── 003_rename_primary_keys.sql        # Rename PKs to EF6 convention
├── 004_update_views.sql               # Drop and recreate views
├── 005_update_stored_procedures.sql   # Update SPs to match new schema
├── 006_add_foreign_keys.sql           # Add any new FK constraints
└── 007_create_migration_history.sql   # Add EF6 migration tracking
```

### Decision 2: Idempotent Scripts
**What**: All scripts check for existence before making changes
**Why**: Safe to re-run without errors; supports partial recovery

Pattern:
```sql
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NewColumn' AND object_id = OBJECT_ID('dbo.TableName'))
BEGIN
    ALTER TABLE [dbo].[TableName] ADD [NewColumn] [datatype] NULL
END
```

### Decision 3: Transaction Handling
**What**: Wrap each logical unit in a transaction with TRY/CATCH
**Why**: Ensures atomic operations; enables rollback on failure

### Decision 4: Primary Key Renaming Strategy
**What**: Use sp_rename to rename PK constraints
**Why**: Preserves data and indexes; minimal disruption

```sql
EXEC sp_rename N'PK_Admin_Step', N'PK_dbo.Admin_Step', N'OBJECT'
```

**Alternatives considered**:
- Drop and recreate PKs: More disruptive, requires dropping FKs first
- Leave PKs unchanged: Would not match EF6 expectations

### Decision 5: View Recreation
**What**: DROP and CREATE views (not ALTER)
**Why**: Some view changes are too significant for ALTER; cleaner approach

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Data loss during migration | Full backup required before running; transaction rollback on error |
| FK constraint violations | Scripts ordered to handle dependencies; clean orphan records first |
| Long execution time | Run during maintenance window; batch large data operations |
| Application compatibility | Test with application after migration; views maintain backward compatibility |
| PK rename breaks FKs | sp_rename preserves relationships; no FK changes needed |

## Migration Plan

### Execution Environment
- **Tool**: SQL Server Management Studio (SSMS)
- **Target Database**: The existing old-structure database (NOT the new-structure reference)
- **Approach**: In-place modification - scripts ALTER the existing database to match new schema
- **Connection**: Connect SSMS to the old database, then execute scripts sequentially

### Pre-Migration
1. Take full database backup of the OLD database
2. Document current row counts for all tables
3. Ensure no active connections (maintenance mode)
4. Verify disk space for transaction logs

### Execution Order (in SSMS against the old database)
1. Run `001_add_new_columns.sql` - Add columns to existing tables
2. Run `002_create_new_tables.sql` - Create new tables
3. Run `003_rename_primary_keys.sql` - Rename PK constraints
4. Run `004_update_views.sql` - Recreate views
5. Run `005_update_stored_procedures.sql` - Update stored procedures to match new schema
6. Run `006_add_foreign_keys.sql` - Add new FK constraints
7. Run `007_create_migration_history.sql` - Add EF6 tracking

### Post-Migration
1. Verify row counts match pre-migration
2. Run integrity checks on foreign keys
3. Test application functionality
4. Update compatibility level to 150

### Rollback
1. Stop application
2. Restore from pre-migration backup
3. Restart application

## Open Questions

1. **Zone table**: The new schema has `Zone_Id` on EntityInCharge - does a `Zone` table need to be created, or does it reference an existing table?
2. **Default values**: Should new NOT NULL columns have specific default values, or should existing rows be updated with calculated values?
3. **Snapshot tables**: Should snapshot tables receive the same column additions as their parent tables?
