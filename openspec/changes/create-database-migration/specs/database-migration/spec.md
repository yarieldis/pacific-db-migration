# Database Migration Specification

## ADDED Requirements

### Requirement: In-Place Database Migration
The migration scripts SHALL modify an existing old-structure database in-place to match the new EF6 schema, preserving all existing data.

#### Scenario: Execute migration against old database
- **WHEN** the migration scripts are executed in SSMS against an existing old-structure database
- **THEN** the database schema SHALL be modified to match the new EF6 structure
- **AND** no new database SHALL be created
- **AND** all existing data SHALL remain intact

#### Scenario: Scripts are self-contained T-SQL
- **WHEN** a migration script is opened in SSMS
- **THEN** it SHALL be executable without external dependencies
- **AND** it SHALL contain all necessary T-SQL commands for that migration step

---

### Requirement: Schema Column Additions
The migration script SHALL add new columns to existing tables to match the target EF6 schema structure.

#### Scenario: Add new columns to Admin_Step table
- **WHEN** the migration script is executed on the old database
- **THEN** the Admin_Step table SHALL have the following new columns:
  - `Level_Id` (int, NULL)
  - `NumberOfUsers` (int, NULL)
  - `Summary` (ntext, NULL)
  - `IsReachingOffice` (bit, NULL)

#### Scenario: Add new column to EntityInCharge table
- **WHEN** the migration script is executed on the old database
- **THEN** the EntityInCharge table SHALL have a new `Zone_Id` (int, NULL) column

#### Scenario: Add new column to GenericRequirement table
- **WHEN** the migration script is executed on the old database
- **THEN** the GenericRequirement table SHALL have a new `NumberOfPages` (int, NOT NULL, DEFAULT 0) column

#### Scenario: Add new column to Admin_StepResult table
- **WHEN** the migration script is executed on the old database
- **THEN** the Admin_StepResult table SHALL have a new `Document_Id` (int, NULL) column

#### Scenario: Add new column to Admin_StepRequirement table
- **WHEN** the migration script is executed on the old database
- **THEN** the Admin_StepRequirement table SHALL have a new `IsEmittedByInstitution` (bit, NOT NULL, DEFAULT 0) column

---

### Requirement: New Table Creation
The migration script SHALL create new tables required by the EF6 schema that do not exist in the old schema.

#### Scenario: Create EF6 Migration History table
- **WHEN** the migration script is executed
- **THEN** a `__MigrationHistory` table SHALL be created with columns for MigrationId, ContextKey, Model, and ProductVersion

#### Scenario: Create Admin_ObjectiveSectionVisibility table
- **WHEN** the migration script is executed
- **THEN** an `Admin_ObjectiveSectionVisibility` table SHALL be created with appropriate columns and primary key

#### Scenario: Create GenericRequirement_Cost table
- **WHEN** the migration script is executed
- **THEN** a `GenericRequirement_Cost` table SHALL be created to support cost tracking for requirements

---

### Requirement: Primary Key Naming Convention
The migration script SHALL rename primary key constraints to follow EF6 naming convention (`PK_dbo.TableName`).

#### Scenario: Rename primary keys on core tables
- **WHEN** the migration script is executed on the old database
- **THEN** all primary key constraints SHALL be renamed from `PK_TableName` format to `PK_dbo.TableName` format

#### Scenario: Idempotent primary key renaming
- **WHEN** a primary key has already been renamed to EF6 convention
- **THEN** the script SHALL skip the rename operation without error

---

### Requirement: View Updates
The migration script SHALL create or update database views to match the target schema.

#### Scenario: Create v_requirement view
- **WHEN** the migration script is executed
- **THEN** a `v_requirement` view SHALL be created that joins Admin_StepRequirement with GenericRequirement and Media tables

#### Scenario: Create v_genericrequirement view
- **WHEN** the migration script is executed
- **THEN** a `v_genericrequirement` view SHALL be created that provides requirement information with media and step counts

---

### Requirement: Stored Procedure Updates
The migration script SHALL update stored procedures to match the new schema definitions.

#### Scenario: Update sp_on_updated_genericRequirement
- **WHEN** the migration script is executed on the old database
- **THEN** the `sp_on_updated_genericRequirement` stored procedure SHALL be replaced with the new schema version

#### Scenario: Update sp_on_updated_objective
- **WHEN** the migration script is executed on the old database
- **THEN** the `sp_on_updated_objective` stored procedure SHALL be replaced with the new schema version

#### Scenario: Update snapshot stored procedures
- **WHEN** the migration script is executed on the old database
- **THEN** the following stored procedures SHALL be replaced with new schema versions:
  - `sp_take_snapshot_objective`
  - `sp_update_snapshot_block`
  - `sp_update_snapshot_recourse`
  - `sp_update_snapshot_step`

#### Scenario: Preserve legacy stored procedures
- **WHEN** a stored procedure exists in the old schema but not in the new schema
- **THEN** the stored procedure SHALL be preserved (not deleted)

---

### Requirement: Idempotent Migration Scripts
All migration scripts SHALL be idempotent and safe to re-run without causing errors or data loss.

#### Scenario: Re-running column addition scripts
- **WHEN** a migration script that adds columns is executed multiple times
- **THEN** the script SHALL check for column existence before adding and skip if already present

#### Scenario: Re-running table creation scripts
- **WHEN** a migration script that creates tables is executed multiple times
- **THEN** the script SHALL check for table existence before creating and skip if already present

---

### Requirement: Transaction Safety
All migration scripts SHALL use transactions to ensure atomic operations and enable rollback on failure.

#### Scenario: Successful migration transaction
- **WHEN** all operations in a migration script succeed
- **THEN** the transaction SHALL be committed and changes persisted

#### Scenario: Failed migration transaction
- **WHEN** any operation in a migration script fails
- **THEN** the transaction SHALL be rolled back and an error message displayed

---

### Requirement: Data Preservation
The migration script SHALL preserve all existing data during schema changes.

#### Scenario: Existing data unchanged after column addition
- **WHEN** new columns are added to existing tables
- **THEN** all existing rows SHALL retain their original column values
- **AND** new columns SHALL contain NULL or the specified default value

#### Scenario: Row counts preserved after migration
- **WHEN** the migration is complete
- **THEN** all table row counts SHALL match pre-migration counts
