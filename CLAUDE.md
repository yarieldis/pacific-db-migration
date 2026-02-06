<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# CLAUDE.md - Pacific Database Migration

This file provides guidance to Claude Code when working with the **ePacific Database Migration** repository.

## Repository Overview

**Purpose**: Create migration scripts to upgrade the legacy Pacific/eRegulations database structure to the new Entity Framework 6 (EF6) database schema.

**Status**: Active development

**Technology Stack**:
- SQL Server (migrating from compatibility level 100 to 150)
- Transact-SQL (T-SQL)
- Entity Framework 6 (EF6) target schema
- Database migration scripts

## Project Structure

```
pacific-db-migration/
├── CLAUDE.md                 # AI assistant instructions
├── old-structure.sql         # Source: Legacy database schema (Tuvalu instance)
├── new-structure.sql         # Target: EF6-based database schema (SouthSudan instance)
├── migrations/               # Migration scripts (to be created)
│   ├── 001_schema_changes.sql
│   ├── 002_data_migration.sql
│   └── ...
└── README.md                 # Project documentation
```

## Database Schemas

### Old Structure (Source)
- **Database**: 30-dbe-Tradeportal-Tuvalu
- **Compatibility Level**: 100 (SQL Server 2008)
- **Key Patterns**:
  - `Admin_*_i18n` tables for translations (e.g., `Admin_Menu_i18n`)
  - `*HierarchicalData` tables for parent-child relationships
  - `*PerLangVisibility` tables for language-specific visibility
  - Primary keys named `PK_TableName`
  - Uses `ntext` columns (deprecated)
  - Schedule columns embedded directly in tables (7 days x 4 time slots)

### New Structure (Target)
- **Database**: 30-dbe-TradeportalSouthSudan
- **Compatibility Level**: 150 (SQL Server 2019)
- **Key Patterns**:
  - EF6 conventions: Primary keys named `PK_dbo.TableName`
  - `Media` table with `Admin_Object_Media` junction table for document management
  - Additional columns on `Admin_Step`: `Level_Id`, `NumberOfUsers`, `Summary`, `IsReachingOffice`
  - `GenericRequirement` with `NumberOfPages` column
  - Views optimized for EF6 consumption

## Key Tables to Migrate

### Core Tables
| Old Table | New Table | Key Changes |
|-----------|-----------|-------------|
| `Admin_Menu` | `Admin_Menu` | Schema changes |
| `Admin_Menu_i18n` | `Admin_Menu_i18n` | Verify structure |
| `Admin_Step` | `Admin_Step` | New columns: Level_Id, NumberOfUsers, Summary, IsReachingOffice |
| `EntityInCharge` | `EntityInCharge` | New columns: GoogleMapsURL, IsOnline, Zone_Id |
| `UnitInCharge` | `UnitInCharge` | Verify structure |
| `PersonInCharge` | `PersonInCharge` | Verify structure |
| `Law` | `Law` | Verify structure |
| N/A | `Media` | New table for document management |
| N/A | `Admin_Object_Media` | New junction table |
| N/A | `GenericRequirement` | May be new or restructured |
| N/A | `Admin_StepRequirement` | Verify if new |
| N/A | `Admin_StepResult` | Verify if new |

### Views to Update
- `v_menu_tree`
- `v_public_menu_tree`
- `v_menu_in_recycle_bin`
- `v_translation_menu`
- `v_entityInCharge`
- `v_unitInCharge`
- `v_personInCharge`
- `v_requirement` (new)
- `v_genericrequirement` (new)

## Migration Script Guidelines

### Script Naming Convention
```
NNN_description.sql
```
- `NNN`: Three-digit sequence number (001, 002, etc.)
- `description`: Brief description using underscores

### Script Structure
```sql
-- =============================================
-- Migration: NNN_description
-- Author: [Name]
-- Date: YYYY-MM-DD
-- Description: Brief description of changes
-- =============================================

-- Pre-migration checks
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'TableName')
BEGIN
    RAISERROR('Pre-condition failed: TableName does not exist', 16, 1)
    RETURN
END

-- Begin transaction
BEGIN TRANSACTION
BEGIN TRY

    -- Migration steps here

    COMMIT TRANSACTION
    PRINT 'Migration NNN completed successfully'
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Migration NNN failed: ' + ERROR_MESSAGE()
    THROW
END CATCH
GO
```

### Best Practices

1. **Always use transactions** for data modifications
2. **Include rollback scripts** where possible
3. **Add pre-condition checks** before running migrations
4. **Preserve data integrity** - never lose existing data
5. **Handle NULL values** explicitly during data migration
6. **Test on a copy** of the database first
7. **Document assumptions** in script comments

### Common Migration Patterns

#### Adding a New Column
```sql
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'NewColumn' AND object_id = OBJECT_ID('dbo.TableName'))
BEGIN
    ALTER TABLE [dbo].[TableName]
    ADD [NewColumn] [nvarchar](100) NULL
END
```

#### Adding a New Column with Default Value from Existing Data
```sql
ALTER TABLE [dbo].[TableName]
ADD [NewColumn] [int] NULL

UPDATE [dbo].[TableName]
SET [NewColumn] = [ExistingColumn]
WHERE [NewColumn] IS NULL
```

#### Creating a New Junction Table
```sql
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'JunctionTable' AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[JunctionTable](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [Parent_Id] [int] NOT NULL,
        [Child_Id] [int] NOT NULL,
        CONSTRAINT [PK_dbo.JunctionTable] PRIMARY KEY CLUSTERED ([Id] ASC)
    )

    ALTER TABLE [dbo].[JunctionTable]
    ADD CONSTRAINT [FK_JunctionTable_Parent] FOREIGN KEY ([Parent_Id]) REFERENCES [dbo].[Parent]([Id])

    ALTER TABLE [dbo].[JunctionTable]
    ADD CONSTRAINT [FK_JunctionTable_Child] FOREIGN KEY ([Child_Id]) REFERENCES [dbo].[Child]([Id])
END
```

#### Migrating i18n Data
```sql
-- Migrate translations from old i18n table to new structure
INSERT INTO [dbo].[NewTable_i18n] ([Parent_Id], [Lang], [Name], [Description])
SELECT [Parent_Id], [Lang], [Name], [Description]
FROM [dbo].[OldTable_i18n]
WHERE NOT EXISTS (
    SELECT 1 FROM [dbo].[NewTable_i18n] n
    WHERE n.[Parent_Id] = [OldTable_i18n].[Parent_Id]
    AND n.[Lang] = [OldTable_i18n].[Lang]
)
```

#### Updating Views
```sql
-- Drop and recreate view (views cannot be altered for major changes)
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_viewname')
BEGIN
    DROP VIEW [dbo].[v_viewname]
END
GO

CREATE VIEW [dbo].[v_viewname]
AS
    -- New view definition
GO
```

## Data Type Considerations

### Deprecated Types to Update
| Old Type | New Type | Notes |
|----------|----------|-------|
| `ntext` | `nvarchar(max)` | Direct conversion usually safe |
| `text` | `varchar(max)` | Direct conversion usually safe |
| `image` | `varbinary(max)` | For binary data |

### Conversion Script
```sql
-- Convert ntext to nvarchar(max)
ALTER TABLE [dbo].[TableName]
ALTER COLUMN [ColumnName] [nvarchar](max) NULL
```

## Foreign Key Handling

When adding foreign keys to existing data:
1. First, clean up orphan records
2. Then add the constraint

```sql
-- Clean up orphans
DELETE FROM [dbo].[ChildTable]
WHERE [Parent_Id] NOT IN (SELECT [Id] FROM [dbo].[ParentTable])

-- Add foreign key
ALTER TABLE [dbo].[ChildTable]
ADD CONSTRAINT [FK_ChildTable_ParentTable]
FOREIGN KEY ([Parent_Id]) REFERENCES [dbo].[ParentTable]([Id])
```

## Testing Migrations

### Pre-Migration Checklist
- [ ] Backup the database
- [ ] Document current row counts for key tables
- [ ] Verify no active connections during migration
- [ ] Test scripts on development/staging first

### Post-Migration Validation
```sql
-- Verify row counts
SELECT 'TableName' as TableName, COUNT(*) as RowCount FROM [dbo].[TableName]
UNION ALL
SELECT 'Table2', COUNT(*) FROM [dbo].[Table2]
-- etc.

-- Check for NULL values in required columns
SELECT * FROM [dbo].[TableName] WHERE [RequiredColumn] IS NULL

-- Verify foreign key integrity
SELECT c.*
FROM [dbo].[ChildTable] c
LEFT JOIN [dbo].[ParentTable] p ON c.[Parent_Id] = p.[Id]
WHERE p.[Id] IS NULL AND c.[Parent_Id] IS NOT NULL
```

## Version Control Guidelines

- **NEVER** commit changes without user approval
- Commit messages should follow convention:
  - `migration: Add new columns to Admin_Step`
  - `fix: Handle NULL values in EntityInCharge migration`
  - `docs: Update migration documentation`
  - `chore: Clean up deprecated migration scripts`
- **NEVER** mention AI/Claude authorship in commit messages

## Troubleshooting

### Common Issues

**Foreign Key Violations**
- Check for orphan records before adding constraints
- Use `NOCHECK` temporarily if needed, then clean data

**Timeout During Large Data Migrations**
- Process data in batches
- Increase command timeout
- Consider running during maintenance window

**Character Encoding Issues**
- Both databases use Unicode (nvarchar)
- Verify collation compatibility

**Identity Column Conflicts**
- Use `SET IDENTITY_INSERT ON` when migrating with specific IDs
- Remember to turn it off after

## Related Resources

- Original eRegulations database documentation
- Entity Framework 6 conventions
- SQL Server migration best practices
