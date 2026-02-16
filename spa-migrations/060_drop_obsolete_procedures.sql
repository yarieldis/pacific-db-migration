-- =============================================
-- Migration: 060_drop_obsolete_procedures
-- Date: 2026-02-16
-- Description: Drop stored procedures that are no longer needed in the SPA schema.
--   Drops: sp_publish_legislation
-- =============================================

BEGIN TRANSACTION
BEGIN TRY

    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_publish_legislation' AND type = 'P')
    BEGIN
        DROP PROCEDURE [dbo].[sp_publish_legislation]
        PRINT 'Dropped sp_publish_legislation'
    END
    ELSE
    BEGIN
        PRINT 'sp_publish_legislation does not exist - skipping'
    END

    COMMIT TRANSACTION
    PRINT '========================================='
    PRINT 'Migration 060_drop_obsolete_procedures completed successfully'
    PRINT '========================================='
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Migration 060_drop_obsolete_procedures FAILED: ' + ERROR_MESSAGE()
    ;THROW
END CATCH
GO
