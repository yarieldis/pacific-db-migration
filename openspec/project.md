# Project Context

## Purpose
Create migration scripts to upgrade the legacy Pacific/eRegulations database structure to the new Entity Framework 6 (EF6) database schema. The migration transforms the old database (Tuvalu instance) to match the new database structure (SouthSudan instance).

## Tech Stack
- SQL Server (migrating from compatibility level 100 to 150)
- Transact-SQL (T-SQL)
- Entity Framework 6 (EF6) target schema

## Project Conventions

### Code Style
- SQL files use uppercase for keywords (SELECT, FROM, WHERE)
- Table and column names use PascalCase with brackets: `[dbo].[TableName]`
- Indentation: tabs for SQL blocks
- All scripts include header comments with author, date, and description

### Architecture Patterns
- Migration scripts are numbered sequentially (001_, 002_, etc.)
- Each script is idempotent (safe to re-run)
- Scripts use transactions with TRY/CATCH for error handling
- Existence checks before CREATE/ALTER operations

### Testing Strategy
- Pre-migration: Document row counts and backup database
- Post-migration: Verify row counts, run integrity checks
- Validation scripts provided for each migration step

### Git Workflow
- Main branch for stable migrations
- Commit convention: `migration:`, `fix:`, `docs:`, `chore:`
- No AI/Claude authorship in commit messages

## Domain Context
- **eRegulations**: Trade portal system for government procedures
- **Admin_Step**: Represents steps in administrative procedures
- **EntityInCharge**: Government entities responsible for procedures
- **GenericRequirement**: Documents required for procedures
- **i18n tables**: Internationalization/translation tables (suffix `_i18n`)
- **Snapshot tables**: Point-in-time copies for versioning (prefix `Snapshot_`)

## Important Constraints
- Must preserve all existing data during migration
- Scripts must be idempotent (safe to re-run)
- Downtime required during migration (maintenance window)
- Full backup required before migration

## External Dependencies
- SQL Server 2019 (target compatibility level 150)
- Entity Framework 6 naming conventions
- Existing application code expects specific view structures
