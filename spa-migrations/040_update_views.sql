-- =============================================
-- Migration: 040_update_views
-- Date: 2026-02-16
-- Description: Create new SPA views and update existing views
--              with structural changes from the new SPA schema.
--              This script includes 18 new views and 2 updated views.
-- =============================================

-- =============================================
-- View: Public_Medias
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'Public_Medias')
    DROP VIEW [dbo].[Public_Medias]
GO
CREATE VIEW [dbo].[Public_Medias]
AS
SELECT DISTINCT 
                      M.Media_Id AS MediaId, M.Lang AS Language, M.Media_Name AS Name, M.Media_FileName AS FileName, M.Media_Extention AS Extention, N'' AS Description, 
                      M.Media_Length AS Length, M.Media_PreviewImageName AS PreviewImageName
FROM         dbo.view_Public_Objectives_Current AS C WITH (NOLOCK) INNER JOIN
                      dbo.Snapshot_Object_Media AS M WITH (NOLOCK) ON C.RegistryId = M.Registry_Id AND C.ObjectiveId = M.Objective_Id AND C.Lang = M.Lang
GO

-- =============================================
-- View: view_Public_Menu_Mono
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_Public_Menu_Mono')
    DROP VIEW [dbo].[view_Public_Menu_Mono]
GO
CREATE VIEW [dbo].[view_Public_Menu_Mono]
AS
SELECT     TOP 100 PERCENT Name, Id, [Level], curSort, RegulationID, MappingType, Parent_Id, Visible, Lang
FROM         (SELECT     TOP 100 PERCENT Name, Id, [Level], curSort, RegulationID, MappingType, Parent_Id, Visible, Lang
                       FROM          dbo.view_sub_Public_Menu_Level1
                       UNION
                       SELECT     TOP 100 PERCENT Name, Id, [Level], curSort, RegulationID, MappingType, Parent_Id, Visible, Lang
                       FROM         dbo.view_sub_Public_Menu_Level2
                       UNION
                       SELECT     TOP 100 PERCENT Name, Id, [Level], curSort, RegulationId, MappingType, Parent_Id, Visible, Lang
                       FROM         dbo.view_sub_Public_Menu_Level3
                       UNION
                       SELECT     TOP 100 PERCENT Name, Id, [Level], curSort, RegulationId, MappingType, Parent_Id, Visible, Lang
                       FROM         dbo.view_sub_Public_Menu_Level4
                       UNION
                       SELECT     TOP 100 PERCENT Name, Id, [Level], curSort, RegulationId, MappingType, Parent_Id, Visible, Lang
                       FROM         dbo.view_sub_Public_Menu_Level5) AS TreeView
ORDER BY curSort
GO

-- =============================================
-- View: view_Public_Objectives_Current
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_Public_Objectives_Current')
    DROP VIEW [dbo].[view_Public_Objectives_Current]
GO
CREATE VIEW [dbo].[view_Public_Objectives_Current]
AS
SELECT     R.Id AS RegistryId, O.Id AS ObjectiveId, O.Lang, O.Name, R.SnapshotVersion AS Version, R.SnapshotDate AS Date
FROM         dbo.Snapshot_Registry AS R WITH (NOLOCK) INNER JOIN
                      dbo.Snapshot_Objective AS O WITH (NOLOCK) ON R.Objective_id = O.Id AND R.Id = O.Registry_Id
WHERE     (R.IsCurrent = 1)
GO

-- =============================================
-- View: view_Public_Regulations_Blocks
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_Public_Regulations_Blocks')
    DROP VIEW [dbo].[view_Public_Regulations_Blocks]
GO
CREATE VIEW [dbo].[view_Public_Regulations_Blocks]
AS
SELECT     TOP (100) PERCENT O.ObjectiveId, O.Lang AS Regulation_Lang, O.Name AS Objective_Name, B.Name AS Regulation_Name, 0 AS Parallele, 0 AS Alternative, 
                      B.IsOptional, 0 AS IsOnline, 4 AS Regulation_TypeID, 10000 + B.Id AS Regulation_Id, - 1 AS regulation_ParentID, B.[Order] AS regulation_Order, 
                      0 AS regulation_ParentOrder, (B.[Order] + 1) * 1000 AS regulationIndexOrder, 0 AS LocalCounter, O.RegistryId, B.Id AS BlockId
FROM         dbo.Snapshot_Block AS B WITH (NOLOCK) INNER JOIN
                      dbo.view_Public_Objectives_Current AS O WITH (NOLOCK) ON B.Registry_Id = O.RegistryId AND B.Objective_Id = O.ObjectiveId AND B.Lang = O.Lang
GO

-- =============================================
-- View: view_Public_Treeview_For_Summary
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_Public_Treeview_For_Summary')
    DROP VIEW [dbo].[view_Public_Treeview_For_Summary]
GO
CREATE VIEW [dbo].[view_Public_Treeview_For_Summary]
AS
SELECT     TOP 100 PERCENT ObjectiveID, Regulation_Lang, Regulation_Name, IsOptional, regulation_Id
FROM         dbo.Public_Treeview WITH (NOLOCK)
WHERE     (IsOptional = 0)
GO

-- =============================================
-- View: view_sub_Public_Menu_Level1
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_sub_Public_Menu_Level1')
    DROP VIEW [dbo].[view_sub_Public_Menu_Level1]
GO
CREATE VIEW [dbo].[view_sub_Public_Menu_Level1]
AS
SELECT     TOP (100) PERCENT menu.Name, menu.Id, 1 AS [Level], dbo.fn_completeNumber(hier.[Order], 6) + N'/' AS curSort, CASE WHEN (menu.MappingType = N'objective') 
                      THEN menu.Objective_Id WHEN (menu.MappingType = N'block') THEN menu.Block_Id ELSE NULL END AS RegulationID, menu.MappingType, hier.Parent_Id, 
                      vis.Visible, vis.Lang, menu.ExplanatoryText, menu.WebPageKeywords, menu.WebPageDescription
FROM         dbo.Admin_Menu AS menu WITH (NOLOCK) INNER JOIN
                      dbo.Admin_MenuHierarchicalData AS hier WITH (NOLOCK) ON menu.Id = hier.Child_Id INNER JOIN
                      dbo.Admin_MenuPerLangVisibility AS vis WITH (NOLOCK) ON hier.Child_Id = vis.Menu_Id
WHERE     (hier.Parent_Id IS NULL) AND (vis.Visible = 1)
ORDER BY hier.[Order]
GO

-- =============================================
-- View: view_sub_Public_Menu_Level2
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_sub_Public_Menu_Level2')
    DROP VIEW [dbo].[view_sub_Public_Menu_Level2]
GO
CREATE VIEW [dbo].[view_sub_Public_Menu_Level2]
AS
SELECT     TOP (100) PERCENT menu.Name, menu.Id, 2 AS [Level], pLevel.curSort + dbo.fn_completeNumber(hier.[Order], 6) + N'/' AS curSort, 
                      CASE WHEN (menu.MappingType = N'objective') THEN menu.Objective_Id WHEN (menu.MappingType = N'block') THEN menu.Block_Id ELSE NULL 
                      END AS RegulationID, menu.MappingType, hier.Parent_Id, vis.Visible, vis.Lang, menu.ExplanatoryText, menu.WebPageKeywords, menu.WebPageDescription
FROM         dbo.Admin_Menu AS menu WITH (NOLOCK) INNER JOIN
                      dbo.Admin_MenuHierarchicalData AS hier WITH (NOLOCK) ON menu.Id = hier.Child_Id INNER JOIN
                      dbo.Admin_MenuPerLangVisibility AS vis WITH (NOLOCK) ON hier.Child_Id = vis.Menu_Id INNER JOIN
                      dbo.view_sub_Public_Menu_Level1 AS pLevel WITH (NOLOCK) ON hier.Parent_Id = pLevel.Id
WHERE     (vis.Visible = 1)
ORDER BY curSort
GO

-- =============================================
-- View: view_sub_Public_Menu_Level3
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_sub_Public_Menu_Level3')
    DROP VIEW [dbo].[view_sub_Public_Menu_Level3]
GO
CREATE VIEW [dbo].[view_sub_Public_Menu_Level3]
AS
SELECT     TOP (100) PERCENT menu.Name, menu.Id, 3 AS [Level], pLevel.curSort + dbo.fn_completeNumber(hier.[Order], 6) + N'/' AS curSort, 
                      CASE WHEN (menu.MappingType = N'objective') THEN menu.Objective_Id WHEN (menu.MappingType = N'block') THEN menu.Block_Id ELSE NULL 
                      END AS RegulationId, menu.MappingType, hier.Parent_Id, vis.Visible, vis.Lang, menu.ExplanatoryText, menu.WebPageKeywords, menu.WebPageDescription
FROM         dbo.Admin_Menu AS menu WITH (NOLOCK) INNER JOIN
                      dbo.Admin_MenuHierarchicalData AS hier WITH (NOLOCK) ON menu.Id = hier.Child_Id INNER JOIN
                      dbo.Admin_MenuPerLangVisibility AS vis WITH (NOLOCK) ON hier.Child_Id = vis.Menu_Id INNER JOIN
                      dbo.view_sub_Public_Menu_Level2 AS pLevel WITH (NOLOCK) ON hier.Parent_Id = pLevel.Id
WHERE     (vis.Visible = 1)
ORDER BY curSort
GO

-- =============================================
-- View: view_sub_Public_Menu_Level4
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_sub_Public_Menu_Level4')
    DROP VIEW [dbo].[view_sub_Public_Menu_Level4]
GO
CREATE VIEW [dbo].[view_sub_Public_Menu_Level4]
AS
SELECT     TOP (100) PERCENT menu.Name, menu.Id, 4 AS [Level], pLevel.curSort + dbo.fn_completeNumber(hier.[Order], 6) + N'/' AS curSort, 
                      CASE WHEN (menu.MappingType = N'objective') THEN menu.Objective_Id WHEN (menu.MappingType = N'block') THEN menu.Block_Id ELSE NULL 
                      END AS RegulationId, menu.MappingType, hier.Parent_Id, vis.Visible, vis.Lang, menu.ExplanatoryText, menu.WebPageKeywords, menu.WebPageDescription
FROM         dbo.Admin_Menu AS menu WITH (NOLOCK) INNER JOIN
                      dbo.Admin_MenuHierarchicalData AS hier WITH (NOLOCK) ON menu.Id = hier.Child_Id INNER JOIN
                      dbo.Admin_MenuPerLangVisibility AS vis WITH (NOLOCK) ON hier.Child_Id = vis.Menu_Id INNER JOIN
                      dbo.view_sub_Public_Menu_Level3 AS pLevel WITH (NOLOCK) ON hier.Parent_Id = pLevel.Id
WHERE     (vis.Visible = 1)
ORDER BY curSort
GO

-- =============================================
-- View: view_sub_Public_Menu_Level5
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_sub_Public_Menu_Level5')
    DROP VIEW [dbo].[view_sub_Public_Menu_Level5]
GO
CREATE VIEW [dbo].[view_sub_Public_Menu_Level5]
AS
SELECT     TOP (100) PERCENT menu.Name, menu.Id, 5 AS [Level], pLevel.curSort + dbo.fn_completeNumber(hier.[Order], 6) + N'/' AS curSort, 
                      CASE WHEN (menu.MappingType = N'objective') THEN menu.Objective_Id WHEN (menu.MappingType = N'block') THEN menu.Block_Id ELSE NULL 
                      END AS RegulationId, menu.MappingType, hier.Parent_Id, vis.Visible, vis.Lang, menu.ExplanatoryText, menu.WebPageKeywords, menu.WebPageDescription
FROM         dbo.Admin_Menu AS menu WITH (NOLOCK) INNER JOIN
                      dbo.Admin_MenuHierarchicalData AS hier WITH (NOLOCK) ON menu.Id = hier.Child_Id INNER JOIN
                      dbo.Admin_MenuPerLangVisibility AS vis WITH (NOLOCK) ON hier.Child_Id = vis.Menu_Id INNER JOIN
                      dbo.view_sub_Public_Menu_Level4 AS pLevel WITH (NOLOCK) ON hier.Parent_Id = pLevel.Id
WHERE     (vis.Visible = 1)
ORDER BY curSort
GO

-- =============================================
-- View: v_translation_item
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_translation_item')
    DROP VIEW [dbo].[v_translation_item]
GO
CREATE VIEW [dbo].[v_translation_item]
AS

SELECT s.id, s.Name, isnull(s_i18n.Name, '') as TranslationName, s_i18n.Lang as TranslationLang, TranslationGroup = 'recourse' 
FROM Admin_Step s with(nolock)
	LEFT JOIN Admin_Step_i18n s_i18n with(nolock) ON s.Id = s_i18n.Step_id 
WHERE isnull(s.[Deleted], 0) = 0
AND s.IsRecourse = 1

UNION

SELECT s.id, s.Name, isnull(s_i18n.Name, '') as TranslationName, s_i18n.Lang as TranslationLang, TranslationGroup = 'step' 
FROM Admin_Step s with(nolock)
	LEFT JOIN Admin_Step_i18n s_i18n with(nolock) ON s.Id = s_i18n.Step_id 
WHERE isnull(s.[Deleted], 0) = 0
AND s.IsRecourse = 0 

UNION

SELECT o.id, o.Name, isnull(o_i18n.Name, '') as TranslationName, o_i18n.Lang as TranslationLang, TranslationGroup = 'objective' 
FROM Admin_Objective o with(nolock)
	LEFT JOIN Admin_Objective_i18n o_i18n with(nolock) ON o.Id = o_i18n.Objective_id 
WHERE isnull(o.[Deleted], 0) = 0

UNION

SELECT b.id, b.Name, isnull(b_i18n.Name, '') as TranslationName, b_i18n.Lang as TranslationLang, TranslationGroup = 'block' 
FROM Admin_Block b with(nolock)
	LEFT JOIN Admin_Block_i18n b_i18n with(nolock) ON b.Id = b_i18n.Block_id 
WHERE isnull(b.[Deleted], 0) = 0

UNION

SELECT gr.id, gr.Name, isnull(gr_i18n.Name, '') as TranslationName, gr_i18n.Lang as TranslationLang, TranslationGroup = 'genericRequirement' 
FROM GenericRequirement gr with(nolock)
	LEFT JOIN GenericRequirement_i18n gr_i18n with(nolock) ON gr.Id = gr_i18n.GenericRequirement_id 
WHERE isnull(gr.[Deleted], 0) = 0

UNION

SELECT l.id, l.Name, isnull(l_i18n.Name, '') as TranslationName, l_i18n.Lang as TranslationLang, TranslationGroup = 'law' 
FROM Law l with(nolock)
	LEFT JOIN Law_i18n l_i18n with(nolock) ON l.Id = l_i18n.Law_id 
WHERE isnull(l.[Deleted], 0) = 0

UNION

SELECT eic.id, eic.Name, isnull(eic_i18n.Name, '') as TranslationName, eic_i18n.Lang as TranslationLang, TranslationGroup = 'entityInCharge' 
FROM EntityInCharge eic with(nolock)
	LEFT JOIN EntityInCharge_i18n eic_i18n with(nolock) ON eic.Id = eic_i18n.EntityInCharge_id 
WHERE isnull(eic.[Deleted], 0) = 0
UNION

SELECT pic.id, pic.Name, isnull(pic_i18n.Name, '') as TranslationName, pic_i18n.Lang as TranslationLang, TranslationGroup = 'personInCharge' 
FROM PersonInCharge pic with(nolock)
	LEFT JOIN PersonInCharge_i18n pic_i18n with(nolock) ON pic.Id = pic_i18n.PersonInCharge_id 
WHERE isnull(pic.[Deleted], 0) = 0
UNION

SELECT uic.id, uic.Name, isnull(uic_i18n.Name, '') as TranslationName, uic_i18n.Lang as TranslationLang, TranslationGroup = 'unitInCharge' 
FROM UnitInCharge uic with(nolock)
	LEFT JOIN UnitInCharge_i18n uic_i18n with(nolock) ON uic.Id = uic_i18n.UnitInCharge_id 
WHERE isnull(uic.[Deleted], 0) = 0
GO

-- =============================================
-- View: Transfert
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'Transfert')
    DROP VIEW [dbo].[Transfert]
GO
CREATE VIEW [dbo].[Transfert]
AS
SELECT     TOP 100 PERCENT dbo.Community_Regulation.regulation_ID, dbo.Community_Regulation.regulation_Name, dbo.Community_Process.Process_Name, 
                      dbo.Community_Process.Process_ProcessTypeID, dbo.Community_Process.Process_DeletedDate, dbo.Community_Regulation.regulation_Context, 
                      dbo.Community_Process.Process_Context, dbo.Community_Regulation.regulation_DepartmentAdministrative, 
                      dbo.Community_Process.Process_DepartmentAdministrative, dbo.Community_Regulation.regulation_Department, 
                      dbo.Community_Process.Process_Department, dbo.Community_Regulation.regulation_DepartmentImage, 
                      dbo.Community_Process.Process_DepartmentImg, dbo.Community_Regulation.regulation_PersonInCharge, 
                      dbo.Community_Process.Process_PersInCharge, dbo.Community_Regulation.regulation_PersonInChargeImage, 
                      dbo.Community_Process.Process_PersInChargeImg, dbo.Community_Regulation.regulation_Phone, dbo.Community_Process.Process_Phone, 
                      dbo.Community_Regulation.regulation_Mail, dbo.Community_Process.Process_Mail, dbo.Community_Regulation.regulation_AuthorityDecision, 
                      dbo.Community_Process.Process_AuthorityDecision, dbo.Community_Regulation.regulation_Schedule, dbo.Community_Process.Process_Schedule, 
                      dbo.Community_Regulation.regulation_LegalSource, dbo.Community_Process.Process_LegalSource, 
                      dbo.Community_Regulation.regulation_RequestFormat, dbo.Community_Process.Process_RequestFormat, 
                      dbo.Community_Regulation.regulation_Requirement, dbo.Community_Process.Process_Requirement, 
                      dbo.Community_Regulation.regulation_TimeDescription, dbo.Community_Process.Process_TimeDescription, 
                      dbo.Community_Regulation.regulation_TimeMin, dbo.Community_Process.Process_TimeMin, dbo.Community_Regulation.regulation_TimeMax, 
                      dbo.Community_Process.Process_TimeMax, dbo.Community_Regulation.regulation_AdministrativeEstimationMin, 
                      dbo.Community_Process.Process_AdministrativeEstimationMin, dbo.Community_Regulation.regulation_AdministrativeEstimationMax, 
                      dbo.Community_Process.Process_AdministrativeEstimationMax, dbo.Community_Regulation.regulation_FixedCosts, 
                      dbo.Community_Process.Process_FixedCosts, dbo.Community_Regulation.regulation_AdditionalCosts, 
                      dbo.Community_Process.Process_AdditionalCosts, dbo.Community_Regulation.regulation_NameAttach, 
                      dbo.Community_Process.Process_NameAttach, dbo.Community_Regulation.regulation_DepartmentAdministrativeAttach, 
                      dbo.Community_Process.Process_DepartmentAdministrativeAttach, dbo.Community_Regulation.regulation_LegalSourceAttach, 
                      dbo.Community_Process.Process_LegalSourceAttach, dbo.Community_Regulation.regulation_RequirementAttach, 
                      dbo.Community_Process.Process_RequirementAttach, dbo.Community_Regulation.regulation_RequestFormatAttach, 
                      dbo.Community_Process.Process_RequestFormatAttach, dbo.Community_Regulation.regulation_TimeDescriptionAttach, 
                      dbo.Community_Process.Process_TimeDescriptionAttach, dbo.Community_Regulation.regulation_AdditionalCostsAttach, 
                      dbo.Community_Process.Process_AdditionalCostsAttach, dbo.Community_Regulation.regulation_CertifiedID, 
                      dbo.Community_Process.Process_CertifiedID, dbo.Community_Regulation.regulation_PublishedID, dbo.Community_Process.Process_PublishedID, 
                      dbo.Community_Regulation.regulation_Activated, dbo.Community_Process.process_lang
FROM         dbo.Community_Regulation INNER JOIN
                      dbo.Community_Process ON dbo.Community_Regulation.regulation_Name = dbo.Community_Process.Process_Name AND 
                      dbo.Community_Regulation.regulation_Lang = dbo.Community_Process.process_lang
WHERE     (dbo.Community_Process.Process_ProcessTypeID = N'2') AND (dbo.Community_Process.Process_DeletedDate IS NULL) AND 
                      (dbo.Community_Regulation.regulation_Activated = 1) AND (dbo.Community_Process.process_lang = 'uk')
ORDER BY dbo.Community_Regulation.regulation_ID
GO

-- =============================================
-- View: VIEW_step_dbl
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW_step_dbl')
    DROP VIEW [dbo].[VIEW_step_dbl]
GO
create VIEW [dbo].[VIEW_step_dbl]
AS
SELECT     TOP 100 PERCENT *
FROM         dbo.Community_Regulation
WHERE     (regulation_ID <> 0) AND (regulation_ID <> - 1) AND (regulation_ID IN
                          (SELECT     regulation_id
                            FROM          view2
                            WHERE      nb > 1))
ORDER BY regulation_ID
GO

-- =============================================
-- View: VIEW2
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW2')
    DROP VIEW [dbo].[VIEW2]
GO
CREATE VIEW [dbo].[VIEW2]
AS
SELECT     COUNT(regulation_ID) AS nb, regulation_ID, regulation_Version
FROM         dbo.Community_Regulation
GROUP BY regulation_Version, regulation_ID
GO

-- =============================================
-- View: VIEW3
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW3')
    DROP VIEW [dbo].[VIEW3]
GO
create VIEW [dbo].[VIEW3]
AS
SELECT     *
FROM         dbo.VIEW2
WHERE     (nb > 1)
GO

-- =============================================
-- View: VIEW4
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW4')
    DROP VIEW [dbo].[VIEW4]
GO
CREATE VIEW [dbo].[VIEW4]
AS
SELECT     MIN(regulation_Status) AS status, regulation_ID
FROM         dbo.VIEW_step_dbl
GROUP BY regulation_ID
GO

-- =============================================
-- View: VIEW5
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW5')
    DROP VIEW [dbo].[VIEW5]
GO
CREATE VIEW [dbo].[VIEW5]
AS
SELECT     p1.SectionProcess_ID AS id, p1.SectionProcess_Title
FROM         dbo.Community_SectionProcess p2 INNER JOIN
                      dbo.Community_SectionProcessMaxTmp Community_SectionProcessMaxTmp_1 ON 
                      p2.SectionProcess_ID = Community_SectionProcessMaxTmp_1.SectionProcess_ID AND 
                      p2.SectionProcess_Lang = Community_SectionProcessMaxTmp_1.SectionProcess_Lang AND 
                      p2.SectionProcess_Status = Community_SectionProcessMaxTmp_1.SectionProcess_Status AND 
                      p2.SectionProcess_Version = Community_SectionProcessMaxTmp_1.SectionProcess_Version RIGHT OUTER JOIN
                      dbo.Community_SectionProcess p1 INNER JOIN
                      dbo.Community_SectionProcessMaxTmp ON p1.SectionProcess_ID = dbo.Community_SectionProcessMaxTmp.SectionProcess_ID AND 
                      p1.SectionProcess_Lang = dbo.Community_SectionProcessMaxTmp.SectionProcess_Lang AND 
                      p1.SectionProcess_Status = dbo.Community_SectionProcessMaxTmp.SectionProcess_Status AND 
                      p1.SectionProcess_Version = dbo.Community_SectionProcessMaxTmp.SectionProcess_Version ON p2.SectionProcess_ID = p1.SectionProcess_ID AND
                       p2.SectionProcess_Lang = 'uk' AND p2.SectionProcess_Status = 3
WHERE     (p1.SectionProcess_DeletedDate IS NULL) AND (p1.SectionProcess_Lang = 'uk') AND (p1.SectionProcess_Status = 3)
GO

-- =============================================
-- View: VIEW6
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW6')
    DROP VIEW [dbo].[VIEW6]
GO
CREATE VIEW [dbo].[VIEW6]
AS
SELECT     TOP 100 PERCENT dbo.Community_Regulation.regulation_ID, dbo.Community_Process.Process_Context, 
                      dbo.Community_Regulation.regulation_Context, dbo.Community_Regulation.regulation_CommunityID, dbo.Community_Regulation.regulation_Status, 
                      dbo.Community_Regulation.regulation_Version, dbo.Community_Regulation.regulation_Lang, dbo.Community_Regulation.regulation_Guid
FROM         dbo.Community_Regulation INNER JOIN
                      dbo.Community_Process ON dbo.Community_Regulation.regulation_Version = dbo.Community_Process.Process_Version AND 
                      dbo.Community_Regulation.regulation_Status = dbo.Community_Process.Process_Status AND 
                      dbo.Community_Regulation.regulation_Lang = dbo.Community_Process.process_lang AND 
                      dbo.Community_Regulation.regulation_ID = dbo.Community_Process.process_id
ORDER BY dbo.Community_Regulation.regulation_ID
GO

-- =============================================
-- Updated View: v_law (structural changes from old schema)
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_law')
    DROP VIEW [dbo].[v_law]
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

-- =============================================
-- Updated View: v_public_review (structural changes from old schema)
-- =============================================
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_public_review')
    DROP VIEW [dbo].[v_public_review]
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

-- =============================================
-- Verification
-- =============================================
PRINT '========================================='
PRINT 'Migration 040_update_views - Verification'
PRINT '========================================='

-- New views (18)
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'Public_Medias')
    PRINT 'OK: Public_Medias exists'
ELSE
    PRINT 'FAIL: Public_Medias not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_Public_Menu_Mono')
    PRINT 'OK: view_Public_Menu_Mono exists'
ELSE
    PRINT 'FAIL: view_Public_Menu_Mono not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_Public_Objectives_Current')
    PRINT 'OK: view_Public_Objectives_Current exists'
ELSE
    PRINT 'FAIL: view_Public_Objectives_Current not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_Public_Regulations_Blocks')
    PRINT 'OK: view_Public_Regulations_Blocks exists'
ELSE
    PRINT 'FAIL: view_Public_Regulations_Blocks not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_Public_Treeview_For_Summary')
    PRINT 'OK: view_Public_Treeview_For_Summary exists'
ELSE
    PRINT 'FAIL: view_Public_Treeview_For_Summary not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_sub_Public_Menu_Level1')
    PRINT 'OK: view_sub_Public_Menu_Level1 exists'
ELSE
    PRINT 'FAIL: view_sub_Public_Menu_Level1 not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_sub_Public_Menu_Level2')
    PRINT 'OK: view_sub_Public_Menu_Level2 exists'
ELSE
    PRINT 'FAIL: view_sub_Public_Menu_Level2 not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_sub_Public_Menu_Level3')
    PRINT 'OK: view_sub_Public_Menu_Level3 exists'
ELSE
    PRINT 'FAIL: view_sub_Public_Menu_Level3 not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_sub_Public_Menu_Level4')
    PRINT 'OK: view_sub_Public_Menu_Level4 exists'
ELSE
    PRINT 'FAIL: view_sub_Public_Menu_Level4 not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'view_sub_Public_Menu_Level5')
    PRINT 'OK: view_sub_Public_Menu_Level5 exists'
ELSE
    PRINT 'FAIL: view_sub_Public_Menu_Level5 not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_translation_item')
    PRINT 'OK: v_translation_item exists'
ELSE
    PRINT 'FAIL: v_translation_item not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'Transfert')
    PRINT 'OK: Transfert exists'
ELSE
    PRINT 'FAIL: Transfert not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW_step_dbl')
    PRINT 'OK: VIEW_step_dbl exists'
ELSE
    PRINT 'FAIL: VIEW_step_dbl not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW2')
    PRINT 'OK: VIEW2 exists'
ELSE
    PRINT 'FAIL: VIEW2 not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW3')
    PRINT 'OK: VIEW3 exists'
ELSE
    PRINT 'FAIL: VIEW3 not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW4')
    PRINT 'OK: VIEW4 exists'
ELSE
    PRINT 'FAIL: VIEW4 not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW5')
    PRINT 'OK: VIEW5 exists'
ELSE
    PRINT 'FAIL: VIEW5 not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'VIEW6')
    PRINT 'OK: VIEW6 exists'
ELSE
    PRINT 'FAIL: VIEW6 not found'

-- Updated views (2)
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_law')
    PRINT 'OK: v_law exists (updated)'
ELSE
    PRINT 'FAIL: v_law not found'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_public_review')
    PRINT 'OK: v_public_review exists (updated)'
ELSE
    PRINT 'FAIL: v_public_review not found'

PRINT '========================================='
PRINT 'Migration 040_update_views - Complete'
PRINT '========================================='
