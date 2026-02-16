-- =============================================
-- Migration: 060_drop_obsolete_procedures
-- Date: 2026-02-16
-- Description: Drop stored procedures no longer needed in SPA schema.
--   Drops: sp_publish_legislation (NTM/legislation feature removed)
-- Execution: Run in SSMS against the old-structure database
-- Dependencies: 051_update_stored_procedures.sql
-- =============================================

SET NOCOUNT ON;

PRINT '=== Migration 060: Drop Obsolete Procedures ==='
PRINT 'Started at: ' + CONVERT(varchar(30), GETDATE(), 120)
PRINT ''

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_publish_legislation')
BEGIN
    DROP PROCEDURE [dbo].[sp_publish_legislation]
    PRINT '  Dropped sp_publish_legislation'
END
ELSE
    PRINT '  sp_publish_legislation does not exist - skipped'
GO

PRINT ''
PRINT '=== Migration 060 completed successfully ==='
PRINT 'Finished at: ' + CONVERT(varchar(30), GETDATE(), 120)
GO
