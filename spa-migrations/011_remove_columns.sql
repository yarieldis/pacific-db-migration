-- =============================================
-- Migration: 011_remove_columns
-- Date: 2026-02-16
-- Description: Remove columns from existing tables to match SPA schema.
--   - Law: Remove 53 NTM/legislation columns (backup first)
--   - Snapshot_StepLaw: Remove IsLegislation column
--   Based on Libya SPA schema (30-dbe-Libya, compat 110).
-- Execution: Run in SSMS against the old-structure database
-- Dependencies: 010_add_new_columns.sql
-- Rationale: The SPA schema strips the Law table down to 12 core columns,
--   removing all NTM-related, legislation-specific, condition/justification,
--   and import-license columns. This is a BREAKING change.
-- =============================================

SET NOCOUNT ON;

PRINT '=== Migration 011: Remove Columns ==='
PRINT 'Started at: ' + CONVERT(varchar(30), GETDATE(), 120)
PRINT ''

-- =========================================
-- STEP 1: Back up Law table data
-- =========================================

PRINT '--- Step 1: Back up Law table ---'

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Law_PreSPA_Backup' AND type = 'U')
BEGIN
    SELECT * INTO [dbo].[Law_PreSPA_Backup] FROM [dbo].[Law]
    PRINT '  Created Law_PreSPA_Backup with ' + CAST(@@ROWCOUNT AS varchar(10)) + ' rows'
END
ELSE
BEGIN
    PRINT '  Law_PreSPA_Backup already exists - skipping backup'
END
GO

-- =========================================
-- STEP 2: Drop dependent constraints on Law columns being removed
-- =========================================

PRINT ''
PRINT '--- Step 2: Drop dependent constraints on Law columns ---'

-- Dynamically find and drop all default constraints on Law columns that will be dropped
DECLARE @sql nvarchar(max) = ''

-- Columns to be dropped from Law table (53 columns)
DECLARE @columns_to_drop TABLE (col_name nvarchar(128))
INSERT INTO @columns_to_drop VALUES
    ('PublishedStatus'), ('Status'), ('Category'),
    ('ApplicabilitySignatureDate'), ('ApplicabilityHasPacerExempt'), ('ApplicabilityHasGrants'),
    ('ApplicabilityHasNeither'), ('ApplicabilityRegulates'), ('ApplicabilityIsProvisional'),
    ('ApplicabilityForDomesticProduction'), ('ApplicabilityLevel'), ('ApplicabilityIsEmergencyMeasure'),
    ('ApplicabilityGovernmentInvolved'),
    ('InForceSince'), ('ExpiryDate'), ('ProposedInForceSince'), ('ProposedExpiryDate'),
    ('EntityInCharge_Id'), ('PersonInCharge_Id'), ('Related_Law_Id'),
    ('Document'), ('Thumbnail'),
    ('ImportLicenseProductType'), ('ImportLicenseProductsAffected'), ('ImportLicenseCountriesAffected'),
    ('ImportLicenseProductsDescription'), ('ImportLicenseCountriesDescription'),
    ('ConditionAdministrativeBody'), ('ConditionProcedureType'), ('ConditionProcedureDuration'),
    ('ConditionProcedurePublication'),
    ('JustificationObjective'), ('JustificationStandard'), ('JustificationStandardInfo'),
    ('JustificationDoesDeviate'), ('JustificationDeviationDescription'),
    ('JustificationCategory'), ('JustificationSubCategory'),
    ('JustificationImposingCountries'), ('JustificationExplanation'), ('JustificationPurposes'),
    ('CommentsStartDate'), ('CommentsEndDate'), ('CommentsAvailablePublicly'), ('CommentsContactPoint'),
    ('ProductType'), ('ProductsAffected'), ('CountriesAffected'),
    ('ProductsDescription'), ('CountriesDescription'),
    ('DocumentIsUrl'), ('DocumentUrl'),
    ('IsLegislation')

-- Drop default constraints on these columns
SELECT @sql = @sql + 'ALTER TABLE [dbo].[Law] DROP CONSTRAINT [' + dc.name + '];' + CHAR(13)
FROM sys.default_constraints dc
INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('dbo.Law')
AND c.name IN (SELECT col_name FROM @columns_to_drop)

IF LEN(@sql) > 0
BEGIN
    EXEC sp_executesql @sql
    PRINT '  Dropped default constraints on Law columns'
END
ELSE
BEGIN
    PRINT '  No default constraints to drop on Law columns'
END

-- Drop foreign key constraints referencing columns being dropped
SET @sql = ''
SELECT @sql = @sql + 'ALTER TABLE [dbo].[Law] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
WHERE fk.parent_object_id = OBJECT_ID('dbo.Law')
AND c.name IN (SELECT col_name FROM @columns_to_drop)

IF LEN(@sql) > 0
BEGIN
    EXEC sp_executesql @sql
    PRINT '  Dropped foreign key constraints on Law columns'
END
ELSE
BEGIN
    PRINT '  No foreign key constraints to drop on Law columns'
END

-- Drop check constraints on these columns
SET @sql = ''
SELECT @sql = @sql + 'ALTER TABLE [dbo].[Law] DROP CONSTRAINT [' + cc.name + '];' + CHAR(13)
FROM sys.check_constraints cc
INNER JOIN sys.columns c ON cc.parent_object_id = c.object_id AND cc.parent_column_id = c.column_id
WHERE cc.parent_object_id = OBJECT_ID('dbo.Law')
AND c.name IN (SELECT col_name FROM @columns_to_drop)

IF LEN(@sql) > 0
BEGIN
    EXEC sp_executesql @sql
    PRINT '  Dropped check constraints on Law columns'
END
ELSE
BEGIN
    PRINT '  No check constraints to drop on Law columns'
END
GO

-- =========================================
-- STEP 3: Drop 53 columns from Law table (in batches)
-- =========================================

PRINT ''
PRINT '--- Step 3: Drop Law table columns (53 columns) ---'

BEGIN TRANSACTION
BEGIN TRY

    -- Batch 1: Status/Category columns
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'PublishedStatus' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [PublishedStatus]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Status' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [Status]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Category' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [Category]

    -- Batch 2: Applicability columns (10)
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ApplicabilitySignatureDate' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ApplicabilitySignatureDate]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ApplicabilityHasPacerExempt' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ApplicabilityHasPacerExempt]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ApplicabilityHasGrants' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ApplicabilityHasGrants]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ApplicabilityHasNeither' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ApplicabilityHasNeither]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ApplicabilityRegulates' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ApplicabilityRegulates]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ApplicabilityIsProvisional' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ApplicabilityIsProvisional]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ApplicabilityForDomesticProduction' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ApplicabilityForDomesticProduction]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ApplicabilityLevel' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ApplicabilityLevel]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ApplicabilityIsEmergencyMeasure' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ApplicabilityIsEmergencyMeasure]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ApplicabilityGovernmentInvolved' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ApplicabilityGovernmentInvolved]

    PRINT '  Dropped Applicability columns'

    -- Batch 3: Date/reference columns
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'InForceSince' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [InForceSince]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ExpiryDate' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ExpiryDate]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ProposedInForceSince' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ProposedInForceSince]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ProposedExpiryDate' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ProposedExpiryDate]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'EntityInCharge_Id' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [EntityInCharge_Id]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'PersonInCharge_Id' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [PersonInCharge_Id]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Related_Law_Id' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [Related_Law_Id]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Document' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [Document]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'Thumbnail' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [Thumbnail]

    PRINT '  Dropped date/reference columns'

    -- Batch 4: ImportLicense columns (5)
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ImportLicenseProductType' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ImportLicenseProductType]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ImportLicenseProductsAffected' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ImportLicenseProductsAffected]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ImportLicenseCountriesAffected' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ImportLicenseCountriesAffected]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ImportLicenseProductsDescription' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ImportLicenseProductsDescription]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ImportLicenseCountriesDescription' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ImportLicenseCountriesDescription]

    PRINT '  Dropped ImportLicense columns'

    -- Batch 5: Condition columns (4)
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ConditionAdministrativeBody' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ConditionAdministrativeBody]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ConditionProcedureType' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ConditionProcedureType]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ConditionProcedureDuration' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ConditionProcedureDuration]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ConditionProcedurePublication' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ConditionProcedurePublication]

    PRINT '  Dropped Condition columns'

    -- Batch 6: Justification columns (10)
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'JustificationObjective' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [JustificationObjective]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'JustificationStandard' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [JustificationStandard]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'JustificationStandardInfo' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [JustificationStandardInfo]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'JustificationDoesDeviate' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [JustificationDoesDeviate]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'JustificationDeviationDescription' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [JustificationDeviationDescription]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'JustificationCategory' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [JustificationCategory]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'JustificationSubCategory' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [JustificationSubCategory]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'JustificationImposingCountries' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [JustificationImposingCountries]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'JustificationExplanation' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [JustificationExplanation]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'JustificationPurposes' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [JustificationPurposes]

    PRINT '  Dropped Justification columns'

    -- Batch 7: Comments columns (4)
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'CommentsStartDate' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [CommentsStartDate]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'CommentsEndDate' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [CommentsEndDate]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'CommentsAvailablePublicly' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [CommentsAvailablePublicly]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'CommentsContactPoint' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [CommentsContactPoint]

    PRINT '  Dropped Comments columns'

    -- Batch 8: Product/Countries/Document columns (7)
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ProductType' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ProductType]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ProductsAffected' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ProductsAffected]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'CountriesAffected' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [CountriesAffected]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ProductsDescription' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [ProductsDescription]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'CountriesDescription' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [CountriesDescription]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'DocumentIsUrl' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [DocumentIsUrl]
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'DocumentUrl' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [DocumentUrl]

    -- Batch 9: IsLegislation
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsLegislation' AND object_id = OBJECT_ID('dbo.Law'))
        ALTER TABLE [dbo].[Law] DROP COLUMN [IsLegislation]

    PRINT '  Dropped remaining columns (Product/Countries/Document/IsLegislation)'

    COMMIT TRANSACTION
    PRINT ''
    PRINT '  Law table column removal complete'

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT '  Law table column removal FAILED: ' + ERROR_MESSAGE()
    DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE()
    DECLARE @ErrorSeverity int = ERROR_SEVERITY()
    DECLARE @ErrorState int = ERROR_STATE()
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
END CATCH
GO

-- =========================================
-- STEP 4: Verify remaining Law columns (should be 12)
-- =========================================

PRINT ''
PRINT '--- Step 4: Verify Law table structure ---'

DECLARE @colCount int
SELECT @colCount = COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Law')
PRINT '  Law table column count: ' + CAST(@colCount AS varchar(10)) + ' (expected: 12)'

IF @colCount <> 12
    PRINT '  WARNING: Expected 12 columns but found ' + CAST(@colCount AS varchar(10))
GO

-- =========================================
-- STEP 5: Remove IsLegislation from Snapshot_StepLaw
-- =========================================

PRINT ''
PRINT '--- Step 5: Remove IsLegislation from Snapshot_StepLaw ---'

-- Drop default constraint first if exists
DECLARE @dfName nvarchar(128)
SELECT @dfName = dc.name
FROM sys.default_constraints dc
INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('dbo.Snapshot_StepLaw') AND c.name = 'IsLegislation'

IF @dfName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE [dbo].[Snapshot_StepLaw] DROP CONSTRAINT [' + @dfName + ']')
    PRINT '  Dropped default constraint ' + @dfName + ' on Snapshot_StepLaw.IsLegislation'
END

IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsLegislation' AND object_id = OBJECT_ID('dbo.Snapshot_StepLaw'))
BEGIN
    ALTER TABLE [dbo].[Snapshot_StepLaw] DROP COLUMN [IsLegislation]
    PRINT '  Removed Snapshot_StepLaw.IsLegislation'
END
GO

PRINT ''
PRINT '=== Migration 011 completed successfully ==='
PRINT 'Finished at: ' + CONVERT(varchar(30), GETDATE(), 120)
GO
