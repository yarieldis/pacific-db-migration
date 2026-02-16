# SPA Database Migration Specification

## ADDED Requirements

### Requirement: In-Place Database Migration to SPA Schema
The migration scripts SHALL modify an existing old-structure database in-place to match the SPA schema (Argentina/Lomas de Zamora instance), preserving all existing non-NTM data.

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

#### Scenario: Add Summary column to Admin_Step_i18n table
- **WHEN** the migration script is executed on the old database
- **THEN** the Admin_Step_i18n table SHALL have a new `Summary` (ntext, NULL) column

#### Scenario: Add new column to EntityInCharge table
- **WHEN** the migration script is executed on the old database
- **THEN** the EntityInCharge table SHALL have a new `Zone_Id` (int, NULL) column

#### Scenario: Add new columns to GenericRequirement table
- **WHEN** the migration script is executed on the old database
- **THEN** the GenericRequirement table SHALL have new columns:
  - `IsEmittedByInstitution` (bit, NOT NULL, DEFAULT 0)
  - `NumberOfPages` (int, NOT NULL, DEFAULT 0)

#### Scenario: Add new column to UnitInCharge table
- **WHEN** the migration script is executed on the old database
- **THEN** the UnitInCharge table SHALL have a new `Website` (nvarchar, NULL) column

#### Scenario: Add new columns to Media_i18n table
- **WHEN** the migration script is executed on the old database
- **THEN** the Media_i18n table SHALL have new columns:
  - `FileName` (nvarchar, NULL)
  - `Extention` (nvarchar, NULL)
  - `Description` (ntext, NULL)
  - `Length` (int, NULL)
  - `PreviewImageName` (nvarchar, NULL)

#### Scenario: Add new column to Feedback table
- **WHEN** the migration script is executed on the old database
- **THEN** the Feedback table SHALL have a new `Status` (int, NULL) column

#### Scenario: Add new column to Filter table
- **WHEN** the migration script is executed on the old database
- **THEN** the Filter table SHALL have a new `IsProductRelated` (bit, NOT NULL, DEFAULT 0) column

#### Scenario: Add new column to Admin_StepSectionVisibility table
- **WHEN** the migration script is executed on the old database
- **THEN** the Admin_StepSectionVisibility table SHALL have a new `IsSummaryVisible` (bit, NOT NULL, DEFAULT 1) column

---

### Requirement: Schema Column Removals
The migration scripts SHALL remove columns from existing tables that are not present in the SPA schema.

#### Scenario: Restructure Law table
- **WHEN** the migration script is executed on the old database
- **THEN** a backup of the full Law table data SHALL be created in `Law_PreSPA_Backup`
- **AND** 53 NTM/legislation-related columns SHALL be removed from the Law table
- **AND** the Law table SHALL retain only these columns: Id, Name, Description, IsDocumentPresent, CreatedDate, CreatedUser, ModifiedDate, ModifiedUser, OwnershipStatus, Deleted, DeprecatedID, IsVisibleInPublicDirectory

#### Scenario: Remove column from Admin_Menu table
- **WHEN** the migration script is executed on the old database
- **THEN** the `IsVisibleInPublicHomePage` column SHALL be removed from Admin_Menu

---

### Requirement: New Table Creation
The migration scripts SHALL create 5 new tables required by the SPA schema.

#### Scenario: Create Admin_ObjectiveSectionVisibility table
- **WHEN** the migration script is executed
- **THEN** an `Admin_ObjectiveSectionVisibility` table SHALL be created with columns for objective-level section visibility control (10 columns including Id, Objective_Id, and 8 boolean visibility flags)

#### Scenario: Create GenericRequirement_Cost table
- **WHEN** the migration script is executed
- **THEN** a `GenericRequirement_Cost` table SHALL be created for cost tracking (11 columns including Type, Level_Id, TimeOfStaff, Automated)

#### Scenario: Create FilterOption_Product table
- **WHEN** the migration script is executed
- **THEN** a `FilterOption_Product` table SHALL be created for product-level filtering (4 columns)

#### Scenario: Create snapshot counterpart tables
- **WHEN** the migration script is executed
- **THEN** `Snapshot_ObjectiveSectionVisibility` and `Snapshot_StepRequirementCost` tables SHALL be created as snapshot counterparts

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

### Requirement: View Creation and Updates
The migration scripts SHALL create 18 new views and update 2 existing views to match SPA schema definitions.

#### Scenario: Create new views
- **WHEN** the view creation script is executed
- **THEN** 18 new views SHALL be created:
  - `Public_Medias`, `view_Public_Menu_Mono`, `view_Public_Objectives_Current`, `view_Public_Regulations_Blocks`, `view_Public_Treeview_For_Summary`
  - `view_sub_Public_Menu_Level1` through `view_sub_Public_Menu_Level5`
  - `v_translation_item`, `Transfert`, `VIEW_step_dbl`
  - `VIEW2`, `VIEW3`, `VIEW4`, `VIEW5`, `VIEW6`

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

---

### Requirement: Stored Procedure Updates
The migration scripts SHALL update 39 existing stored procedures to match SPA schema definitions.

#### Scenario: Update dynamic search procedures for Unicode support
- **WHEN** the stored procedure update script is executed
- **THEN** 16 dynamic search procedures SHALL be updated to use `nvarchar` instead of `varchar` for parameters and variables:
  - `sp_auditRecord_dynamic_search`, `sp_entityincharge_dynamic_search`, `sp_genericrequirement_dynamic_search`, `sp_law_dynamic_search`, `sp_media_dynamic_search`, `sp_menu_dynamic_search`, `sp_partner_dynamic_search`, `sp_personincharge_dynamic_search`, `sp_recourse_dynamic_search`, `sp_regulation_dynamic_search`, `sp_requirement_dynamic_search`, `sp_translation_dynamic_search`, `sp_translation_menu_dynamic_search`, `sp_unitincharge_dynamic_search`, `sp_xmlSerializedItem_dynamic_search`, `sp_public_reviews_dynamic_search`

#### Scenario: Update translation search procedures for NULL i18n fallback
- **WHEN** the stored procedure update script is executed
- **THEN** 5 translation search procedures SHALL be updated with varchar -> nvarchar conversion AND NULL i18n fallback pattern `(i.Name is null and LOWER(o.Name) LIKE ...)`:
  - `sp_cost_variables_translation_search`, `sp_filter_translation_search`, `sp_filteroption_translation_search`, `sp_options_translation_search`, `sp_site_menu_translation_search`

#### Scenario: Update feedback procedures with guest visibility filter
- **WHEN** the stored procedure update script is executed
- **THEN** 4 feedback procedures SHALL be updated to add `AND m.IsVisibleToGuest = 1` filter:
  - `sp_feedback_menu_get_children`, `sp_feedback_menu_get_first_level`, `sp_feedback_objective_get_children`, `sp_feedback_objective_get_first_level`

#### Scenario: Update published procedures with SystemLanguage changes
- **WHEN** the stored procedure update script is executed
- **THEN** 3 published procedures SHALL be updated:
  - `sp_on_published_block` and `sp_on_published_step` with casing/alias reformatting
  - `sp_on_published_recourse` with `community_lang WHERE lang_principal = 1` replacing `SystemLanguage WHERE IsPrincipal = 1`

#### Scenario: Update column-aware procedures
- **WHEN** the stored procedure update script is executed
- **THEN** `sp_on_updated_unitInCharge` SHALL be updated to include `Website` column in UPDATE statements
- **AND** `sp_on_updated_media` SHALL be updated to use i18n-aware media fields: `isnull(m_i18n.FileName, m.FileName)` pattern

#### Scenario: Update structurally changed procedures
- **WHEN** the stored procedure update script is executed
- **THEN** the following 9 procedures SHALL be dropped and recreated with SPA definitions:
  - `sp_on_updated_entityInCharge` - with GoogleMapsURL, Zone_Id, Snapshot_Object_Media handling, OnlineStepURL update
  - `sp_on_updated_genericRequirement` - with NumberOfPages, IsEmittedByInstitution, Snapshot_StepRequirementCost sync
  - `sp_on_updated_law` - with removed IsLegislation checks, i18n media, Public_Generate_ALL call
  - `sp_snapshot_getStep` - with ROW_NUMBER() windowed function replacing MAX()/GROUP BY
  - `sp_take_snapshot_objective` - with Snapshot_StepRequirementCost/ObjectiveSectionVisibility sync, Level_Id, NumberOfUsers, Summary
  - `sp_take_snapshot_step` - with Zone_Id, i18n media, Snapshot_StepRequirementCost, Website
  - `sp_update_snapshot_block` - with updated snapshot logic
  - `sp_update_snapshot_recourse` - with updated snapshot logic
  - `sp_update_snapshot_step` - with updated snapshot logic

---

### Requirement: Obsolete Procedure Removal
The migration scripts SHALL remove stored procedures that are no longer needed in the SPA schema.

#### Scenario: Drop sp_publish_legislation
- **WHEN** the obsolete procedure removal script is executed
- **THEN** the `sp_publish_legislation` stored procedure SHALL be dropped
- **AND** no other existing stored procedures SHALL be removed

---

### Requirement: Foreign Key Constraints
The migration scripts SHALL add foreign key constraints for new tables to maintain referential integrity.

#### Scenario: Add FK constraints for new tables
- **WHEN** the foreign key script is executed
- **THEN** appropriate foreign key constraints SHALL be added for:
  - `Admin_ObjectiveSectionVisibility.Objective_Id`
  - `Snapshot_ObjectiveSectionVisibility.Registry_Id`
  - `FilterOption_Product.FilterOption_Id`
  - `GenericRequirement_Cost.GenericRequirement_Id`
  - `Snapshot_StepRequirementCost.Registry_Id`

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
