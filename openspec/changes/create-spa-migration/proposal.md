# Change: Create SPA Database Migration Scripts

## Why
The legacy ePacific/eRegulations database (Tuvalu instance, SQL Server 2008 compatibility level 100) needs to be migrated to the new SPA (Single Page Application) database structure (Argentina/Lomas de Zamora instance). This SPA structure introduces new schema columns, tables for section visibility and cost tracking, removes the NTM (Non-Tariff Measures) module entirely, and updates existing views and stored procedures to reflect the new schema. Migration scripts are required to transform the old database to the SPA schema while preserving existing data.

## Execution Model
- **Target**: An existing database with the OLD structure (e.g., Tuvalu instance)
- **Tool**: SQL Server Management Studio (SSMS)
- **Action**: Run migration scripts sequentially against the old database
- **Result**: The old database is modified IN-PLACE to match the SPA structure
- **Data**: All existing data is preserved; schema is upgraded, NTM data is cleaned up

The scripts do NOT create a new database. They ALTER the existing old-structure database to add/remove columns, create/drop tables, update views and stored procedures to match the SPA schema.

## What Changes

### Schema Changes - Column Additions
- **Admin_Step**: Add columns `Level_Id`, `NumberOfUsers`, `Summary`
- **Admin_Step_i18n**: Add column `Summary`
- **EntityInCharge**: Add column `Zone_Id`
- **GenericRequirement**: Add columns `IsEmittedByInstitution`, `NumberOfPages`
- **UnitInCharge**: Add column `Website`
- **Media_i18n**: Add columns `FileName`, `Extention`, `Description`, `Length`, `PreviewImageName`
- **Feedback**: Add column `Status`
- **Filter**: Add column `IsProductRelated`
- **Admin_StepSectionVisibility**: Add column `IsSummaryVisible`

### Schema Changes - Column Removals
- **Admin_Menu**: Remove column `IsVisibleInPublicHomePage`
- **Law**: **BREAKING** - Remove 53 columns (NTM-related, legislation-specific, condition/justification, import-license columns); retain only core columns (Id, Name, Description, IsDocumentPresent, CRUD audit, OwnershipStatus, Deleted, DeprecatedID, IsVisibleInPublicDirectory)

### New Tables (5)
- `Admin_ObjectiveSectionVisibility` - Per-objective section visibility control
- `Snapshot_ObjectiveSectionVisibility` - Snapshot counterpart
- `FilterOption_Product` - Product-level filtering
- `GenericRequirement_Cost` - Cost tracking for requirements
- `Snapshot_StepRequirementCost` - Snapshot counterpart for requirement costs

### Dropped Tables (10) - **BREAKING**
- `Imported_Tariff`, `Law_ConditionMeasure`, `Law_RelatedLaw` - Law/legislation tables
- `NtmCountry`, `NtmNotification`, `NtmSubject`, `NtmUser` - NTM module tables
- `Snapshot_Law`, `Snapshot_Law_ConditionMeasure`, `Snapshot_Law_RelatedLaw` - Snapshot counterparts

### New Views (18)
- `Public_Medias`, `Transfert`, `v_translation_item`
- `view_Public_Menu_Mono`, `view_Public_Objectives_Current`, `view_Public_Regulations_Blocks`
- `view_Public_Treeview_For_Summary`
- `VIEW_step_dbl`, `VIEW2` through `VIEW6`
- `view_sub_Public_Menu_Level1` through `Level5`

### Updated Views (2)
- **v_law**: Structural change - 15 columns removed (Category, Status, Description, EntityInCharge_Id, all ImportLicense/Countries/Products columns, IsLegislation); LEFT JOIN to EntityInCharge removed. Aligns with Law table restructure.
- **v_public_review**: Structural change - step tickets section changed from LEFT JOIN to INNER JOIN on Snapshot_Step; entire "legislation tickets" UNION block removed (~57 lines).

Note: `v_personInCharge` has cosmetic-only differences (comment fix, whitespace). The remaining 22 shared views are identical.

### Updated Stored Procedures (39)

#### varchar -> nvarchar conversion (16 procedures)
Systematic Unicode compatibility improvement across all dynamic search procedures:
- `sp_auditRecord_dynamic_search`, `sp_entityincharge_dynamic_search`, `sp_genericrequirement_dynamic_search`, `sp_law_dynamic_search`, `sp_media_dynamic_search`, `sp_menu_dynamic_search`, `sp_partner_dynamic_search`, `sp_personincharge_dynamic_search`, `sp_recourse_dynamic_search`, `sp_regulation_dynamic_search`, `sp_requirement_dynamic_search`, `sp_translation_dynamic_search`, `sp_translation_menu_dynamic_search`, `sp_unitincharge_dynamic_search`, `sp_xmlSerializedItem_dynamic_search`, `sp_public_reviews_dynamic_search`

#### varchar -> nvarchar + NULL i18n fallback (5 procedures)
Added `(i.Name is null and LOWER(o.Name) LIKE ...)` pattern for NULL i18n fallback:
- `sp_cost_variables_translation_search`, `sp_filter_translation_search`, `sp_filteroption_translation_search`, `sp_options_translation_search`, `sp_site_menu_translation_search`

#### Added IsVisibleToGuest filter (4 procedures)
Added `AND m.IsVisibleToGuest = 1` to WHERE clause:
- `sp_feedback_menu_get_children`, `sp_feedback_menu_get_first_level`, `sp_feedback_objective_get_children`, `sp_feedback_objective_get_first_level`

#### SystemLanguage query reformatting (3 procedures)
- `sp_on_published_block`, `sp_on_published_step` - Minor casing/alias changes
- `sp_on_published_recourse` - Changed from `SystemLanguage` to `community_lang WHERE lang_principal = 1`

#### New columns added to logic (2 procedures)
- `sp_on_updated_unitInCharge` - Added `Website` column to UPDATE statements
- `sp_on_updated_media` - Changed media fields to i18n-aware: `isnull(m_i18n.FileName, m.FileName)` pattern

#### Major structural changes (9 procedures)
- `sp_on_updated_entityInCharge` - Added `GoogleMapsURL`, `Zone_Id`; added `Snapshot_Object_Media` handling; added `OnlineStepURL` update
- `sp_on_updated_genericRequirement` - Added `NumberOfPages`, `IsEmittedByInstitution`; added `Snapshot_StepRequirementCost` sync; media -> i18n-aware
- `sp_on_updated_law` - Removed `IsLegislation` checks; media -> i18n-aware; added `Public_Generate_ALL` call
- `sp_snapshot_getStep` - Replaced `MAX()/GROUP BY` with `ROW_NUMBER() OVER (PARTITION BY...)` windowed function
- `sp_take_snapshot_objective` - Added `Snapshot_StepRequirementCost`/`Snapshot_ObjectiveSectionVisibility` sync; added `Level_Id`, `NumberOfUsers`, `Summary`
- `sp_take_snapshot_step` - Added `Zone_Id` to EIC inserts; media -> i18n-aware; added `Snapshot_StepRequirementCost`; added UIC `Website`
- `sp_update_snapshot_block` - Snapshot update logic changes for new schema
- `sp_update_snapshot_recourse` - Snapshot update logic changes for new schema
- `sp_update_snapshot_step` - Snapshot update logic changes for new schema

Note: `sp_Public_GetListOfStatusForUser_v4` differs only in environment-specific server name (skipped). The remaining 33 shared procedures are identical.

### Dropped Stored Procedures (1)
- `sp_publish_legislation` - Related to removed NTM/legislation features

## Impact
- **Affected tables**: ~93 tables (create 5, drop 10, alter 11, preserve ~77)
- **Affected views**: 43 views total (18 new, 2 updated, 22 unchanged, 1 cosmetic-only)
- **Affected stored procedures**: 39 updated, 1 dropped, 33 unchanged
- **Risk level**: High - breaking changes to Law table, NTM module removal, structural SP changes
- **Downtime required**: Yes - recommend maintenance window
- **Rollback strategy**: Full database backup before migration
