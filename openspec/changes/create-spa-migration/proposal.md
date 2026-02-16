# Change: Create SPA Database Migration Scripts

## Why
The legacy ePacific/eRegulations database (Tuvalu instance, SQL Server 2008 compatibility level 100) needs to be migrated to the new SPA (Single Page Application) database structure (Libya instance, SQL Server 2012 compatibility level 110). This SPA structure introduces new schema columns, tables for section visibility and cost tracking, removes the NTM (Non-Tariff Measures) module entirely, and updates existing views and stored procedures to reflect the new schema. Migration scripts are required to transform the old database to the SPA schema while preserving existing data.

## Execution Model
- **Target**: An existing database with the OLD structure (e.g., Tuvalu instance)
- **Tool**: SQL Server Management Studio (SSMS)
- **Action**: Run migration scripts sequentially against the old database
- **Result**: The old database is modified IN-PLACE to match the SPA structure
- **Data**: All existing data is preserved; schema is upgraded, NTM data is cleaned up

The scripts do NOT create a new database. They ALTER the existing old-structure database to add/remove columns, create/drop tables, update views and stored procedures to match the SPA schema.

## What Changes

### Schema Changes - Column Additions (24 tables affected)

#### Base tables (12 tables)
- **Admin_Step**: Add columns `Level_Id` (int NULL), `NumberOfUsers` (int NULL), `Summary` (ntext NULL), `IsReachingOffice` (bit NULL)
- **Admin_Step_i18n**: Add column `Summary` (ntext NULL)
- **Admin_StepRequirement**: Add column `IsEmittedByInstitution` (bit NOT NULL DEFAULT 0)
- **Admin_StepSectionVisibility**: Add column `IsSummaryVisible` (bit NOT NULL DEFAULT 1)
- **EntityInCharge**: Add column `Zone_Id` (int NULL)
- **Feedback**: Add column `Status` (int NOT NULL)
- **Filter**: Add column `IsProductRelated` (bit NOT NULL DEFAULT 0)
- **GenericRequirement**: Add column `NumberOfPages` (int NOT NULL DEFAULT 1)
- **Media_i18n**: Add columns `FileName` (nvarchar(500) NULL), `Extention` (nvarchar(15) NULL), `Description` (ntext NULL), `Length` (decimal(18,0) NULL), `PreviewImageName` (nvarchar(100) NULL)
- **Public_Team_Member**: Add columns `Phone` (nvarchar(50) NULL), `Email` (nvarchar(100) NULL)
- **UnitInCharge**: Add column `Website` (nvarchar(255) NULL)
- **UnitInCharge_i18n**: Add column `Website` (nvarchar(255) NULL)

#### Snapshot tables (10 tables)
- **Snapshot_Objective**: Add column `ExplanatoryText` (ntext NULL)
- **Snapshot_Step**: Add columns `Level_Id` (int NULL), `NumberOfUsers` (int NULL), `Summary` (ntext NULL), `IsReachingOffice` (bit NULL)
- **Snapshot_StepEntityInCharge**: Add column `Zone_Id` (int NULL)
- **Snapshot_StepRecourseEntityInCharge**: Add column `Zone_Id` (int NULL)
- **Snapshot_StepRecourseUnitInCharge**: Add column `Website` (nvarchar(255) NULL)
- **Snapshot_StepRegionalEntityInCharge**: Add columns `GoogleMapsURL` (nvarchar(800) NULL), `Zone_Id` (int NULL)
- **Snapshot_StepRegionalUnitInCharge**: Add column `Website` (nvarchar(255) NULL)
- **Snapshot_StepRequirement**: Add columns `GenericRequirement_NumberOfPages` (int NOT NULL DEFAULT 1), `IsEmittedByInstitution` (bit NOT NULL)
- **Snapshot_StepSectionVisibility**: Add column `IsSummaryVisible` (bit NOT NULL)
- **Snapshot_StepUnitInCharge**: Add column `Website` (nvarchar(255) NULL)

### Schema Changes - Column Type Modifications (1 table)
- **Feedback**: Change `Email` from nvarchar(30) to nvarchar(100); change `Type` from int NULL to int NOT NULL

### Schema Changes - Column Removals (2 tables)
- **Law**: **BREAKING** - Remove 53 columns (NTM-related, legislation-specific, condition/justification, import-license columns); retain only core columns (Id, Name, Description, IsDocumentPresent, CreatedDate, CreatedUser, ModifiedDate, ModifiedUser, OwnershipStatus, Deleted, DeprecatedID, IsVisibleInPublicDirectory)
- **Snapshot_StepLaw**: Remove `IsLegislation` (bit NOT NULL) - aligns with Law table restructure

Note: Admin_Menu.IsVisibleInPublicHomePage is NOT removed - it still exists in the SPA schema.

### New Tables (5)
- `Admin_ObjectiveSectionVisibility` - Per-objective section visibility control (11 columns)
- `Snapshot_ObjectiveSectionVisibility` - Snapshot counterpart (11 columns)
- `FilterOption_Product` - Product-level filtering (4 columns)
- `GenericRequirement_Cost` - Cost tracking for requirements (11 columns)
- `Snapshot_StepRequirementCost` - Snapshot counterpart for requirement costs (10 columns)

### Dropped Tables (10) - **BREAKING**
- `Imported_Tariff`, `Law_ConditionMeasure`, `Law_RelatedLaw` - Law/legislation tables
- `NtmCountry`, `NtmNotification`, `NtmSubject`, `NtmUser` - NTM module tables
- `Snapshot_Law`, `Snapshot_Law_ConditionMeasure`, `Snapshot_Law_RelatedLaw` - Snapshot counterparts

### New Foreign Key Constraints
- `FK_Admin_Step_Level`: Admin_Step.Level_Id -> Option.Id
- `FK_EntityInCharge_Zone`: EntityInCharge.Zone_Id -> Option.Id
- `FK_Admin_ObjectiveSectionVisibility_Objective`: Admin_ObjectiveSectionVisibility.Objective_Id -> Admin_Objective.Id
- `FK_FilterOption_Product_FilterOption`: FilterOption_Product.FilterOption_Id -> FilterOption.Id
- `FK_GenericRequirement_Id`: GenericRequirement_Cost.GenericRequirement_Id -> GenericRequirement.Id
- `FK_Level_Id`: GenericRequirement_Cost.Level_Id -> Option.Id

### Updated Views (2 structural + 1 cosmetic)
- **v_law**: Structural change - 15 columns removed (Category, Status, Description, EntityInCharge_Id, EntityInCharge_Name, InForceSince, all ImportLicense columns, CountriesAffected, ProductsAffected, CountriesDescription, ProductsDescription, IsLegislation); LEFT JOIN to EntityInCharge removed. Aligns with Law table restructure.
- **v_public_review**: Structural change - step tickets section changed from LEFT OUTER JOIN to INNER JOIN on Snapshot_Step; entire "legislation tickets" UNION block removed (~57 lines).
- **v_personInCharge**: Cosmetic only - comment text fix ("entity in charges" -> "people in charges"), WITH casing change, extra blank lines. No functional impact.

Note: The remaining 22 shared views are identical between old and new. There are NO new views to create - both schemas have the same 25 views.

### New Stored Procedures (3)
- `sp_on_updated_StepRequirement` - Handles updates to step requirements (IsEmittedByInstitution, NumberOfPages sync to snapshots)
- `sp_Public_GetFullReviews` - Public review retrieval
- `sp_snapshot_getStepRequirementCosts` - Retrieves step requirement costs from snapshots

### Updated Stored Procedures (28)

#### IsVisibleToGuest filter added (6 procedures)
- `sp_feedback_menu_get_children`, `sp_feedback_menu_get_first_level`, `sp_feedback_objective_get_children`, `sp_feedback_objective_get_first_level` - Added `AND m.IsVisibleToGuest = 1` to WHERE clause
- `sp_on_updated_menu_tree` - Added IsVisibleToGuest column to recursive CTE
- `sp_on_updated_objective` - Added IsVisibleToGuest handling in snapshot population

#### GoogleMapsURL + Zone_Id columns (6 procedures)
- `sp_on_updated_entityInCharge` - Added GoogleMapsURL, Zone_Id to step/recourse EIC UPDATEs; restructured media handling with i18n cursor; added OnlineStepURL logic
- `sp_snapshot_getStepEICs`, `sp_snapshot_getStepRegionalEICs` - Added GoogleMapsURL, Zone_Id to SELECT
- `sp_take_snapshot_step` - Added GoogleMapsURL, Zone_Id to EIC snapshot INSERTs
- `sp_update_snapshot_recourse`, `sp_update_snapshot_step` - Added GoogleMapsURL, Zone_Id to EIC UPDATEs

#### New Admin_Step columns: Level_Id, NumberOfUsers, Summary, IsReachingOffice (3 procedures)
- `sp_snapshot_getStep` - Added new columns to step retrieval
- `sp_take_snapshot_step` - Added new columns to Snapshot_Step INSERT
- `sp_update_snapshot_step` - Added new columns to step snapshot UPDATE

#### GenericRequirement_NumberOfPages column (4 procedures)
- `sp_on_updated_genericRequirement` - Added NumberOfPages to Snapshot_StepRequirement UPDATE
- `sp_snapshot_getStepRequirements` - Added NumberOfPages to requirement retrieval
- `sp_take_snapshot_step` - Added NumberOfPages to Snapshot_StepRequirement INSERT
- `sp_update_snapshot_step` - Added NumberOfPages to requirement UPDATE

#### Snapshot_StepRequirementCost new table sync (4 procedures)
- `sp_on_updated_genericRequirement` - Added cursor-based StepRequirementCost management
- `sp_take_snapshot_objective` - Added DELETE FROM Snapshot_StepRequirementCost cleanup
- `sp_take_snapshot_step` - Added Snapshot_StepRequirementCost INSERT logic
- `sp_update_snapshot_step` - Added StepRequirementCost management

#### i18n-aware media handling (7 procedures)
Using `isnull(m_i18n.FileName, m.FileName)` pattern for FileName, Extention, Length, PreviewImageName:
- `sp_on_updated_entityInCharge`, `sp_on_updated_law`, `sp_on_updated_media`, `sp_on_updated_personInCharge`, `sp_on_updated_unitInCharge`
- `sp_take_snapshot_step`, `sp_update_snapshot_step`

#### Other changes
- `sp_on_updated_entityInCharge` - Added OnlineStepURL update logic
- `sp_snapshot_getStepSectionVisibility` - Added IsSummaryVisible column
- `sp_on_updated_law` - Removed IsLegislation guards; added Public_Generate_ALL call
- `sp_on_updated_menu` - IsVisibleToGuest-related changes
- `sp_snapshot_getStepRecourses`, `sp_snapshot_getStepRecourseUICs`, `sp_snapshot_getStepRegionalPICs`, `sp_snapshot_getStepResults`, `sp_snapshot_getStepUICs` - Schema column additions
- `sp_update_snapshot_block` - Updated snapshot logic

Note: 21 shared procedures are identical. `sp_on_published_block`, `sp_on_published_step`, and `sp_on_published_recourse` are all IDENTICAL between old and new.

### Dropped Stored Procedures (1)
- `sp_publish_legislation` - Related to removed NTM/legislation features

## Impact
- **Affected tables**: ~93 tables (create 5, drop 10, alter 24, preserve ~64)
- **Affected views**: 25 views total (0 new, 2 structural updates, 1 cosmetic update, 22 unchanged)
- **Affected stored procedures**: 28 updated, 3 new, 1 dropped, 21 unchanged
- **Risk level**: High - breaking changes to Law table, NTM module removal, structural SP changes
- **Downtime required**: Yes - recommend maintenance window
- **Rollback strategy**: Full database backup before migration
