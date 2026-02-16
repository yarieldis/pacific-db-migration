-- =============================================
-- Migration: 030_drop_ntm_tables
-- Date: 2026-02-16
-- Description: Drop 10 NTM and Law-related tables after archiving data.
--   Tables dropped: NtmCountry, NtmNotification, NtmSubject, NtmUser,
--   Imported_Tariff, Law_ConditionMeasure, Law_RelatedLaw,
--   Snapshot_Law, Snapshot_Law_ConditionMeasure, Snapshot_Law_RelatedLaw
-- =============================================

-- =============================================
-- PART 1: Create backup schema and archive NTM data
-- =============================================
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'ntm_backup')
BEGIN
    EXEC('CREATE SCHEMA [ntm_backup]')
    PRINT 'Created ntm_backup schema'
END
GO

-- Archive each table before dropping
DECLARE @tablesToDrop TABLE (TableName NVARCHAR(200))
INSERT INTO @tablesToDrop VALUES
    ('NtmCountry'), ('NtmNotification'), ('NtmSubject'), ('NtmUser'),
    ('Imported_Tariff'), ('Law_ConditionMeasure'), ('Law_RelatedLaw'),
    ('Snapshot_Law'), ('Snapshot_Law_ConditionMeasure'), ('Snapshot_Law_RelatedLaw')

DECLARE @tbl NVARCHAR(200)
DECLARE @sql NVARCHAR(MAX)

DECLARE tbl_cursor CURSOR FOR SELECT TableName FROM @tablesToDrop
OPEN tbl_cursor
FETCH NEXT FROM tbl_cursor INTO @tbl

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Only archive if source exists and backup doesn't
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = @tbl AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
    AND NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = @tbl AND type = 'U' AND schema_id = SCHEMA_ID('ntm_backup'))
    BEGIN
        SET @sql = 'SELECT * INTO [ntm_backup].[' + @tbl + '] FROM [dbo].[' + @tbl + ']'
        EXEC sp_executesql @sql
        PRINT 'Archived ' + @tbl + ' to ntm_backup schema'
    END
    ELSE IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = @tbl AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
    BEGIN
        PRINT @tbl + ' does not exist in dbo schema - skipping archive'
    END
    ELSE
    BEGIN
        PRINT @tbl + ' already archived in ntm_backup schema - skipping'
    END

    FETCH NEXT FROM tbl_cursor INTO @tbl
END

CLOSE tbl_cursor
DEALLOCATE tbl_cursor
GO

-- =============================================
-- PART 2: Verify archives
-- =============================================
DECLARE @verified BIT = 1
DECLARE @tblName NVARCHAR(200)
DECLARE @srcCount INT, @bkpCount INT
DECLARE @sql2 NVARCHAR(MAX)

DECLARE @verifyTables TABLE (TableName NVARCHAR(200))
INSERT INTO @verifyTables VALUES
    ('NtmCountry'), ('NtmNotification'), ('NtmSubject'), ('NtmUser'),
    ('Imported_Tariff'), ('Law_ConditionMeasure'), ('Law_RelatedLaw'),
    ('Snapshot_Law'), ('Snapshot_Law_ConditionMeasure'), ('Snapshot_Law_RelatedLaw')

DECLARE verify_cursor CURSOR FOR SELECT TableName FROM @verifyTables
OPEN verify_cursor
FETCH NEXT FROM verify_cursor INTO @tblName

WHILE @@FETCH_STATUS = 0
BEGIN
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = @tblName AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
    AND EXISTS (SELECT 1 FROM sys.objects WHERE name = @tblName AND type = 'U' AND schema_id = SCHEMA_ID('ntm_backup'))
    BEGIN
        SET @sql2 = 'SELECT @src = COUNT(*) FROM [dbo].[' + @tblName + ']'
        EXEC sp_executesql @sql2, N'@src INT OUTPUT', @src = @srcCount OUTPUT

        SET @sql2 = 'SELECT @bkp = COUNT(*) FROM [ntm_backup].[' + @tblName + ']'
        EXEC sp_executesql @sql2, N'@bkp INT OUTPUT', @bkp = @bkpCount OUTPUT

        IF @srcCount <> @bkpCount
        BEGIN
            PRINT 'WARNING: ' + @tblName + ' backup count mismatch: source=' + CAST(@srcCount AS VARCHAR) + ' backup=' + CAST(@bkpCount AS VARCHAR)
            SET @verified = 0
        END
        ELSE
        BEGIN
            PRINT @tblName + ' verified: ' + CAST(@srcCount AS VARCHAR) + ' rows'
        END
    END

    FETCH NEXT FROM verify_cursor INTO @tblName
END

CLOSE verify_cursor
DEALLOCATE verify_cursor

IF @verified = 0
BEGIN
    RAISERROR('Archive verification failed. Aborting table drops.', 16, 1)
    RETURN
END
PRINT 'All archives verified successfully'
GO

-- =============================================
-- PART 3: Drop foreign key constraints on NTM tables
-- =============================================
BEGIN TRANSACTION
BEGIN TRY

    DECLARE @fkSql NVARCHAR(MAX) = ''

    -- Drop all FK constraints where these tables are either parent or child
    SELECT @fkSql = @fkSql +
        'ALTER TABLE [' + OBJECT_SCHEMA_NAME(fk.parent_object_id) + '].[' + OBJECT_NAME(fk.parent_object_id) + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
    FROM sys.foreign_keys fk
    WHERE fk.parent_object_id IN (
        OBJECT_ID('dbo.NtmCountry'), OBJECT_ID('dbo.NtmNotification'),
        OBJECT_ID('dbo.NtmSubject'), OBJECT_ID('dbo.NtmUser'),
        OBJECT_ID('dbo.Imported_Tariff'),
        OBJECT_ID('dbo.Law_ConditionMeasure'), OBJECT_ID('dbo.Law_RelatedLaw'),
        OBJECT_ID('dbo.Snapshot_Law'), OBJECT_ID('dbo.Snapshot_Law_ConditionMeasure'),
        OBJECT_ID('dbo.Snapshot_Law_RelatedLaw')
    )
    OR fk.referenced_object_id IN (
        OBJECT_ID('dbo.NtmCountry'), OBJECT_ID('dbo.NtmNotification'),
        OBJECT_ID('dbo.NtmSubject'), OBJECT_ID('dbo.NtmUser'),
        OBJECT_ID('dbo.Imported_Tariff'),
        OBJECT_ID('dbo.Law_ConditionMeasure'), OBJECT_ID('dbo.Law_RelatedLaw'),
        OBJECT_ID('dbo.Snapshot_Law'), OBJECT_ID('dbo.Snapshot_Law_ConditionMeasure'),
        OBJECT_ID('dbo.Snapshot_Law_RelatedLaw')
    )

    IF LEN(@fkSql) > 0
    BEGIN
        EXEC sp_executesql @fkSql
        PRINT 'Dropped foreign key constraints on NTM tables'
    END

    -- =============================================
    -- PART 4: Drop NTM tables
    -- =============================================

    -- NTM module tables
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmCountry' AND type = 'U')
        DROP TABLE [dbo].[NtmCountry]
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmNotification' AND type = 'U')
        DROP TABLE [dbo].[NtmNotification]
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmSubject' AND type = 'U')
        DROP TABLE [dbo].[NtmSubject]
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmUser' AND type = 'U')
        DROP TABLE [dbo].[NtmUser]
    PRINT 'Dropped NTM module tables (NtmCountry, NtmNotification, NtmSubject, NtmUser)'

    -- Imported_Tariff
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Imported_Tariff' AND type = 'U')
        DROP TABLE [dbo].[Imported_Tariff]
    PRINT 'Dropped Imported_Tariff'

    -- Law relation tables
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Law_ConditionMeasure' AND type = 'U')
        DROP TABLE [dbo].[Law_ConditionMeasure]
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Law_RelatedLaw' AND type = 'U')
        DROP TABLE [dbo].[Law_RelatedLaw]
    PRINT 'Dropped Law_ConditionMeasure, Law_RelatedLaw'

    -- Snapshot counterparts
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_Law' AND type = 'U')
        DROP TABLE [dbo].[Snapshot_Law]
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_Law_ConditionMeasure' AND type = 'U')
        DROP TABLE [dbo].[Snapshot_Law_ConditionMeasure]
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_Law_RelatedLaw' AND type = 'U')
        DROP TABLE [dbo].[Snapshot_Law_RelatedLaw]
    PRINT 'Dropped Snapshot_Law, Snapshot_Law_ConditionMeasure, Snapshot_Law_RelatedLaw'

    COMMIT TRANSACTION
    PRINT '========================================='
    PRINT 'Migration 030_drop_ntm_tables completed successfully'
    PRINT '========================================='
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Migration 030_drop_ntm_tables FAILED: ' + ERROR_MESSAGE()
    ;THROW
END CATCH
GO
