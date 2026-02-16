-- =============================================
-- Migration: 030_drop_ntm_tables
-- Date: 2026-02-16
-- Description: Drop 10 NTM and Law-related tables after archiving data.
--   Tables dropped: NtmCountry, NtmNotification, NtmSubject, NtmUser,
--   Imported_Tariff, Law_ConditionMeasure, Law_RelatedLaw,
--   Snapshot_Law, Snapshot_Law_ConditionMeasure, Snapshot_Law_RelatedLaw
-- Execution: Run in SSMS against the old-structure database
-- Dependencies: 011_remove_columns.sql (Law columns removed first)
-- =============================================

SET NOCOUNT ON;

PRINT '=== Migration 030: Drop NTM Tables ==='
PRINT 'Started at: ' + CONVERT(varchar(30), GETDATE(), 120)
PRINT ''

-- =========================================
-- STEP 1: Create backup schema
-- =========================================

PRINT '--- Step 1: Create backup schema ---'

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'ntm_backup')
BEGIN
    EXEC('CREATE SCHEMA [ntm_backup]')
    PRINT '  Created ntm_backup schema'
END
ELSE
    PRINT '  ntm_backup schema already exists'
GO

-- =========================================
-- STEP 2: Archive table data to backup schema
-- =========================================

PRINT ''
PRINT '--- Step 2: Archive NTM table data ---'

DECLARE @tablesToBackup TABLE (TableName nvarchar(128))
INSERT INTO @tablesToBackup VALUES
    ('NtmCountry'), ('NtmNotification'), ('NtmSubject'), ('NtmUser'),
    ('Imported_Tariff'), ('Law_ConditionMeasure'), ('Law_RelatedLaw'),
    ('Snapshot_Law'), ('Snapshot_Law_ConditionMeasure'), ('Snapshot_Law_RelatedLaw')

DECLARE @tblName nvarchar(128)
DECLARE @sql nvarchar(max)

DECLARE tbl_cursor CURSOR FOR SELECT TableName FROM @tablesToBackup
OPEN tbl_cursor
FETCH NEXT FROM tbl_cursor INTO @tblName

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Only backup if source table exists and backup doesn't
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = @tblName AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
    AND NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = @tblName AND type = 'U' AND schema_id = SCHEMA_ID('ntm_backup'))
    BEGIN
        SET @sql = 'SELECT * INTO [ntm_backup].[' + @tblName + '] FROM [dbo].[' + @tblName + ']'
        EXEC sp_executesql @sql
        PRINT '  Archived ' + @tblName + ' (' + CAST(@@ROWCOUNT AS varchar(10)) + ' rows)'
    END
    ELSE IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE name = @tblName AND type = 'U' AND schema_id = SCHEMA_ID('dbo'))
        PRINT '  ' + @tblName + ' does not exist in dbo - skipped'
    ELSE
        PRINT '  ' + @tblName + ' already archived - skipped'

    FETCH NEXT FROM tbl_cursor INTO @tblName
END

CLOSE tbl_cursor
DEALLOCATE tbl_cursor
GO

-- =========================================
-- STEP 3: Drop foreign key constraints on tables to be dropped
-- =========================================

PRINT ''
PRINT '--- Step 3: Drop foreign key constraints ---'

DECLARE @tablesToDrop TABLE (TableName nvarchar(128))
INSERT INTO @tablesToDrop VALUES
    ('NtmCountry'), ('NtmNotification'), ('NtmSubject'), ('NtmUser'),
    ('Imported_Tariff'), ('Law_ConditionMeasure'), ('Law_RelatedLaw'),
    ('Snapshot_Law'), ('Snapshot_Law_ConditionMeasure'), ('Snapshot_Law_RelatedLaw')

-- Drop FKs that REFERENCE these tables (FKs on other tables pointing to these)
DECLARE @fkSql nvarchar(max) = ''
SELECT @fkSql = @fkSql +
    'ALTER TABLE [' + SCHEMA_NAME(fk.schema_id) + '].[' + OBJECT_NAME(fk.parent_object_id) + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
FROM sys.foreign_keys fk
WHERE OBJECT_NAME(fk.referenced_object_id) IN (SELECT TableName FROM @tablesToDrop)

IF LEN(@fkSql) > 0
BEGIN
    EXEC sp_executesql @fkSql
    PRINT '  Dropped FK constraints referencing NTM tables'
END
ELSE
    PRINT '  No FK constraints referencing NTM tables found'

-- Drop FKs ON these tables (FKs defined on tables being dropped)
SET @fkSql = ''
SELECT @fkSql = @fkSql +
    'ALTER TABLE [' + SCHEMA_NAME(fk.schema_id) + '].[' + OBJECT_NAME(fk.parent_object_id) + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
FROM sys.foreign_keys fk
WHERE OBJECT_NAME(fk.parent_object_id) IN (SELECT TableName FROM @tablesToDrop)

IF LEN(@fkSql) > 0
BEGIN
    EXEC sp_executesql @fkSql
    PRINT '  Dropped FK constraints on NTM tables'
END
ELSE
    PRINT '  No FK constraints on NTM tables found'
GO

-- =========================================
-- STEP 4: Drop tables
-- =========================================

PRINT ''
PRINT '--- Step 4: Drop NTM tables ---'

-- Drop in dependency order (children first)

-- Snapshot tables (no FKs typically)
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_Law_RelatedLaw' AND type = 'U')
BEGIN
    DROP TABLE [dbo].[Snapshot_Law_RelatedLaw]
    PRINT '  Dropped Snapshot_Law_RelatedLaw'
END

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_Law_ConditionMeasure' AND type = 'U')
BEGIN
    DROP TABLE [dbo].[Snapshot_Law_ConditionMeasure]
    PRINT '  Dropped Snapshot_Law_ConditionMeasure'
END

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Snapshot_Law' AND type = 'U')
BEGIN
    DROP TABLE [dbo].[Snapshot_Law]
    PRINT '  Dropped Snapshot_Law'
END

-- Law relation tables
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Law_RelatedLaw' AND type = 'U')
BEGIN
    DROP TABLE [dbo].[Law_RelatedLaw]
    PRINT '  Dropped Law_RelatedLaw'
END

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Law_ConditionMeasure' AND type = 'U')
BEGIN
    DROP TABLE [dbo].[Law_ConditionMeasure]
    PRINT '  Dropped Law_ConditionMeasure'
END

-- NTM tables
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmNotification' AND type = 'U')
BEGIN
    DROP TABLE [dbo].[NtmNotification]
    PRINT '  Dropped NtmNotification'
END

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmCountry' AND type = 'U')
BEGIN
    DROP TABLE [dbo].[NtmCountry]
    PRINT '  Dropped NtmCountry'
END

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmSubject' AND type = 'U')
BEGIN
    DROP TABLE [dbo].[NtmSubject]
    PRINT '  Dropped NtmSubject'
END

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'NtmUser' AND type = 'U')
BEGIN
    DROP TABLE [dbo].[NtmUser]
    PRINT '  Dropped NtmUser'
END

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Imported_Tariff' AND type = 'U')
BEGIN
    DROP TABLE [dbo].[Imported_Tariff]
    PRINT '  Dropped Imported_Tariff'
END
GO

PRINT ''
PRINT '=== Migration 030 completed successfully ==='
PRINT 'Finished at: ' + CONVERT(varchar(30), GETDATE(), 120)
GO
