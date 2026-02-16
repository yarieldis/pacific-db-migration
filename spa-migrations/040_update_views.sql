-- =============================================
-- Migration: 040_update_views
-- Date: 2026-02-16
-- Description: Update 2 views with structural changes from SPA schema.
--   - v_law: 15 columns removed, EntityInCharge JOIN removed
--   - v_public_review: LEFT OUTER->INNER JOIN, legislation UNION removed
--   View bodies extracted verbatim from new-spa-structure.sql (Libya).
-- Execution: Run in SSMS against the old-structure database
-- Dependencies: 011_remove_columns.sql (Law columns must be removed first)
-- =============================================

SET NOCOUNT ON;

PRINT '=== Migration 040: Update Views ==='
PRINT 'Started at: ' + CONVERT(varchar(30), GETDATE(), 120)
PRINT ''

-- =========================================
-- 1. v_law - Structural change
-- =========================================

PRINT '--- Updating v_law ---'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_law')
BEGIN
    DROP VIEW [dbo].[v_law]
    PRINT '  Dropped existing v_law'
END
GO

CREATE VIEW [dbo].[v_law]
AS

-- get the genric requirement
SELECT l.[Id]
      ,l.[Name]
      ,l.[OwnershipStatus]
	  ,l.[CreatedDate]
      ,l.[CreatedUser]
      ,l.[ModifiedDate]
      ,l.[ModifiedUser]
	  ,m.[Name] as [Media_Name]
	  ,m.[FileName] as [Media_FileName]
	  ,m.[Extention] as [Media_Extention]
	  ,isnull(sl.[NbSteps], 0) as [NbSteps]
	  ,l.[IsVisibleInPublicDirectory]
FROM [dbo].[Law] l with (nolock)
		LEFT JOIN
			( SELECT obj_m.[object_id], m.*
			  FROM Admin_Object_Media obj_m with(nolock)
					INNER JOIN Media m with(nolock) on obj_m.Media_id = m.Id
			  WHERE obj_m.[Type] = 'Law'
			  AND isnull(m.[Deleted], 0) = 0
			) m on l.id = m.[Object_Id]
		LEFT JOIN
			(	SELECT sl.Law_Id, count(*) as NbSteps
				FROM [dbo].[Admin_StepLaw] sl with(nolock)
						INNER JOIN [dbo].[Admin_Step] s with(nolock) on sl.Step_ID = s.Id
				WHERE sl.Law_Id IS NOT NULL
				AND isnull(s.[Deleted], 0) = 0
				GROUP BY sl.Law_Id
			) sl on l.id = sl.Law_Id
WHERE isnull(l.[Deleted], 0) = 0
GO

PRINT '  Created v_law with SPA definition'
GO

-- =========================================
-- 2. v_public_review - Structural change
-- =========================================

PRINT ''
PRINT '--- Updating v_public_review ---'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_public_review')
BEGIN
    DROP VIEW [dbo].[v_public_review]
    PRINT '  Dropped existing v_public_review'
END
GO

CREATE VIEW [dbo].[v_public_review]
AS
--step tickets
SELECT TOP 100 PERCENT
	t.id AS TicketId,
	t.systemId as SystemId,
	t.pagename as PageName,
	t.menuid as MenuId,
	IsNull(mn.ChildName ,ob.ChildName) as MenuCaption,
	t.objectiveId as ObjectiveId,
	t.stepId as StepId,
	tv.Name AS StepCaption,
	t.section as Section,
	t.priority as Priority,
	t.status as Status,
	t.[content] as Content,
	t.dateCreated as DateCreated,
	t.creatorId as CreatorId,
	u.UserName AS CreatorUsername,
	t.lastModified as LastModified,
	t.modifierId as ModifierId,
	t.commentLastStatus as CommentLastStatus,
	tv.[Order] as Regulation_Order ,
	COUNT(c.id) AS CountComments,
	IsNull(mn.Lang,ob.Lang) as Lang
 FROM [eregulations-consistency].[00-dbe-consistency].dbo.consistency_tickets AS t WITH (NOLOCK) INNER JOIN
[eregulations-global].[00-dbe-global].dbo.[User] AS u WITH (NOLOCK) ON t.creatorId = u.ID
Inner JOIN
(SELECT TOP 100 PERCENT Name, Objective_Id, [Order], Id, Lang FROM dbo.Snapshot_Step WITH (NOLOCK)) AS tv
	ON t.objectiveId = tv.Objective_Id AND t.stepId = tv.Id
LEFT OUTER JOIN
	(SELECT TOP 100 PERCENT ChildName, ChildId, Lang FROM dbo.v_public_menu_tree WITH (NOLOCK) WHERE (ChildIsVisible =1)) AS mn
	ON t.menuid = mn.ChildId and mn.Lang=tv.Lang
LEFT OUTER JOIN
	(SELECT TOP 100 PERCENT ChildName, ChildId, Lang FROM dbo.v_public_objective_tree WITH (NOLOCK) WHERE (ChildIsVisible =1)) AS ob
	ON t.objectiveId = ob.ChildId and ob.Lang=tv.Lang

LEFT OUTER JOIN
	[eregulations-consistency].[00-dbe-consistency].dbo.consistency_comments AS c WITH (NOLOCK)
		ON t.id = c.ticketId and c.[status]>0
WHERE t.pagename='step'
GROUP BY t.id,
		t.systemId,
		t.pagename,
		t.menuid,
		IsNull(mn.ChildName ,ob.ChildName),
		t.objectiveId,
		t.stepId,
		tv.Name,
		t.section,
		t.priority,
		t.status,
		t.[content],
		tv.[Order],
		t.dateCreated,
		t.creatorId,
		u.UserName,
		t.lastModified,
		t.modifierId,
		t.commentsCounter,
		t.commentLastStatus,
		t.id,
		IsNull(mn.Lang,ob.Lang)
UNION
--procedure tickets
SELECT TOP 100 PERCENT
	t.id AS TicketId,
	t.systemId as SystemId,
	t.pagename as PageName,
	t.menuid as MenuId,
	IsNull(mn.ChildName,ob.ChildName) AS MenuCaption,
	t.objectiveId as ObjectiveId,
	t.stepId as StepId,
	null AS StepCaption,
	t.section as Section,
	t.priority as Priority,
	t.status as Status,
	t.[content] as Content,
	t.dateCreated as DateCreated,
	t.creatorId as CreatorId,
	u.UserName AS CreatorUsername,
	t.lastModified as LastModified,
	t.modifierId as ModifierId,
	t.commentLastStatus as CommentLastStatus,
	null as Regulation_Order ,
	COUNT(c.id) AS CountComments,
	IsNull(mn.Lang,ob.Lang)
 FROM [eregulations-consistency].[00-dbe-consistency].dbo.consistency_tickets AS t WITH (NOLOCK) INNER JOIN
[eregulations-global].[00-dbe-global].dbo.[User] AS u WITH (NOLOCK) ON t.creatorId = u.ID
LEFT OUTER JOIN
	(SELECT TOP 100 PERCENT ChildName, ChildId, Lang  FROM dbo.v_public_menu_tree WITH (NOLOCK) WHERE (ChildIsVisible =1)) AS mn
	ON t.menuid = mn.ChildId
LEFT OUTER JOIN
	(SELECT TOP 100 PERCENT ChildName, ChildId, Lang FROM dbo.v_public_objective_tree WITH (NOLOCK) WHERE (ChildIsVisible =1)) AS ob
	ON t.objectiveId = ob.ChildId
LEFT OUTER JOIN
	[eregulations-consistency].[00-dbe-consistency].dbo.consistency_comments AS c WITH (NOLOCK)
		ON t.id = c.ticketId and c.[status]>0
WHERE t.pagename='stepsummary'
GROUP BY t.id,
		t.systemId,
		t.pagename,
		t.menuid,
		IsNull(mn.ChildName,ob.ChildName),
		t.objectiveId,
		t.stepId,
		t.section,
		t.priority,
		t.status,
		t.[content],
		t.dateCreated,
		t.creatorId,
		u.UserName,
		t.lastModified,
		t.modifierId,
		t.commentsCounter,
		t.commentLastStatus,
		t.id,
		IsNull(mn.Lang,ob.Lang)


UNION
--menu tickets
SELECT TOP 100 PERCENT
	t.id AS TicketId,
	t.systemId as SystemId,
	t.pagename as PageName,
	t.menuid as MenuId,
	mn.ChildName AS MenuCaption,
	t.objectiveId as ObjectiveId,
	t.stepId as StepId,
	null AS StepCaption,
	t.section as Section,
	t.priority as Priority,
	t.status as Status,
	t.[content] as Content,
	t.dateCreated as DateCreated,
	t.creatorId as CreatorId,
	u.UserName AS CreatorUsername,
	t.lastModified as LastModified,
	t.modifierId as ModifierId,
	t.commentLastStatus as CommentLastStatus,
	null as Regulation_Order ,
	COUNT(c.id) AS CountComments,
	mn.Lang
 FROM [eregulations-consistency].[00-dbe-consistency].dbo.consistency_tickets AS t WITH (NOLOCK) INNER JOIN
[eregulations-global].[00-dbe-global].dbo.[User] AS u WITH (NOLOCK) ON t.creatorId = u.ID
LEFT OUTER JOIN
	(SELECT TOP 100 PERCENT ChildName, ChildId, Lang FROM dbo.v_public_menu_tree WITH (NOLOCK) WHERE (ChildIsVisible =1)) AS mn
	ON t.menuid = mn.ChildId
LEFT OUTER JOIN
	[eregulations-consistency].[00-dbe-consistency].dbo.consistency_comments AS c WITH (NOLOCK)
		ON t.id = c.ticketId and c.[status]>0
WHERE t.pagename='menu'
GROUP BY t.id,
		t.systemId,
		t.pagename,
		t.menuid,
		mn.ChildName,
		t.objectiveId,
		t.stepId,
		t.section,
		t.priority,
		t.status,
		t.[content],
		t.dateCreated,
		t.creatorId,
		u.UserName,
		t.lastModified,
		t.modifierId,
		t.commentsCounter,
		t.commentLastStatus,
		t.id,
		mn.Lang

UNION
--objective tickets
SELECT TOP 100 PERCENT
	t.id AS TicketId,
	t.systemId as SystemId,
	t.pagename as PageName,
	t.menuid as MenuId,
	mn.ChildName AS MenuCaption,
	t.objectiveId as ObjectiveId,
	t.stepId as StepId,
	null AS StepCaption,
	t.section as Section,
	t.priority as Priority,
	t.status as Status,
	t.[content] as Content,
	t.dateCreated as DateCreated,
	t.creatorId as CreatorId,
	u.UserName AS CreatorUsername,
	t.lastModified as LastModified,
	t.modifierId as ModifierId,
	t.commentLastStatus as CommentLastStatus,
	null as Regulation_Order ,
	COUNT(c.id) AS CountComments,
	mn.Lang
 FROM [eregulations-consistency].[00-dbe-consistency].dbo.consistency_tickets AS t WITH (NOLOCK) INNER JOIN
[eregulations-global].[00-dbe-global].dbo.[User] AS u WITH (NOLOCK) ON t.creatorId = u.ID
LEFT OUTER JOIN
	(SELECT TOP 100 PERCENT ChildName, ChildId, Lang FROM dbo.v_public_objective_tree WITH (NOLOCK) WHERE (ChildIsVisible =1)) AS mn
	ON t.objectiveId = mn.ChildId
LEFT OUTER JOIN
	[eregulations-consistency].[00-dbe-consistency].dbo.consistency_comments AS c WITH (NOLOCK)
		ON t.id = c.ticketId and c.[status]>0
WHERE t.pagename='objective'
GROUP BY t.id,
		t.systemId,
		t.pagename,
		t.menuid,
		mn.ChildName,
		t.objectiveId,
		t.stepId,
		t.section,
		t.priority,
		t.status,
		t.[content],
		t.dateCreated,
		t.creatorId,
		u.UserName,
		t.lastModified,
		t.modifierId,
		t.commentsCounter,
		t.commentLastStatus,
		t.id,
		mn.Lang

UNION
--homepage tickets
SELECT TOP 100 PERCENT
	t.id AS TicketId,
	t.systemId as SystemId,
	t.pagename as PageName,
	t.menuid as MenuId,
	null AS MenuCaption,
	t.objectiveId as ObjectiveId,
	t.stepId as StepId,
	null AS StepCaption,
	t.section as Section,
	t.priority as Priority,
	t.status as Status,
	t.[content] as Content,
	t.dateCreated as DateCreated,
	t.creatorId as CreatorId,
	u.UserName AS CreatorUsername,
	t.lastModified as LastModified,
	t.modifierId as ModifierId,
	t.commentLastStatus as CommentLastStatus,
	null as Regulation_Order ,
	COUNT(c.id) AS CountComments,
	'hp' as Lang
 FROM [eregulations-consistency].[00-dbe-consistency].dbo.consistency_tickets AS t WITH (NOLOCK) INNER JOIN
[eregulations-global].[00-dbe-global].dbo.[User] AS u WITH (NOLOCK) ON t.creatorId = u.ID

LEFT OUTER JOIN
	[eregulations-consistency].[00-dbe-consistency].dbo.consistency_comments AS c WITH (NOLOCK)
		ON t.id = c.ticketId and c.[status]>0
WHERE t.pagename='homepage'
GROUP BY t.id,
		t.systemId,
		t.pagename,
		t.menuid,
		t.objectiveId,
		t.stepId,
		t.section,
		t.priority,
		t.status,
		t.[content],
		t.dateCreated,
		t.creatorId,
		u.UserName,
		t.lastModified,
		t.modifierId,
		t.commentsCounter,
		t.commentLastStatus,
		t.id
GO

PRINT '  Created v_public_review with SPA definition'
GO

PRINT ''
PRINT '=== Migration 040 completed successfully ==='
PRINT 'Finished at: ' + CONVERT(varchar(30), GETDATE(), 120)
GO
