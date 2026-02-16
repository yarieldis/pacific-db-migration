-- =============================================
-- Migration: 050_create_new_stored_procedures
-- Date: 2026-02-16
-- Description: Create 3 new stored procedures required by SPA schema.
--   1. sp_on_updated_StepRequirement - IsEmittedByInstitution/NumberOfPages sync
--   2. sp_Public_GetFullReviews - Public review retrieval
--   3. sp_snapshot_getStepRequirementCosts - Snapshot requirement costs
--   SP bodies extracted verbatim from new-spa-structure.sql (Libya).
-- Execution: Run in SSMS against the old-structure database
-- Dependencies: 010_add_new_columns.sql, 020_create_new_tables.sql
-- =============================================

SET NOCOUNT ON;

PRINT '=== Migration 050: Create New Stored Procedures ==='
PRINT 'Started at: ' + CONVERT(varchar(30), GETDATE(), 120)
PRINT ''

-- =========================================
-- 1. sp_on_updated_StepRequirement
-- =========================================

PRINT '--- Creating sp_on_updated_StepRequirement ---'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_on_updated_StepRequirement')
BEGIN
    DROP PROCEDURE [dbo].[sp_on_updated_StepRequirement]
    PRINT '  Dropped existing sp_on_updated_StepRequirement'
END
GO

CREATE PROCEDURE [dbo].[sp_on_updated_StepRequirement]
(
	@stepRequirementId int
)
AS
BEGIN

SET NOCOUNT ON

-- update the snapshot table
UPDATE ssr 
	SET ssr.[Type] = sr.[Type],
		ssr.AggregateOperator = sr.AggregateOperator,
		ssr.NbOriginal = sr.NbOriginal,
		ssr.NbCopy = sr.NbCopy,
		ssr.NbAuthenticated = sr.NbAuthenticated,
		ssr.Comments = isnull(sr_i18n.Comments, sr.Comments),
		ssr.Articles = isnull(sr_i18n.Articles, sr.Articles),
		ssr.IsEmittedByInstitution = sr.IsEmittedByInstitution
	FROM Snapshot_StepRequirement ssr
			INNER JOIN Admin_StepRequirement sr on ssr.[Id] = sr.[Id]
				LEFT JOIN Admin_StepRequirement_i18n sr_i18n on sr.Id = sr_i18n.StepRequirement_Id AND sr_i18n.Lang = ssr.Lang		
	WHERE ssr.[Id] = @stepRequirementId
	AND ssr.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

SET NOCOUNT OFF
END
GO

PRINT '  Created sp_on_updated_StepRequirement'
GO

-- =========================================
-- 2. sp_Public_GetFullReviews
-- =========================================

PRINT '--- Creating sp_Public_GetFullReviews ---'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_Public_GetFullReviews')
BEGIN
    DROP PROCEDURE [dbo].[sp_Public_GetFullReviews]
    PRINT '  Dropped existing sp_Public_GetFullReviews'
END
GO

CREATE PROCEDURE [dbo].[sp_Public_GetFullReviews]
(
	@systemId int,
	@lang nvarchar(10),
	@objectiveId int,
	@menuId int,
	@status int
)
AS
SET NOCOUNT ON

/****** STEP RELATED TICKETS ***********/
SELECT TOP 100 PERCENT 
	tv.Objective_Id as ObjectiveID, 
	bl.Id as BlockId,
	bl.Name as BlockName,
	tv.Id AS StepId,
	tv.Name AS StepName, 
	tv.IsParallele as Parallele, 
	tv.IsAlternative as Alternative, 
	tv.IsOptional,
	tv.IsOnline, 
	tv.[Order] as StepOrder, 
	bl.[Order] as BlockOrder,
	sta.status as StepStatus, 
	sta.version as StepStatusVersion, 
	sta.cycle as StepStatusCycle, 

	sta.[content] as StepStatusContent, 
	sta.creatorId as StepStatusCreatorId, 
	sta.dateCreated as StepStatusCreatedDate,
	--ticket related props 
	ticket.TicketId,
	@systemId as SystemId,
	ticket.Pagename,
	ticket.Section,
	ticket.MenuId as MenuId,
	ticket.TicketContent,
	ticket.TicketDate,
	ticket.TicketUser,
	Ticket.TicketUserId,
	ticket.CommentId,
	ticket.CommentContent,
	ticket.CommentDate,
	ticket.CommentUserId,
	ticket.CommentUser
FROM dbo.[Snapshot_Step] AS tv WITH (NOLOCK) 
INNER JOIN dbo.[Snapshot_Block] as bl WITH (NOLOCK) 
	ON tv.Objective_Id=bl.Objective_Id AND tv.Block_Id=bl.Id and tv.Lang=bl.Lang
Inner join (
SELECT DISTINCT TOP (100) PERCENT ChildId, MappingID FROM dbo.[v_public_menu_tree] WITH (NOLOCK) 
		WHERE (Lang =@lang) AND (ChildIsVisible = 1) AND (MappingID > 0 and MappingID is not null)
) mt on mt.MappingID = tv.Objective_Id 
LEFT OUTER JOIN			
	(SELECT TOP 100 PERCENT 
		stepId, 
		status, 
		version, 
		cycle, 
		[content], 
		creatorId, 
		dateCreated 
	FROM  [eregulations-consistency].[00-dbe-consistency].dbo.consistency_status WITH (NOLOCK) 
	WHERE (pagename = 'step') AND (isLast = 1) AND (systemId =@systemId)) AS sta 
	ON tv.Id = sta.stepId
LEFT OUTER JOIN 
	(SELECT TOP 100 PERCENT
	   t.systemId as SystemId,
		t.pagename as Pagename,
		t.section as Section,
		t.menuid as MenuId,
		t.objectiveId as ObjectiveId,
		t.stepId as StepId,
		t.id as TicketId,
		t.content as TicketContent,
		t.dateCreated as TicketDate,
		t.creatorId as TicketUserId,
		tu.UserName as TicketUser,
		c.id AS CommentId,
		c.comment as CommentContent,
		c.dateCreated as CommentDate,
		c.userId as CommentUserId,
		cu.UserName as CommentUser
	FROM [eregulations-consistency].[00-dbe-consistency].dbo.consistency_comments AS c WITH (NOLOCK) 
	RIGHT OUTER JOIN 
		( SELECT 
			*
		FROM [eregulations-consistency].[00-dbe-consistency].dbo.consistency_tickets WITH (NOLOCK) 
		WHERE (systemId = @systemId) and pagename='step' and status = @status) AS t 
	ON c.ticketId = t.Id and c.status > 0
	LEFT JOIN [eregulations-global].[00-dbe-global].dbo.[User] cu on c.userId = cu.Id
	INNER JOIN [eregulations-global].[00-dbe-global].dbo.[User] tu on t.creatorId = tu.Id
	ORDER BY t.stepId) AS Ticket 
ON tv.Id = Ticket.StepId  and tv.Objective_Id = Ticket.ObjectiveId and mt.ChildId = Ticket.MenuId
WHERE (tv.Lang =@lang) 
and (tv.isRecourse=0)
AND  ((@objectiveId is not null and tv.Objective_Id =@objectiveId) or (@objectiveId is null) )

/****** RESUME RELATED TICKETS ***********/
union 
 
SELECT TOP 100 PERCENT 
	ticket.ObjectiveId as ObjectiveID, 
	null as BlockId,
	null as BlockName,
	null AS StepId,
	null AS StepName, 
	null as Parallele, 
	null as Alternative, 
	null as IsOptional,
	null as IsOnline, 
	null as StepOrder, 
	null as BlockOrder,
	null as StepStatus, 
	null as StepStatusVersion, 
	null as StepStatusCycle, 

	null as StepStatusContent, 
	null as StepStatusCreatorId, 
	null as StepStatusCreatedDate,
	--ticket related props 
	ticket.TicketId,
	@systemId as SystemId,
	ticket.Pagename,
	ticket.Section,
	ticket.MenuId,
	ticket.TicketContent,
	ticket.TicketDate,
	ticket.TicketUser,
	Ticket.TicketUserId,
	ticket.CommentId,
	ticket.CommentContent,
	ticket.CommentDate,
	ticket.CommentUserId,
	ticket.CommentUser
FROM (SELECT TOP 100 PERCENT
	   t.systemId as SystemId,
		t.pagename as Pagename,
		t.section as Section,
		t.menuid as MenuId,
		t.objectiveId as ObjectiveId,
		t.stepId as StepId,
		t.id as TicketId,
		t.content as TicketContent,
		t.dateCreated as TicketDate,
		t.creatorId as TicketUserId,
		tu.UserName as TicketUser,
		c.id AS CommentId,
		c.comment as CommentContent,
		c.dateCreated as CommentDate,
		c.userId as CommentUserId,
		cu.UserName as CommentUser
	FROM [eregulations-consistency].[00-dbe-consistency].dbo.consistency_comments AS c WITH (NOLOCK) 
	RIGHT OUTER JOIN 
		( SELECT 
			*
		FROM [eregulations-consistency].[00-dbe-consistency].dbo.consistency_tickets WITH (NOLOCK) 
		WHERE (systemId = @systemId) and pagename='stepsummary' and status = @status
		AND ((@objectiveId is not null and ObjectiveId = @objectiveId  and MenuId = @menuId)
			OR (@objectiveId is null)
			)) AS t 
	ON c.ticketId = t.Id and c.status > 0 
	 
	LEFT JOIN [eregulations-global].[00-dbe-global].dbo.[User] cu on c.userId = cu.Id
	INNER JOIN [eregulations-global].[00-dbe-global].dbo.[User] tu on t.creatorId = tu.Id
	) AS Ticket
Inner join (
SELECT DISTINCT TOP (100) PERCENT ChildId, MappingID FROM dbo.[v_public_menu_tree] WITH (NOLOCK) 
		WHERE (Lang =@lang) AND (ChildIsVisible = 1) AND (MappingID > 0 and MappingID is not null)
) mt on mt.MappingID = Ticket.ObjectiveId and mt.ChildId = Ticket.MenuId 

GO

PRINT '  Created sp_Public_GetFullReviews'
GO

-- =========================================
-- 3. sp_snapshot_getStepRequirementCosts
-- =========================================

PRINT '--- Creating sp_snapshot_getStepRequirementCosts ---'

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_snapshot_getStepRequirementCosts')
BEGIN
    DROP PROCEDURE [dbo].[sp_snapshot_getStepRequirementCosts]
    PRINT '  Dropped existing sp_snapshot_getStepRequirementCosts'
END
GO

CREATE PROCEDURE [dbo].[sp_snapshot_getStepRequirementCosts]
(
@registryId int,
@blockId int,
@stepId int,
@requirementId int
)
AS
SET NOCOUNT ON

SELECT *
FROM Snapshot_StepRequirementCost with (nolock)
WHERE
Registry_Id = @registryId
AND Block_Id = @blockId
AND Step_Id = @stepId
AND GenericRequirement_Id = @requirementId
GO

PRINT '  Created sp_snapshot_getStepRequirementCosts'
GO

PRINT ''
PRINT '=== Migration 050 completed successfully ==='
PRINT 'Finished at: ' + CONVERT(varchar(30), GETDATE(), 120)
GO
