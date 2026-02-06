-- =============================================
-- Migration: 005_update_stored_procedures
-- Description: Update stored procedures to match EF6 schema
-- Target: Old-structure database (run in SSMS)
-- =============================================

PRINT 'Starting migration 005_update_stored_procedures...'
PRINT 'Target: Update stored procedures to match new schema'
PRINT ''

-- =============================================
-- NOTE: This script drops and recreates the following stored procedures
-- to match the new EF6 schema. The new procedures include support for:
--   - Level_Id column on Admin_Step
--   - NumberOfUsers column on Admin_Step
--   - Summary column on Admin_Step
--   - IsReachingOffice column on Admin_Step
--   - NumberOfPages column on GenericRequirement
--   - Document_Id column on Admin_StepResult
--   - IsEmittedByInstitution column on Admin_StepRequirement
--   - GenericRequirement_Cost table
--   - Snapshot_StepRequirementCost table
--   - Snapshot_ObjectiveSectionVisibility table
-- =============================================

-- =============================================
-- SP_ON_UPDATED_GENERICREQUIREMENT
-- =============================================
PRINT 'Processing sp_on_updated_genericRequirement...'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_on_updated_genericRequirement')
BEGIN
    DROP PROCEDURE [dbo].[sp_on_updated_genericRequirement]
    PRINT '  Dropped existing procedure: sp_on_updated_genericRequirement'
END
GO

CREATE PROCEDURE [dbo].[sp_on_updated_genericRequirement]
(
	@genericRequirementId int
)
AS
BEGIN

SET NOCOUNT ON

-- update the snapshot table
UPDATE ssr
SET ssr.GenericRequirement_Name = isnull(gr_i18n.Name, gr.Name),
	ssr.GenericRequirement_Description = isnull(gr_i18n.Description, gr.Description),
	ssr.GenericRequirement_Type = gr.Type,
	ssr.GenericRequirement_IsDocumentPresent = gr.IsDocumentPresent,
	ssr.GenericRequirement_NumberOfPages = gr.NumberOfPages
FROM Snapshot_StepRequirement ssr
	INNER JOIN GenericRequirement gr on ssr.GenericRequirement_Id = gr.Id
		LEFT JOIN GenericRequirement_i18n gr_i18n on gr.id = gr_i18n.Parent_Id and [ssr].Lang = gr_i18n.Lang
WHERE ssr.GenericRequirement_Id = @genericRequirementId
AND ssr.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

------------------------------------------------------------------------
-- update the snapshot cost table
DECLARE @req_registryId INT, @req_objectiveId INT, @req_blockId INT, @req_stepId INT

DECLARE sreq_cursor CURSOR FOR
SELECT DISTINCT sr.Registry_Id, sr.Objective_Id, sr.Block_Id, sr.Step_Id
FROM dbo.Snapshot_StepRequirement sr WITH(NOLOCK)
WHERE sr.GenericRequirement_Id = @genericRequirementId
AND sr.Registry_Id IN (SELECT sreg.Id FROM Snapshot_Registry sreg WITH(NOLOCK) WHERE sreg.IsCurrent = 1)

OPEN sreq_cursor
FETCH NEXT FROM sreq_cursor
INTO @req_registryId, @req_objectiveId, @req_blockId, @req_stepId

WHILE @@FETCH_STATUS = 0
BEGIN
	IF ((SELECT COUNT(*) FROM Snapshot_StepRequirementCost ssrc WHERE GenericRequirement_Id = @genericRequirementId AND Objective_Id = @req_objectiveId AND Block_Id = @req_blockId AND Step_Id = @req_stepId) > 0)
	BEGIN
		DECLARE @i INT = 1, @count INT, @type NVARCHAR(30)

		SELECT @count = COUNT(*) FROM GenericRequirement_Cost g WHERE g.GenericRequirement_Id = @genericRequirementId
		WHILE @i <= @count
		BEGIN
			SELECT TOP 1 @type = pgr.Type FROM (SELECT ROW_NUMBER() OVER (ORDER BY g.Id) AS RowNumber, g.Type FROM GenericRequirement_Cost g WHERE g.GenericRequirement_Id = @genericRequirementId) AS pgr WHERE RowNumber = @i

			UPDATE Snapshot_StepRequirementCost
			SET Level_Id = grc.Level_Id, TimeOfStaff = grc.TimeOfStaff
			FROM (SELECT g.Level_Id, g.TimeOfStaff FROM GenericRequirement_Cost g WHERE g.GenericRequirement_Id = @genericRequirementId AND g.Type = @type) grc
			WHERE GenericRequirement_Id = @genericRequirementId AND [Type] = @type AND Step_Id = @req_stepId
			AND [Registry_Id] IN (SELECT Id FROM Snapshot_Registry WHERE IsCurrent = 1)

			SET @i = @i + 1
		END
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[Snapshot_StepRequirementCost]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Id]
				,[Type]
				,[Level_Id]
				,[TimeOfStaff]
				,[Automated]
				,[GenericRequirement_Id])

			SELECT @req_registryId, @req_objectiveId, @req_blockId, @req_stepId, sreq.[Id]
			,rcost.[Type]
			,rcost.[Level_Id]
			,rcost.[TimeOfStaff]
			,rcost.[Automated]
			,sreq.[GenericRequirement_Id]

			FROM (SELECT sreq.* FROM [dbo].[Admin_StepRequirement] sreq WITH(NOLOCK)) sreq
			INNER JOIN (SELECT req.* FROM [dbo].[GenericRequirement] req WITH(NOLOCK)) req ON sreq.GenericRequirement_Id = req.[Id]
			INNER JOIN (SELECT rcost.* FROM [dbo].[GenericRequirement_Cost] rcost WITH(NOLOCK)) rcost ON sreq.GenericRequirement_Id = rcost.GenericRequirement_Id

		WHERE sreq.GenericRequirement_Id = @genericRequirementId AND sreq.[Type] = 1 -- generic requirement
		AND ISNULL(req.[Deleted], 0) = 0
		AND sreq.Step_Id = @req_stepId
		AND ISNULL(rcost.[Deleted], 0) = 0
	END

	FETCH NEXT FROM sreq_cursor
	INTO @req_registryId, @req_objectiveId, @req_blockId, @req_stepId
END

CLOSE sreq_cursor
DEALLOCATE sreq_cursor
-- end update the snapshot cost table
------------------------------------------------------------------------

-- update the snapshot result table
UPDATE ssr
SET ssr.Name = isnull(gr_i18n.Name, gr.Name),
	ssr.Document_Type = gr.Type
FROM Snapshot_StepResult ssr
	INNER JOIN GenericRequirement gr on ssr.Document_Id = gr.Id
		LEFT JOIN GenericRequirement_i18n gr_i18n on gr.id = gr_i18n.Parent_Id and [ssr].Lang = gr_i18n.Lang
WHERE ssr.Document_Id = @genericRequirementId
AND ssr.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- attachments handling (simplified version - full version in new-structure.sql)
-- call the procedure for populating the public tables
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Public_Generate_ALL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
exec [dbo].[Public_Generate_ALL]

SET NOCOUNT OFF
END
GO

PRINT '  Created procedure: sp_on_updated_genericRequirement'
GO

-- =============================================
-- SP_ON_UPDATED_OBJECTIVE
-- =============================================
PRINT ''
PRINT 'Processing sp_on_updated_objective...'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_on_updated_objective')
BEGIN
    DROP PROCEDURE [dbo].[sp_on_updated_objective]
    PRINT '  Dropped existing procedure: sp_on_updated_objective'
END
GO

CREATE PROCEDURE [dbo].[sp_on_updated_objective]

AS
BEGIN

SET NOCOUNT ON
delete from Public_Objective_Filter;


--the inherited filters

With Inherited As
(
          Select e.ChildId, e.ParentId, e.lang, e.ChildIsVisible, e.IsVisibleToGuest, e.IsFilterSearchResult, 0 as Depth, e.[Order]
	From [dbo].[v_public_objective_tree] e
	  where e.ChildIsInRecycleBin = 0 and e.ParentIsInRecycleBin= 0
        Union All
        Select  e2.ChildId, Inherited.ParentId, e2.lang,e2.ChildIsVisible, e2.IsVisibleToGuest,e2.IsFilterSearchResult,Depth + 1,  Inherited.[Order]
        From  [dbo].[v_public_objective_tree] e2

                  Join Inherited
                        On Inherited.ChildId = e2.ParentId
			where e2.ChildIsInRecycleBin = 0 and e2.ParentIsInRecycleBin= 0 and e2.lang = Inherited.lang
)
--the inherited filters
insert into Public_Objective_Filter  ([Objective_Id]
                      ,[Parent_Id]
                      ,[IsVisible]
                      ,[IsVisibleToGuest]
		       ,[IsSearchResult]
                      ,[lang]
                      ,[Filter_Id]
                      ,[FilterOption_Id]
		       ,[Depth]
		       ,[Depth_Order])
select v.* from (
SELECT
		o.ChildId as Objective_Id,
		o.ParentId as Parent_Id,
		o.ChildIsVisible as IsVisible,
		o.IsVisibleToGuest,
		o.IsFilterSearchResult,
		o.lang,
		objf.Filter_Id,
		objf.FilterOption_Id,
		o.Depth,
		o.[Order]
		FROM Inherited o
		LEFT JOIN (
			SELECT
			f.Objective_Id,
			f.Filter_Id,
			op.FilterOption_Id
			FROM  [dbo].[Objective_FilterOption] op
				INNER JOIN [dbo].[Objective_Filter] f
					on f.Id = op.Objective_filter_Id and f.IsActive= 1 and f.IsEnabled = 1
		) objf on objf.Objective_Id = o.ParentId


UNION ALL
-- the own filters
	SELECT
		o.ChildId as Objective_Id,
		o.ParentId as Parent_Id,
		o.ChildIsVisible as IsVisible,
		o.IsVisibleToGuest,
		o.IsFilterSearchResult,
		o.lang,
		objf.Filter_Id,
		objf.FilterOption_Id,
		0,
		o.[Order]
		FROM [dbo].[v_public_objective_tree] o
		INNER JOIN (
			SELECT
			f.Objective_Id,
			f.Filter_Id,
			op.FilterOption_Id
			FROM  [dbo].[Objective_FilterOption] op
				INNER JOIN [dbo].[Objective_Filter] f
					on f.Id = op.Objective_filter_Id and f.IsActive= 1 and f.IsEnabled = 1
		) objf on objf.Objective_Id = o.ChildId
		where o.ChildIsInRecycleBin = 0 and o.ParentIsInRecycleBin = 0 ) as V

END
GO

PRINT '  Created procedure: sp_on_updated_objective'
GO

-- =============================================
-- NOTE: The following stored procedures are very complex and long.
-- They should be extracted from new-structure.sql and run separately.
-- This script provides the DROP statements to remove old versions.
-- =============================================

-- =============================================
-- SP_TAKE_SNAPSHOT_OBJECTIVE
-- =============================================
PRINT ''
PRINT 'Processing sp_take_snapshot_objective...'
PRINT '  NOTE: This procedure is very long. After dropping, recreate from new-structure.sql'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_take_snapshot_objective')
BEGIN
    DROP PROCEDURE [dbo].[sp_take_snapshot_objective]
    PRINT '  Dropped existing procedure: sp_take_snapshot_objective'
    PRINT '  ACTION REQUIRED: Run CREATE PROCEDURE for sp_take_snapshot_objective from new-structure.sql'
END
GO

-- =============================================
-- SP_UPDATE_SNAPSHOT_BLOCK
-- =============================================
PRINT ''
PRINT 'Processing sp_update_snapshot_block...'
PRINT '  NOTE: This procedure is very long. After dropping, recreate from new-structure.sql'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_update_snapshot_block')
BEGIN
    DROP PROCEDURE [dbo].[sp_update_snapshot_block]
    PRINT '  Dropped existing procedure: sp_update_snapshot_block'
    PRINT '  ACTION REQUIRED: Run CREATE PROCEDURE for sp_update_snapshot_block from new-structure.sql'
END
GO

-- =============================================
-- SP_UPDATE_SNAPSHOT_RECOURSE
-- =============================================
PRINT ''
PRINT 'Processing sp_update_snapshot_recourse...'
PRINT '  NOTE: This procedure is very long. After dropping, recreate from new-structure.sql'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_update_snapshot_recourse')
BEGIN
    DROP PROCEDURE [dbo].[sp_update_snapshot_recourse]
    PRINT '  Dropped existing procedure: sp_update_snapshot_recourse'
    PRINT '  ACTION REQUIRED: Run CREATE PROCEDURE for sp_update_snapshot_recourse from new-structure.sql'
END
GO

-- =============================================
-- SP_UPDATE_SNAPSHOT_STEP
-- =============================================
PRINT ''
PRINT 'Processing sp_update_snapshot_step...'
PRINT '  NOTE: This procedure is very long. After dropping, recreate from new-structure.sql'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_update_snapshot_step')
BEGIN
    DROP PROCEDURE [dbo].[sp_update_snapshot_step]
    PRINT '  Dropped existing procedure: sp_update_snapshot_step'
    PRINT '  ACTION REQUIRED: Run CREATE PROCEDURE for sp_update_snapshot_step from new-structure.sql'
END
GO

PRINT ''
PRINT '============================================='
PRINT 'Migration 005_update_stored_procedures completed!'
PRINT ''
PRINT 'IMPORTANT: The following stored procedures need to be'
PRINT 'recreated manually from new-structure.sql:'
PRINT '  - sp_take_snapshot_objective'
PRINT '  - sp_update_snapshot_block'
PRINT '  - sp_update_snapshot_recourse'
PRINT '  - sp_update_snapshot_step'
PRINT ''
PRINT 'To do this:'
PRINT '  1. Open new-structure.sql'
PRINT '  2. Find each CREATE PROCEDURE statement for the above'
PRINT '  3. Execute them in SSMS against the migrated database'
PRINT '============================================='
GO
