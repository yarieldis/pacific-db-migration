-- =============================================
-- Migration: 004_update_views
-- Description: Update views to match EF6 schema
-- Target: Old-structure database (run in SSMS)
-- =============================================

PRINT 'Starting migration 004_update_views...'
PRINT 'Target: Update/recreate views to match new schema'
PRINT ''

-- =============================================
-- V_REQUIREMENT VIEW
-- =============================================
PRINT 'Processing v_requirement view...'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_requirement')
BEGIN
    DROP VIEW [dbo].[v_requirement]
    PRINT '  Dropped existing view: v_requirement'
END
GO

CREATE VIEW [dbo].[v_requirement]
AS

-- get the generic requirement
SELECT [StepRequirementType] = 1 -- generic requirement
	    ,r.[Id]
        ,r.[Name]
        ,r.[Type] as [RequirementType]
        ,r.[OwnershipStatus]
	    ,r.[CreatedDate]
        ,r.[CreatedUser]
        ,r.[ModifiedDate]
        ,r.[ModifiedUser]
	    ,m.[Name] as [Media_Name]
	    ,m.[FileName] as [Media_FileName]
	    ,m.[Extention] as [Media_Extention]
	    ,isnull(sr.[NbSteps], 0) as [NbSteps]
	    ,NULL as [Step_Id]
	    ,NULL as [Step_Name]
	    ,NULL as [Block_Id]
	    ,NULL as [Block_Name]
	    ,NULL as [Objective_Id]
	    ,NULL as [Objective_Name]
FROM [dbo].[GenericRequirement] r with (nolock)
		LEFT JOIN
			(  SELECT obj_m.[object_id], m.*
			    FROM Admin_Object_Media obj_m with(nolock)
					INNER JOIN Media m with(nolock) on obj_m.Media_id = m.Id
			    WHERE obj_m.[Type] = 'GenericRequirement'
			    AND isnull(m.[Deleted], 0) = 0
			) m on r.id = m.[Object_Id]
		LEFT JOIN
			( 	select doc.GenericRequirement_Id, sum(NbSteps) as NbSteps
				from (SELECT sr.GenericRequirement_Id, count(*) as NbSteps
				FROM [dbo].[Admin_StepRequirement] sr with(nolock)
						INNER JOIN [dbo].[Admin_Step] s with(nolock) on sr.Step_ID = s.Id

				WHERE sr.GenericRequirement_Id IS NOT NULL
				AND isnull(s.[Deleted], 0) = 0
				GROUP BY sr.GenericRequirement_Id
				Union
				SELECT sr.Document_Id as GenericRequirement_Id, count(*) as NbSteps
				FROM [dbo].[Admin_StepResult] sr with(nolock)
						INNER JOIN [dbo].[Admin_Step] s with(nolock) on sr.Step_ID = s.Id

				WHERE sr.Document_Id IS NOT NULL
				AND isnull(s.[Deleted], 0) = 0
				GROUP BY sr.Document_Id) as doc
				group by doc.GenericRequirement_Id
			) sr on r.id = sr.GenericRequirement_Id
WHERE isnull(r.[Deleted], 0) = 0
GO

PRINT '  Created view: v_requirement'
GO

-- =============================================
-- V_GENERICREQUIREMENT VIEW
-- =============================================
PRINT ''
PRINT 'Processing v_genericrequirement view...'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_genericrequirement')
BEGIN
    DROP VIEW [dbo].[v_genericrequirement]
    PRINT '  Dropped existing view: v_genericrequirement'
END
GO

CREATE VIEW [dbo].[v_genericrequirement]
AS

SELECT r.[Id]
            ,r.[Name]
            ,r.[Description]
            ,r.[Type]
            ,r.[CreatedDate]
            ,r.[CreatedUser]
            ,r.[ModifiedDate]
            ,r.[ModifiedUser]
            ,r.[OwnershipStatus]
	    ,m.[Name] as [Media_Name]
	    ,m.[FileName] as [Media_FileName]
	    ,m.[Extention] as [Media_Extention]
	    ,isnull(sr.[NbSteps], 0) as [NbSteps]
            ,r.[IsVisibleInPublicDirectory]
FROM [dbo].[GenericRequirement] r with (nolock)
		LEFT JOIN
			(  SELECT obj_m.[object_id], m.*
			    FROM Admin_Object_Media obj_m with(nolock)
					INNER JOIN Media m with(nolock) on obj_m.Media_id = m.Id
			    WHERE obj_m.[Type] = 'GenericRequirement'
			    AND isnull(m.[Deleted], 0) = 0
			) m on r.id = m.[Object_Id]
		LEFT JOIN
			( 	select doc.GenericRequirement_Id, sum(NbSteps) as NbSteps
				from (SELECT sr.GenericRequirement_Id, count(*) as NbSteps
				FROM [dbo].[Admin_StepRequirement] sr with(nolock)
						INNER JOIN [dbo].[Admin_Step] s with(nolock) on sr.Step_ID = s.Id

				WHERE sr.GenericRequirement_Id IS NOT NULL
				AND isnull(s.[Deleted], 0) = 0
				GROUP BY sr.GenericRequirement_Id
				Union
				SELECT sr.Document_Id as GenericRequirement_Id, count(*) as NbSteps
				FROM [dbo].[Admin_StepResult] sr with(nolock)
						INNER JOIN [dbo].[Admin_Step] s with(nolock) on sr.Step_ID = s.Id

				WHERE sr.Document_Id IS NOT NULL
				AND isnull(s.[Deleted], 0) = 0
				GROUP BY sr.Document_Id) as doc
				group by doc.GenericRequirement_Id
			) sr on r.id = sr.GenericRequirement_Id
WHERE isnull(r.[Deleted], 0) = 0
GO

PRINT '  Created view: v_genericrequirement'
GO

-- =============================================
-- V_ENTITYINCHARGE VIEW
-- =============================================
PRINT ''
PRINT 'Processing v_entityInCharge view...'

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'v_entityInCharge')
BEGIN
    DROP VIEW [dbo].[v_entityInCharge]
    PRINT '  Dropped existing view: v_entityInCharge'
END
GO

CREATE VIEW [dbo].[v_entityInCharge]
AS

-- get the entity in charge
SELECT eic.[Id]
            ,eic.[Name]
            ,eic.[OwnershipStatus]
	    ,eic.[CreatedDate]
            ,eic.[CreatedUser]
            ,eic.[ModifiedDate]
            ,eic.[ModifiedUser]
	    ,eic.[Image]
	    ,eic.[IsVisibleInPublicDirectory]
	    ,isnull(seic.[NbSteps], 0) + isnull(reic.[NbSteps], 0) as [NbSteps]
FROM [dbo].[EntityInCharge] eic with (nolock)
		LEFT JOIN
			( 	SELECT s.EntityInCharge_Id, count(*) as NbSteps
				FROM [dbo].[Admin_Step] s with(nolock)
				WHERE s.EntityInCharge_Id IS NOT NULL
				AND isnull(s.[Deleted], 0) = 0
				GROUP BY s.EntityInCharge_Id
			) seic on eic.id = seic.EntityInCharge_Id
		LEFT JOIN 	( 	SELECT s.Recourse_EntityInCharge_Id, count(*) as NbSteps
				FROM [dbo].[Admin_Step] s with(nolock)
				WHERE s.Recourse_EntityInCharge_Id IS NOT NULL
				AND isnull(s.[Deleted], 0) = 0
				GROUP BY s.Recourse_EntityInCharge_Id
			) reic on eic.id = reic.Recourse_EntityInCharge_Id
WHERE isnull(eic.[Deleted], 0) = 0

GO

PRINT '  Created view: v_entityInCharge'
GO

PRINT ''
PRINT '============================================='
PRINT 'Migration 004_update_views completed!'
PRINT '============================================='
GO
