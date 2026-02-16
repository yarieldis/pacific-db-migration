-- =============================================
-- Migration: 011_remove_columns
-- Date: 2026-02-16
-- Description: Remove columns from existing tables to match SPA schema.
--   - Law: Remove 53 NTM/legislation columns (backup first)
--   - Admin_Menu: Remove IsVisibleInPublicHomePage
-- =============================================

-- =============================================
-- PART 1: Back up Law table before destructive changes
-- =============================================
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Law_PreSPA_Backup' AND type = 'U')
BEGIN
    SELECT * INTO [dbo].[Law_PreSPA_Backup] FROM [dbo].[Law]
    PRINT 'Created Law_PreSPA_Backup with ' + CAST((SELECT COUNT(*) FROM [dbo].[Law_PreSPA_Backup]) AS VARCHAR) + ' rows'
END
ELSE
BEGIN
    PRINT 'Law_PreSPA_Backup already exists - skipping backup'
END
GO

-- Verify backup has data
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Law_PreSPA_Backup' AND type = 'U')
BEGIN
    DECLARE @backupCount INT, @lawCount INT
    SELECT @backupCount = COUNT(*) FROM [dbo].[Law_PreSPA_Backup]
    SELECT @lawCount = COUNT(*) FROM [dbo].[Law]
    IF @backupCount <> @lawCount
    BEGIN
        RAISERROR('Law_PreSPA_Backup row count (%d) does not match Law row count (%d). Aborting.', 16, 1, @backupCount, @lawCount)
        RETURN
    END
    PRINT 'Law_PreSPA_Backup verified: ' + CAST(@backupCount AS VARCHAR) + ' rows match'
END
GO

-- =============================================
-- PART 2: Remove Law table columns
-- =============================================
BEGIN TRANSACTION
BEGIN TRY

    -- Drop default constraints on Law columns being removed
    DECLARE @sql NVARCHAR(MAX) = ''

    SELECT @sql = @sql + 'ALTER TABLE [dbo].[Law] DROP CONSTRAINT [' + dc.name + '];' + CHAR(13)
    FROM sys.default_constraints dc
    INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
    WHERE dc.parent_object_id = OBJECT_ID('dbo.Law')
    AND c.name IN (
        'PublishedStatus', 'Status', 'Category',
        'ApplicabilitySignatureDate', 'ApplicabilityHasPacerExempt', 'ApplicabilityHasGrants',
        'ApplicabilityHasNeither', 'ApplicabilityRegulates', 'ApplicabilityIsProvisional',
        'ApplicabilityForDomesticProduction', 'ApplicabilityLevel', 'ApplicabilityIsEmergencyMeasure',
        'ApplicabilityGovernmentInvolved',
        'InForceSince', 'ExpiryDate', 'ProposedInForceSince', 'ProposedExpiryDate',
        'EntityInCharge_Id', 'PersonInCharge_Id', 'Related_Law_Id',
        'Document', 'Thumbnail',
        'ImportLicenseProductType', 'ImportLicenseProductsAffected', 'ImportLicenseCountriesAffected',
        'ImportLicenseProductsDescription', 'ImportLicenseCountriesDescription',
        'ConditionAdministrativeBody', 'ConditionProcedureType', 'ConditionProcedureDuration',
        'ConditionProcedurePublication',
        'JustificationObjective', 'JustificationStandard', 'JustificationStandardInfo',
        'JustificationDoesDeviate', 'JustificationDeviationDescription',
        'JustificationCategory', 'JustificationSubCategory',
        'JustificationImposingCountries', 'JustificationExplanation', 'JustificationPurposes',
        'CommentsStartDate', 'CommentsEndDate', 'CommentsAvailablePublicly', 'CommentsContactPoint',
        'ProductType', 'ProductsAffected', 'CountriesAffected',
        'ProductsDescription', 'CountriesDescription',
        'DocumentIsUrl', 'DocumentUrl', 'IsLegislation'
    )

    IF LEN(@sql) > 0
    BEGIN
        EXEC sp_executesql @sql
        PRINT 'Dropped default constraints on Law columns'
    END

    -- Drop foreign key constraints referencing Law columns being removed
    SET @sql = ''

    SELECT @sql = @sql + 'ALTER TABLE [' + OBJECT_SCHEMA_NAME(fk.parent_object_id) + '].[' + OBJECT_NAME(fk.parent_object_id) + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
    FROM sys.foreign_keys fk
    INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
    INNER JOIN sys.columns c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
    WHERE fk.parent_object_id = OBJECT_ID('dbo.Law')
    AND c.name IN ('EntityInCharge_Id', 'PersonInCharge_Id', 'Related_Law_Id')

    -- Also drop FKs where Law columns are referenced
    SELECT @sql = @sql + 'ALTER TABLE [' + OBJECT_SCHEMA_NAME(fk.parent_object_id) + '].[' + OBJECT_NAME(fk.parent_object_id) + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
    FROM sys.foreign_keys fk
    INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
    WHERE fk.referenced_object_id = OBJECT_ID('dbo.Law')
    AND NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys fk2
        INNER JOIN sys.foreign_key_columns fkc2 ON fk2.object_id = fkc2.constraint_object_id
        INNER JOIN sys.columns c2 ON fkc2.referenced_object_id = c2.object_id AND fkc2.referenced_column_id = c2.column_id
        WHERE fk2.object_id = fk.object_id
        AND c2.name = 'Id'
    )

    IF LEN(@sql) > 0
    BEGIN
        EXEC sp_executesql @sql
        PRINT 'Dropped foreign key constraints on Law columns'
    END

    -- Drop columns in batches (SQL Server has limits on ALTER TABLE DROP COLUMN)
    -- Batch 1: NTM status and applicability columns
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'PublishedStatus' AND object_id = OBJECT_ID('dbo.Law'))
    BEGIN
        ALTER TABLE [dbo].[Law] DROP COLUMN
            [PublishedStatus], [Status], [Category],
            [ApplicabilitySignatureDate], [ApplicabilityHasPacerExempt], [ApplicabilityHasGrants],
            [ApplicabilityHasNeither], [ApplicabilityRegulates], [ApplicabilityIsProvisional],
            [ApplicabilityForDomesticProduction], [ApplicabilityLevel], [ApplicabilityIsEmergencyMeasure],
            [ApplicabilityGovernmentInvolved]
        PRINT 'Dropped Law columns batch 1: PublishedStatus through ApplicabilityGovernmentInvolved (13 columns)'
    END

    -- Batch 2: Date, entity, document columns
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'InForceSince' AND object_id = OBJECT_ID('dbo.Law'))
    BEGIN
        ALTER TABLE [dbo].[Law] DROP COLUMN
            [InForceSince], [ExpiryDate], [ProposedInForceSince], [ProposedExpiryDate],
            [EntityInCharge_Id], [PersonInCharge_Id], [Related_Law_Id],
            [Document], [Thumbnail]
        PRINT 'Dropped Law columns batch 2: InForceSince through Thumbnail (9 columns)'
    END

    -- Batch 3: Import license columns
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ImportLicenseProductType' AND object_id = OBJECT_ID('dbo.Law'))
    BEGIN
        ALTER TABLE [dbo].[Law] DROP COLUMN
            [ImportLicenseProductType], [ImportLicenseProductsAffected], [ImportLicenseCountriesAffected],
            [ImportLicenseProductsDescription], [ImportLicenseCountriesDescription]
        PRINT 'Dropped Law columns batch 3: ImportLicense columns (5 columns)'
    END

    -- Batch 4: Condition columns
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'ConditionAdministrativeBody' AND object_id = OBJECT_ID('dbo.Law'))
    BEGIN
        ALTER TABLE [dbo].[Law] DROP COLUMN
            [ConditionAdministrativeBody], [ConditionProcedureType],
            [ConditionProcedureDuration], [ConditionProcedurePublication]
        PRINT 'Dropped Law columns batch 4: Condition columns (4 columns)'
    END

    -- Batch 5: Justification columns
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'JustificationObjective' AND object_id = OBJECT_ID('dbo.Law'))
    BEGIN
        ALTER TABLE [dbo].[Law] DROP COLUMN
            [JustificationObjective], [JustificationStandard], [JustificationStandardInfo],
            [JustificationDoesDeviate], [JustificationDeviationDescription],
            [JustificationCategory], [JustificationSubCategory],
            [JustificationImposingCountries], [JustificationExplanation], [JustificationPurposes]
        PRINT 'Dropped Law columns batch 5: Justification columns (10 columns)'
    END

    -- Batch 6: Comments, products, documents, legislation columns
    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'CommentsStartDate' AND object_id = OBJECT_ID('dbo.Law'))
    BEGIN
        ALTER TABLE [dbo].[Law] DROP COLUMN
            [CommentsStartDate], [CommentsEndDate], [CommentsAvailablePublicly], [CommentsContactPoint],
            [ProductType], [ProductsAffected], [CountriesAffected],
            [ProductsDescription], [CountriesDescription],
            [DocumentIsUrl], [DocumentUrl], [IsLegislation]
        PRINT 'Dropped Law columns batch 6: Comments through IsLegislation (12 columns)'
    END

    PRINT 'Law table restructured: 53 columns removed'

    COMMIT TRANSACTION
    PRINT 'Law column removal committed successfully'
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Law column removal FAILED: ' + ERROR_MESSAGE()
    ;THROW
END CATCH
GO

-- =============================================
-- PART 3: Remove Admin_Menu.IsVisibleInPublicHomePage
-- =============================================
BEGIN TRANSACTION
BEGIN TRY

    -- Drop default constraint if exists
    DECLARE @menuSql NVARCHAR(MAX) = ''

    SELECT @menuSql = @menuSql + 'ALTER TABLE [dbo].[Admin_Menu] DROP CONSTRAINT [' + dc.name + '];'
    FROM sys.default_constraints dc
    INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
    WHERE dc.parent_object_id = OBJECT_ID('dbo.Admin_Menu')
    AND c.name = 'IsVisibleInPublicHomePage'

    IF LEN(@menuSql) > 0
    BEGIN
        EXEC sp_executesql @menuSql
        PRINT 'Dropped default constraint on Admin_Menu.IsVisibleInPublicHomePage'
    END

    IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'IsVisibleInPublicHomePage' AND object_id = OBJECT_ID('dbo.Admin_Menu'))
    BEGIN
        ALTER TABLE [dbo].[Admin_Menu] DROP COLUMN [IsVisibleInPublicHomePage]
        PRINT 'Removed IsVisibleInPublicHomePage from Admin_Menu'
    END

    COMMIT TRANSACTION
    PRINT '========================================='
    PRINT 'Migration 011_remove_columns completed successfully'
    PRINT '========================================='
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Admin_Menu column removal FAILED: ' + ERROR_MESSAGE()
    ;THROW
END CATCH
GO
