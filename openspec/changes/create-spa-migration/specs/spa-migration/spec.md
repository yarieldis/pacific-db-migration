# SPA Database Migration Specification

## ADDED Requirements

### Requirement: In-Place Database Migration to SPA Schema
The migration scripts SHALL modify an existing old-structure database in-place to match the SPA schema (Libya instance), preserving all existing non-NTM data.

#### Scenario: Execute migration against old database
- **WHEN** the migration scripts are executed in SSMS against an existing old-structure database
- **THEN** the database schema SHALL be modified to match the SPA structure
- **AND** no new database SHALL be created
- **AND** all existing non-NTM data SHALL remain intact

#### Scenario: Scripts are self-contained T-SQL
- **WHEN** a migration script is opened in SSMS
- **THEN** it SHALL be executable without external dependencies
- **AND** it SHALL contain all necessary T-SQL commands for that migration step

---

### Requirement: Schema Column Additions
The migration scripts SHALL add new columns to existing tables to match the SPA schema structure.

#### Scenario: Add new columns to Admin_Step table
- **WHEN** the migration script is executed on the old database
- **THEN** the Admin_Step table SHALL have the following new columns:
  - `Level_Id` (int, NULL)
  - `NumberOfUsers` (int, NULL)
  - `Summary` (ntext, NULL)
  - `IsReachingOffice` (bit, NULL)

#### Scenario: Add Summary column to Admin_Step_i18n table
- **WHEN** the migration script is executed on the old database
- **THEN** the Admin_Step_i18n table SHALL have a new `Summary` (ntext, NULL) column

#### Scenario: Add new column to Admin_StepRequirement table
- **WHEN** the migration script is executed on the old database
- **THEN** the Admin_StepRequirement table SHALL have a new `IsEmittedByInstitution` (bit, NOT NULL, DEFAULT 0) column

#### Scenario: Add new column to Admin_StepSectionVisibility table
- **WHEN** the migration script is executed on the old database
- **THEN** the Admin_StepSectionVisibility table SHALL have a new `IsSummaryVisible` (bit, NOT NULL, DEFAULT 1) column

#### Scenario: Add new column to EntityInCharge table
- **WHEN** the migration script is executed on the old database
- **THEN** the EntityInCharge table SHALL have a new `Zone_Id` (int, NULL) column

#### Scenario: Add new column to Feedback table
- **WHEN** the migration script is executed on the old database
- **THEN** the Feedback table SHALL have a new `Status` (int, NOT NULL) column

#### Scenario: Add new column to Filter table
- **WHEN** the migration script is executed on the old database
- **THEN** the Filter table SHALL have a new `IsProductRelated` (bit, NOT NULL, DEFAULT 0) column

#### Scenario: Add new column to GenericRequirement table
- **WHEN** the migration script is executed on the old database
- **THEN** the GenericRequirement table SHALL have a new `NumberOfPages` (int, NOT NULL, DEFAULT 1) column

#### Scenario: Add new columns to Media_i18n table
- **WHEN** the migration script is executed on the old database
- **THEN** the Media_i18n table SHALL have new columns:
  - `FileName` (nvarchar(500), NULL)
  - `Extention` (nvarchar(15), NULL)
  - `Description` (ntext, NULL)
  - `Length` (decimal(18,0), NULL)
  - `PreviewImageName` (nvarchar(100), NULL)

#### Scenario: Add new columns to Public_Team_Member table
- **WHEN** the migration script is executed on the old database
- **THEN** the Public_Team_Member table SHALL have new columns:
  - `Phone` (nvarchar(50), NULL)
  - `Email` (nvarchar(100), NULL)

#### Scenario: Add new column to UnitInCharge table
- **WHEN** the migration script is executed on the old database
- **THEN** the UnitInCharge table SHALL have a new `Website` (nvarchar(255), NULL) column

#### Scenario: Add new column to UnitInCharge_i18n table
- **WHEN** the migration script is executed on the old database
- **THEN** the UnitInCharge_i18n table SHALL have a new `Website` (nvarchar(255), NULL) column

#### Scenario: Add new column to Snapshot_Objective table
- **WHEN** the migration script is executed on the old database
- **THEN** the Snapshot_Objective table SHALL have a new `ExplanatoryText` (ntext, NULL) column

#### Scenario: Add new columns to Snapshot_Step table
- **WHEN** the migration script is executed on the old database
- **THEN** the Snapshot_Step table SHALL have new columns:
  - `Level_Id` (int, NULL)
  - `NumberOfUsers` (int, NULL)
  - `Summary` (ntext, NULL)
  - `IsReachingOffice` (bit, NULL)

#### Scenario: Add new column to Snapshot_StepEntityInCharge table
- **WHEN** the migration script is executed on the old database
- **THEN** the Snapshot_StepEntityInCharge table SHALL have a new `Zone_Id` (int, NULL) column

#### Scenario: Add new column to Snapshot_StepRecourseEntityInCharge table
- **WHEN** the migration script is executed on the old database
- **THEN** the Snapshot_StepRecourseEntityInCharge table SHALL have a new `Zone_Id` (int, NULL) column

#### Scenario: Add new column to Snapshot_StepRecourseUnitInCharge table
- **WHEN** the migration script is executed on the old database
- **THEN** the Snapshot_StepRecourseUnitInCharge table SHALL have a new `Website` (nvarchar(255), NULL) column

#### Scenario: Add new columns to Snapshot_StepRegionalEntityInCharge table
- **WHEN** the migration script is executed on the old database
- **THEN** the Snapshot_StepRegionalEntityInCharge table SHALL have new columns:
  - `GoogleMapsURL` (nvarchar(800), NULL)
  - `Zone_Id` (int, NULL)

#### Scenario: Add new column to Snapshot_StepRegionalUnitInCharge table
- **WHEN** the migration script is executed on the old database
- **THEN** the Snapshot_StepRegionalUnitInCharge table SHALL have a new `Website` (nvarchar(255), NULL) column

#### Scenario: Add new columns to Snapshot_StepRequirement table
- **WHEN** the migration script is executed on the old database
- **THEN** the Snapshot_StepRequirement table SHALL have new columns:
  - `GenericRequirement_NumberOfPages` (int, NOT NULL, DEFAULT 1)
  - `IsEmittedByInstitution` (bit, NOT NULL)

#### Scenario: Add new column to Snapshot_StepSectionVisibility table
- **WHEN** the migration script is executed on the old database
- **THEN** the Snapshot_StepSectionVisibility table SHALL have a new `IsSummaryVisible` (bit, NOT NULL) column

#### Scenario: Add new column to Snapshot_StepUnitInCharge table
- **WHEN** the migration script is executed on the old database
- **THEN** the Snapshot_StepUnitInCharge table SHALL have a new `Website` (nvarchar(255), NULL) column

---

### Requirement: Schema Column Type Modifications
The migration scripts SHALL modify column types on existing tables to match the SPA schema.

#### Scenario: Modify Feedback table columns
- **WHEN** the migration script is executed on the old database
- **THEN** the Feedback table `Email` column SHALL be altered from nvarchar(30) to nvarchar(100)
- **AND** the Feedback table `Type` column SHALL be altered from int NULL to int NOT NULL

---

### Requirement: Schema Column Removals
The migration scripts SHALL remove columns from existing tables that are not present in the SPA schema.

#### Scenario: Restructure Law table
- **WHEN** the migration script is executed on the old database
- **THEN** a backup of the full Law table data SHALL be created in `Law_PreSPA_Backup`
- **AND** 53 NTM/legislation-related columns SHALL be removed from the Law table
- **AND** the Law table SHALL retain only these columns: Id, Name, Description, IsDocumentPresent, CreatedDate, CreatedUser, ModifiedDate, ModifiedUser, OwnershipStatus, Deleted, DeprecatedID, IsVisibleInPublicDirectory

#### Scenario: Remove IsLegislation from Snapshot_StepLaw
- **WHEN** the migration script is executed on the old database
- **THEN** the `IsLegislation` column SHALL be removed from Snapshot_StepLaw

#### Scenario: Admin_Menu table is NOT modified
- **WHEN** the migration script is executed on the old database
- **THEN** the Admin_Menu table SHALL NOT have any columns removed
- **AND** the `IsVisibleInPublicHomePage` column SHALL remain (it exists in both old and SPA schemas)

---

### Requirement: New Table Creation
The migration scripts SHALL create 5 new tables required by the SPA schema.

#### Scenario: Create Admin_ObjectiveSectionVisibility table
- **WHEN** the migration script is executed
- **THEN** an `Admin_ObjectiveSectionVisibility` table SHALL be created with 11 columns (Id, Objective_Id, IsExpectedResultsVisible, IsEntitiesInChargeVisible, IsRequirementsVisible, IsCostsVisible, IsTimeframeVisible, IsLegalJustificationVisible, IsAdditionalInfoVisible, IsAdministrativeBurdenVisible, IsAllSectionsVisible)

#### Scenario: Create Snapshot_ObjectiveSectionVisibility table
- **WHEN** the migration script is executed
- **THEN** a `Snapshot_ObjectiveSectionVisibility` table SHALL be created with 11 columns (same as Admin but with Registry_Id instead of auto-increment Id)

#### Scenario: Create GenericRequirement_Cost table
- **WHEN** the migration script is executed
- **THEN** a `GenericRequirement_Cost` table SHALL be created for cost tracking (11 columns including Type, Level_Id, TimeOfStaff, Automated, GenericRequirement_Id)

#### Scenario: Create FilterOption_Product table
- **WHEN** the migration script is executed
- **THEN** a `FilterOption_Product` table SHALL be created for product-level filtering (4 columns: Id, FilterOption_Id, ProductCode, ProductName)

#### Scenario: Create Snapshot_StepRequirementCost table
- **WHEN** the migration script is executed
- **THEN** a `Snapshot_StepRequirementCost` table SHALL be created (10 columns: Registry_Id, Objective_Id, Block_Id, Step_Id, Id, Type, Level_Id, TimeOfStaff, Automated, GenericRequirement_Id)

---

### Requirement: NTM Module Removal
The migration scripts SHALL safely remove all NTM (Non-Tariff Measures) module tables after archiving their data.

#### Scenario: Archive NTM data before removal
- **WHEN** the NTM table drop script is executed
- **THEN** all NTM table data SHALL be copied to a backup schema (`ntm_backup`)
- **AND** the backup SHALL be verified before proceeding with drops

#### Scenario: Drop NTM tables
- **WHEN** the NTM table drop script is executed after archival
- **THEN** the following tables SHALL be dropped:
  - `NtmCountry`, `NtmNotification`, `NtmSubject`, `NtmUser`
  - `Imported_Tariff`
  - `Law_ConditionMeasure`, `Law_RelatedLaw`
  - `Snapshot_Law`, `Snapshot_Law_ConditionMeasure`, `Snapshot_Law_RelatedLaw`
- **AND** all foreign key constraints referencing these tables SHALL be dropped first

---

### Requirement: View Updates
The migration scripts SHALL update 2 existing views to match SPA schema definitions.

#### Scenario: Update v_law view
- **WHEN** the view update script is executed
- **THEN** the `v_law` view SHALL be dropped and recreated with the SPA definition
- **AND** the new definition SHALL remove 15 columns (Category, Status, Description, EntityInCharge_Id, EntityInCharge_Name, InForceSince, all ImportLicense columns, CountriesAffected, ProductsAffected, CountriesDescription, ProductsDescription, IsLegislation)
- **AND** the LEFT JOIN to EntityInCharge SHALL be removed

#### Scenario: Update v_public_review view
- **WHEN** the view update script is executed
- **THEN** the `v_public_review` view SHALL be dropped and recreated with the SPA definition
- **AND** the step tickets section SHALL use INNER JOIN instead of LEFT OUTER JOIN on Snapshot_Step
- **AND** the "legislation tickets" UNION block SHALL be removed

#### Scenario: No new views created
- **WHEN** the migration is complete
- **THEN** no new views SHALL have been created
- **AND** the database SHALL have exactly 25 views (same as before migration)

---

### Requirement: New Stored Procedure Creation
The migration scripts SHALL create 3 new stored procedures required by the SPA schema.

#### Scenario: Create sp_on_updated_StepRequirement
- **WHEN** the stored procedure creation script is executed
- **THEN** `sp_on_updated_StepRequirement` SHALL be created with the SPA definition for syncing step requirement updates (IsEmittedByInstitution, NumberOfPages) to snapshots

#### Scenario: Create sp_Public_GetFullReviews
- **WHEN** the stored procedure creation script is executed
- **THEN** `sp_Public_GetFullReviews` SHALL be created with the SPA definition for public review retrieval

#### Scenario: Create sp_snapshot_getStepRequirementCosts
- **WHEN** the stored procedure creation script is executed
- **THEN** `sp_snapshot_getStepRequirementCosts` SHALL be created with the SPA definition for retrieving step requirement costs from snapshots

---

### Requirement: Stored Procedure Updates
The migration scripts SHALL update 28 existing stored procedures to match SPA schema definitions.

#### Scenario: Update IsVisibleToGuest procedures
- **WHEN** the stored procedure update script is executed
- **THEN** 4 feedback procedures SHALL be updated to add `AND m.IsVisibleToGuest = 1` filter:
  - `sp_feedback_menu_get_children`, `sp_feedback_menu_get_first_level`, `sp_feedback_objective_get_children`, `sp_feedback_objective_get_first_level`
- **AND** `sp_on_updated_menu_tree` SHALL be updated to include IsVisibleToGuest in recursive CTE
- **AND** `sp_on_updated_objective` SHALL be updated with IsVisibleToGuest handling

#### Scenario: Update EntityInCharge-related procedures
- **WHEN** the stored procedure update script is executed
- **THEN** 6 procedures SHALL be updated with GoogleMapsURL and Zone_Id column support:
  - `sp_on_updated_entityInCharge`, `sp_snapshot_getStepEICs`, `sp_snapshot_getStepRegionalEICs`, `sp_take_snapshot_step`, `sp_update_snapshot_recourse`, `sp_update_snapshot_step`

#### Scenario: Update Admin_Step column procedures
- **WHEN** the stored procedure update script is executed
- **THEN** 3 procedures SHALL be updated with Level_Id, NumberOfUsers, Summary, IsReachingOffice support:
  - `sp_snapshot_getStep`, `sp_take_snapshot_step`, `sp_update_snapshot_step`

#### Scenario: Update GenericRequirement_NumberOfPages procedures
- **WHEN** the stored procedure update script is executed
- **THEN** 4 procedures SHALL be updated with NumberOfPages column support:
  - `sp_on_updated_genericRequirement`, `sp_snapshot_getStepRequirements`, `sp_take_snapshot_step`, `sp_update_snapshot_step`

#### Scenario: Update Snapshot_StepRequirementCost procedures
- **WHEN** the stored procedure update script is executed
- **THEN** 4 procedures SHALL be updated with StepRequirementCost table sync:
  - `sp_on_updated_genericRequirement`, `sp_take_snapshot_objective`, `sp_take_snapshot_step`, `sp_update_snapshot_step`

#### Scenario: Update i18n-aware media procedures
- **WHEN** the stored procedure update script is executed
- **THEN** 7 procedures SHALL be updated with `isnull(m_i18n.FileName, m.FileName)` pattern:
  - `sp_on_updated_entityInCharge`, `sp_on_updated_law`, `sp_on_updated_media`, `sp_on_updated_personInCharge`, `sp_on_updated_unitInCharge`, `sp_take_snapshot_step`, `sp_update_snapshot_step`

#### Scenario: Update remaining changed procedures
- **WHEN** the stored procedure update script is executed
- **THEN** the following procedures SHALL also be updated:
  - `sp_on_updated_entityInCharge` - OnlineStepURL update logic
  - `sp_snapshot_getStepSectionVisibility` - IsSummaryVisible column
  - `sp_on_updated_law` - Removed IsLegislation guards, added Public_Generate_ALL call
  - `sp_on_updated_menu` - IsVisibleToGuest-related changes
  - `sp_snapshot_getStepRecourses`, `sp_snapshot_getStepRecourseUICs`, `sp_snapshot_getStepRegionalPICs`, `sp_snapshot_getStepResults`, `sp_snapshot_getStepUICs` - Schema column additions
  - `sp_update_snapshot_block` - Updated snapshot logic

---

### Requirement: Obsolete Procedure Removal
The migration scripts SHALL remove stored procedures that are no longer needed in the SPA schema.

#### Scenario: Drop sp_publish_legislation
- **WHEN** the obsolete procedure removal script is executed
- **THEN** the `sp_publish_legislation` stored procedure SHALL be dropped
- **AND** no other existing stored procedures SHALL be removed

---

### Requirement: Foreign Key Constraints
The migration scripts SHALL add foreign key constraints for new tables and new columns to maintain referential integrity.

#### Scenario: Add FK constraints for new columns on existing tables
- **WHEN** the foreign key script is executed
- **THEN** appropriate foreign key constraints SHALL be added for:
  - `Admin_Step.Level_Id` -> `Option.Id` (FK_Admin_Step_Level)
  - `EntityInCharge.Zone_Id` -> `Option.Id` (FK_EntityInCharge_Zone)

#### Scenario: Add FK constraints for new tables
- **WHEN** the foreign key script is executed
- **THEN** appropriate foreign key constraints SHALL be added for:
  - `Admin_ObjectiveSectionVisibility.Objective_Id` -> `Admin_Objective.Id`
  - `FilterOption_Product.FilterOption_Id` -> `FilterOption.Id`
  - `GenericRequirement_Cost.GenericRequirement_Id` -> `GenericRequirement.Id`
  - `GenericRequirement_Cost.Level_Id` -> `Option.Id`

---

### Requirement: Idempotent Migration Scripts
All migration scripts SHALL be idempotent and safe to re-run without causing errors or data loss.

#### Scenario: Re-running column addition scripts
- **WHEN** a migration script that adds columns is executed multiple times
- **THEN** the script SHALL check for column existence before adding and skip if already present

#### Scenario: Re-running table creation scripts
- **WHEN** a migration script that creates tables is executed multiple times
- **THEN** the script SHALL check for table existence before creating and skip if already present

#### Scenario: Re-running table drop scripts
- **WHEN** a migration script that drops tables is executed multiple times
- **THEN** the script SHALL check for table existence before dropping and skip if already absent

#### Scenario: Re-running stored procedure updates
- **WHEN** a migration script that updates stored procedures is executed multiple times
- **THEN** the script SHALL drop and recreate procedures (using DROP IF EXISTS + CREATE pattern)

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

### Requirement: Data Preservation and Backup
The migration scripts SHALL preserve existing data and create backups before destructive operations.

#### Scenario: Existing data unchanged after column addition
- **WHEN** new columns are added to existing tables
- **THEN** all existing rows SHALL retain their original column values
- **AND** new columns SHALL contain NULL or the specified default value

#### Scenario: Law table data preserved before restructuring
- **WHEN** the Law table column removal script is executed
- **THEN** a `Law_PreSPA_Backup` table SHALL be created with all original Law data
- **AND** the backup SHALL be verified before any columns are dropped

#### Scenario: NTM data preserved before table drops
- **WHEN** the NTM table drop script is executed
- **THEN** all NTM table data SHALL be archived in the `ntm_backup` schema
- **AND** the archive SHALL be verified before any tables are dropped

#### Scenario: Row counts preserved for non-dropped tables
- **WHEN** the migration is complete
- **THEN** all non-dropped table row counts SHALL match pre-migration counts
