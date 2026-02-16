-- =============================================
-- Migration: 050_update_stored_procedures
-- Date: 2026-02-16
-- Description: Update 39 stored procedures to match SPA schema definitions.
--   Category 1: 16 dynamic search procedures (varchar -> nvarchar)
--   Category 2: 5 translation search procedures (varchar -> nvarchar + NULL i18n fallback)
--   Category 3: 4 feedback procedures (add IsVisibleToGuest filter)
--   Category 4: 3 published procedures (SystemLanguage reformatting)
--   Category 5: 2 column-aware procedures (new column support)
--   Category 6: 9 structurally changed procedures
-- =============================================

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_auditRecord_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_auditRecord_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_auditRecord_dynamic_search]
GO
CREATE procedure [dbo].[sp_auditRecord_dynamic_search]
(
	@noOfRows			int,
	@lastIdProcessed	int,
	@whereclause		nvarchar(4000),
	@orderclause		nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strTable = ' v_auditRecord'

IF (@noOfRows is not null)
	set @strFields = ' top '+Convert(nvarchar, @noOfRows)+' * ' 
ELSE 
	set @strFields = ' * '

IF ( @lastIdProcessed is not null)
	SET @strFilterCriteria = ' WHERE id < ' + Convert(nvarchar, @lastIdProcessed)
ELSE 
	SET  @strFilterCriteria = ''

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	IF(@lastIdProcessed is not null)
		SET  @strFilterCriteria = @strFilterCriteria+ ' AND '+ @whereclause +' '
	ELSE 
		SET  @strFilterCriteria = ' WHERE '+ @whereclause+' '
ELSE 
    SET  @strFilterCriteria = @strFilterCriteria+ ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY Id desc, ' + @orderclause
ELSE
      SET  @strSortCriteria = 'ORDER BY Id desc'


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_entityincharge_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_entityincharge_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_entityincharge_dynamic_search]
GO
CREATE procedure [dbo].[sp_entityincharge_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_entityInCharge'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_genericrequirement_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_genericrequirement_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_genericrequirement_dynamic_search]
GO
CREATE procedure [dbo].[sp_genericrequirement_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_genericrequirement'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_law_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_law_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_law_dynamic_search]
GO
CREATE procedure [dbo].[sp_law_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_law'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_media_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_media_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_media_dynamic_search]
GO
CREATE procedure [dbo].[sp_media_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_media'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_menu_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_menu_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_menu_dynamic_search]
GO
CREATE procedure [dbo].[sp_menu_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_menu'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_partner_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_partner_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_partner_dynamic_search]
GO
CREATE procedure [dbo].[sp_partner_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_partner'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_personincharge_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_personincharge_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_personincharge_dynamic_search]
GO
CREATE procedure [dbo].[sp_personincharge_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_personInCharge'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_recourse_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_recourse_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_recourse_dynamic_search]
GO
CREATE procedure [dbo].[sp_recourse_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_recourse'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_regulation_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_regulation_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_regulation_dynamic_search]
GO
CREATE procedure [dbo].[sp_regulation_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_regulation'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_requirement_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_requirement_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_requirement_dynamic_search]
GO
CREATE procedure [dbo].[sp_requirement_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_requirement'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_translation_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_translation_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_translation_dynamic_search]
GO
CREATE procedure [dbo].[sp_translation_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_translation_item'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_translation_menu_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_translation_menu_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_translation_menu_dynamic_search]
GO
CREATE procedure [dbo].[sp_translation_menu_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_translation_menu'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_unitincharge_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_unitincharge_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_unitincharge_dynamic_search]
GO
CREATE procedure [dbo].[sp_unitincharge_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_unitInCharge'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_xmlSerializedItem_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_xmlSerializedItem_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_xmlSerializedItem_dynamic_search]
GO
CREATE procedure [dbo].[sp_xmlSerializedItem_dynamic_search]
(
	@whereclause nvarchar(4000),
	@orderclause nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

set @strFields = ' *' 
set @strTable = ' v_xmlSerializedItem'

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	SET  @strFilterCriteria = ' WHERE ' + @whereclause
ELSE
      SET  @strFilterCriteria = ''

-- ADD OPTIONAL ORDER BY CLAUSE
IF ( @orderclause is not null AND len(ltrim(@orderclause)) > 0 ) 
	SET  @strSortCriteria = ' ORDER BY ' + @orderclause
ELSE
      SET  @strSortCriteria = ''


-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + ' with (nolock) ' + @strFilterCriteria + @strSortCriteria)

end
GO

-- =============================================
-- Category 1: Dynamic search (varchar -> nvarchar)
-- Procedure: sp_public_reviews_dynamic_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_public_reviews_dynamic_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_public_reviews_dynamic_search]
GO
CREATE procedure [dbo].[sp_public_reviews_dynamic_search]
(
	@systemId			int,
	@lang				nvarchar(10),
	@whereclause		nvarchar(4000)='',
	@noOfRows			int,
	@lastIdProcessed	int
)
as
begin

SET NOCOUNT OFF

declare @strFields nvarchar(4000)
declare @strTable nvarchar(4000)
declare @strFilterCriteria nvarchar(4000)
declare @strSortCriteria nvarchar(4000)

	
set @strTable = ' v_public_review'


IF (@noOfRows is not null)
	set @strFields = ' top '+Convert(nvarchar, @noOfRows)+' * ' 
ELSE 
	set @strFields = ' * '


IF ( @lastIdProcessed is not null)
	SET @strFilterCriteria = ' WHERE ticketId < ' + Convert(nvarchar, @lastIdProcessed)
ELSE 
	SET  @strFilterCriteria = ''

-- ADD OPTIONAL WHERE CLAUSE
IF ( @whereclause is not null AND len(ltrim(@whereclause)) > 0 ) 
	IF (len(ltrim(@strFilterCriteria)) > 0 )
		SET  @strFilterCriteria =@strFilterCriteria +' AND '+ @whereclause+' '
	ELSE
		SET  @strFilterCriteria = ' WHERE '+ @whereclause+' '
ELSE 
    SET  @strFilterCriteria = @strFilterCriteria+ ''


SET  @strFilterCriteria = @strFilterCriteria+ ''

--ADD SYSTEM ID AND LANG FILTER
IF ( @strFilterCriteria is not null AND len(ltrim(@strFilterCriteria)) > 0 )
	 SET  @strFilterCriteria = @strFilterCriteria+ ' AND '+ ' SystemId= '+Convert(nvarchar, @systemId)  +' AND (lang =''hp'' or lang=''' + @lang +''' )'
ELSE
	SET  @strFilterCriteria =  ' WHERE SystemId= '+Convert(nvarchar, @systemId)  +' AND (lang =''hp'' or lang=''' + @lang +''' )'
	
-- ORDER BY CLAUSE
set @strSortCriteria=' ORDER BY ticketId desc'

print ('SELECT' + @strFields + ' FROM' + @strTable + @strFilterCriteria  + @strSortCriteria)

-- EXECUTE BUILDED QUERY
execute ('SELECT' + @strFields + ' FROM' + @strTable + @strFilterCriteria  + @strSortCriteria)

end
GO

-- =============================================
-- Category 2: Translation search (varchar -> nvarchar + NULL i18n fallback)
-- Procedure: sp_cost_variables_translation_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_cost_variables_translation_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_cost_variables_translation_search]
GO
CREATE procedure [dbo].[sp_cost_variables_translation_search]
(
	@translationLang nvarchar(5),
	@searchLang nvarchar(5),
	@search nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @searchTerm nvarchar(1000)

--make search term to lowercase
set @searchTerm =lower(@search)

SELECT 
	o.Id, 
	o.Label,
	ISNULL(i.Label, o.Label) as TranslatedLabel
FROM [dbo].[CostVariable] o
LEFT JOIN  [dbo].[CostVariable_i18n] i
	ON i.costVariable_Id=o.Id AND i.lang=@translationLang
WHERE o.Deleted=0
AND (( @searchLang is null and  LOWER(o.Label) LIKE N'%'+@searchTerm+ '%') or (i.Label is null and LOWER(o.Label) LIKE N'%'+@searchTerm+ '%') or LOWER(i.Label) like  N'%'+@searchTerm+ '%')
ORDER BY o.Label, TranslatedLabel


end
GO

-- =============================================
-- Category 2: Translation search (varchar -> nvarchar + NULL i18n fallback)
-- Procedure: sp_filter_translation_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_filter_translation_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_filter_translation_search]
GO
CREATE procedure [dbo].[sp_filter_translation_search]
(
	@translationLang nvarchar(5),
	@searchLang nvarchar(5),
	@search nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @searchTerm nvarchar(1000)

--make search term to lowercase
set @searchTerm =lower(@search)

SELECT 
	o.Id, 
	o.Name,
	ISNULL(i.Name, o.Name) as TranslatedName
FROM [dbo].[Filter] o
LEFT JOIN  [dbo].[Filter_i18n] i
	ON i.Filter_Id = o.Id AND i.Lang=@translationLang
WHERE o.Deleted=0
AND (( @searchLang is null and  LOWER(o.Name) LIKE N'%'+@searchTerm+ '%') or (i.Name is null and LOWER(o.Name) LIKE N'%'+@searchTerm+ '%') or LOWER(i.Name) like  N'%'+@searchTerm+ '%')
ORDER BY o.Name, TranslatedName


end
GO

-- =============================================
-- Category 2: Translation search (varchar -> nvarchar + NULL i18n fallback)
-- Procedure: sp_filteroption_translation_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_filteroption_translation_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_filteroption_translation_search]
GO
CREATE procedure [dbo].[sp_filteroption_translation_search]
(
	@translationLang nvarchar(5),
	@searchLang nvarchar(5),
	@search nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @searchTerm nvarchar(1000)

--make search term to lowercase
set @searchTerm =lower(@search)

SELECT 
	o.Id, 
	o.Name,
	ISNULL(i.Name, o.Name) as TranslatedName
FROM [dbo].[FilterOption] o
LEFT JOIN  [dbo].[FilterOption_i18n] i
	ON i.FilterOption_Id = o.Id AND i.Lang=@translationLang
WHERE o.Deleted=0
AND (( @searchLang is null and  LOWER(o.Name) LIKE N'%'+@searchTerm+ '%') or (i.Name is null and LOWER(o.Name) LIKE N'%'+@searchTerm+ '%') or LOWER(i.Name) like  N'%'+@searchTerm+ '%')
ORDER BY o.Name, TranslatedName


end
GO

-- =============================================
-- Category 2: Translation search (varchar -> nvarchar + NULL i18n fallback)
-- Procedure: sp_options_translation_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_options_translation_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_options_translation_search]
GO
CREATE procedure [dbo].[sp_options_translation_search]
(
	@translationLang nvarchar(5),
	@searchLang nvarchar(5),
	@search nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @searchTerm nvarchar(1000)

--make search term to lowercase
set @searchTerm =lower(@search)

SELECT 
	o.Id, 
	o.Type,
	o.Text,
	ISNULL(i.Text, o.Text) as TranslatedText
FROM [dbo].[Option] o
LEFT JOIN  [dbo].[Option_i18n] i
	ON i.optionId=o.Id AND i.lang=@translationLang
WHERE o.Deleted=0
AND o.Selected=1
AND ((@searchLang is null and LOWER(o.Text) LIKE N'%'+@searchTerm+ '%') or (i.Text is null and LOWER(o.Text) LIKE N'%'+@searchTerm+ '%') or LOWER(i.Text) like  N'%'+@searchTerm+ '%')
ORDER BY o.Text, TranslatedText


end
GO

-- =============================================
-- Category 2: Translation search (varchar -> nvarchar + NULL i18n fallback)
-- Procedure: sp_site_menu_translation_search
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_site_menu_translation_search' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_site_menu_translation_search]
GO
CREATE procedure [dbo].[sp_site_menu_translation_search]
(
	@translationLang nvarchar(5),
	@searchLang nvarchar(5),
	@search nvarchar(1000)
)
as
begin

SET NOCOUNT ON;

declare @searchTerm nvarchar(1000)

--make search term to lowercase
set @searchTerm =lower(@search)

SELECT 
	o.Id, 
	o.Name,
	ISNULL(i.Name, o.name) as TranslatedName
FROM [dbo].[SiteMenu] o
LEFT JOIN  [dbo].[SiteMenu_i18n] i
	ON i.Menu_Id=o.Id AND i.lang=@translationLang
	WHERE o.IsVisible=1
AND (( @searchLang is null and  LOWER(o.Name) LIKE N'%'+@searchTerm+ '%') or (i.Name is null and LOWER(o.Name) LIKE N'%'+@searchTerm+ '%') or LOWER(i.Name) like  N'%'+@searchTerm+ '%')
ORDER BY o.Name, TranslatedName


end
GO

-- =============================================
-- Category 3: Feedback (IsVisibleToGuest filter)
-- Procedure: sp_feedback_menu_get_children
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_feedback_menu_get_children' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_feedback_menu_get_children]
GO
CREATE PROCEDURE [dbo].[sp_feedback_menu_get_children]
(
	@menuId int,
	@lang char(2)
)
AS
BEGIN
	
	SELECT m.Id, isnull(m_i18n.[Name], m.[Name]) as [Name]
	FROM Admin_Menu m with(nolock)
		LEFT JOIN (SELECT * FROM Admin_Menu_i18n with(nolock) WHERE [Lang] = @lang) m_i18n ON m.[Id] = m_i18n.[Parent_Id]
		JOIN Admin_MenuHierarchicalData mHier with(nolock) ON m.[Id] = mHier.[Child_Id]
		JOIN Admin_MenuPerLangVisibility mLangV with(nolock) on m.[Id] = mLangV.[Menu_Id]
	WHERE isnull(m.[Deleted], 0) = 0 
	AND m.IsVisibleToGuest = 1
	AND mHier.[Parent_Id] = @menuId	
	AND mLangV.[Lang] = @lang
	AND mLangV.[Visible] = 1 
	ORDER BY mHier.[Order]
END
GO

-- =============================================
-- Category 3: Feedback (IsVisibleToGuest filter)
-- Procedure: sp_feedback_menu_get_first_level
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_feedback_menu_get_first_level' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_feedback_menu_get_first_level]
GO
CREATE PROCEDURE [dbo].[sp_feedback_menu_get_first_level]
(
	@lang char(2)
)
AS
BEGIN
	
	SELECT m.Id, isnull(m_i18n.[Name], m.[Name]) as [Name]
	FROM Admin_Menu m with(nolock)
		LEFT JOIN (SELECT * FROM Admin_Menu_i18n with(nolock) WHERE [Lang] = @lang) m_i18n ON m.[Id] = m_i18n.[Parent_Id]
		JOIN Admin_MenuHierarchicalData mHier with(nolock) ON m.[Id] = mHier.[Child_Id]
		JOIN Admin_MenuPerLangVisibility mLangV with(nolock) on m.[Id] = mLangV.[Menu_Id]
	WHERE isnull(m.[Deleted], 0) = 0 
	AND m.IsVisibleToGuest = 1
	AND mHier.[Parent_Id] IS NULL	
	AND mLangV.[Lang] = @lang
	AND mLangV.[Visible] = 1 
	ORDER BY mHier.[Order]
END
GO

-- =============================================
-- Category 3: Feedback (IsVisibleToGuest filter)
-- Procedure: sp_feedback_objective_get_children
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_feedback_objective_get_children' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_feedback_objective_get_children]
GO
CREATE PROCEDURE [dbo].[sp_feedback_objective_get_children]
(
	@menuId int,
	@lang char(2)
)
AS
BEGIN
	
	SELECT m.Id, isnull(m_i18n.[Name], m.[Name]) as [Name]
	FROM Admin_Objective m with(nolock)
		LEFT JOIN (SELECT * FROM Admin_Objective_i18n with(nolock) WHERE [Lang] = @lang) m_i18n ON m.[Id] = m_i18n.[Parent_Id]
		JOIN Admin_ObjectiveHierarchicalData mHier with(nolock) ON m.[Id] = mHier.[Child_Id]
		JOIN Admin_ObjectivePerLangVisibility mLangV with(nolock) on m.[Id] = mLangV.[Objective_Id]
	WHERE isnull(m.[Deleted], 0) = 0
	AND m.IsVisibleToGuest = 1 
	AND mHier.[Parent_Id] = @menuId	
	AND mLangV.[Lang] = @lang
	AND mLangV.[Visible] = 1 
	ORDER BY mHier.[Order]
END
GO

-- =============================================
-- Category 3: Feedback (IsVisibleToGuest filter)
-- Procedure: sp_feedback_objective_get_first_level
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_feedback_objective_get_first_level' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_feedback_objective_get_first_level]
GO
CREATE PROCEDURE [dbo].[sp_feedback_objective_get_first_level]
(
	@lang char(2)
)
AS
BEGIN
	
	SELECT m.Id, isnull(m_i18n.[Name], m.[Name]) as [Name]
	FROM Admin_Objective m with(nolock)
		LEFT JOIN (SELECT * FROM Admin_Objective_i18n with(nolock) WHERE [Lang] = @lang) m_i18n ON m.[Id] = m_i18n.[Parent_Id]
		JOIN Admin_ObjectiveHierarchicalData mHier with(nolock) ON m.[Id] = mHier.[Child_Id]
		JOIN Admin_ObjectivePerLangVisibility mLangV with(nolock) on m.[Id] = mLangV.[Objective_Id]
	WHERE isnull(m.[Deleted], 0) = 0 
	AND m.IsVisibleToGuest = 1
	AND mHier.[Parent_Id] IS NULL	
	AND mLangV.[Lang] = @lang
	AND mLangV.[Visible] = 1 
	ORDER BY mHier.[Order]
END
GO

-- =============================================
-- Category 4: Published (SystemLanguage reformatting)
-- Procedure: sp_on_published_block
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_on_published_block' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_on_published_block]
GO
CREATE PROCEDURE [dbo].[sp_on_published_block]
(
	@blockId int
)
AS
BEGIN

SET NOCOUNT ON

DECLARE @langPrincipal varchar(2)
SET @langPrincipal = (SELECT TOP 1 code FROM SystemLanguage WHERE IsPrincipal = 1) 

-- get all the registry for objectives where this block exists
DECLARE @registryId int, @objectiveId int

-- get all the blocks in the snapshot tables
DECLARE blocks_cursor CURSOR FOR 
	SELECT DISTINCT sb.registry_id, sb.objective_id
	FROM dbo.Snapshot_Block sb with(nolock)
	WHERE sb.id = @blockId 
	AND sb.registry_id IN (SELECT sreg.id FROM Snapshot_Registry sreg with(nolock) WHERE sreg.IsCurrent = 1)
	AND sb.lang = @langPrincipal

OPEN blocks_cursor

FETCH NEXT FROM blocks_cursor
INTO @registryId, @objectiveId
WHILE @@FETCH_STATUS = 0
BEGIN 
	-- call the procedure for populating the public tables 
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_populate_public_data_procedure]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)  
	exec [dbo].[sp_populate_public_data_procedure] @registryId, @objectiveId


	FETCH NEXT FROM blocks_cursor
	INTO @registryId, @objectiveId
END
	
CLOSE blocks_cursor
DEALLOCATE blocks_cursor

SET NOCOUNT OFF
END
GO

-- =============================================
-- Category 4: Published (SystemLanguage reformatting)
-- Procedure: sp_on_published_step
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_on_published_step' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_on_published_step]
GO
CREATE PROCEDURE [dbo].[sp_on_published_step]
(
	@stepId int
)
AS
BEGIN

SET NOCOUNT ON

DECLARE @langPrincipal varchar(2)
SET @langPrincipal = (SELECT TOP 1 code FROM SystemLanguage WHERE IsPrincipal = 1) 

-- get all the registry for objectives where this steps exists
DECLARE @registryId int, @objectiveId int

-- get all the steps in the snapshot tables
DECLARE step_cursor CURSOR FOR 
	SELECT DISTINCT ss.registry_id, ss.objective_id
	FROM dbo.Snapshot_Step ss with(nolock)
	WHERE ss.id = @stepId AND ss.IsRecourse = 0
	AND ss.registry_id IN (SELECT sreg.id FROM Snapshot_Registry sreg with(nolock) WHERE sreg.IsCurrent = 1)
	AND ss.lang = @langPrincipal

OPEN step_cursor

FETCH NEXT FROM step_cursor
INTO @registryId, @objectiveId
WHILE @@FETCH_STATUS = 0
BEGIN 
	-- call the procedure for populating the public tables 
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_populate_public_data_procedure]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)  
	exec [dbo].[sp_populate_public_data_procedure] @registryId, @objectiveId


	FETCH NEXT FROM step_cursor
	INTO @registryId, @objectiveId
END
	
CLOSE step_cursor
DEALLOCATE step_cursor

SET NOCOUNT OFF
END
GO

-- =============================================
-- Category 4: Published (SystemLanguage reformatting)
-- Procedure: sp_on_published_recourse
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_on_published_recourse' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_on_published_recourse]
GO
CREATE PROCEDURE [dbo].[sp_on_published_recourse]
(
	@recourseId int
)
AS
BEGIN

SET NOCOUNT ON

DECLARE @langPrincipal varchar(2)
SET @langPrincipal = (SELECT TOP 1 entity_lang FROM community_lang WHERE lang_principal = 1)

-- get all the registry for objectives where this steps exists
DECLARE @registryId int, @objectiveId int

-- get all the recourses in the snapshot tables
DECLARE recourse_cursor CURSOR FOR 
	SELECT DISTINCT sr.registry_id, sr.objective_id
	FROM dbo.Snapshot_Step sr 
	WHERE sr.id = @recourseId AND sr.IsRecourse = 1
	AND sr.registry_id IN (SELECT sreg.id FROM Snapshot_Registry sreg with(nolock) WHERE sreg.IsCurrent = 1)
	AND sr.lang = @langPrincipal	

OPEN recourse_cursor

FETCH NEXT FROM recourse_cursor
INTO @registryId, @objectiveId
WHILE @@FETCH_STATUS = 0
BEGIN 
	-- call the procedure for populating the public tables 
	if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_populate_public_data_procedure]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)  
	exec [dbo].[sp_populate_public_data_procedure] @registryId, @objectiveId


	FETCH NEXT FROM recourse_cursor
	INTO @registryId, @objectiveId
END
	
CLOSE recourse_cursor
DEALLOCATE recourse_cursor

SET NOCOUNT OFF
END
GO

-- =============================================
-- Category 5: Column-aware (new column support)
-- Procedure: sp_on_updated_unitInCharge
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_on_updated_unitInCharge' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_on_updated_unitInCharge]
GO
CREATE PROCEDURE [dbo].[sp_on_updated_unitInCharge]
(
	@unitInChargeId int
)
AS
BEGIN

SET NOCOUNT ON

-- update the snapshot table
UPDATE suic
	SET 
	suic.[Name]  = isnull(uic_i18n.Name, uic.Name)
       ,suic.[Image] = uic.[Image]  
       ,suic.[ScheduleIsInherited] = uic.[ScheduleIsInherited]  	
       ,suic.[ScheduleDay1MorningStart] = uic.[ScheduleDay1MorningStart]   
       ,suic.[ScheduleDay1MorningEnd] = uic.[ScheduleDay1MorningEnd] 
       ,suic.[ScheduleDay1EveningStart] = uic.[ScheduleDay1EveningStart] 
       ,suic.[ScheduleDay1EveningEnd] = uic.[ScheduleDay1EveningEnd] 
       ,suic.[ScheduleDay1IsClosed] = uic.[ScheduleDay1IsClosed] 
       ,suic.[ScheduleDay1IsNotAvailable] = uic.[ScheduleDay1IsNotAvailable]  
       ,suic.[ScheduleDay2MorningStart] = uic.[ScheduleDay2MorningStart]  
       ,suic.[ScheduleDay2MorningEnd] = uic.[ScheduleDay2MorningEnd] 
       ,suic.[ScheduleDay2EveningStart] = uic.[ScheduleDay2EveningStart] 
       ,suic.[ScheduleDay2EveningEnd] = uic.[ScheduleDay2EveningEnd] 
       ,suic.[ScheduleDay2IsClosed] = uic.[ScheduleDay2IsClosed] 
       ,suic.[ScheduleDay2IsNotAvailable] = uic.[ScheduleDay2IsNotAvailable] 
       ,suic.[ScheduleDay3MorningStart] = uic.[ScheduleDay3MorningStart]  
       ,suic.[ScheduleDay3MorningEnd] = uic.[ScheduleDay3MorningEnd]  
       ,suic.[ScheduleDay3EveningStart] = uic.[ScheduleDay3EveningStart]  
       ,suic.[ScheduleDay3EveningEnd] = uic.[ScheduleDay3EveningEnd]  
       ,suic.[ScheduleDay3IsClosed] = uic.[ScheduleDay3IsClosed]   
       ,suic.[ScheduleDay3IsNotAvailable] = uic.[ScheduleDay3IsNotAvailable]  
       ,suic.[ScheduleDay4MorningStart] = uic.[ScheduleDay4MorningStart]  
       ,suic.[ScheduleDay4MorningEnd] = uic.[ScheduleDay4MorningEnd]  
       ,suic.[ScheduleDay4EveningStart] = uic.[ScheduleDay4EveningStart]  
       ,suic.[ScheduleDay4EveningEnd] = uic.[ScheduleDay4EveningEnd] 
       ,suic.[ScheduleDay4IsClosed] = uic.[ScheduleDay4IsClosed]  
       ,suic.[ScheduleDay4IsNotAvailable]= uic.[ScheduleDay4IsNotAvailable]   
       ,suic.[ScheduleDay5MorningStart] = uic.[ScheduleDay5MorningStart]  
       ,suic.[ScheduleDay5MorningEnd] = uic.[ScheduleDay5MorningEnd] 
       ,suic.[ScheduleDay5EveningStart] = uic.[ScheduleDay5EveningStart] 
       ,suic.[ScheduleDay5EveningEnd] = uic.[ScheduleDay5EveningEnd] 
       ,suic.[ScheduleDay5IsClosed] = uic.[ScheduleDay5IsClosed] 
       ,suic.[ScheduleDay5IsNotAvailable] = uic.[ScheduleDay5IsNotAvailable] 
       ,suic.[ScheduleDay6MorningStart] = uic.[ScheduleDay6MorningStart] 
       ,suic.[ScheduleDay6MorningEnd] = uic.[ScheduleDay6MorningEnd] 
       ,suic.[ScheduleDay6EveningStart] = uic.[ScheduleDay6EveningStart] 
       ,suic.[ScheduleDay6EveningEnd] = uic.[ScheduleDay6EveningEnd] 
       ,suic.[ScheduleDay6IsClosed] = uic.[ScheduleDay6IsClosed] 
       ,suic.[ScheduleDay6IsNotAvailable] = uic.[ScheduleDay6IsNotAvailable] 
       ,suic.[ScheduleDay7MorningStart] = uic.[ScheduleDay7MorningStart] 
       ,suic.[ScheduleDay7MorningEnd] = uic.[ScheduleDay7MorningEnd] 
       ,suic.[ScheduleDay7EveningStart] = uic.[ScheduleDay7EveningStart]  
       ,suic.[ScheduleDay7EveningEnd] = uic.[ScheduleDay7EveningEnd]  
       ,suic.[ScheduleDay7IsClosed] = uic.[ScheduleDay7IsClosed]  
       ,suic.[ScheduleDay7IsNotAvailable] = uic.[ScheduleDay7IsNotAvailable]   
       ,suic.[ScheduleComments] = ISNULL(uic_i18n.[ScheduleComments], uic.[ScheduleComments])   
       ,suic.[Website] = ISNULL(uic_i18n.[Website], uic.[Website]) 

FROM Snapshot_StepUnitInCharge suic
	INNER JOIN UnitInCharge uic on suic.Id = uic.Id
		LEFT JOIN UnitInCharge_i18n uic_i18n on uic.id = uic_i18n.Parent_Id and [suic].Lang = uic_i18n.Lang
WHERE suic.Id = @unitInChargeId
AND suic.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- update the snapshot recourse table
UPDATE ruic
	SET 
	ruic.[Name]  = isnull(uic_i18n.Name, uic.Name)
       ,ruic.[Image] = uic.[Image]  
       ,ruic.[ScheduleIsInherited] = uic.[ScheduleIsInherited]  	
       ,ruic.[ScheduleDay1MorningStart] = uic.[ScheduleDay1MorningStart]   
       ,ruic.[ScheduleDay1MorningEnd] = uic.[ScheduleDay1MorningEnd] 
       ,ruic.[ScheduleDay1EveningStart] = uic.[ScheduleDay1EveningStart] 
       ,ruic.[ScheduleDay1EveningEnd] = uic.[ScheduleDay1EveningEnd] 
       ,ruic.[ScheduleDay1IsClosed] = uic.[ScheduleDay1IsClosed] 
       ,ruic.[ScheduleDay1IsNotAvailable] = uic.[ScheduleDay1IsNotAvailable]  
       ,ruic.[ScheduleDay2MorningStart] = uic.[ScheduleDay2MorningStart]  
       ,ruic.[ScheduleDay2MorningEnd] = uic.[ScheduleDay2MorningEnd] 
       ,ruic.[ScheduleDay2EveningStart] = uic.[ScheduleDay2EveningStart] 
       ,ruic.[ScheduleDay2EveningEnd] = uic.[ScheduleDay2EveningEnd] 
       ,ruic.[ScheduleDay2IsClosed] = uic.[ScheduleDay2IsClosed] 
       ,ruic.[ScheduleDay2IsNotAvailable] = uic.[ScheduleDay2IsNotAvailable] 
       ,ruic.[ScheduleDay3MorningStart] = uic.[ScheduleDay3MorningStart]  
       ,ruic.[ScheduleDay3MorningEnd] = uic.[ScheduleDay3MorningEnd]  
       ,ruic.[ScheduleDay3EveningStart] = uic.[ScheduleDay3EveningStart]  
       ,ruic.[ScheduleDay3EveningEnd] = uic.[ScheduleDay3EveningEnd]  
       ,ruic.[ScheduleDay3IsClosed] = uic.[ScheduleDay3IsClosed]   
       ,ruic.[ScheduleDay3IsNotAvailable] = uic.[ScheduleDay3IsNotAvailable]  
       ,ruic.[ScheduleDay4MorningStart] = uic.[ScheduleDay4MorningStart]  
       ,ruic.[ScheduleDay4MorningEnd] = uic.[ScheduleDay4MorningEnd]  
       ,ruic.[ScheduleDay4EveningStart] = uic.[ScheduleDay4EveningStart]  
       ,ruic.[ScheduleDay4EveningEnd] = uic.[ScheduleDay4EveningEnd] 
       ,ruic.[ScheduleDay4IsClosed] = uic.[ScheduleDay4IsClosed]  
       ,ruic.[ScheduleDay4IsNotAvailable]= uic.[ScheduleDay4IsNotAvailable]   
       ,ruic.[ScheduleDay5MorningStart] = uic.[ScheduleDay5MorningStart]  
       ,ruic.[ScheduleDay5MorningEnd] = uic.[ScheduleDay5MorningEnd] 
       ,ruic.[ScheduleDay5EveningStart] = uic.[ScheduleDay5EveningStart] 
       ,ruic.[ScheduleDay5EveningEnd] = uic.[ScheduleDay5EveningEnd] 
       ,ruic.[ScheduleDay5IsClosed] = uic.[ScheduleDay5IsClosed] 
       ,ruic.[ScheduleDay5IsNotAvailable] = uic.[ScheduleDay5IsNotAvailable] 
       ,ruic.[ScheduleDay6MorningStart] = uic.[ScheduleDay6MorningStart] 
       ,ruic.[ScheduleDay6MorningEnd] = uic.[ScheduleDay6MorningEnd] 
       ,ruic.[ScheduleDay6EveningStart] = uic.[ScheduleDay6EveningStart] 
       ,ruic.[ScheduleDay6EveningEnd] = uic.[ScheduleDay6EveningEnd] 
       ,ruic.[ScheduleDay6IsClosed] = uic.[ScheduleDay6IsClosed] 
       ,ruic.[ScheduleDay6IsNotAvailable] = uic.[ScheduleDay6IsNotAvailable] 
       ,ruic.[ScheduleDay7MorningStart] = uic.[ScheduleDay7MorningStart] 
       ,ruic.[ScheduleDay7MorningEnd] = uic.[ScheduleDay7MorningEnd] 
       ,ruic.[ScheduleDay7EveningStart] = uic.[ScheduleDay7EveningStart]  
       ,ruic.[ScheduleDay7EveningEnd] = uic.[ScheduleDay7EveningEnd]  
       ,ruic.[ScheduleDay7IsClosed] = uic.[ScheduleDay7IsClosed]  
       ,ruic.[ScheduleDay7IsNotAvailable] = uic.[ScheduleDay7IsNotAvailable]   
       ,ruic.[ScheduleComments] = ISNULL(uic_i18n.[ScheduleComments], uic.[ScheduleComments])
       ,ruic.[Website] = ISNULL(uic_i18n.[Website], uic.[Website]) 

FROM Snapshot_StepRecourseUnitInCharge ruic
	INNER JOIN UnitInCharge uic on ruic.Id = uic.Id
		LEFT JOIN UnitInCharge_i18n uic_i18n on uic.id = uic_i18n.Parent_Id and ruic.Lang = uic_i18n.Lang
WHERE ruic.Id = @unitInChargeId
AND ruic.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)


SET NOCOUNT OFF
END
GO

-- =============================================
-- Category 5: Column-aware (new column support)
-- Procedure: sp_on_updated_media
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_on_updated_media' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_on_updated_media]
GO
CREATE PROCEDURE [dbo].[sp_on_updated_media]
(
	@mediaId int
)
AS
BEGIN

SET NOCOUNT ON

-- update the snapshot table
UPDATE som 
	SET som.Media_Id = m.Id,
		som.Media_Name = isnull(m_i18n.Name, m.Name),
		som.Media_FileName = isnull(m_i18n.FileName, m.FileName),
		som.Media_Extention = isnull(m_i18n.Extention, m.Extention),
		som.Media_Length = isnull(m_i18n.Length, m.Length),
		som.Media_PreviewImageName = isnull(m_i18n.PreviewImageName, m.PreviewImageName),
		som.Media_IsDocumentPresent = m.IsDocumentPresent
	FROM Snapshot_Object_Media som
			INNER JOIN Media m on som.[Media_Id] = m.[Id]
				LEFT JOIN Media_i18n m_i18n on m.Id = m_i18n.Media_Id AND m_i18n.Lang = som.Lang		
	WHERE som.[Media_Id] = @mediaId
	AND som.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- call the procedure for populating the public tables 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Public_Generate_ALL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)  
exec [dbo].[Public_Generate_ALL]

SET NOCOUNT OFF
END
GO

-- =============================================
-- Category 6: Major structural
-- Procedure: sp_on_updated_entityInCharge
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_on_updated_entityInCharge' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_on_updated_entityInCharge]
GO
CREATE PROCEDURE [dbo].[sp_on_updated_entityInCharge]
(
	@entityInChargeId int
)
AS
BEGIN

SET NOCOUNT ON

-- update the snapshot table
UPDATE seic
	SET 
		seic.[Name]  = isnull(eic_i18n.Name, eic.Name)
       ,seic.[Address] = ISNULL(eic_i18n.[Address], eic.[Address]) 
       ,seic.[City] = eic.[City]  
       ,seic.[PostalCode] = eic.[PostalCode] 
       ,seic.[CountryCode] = eic.[CountryCode] 
       ,seic.[Phone1] = eic.[Phone1] 
       ,seic.[Phone2] = eic.[Phone2] 
       ,seic.[Fax1] = eic.[Fax1] 
	   ,seic.[GoogleMapsURL] = eic.[GoogleMapsURL] 
       ,seic.[Fax2] = eic.[Fax2]
       ,seic.[Email1] = eic.[Email1] 
       ,seic.[Email2] = eic.[Email2] 
       ,seic.[Website1] = ISNULL(eic_i18n.[Website1], eic.[Website1])   
       ,seic.[Website2] = ISNULL(eic_i18n.[Website2], eic.[Website2]) 
       ,seic.[Image] = eic.[Image]  
       ,seic.[ScheduleDay1MorningStart] = eic.[ScheduleDay1MorningStart]   
       ,seic.[ScheduleDay1MorningEnd] = eic.[ScheduleDay1MorningEnd] 
       ,seic.[ScheduleDay1EveningStart] = eic.[ScheduleDay1EveningStart] 
       ,seic.[ScheduleDay1EveningEnd] = eic.[ScheduleDay1EveningEnd] 
       ,seic.[ScheduleDay1IsClosed] = eic.[ScheduleDay1IsClosed] 
       ,seic.[ScheduleDay1IsNotAvailable] = eic.[ScheduleDay1IsNotAvailable]  
       ,seic.[ScheduleDay2MorningStart] = eic.[ScheduleDay2MorningStart]  
       ,seic.[ScheduleDay2MorningEnd] = eic.[ScheduleDay2MorningEnd] 
       ,seic.[ScheduleDay2EveningStart] = eic.[ScheduleDay2EveningStart] 
       ,seic.[ScheduleDay2EveningEnd] = eic.[ScheduleDay2EveningEnd] 
       ,seic.[ScheduleDay2IsClosed] = eic.[ScheduleDay2IsClosed] 
       ,seic.[ScheduleDay2IsNotAvailable] = eic.[ScheduleDay2IsNotAvailable] 
       ,seic.[ScheduleDay3MorningStart] = eic.[ScheduleDay3MorningStart]  
       ,seic.[ScheduleDay3MorningEnd] = eic.[ScheduleDay3MorningEnd]  
       ,seic.[ScheduleDay3EveningStart] = eic.[ScheduleDay3EveningStart]  
       ,seic.[ScheduleDay3EveningEnd] = eic.[ScheduleDay3EveningEnd]  
       ,seic.[ScheduleDay3IsClosed] = eic.[ScheduleDay3IsClosed]   
       ,seic.[ScheduleDay3IsNotAvailable] = eic.[ScheduleDay3IsNotAvailable]  
       ,seic.[ScheduleDay4MorningStart] = eic.[ScheduleDay4MorningStart]  
       ,seic.[ScheduleDay4MorningEnd] = eic.[ScheduleDay4MorningEnd]  
       ,seic.[ScheduleDay4EveningStart] = eic.[ScheduleDay4EveningStart]  
       ,seic.[ScheduleDay4EveningEnd] = eic.[ScheduleDay4EveningEnd] 
       ,seic.[ScheduleDay4IsClosed] = eic.[ScheduleDay4IsClosed]  
       ,seic.[ScheduleDay4IsNotAvailable]= eic.[ScheduleDay4IsNotAvailable]   
       ,seic.[ScheduleDay5MorningStart] = eic.[ScheduleDay5MorningStart]  
       ,seic.[ScheduleDay5MorningEnd] = eic.[ScheduleDay5MorningEnd] 
       ,seic.[ScheduleDay5EveningStart] = eic.[ScheduleDay5EveningStart] 
       ,seic.[ScheduleDay5EveningEnd] = eic.[ScheduleDay5EveningEnd] 
       ,seic.[ScheduleDay5IsClosed] = eic.[ScheduleDay5IsClosed] 
       ,seic.[ScheduleDay5IsNotAvailable] = eic.[ScheduleDay5IsNotAvailable] 
       ,seic.[ScheduleDay6MorningStart] = eic.[ScheduleDay6MorningStart] 
       ,seic.[ScheduleDay6MorningEnd] = eic.[ScheduleDay6MorningEnd] 
       ,seic.[ScheduleDay6EveningStart] = eic.[ScheduleDay6EveningStart] 
       ,seic.[ScheduleDay6EveningEnd] = eic.[ScheduleDay6EveningEnd] 
       ,seic.[ScheduleDay6IsClosed] = eic.[ScheduleDay6IsClosed] 
       ,seic.[ScheduleDay6IsNotAvailable] = eic.[ScheduleDay6IsNotAvailable] 
       ,seic.[ScheduleDay7MorningStart] = eic.[ScheduleDay7MorningStart] 
       ,seic.[ScheduleDay7MorningEnd] = eic.[ScheduleDay7MorningEnd] 
       ,seic.[ScheduleDay7EveningStart] = eic.[ScheduleDay7EveningStart]  
       ,seic.[ScheduleDay7EveningEnd] = eic.[ScheduleDay7EveningEnd]  
       ,seic.[ScheduleDay7IsClosed] = eic.[ScheduleDay7IsClosed]  
       ,seic.[ScheduleDay7IsNotAvailable] = eic.[ScheduleDay7IsNotAvailable]   
       ,seic.[ScheduleComments] = ISNULL(eic_i18n.[ScheduleComments], eic.[ScheduleComments])
	   ,seic.[IsOnline] = eic.[IsOnline]
	   ,seic.[Zone_Id] = eic.[Zone_Id]

FROM Snapshot_StepEntityInCharge seic
	INNER JOIN EntityInCharge eic on seic.Id = eic.Id
		LEFT JOIN EntityInCharge_i18n eic_i18n on eic.id = eic_i18n.Parent_Id and [seic].Lang = eic_i18n.Lang
WHERE seic.Id = @entityInChargeId
AND seic.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- Update the attachments of the entity
DELETE FROM [dbo].[Snapshot_Object_Media] WHERE [Object_Id] = @entityInChargeId AND [Type] LIKE '%EntityInCharge%'

DECLARE @langPrincipal varchar(2)  
SET @langPrincipal = (SELECT TOP 1 code FROM SystemLanguage WHERE IsPrincipal = 1)  

DECLARE @registryId int, @objectiveId int, @blockId int, @stepId int

DECLARE sseic_cursor CURSOR FOR 
	SELECT DISTINCT sseic.Registry_Id, sseic.Objective_Id, sseic.Block_Id, sseic.Step_Id
	FROM dbo.Snapshot_StepEntityInCharge sseic with(nolock)
	WHERE sseic.Id = @entityInChargeId
	AND sseic.Registry_Id IN (SELECT sreg.Id FROM Snapshot_Registry sreg with(nolock) WHERE sreg.IsCurrent = 1)

OPEN sseic_cursor

FETCH NEXT FROM sseic_cursor
INTO @registryId, @objectiveId, @blockId, @stepId
WHILE @@FETCH_STATUS = 0
BEGIN 
	INSERT INTO [dbo].[Snapshot_Object_Media]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Lang]  
       ,[Object_Id],[Type],[Order]  
       ,[Media_Id]  
       ,[Media_Name]  
       ,[Media_FileName],[Media_Extention]  
       ,[Media_Length],[Media_PreviewImageName], [Media_IsDocumentPresent])  
	SELECT @registryId, @objectiveId, @blockId, @stepId, m.lang,  
	  om.[Object_Id], om.[Type], om.[Order],  
	  m.Id,   
	  CASE   
	   WHEN m.lang = @langPrincipal THEN m.[Name]  
	   ELSE ISNULL(m_i18n.[Name], m.[Name])  
	  END AS [Media_Name],  
	  CASE   
     WHEN m.lang = @langPrincipal THEN m.[FileName]  
     ELSE ISNULL(m_i18n.[FileName], m.[FileName])  
    END AS [Media_FileName],
    CASE   
     WHEN m.lang = @langPrincipal THEN m.[Extention]  
     ELSE ISNULL(m_i18n.[Extention], m.[Extention])  
    END AS [Media_Extention],
    CASE   
     WHEN m.lang = @langPrincipal THEN m.[Length]  
     ELSE ISNULL(m_i18n.[Length], m.[Length])  
    END AS [Media_Length],
    CASE   
     WHEN m.lang = @langPrincipal THEN m.[PreviewImageName]  
     ELSE ISNULL(m_i18n.[PreviewImageName], m.[PreviewImageName])  
    END AS [Media_PreviewImageName],
    m.[IsDocumentPresent]  
	FROM Admin_Object_Media om WITH(NOLOCK)  
	 INNER JOIN (SELECT l.code as lang, m.* FROM SystemLanguage l, Media m WITH(NOLOCK)) m ON om.[Media_Id] = m.[Id]  
		 LEFT JOIN Media_i18n m_i18n WITH(NOLOCK) ON m.[Id] = m_i18n.[Media_Id] and m.lang = m_i18n.lang 
	 INNER JOIN Admin_Step s WITH(NOLOCK) ON s.Id = @stepId
	 INNER JOIN [dbo].[EntityInCharge] eic WITH(NOLOCK) ON eic.[Id] = s.[EntityInCharge_Id]
	WHERE om.[Object_Id] = eic.[Id]  
	AND om.[Type] LIKE 'EntityInCharge'  
	AND ISNULL(eic.[Deleted], 0) = 0

	FETCH NEXT FROM sseic_cursor
	INTO @registryId, @objectiveId, @blockId, @stepId
END

CLOSE sseic_cursor
DEALLOCATE sseic_cursor


-- update the step certification
UPDATE ss
	SET ss.CertificationEntityInCharge_Name = isnull(eic_i18n.Name, eic.Name)
FROM Snapshot_Step ss
	INNER JOIN EntityInCharge eic on ss.CertificationEntityInCharge_Id = eic.Id
		LEFT JOIN EntityInCharge_i18n eic_i18n on eic.id = eic_i18n.Parent_Id and [ss].Lang = eic_i18n.Lang
WHERE ss.CertificationEntityInCharge_Id = @entityInChargeId
AND ss.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)


-- update the recourse snapshot table
UPDATE ruic
	SET 
		ruic.[Name]  = isnull(eic_i18n.Name, eic.Name)
       ,ruic.[Address] = ISNULL(eic_i18n.[Address], eic.[Address]) 
       ,ruic.[City] = eic.[City]  
       ,ruic.[PostalCode] = eic.[PostalCode] 
       ,ruic.[CountryCode] = eic.[CountryCode] 
       ,ruic.[Phone1] = eic.[Phone1] 
       ,ruic.[Phone2] = eic.[Phone2] 
	   ,ruic.[GoogleMapsURL] = eic.[GoogleMapsURL] 
       ,ruic.[Fax1] = eic.[Fax1] 
       ,ruic.[Fax2] = eic.[Fax2]
       ,ruic.[Email1] = eic.[Email1] 
       ,ruic.[Email2] = eic.[Email2] 
       ,ruic.[Website1] = ISNULL(eic_i18n.[Website1], eic.[Website1])   
       ,ruic.[Website2] = ISNULL(eic_i18n.[Website2], eic.[Website2]) 
       ,ruic.[Image] = eic.[Image]  
       ,ruic.[ScheduleDay1MorningStart] = eic.[ScheduleDay1MorningStart]   
       ,ruic.[ScheduleDay1MorningEnd] = eic.[ScheduleDay1MorningEnd] 
       ,ruic.[ScheduleDay1EveningStart] = eic.[ScheduleDay1EveningStart] 
       ,ruic.[ScheduleDay1EveningEnd] = eic.[ScheduleDay1EveningEnd] 
       ,ruic.[ScheduleDay1IsClosed] = eic.[ScheduleDay1IsClosed] 
       ,ruic.[ScheduleDay1IsNotAvailable] = eic.[ScheduleDay1IsNotAvailable]  
       ,ruic.[ScheduleDay2MorningStart] = eic.[ScheduleDay2MorningStart]  
       ,ruic.[ScheduleDay2MorningEnd] = eic.[ScheduleDay2MorningEnd] 
       ,ruic.[ScheduleDay2EveningStart] = eic.[ScheduleDay2EveningStart] 
       ,ruic.[ScheduleDay2EveningEnd] = eic.[ScheduleDay2EveningEnd] 
       ,ruic.[ScheduleDay2IsClosed] = eic.[ScheduleDay2IsClosed] 
       ,ruic.[ScheduleDay2IsNotAvailable] = eic.[ScheduleDay2IsNotAvailable] 
       ,ruic.[ScheduleDay3MorningStart] = eic.[ScheduleDay3MorningStart]  
       ,ruic.[ScheduleDay3MorningEnd] = eic.[ScheduleDay3MorningEnd]  
       ,ruic.[ScheduleDay3EveningStart] = eic.[ScheduleDay3EveningStart]  
       ,ruic.[ScheduleDay3EveningEnd] = eic.[ScheduleDay3EveningEnd]  
       ,ruic.[ScheduleDay3IsClosed] = eic.[ScheduleDay3IsClosed]   
       ,ruic.[ScheduleDay3IsNotAvailable] = eic.[ScheduleDay3IsNotAvailable]  
       ,ruic.[ScheduleDay4MorningStart] = eic.[ScheduleDay4MorningStart]  
       ,ruic.[ScheduleDay4MorningEnd] = eic.[ScheduleDay4MorningEnd]  
       ,ruic.[ScheduleDay4EveningStart] = eic.[ScheduleDay4EveningStart]  
       ,ruic.[ScheduleDay4EveningEnd] = eic.[ScheduleDay4EveningEnd] 
       ,ruic.[ScheduleDay4IsClosed] = eic.[ScheduleDay4IsClosed]  
       ,ruic.[ScheduleDay4IsNotAvailable]= eic.[ScheduleDay4IsNotAvailable]   
       ,ruic.[ScheduleDay5MorningStart] = eic.[ScheduleDay5MorningStart]  
       ,ruic.[ScheduleDay5MorningEnd] = eic.[ScheduleDay5MorningEnd] 
       ,ruic.[ScheduleDay5EveningStart] = eic.[ScheduleDay5EveningStart] 
       ,ruic.[ScheduleDay5EveningEnd] = eic.[ScheduleDay5EveningEnd] 
       ,ruic.[ScheduleDay5IsClosed] = eic.[ScheduleDay5IsClosed] 
       ,ruic.[ScheduleDay5IsNotAvailable] = eic.[ScheduleDay5IsNotAvailable] 
       ,ruic.[ScheduleDay6MorningStart] = eic.[ScheduleDay6MorningStart] 
       ,ruic.[ScheduleDay6MorningEnd] = eic.[ScheduleDay6MorningEnd] 
       ,ruic.[ScheduleDay6EveningStart] = eic.[ScheduleDay6EveningStart] 
       ,ruic.[ScheduleDay6EveningEnd] = eic.[ScheduleDay6EveningEnd] 
       ,ruic.[ScheduleDay6IsClosed] = eic.[ScheduleDay6IsClosed] 
       ,ruic.[ScheduleDay6IsNotAvailable] = eic.[ScheduleDay6IsNotAvailable] 
       ,ruic.[ScheduleDay7MorningStart] = eic.[ScheduleDay7MorningStart] 
       ,ruic.[ScheduleDay7MorningEnd] = eic.[ScheduleDay7MorningEnd] 
       ,ruic.[ScheduleDay7EveningStart] = eic.[ScheduleDay7EveningStart]  
       ,ruic.[ScheduleDay7EveningEnd] = eic.[ScheduleDay7EveningEnd]  
       ,ruic.[ScheduleDay7IsClosed] = eic.[ScheduleDay7IsClosed]  
       ,ruic.[ScheduleDay7IsNotAvailable] = eic.[ScheduleDay7IsNotAvailable]   
       ,ruic.[ScheduleComments] = ISNULL(eic_i18n.[ScheduleComments], eic.[ScheduleComments])
	   ,ruic.[IsOnline] = eic.[IsOnline]
	   ,ruic.[Zone_Id] = eic.[Zone_Id]

FROM Snapshot_StepRecourseEntityInCharge ruic
	INNER JOIN EntityInCharge eic on ruic.Id = eic.Id
		LEFT JOIN EntityInCharge_i18n eic_i18n on eic.id = eic_i18n.Parent_Id and [ruic].Lang = eic_i18n.Lang
WHERE ruic.Id = @entityInChargeId
AND ruic.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- Set the URL of the entity in charge to the step if both are online
UPDATE s
SET s.[OnlineStepURL] = ISNULL(e_i18n.Website1, e.Website1)
  FROM EntityInCharge e
  INNER JOIN Admin_Step s ON e.Id = s.EntityInCharge_Id OR e.Id = s.CertificationEntityInCharge_Id OR e.Id = s.Recourse_EntityInCharge_Id
  LEFT JOIN EntityInCharge_i18n e_i18n ON e.Id = e_i18n.Parent_Id
  WHERE e.Id = @entityInChargeId AND s.IsOnline = 1 AND e.IsOnline = 1

SET NOCOUNT OFF
END
GO

-- =============================================
-- Category 6: Major structural
-- Procedure: sp_on_updated_genericRequirement
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_on_updated_genericRequirement' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_on_updated_genericRequirement]
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
	ssr.GenericRequirement_NumberOfPages = gr.NumberOfPages,
	ssr.GenericRequirement_IsEmittedByInstitution = gr.IsEmittedByInstitution
FROM Snapshot_StepRequirement ssr
	INNER JOIN GenericRequirement gr on ssr.GenericRequirement_Id = gr.Id
		LEFT JOIN GenericRequirement_i18n gr_i18n on gr.id = gr_i18n.Parent_Id and [ssr].Lang = gr_i18n.Lang
WHERE ssr.GenericRequirement_Id = @genericRequirementId
AND ssr.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

--------------------------------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------------------------------

-- update the snapshot result table
UPDATE ssr
SET ssr.Name = isnull(gr_i18n.Name, gr.Name),
	ssr.Document_Type = gr.Type
FROM Snapshot_StepResult ssr
	INNER JOIN GenericRequirement gr on ssr.Document_Id = gr.Id
		LEFT JOIN GenericRequirement_i18n gr_i18n on gr.id = gr_i18n.Parent_Id and [ssr].Lang = gr_i18n.Lang
WHERE ssr.Document_Id = @genericRequirementId
AND ssr.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- attachments
if ((select count(*) from Snapshot_Object_Media where [Object_Id] = @genericRequirementId and [Type] = 'GenericRequirement') > 0 and
	(select count(*) from Admin_Object_Media where [Object_Id] = @genericRequirementId and [Type] = 'GenericRequirement') > 0)
begin
	UPDATE som 
	SET som.Media_Id = m.Id,
		som.Media_Name = isnull(m_i18n.Name, m.Name),
		som.Media_FileName = isnull(m_i18n.FileName, m.FileName),
		som.Media_Extention = isnull(m_i18n.Extention, m.Extention),
		som.Media_Length = isnull(m_i18n.Length, m.Length),
		som.Media_PreviewImageName = isnull(m_i18n.PreviewImageName, m.PreviewImageName),
		som.Media_IsDocumentPresent = m.IsDocumentPresent
	FROM Snapshot_Object_Media som
		INNER JOIN Admin_Object_Media aom ON som.[Object_Id] = aom.[Object_Id] and [som].[Type] = aom.[Type]
			INNER JOIN Media m on aom.[Media_Id] = m.[Id]
				LEFT JOIN Media_i18n m_i18n on m.Id = m_i18n.Media_Id and m_i18n.Lang = som.Lang
	WHERE som.[Object_Id] = @genericRequirementId
	AND som.[Type] = 'GenericRequirement'
	AND som.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)
end
else if ((select count(*) from Snapshot_Object_Media where [Object_Id] = @genericRequirementId and [Type] = 'GenericRequirement') = 0 and
	(select count(*) from Admin_Object_Media where [Object_Id] = @genericRequirementId and [Type] = 'GenericRequirement') > 0)
begin
	-- you must insert the new media for all the generic requirements where 
	DECLARE @registryId int, @objectiveId int, @blockId int, @stepId int, @lang varchar(2)

	-- get all the blocks in the snapshot tables
	DECLARE som_cursor CURSOR FOR 
		SELECT DISTINCT sr.registry_id, sr.objective_id, sr.block_id, sr.step_id, lang
		FROM dbo.Snapshot_StepRequirement sr with(nolock)
		WHERE sr.GenericRequirement_id = @genericRequirementId 
		AND sr.registry_id IN (SELECT sreg.id FROM Snapshot_Registry sreg with(nolock) WHERE sreg.IsCurrent = 1)

	OPEN som_cursor

	FETCH NEXT FROM som_cursor
	INTO @registryId, @objectiveId, @blockId, @stepId, @lang
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		INSERT INTO [dbo].[Snapshot_Object_Media]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Lang]  
		   ,[Object_Id],[Type],[Order]  
		   ,[Media_Id]  
		   ,[Media_Name]  
		   ,[Media_FileName],[Media_Extention]  
		   ,[Media_Length],[Media_PreviewImageName], [Media_IsDocumentPresent]) 		
		SELECT @registryId, @objectiveId, @blockId, @stepId, @lang,
			@genericRequirementId, 'GenericRequirement', 0,
			m.Id, isnull(m_i18n.Name, m.[Name]),
			isnull(m_i18n.FileName, m.FileName),
			isnull(m_i18n.Extention, m.Extention),
			isnull(m_i18n.Length, m.Length),
			isnull(m_i18n.PreviewImageName, m.PreviewImageName),
			m.IsDocumentPresent
		FROM Media m
			LEFT JOIN Media_i18n m_i18n on m.[Id] = m_i18n.[Media_Id] and m_i18n.lang = @lang
		WHERE m.id = (select top 1 Media_Id FROM Admin_Object_Media where [object_id] = @genericRequirementId and [Type] = 'GenericRequirement')  
		
		FETCH NEXT FROM som_cursor
		INTO @registryId, @objectiveId, @blockId, @stepId, @lang
	END
		
	CLOSE som_cursor
	DEALLOCATE som_cursor

	-- same for step results
	DECLARE srm_cursor CURSOR FOR 
		SELECT DISTINCT sr.registry_id, sr.objective_id, sr.block_id, sr.step_id, lang
		FROM dbo.Snapshot_StepResult sr with(nolock)
		WHERE sr.Document_Id = @genericRequirementId 
		AND sr.registry_id IN (SELECT sreg.id FROM Snapshot_Registry sreg with(nolock) WHERE sreg.IsCurrent = 1)

	OPEN srm_cursor

	FETCH NEXT FROM srm_cursor
	INTO @registryId, @objectiveId, @blockId, @stepId, @lang
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		INSERT INTO [dbo].[Snapshot_Object_Media]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Lang]  
		   ,[Object_Id],[Type],[Order]  
		   ,[Media_Id]  
		   ,[Media_Name]  
		   ,[Media_FileName],[Media_Extention]  
		   ,[Media_Length],[Media_PreviewImageName], [Media_IsDocumentPresent]) 		
		SELECT @registryId, @objectiveId, @blockId, @stepId, @lang,
			@genericRequirementId, 'GenericRequirement', 0,
			m.Id, isnull(m_i18n.Name, m.[Name]),
			isnull(m_i18n.FileName, m.FileName),
			isnull(m_i18n.Extention, m.Extention), 
			isnull(m_i18n.Length, m.Length),
			isnull(m_i18n.PreviewImageName, m.PreviewImageName),
			m.IsDocumentPresent
		FROM Media m
			LEFT JOIN Media_i18n m_i18n on m.[Id] = m_i18n.[Media_Id] and m_i18n.lang = @lang
		WHERE m.id = (select top 1 Media_Id FROM Admin_Object_Media where [object_id] = @genericRequirementId and [Type] = 'GenericRequirement')  
		
		FETCH NEXT FROM srm_cursor
		INTO @registryId, @objectiveId, @blockId, @stepId, @lang
	END
		
	CLOSE srm_cursor
	DEALLOCATE srm_cursor

end
else if ((select count(*) from Snapshot_Object_Media where [Object_Id] = @genericRequirementId and [Type] = 'GenericRequirement') > 0 and
	(select count(*) from Admin_Object_Media where [Object_Id] = @genericRequirementId and [Type] = 'GenericRequirement') = 0)
begin
	DELETE FROM Snapshot_Object_Media
	WHERE [Object_Id] = @genericRequirementId and [Type] = 'GenericRequirement'
end

-- call the procedure for populating the public tables 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Public_Generate_ALL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)  
exec [dbo].[Public_Generate_ALL]

SET NOCOUNT OFF
END
GO

-- =============================================
-- Category 6: Major structural
-- Procedure: sp_on_updated_law
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_on_updated_law' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_on_updated_law]
GO
CREATE PROCEDURE [dbo].[sp_on_updated_law]
(
	@lawId int
)
AS
BEGIN

SET NOCOUNT ON

-- update the snapshot table

-- 1. Snapshot_StepLaw
UPDATE [ssl]
SET [ssl].Law_Name = isnull(l_i18n.Name, l.Name),
	[ssl].Law_Description = isnull(l_i18n.Description, l.Description),
	[ssl].Law_IsDocumentPresent = l.IsDocumentPresent
FROM Snapshot_StepLaw [ssl]
	INNER JOIN Law l on [ssl].Law_Id = l.Id
		LEFT JOIN Law_i18n l_i18n on l.id = l_i18n.Parent_Id and [ssl].Lang = l_i18n.Lang
WHERE [ssl].Law_Id = @lawId
AND [ssl].[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- 2. Snapshot_Step, Contact Law
UPDATE [ss]
SET [ss].Contact_Law_Name = isnull(l_i18n.Name, l.Name),
	[ss].Contact_Law_Description = isnull(l_i18n.Description, l.Description)
FROM Snapshot_Step [ss]
	INNER JOIN Law l on [ss].Contact_Law_Id = l.Id
		LEFT JOIN Law_i18n l_i18n on l.id = l_i18n.Parent_Id and [ss].Lang = l_i18n.Lang
WHERE [ss].Contact_Law_Id = @lawId
AND [ss].[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- 3. Snapshot_Step, Timeframe Law
UPDATE [ss]
SET [ss].Timeframe_Law_Name = isnull(l_i18n.Name, l.Name),
	[ss].Timeframe_Law_Description = isnull(l_i18n.Description, l.Description)
FROM Snapshot_Step [ss]
	INNER JOIN Law l on [ss].Timeframe_Law_Id = l.Id
		LEFT JOIN Law_i18n l_i18n on l.id = l_i18n.Parent_Id and [ss].Lang = l_i18n.Lang
WHERE [ss].Timeframe_Law_Id = @lawId
AND [ss].[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- 4. Snapshot_StepResult
UPDATE [ssres]
SET [ssres].Law_Name = isnull(l_i18n.Name, l.Name),
	[ssres].Law_Description = isnull(l_i18n.Description, l.Description)
FROM Snapshot_StepResult [ssres]
	INNER JOIN Law l on [ssres].Law_Id = l.Id
		LEFT JOIN Law_i18n l_i18n on l.id = l_i18n.Parent_Id and [ssres].Lang = l_i18n.Lang
WHERE [ssres].Law_Id = @lawId
AND [ssres].[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- 5. Snapshot_StepCost
UPDATE [sscost]
SET [sscost].Law_Name = isnull(l_i18n.Name, l.Name),
	[sscost].Law_Description = isnull(l_i18n.Description, l.Description)
FROM Snapshot_StepCost [sscost]
	INNER JOIN Law l on [sscost].Law_Id = l.Id
		LEFT JOIN Law_i18n l_i18n on l.id = l_i18n.Parent_Id and [sscost].Lang = l_i18n.Lang
WHERE [sscost].Law_Id = @lawId
AND [sscost].[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- 6. Snapshot_StepRequirement
UPDATE [ssr]
SET [ssr].Law_Name = isnull(l_i18n.Name, l.Name),
	[ssr].Law_Description = isnull(l_i18n.Description, l.Description)
FROM Snapshot_StepRequirement [ssr]
	INNER JOIN Law l on [ssr].Law_Id = l.Id
		LEFT JOIN Law_i18n l_i18n on l.id = l_i18n.Parent_Id and [ssr].Lang = l_i18n.Lang
WHERE [ssr].Law_Id = @lawId
AND [ssr].[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)

-- attachments
if ((select count(*) from Snapshot_Object_Media where [Object_Id] = @lawId and [Type] = 'Law') > 0 and
	(select count(*) from Admin_Object_Media where [Object_Id] = @lawId and [Type] = 'Law') > 0)
begin
	UPDATE som 
	SET som.Media_Id = m.Id,
		som.Media_Name = isnull(m_i18n.Name, m.Name),
		som.Media_FileName = isnull(m_i18n.FileName, m.FileName),
		som.Media_Extention = isnull(m_i18n.Extention, m.Extention),
		som.Media_Length = isnull(m_i18n.Length, m.Length),
		som.Media_PreviewImageName = isnull(m_i18n.PreviewImageName, m.PreviewImageName),
		som.Media_IsDocumentPresent = m.IsDocumentPresent
	FROM Snapshot_Object_Media som
		INNER JOIN Admin_Object_Media aom ON som.[Object_Id] = aom.[Object_Id] and [som].[Type] = aom.[Type]
			INNER JOIN Media m on aom.[Media_Id] = m.[Id]
				LEFT JOIN Media_i18n m_i18n on m.Id = m_i18n.Media_Id and m_i18n.Lang = som.Lang
	WHERE som.[Object_Id] = @lawId
	AND som.[Type] = 'Law'
	AND som.[Registry_Id] in (select id from Snapshot_Registry where IsCurrent = 1)
end
else if ((select count(*) from Snapshot_Object_Media where [Object_Id] = @lawId and [Type] = 'Law') = 0 and
	(select count(*) from Admin_Object_Media where [Object_Id] = @lawId and [Type] = 'Law') > 0)
begin
	-- you must insert the new media for all the generic requirements where 
	DECLARE @registryId int, @objectiveId int, @blockId int, @stepId int, @lang varchar(2)

	-- get all the blocks in the snapshot tables
	DECLARE som_cursor CURSOR FOR 
		SELECT DISTINCT sl.registry_id, sl.objective_id, sl.block_id, sl.step_id, lang
		FROM dbo.Snapshot_StepLaw sl with(nolock)
		WHERE sl.Law_Id = @lawId 
		AND sl.registry_id IN (SELECT sreg.id FROM Snapshot_Registry sreg with(nolock) WHERE sreg.IsCurrent = 1)

	OPEN som_cursor

	FETCH NEXT FROM som_cursor
	INTO @registryId, @objectiveId, @blockId, @stepId, @lang
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		INSERT INTO [dbo].[Snapshot_Object_Media]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Lang]  
		   ,[Object_Id],[Type],[Order]  
		   ,[Media_Id]  
		   ,[Media_Name]  
		   ,[Media_FileName],[Media_Extention]  
		   ,[Media_Length],[Media_PreviewImageName], [Media_IsDocumentPresent]) 		
		SELECT @registryId, @objectiveId, @blockId, @stepId, @lang,
			@lawId, 'Law', 0,
			m.Id, isnull(m_i18n.Name, m.[Name]),
			isnull(m_i18n.FileName, m.FileName),
			isnull(m_i18n.Extention, m.Extention), 
			isnull(m_i18n.Length, m.Length),
			isnull(m_i18n.PreviewImageName, m.PreviewImageName),
			m.IsDocumentPresent
		FROM Media m
			LEFT JOIN Media_i18n m_i18n on m.[Id] = m_i18n.[Media_Id] and m_i18n.lang = @lang
		WHERE m.id = (select top 1 Media_Id FROM Admin_Object_Media where [object_id] = @lawId and [Type] = 'Law')  
		
		FETCH NEXT FROM som_cursor
		INTO @registryId, @objectiveId, @blockId, @stepId, @lang
	END
		
	CLOSE som_cursor
	DEALLOCATE som_cursor
end
else if ((select count(*) from Snapshot_Object_Media where [Object_Id] = @lawId and [Type] = 'Law') > 0 and
	(select count(*) from Admin_Object_Media where [Object_Id] = @lawId and [Type] = 'Law') = 0)
begin
	DELETE FROM Snapshot_Object_Media
	WHERE [Object_Id] = @lawId and [Type] = 'Law'
end

-- call the procedure for populating the public tables 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Public_Generate_ALL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)  
exec [dbo].[Public_Generate_ALL]

SET NOCOUNT OFF
END
GO

-- =============================================
-- Category 6: Major structural
-- Procedure: sp_snapshot_getStep
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_snapshot_getStep' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_snapshot_getStep]
GO
CREATE PROCEDURE [dbo].[sp_snapshot_getStep]
(
	@registryId int,
	@blockId int,
	@lang varchar(2),
	@systemId int
)
AS
SET NOCOUNT ON

SELECT ss.*, 
	IsNull(sta.status,10) as status, 
	IsNull(sta.dateCreated, reg.SnapshotDate) as StatusDate,
	IsNull(sta.version,1) as [Version]
FROM Snapshot_Step ss with (nolock)
LEFT OUTER JOIN (SELECT
		stepId, 
		[status], 
		[version], 
		[cycle], 
		[dateCreated], 
		creatorId
        FROM(
SELECT
		stepId, 
		[status], 
		[version], 
		[cycle], 
		[dateCreated], 
		creatorId,
        ROW_NUMBER() OVER (PARTITION BY stepId ORDER BY [version] DESC, cycle DESC, [status] DESC) AS row_num
	FROM [eregulations-consistency].[00-dbe-consistency].dbo.consistency_status WITH (NOLOCK) 
	WHERE (pagename = 'step') 
	AND (isLast = 1) 
	AND (systemId = @systemId)) AS subquery
    WHERE row_num = 1) AS sta 
ON  ss.Id = sta.stepId 
INNER JOIN dbo.Snapshot_Registry reg
ON ss.Registry_Id=reg.Id AND reg.IsCurrent=1
WHERE 
ss.Registry_Id = @registryId
AND ss.Block_Id = @blockId
AND ss.IsRecourse = 0 
AND ss.Lang = @lang
GO

-- =============================================
-- Category 6: Major structural
-- Procedure: sp_take_snapshot_objective
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_take_snapshot_objective' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_take_snapshot_objective]
GO
CREATE PROCEDURE [dbo].[sp_take_snapshot_objective]
(
	@objectiveId int,
	@date datetime
)
AS
BEGIN

SET NOCOUNT ON

/* 1. get the current snapshotVer (if null, that is first time taken, set the default = 1) */
DECLARE @snapshotVer int
SET @snapshotVer = 0 --initialize with 0
SELECT @snapshotVer = snapshotVersion FROM [dbo].[Snapshot_Registry] WITH(NOLOCK) WHERE Objective_Id = @objectiveId and IsCurrent = 1
IF @snapshotVer = 0 -- not found, set to 1
	SET @snapshotVer = 1


/* 2. get the registry_ID that correspond to the objectiveId and the snapshotVer
		if null (first time taken), add a new entry in snapshot_registry and get the registry_Id */
DECLARE @registryId int
IF NOT EXISTS (SELECT [Id] FROM [dbo].[Snapshot_Registry] WITH(NOLOCK) WHERE Objective_Id = @objectiveId AND SnapshotVersion = @snapshotVer)
BEGIN
	INSERT INTO [dbo].[Snapshot_Registry] ([Objective_id],[SnapshotVersion],[SnapshotDate],[IsCurrent])
     VALUES (@objectiveId, @snapshotVer, @date, 1)	
END
SELECT @registryId = [Id] FROM [dbo].[Snapshot_Registry] WITH(NOLOCK) WHERE Objective_Id = @objectiveId and SnapshotVersion = @snapshotVer

/* 3. delete all from Snapshot_Objective, Snapshot_Block, Snapshot_Step, 
						Snapshot_StepEntityInCharge, Snapshot_StepUnitInCharge, Snapshot_StepPersonInCharge,
						Snapshot_StepResult, Snapshot_StepRequirement, Snapshot_StepCost, Snapshot_StepLaw
						Snapshot_StepSectionVisibility,
						Snapshot_Object_Media 
		that are linked to the registry_Id of the current snapshot */

DELETE FROM [dbo].[Snapshot_Objective] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_Block] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_Step] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepEntityInCharge] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepUnitInCharge] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepPersonInCharge] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepRecourseEntityInCharge] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepRecourseUnitInCharge] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepRecoursePersonInCharge] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepRegionalEntityInCharge] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepRegionalUnitInCharge] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepRegionalPersonInCharge] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepResult] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepRequirement] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepRequirementCost] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepCost] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepLaw] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_StepSectionVisibility] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_Object_Media] WHERE [Registry_Id] = @registryId
DELETE FROM [dbo].[Snapshot_ObjectiveSectionVisibility] WHERE [Registry_Id] = @registryId

/* 4. update the date in the snapshot registry to the current date for the current snapshot  */
UPDATE [dbo].[Snapshot_Registry]
SET [SnapshotDate] = @date
WHERE [Id] = @registryId

DECLARE @langPrincipal varchar(2)
SET @langPrincipal = (SELECT TOP 1 code FROM SystemLanguage WHERE IsPrincipal = 1)

/* 5. add new entry for each lang in Snaphot_Objective */
INSERT INTO [dbo].[Snapshot_Objective]([Registry_Id],[Id],[Lang],[Name],[AdditionalInfo])
SELECT @registryId, o.Id, o.lang,
	CASE 
		WHEN o.lang = @langPrincipal THEN o.Name
		ELSE ISNULL(o_i18n.[Name], o.[Name])
	END AS [Name],
	CASE 
		WHEN o.lang = @langPrincipal THEN o.AdditionalInfo
		ELSE ISNULL(o_i18n.[AdditionalInfo], o.[AdditionalInfo])
	END AS [AdditionalInfo]
FROM (SELECT l.code AS lang, [Id], o.[Name], o.[AdditionalInfo] FROM Admin_Objective o WITH(NOLOCK), SystemLanguage l) o
	LEFT JOIN Admin_Objective_i18n o_i18n WITH(NOLOCK) ON o.[lang] = o_i18n.[lang] and o.[Id] = o_i18n.[Parent_Id]
	LEFT JOIN Admin_ObjectivePerLangVisibility mvis WITH(NOLOCK) on o.Id = mvis.Objective_Id AND o.lang = mvis.Lang
WHERE o.[Id] = @objectiveId AND mvis.Visible = 1

-- insert the attachments for the objective additional info  
INSERT INTO [dbo].[Snapshot_Object_Media]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Lang]  
       ,[Object_Id],[Type],[Order]  
       ,[Media_Id]  
       ,[Media_Name]  
       ,[Media_FileName],[Media_Extention]  
       ,[Media_Length],[Media_PreviewImageName], [Media_IsDocumentPresent])  
SELECT @registryId, @objectiveId, 0, 0, m.lang,  
  om.[Object_Id], om.[Type], om.[Order],  
  m.Id,   
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[Name]  
   ELSE ISNULL(m_i18n.[Name], m.[Name])  
  END AS [Media_Name],  
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[FileName]  
   ELSE ISNULL(m_i18n.[FileName], m.[FileName])  
  END AS [Media_FileName],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Extention]  
    ELSE ISNULL(m_i18n.[Extention], m.[Extention])  
  END AS [Media_Extention],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Length]  
    ELSE ISNULL(m_i18n.[Length], m.[Length])  
  END AS [Media_Length],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[PreviewImageName]  
    ELSE ISNULL(m_i18n.[PreviewImageName], m.[PreviewImageName])  
  END AS [Media_PreviewImageName],
  m.[IsDocumentPresent]
FROM Admin_Object_Media om WITH(NOLOCK)  
 INNER JOIN (SELECT l.code as lang, m.* FROM SystemLanguage l, Media m WITH(NOLOCK)) m ON om.[Media_Id] = m.[Id]  
     LEFT JOIN Media_i18n m_i18n WITH(NOLOCK) ON m.[Id] = m_i18n.[Media_Id] and m.lang = m_i18n.lang   
WHERE om.[Object_Id] = @objectiveId
AND om.[Type] in ('ObjectiveSummary')   

/* 5.1 set the objective section visibility */
INSERT INTO [dbo].[Snapshot_ObjectiveSectionVisibility]([Registry_Id],[Objective_Id]
       ,[IsExpectedResultsVisible]  
       ,[IsEntitiesInChargeVisible]  
       ,[IsRequirementsVisible]  
       ,[IsCostsVisible]  
       ,[IsTimeframeVisible]  
       ,[IsLegalJustificationVisible]  
       ,[IsAdditionalInfoVisible]  
       ,[IsAdministrativeBurdenVisible])  
 SELECT @registryId, @objectiveId
   ,[IsExpectedResultsVisible]  
   ,[IsEntitiesInChargeVisible]  
   ,[IsRequirementsVisible]  
   ,[IsCostsVisible]  
   ,[IsTimeframeVisible]  
   ,[IsLegalJustificationVisible]  
   ,[IsAdditionalInfoVisible]  
   ,[IsAdministrativeBurdenVisible]
FROM [dbo].[Admin_ObjectiveSectionVisibility]  
WHERE Objective_Id = @objectiveId  

/* 6. for each Block in Admin_Objective_Block add a new entry for each lang in Snapshot_Block */
INSERT INTO [dbo].[Snapshot_Block]([Registry_Id],[Objective_Id],[Order],[Id],[Lang]
           ,[Name]
		   ,[Description]
		   ,[IsOptional],[PhysicalPresence],[RepresentationThirdParty])
SELECT @registryId, ob.objective_id, ob.[order], b.Id, b.lang,
	CASE 
		WHEN b.lang = @langPrincipal THEN b.[Name]
		ELSE ISNULL(b_i18n.[Name], b.[Name])
	END AS [Name],
	CASE 
		WHEN b.lang = @langPrincipal THEN b.[Description]
		ELSE ISNULL(b_i18n.[Description], b.[Description])
	END AS [Description],
	b.[IsOptional], b.[PhysicalPresence], b.[RepresentationThirdParty]
FROM 
	( SELECT l.code as lang, b.* FROM Admin_Block b WITH(NOLOCK), SystemLanguage l
	  WHERE ISNULL(b.[Deleted], 0) = 0  AND ISNULL(b.[IsInRecycleBin], 0) = 0
	) b
		LEFT JOIN Admin_Block_i18n b_i18n WITH(NOLOCK) ON b.[lang] = b_i18n.[lang] and b.[Id] = b_i18n.[Parent_Id]
		INNER JOIN Admin_Objective_Block ob WITH(NOLOCK) ON b.[Id] = ob.[Block_Id]
WHERE 
	ob.[Objective_Id] = @objectiveId		

/*		6.1. for each Block in Admin_Objective_Block 
						& for each Step in Admin_Block_Step add a new entry for each lang in 
							Snapshot_Step,
							Snapshot_StepEntityInCharge, Snapshot_StepUnitInCharge, Snapshot_StepPersonInCharge,
							Snapshot_StepResult, Snapshot_StepRequirement, Snapshot_StepCost, Snapshot_StepLaw
							Snapshot_StepSectionVisibility 
 */

DECLARE @blockId int, @stepId int, @stepOrder int, @stepIsParallele bit, @stepIsAlternative bit

DECLARE step_cursor CURSOR FOR 
	SELECT b.Id as Block_Id, s.Id as Step_Id, bs.[Order], bs.[IsParallele], bs.[IsAlternative]
	FROM Admin_Step s WITH(NOLOCK)
			INNER JOIN Admin_Block_Step bs WITH(NOLOCK) ON s.[Id] = bs.[Step_Id]
				INNER JOIN Admin_Block b WITH(NOLOCK) ON bs.[Block_Id] = b.[Id]
					INNER JOIN Admin_Objective_Block ob WITH(NOLOCK) ON b.[Id] = ob.[Block_Id]
	WHERE 
	ISNULL(s.[Deleted], 0) = 0  AND ISNULL(s.[IsInRecycleBin], 0) = 0 
	AND ISNULL(b.[Deleted], 0) = 0  AND ISNULL(b.[IsInRecycleBin], 0) = 0
	AND ob.[Objective_Id] = @objectiveId
OPEN step_cursor

FETCH NEXT FROM step_cursor 
INTO @blockId, @stepId, @stepOrder, @stepIsParallele, @stepIsAlternative

WHILE @@FETCH_STATUS = 0
BEGIN
	-- add Step
	INSERT INTO [dbo].[Snapshot_Step]([Registry_Id],[Objective_Id],[Block_Id]
		   ,[IsRecourse],[Step_Id]
		   ,[Order],[IsParallele],[IsAlternative]
		   ,[Certified], [CertificationDate], [CertificationUser], [CertificationEntityInCharge_Id]
		   ,[CertificationEntityInCharge_Name]
		   ,[Id],[Lang]
           ,[Name]
           ,[PhysicalPresence],[RepresentationThirdParty],[IsOnline],[OnlineType],[OnlineStepURL],[IsOptional],[RequirementsPhysicalPresence]
           ,[HasCosts],[NoCostsReason],[IsPayMethodCash],[IsPayMethodCheck],[IsPayMethodCard],[IsPayMethodOther]
           ,[PayMethodOtherText]
           ,[CostsComments]
           ,[WaintingTimeInLineMin],[WaintingTimeInLineMax],[TimeSpentAtTheCounterMin],[TimeSpentAtTheCounterMax],[WaitingTimeUntilNextStepMin],[WaitingTimeUntilNextStepMax]
           ,[TimeframeComments]
           ,[LawsComments]
           ,[AdditionalInfo]
		   ,[Contact_Law_Id]
		   ,[Contact_Law_Name]
		   ,[Contact_Law_Description]
		   ,[Contact_Articles]
		   ,[Recourse_Law_Id]
		   ,[Recourse_Law_Name]
		   ,[Recourse_Law_Description]
		   ,[Recourse_Articles]
		   ,[Timeframe_Law_Id]
		   ,[Timeframe_Law_Name]
		   ,[Timeframe_Law_Description]
		   ,[Timeframe_Articles]
		   ,[IsInternal]
		   ,[SnapshotDate]
		   ,[Level_Id]
		   ,[NumberOfUsers]
		   ,[Summary])
	SELECT @registryId, @objectiveId, @blockId, 
			0, NULL, -- is no recourse, so the step_Id is NULL
		    @stepOrder, @stepIsParallele, @stepIsAlternative,
			s.[Certified], s.[CertificationDate], s.[CertificationUser], s.[CertificationEntityInCharge_Id], 
			CASE 
				WHEN s.lang = @langPrincipal THEN ceic.[Name]
				ELSE ISNULL(ceic_i18n.[Name], ceic.[Name])
			END AS [CertificationEntityInCharge_Name],			
			@stepId, s.lang,
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[Name]
				ELSE ISNULL(s_i18n.[Name], s.[Name])
			END AS [Name],
			s.[PhysicalPresence],s.[RepresentationThirdParty],s.[IsOnline],s.[OnlineType],s.[OnlineStepURL],s.[IsOptional],s.[RequirementsPhysicalPresence],
			s.[HasCosts],s.[NoCostsReason],s.[IsPayMethodCash],s.[IsPayMethodCheck],s.[IsPayMethodCard],s.[IsPayMethodOther],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[PayMethodOtherText]
				ELSE ISNULL(s_i18n.[PayMethodOtherText], s.[PayMethodOtherText])
			END AS [PayMethodOtherText],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[CostsComments]
				ELSE ISNULL(s_i18n.[CostsComments], s.[CostsComments])
			END AS [CostsComments],
			s.[WaintingTimeInLineMin],s.[WaintingTimeInLineMax],s.[TimeSpentAtTheCounterMin],s.[TimeSpentAtTheCounterMax],s.[WaitingTimeUntilNextStepMin],s.[WaitingTimeUntilNextStepMax],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[TimeframeComments]
				ELSE ISNULL(s_i18n.[TimeframeComments], s.[TimeframeComments])
			END AS [TimeframeComments],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[LawsComments]
				ELSE ISNULL(s_i18n.[LawsComments], s.[LawsComments])
			END AS [LawsComments],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[AdditionalInfo]
				ELSE ISNULL(s_i18n.[AdditionalInfo], s.[AdditionalInfo])
			END AS [AdditionalInfo]
			,claw.[Id] as [Contact_Law_Id]
			,CASE
				WHEN claw.lang = @langPrincipal THEN claw.[Name]
				ELSE ISNULL(claw_i18n.[Name], claw.[Name])
			END AS [Contact_Law_Name]
			,CASE
				WHEN claw.lang = @langPrincipal THEN claw.[Description]
				ELSE ISNULL(claw_i18n.[Description], claw.[Description])
			END AS [Contact_Law_Description]
			,CASE 
				WHEN s.lang = @langPrincipal THEN s.[Contact_Articles]
				ELSE ISNULL(s_i18n.[Contact_Articles], s.[Contact_Articles])
			END AS [Contact_Articles]
			,rlaw.[Id] as [Recourse_Law_Id]
			,CASE
				WHEN rlaw.lang = @langPrincipal THEN rlaw.[Name]
				ELSE ISNULL(rlaw_i18n.[Name], rlaw.[Name])
			END AS [Recourse_Law_Name]
			,CASE
				WHEN rlaw.lang = @langPrincipal THEN rlaw.[Description]
				ELSE ISNULL(rlaw_i18n.[Description], rlaw.[Description])
			END AS [Recourse_Law_Description]
			,CASE 
				WHEN s.lang = @langPrincipal THEN s.[Recourse_Articles]
				ELSE ISNULL(s_i18n.[Recourse_Articles], s.[Recourse_Articles])
			END AS [Recourse_Articles]
			,tlaw.[Id] as [Timeframe_Law_Id]
			,CASE
				WHEN tlaw.lang = @langPrincipal THEN tlaw.[Name]
				ELSE ISNULL(tlaw_i18n.[Name], tlaw.[Name])
			END AS [Timeframe_Law_Name]
			,CASE
				WHEN tlaw.lang = @langPrincipal THEN tlaw.[Description]
				ELSE ISNULL(tlaw_i18n.[Description], tlaw.[Description])
			END AS [Timeframe_Law_Description]
			,CASE 
				WHEN s.lang = @langPrincipal THEN s.[Timeframe_Articles]
				ELSE ISNULL(s_i18n.[Timeframe_Articles], s.[Timeframe_Articles])
			END AS [Timeframe_Articles],
			s.IsInternal,
			GetDate(),
			s.Level_Id,
			s.NumberOfUsers,
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[Summary]
				ELSE ISNULL(s_i18n.[Summary], s.[Summary])
			END AS [Summary]
	FROM 
		(SELECT l.code as lang, s.* FROM [Admin_Step] s WITH(NOLOCK), SystemLanguage l) s
			LEFT JOIN Admin_Step_i18n s_i18n WITH(NOLOCK) ON s.[lang] = s_i18n.[lang] and s.[Id] = s_i18n.[Parent_Id]
			LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) claw 
				ON s.Contact_Law_Id = claw.[Id] AND s.lang = claw.lang
						LEFT JOIN [Law_i18n] claw_i18n WITH(NOLOCK) 
							ON claw.[Id] = claw_i18n.[Parent_Id] AND claw.lang = claw_i18n.lang
			LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) rlaw 
				ON s.Recourse_Law_Id = rlaw.[Id] AND s.lang = rlaw.lang
						LEFT JOIN [Law_i18n] rlaw_i18n WITH(NOLOCK) 
							ON rlaw.[Id] = rlaw_i18n.[Parent_Id] AND rlaw.lang = rlaw_i18n.lang
			LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) tlaw 
				ON s.Timeframe_Law_Id = tlaw.[Id] AND s.lang = tlaw.lang
						LEFT JOIN [Law_i18n] tlaw_i18n WITH(NOLOCK) 
							ON tlaw.[Id] = tlaw_i18n.[Parent_Id] AND tlaw.lang = tlaw_i18n.lang
			LEFT JOIN (SELECT l.code as lang, eic.* FROM SystemLanguage l, [dbo].[EntityInCharge] eic WITH(NOLOCK)) ceic
				ON s.CertificationEntityInCharge_Id = ceic.[Id] AND s.lang = ceic.lang
					LEFT JOIN [EntityInCharge_i18n] ceic_i18n WITH(NOLOCK)
						ON ceic.[Id] = ceic_i18n.[Parent_Id] AND ceic.lang = ceic_i18n.lang
	WHERE s.[Id] = @stepId
	AND ISNULL(claw.deleted, 0) = 0
	AND ISNULL(rlaw.deleted, 0) = 0
	AND ISNULL(tlaw.deleted, 0) = 0
	AND ISNULL(ceic.deleted, 0) = 0
	
	EXEC sp_take_snapshot_step @registryId, @objectiveId, @blockId, @stepId	
	
	
	FETCH NEXT FROM step_cursor 
	INTO @blockId, @stepId, @stepOrder, @stepIsParallele, @stepIsAlternative
END
CLOSE step_cursor
DEALLOCATE step_cursor

SET NOCOUNT OFF
END
GO

-- =============================================
-- Category 6: Major structural
-- Procedure: sp_take_snapshot_step
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_take_snapshot_step' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_take_snapshot_step]
GO
CREATE PROCEDURE [dbo].[sp_take_snapshot_step]  
(  
 @registryId int,  
 @objectiveId int,  
 @blockId int,   
 @stepId int  
)  
AS  
BEGIN  
   
DECLARE @langPrincipal varchar(2)  
SET @langPrincipal = (SELECT TOP 1 code FROM SystemLanguage WHERE IsPrincipal = 1)  
  
-- add the attachments of step  
INSERT INTO [dbo].[Snapshot_Object_Media]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Lang]  
       ,[Object_Id],[Type],[Order]  
       ,[Media_Id]  
       ,[Media_Name]  
       ,[Media_FileName],[Media_Extention]  
       ,[Media_Length],[Media_PreviewImageName], [Media_IsDocumentPresent])  
SELECT @registryId, @objectiveId, @blockId, @stepId, m.lang,  
  om.[Object_Id], om.[Type], om.[Order],  
  m.Id,   
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[Name]  
   ELSE ISNULL(m_i18n.[Name], m.[Name])  
  END AS [Media_Name],  
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[FileName]  
   ELSE ISNULL(m_i18n.[FileName], m.[FileName])  
  END AS [Media_FileName],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Extention]  
    ELSE ISNULL(m_i18n.[Extention], m.[Extention])  
  END AS [Media_Extention],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Length]  
    ELSE ISNULL(m_i18n.[Length], m.[Length])  
  END AS [Media_Length],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[PreviewImageName]  
    ELSE ISNULL(m_i18n.[PreviewImageName], m.[PreviewImageName])  
  END AS [Media_PreviewImageName],
  m.[IsDocumentPresent]  
FROM Admin_Object_Media om WITH(NOLOCK)  
 INNER JOIN (SELECT l.code as lang, m.* FROM SystemLanguage l, Media m WITH(NOLOCK)) m ON om.[Media_Id] = m.[Id]  
     LEFT JOIN Media_i18n m_i18n WITH(NOLOCK) ON m.[Id] = m_i18n.[Media_Id] and m.lang = m_i18n.lang   
WHERE om.[Object_Id] = @stepId  
AND om.[Type] in ('ContactSection', 'CostSection', 'TimeframeSection', 'AdditionalInfo', 'Certification', 'Recourse')  
   
-- add the stepEntityInCharge  
INSERT INTO [dbo].[Snapshot_StepEntityInCharge]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Id],[Lang]  
       ,[Name]  
       ,[Address]  
       ,[City]  
       ,[PostalCode]  
       ,[CountryCode]  
       ,[Phone1]  
       ,[Phone2]  
	   ,[GoogleMapsURL] 
       ,[Fax1]  
       ,[Fax2]  
       ,[Email1]  
       ,[Email2]  
       ,[Website1]  
       ,[Website2]  
       ,[Image]  
       ,[ScheduleDay1MorningStart]  
       ,[ScheduleDay1MorningEnd]  
       ,[ScheduleDay1EveningStart]  
       ,[ScheduleDay1EveningEnd]  
       ,[ScheduleDay1IsClosed]  
       ,[ScheduleDay1IsNotAvailable]  
       ,[ScheduleDay2MorningStart]  
       ,[ScheduleDay2MorningEnd]  
       ,[ScheduleDay2EveningStart]  
       ,[ScheduleDay2EveningEnd]  
       ,[ScheduleDay2IsClosed]  
       ,[ScheduleDay2IsNotAvailable]  
       ,[ScheduleDay3MorningStart]  
       ,[ScheduleDay3MorningEnd]  
       ,[ScheduleDay3EveningStart]  
       ,[ScheduleDay3EveningEnd]  
       ,[ScheduleDay3IsClosed]  
       ,[ScheduleDay3IsNotAvailable]  
       ,[ScheduleDay4MorningStart]  
       ,[ScheduleDay4MorningEnd]  
       ,[ScheduleDay4EveningStart]  
       ,[ScheduleDay4EveningEnd]  
       ,[ScheduleDay4IsClosed]  
       ,[ScheduleDay4IsNotAvailable]  
       ,[ScheduleDay5MorningStart]  
       ,[ScheduleDay5MorningEnd]  
       ,[ScheduleDay5EveningStart]  
       ,[ScheduleDay5EveningEnd]  
       ,[ScheduleDay5IsClosed]  
       ,[ScheduleDay5IsNotAvailable]  
       ,[ScheduleDay6MorningStart]  
       ,[ScheduleDay6MorningEnd]  
       ,[ScheduleDay6EveningStart]  
       ,[ScheduleDay6EveningEnd]  
       ,[ScheduleDay6IsClosed]  
       ,[ScheduleDay6IsNotAvailable]  
       ,[ScheduleDay7MorningStart]  
       ,[ScheduleDay7MorningEnd]  
       ,[ScheduleDay7EveningStart]  
       ,[ScheduleDay7EveningEnd]  
       ,[ScheduleDay7IsClosed]  
       ,[ScheduleDay7IsNotAvailable]  
       ,[ScheduleComments]
	   ,[IsOnline]
	   ,[Zone_Id])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, eic.[Id], eic.[lang]  
    ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Name]  
   ELSE ISNULL(eic_i18n.[Name], eic.[Name])  
  END AS [Name]  
    ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Address]  
   ELSE ISNULL(eic_i18n.[Address], eic.[Address])  
  END AS [Address]  
    ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[City]  
   ELSE ISNULL(eic_i18n.[City], eic.[City])  
  END AS [City]  
    ,[PostalCode]  
   ,[CountryCode]  
   ,[Phone1]  
   ,[Phone2]  
   ,[GoogleMapsURL]
   ,[Fax1]  
   ,[Fax2]  
   ,[Email1]  
   ,[Email2]  
   ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Website1]  
   ELSE ISNULL(eic_i18n.[Website1], eic.[Website1])  
  END AS [Website1]  
   ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Website2]  
   ELSE ISNULL(eic_i18n.[Website2], eic.[Website2])  
  END AS [Website2]  
   ,[Image]  
   ,[ScheduleDay1MorningStart]  
   ,[ScheduleDay1MorningEnd]  
   ,[ScheduleDay1EveningStart]  
   ,[ScheduleDay1EveningEnd]  
   ,[ScheduleDay1IsClosed]  
   ,[ScheduleDay1IsNotAvailable]  
   ,[ScheduleDay2MorningStart]  
   ,[ScheduleDay2MorningEnd]  
   ,[ScheduleDay2EveningStart]  
   ,[ScheduleDay2EveningEnd]  
   ,[ScheduleDay2IsClosed]  
   ,[ScheduleDay2IsNotAvailable]  
   ,[ScheduleDay3MorningStart]  
   ,[ScheduleDay3MorningEnd]  
   ,[ScheduleDay3EveningStart]  
   ,[ScheduleDay3EveningEnd]  
   ,[ScheduleDay3IsClosed]  
   ,[ScheduleDay3IsNotAvailable]  
   ,[ScheduleDay4MorningStart]  
   ,[ScheduleDay4MorningEnd]  
   ,[ScheduleDay4EveningStart]  
   ,[ScheduleDay4EveningEnd]  
   ,[ScheduleDay4IsClosed]  
   ,[ScheduleDay4IsNotAvailable]  
   ,[ScheduleDay5MorningStart]  
   ,[ScheduleDay5MorningEnd]  
   ,[ScheduleDay5EveningStart]  
   ,[ScheduleDay5EveningEnd]  
   ,[ScheduleDay5IsClosed]  
   ,[ScheduleDay5IsNotAvailable]  
   ,[ScheduleDay6MorningStart]  
   ,[ScheduleDay6MorningEnd]  
   ,[ScheduleDay6EveningStart]  
   ,[ScheduleDay6EveningEnd]  
   ,[ScheduleDay6IsClosed]  
   ,[ScheduleDay6IsNotAvailable]  
   ,[ScheduleDay7MorningStart]  
   ,[ScheduleDay7MorningEnd]  
   ,[ScheduleDay7EveningStart]  
   ,[ScheduleDay7EveningEnd]  
   ,[ScheduleDay7IsClosed]  
   ,[ScheduleDay7IsNotAvailable]  
   ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[ScheduleComments]  
   ELSE ISNULL(eic_i18n.[ScheduleComments], eic.[ScheduleComments])  
    END AS [ScheduleComments]  
   ,eic.[IsOnline]
   ,[Zone_Id]   
  FROM (SELECT l.code as lang, eic.* FROM SystemLanguage l, [dbo].[EntityInCharge] eic WITH(NOLOCK)) eic  
  LEFT JOIN EntityInCharge_i18n eic_i18n WITH(NOLOCK) on eic.[Id] = eic_i18n.[Parent_Id] AND eic.[Lang] = eic_i18n.[Lang]   
  INNER JOIN Admin_Step s WITH(NOLOCK) on eic.[Id] = s.[EntityInCharge_Id]  
  WHERE s.Id = @stepId  
 AND ISNULL(eic.[Deleted], 0) = 0  
 
 -- add recourseEntity in charge
INSERT INTO [dbo].[Snapshot_StepRecourseEntityInCharge]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Id],[Lang]  
       ,[Name]  
       ,[Address]  
       ,[City]  
       ,[PostalCode]  
       ,[CountryCode]  
       ,[Phone1]  
       ,[Phone2]  
	   ,[GoogleMapsURL]
       ,[Fax1]  
       ,[Fax2]  
       ,[Email1]  
       ,[Email2]  
       ,[Website1]  
       ,[Website2]  
       ,[Image]  
       ,[ScheduleDay1MorningStart]  
       ,[ScheduleDay1MorningEnd]  
       ,[ScheduleDay1EveningStart]  
       ,[ScheduleDay1EveningEnd]  
       ,[ScheduleDay1IsClosed]  
       ,[ScheduleDay1IsNotAvailable]  
       ,[ScheduleDay2MorningStart]  
       ,[ScheduleDay2MorningEnd]  
       ,[ScheduleDay2EveningStart]  
       ,[ScheduleDay2EveningEnd]  
       ,[ScheduleDay2IsClosed]  
       ,[ScheduleDay2IsNotAvailable]  
       ,[ScheduleDay3MorningStart]  
       ,[ScheduleDay3MorningEnd]  
       ,[ScheduleDay3EveningStart]  
       ,[ScheduleDay3EveningEnd]  
       ,[ScheduleDay3IsClosed]  
       ,[ScheduleDay3IsNotAvailable]  
       ,[ScheduleDay4MorningStart]  
       ,[ScheduleDay4MorningEnd]  
       ,[ScheduleDay4EveningStart]  
       ,[ScheduleDay4EveningEnd]  
       ,[ScheduleDay4IsClosed]  
       ,[ScheduleDay4IsNotAvailable]  
       ,[ScheduleDay5MorningStart]  
       ,[ScheduleDay5MorningEnd]  
       ,[ScheduleDay5EveningStart]  
       ,[ScheduleDay5EveningEnd]  
       ,[ScheduleDay5IsClosed]  
       ,[ScheduleDay5IsNotAvailable]  
       ,[ScheduleDay6MorningStart]  
       ,[ScheduleDay6MorningEnd]  
       ,[ScheduleDay6EveningStart]  
       ,[ScheduleDay6EveningEnd]  
       ,[ScheduleDay6IsClosed]  
       ,[ScheduleDay6IsNotAvailable]  
       ,[ScheduleDay7MorningStart]  
       ,[ScheduleDay7MorningEnd]  
       ,[ScheduleDay7EveningStart]  
       ,[ScheduleDay7EveningEnd]  
       ,[ScheduleDay7IsClosed]  
       ,[ScheduleDay7IsNotAvailable]  
       ,[ScheduleComments]
	   ,[IsOnline]
	   ,[Zone_Id])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, eic.[Id], eic.[lang]  
    ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Name]  
   ELSE ISNULL(eic_i18n.[Name], eic.[Name])  
  END AS [Name]  
    ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Address]  
   ELSE ISNULL(eic_i18n.[Address], eic.[Address])  
  END AS [Address]  
    ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[City]  
   ELSE ISNULL(eic_i18n.[City], eic.[City])  
  END AS [City]  
    ,[PostalCode]  
   ,[CountryCode]  
   ,[Phone1]  
   ,[Phone2]  
   ,[GoogleMapsURL]
   ,[Fax1]  
   ,[Fax2]  
   ,[Email1]  
   ,[Email2]  
   ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Website1]  
   ELSE ISNULL(eic_i18n.[Website1], eic.[Website1])  
  END AS [Website1]  
   ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Website2]  
   ELSE ISNULL(eic_i18n.[Website2], eic.[Website2])  
  END AS [Website2]  
   ,[Image]  
   ,[ScheduleDay1MorningStart]  
   ,[ScheduleDay1MorningEnd]  
   ,[ScheduleDay1EveningStart]  
   ,[ScheduleDay1EveningEnd]  
   ,[ScheduleDay1IsClosed]  
   ,[ScheduleDay1IsNotAvailable]  
   ,[ScheduleDay2MorningStart]  
   ,[ScheduleDay2MorningEnd]  
   ,[ScheduleDay2EveningStart]  
   ,[ScheduleDay2EveningEnd]  
   ,[ScheduleDay2IsClosed]  
   ,[ScheduleDay2IsNotAvailable]  
   ,[ScheduleDay3MorningStart]  
   ,[ScheduleDay3MorningEnd]  
   ,[ScheduleDay3EveningStart]  
   ,[ScheduleDay3EveningEnd]  
   ,[ScheduleDay3IsClosed]  
   ,[ScheduleDay3IsNotAvailable]  
   ,[ScheduleDay4MorningStart]  
   ,[ScheduleDay4MorningEnd]  
   ,[ScheduleDay4EveningStart]  
   ,[ScheduleDay4EveningEnd]  
   ,[ScheduleDay4IsClosed]  
   ,[ScheduleDay4IsNotAvailable]  
   ,[ScheduleDay5MorningStart]  
   ,[ScheduleDay5MorningEnd]  
   ,[ScheduleDay5EveningStart]  
   ,[ScheduleDay5EveningEnd]  
   ,[ScheduleDay5IsClosed]  
   ,[ScheduleDay5IsNotAvailable]  
   ,[ScheduleDay6MorningStart]  
   ,[ScheduleDay6MorningEnd]  
   ,[ScheduleDay6EveningStart]  
   ,[ScheduleDay6EveningEnd]  
   ,[ScheduleDay6IsClosed]  
   ,[ScheduleDay6IsNotAvailable]  
   ,[ScheduleDay7MorningStart]  
   ,[ScheduleDay7MorningEnd]  
   ,[ScheduleDay7EveningStart]  
   ,[ScheduleDay7EveningEnd]  
   ,[ScheduleDay7IsClosed]  
   ,[ScheduleDay7IsNotAvailable]  
   ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[ScheduleComments]  
   ELSE ISNULL(eic_i18n.[ScheduleComments], eic.[ScheduleComments])  
    END AS [ScheduleComments]   
   ,eic.[IsOnline]
   ,[Zone_Id]   
  FROM (SELECT l.code as lang, eic.* FROM SystemLanguage l, [dbo].[EntityInCharge] eic WITH(NOLOCK)) eic  
  LEFT JOIN EntityInCharge_i18n eic_i18n WITH(NOLOCK) on eic.[Id] = eic_i18n.[Parent_Id] AND eic.[Lang] = eic_i18n.[Lang]   
  INNER JOIN Admin_Step s WITH(NOLOCK) on eic.[Id] = s.[Recourse_EntityInCharge_Id]  
  WHERE s.Id = @stepId  
 AND ISNULL(eic.[Deleted], 0) = 0  
   
-- add regional entities in charge
INSERT INTO [dbo].[Snapshot_StepRegionalEntityInCharge]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Id],[Lang]
	   ,[Region_Id]
	   ,[Region_Name]
       ,[Name]  
       ,[Address]  
       ,[City]  
       ,[PostalCode]  
       ,[CountryCode]  
       ,[Phone1]  
       ,[Phone2]  
       ,[Fax1]  
       ,[Fax2]  
       ,[Email1]  
       ,[Email2]  
       ,[Website1]  
       ,[Website2]  
       ,[Image]  
       ,[ScheduleDay1MorningStart]  
       ,[ScheduleDay1MorningEnd]  
       ,[ScheduleDay1EveningStart]  
       ,[ScheduleDay1EveningEnd]  
       ,[ScheduleDay1IsClosed]  
       ,[ScheduleDay1IsNotAvailable]  
       ,[ScheduleDay2MorningStart]  
       ,[ScheduleDay2MorningEnd]  
       ,[ScheduleDay2EveningStart]  
       ,[ScheduleDay2EveningEnd]  
       ,[ScheduleDay2IsClosed]  
       ,[ScheduleDay2IsNotAvailable]  
       ,[ScheduleDay3MorningStart]  
       ,[ScheduleDay3MorningEnd]  
       ,[ScheduleDay3EveningStart]  
       ,[ScheduleDay3EveningEnd]  
       ,[ScheduleDay3IsClosed]  
       ,[ScheduleDay3IsNotAvailable]  
       ,[ScheduleDay4MorningStart]  
       ,[ScheduleDay4MorningEnd]  
       ,[ScheduleDay4EveningStart]  
       ,[ScheduleDay4EveningEnd]  
       ,[ScheduleDay4IsClosed]  
       ,[ScheduleDay4IsNotAvailable]  
       ,[ScheduleDay5MorningStart]  
       ,[ScheduleDay5MorningEnd]  
       ,[ScheduleDay5EveningStart]  
       ,[ScheduleDay5EveningEnd]  
       ,[ScheduleDay5IsClosed]  
       ,[ScheduleDay5IsNotAvailable]  
       ,[ScheduleDay6MorningStart]  
       ,[ScheduleDay6MorningEnd]  
       ,[ScheduleDay6EveningStart]  
       ,[ScheduleDay6EveningEnd]  
       ,[ScheduleDay6IsClosed]  
       ,[ScheduleDay6IsNotAvailable]  
       ,[ScheduleDay7MorningStart]  
       ,[ScheduleDay7MorningEnd]  
       ,[ScheduleDay7EveningStart]  
       ,[ScheduleDay7EveningEnd]  
       ,[ScheduleDay7IsClosed]  
       ,[ScheduleDay7IsNotAvailable]  
       ,[ScheduleComments]
	   ,[Zone_Id])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, eic.[Id], eic.[lang]
	 ,op.Value as [Region_id]
	 ,CASE   
		WHEN eic.lang = @langPrincipal THEN op.[Text]  
		ELSE ISNULL(op_i18n.[Text], op.[Text]) 
		END AS [Region_Name]   
    ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Name]  
   ELSE ISNULL(eic_i18n.[Name], eic.[Name])  
  END AS [Name]  
    ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Address]  
   ELSE ISNULL(eic_i18n.[Address], eic.[Address])  
  END AS [Address]  
    ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[City]  
   ELSE ISNULL(eic_i18n.[City], eic.[City])  
  END AS [City]  
    ,[PostalCode]  
   ,[CountryCode]  
   ,[Phone1]  
   ,[Phone2]  
   ,[Fax1]  
   ,[Fax2]  
   ,[Email1]  
   ,[Email2]  
   ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Website1]  
   ELSE ISNULL(eic_i18n.[Website1], eic.[Website1])  
  END AS [Website1]  
   ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[Website2]  
   ELSE ISNULL(eic_i18n.[Website2], eic.[Website2])  
  END AS [Website2]  
   ,[Image]  
   ,[ScheduleDay1MorningStart]  
   ,[ScheduleDay1MorningEnd]  
   ,[ScheduleDay1EveningStart]  
   ,[ScheduleDay1EveningEnd]  
   ,[ScheduleDay1IsClosed]  
   ,[ScheduleDay1IsNotAvailable]  
   ,[ScheduleDay2MorningStart]  
   ,[ScheduleDay2MorningEnd]  
   ,[ScheduleDay2EveningStart]  
   ,[ScheduleDay2EveningEnd]  
   ,[ScheduleDay2IsClosed]  
   ,[ScheduleDay2IsNotAvailable]  
   ,[ScheduleDay3MorningStart]  
   ,[ScheduleDay3MorningEnd]  
   ,[ScheduleDay3EveningStart]  
   ,[ScheduleDay3EveningEnd]  
   ,[ScheduleDay3IsClosed]  
   ,[ScheduleDay3IsNotAvailable]  
   ,[ScheduleDay4MorningStart]  
   ,[ScheduleDay4MorningEnd]  
   ,[ScheduleDay4EveningStart]  
   ,[ScheduleDay4EveningEnd]  
   ,[ScheduleDay4IsClosed]  
   ,[ScheduleDay4IsNotAvailable]  
   ,[ScheduleDay5MorningStart]  
   ,[ScheduleDay5MorningEnd]  
   ,[ScheduleDay5EveningStart]  
   ,[ScheduleDay5EveningEnd]  
   ,[ScheduleDay5IsClosed]  
   ,[ScheduleDay5IsNotAvailable]  
   ,[ScheduleDay6MorningStart]  
   ,[ScheduleDay6MorningEnd]  
   ,[ScheduleDay6EveningStart]  
   ,[ScheduleDay6EveningEnd]  
   ,[ScheduleDay6IsClosed]  
   ,[ScheduleDay6IsNotAvailable]  
   ,[ScheduleDay7MorningStart]  
   ,[ScheduleDay7MorningEnd]  
   ,[ScheduleDay7EveningStart]  
   ,[ScheduleDay7EveningEnd]  
   ,[ScheduleDay7IsClosed]  
   ,[ScheduleDay7IsNotAvailable]  
   ,CASE   
   WHEN eic.lang = @langPrincipal THEN eic.[ScheduleComments]  
   ELSE ISNULL(eic_i18n.[ScheduleComments], eic.[ScheduleComments])  
    END AS [ScheduleComments]
   ,[Zone_Id]      
  FROM (SELECT l.code as lang, eic.* FROM SystemLanguage l, [dbo].[EntityInCharge] eic WITH(NOLOCK)) eic  
  LEFT JOIN EntityInCharge_i18n eic_i18n WITH(NOLOCK) on eic.[Id] = eic_i18n.[Parent_Id] AND eic.[Lang] = eic_i18n.[Lang]   
  INNER JOIN Admin_StepRegionalEntityInCharge s WITH(NOLOCK) on eic.[Id] = s.[EntityInCharge_Id] 
  INNER JOIN [Option] op   WITH(NOLOCK) on s.[Region_Id] = op.[Value] and op.[Type] = 'Regions'
  LEFT JOIN [Option_i18n] op_i18n WITH(NOLOCK) on op.[Id] = op_i18n.[OptionId] and eic.[Lang] = op_i18n.[Lang] 
  WHERE s.Step_id = @stepId  
 AND ISNULL(eic.[Deleted], 0) = 0  

-- add the attachments of the entities in charge  
INSERT INTO [dbo].[Snapshot_Object_Media]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Lang]  
       ,[Object_Id],[Type],[Order]  
       ,[Media_Id]  
       ,[Media_Name]  
       ,[Media_FileName],[Media_Extention]  
       ,[Media_Length],[Media_PreviewImageName], [Media_IsDocumentPresent])  
SELECT @registryId, @objectiveId, @blockId, @stepId, m.lang,  
  om.[Object_Id], om.[Type], om.[Order],  
  m.Id,   
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[Name]  
   ELSE ISNULL(m_i18n.[Name], m.[Name])  
  END AS [Media_Name],  
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[FileName]  
   ELSE ISNULL(m_i18n.[FileName], m.[FileName])  
  END AS [Media_FileName],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Extention]  
    ELSE ISNULL(m_i18n.[Extention], m.[Extention])  
  END AS [Media_Extention],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Length]  
    ELSE ISNULL(m_i18n.[Length], m.[Length])  
  END AS [Media_Length],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[PreviewImageName]  
    ELSE ISNULL(m_i18n.[PreviewImageName], m.[PreviewImageName])  
  END AS [Media_PreviewImageName],
  m.[IsDocumentPresent] 
FROM Admin_Object_Media om WITH(NOLOCK)  
 INNER JOIN (SELECT l.code as lang, m.* FROM SystemLanguage l, Media m WITH(NOLOCK)) m ON om.[Media_Id] = m.[Id]  
     LEFT JOIN Media_i18n m_i18n WITH(NOLOCK) ON m.[Id] = m_i18n.[Media_Id] and m.lang = m_i18n.lang 
 INNER JOIN Admin_Step s WITH(NOLOCK) ON s.Id = @stepId
 INNER JOIN [dbo].[EntityInCharge] eic WITH(NOLOCK) ON eic.[Id] = s.[EntityInCharge_Id]
WHERE om.[Object_Id] = eic.[Id]  
AND om.[Type] LIKE 'EntityInCharge'  
AND ISNULL(eic.[Deleted], 0) = 0


-- add the UnitInCharge  
INSERT INTO [dbo].[Snapshot_StepUnitInCharge]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Id],[Lang]  
       ,[Name]  
       ,[Image]  
       ,[ScheduleIsInherited]  
       ,[ScheduleDay1MorningStart]  
       ,[ScheduleDay1MorningEnd]  
       ,[ScheduleDay1EveningStart]  
       ,[ScheduleDay1EveningEnd]  
       ,[ScheduleDay1IsClosed]  
       ,[ScheduleDay1IsNotAvailable]  
       ,[ScheduleDay2MorningStart]  
       ,[ScheduleDay2MorningEnd]  
       ,[ScheduleDay2EveningStart]  
       ,[ScheduleDay2EveningEnd]  
       ,[ScheduleDay2IsClosed]  
       ,[ScheduleDay2IsNotAvailable]  
       ,[ScheduleDay3MorningStart]  
       ,[ScheduleDay3MorningEnd]  
       ,[ScheduleDay3EveningStart]  
       ,[ScheduleDay3EveningEnd]  
       ,[ScheduleDay3IsClosed]  
       ,[ScheduleDay3IsNotAvailable]  
       ,[ScheduleDay4MorningStart]  
       ,[ScheduleDay4MorningEnd]  
       ,[ScheduleDay4EveningStart]  
       ,[ScheduleDay4EveningEnd]  
       ,[ScheduleDay4IsClosed]  
       ,[ScheduleDay4IsNotAvailable]  
       ,[ScheduleDay5MorningStart]  
       ,[ScheduleDay5MorningEnd]  
       ,[ScheduleDay5EveningStart]  
       ,[ScheduleDay5EveningEnd]  
       ,[ScheduleDay5IsClosed]  
       ,[ScheduleDay5IsNotAvailable]  
       ,[ScheduleDay6MorningStart]  
       ,[ScheduleDay6MorningEnd]  
       ,[ScheduleDay6EveningStart]  
       ,[ScheduleDay6EveningEnd]  
       ,[ScheduleDay6IsClosed]  
       ,[ScheduleDay6IsNotAvailable]  
       ,[ScheduleDay7MorningStart]  
       ,[ScheduleDay7MorningEnd]  
       ,[ScheduleDay7EveningStart]  
       ,[ScheduleDay7EveningEnd]  
       ,[ScheduleDay7IsClosed]  
       ,[ScheduleDay7IsNotAvailable]  
       ,[ScheduleComments]
       ,[Website])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, uic.[Id], uic.[lang]  
   ,CASE   
   WHEN uic.lang = @langPrincipal THEN uic.[Name]  
   ELSE ISNULL(uic_i18n.[Name], uic.[Name])  
    END AS [Name]  
   ,[Image]  
   ,[ScheduleIsInherited]  
   ,[ScheduleDay1MorningStart]  
   ,[ScheduleDay1MorningEnd]  
   ,[ScheduleDay1EveningStart]  
   ,[ScheduleDay1EveningEnd]  
   ,[ScheduleDay1IsClosed]  
   ,[ScheduleDay1IsNotAvailable]  
   ,[ScheduleDay2MorningStart]  
   ,[ScheduleDay2MorningEnd]  
   ,[ScheduleDay2EveningStart]  
   ,[ScheduleDay2EveningEnd]  
   ,[ScheduleDay2IsClosed]  
   ,[ScheduleDay2IsNotAvailable]  
   ,[ScheduleDay3MorningStart]  
   ,[ScheduleDay3MorningEnd]  
   ,[ScheduleDay3EveningStart]  
   ,[ScheduleDay3EveningEnd]  
   ,[ScheduleDay3IsClosed]  
   ,[ScheduleDay3IsNotAvailable]  
   ,[ScheduleDay4MorningStart]  
   ,[ScheduleDay4MorningEnd]  
   ,[ScheduleDay4EveningStart]  
   ,[ScheduleDay4EveningEnd]  
   ,[ScheduleDay4IsClosed]  
   ,[ScheduleDay4IsNotAvailable]  
   ,[ScheduleDay5MorningStart]  
   ,[ScheduleDay5MorningEnd]  
   ,[ScheduleDay5EveningStart]  
   ,[ScheduleDay5EveningEnd]  
   ,[ScheduleDay5IsClosed]  
   ,[ScheduleDay5IsNotAvailable]  
   ,[ScheduleDay6MorningStart]  
   ,[ScheduleDay6MorningEnd]  
   ,[ScheduleDay6EveningStart]  
   ,[ScheduleDay6EveningEnd]  
   ,[ScheduleDay6IsClosed]  
   ,[ScheduleDay6IsNotAvailable]  
   ,[ScheduleDay7MorningStart]  
   ,[ScheduleDay7MorningEnd]  
   ,[ScheduleDay7EveningStart]  
   ,[ScheduleDay7EveningEnd]  
   ,[ScheduleDay7IsClosed]  
   ,[ScheduleDay7IsNotAvailable]  
   ,CASE   
   WHEN uic.lang = @langPrincipal THEN uic.[ScheduleComments]  
   ELSE ISNULL(uic_i18n.[ScheduleComments], uic.[ScheduleComments])  
    END AS [ScheduleComments]
  ,CASE   
   WHEN uic.lang = @langPrincipal THEN uic.[Website]  
   ELSE ISNULL(uic_i18n.[Website], uic.[Website])  
    END AS [Website]    
  FROM (SELECT l.code as lang, uic.* FROM SystemLanguage l, [dbo].[UnitInCharge] uic WITH(NOLOCK)) uic  
  LEFT JOIN UnitInCharge_i18n uic_i18n WITH(NOLOCK) on uic.[Id] = uic_i18n.[Parent_Id] AND uic.[Lang] = uic_i18n.[Lang]   
  INNER JOIN Admin_Step s WITH(NOLOCK) on uic.[Id] = s.[UnitInCharge_Id]  
  WHERE s.Id = @stepId  
 AND ISNULL(uic.[Deleted], 0) = 0  

 -- add the recourse unit in charge
INSERT INTO [dbo].[Snapshot_StepRecourseUnitInCharge]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Id],[Lang]  
       ,[Name]  
       ,[Image]  
       ,[ScheduleIsInherited]  
       ,[ScheduleDay1MorningStart]  
       ,[ScheduleDay1MorningEnd]  
       ,[ScheduleDay1EveningStart]  
       ,[ScheduleDay1EveningEnd]  
       ,[ScheduleDay1IsClosed]  
       ,[ScheduleDay1IsNotAvailable]  
       ,[ScheduleDay2MorningStart]  
       ,[ScheduleDay2MorningEnd]  
       ,[ScheduleDay2EveningStart]  
       ,[ScheduleDay2EveningEnd]  
       ,[ScheduleDay2IsClosed]  
       ,[ScheduleDay2IsNotAvailable]  
       ,[ScheduleDay3MorningStart]  
       ,[ScheduleDay3MorningEnd]  
       ,[ScheduleDay3EveningStart]  
       ,[ScheduleDay3EveningEnd]  
       ,[ScheduleDay3IsClosed]  
       ,[ScheduleDay3IsNotAvailable]  
       ,[ScheduleDay4MorningStart]  
       ,[ScheduleDay4MorningEnd]  
       ,[ScheduleDay4EveningStart]  
       ,[ScheduleDay4EveningEnd]  
       ,[ScheduleDay4IsClosed]  
       ,[ScheduleDay4IsNotAvailable]  
       ,[ScheduleDay5MorningStart]  
       ,[ScheduleDay5MorningEnd]  
       ,[ScheduleDay5EveningStart]  
       ,[ScheduleDay5EveningEnd]  
       ,[ScheduleDay5IsClosed]  
       ,[ScheduleDay5IsNotAvailable]  
       ,[ScheduleDay6MorningStart]  
       ,[ScheduleDay6MorningEnd]  
       ,[ScheduleDay6EveningStart]  
       ,[ScheduleDay6EveningEnd]  
       ,[ScheduleDay6IsClosed]  
       ,[ScheduleDay6IsNotAvailable]  
       ,[ScheduleDay7MorningStart]  
       ,[ScheduleDay7MorningEnd]  
       ,[ScheduleDay7EveningStart]  
       ,[ScheduleDay7EveningEnd]  
       ,[ScheduleDay7IsClosed]  
       ,[ScheduleDay7IsNotAvailable]  
       ,[ScheduleComments]
       ,[Website])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, uic.[Id], uic.[lang]  
   ,CASE   
   WHEN uic.lang = @langPrincipal THEN uic.[Name]  
   ELSE ISNULL(uic_i18n.[Name], uic.[Name])  
    END AS [Name]  
   ,[Image]  
   ,[ScheduleIsInherited]  
   ,[ScheduleDay1MorningStart]  
   ,[ScheduleDay1MorningEnd]  
   ,[ScheduleDay1EveningStart]  
   ,[ScheduleDay1EveningEnd]  
   ,[ScheduleDay1IsClosed]  
   ,[ScheduleDay1IsNotAvailable]  
   ,[ScheduleDay2MorningStart]  
   ,[ScheduleDay2MorningEnd]  
   ,[ScheduleDay2EveningStart]  
   ,[ScheduleDay2EveningEnd]  
   ,[ScheduleDay2IsClosed]  
   ,[ScheduleDay2IsNotAvailable]  
   ,[ScheduleDay3MorningStart]  
   ,[ScheduleDay3MorningEnd]  
   ,[ScheduleDay3EveningStart]  
   ,[ScheduleDay3EveningEnd]  
   ,[ScheduleDay3IsClosed]  
   ,[ScheduleDay3IsNotAvailable]  
   ,[ScheduleDay4MorningStart]  
   ,[ScheduleDay4MorningEnd]  
   ,[ScheduleDay4EveningStart]  
   ,[ScheduleDay4EveningEnd]  
   ,[ScheduleDay4IsClosed]  
   ,[ScheduleDay4IsNotAvailable]  
   ,[ScheduleDay5MorningStart]  
   ,[ScheduleDay5MorningEnd]  
   ,[ScheduleDay5EveningStart]  
   ,[ScheduleDay5EveningEnd]  
   ,[ScheduleDay5IsClosed]  
   ,[ScheduleDay5IsNotAvailable]  
   ,[ScheduleDay6MorningStart]  
   ,[ScheduleDay6MorningEnd]  
   ,[ScheduleDay6EveningStart]  
   ,[ScheduleDay6EveningEnd]  
   ,[ScheduleDay6IsClosed]  
   ,[ScheduleDay6IsNotAvailable]  
   ,[ScheduleDay7MorningStart]  
   ,[ScheduleDay7MorningEnd]  
   ,[ScheduleDay7EveningStart]  
   ,[ScheduleDay7EveningEnd]  
   ,[ScheduleDay7IsClosed]  
   ,[ScheduleDay7IsNotAvailable]  
   ,CASE   
   WHEN uic.lang = @langPrincipal THEN uic.[ScheduleComments]  
   ELSE ISNULL(uic_i18n.[ScheduleComments], uic.[ScheduleComments])  
    END AS [ScheduleComments] 
   ,CASE   
   WHEN uic.lang = @langPrincipal THEN uic.[Website]  
   ELSE ISNULL(uic_i18n.[Website], uic.[Website])  
    END AS [Website] 
  FROM (SELECT l.code as lang, uic.* FROM SystemLanguage l, [dbo].[UnitInCharge] uic WITH(NOLOCK)) uic  
  LEFT JOIN UnitInCharge_i18n uic_i18n WITH(NOLOCK) on uic.[Id] = uic_i18n.[Parent_Id] AND uic.[Lang] = uic_i18n.[Lang]   
  INNER JOIN Admin_Step s WITH(NOLOCK) on uic.[Id] = s.[Recourse_UnitInCharge_Id]  
  WHERE s.Id = @stepId  
 AND ISNULL(uic.[Deleted], 0) = 0  

-- add regional Unit in charge
INSERT INTO [dbo].[Snapshot_StepRegionalUnitInCharge]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Id],[Lang]
	   ,[Region_Id]
	   ,[Region_Name]
       ,[Name]  
       ,[Image]  
       ,[ScheduleIsInherited]  
       ,[ScheduleDay1MorningStart]  
       ,[ScheduleDay1MorningEnd]  
       ,[ScheduleDay1EveningStart]  
       ,[ScheduleDay1EveningEnd]  
       ,[ScheduleDay1IsClosed]  
       ,[ScheduleDay1IsNotAvailable]  
       ,[ScheduleDay2MorningStart]  
       ,[ScheduleDay2MorningEnd]  
       ,[ScheduleDay2EveningStart]  
       ,[ScheduleDay2EveningEnd]  
       ,[ScheduleDay2IsClosed]  
       ,[ScheduleDay2IsNotAvailable]  
       ,[ScheduleDay3MorningStart]  
       ,[ScheduleDay3MorningEnd]  
       ,[ScheduleDay3EveningStart]  
       ,[ScheduleDay3EveningEnd]  
       ,[ScheduleDay3IsClosed]  
       ,[ScheduleDay3IsNotAvailable]  
       ,[ScheduleDay4MorningStart]  
       ,[ScheduleDay4MorningEnd]  
       ,[ScheduleDay4EveningStart]  
       ,[ScheduleDay4EveningEnd]  
       ,[ScheduleDay4IsClosed]  
       ,[ScheduleDay4IsNotAvailable]  
       ,[ScheduleDay5MorningStart]  
       ,[ScheduleDay5MorningEnd]  
       ,[ScheduleDay5EveningStart]  
       ,[ScheduleDay5EveningEnd]  
       ,[ScheduleDay5IsClosed]  
       ,[ScheduleDay5IsNotAvailable]  
       ,[ScheduleDay6MorningStart]  
       ,[ScheduleDay6MorningEnd]  
       ,[ScheduleDay6EveningStart]  
       ,[ScheduleDay6EveningEnd]  
       ,[ScheduleDay6IsClosed]  
       ,[ScheduleDay6IsNotAvailable]  
       ,[ScheduleDay7MorningStart]  
       ,[ScheduleDay7MorningEnd]  
       ,[ScheduleDay7EveningStart]  
       ,[ScheduleDay7EveningEnd]  
       ,[ScheduleDay7IsClosed]  
       ,[ScheduleDay7IsNotAvailable]  
       ,[ScheduleComments]
       ,[Website])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, uic.[Id], uic.[lang]  
	,op.Value as [Region_id]
	,CASE   
		WHEN uic.lang = @langPrincipal THEN op.[Text]  
		ELSE ISNULL(op_i18n.[Text], op.[Text]) 
		END AS [Region_Name]   
   ,CASE   
   WHEN uic.lang = @langPrincipal THEN uic.[Name]  
   ELSE ISNULL(uic_i18n.[Name], uic.[Name])  
    END AS [Name]  
   ,[Image]  
   ,[ScheduleIsInherited]  
   ,[ScheduleDay1MorningStart]  
   ,[ScheduleDay1MorningEnd]  
   ,[ScheduleDay1EveningStart]  
   ,[ScheduleDay1EveningEnd]  
   ,[ScheduleDay1IsClosed]  
   ,[ScheduleDay1IsNotAvailable]  
   ,[ScheduleDay2MorningStart]  
   ,[ScheduleDay2MorningEnd]  
   ,[ScheduleDay2EveningStart]  
   ,[ScheduleDay2EveningEnd]  
   ,[ScheduleDay2IsClosed]  
   ,[ScheduleDay2IsNotAvailable]  
   ,[ScheduleDay3MorningStart]  
   ,[ScheduleDay3MorningEnd]  
   ,[ScheduleDay3EveningStart]  
   ,[ScheduleDay3EveningEnd]  
   ,[ScheduleDay3IsClosed]  
   ,[ScheduleDay3IsNotAvailable]  
   ,[ScheduleDay4MorningStart]  
   ,[ScheduleDay4MorningEnd]  
   ,[ScheduleDay4EveningStart]  
   ,[ScheduleDay4EveningEnd]  
   ,[ScheduleDay4IsClosed]  
   ,[ScheduleDay4IsNotAvailable]  
   ,[ScheduleDay5MorningStart]  
   ,[ScheduleDay5MorningEnd]  
   ,[ScheduleDay5EveningStart]  
   ,[ScheduleDay5EveningEnd]  
   ,[ScheduleDay5IsClosed]  
   ,[ScheduleDay5IsNotAvailable]  
   ,[ScheduleDay6MorningStart]  
   ,[ScheduleDay6MorningEnd]  
   ,[ScheduleDay6EveningStart]  
   ,[ScheduleDay6EveningEnd]  
   ,[ScheduleDay6IsClosed]  
   ,[ScheduleDay6IsNotAvailable]  
   ,[ScheduleDay7MorningStart]  
   ,[ScheduleDay7MorningEnd]  
   ,[ScheduleDay7EveningStart]  
   ,[ScheduleDay7EveningEnd]  
   ,[ScheduleDay7IsClosed]  
   ,[ScheduleDay7IsNotAvailable]  
   ,CASE   
   WHEN uic.lang = @langPrincipal THEN uic.[ScheduleComments]  
   ELSE ISNULL(uic_i18n.[ScheduleComments], uic.[ScheduleComments])  
    END AS [ScheduleComments]
   ,CASE   
   WHEN uic.lang = @langPrincipal THEN uic.[Website]  
   ELSE ISNULL(uic_i18n.[Website], uic.[Website])  
    END AS [Website]      
  FROM (SELECT l.code as lang, uic.* FROM SystemLanguage l, [dbo].[UnitInCharge] uic WITH(NOLOCK)) uic  
  LEFT JOIN UnitInCharge_i18n uic_i18n WITH(NOLOCK) on uic.[Id] = uic_i18n.[Parent_Id] AND uic.[Lang] = uic_i18n.[Lang]   
  INNER JOIN Admin_StepRegionalUnitInCharge s WITH(NOLOCK) on uic.[Id] = s.[UnitInCharge_Id]  
  INNER JOIN [Option] op   WITH(NOLOCK) on s.[Region_Id] = op.[Value] and op.[Type] = 'Regions'
  LEFT JOIN [Option_i18n] op_i18n WITH(NOLOCK) on op.[Id] = op_i18n.[OptionId] and uic.[Lang] = op_i18n.[Lang] 
  WHERE s.Step_Id = @stepId  
 AND ISNULL(uic.[Deleted], 0) = 0 
 
-- add personInCharge  
INSERT INTO [dbo].[Snapshot_StepPersonInCharge]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Id],[Lang]
       ,[Name]  
       ,[Profession]  
       ,[Phone1]  
       ,[Phone2]  
       ,[Email1]  
       ,[Email2]  
       ,[Image])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, pic.[Id], pic.[lang]

   ,CASE   
   WHEN pic.lang = @langPrincipal THEN pic.[Name]  
   ELSE ISNULL(pic_i18n.[Name], pic.[Name])  
    END AS [Name]  
   ,CASE   
   WHEN pic.lang = @langPrincipal THEN pic.[Profession]  
   ELSE ISNULL(pic_i18n.[Profession], pic.[Profession])  
    END AS [Profession]  
   ,[Phone1]  
   ,[Phone2]  
   ,[Email1]  
   ,[Email2]  
   ,[Image]      
FROM (SELECT l.code as lang, pic.* FROM SystemLanguage l, [dbo].[PersonInCharge] pic WITH(NOLOCK)) pic  
  LEFT JOIN PersonInCharge_i18n pic_i18n WITH(NOLOCK) on pic.[Id] = pic_i18n.[Parent_Id] AND pic.[Lang] = pic_i18n.[Lang]   
  INNER JOIN Admin_Step s WITH(NOLOCK) on pic.[Id] = s.[PersonInCharge_Id]
WHERE s.Id = @stepId  
 AND ISNULL(pic.[Deleted], 0) = 0  
 
 -- add recourse personInCharge  
INSERT INTO [dbo].[Snapshot_StepRecoursePersonInCharge]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Id],[Lang]
       ,[Name]  
       ,[Profession]  
       ,[Phone1]  
       ,[Phone2]  
       ,[Email1]  
       ,[Email2]  
       ,[Image])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, pic.[Id], pic.[lang]

   ,CASE   
   WHEN pic.lang = @langPrincipal THEN pic.[Name]  
   ELSE ISNULL(pic_i18n.[Name], pic.[Name])  
    END AS [Name]  
   ,CASE   
   WHEN pic.lang = @langPrincipal THEN pic.[Profession]  
   ELSE ISNULL(pic_i18n.[Profession], pic.[Profession])  
    END AS [Profession]  
   ,[Phone1]  
   ,[Phone2]  
   ,[Email1]  
   ,[Email2]  
   ,[Image]      
FROM (SELECT l.code as lang, pic.* FROM SystemLanguage l, [dbo].[PersonInCharge] pic WITH(NOLOCK)) pic  
  LEFT JOIN PersonInCharge_i18n pic_i18n WITH(NOLOCK) on pic.[Id] = pic_i18n.[Parent_Id] AND pic.[Lang] = pic_i18n.[Lang]   
  INNER JOIN Admin_Step s WITH(NOLOCK) on pic.[Id] = s.[Recourse_PersonInCharge_Id]
WHERE s.Id = @stepId  
 AND ISNULL(pic.[Deleted], 0) = 0  
 

 -- add regional person in charge  
INSERT INTO [dbo].[Snapshot_StepRegionalPersonInCharge]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Id],[Lang]
	   ,[Region_Id]
	   ,[Region_Name]
       ,[Name]  
       ,[Profession]  
       ,[Phone1]  
       ,[Phone2]  
       ,[Email1]  
       ,[Email2]  
       ,[Image])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, pic.[Id], pic.[lang]
 	, op.Value as Region_id
	, CASE   
		WHEN pic.lang = @langPrincipal THEN op.[Text]  
		ELSE ISNULL(op_i18n.[Text], op.[Text]) 
		END AS [Region_Name]    
   ,CASE   
   WHEN pic.lang = @langPrincipal THEN pic.[Name]  
   ELSE ISNULL(pic_i18n.[Name], pic.[Name])  
    END AS [Name]  
   ,CASE   
   WHEN pic.lang = @langPrincipal THEN pic.[Profession]  
   ELSE ISNULL(pic_i18n.[Profession], pic.[Profession])  
    END AS [Profession]  
   ,[Phone1]  
   ,[Phone2]  
   ,[Email1]  
   ,[Email2]  
   ,[Image]      
FROM (SELECT l.code as lang, pic.* FROM SystemLanguage l, [dbo].[PersonInCharge] pic WITH(NOLOCK)) pic  
  LEFT JOIN PersonInCharge_i18n pic_i18n WITH(NOLOCK) on pic.[Id] = pic_i18n.[Parent_Id] AND pic.[Lang] = pic_i18n.[Lang]   
  INNER JOIN Admin_StepRegionalPersonInCharge s WITH(NOLOCK) on pic.[Id] = s.[PersonInCharge_Id]
  INNER JOIN [Option] op   WITH(NOLOCK) on s.Region_Id = op.Value and op.Type = 'Regions'
  LEFT JOIN [Option_i18n] op_i18n WITH(NOLOCK) on op.Id = op_i18n.OptionId and pic.[Lang] = op_i18n.[Lang] 
WHERE s.Step_Id = @stepId  
 AND ISNULL(pic.[Deleted], 0) = 0  
  
-- insert StepResult  
INSERT INTO [dbo].[Snapshot_StepResult]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Order],[Id],[Lang]  
       ,[Name]  
       ,[NbOriginal]  
       ,[NbCopy]  
       ,[NbAuthenticated]  
       ,[Type]  
       ,[Law_Id]  
       ,[Law_Name]  
       ,[Law_Description]  
       ,[Articles]
	   ,[IsDocumentPresent],[Document_Id],[Document_Type])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, [Order], sr.[Id], sr.lang  
   ,CASE   
   WHEN sr.lang = @langPrincipal THEN sr.[Name]  
   ELSE ISNULL(sr_i18n.[Name], sr.[Name])  
    END AS [Name]  
   ,[NbOriginal]  
   ,[NbCopy]  
   ,[NbAuthenticated]  
   ,[Type]  
   ,law.[Id]  
   ,CASE  
   WHEN law.lang = @langPrincipal THEN law.[Name]  
   ELSE ISNULL(law_i18n.[Name], law.[Name])  
  END AS [Law_Name]  
   ,CASE  
   WHEN law.lang = @langPrincipal THEN law.[Description]  
   ELSE ISNULL(law_i18n.[Description], law.[Description])  
  END AS [Law_Description]  
   ,CASE   
   WHEN sr.lang = @langPrincipal THEN sr.[Articles]  
   ELSE ISNULL(sr_i18n.[Articles], sr.[Articles])  
    END AS [Articles]
	,sr.[IsDocumentPresent]
	, null, null   
  FROM (SELECT l.code as lang, sr.* FROM SystemLanguage l, [dbo].[Admin_StepResult] sr WITH(NOLOCK) ) sr  
 LEFT JOIN [Admin_StepResult_i18n] sr_i18n WITH(NOLOCK) ON sr.[Id] = sr_i18n.[StepResult_Id] AND sr.[lang] = sr_i18n.[lang]  
  LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) law   
   ON sr.Law_Id = law.[Id] AND sr.lang = law.lang  
     LEFT JOIN [Law_i18n] law_i18n WITH(NOLOCK)   
      ON law.[Id] = law_i18n.[Parent_Id] AND law.lang = law_i18n.lang  
  WHERE sr.[Step_Id] = @stepId and sr.Document_Id is null 
  AND ISNULL(law.[Deleted], 0) = 0  

  -- insert StepResult Attachments  
INSERT INTO [dbo].[Snapshot_Object_Media]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Lang]  
       ,[Object_Id],[Type],[Order]  
       ,[Media_Id]  
       ,[Media_Name]  
       ,[Media_FileName],[Media_Extention]  
       ,[Media_Length],[Media_PreviewImageName], [Media_IsDocumentPresent])  
SELECT @registryId, @objectiveId, @blockId, @stepId, m.lang,  
  om.[Object_Id], om.[Type], om.[Order],  
  m.Id,   
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[Name]  
   ELSE ISNULL(m_i18n.[Name], m.[Name])  
  END AS [Media_Name],  
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[FileName]  
   ELSE ISNULL(m_i18n.[FileName], m.[FileName])  
  END AS [Media_FileName],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Extention]  
    ELSE ISNULL(m_i18n.[Extention], m.[Extention])  
  END AS [Media_Extention],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Length]  
    ELSE ISNULL(m_i18n.[Length], m.[Length])  
  END AS [Media_Length],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[PreviewImageName]  
    ELSE ISNULL(m_i18n.[PreviewImageName], m.[PreviewImageName])  
  END AS [Media_PreviewImageName],
  m.[IsDocumentPresent] 
FROM Admin_Object_Media om WITH(NOLOCK)  
 INNER JOIN (SELECT l.code as lang, m.* FROM SystemLanguage l, Media m WITH(NOLOCK)) m ON om.[Media_Id] = m.[Id]  
     LEFT JOIN Media_i18n m_i18n WITH(NOLOCK) ON m.[Id] = m_i18n.[Media_Id] and m.lang = m_i18n.lang   
WHERE om.[Object_Id] in (SELECT [Id] FROM [dbo].[Admin_StepResult] sr WITH(NOLOCK) WHERE [Step_Id] = @stepId)  
AND om.[Type] in ('StepResult')  
  
  -- insert the documents
  INSERT INTO [dbo].[Snapshot_StepResult]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Order],[Id],[Lang]  
       ,[Name]  
       ,[NbOriginal]  
       ,[NbCopy]  
       ,[NbAuthenticated]  
       ,[Type]  
       ,[Law_Id]  
       ,[Law_Name]  
       ,[Law_Description]  
       ,[Articles]
	   ,[IsDocumentPresent],[Document_Id],[Document_Type])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, sr.[Order], sr.[Id], sr.lang  
    ,CASE   
	   WHEN sr.lang = @langPrincipal THEN req.[Name]  
	   ELSE ISNULL(req_i18n.[Name], req.[Name])  END AS Name
   ,sr.[NbOriginal]  
   ,sr.[NbCopy]  
   ,sr.[NbAuthenticated]  
   ,sr.[Type]  
   ,law.[Id]  
   ,CASE  
   WHEN law.lang = @langPrincipal THEN law.[Name]  
   ELSE ISNULL(law_i18n.[Name], law.[Name])  
  END AS [Law_Name]  
   ,CASE  
   WHEN law.lang = @langPrincipal THEN law.[Description]  
   ELSE ISNULL(law_i18n.[Description], law.[Description])  
  END AS [Law_Description]  
   ,CASE   
   WHEN sr.lang = @langPrincipal THEN sr.[Articles]  
   ELSE ISNULL(sr_i18n.[Articles], sr.[Articles])  
    END AS [Articles]
   ,sr.[IsDocumentPresent]
   ,sr.Document_Id
   , req.[Type]  
  FROM (SELECT l.code as lang, sr.* FROM SystemLanguage l, [dbo].[Admin_StepResult] sr WITH(NOLOCK) ) sr  
 LEFT JOIN [Admin_StepResult_i18n] sr_i18n WITH(NOLOCK) ON sr.[Id] = sr_i18n.[StepResult_Id] AND sr.[lang] = sr_i18n.[lang]  
 LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) law   
   ON sr.Law_Id = law.[Id] AND sr.lang = law.lang  
 LEFT JOIN [Law_i18n] law_i18n WITH(NOLOCK)   
      ON law.[Id] = law_i18n.[Parent_Id] AND law.lang = law_i18n.lang
 
 INNER JOIN (SELECT l.code as lang, req.* FROM SystemLanguage l, [dbo].[GenericRequirement] req WITH(NOLOCK)) req   
   ON sr.Document_Id = req.[Id] AND sr.lang = req.lang  
  LEFT JOIN [GenericRequirement_i18n] req_i18n WITH(NOLOCK)   
      ON req.[Id] = req_i18n.[Parent_Id] AND req.lang = req_i18n.lang  

  WHERE sr.[Step_Id] = @stepId and sr.Document_Id is not null 
  AND ISNULL(law.[Deleted], 0) = 0  
  
-- insert StepResult as documents Attachments  
INSERT INTO [dbo].[Snapshot_Object_Media]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Lang]  
       ,[Object_Id],[Type],[Order]  
       ,[Media_Id]  
       ,[Media_Name]  
       ,[Media_FileName],[Media_Extention]  
       ,[Media_Length],[Media_PreviewImageName], [Media_IsDocumentPresent])  
SELECT @registryId, @objectiveId, @blockId, @stepId, m.lang,  
  om.[Object_Id], om.[Type], om.[Order],  
  m.Id,   
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[Name]  
   ELSE ISNULL(m_i18n.[Name], m.[Name])  
  END AS [Media_Name],  
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[FileName]  
   ELSE ISNULL(m_i18n.[FileName], m.[FileName])  
  END AS [Media_FileName],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Extention]  
    ELSE ISNULL(m_i18n.[Extention], m.[Extention])  
  END AS [Media_Extention],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Length]  
    ELSE ISNULL(m_i18n.[Length], m.[Length])  
  END AS [Media_Length],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[PreviewImageName]  
    ELSE ISNULL(m_i18n.[PreviewImageName], m.[PreviewImageName])  
  END AS [Media_PreviewImageName],
  m.[IsDocumentPresent]

FROM Admin_Object_Media om WITH(NOLOCK)  
 INNER JOIN (SELECT l.code as lang, m.* FROM SystemLanguage l, Media m WITH(NOLOCK)) m ON om.[Media_Id] = m.[Id]  
     LEFT JOIN Media_i18n m_i18n WITH(NOLOCK) ON m.[Id] = m_i18n.[Media_Id] and m.lang = m_i18n.lang   
WHERE om.[Object_Id] in (SELECT [Document_Id] FROM [dbo].[Admin_StepResult] WITH(NOLOCK) WHERE Document_Id is not null AND [Step_Id] = @stepId)  
AND om.[Type] in ('GenericRequirement')  
 
-- insert stepRequirement that are of type GenericRequirement   
INSERT INTO [dbo].[Snapshot_StepRequirement]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Order],[Id],[Lang]  
       ,[AggregateOperator]  
       ,[Type]  
       ,[GenericRequirement_Id]  
       ,[GenericRequirement_Name]  
       ,[GenericRequirement_Description]  
       ,[GenericRequirement_Type]
       ,[GenericRequirement_IsDocumentPresent]  
       ,[NbOriginal]  
       ,[NbCopy]  
       ,[NbAuthenticated]  
       ,[Comments]  
       ,[FilterGlobalOption]  
       ,[Law_Id]  
       ,[Law_Name]  
       ,[Law_Description]  
       ,[Articles]
	   ,[GenericRequirement_NumberOfPages]
	   ,[GenericRequirement_IsEmittedByInstitution])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, sreq.[Order], sreq.[Id], sreq.lang  
   ,[AggregateOperator]  
   ,sreq.[Type]  
   ,req.[Id]  
   ,CASE  
   WHEN req.lang = @langPrincipal THEN req.[Name]  
   ELSE ISNULL(req_i18n.[Name], req.[Name])  
  END AS [GenericRequirement_Name]  
   ,CASE  
   WHEN req.lang = @langPrincipal THEN req.[Description]  
   ELSE ISNULL(req_i18n.[Description], req.[Description])  
  END AS [GenericRequirement_Description]  
   ,req.Type as [GenericRequirement_Type]
   ,req.IsDocumentPresent as [GenericRequirement_IsDocumentPresent]	  
   ,[NbOriginal]  
   ,[NbCopy]  
   ,[NbAuthenticated]  
   ,CASE  
   WHEN sreq.lang = @langPrincipal THEN sreq.[Comments]  
   ELSE ISNULL(sreq_i18n.[Comments], sreq.[Comments])  
  END AS [Comments]  
   ,[FilterGlobalOption]  
   ,law.[Id]  
   ,CASE  
   WHEN law.lang = @langPrincipal THEN law.[Name]  
   ELSE ISNULL(law_i18n.[Name], law.[Name])  
  END AS [Law_Name]  
   ,CASE  
   WHEN law.lang = @langPrincipal THEN law.[Description]  
   ELSE ISNULL(law_i18n.[Description], law.[Description])  
  END AS [Law_Description]  
   ,CASE   
   WHEN sreq.lang = @langPrincipal THEN sreq.[Articles]  
   ELSE ISNULL(sreq_i18n.[Articles], sreq.[Articles])  
    END AS [Articles]
   ,req.NumberOfPages as [GenericRequirement_NumberOfPages]
   ,req.IsEmittedByInstitution as [GenericRequirement_IsEmittedByInstitution]
FROM (SELECT l.code as lang, sreq.* FROM SystemLanguage l, [dbo].[Admin_StepRequirement] sreq WITH(NOLOCK)) sreq  
 LEFT JOIN [dbo].[Admin_StepRequirement_i18n] sreq_i18n WITH(NOLOCK) ON sreq.[Id] = sreq_i18n.[StepRequirement_Id] AND sreq.[lang] = sreq_i18n.[lang]  
 INNER JOIN (SELECT l.code as lang, req.* FROM SystemLanguage l, [dbo].[GenericRequirement] req WITH(NOLOCK)) req   
   ON sreq.GenericRequirement_Id = req.[Id] AND sreq.lang = req.lang  
     LEFT JOIN [GenericRequirement_i18n] req_i18n WITH(NOLOCK)   
      ON req.[Id] = req_i18n.[Parent_Id] AND req.lang = req_i18n.lang  
 LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) law   
   ON sreq.Law_Id = law.[Id] AND sreq.lang = law.lang  
     LEFT JOIN [Law_i18n] law_i18n WITH(NOLOCK)   
      ON law.[Id] = law_i18n.[Parent_Id] AND law.lang = law_i18n.lang  
  
WHERE sreq.[Type] = 1 -- generic requirement  
AND ISNULL(req.[Deleted], 0) = 0  
AND sreq.Step_Id = @stepId  
AND ISNULL(law.[Deleted], 0) = 0  

-- insert the cost for the requirements  
INSERT INTO [dbo].[Snapshot_StepRequirementCost]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Id]  
       ,[Type]  
	   ,[Level_Id]
	   ,[TimeOfStaff]
	   ,[Automated]
       ,[GenericRequirement_Id])

 SELECT @registryId, @objectiveId, @blockId, @stepId, sreq.[Id]
   ,rcost.[Type]  
   ,rcost.[Level_Id]  
   ,rcost.[TimeOfStaff]
   ,rcost.[Automated]
   ,sreq.[GenericRequirement_Id]

 FROM (SELECT sreq.* FROM [dbo].[Admin_StepRequirement] sreq WITH(NOLOCK)) sreq  
 INNER JOIN (SELECT req.* FROM [dbo].[GenericRequirement] req WITH(NOLOCK)) req ON sreq.GenericRequirement_Id = req.[Id]
 INNER JOIN (SELECT rcost.* FROM [dbo].[GenericRequirement_Cost] rcost WITH(NOLOCK)) rcost ON sreq.GenericRequirement_Id = rcost.GenericRequirement_Id 
  
WHERE sreq.[Type] = 1 -- generic requirement  
AND ISNULL(req.[Deleted], 0) = 0  
AND sreq.Step_Id = @stepId  
AND ISNULL(rcost.[Deleted], 0) = 0  

  
-- insert the attachments for the generic requirements  
INSERT INTO [dbo].[Snapshot_Object_Media]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Lang]  
       ,[Object_Id],[Type],[Order]  
       ,[Media_Id]  
       ,[Media_Name]  
       ,[Media_FileName],[Media_Extention]  
       ,[Media_Length],[Media_PreviewImageName], [Media_IsDocumentPresent])  
SELECT @registryId, @objectiveId, @blockId, @stepId, m.lang,  
  om.[Object_Id], om.[Type], om.[Order],  
  m.Id,   
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[Name]  
   ELSE ISNULL(m_i18n.[Name], m.[Name])  
  END AS [Media_Name],  
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[FileName]  
   ELSE ISNULL(m_i18n.[FileName], m.[FileName])  
  END AS [Media_FileName],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Extention]  
    ELSE ISNULL(m_i18n.[Extention], m.[Extention])  
  END AS [Media_Extention],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Length]  
    ELSE ISNULL(m_i18n.[Length], m.[Length])  
  END AS [Media_Length],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[PreviewImageName]  
    ELSE ISNULL(m_i18n.[PreviewImageName], m.[PreviewImageName])  
  END AS [Media_PreviewImageName],
  m.[IsDocumentPresent]
FROM Admin_Object_Media om WITH(NOLOCK)  
 INNER JOIN (SELECT l.code as lang, m.* FROM SystemLanguage l, Media m WITH(NOLOCK)) m ON om.[Media_Id] = m.[Id]  
     LEFT JOIN Media_i18n m_i18n WITH(NOLOCK) ON m.[Id] = m_i18n.[Media_Id] and m.lang = m_i18n.lang   
WHERE om.[Object_Id] in (SELECT [GenericRequirement_Id] FROM [dbo].[Admin_StepRequirement] WITH(NOLOCK) WHERE [Type] = 1 AND [Step_Id] = @stepId)  
AND om.[Type] in ('GenericRequirement')   
  
-- insert stepRequirement that are of type StepResult   
--INSERT INTO [dbo].[Snapshot_StepRequirement]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Order],[Id],[Lang]  
--       ,[AggregateOperator]  
--       ,[Type]  
--       ,[StepResult_Id]  
--       ,[StepResult_Step_Id]  
--       ,[NbOriginal]  
--       ,[NbCopy]  
--       ,[NbAuthenticated]  
--       ,[Comments]  
--       ,[FilterGlobalOption]  
--       ,[Law_Id]  
--       ,[Law_Name]  
--       ,[Law_Description]  
--       ,[Articles])  
-- SELECT @registryId, @objectiveId, @blockId, @stepId, sreq.[Order], sreq.[Id], sreq.lang  
--   ,[AggregateOperator]  
--   ,sreq.[Type]  
--   ,sr.[Id]  
--   ,sr.[Step_Id]  
--   ,sreq.[NbOriginal]  
--   ,sreq.[NbCopy]  
--   ,sreq.[NbAuthenticated]  
--   ,CASE  
--   WHEN sreq.lang = @langPrincipal THEN sreq.[Comments]  
--   ELSE ISNULL(sreq_i18n.[Comments], sreq.[Comments])  
--  END AS [Comments]  
--   ,[FilterGlobalOption]  
--   ,law.[Id]  
--   ,CASE  
--   WHEN law.lang = @langPrincipal THEN law.[Name]  
--   ELSE ISNULL(law_i18n.[Name], law.[Name])  
--  END AS [Law_Name]  
--   ,CASE  
--   WHEN law.lang = @langPrincipal THEN law.[Description]  
--   ELSE ISNULL(law_i18n.[Description], law.[Description])  
--  END AS [Law_Description]  
--   ,CASE   
--   WHEN sreq.lang = @langPrincipal THEN sreq.[Articles]  
--   ELSE ISNULL(sreq_i18n.[Articles], sreq.[Articles])  
--    END AS [Articles] 
--FROM (SELECT l.code as lang, sreq.* FROM SystemLanguage l, [dbo].[Admin_StepRequirement] sreq WITH(NOLOCK)) sreq  
-- LEFT JOIN [dbo].[Admin_StepRequirement_i18n] sreq_i18n WITH(NOLOCK) ON sreq.[Id] = sreq_i18n.[StepRequirement_Id] AND sreq.[lang] = sreq_i18n.[lang]  
-- INNER JOIN Admin_StepResult sr WITH(NOLOCK) ON sreq.[StepResult_Id] = sr.[Id]  
-- LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) law   
--   ON sreq.Law_Id = law.[Id] AND sreq.lang = law.lang  
--     LEFT JOIN [Law_i18n] law_i18n WITH(NOLOCK)   
--      ON law.[Id] = law_i18n.[Parent_Id] AND law.lang = law_i18n.lang  
--WHERE sreq.[Type] = 2 -- result of step  
--AND sreq.Step_Id = @stepId  
--AND ISNULL(law.[Deleted], 0) = 0   
  
-- insert stepRequirement that are of type Separator   
INSERT INTO [dbo].[Snapshot_StepRequirement]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Order],[Id],[Lang]  
       ,[AggregateOperator]  
       ,[Type]  
       ,[NbOriginal]  
       ,[NbCopy]  
       ,[NbAuthenticated]  
       ,[Comments]  
       ,[FilterGlobalOption])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, sreq.[Order], sreq.[Id], sreq.lang  
   ,[AggregateOperator]  
   ,sreq.[Type]  
   ,[NbOriginal]  
   ,[NbCopy]  
   ,[NbAuthenticated]  
   ,CASE  
   WHEN sreq.lang = @langPrincipal THEN sreq.[Comments]  
   ELSE ISNULL(sreq_i18n.[Comments], sreq.[Comments])  
  END AS [Comments]  
   ,[FilterGlobalOption]  
FROM (SELECT l.code as lang, sreq.* FROM SystemLanguage l, [dbo].[Admin_StepRequirement] sreq WITH(NOLOCK)) sreq  
 LEFT JOIN [dbo].[Admin_StepRequirement_i18n] sreq_i18n WITH(NOLOCK) ON sreq.[Id] = sreq_i18n.[StepRequirement_Id] AND sreq.[lang] = sreq_i18n.[lang]  
WHERE sreq.[Type] = 3 -- separator  
AND sreq.Step_Id = @stepId   
  
-- insert stepCost  
INSERT INTO [dbo].[Snapshot_StepCost]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Order],[Id],[Lang]  
       ,[AggregateOperator]  
       ,[IsSeparator]  
       ,[Value]  
       ,[Unit]  
       ,[Operator]  
       ,[Parameter]  
       ,[Type]  
       ,[AverageValue]  
       ,[CalculatedValue]    
       ,[Comments]  
       ,[AverageValueComments]  
       ,[FilterGlobalOption]  
       ,[Law_Id]  
       ,[Law_Name]  
       ,[Law_Description]  
       ,[Articles])  
SELECT @registryId, @objectiveId, @blockId, @stepId, sc.[Order], sc.[Id], sc.[lang]  
   ,[AggregateOperator]  
   ,[IsSeparator]  
   ,[Value]  
   ,[Unit]  
   ,[Operator]  
   ,[Parameter]  
   ,[Type]  
   ,[AverageValue]  
   ,CASE [Operator]  
   WHEN 'percentage' THEN (ISNULL([Value], 0) / 100 * ISNULL([AverageValue], 0))  
   WHEN 'per' THEN (ISNULL([Value], 0) * ISNULL([AverageValue], 0))  
   ELSE ISNULL([VALUE], 0)  
  END AS [CalculatedValue]     
   ,CASE  
   WHEN sc.lang = @langPrincipal THEN sc.[Comments]  
   ELSE ISNULL(sc_i18n.[Comments], sc.[Comments])  
  END AS [Comments] 
  ,CASE  
   WHEN sc.lang = @langPrincipal THEN sc.[AverageValueComments]  
   ELSE ISNULL(sc_i18n.[AverageValueComments], sc.[AverageValueComments])  
  END AS [AverageValueComments]  
   ,[FilterGlobalOption]  
   ,law.[Id]  
   ,CASE  
   WHEN law.lang = @langPrincipal THEN law.[Name]  
   ELSE ISNULL(law_i18n.[Name], law.[Name])  
  END AS [Law_Name]  
   ,CASE  
   WHEN law.lang = @langPrincipal THEN law.[Description]  
   ELSE ISNULL(law_i18n.[Description], law.[Description])  
  END AS [Law_Description]  
   ,CASE   
   WHEN sc.lang = @langPrincipal THEN sc.[Articles]  
   ELSE ISNULL(sc_i18n.[Articles], sc.[Articles])  
    END AS [Articles]  
FROM (SELECT l.code as lang, sc.* FROM SystemLanguage l, [dbo].[Admin_StepCost] sc WITH(NOLOCK)) sc  
 LEFT JOIN [dbo].[Admin_StepCost_i18n] sc_i18n WITH(NOLOCK) ON sc.[Id] = sc_i18n.[StepCost_Id] AND sc.[lang] = sc_i18n.[lang]  
 LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) law   
   ON sc.Law_Id = law.[Id] AND sc.lang = law.lang  
     LEFT JOIN [Law_i18n] law_i18n WITH(NOLOCK)   
      ON law.[Id] = law_i18n.[Parent_Id] AND law.lang = law_i18n.lang  
WHERE sc.Step_Id = @stepId   
AND ISNULL(law.[Deleted], 0) = 0  
  
-- insert stepLaw  
INSERT INTO [dbo].[Snapshot_StepLaw]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Order],[Id],[Lang]  
       ,[AggregateOperator]  
       ,[Law_Id]  
       ,[Law_Name]  
       ,[Law_Description]  
	   ,[Law_IsDocumentPresent]
       ,[Articles]  
       ,[Comments])  
 SELECT @registryId, @objectiveId, @blockId, @stepId, sl.[Order], sl.[Id], sl.[lang]  
   ,[AggregateOperator]  
   ,l.[Id] as Law_Id  
   ,CASE  
   WHEN l.lang = @langPrincipal THEN l.[Name]  
   ELSE ISNULL(l_i18n.[Name], l.[Name])  
  END AS [Law_Name]  
   ,CASE  
   WHEN l.lang = @langPrincipal THEN l.[Description]  
   ELSE ISNULL(l_i18n.[Description], l.[Description])  
  END AS [Law_Description]  
   ,l.[IsDocumentPresent]
   ,CASE  
   WHEN sl.lang = @langPrincipal THEN sl.[Articles]  
   ELSE ISNULL(sl_i18n.[Articles], sl.[Articles])  
  END AS [Articles]  
   ,CASE  
   WHEN sl.lang = @langPrincipal THEN sl.[Comments]  
   ELSE ISNULL(sl_i18n.[Comments], sl.[Comments])  
  END AS [Comments]  
FROM (SELECT l.code as lang, sl.* FROM SystemLanguage l, [dbo].[Admin_StepLaw] sl WITH(NOLOCK)) sl  
 LEFT JOIN [dbo].[Admin_StepLaw_i18n] sl_i18n WITH(NOLOCK) ON sl.[Id] = sl_i18n.[StepLaw_Id] AND sl.[lang] = sl_i18n.[lang]  
 INNER JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) l   
   ON sl.Law_Id = l.[Id] AND sl.lang = l.lang  
     LEFT JOIN [Law_i18n] l_i18n WITH(NOLOCK)   
      ON l.[Id] = l_i18n.[Parent_Id] AND l.lang = l_i18n.lang  
  
WHERE sl.Step_Id = @stepId  
AND ISNULL(l.[Deleted], 0) = 0  
  
-- insert the attachments for the law  
INSERT INTO [dbo].[Snapshot_Object_Media]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id],[Lang]  
       ,[Object_Id],[Type],[Order]  
       ,[Media_Id]  
 ,[Media_Name]  
       ,[Media_FileName],[Media_Extention]  
       ,[Media_Length],[Media_PreviewImageName], [Media_IsDocumentPresent])  
SELECT @registryId, @objectiveId, @blockId, @stepId, m.lang,  
  om.[Object_Id], om.[Type], om.[Order],  
  m.Id,   
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[Name]  
   ELSE ISNULL(m_i18n.[Name], m.[Name])  
  END AS [Media_Name],  
  CASE   
   WHEN m.lang = @langPrincipal THEN m.[FileName]  
   ELSE ISNULL(m_i18n.[FileName], m.[FileName])  
  END AS [Media_FileName],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Extention]  
    ELSE ISNULL(m_i18n.[Extention], m.[Extention])  
  END AS [Media_Extention],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[Length]  
    ELSE ISNULL(m_i18n.[Length], m.[Length])  
  END AS [Media_Length],
  CASE   
    WHEN m.lang = @langPrincipal THEN m.[PreviewImageName]  
    ELSE ISNULL(m_i18n.[PreviewImageName], m.[PreviewImageName])  
  END AS [Media_PreviewImageName],
  m.[IsDocumentPresent]
FROM Admin_Object_Media om WITH(NOLOCK)  
 INNER JOIN (SELECT l.code as lang, m.* FROM SystemLanguage l, Media m WITH(NOLOCK)) m ON om.[Media_Id] = m.[Id]  
     LEFT JOIN Media_i18n m_i18n WITH(NOLOCK) ON m.[Id] = m_i18n.[Media_Id] and m.lang = m_i18n.lang   
WHERE om.[Object_Id] in (SELECT [Law_Id] FROM [dbo].[Admin_StepLaw] WITH(NOLOCK) WHERE [Step_Id] = @stepId)  
AND om.[Type] in ('Law')   
  
-- insert section visibility  
INSERT INTO [dbo].[Snapshot_StepSectionVisibility]([Registry_Id],[Objective_Id],[Block_Id],[Step_Id]  
       ,[IsExpectedResultsVisible]  
       ,[IsEntityInChargeVisible]  
       ,[IsUnitInChargeVisible]  
       ,[IsPersonInChargeVisible]  
       ,[IsRequirementsVisible]  
       ,[IsCostsVisible]  
       ,[IsCostsCommentsVisible]  
       ,[IsTimeframeVisible]  
       ,[IsTimeframeWaintingTimeInLineVisible]  
       ,[IsTimeframeTimeSpentAtTheCounterVisible]  
       ,[IsTimeframeWaitingTimeUntilNextStepVisible]  
       ,[IsTimeframeCommentsVisible]  
       ,[IsLegalJustificationVisible]  
       ,[IsLegalJustificationCommentsVisible]  
       ,[IsAdditionalInfoVisible]  
       ,[IsRecoursesVisible]
	     ,[IsRecourseUnitInChargeVisible]
       ,[IsRecoursePersonInChargeVisible]  
       ,[IsCertificationVisible]
       ,[IsSummaryVisible])  
 SELECT @registryId, @objectiveId, @blockId, @stepId  
   ,[IsExpectedResultsVisible]  
   ,[IsEntityInChargeVisible]  
   ,[IsUnitInChargeVisible]  
   ,[IsPersonInChargeVisible]  
   ,[IsRequirementsVisible]  
   ,[IsCostsVisible]  
   ,[IsCostsCommentsVisible]  
   ,[IsTimeframeVisible]  
   ,[IsTimeframeWaintingTimeInLineVisible]  
   ,[IsTimeframeTimeSpentAtTheCounterVisible]  
   ,[IsTimeframeWaitingTimeUntilNextStepVisible]  
   ,[IsTimeframeCommentsVisible]  
   ,[IsLegalJustificationVisible]  
   ,[IsLegalJustificationCommentsVisible]  
   ,[IsAdditionalInfoVisible]  
   ,[IsRecoursesVisible]
   ,[IsRecourseUnitInChargeVisible]
   ,[IsRecoursePersonInChargeVisible]
   ,[IsCertificationVisible]
   ,[IsSummaryVisible]  
FROM [dbo].[Admin_StepSectionVisibility]  
WHERE Step_Id = @stepId  
  
   
END
GO

-- =============================================
-- Category 6: Major structural
-- Procedure: sp_update_snapshot_block
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_update_snapshot_block' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_update_snapshot_block]
GO
CREATE PROCEDURE [dbo].[sp_update_snapshot_block]
(
	@blockId int,
	@date datetime
)
AS
BEGIN

SET NOCOUNT ON

DECLARE @langPrincipal varchar(2)
SET @langPrincipal = (SELECT TOP 1 code FROM SystemLanguage WHERE IsPrincipal = 1) 

-- get all the registry for objectives where this block exists
DECLARE @registryId int, @objectiveId int, @blockOrder int

-- make sure a parent exist, if not do not add the snapshot
DECLARE @snapshotProcedureExists bit
SET @snapshotProcedureExists = 0

-- if no current snapshot exist for current block, add one entry for a procedure parent
DECLARE @nbSnapshotBlock as int
SET @nbSnapshotBlock = 0
SELECT @nbSnapshotBlock = count(*) from Snapshot_Block with(nolock) WHERE Id = @blockId and registry_id in (select [id] from snapshot_registry where isCurrent = 1)
IF @nbSnapshotBlock = 0
BEGIN
	-- get a parent from tables Admin
	DECLARE @objectiveParentId int
	SET @objectiveParentId = 0
	SELECT TOP 1 @objectiveParentId = o.Id 
	FROM Admin_Block b with(nolock) INNER JOIN Admin_Objective_Block ob with(nolock) ON b.Id = ob.block_Id
		INNER JOIN Admin_Objective o with(nolock) ON ob.Objective_id = o.Id
	WHERE isnull(o.Deleted, 0) = 0
	AND b.Id = @blockId

	-- add a snapshot of the procedure parent if exists
	IF @objectiveParentId <> 0
	BEGIN
		-- set the flag
		SET @snapshotProcedureExists = 1

		DECLARE @snapshotVer int  
		SET @snapshotVer = 0 --initialize with 0  
		SELECT @snapshotVer = snapshotVersion FROM [dbo].[Snapshot_Registry] WITH(NOLOCK) WHERE Objective_Id = @objectiveParentId and IsCurrent = 1  
		IF @snapshotVer = 0 -- not found, set to 1  
		 SET @snapshotVer = 1  
		
		-- add the registry entry
		IF NOT EXISTS (SELECT [Id] FROM [dbo].[Snapshot_Registry] WITH(NOLOCK) WHERE Objective_Id = @objectiveParentId AND SnapshotVersion = @snapshotVer)  
		BEGIN  
		 INSERT INTO [dbo].[Snapshot_Registry] ([Objective_id],[SnapshotVersion],[SnapshotDate],[IsCurrent])  
			 VALUES (@objectiveParentId, @snapshotVer, @date, 1)   
		END   
		SELECT @registryId = [Id] FROM [dbo].[Snapshot_Registry] WITH(NOLOCK) WHERE Objective_Id = @objectiveParentId and SnapshotVersion = @snapshotVer  

		-- add the objective snapshot
		IF (SELECT count(*) FROM Snapshot_Objective where Id = @objectiveParentId and registry_id = @registryId) = 0		
		BEGIN
			INSERT INTO [dbo].[Snapshot_Objective]([Registry_Id],[Id],[Lang],[Name])  
			SELECT @registryId, o.Id, o.lang,  
			 CASE   
			  WHEN o.lang = @langPrincipal THEN o.Name  
			  ELSE ISNULL(o_i18n.[Name], o.[Name])  
			 END AS [Name]  
			FROM (SELECT l.code AS lang, [Id], o.[Name] FROM Admin_Objective o WITH(NOLOCK), SystemLanguage l) o  
			  LEFT JOIN Admin_Objective_i18n o_i18n WITH(NOLOCK) ON o.[lang] = o_i18n.[lang] and o.[Id] = o_i18n.[Parent_Id]  
			WHERE o.[Id] = @objectiveParentId
		END
		-- add one mock-up block to snapshot_block (it will be found later and recalculated) --WHY
		INSERT INTO [dbo].[Snapshot_Block]([Registry_Id],[Objective_Id],[Order],[Id],[Lang]
			   ,[Name]
			   ,[Description]
			   ,[IsOptional],[PhysicalPresence],[RepresentationThirdParty])
		SELECT @registryId, @objectiveParentId, ob.[Order], b.Id, b.lang,
			b.[Name],
			b.[description],
			b.[IsOptional], b.[PhysicalPresence], b.[RepresentationThirdParty]
		FROM 
			( SELECT l.code as lang, b.* FROM Admin_Block b WITH(NOLOCK), SystemLanguage l
			  WHERE ISNULL(b.[Deleted], 0) = 0  AND ISNULL(b.[IsInRecycleBin], 0) = 0
			) b				
				INNER JOIN Admin_Objective_Block ob WITH(NOLOCK) ON b.[Id] = ob.[Block_Id]  
		WHERE 
			ob.Objective_id = @objectiveParentId and b.Id = @blockId
	END	
END
ELSE
BEGIN
	SET @snapshotProcedureExists = 1
END

-- the following procedure is executed only if snapshot exists
IF @snapshotProcedureExists = 1
BEGIN
	-- get all the blocks in the snapshot tables
	DECLARE blocks_cursor CURSOR FOR 
		SELECT DISTINCT sb.registry_id, sb.objective_id, sb.[order]
		FROM dbo.Snapshot_Block sb with(nolock)
		WHERE sb.id = @blockId 
		AND sb.registry_id IN (SELECT sreg.id FROM Snapshot_Registry sreg with(nolock) WHERE sreg.IsCurrent = 1)
		AND sb.lang = @langPrincipal

	OPEN blocks_cursor

	FETCH NEXT FROM blocks_cursor
	INTO @registryId, @objectiveId, @blockOrder
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		
		/* 1. delete all from Snapshot_Block, Snapshot_Step, 
						Snapshot_StepEntityInCharge, Snapshot_StepUnitInCharge, Snapshot_StepPersonInCharge,
						Snapshot_StepResult, Snapshot_StepRequirement, Snapshot_StepCost, Snapshot_StepLaw
						Snapshot_StepSectionVisibility,
						Snapshot_Object_Media 
		that are linked to the registry_Id and the @blockId of the current snapshot */

		-- delete dependencies
		DELETE FROM [dbo].[Snapshot_Step] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		DELETE FROM [dbo].[Snapshot_StepEntityInCharge] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		DELETE FROM [dbo].[Snapshot_StepUnitInCharge] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		DELETE FROM [dbo].[Snapshot_StepPersonInCharge] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId
		DELETE FROM [dbo].[Snapshot_StepRecourseEntityInCharge] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		DELETE FROM [dbo].[Snapshot_StepRecourseUnitInCharge] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		DELETE FROM [dbo].[Snapshot_StepRecoursePersonInCharge] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId
		DELETE FROM [dbo].[Snapshot_StepRegionalEntityInCharge] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId
		DELETE FROM [dbo].[Snapshot_StepRegionalUnitInCharge] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId
		DELETE FROM [dbo].[Snapshot_StepRegionalPersonInCharge] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId
		DELETE FROM [dbo].[Snapshot_StepResult] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		DELETE FROM [dbo].[Snapshot_StepRequirement] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		DELETE FROM [dbo].[Snapshot_StepRequirementCost] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		DELETE FROM [dbo].[Snapshot_StepCost] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		DELETE FROM [dbo].[Snapshot_StepLaw] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		DELETE FROM [dbo].[Snapshot_StepSectionVisibility] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		DELETE FROM [dbo].[Snapshot_Object_Media] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Block_Id] = @blockId 
		-- delete main obj
		DELETE FROM [dbo].[Snapshot_Block] WHERE [Registry_Id] = @registryId AND [Objective_id] = @objectiveId AND [Id] = @blockId 
  
		/* 2. update the date in the snapshot registry to the current date for the current snapshot  */
		UPDATE [dbo].[Snapshot_Registry]
		SET [SnapshotDate] = @date
		WHERE [Id] = @registryId
		
		/* 3. recreate the entries in Snapshot Block for each language */
		INSERT INTO [dbo].[Snapshot_Block]([Registry_Id],[Objective_Id],[Order],[Id],[Lang]
				   ,[Name]
				   ,[Description]
				   ,[IsOptional],[PhysicalPresence],[RepresentationThirdParty])
		SELECT @registryId, @objectiveId, @blockOrder, b.Id, b.lang,
			CASE 
				WHEN b.lang = @langPrincipal THEN b.[Name]
				ELSE ISNULL(b_i18n.[Name], b.[Name])
			END AS [Name],
			CASE 
				WHEN b.lang = @langPrincipal THEN b.[Description]
				ELSE ISNULL(b_i18n.[Description], b.[Description])
			END AS [Description],
			b.[IsOptional], b.[PhysicalPresence], b.[RepresentationThirdParty]
		FROM 
			( SELECT l.code as lang, b.* FROM Admin_Block b WITH(NOLOCK), SystemLanguage l
			  WHERE ISNULL(b.[Deleted], 0) = 0  AND ISNULL(b.[IsInRecycleBin], 0) = 0
			) b
				LEFT JOIN Admin_Block_i18n b_i18n WITH(NOLOCK) ON b.[lang] = b_i18n.[lang] and b.[Id] = b_i18n.[Parent_Id]
		WHERE 
			b.id = @blockId

		/*	4. for each Step in Admin_Block_Step add a new entry for each lang in 
				Snapshot_Step,
				Snapshot_StepEntityInCharge, Snapshot_StepUnitInCharge, Snapshot_StepPersonInCharge,
				Snapshot_StepResult, Snapshot_StepRequirement, Snapshot_StepCost, Snapshot_StepLaw
				Snapshot_StepSectionVisibility 
		*/
		DECLARE @stepId int, @stepOrder int, @stepIsParallele bit, @stepIsAlternative bit
		
		DECLARE step_cursor CURSOR FOR 
			SELECT s.Id as Step_Id, bs.[Order], bs.[IsParallele], bs.[IsAlternative]
			FROM Admin_Step s WITH(NOLOCK)
					INNER JOIN Admin_Block_Step bs WITH(NOLOCK) ON s.[Id] = bs.[Step_Id]
						INNER JOIN Admin_Block b WITH(NOLOCK) ON bs.[Block_Id] = b.[Id]
			WHERE 
			ISNULL(s.[Deleted], 0) = 0  AND ISNULL(s.[IsInRecycleBin], 0) = 0 
			AND ISNULL(b.[Deleted], 0) = 0  AND ISNULL(b.[IsInRecycleBin], 0) = 0
			AND b.[Id] = @blockId
		OPEN step_cursor

		FETCH NEXT FROM step_cursor 
		INTO @stepId, @stepOrder, @stepIsParallele, @stepIsAlternative

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- add Step
			INSERT INTO [dbo].[Snapshot_Step]([Registry_Id],[Objective_Id],[Block_Id]
				   ,[IsRecourse],[Step_Id]
				   ,[Order],[IsParallele],[IsAlternative]
				   ,[Certified], [CertificationDate], [CertificationUser], [CertificationEntityInCharge_Id]
				   ,[CertificationEntityInCharge_Name]
				   ,[Id],[Lang]
				   ,[Name]
				   ,[PhysicalPresence],[RepresentationThirdParty],[IsOnline],[OnlineType],[OnlineStepURL],[IsOptional],[RequirementsPhysicalPresence]
				   ,[HasCosts],[NoCostsReason],[IsPayMethodCash],[IsPayMethodCheck],[IsPayMethodCard],[IsPayMethodOther]
				   ,[PayMethodOtherText]
				   ,[CostsComments]
				   ,[WaintingTimeInLineMin],[WaintingTimeInLineMax],[TimeSpentAtTheCounterMin],[TimeSpentAtTheCounterMax],[WaitingTimeUntilNextStepMin],[WaitingTimeUntilNextStepMax]
				   ,[TimeframeComments]
				   ,[LawsComments]
				   ,[AdditionalInfo]
				   ,[Contact_Law_Id]
				   ,[Contact_Law_Name]
				   ,[Contact_Law_Description]
				   ,[Contact_Articles]
				   ,[Recourse_Law_Id]
				   ,[Recourse_Law_Name]
				   ,[Recourse_Law_Description]
				   ,[Recourse_Articles]
				   ,[Timeframe_Law_Id]
				   ,[Timeframe_Law_Name]
				   ,[Timeframe_Law_Description]
				   ,[Timeframe_Articles]
				   ,[IsInternal]
				   ,[SnapshotDate]
				   ,[Level_Id]
				   ,[NumberOfUsers]
				   ,[Summary])
			SELECT @registryId, @objectiveId, @blockId, 
					0, NULL, -- is no recourse, so the step_Id is NULL
					@stepOrder, @stepIsParallele, @stepIsAlternative,
					s.[Certified], s.[CertificationDate], s.[CertificationUser], s.[CertificationEntityInCharge_Id], 
					CASE 
						WHEN s.lang = @langPrincipal THEN ceic.[Name]
						ELSE ISNULL(ceic_i18n.[Name], ceic.[Name])
					END AS [CertificationEntityInCharge_Name], 
					@stepId, s.lang,
					CASE 
						WHEN s.lang = @langPrincipal THEN s.[Name]
						ELSE ISNULL(s_i18n.[Name], s.[Name])
					END AS [Name],
					s.[PhysicalPresence],s.[RepresentationThirdParty],s.[IsOnline],s.[OnlineType],s.[OnlineStepURL],s.[IsOptional],s.[RequirementsPhysicalPresence],
					s.[HasCosts],s.[NoCostsReason],s.[IsPayMethodCash],s.[IsPayMethodCheck],s.[IsPayMethodCard],s.[IsPayMethodOther],
					CASE 
						WHEN s.lang = @langPrincipal THEN s.[PayMethodOtherText]
						ELSE ISNULL(s_i18n.[PayMethodOtherText], s.[PayMethodOtherText])
					END AS [PayMethodOtherText],
					CASE 
						WHEN s.lang = @langPrincipal THEN s.[CostsComments]
						ELSE ISNULL(s_i18n.[CostsComments], s.[CostsComments])
					END AS [CostsComments],
					s.[WaintingTimeInLineMin],s.[WaintingTimeInLineMax],s.[TimeSpentAtTheCounterMin],s.[TimeSpentAtTheCounterMax],s.[WaitingTimeUntilNextStepMin],s.[WaitingTimeUntilNextStepMax],
					CASE 
						WHEN s.lang = @langPrincipal THEN s.[TimeframeComments]
						ELSE ISNULL(s_i18n.[TimeframeComments], s.[TimeframeComments])
					END AS [TimeframeComments],
					CASE 
						WHEN s.lang = @langPrincipal THEN s.[LawsComments]
						ELSE ISNULL(s_i18n.[LawsComments], s.[LawsComments])
					END AS [LawsComments],
					CASE 
						WHEN s.lang = @langPrincipal THEN s.[AdditionalInfo]
						ELSE ISNULL(s_i18n.[AdditionalInfo], s.[AdditionalInfo])
					END AS [AdditionalInfo]
					,claw.[Id] as [Contact_Law_Id]
					,CASE
						WHEN claw.lang = @langPrincipal THEN claw.[Name]
						ELSE ISNULL(claw_i18n.[Name], claw.[Name])
					END AS [Contact_Law_Name]
					,CASE
						WHEN claw.lang = @langPrincipal THEN claw.[Description]
						ELSE ISNULL(claw_i18n.[Description], claw.[Description])
					END AS [Contact_Law_Description]
					,CASE 
						WHEN s.lang = @langPrincipal THEN s.[Contact_Articles]
						ELSE ISNULL(s_i18n.[Contact_Articles], s.[Contact_Articles])
					END AS [Contact_Articles]
					,rlaw.[Id] as [Recourse_Law_Id]
					,CASE
						WHEN rlaw.lang = @langPrincipal THEN rlaw.[Name]
						ELSE ISNULL(rlaw_i18n.[Name], rlaw.[Name])
					END AS [Recourse_Law_Name]
					,CASE
						WHEN rlaw.lang = @langPrincipal THEN rlaw.[Description]
						ELSE ISNULL(rlaw_i18n.[Description], rlaw.[Description])
					END AS [Recourse_Law_Description]
					,CASE 
						WHEN s.lang = @langPrincipal THEN s.[Recourse_Articles]
						ELSE ISNULL(s_i18n.[Recourse_Articles], s.[Recourse_Articles])
					END AS [Recourse_Articles]
					,tlaw.[Id] as [Timeframe_Law_Id]
					,CASE
						WHEN tlaw.lang = @langPrincipal THEN tlaw.[Name]
						ELSE ISNULL(tlaw_i18n.[Name], tlaw.[Name])
					END AS [Timeframe_Law_Name]
					,CASE
						WHEN tlaw.lang = @langPrincipal THEN tlaw.[Description]
						ELSE ISNULL(tlaw_i18n.[Description], tlaw.[Description])
					END AS [Timeframe_Law_Description]
					,CASE 
						WHEN s.lang = @langPrincipal THEN s.[Timeframe_Articles]
						ELSE ISNULL(s_i18n.[Timeframe_Articles], s.[Timeframe_Articles])
					END AS [Timeframe_Articles]
					, s.IsInternal
					, GetDate()
					, s.Level_Id
					, s.NumberOfUsers
					, CASE 
						WHEN s.lang = @langPrincipal THEN s.[Summary]
						ELSE ISNULL(s_i18n.[Summary], s.[Summary])
					END AS [Summary]
			FROM 
				(SELECT l.code as lang, s.* FROM [Admin_Step] s WITH(NOLOCK), SystemLanguage l) s
					LEFT JOIN Admin_Step_i18n s_i18n WITH(NOLOCK) ON s.[lang] = s_i18n.[lang] and s.[Id] = s_i18n.[Parent_Id]
					LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) claw 
						ON s.Contact_Law_Id = claw.[Id] AND s.lang = claw.lang
								LEFT JOIN [Law_i18n] claw_i18n WITH(NOLOCK) 
									ON claw.[Id] = claw_i18n.[Parent_Id] AND claw.lang = claw_i18n.lang
					LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) rlaw 
						ON s.Recourse_Law_Id = rlaw.[Id] AND s.lang = rlaw.lang
								LEFT JOIN [Law_i18n] rlaw_i18n WITH(NOLOCK) 
									ON rlaw.[Id] = rlaw_i18n.[Parent_Id] AND rlaw.lang = rlaw_i18n.lang
					LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) tlaw 
						ON s.Timeframe_Law_Id = tlaw.[Id] AND s.lang = tlaw.lang
								LEFT JOIN [Law_i18n] tlaw_i18n WITH(NOLOCK) 
									ON tlaw.[Id] = tlaw_i18n.[Parent_Id] AND tlaw.lang = tlaw_i18n.lang
					LEFT JOIN (SELECT l.code as lang, eic.* FROM SystemLanguage l, [dbo].[EntityInCharge] eic WITH(NOLOCK)) ceic
						ON s.CertificationEntityInCharge_Id = ceic.[Id] AND s.lang = ceic.lang
							LEFT JOIN [EntityInCharge_i18n] ceic_i18n WITH(NOLOCK)
								ON ceic.[Id] = ceic_i18n.[Parent_Id] AND ceic.lang = ceic_i18n.lang
			WHERE s.[Id] = @stepId
			AND ISNULL(claw.deleted, 0) = 0
			AND ISNULL(rlaw.deleted, 0) = 0
			AND ISNULL(tlaw.deleted, 0) = 0
			AND ISNULL(ceic.deleted, 0) = 0
			
			EXEC sp_take_snapshot_step @registryId, @objectiveId, @blockId, @stepId	
			
		
			
			FETCH NEXT FROM step_cursor 
			INTO @stepId, @stepOrder, @stepIsParallele, @stepIsAlternative
		END
		CLOSE step_cursor
		DEALLOCATE step_cursor
		
		FETCH NEXT FROM blocks_cursor
		INTO @registryId, @objectiveId, @blockOrder
	END

	CLOSE blocks_cursor
	DEALLOCATE blocks_cursor
END

SET NOCOUNT OFF
END
GO

-- =============================================
-- Category 6: Major structural
-- Procedure: sp_update_snapshot_recourse
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_update_snapshot_recourse' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_update_snapshot_recourse]
GO
CREATE PROCEDURE [dbo].[sp_update_snapshot_recourse]
(
	@recourseId int,
	@date datetime
)
AS
BEGIN

SET NOCOUNT ON

DECLARE @langPrincipal varchar(2)
SET @langPrincipal = (SELECT TOP 1 code FROM SystemLanguage WHERE IsPrincipal = 1) 

-- get all the registry for objectives where this step exists
DECLARE @registryId int, @objectiveId int, @blockId int, @stepId int, @recourseOrder int

-- get all the recourses in the snapshot tables
DECLARE recourse_cursor CURSOR FOR 
	SELECT DISTINCT sr.registry_id, sr.objective_id, sr.block_id, sr.step_id, sr.[order]
	FROM dbo.Snapshot_Step sr 
	WHERE sr.id = @recourseId AND sr.IsRecourse = 1
	AND sr.registry_id IN (SELECT sreg.id FROM Snapshot_Registry sreg with(nolock) WHERE sreg.IsCurrent = 1)
	AND sr.lang = @langPrincipal	

OPEN recourse_cursor

FETCH NEXT FROM recourse_cursor
INTO @registryId, @objectiveId, @blockId, @stepId, @recourseOrder
WHILE @@FETCH_STATUS = 0
BEGIN 
	
	/* 1. delete all from Snapshot_Step, 
					Snapshot_StepEntityInCharge, Snapshot_StepUnitInCharge, Snapshot_StepPersonInCharge,
					Snapshot_StepResult, Snapshot_StepRequirement, Snapshot_StepCost, Snapshot_StepLaw
					Snapshot_StepSectionVisibility,
					Snapshot_Object_Media 
	that are linked to the registry_Id and the @stepId of the current snapshot */
	
	-- delete dependencies
	DELETE FROM [dbo].[Snapshot_StepEntityInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_StepUnitInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_StepPersonInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_StepRegionalEntityInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_StepRegionalUnitInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_StepRegionalPersonInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_StepResult] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_StepRequirement] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_StepRequirementCost] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_StepCost] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_StepLaw] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_StepSectionVisibility] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	DELETE FROM [dbo].[Snapshot_Object_Media] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @recourseId
	-- delete main object
	DELETE FROM [dbo].[Snapshot_Step] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND [Step_Id] = @stepId AND [Id] = @recourseId


	/* 2. update the date in the snapshot registry to the current date for the current snapshot  */
	UPDATE [dbo].[Snapshot_Registry]
	SET [SnapshotDate] = @date
	WHERE [Id] = @registryId
	
	/*	3. for each Step in Admin_Block_Step add a new entry for each lang in 
			Snapshot_Step,
			Snapshot_StepEntityInCharge, Snapshot_StepUnitInCharge, Snapshot_StepPersonInCharge,
			Snapshot_StepResult, Snapshot_StepRequirement, Snapshot_StepCost, Snapshot_StepLaw
			Snapshot_StepSectionVisibility 
	*/				
	
	-- add Recourse
	INSERT INTO [dbo].[Snapshot_Step]([Registry_Id],[Objective_Id],[Block_Id]
		   ,[IsRecourse],[Step_Id]
		   ,[Order]
		   ,[Certified], [CertificationDate], [CertificationUser], [CertificationEntityInCharge_Id]
		   ,[CertificationEntityInCharge_Name]
		   ,[Id],[Lang]
		   ,[Name]
		   ,[PhysicalPresence],[RepresentationThirdParty],[IsOnline],[OnlineStepURL],[IsOptional],[RequirementsPhysicalPresence]
		   ,[HasCosts],[NoCostsReason],[IsPayMethodCash],[IsPayMethodCheck],[IsPayMethodCard],[IsPayMethodOther]
		   ,[PayMethodOtherText]
		   ,[CostsComments]
		   ,[WaintingTimeInLineMin],[WaintingTimeInLineMax],[TimeSpentAtTheCounterMin],[TimeSpentAtTheCounterMax],[WaitingTimeUntilNextStepMin],[WaitingTimeUntilNextStepMax]
		   ,[TimeframeComments]
		   ,[LawsComments]
		   ,[AdditionalInfo]
		   ,[Contact_Law_Id]
		   ,[Contact_Law_Name]
		   ,[Contact_Law_Description]
		   ,[Contact_Articles]
		   ,[Timeframe_Law_Id]
		   ,[Timeframe_Law_Name]
		   ,[Timeframe_Law_Description]
		   ,[Timeframe_Articles]
		   ,[Level_Id]
		   ,[NumberOfUsers]
		   ,[Summary])
	SELECT @registryId, @objectiveId, @blockId, 
			s.IsRecourse, @stepId, -- is recourse, get the parent = @stepId
			@recourseOrder, 
			s.[Certified], s.[CertificationDate], s.[CertificationUser], s.[CertificationEntityInCharge_Id], 
			CASE 
				WHEN s.lang = @langPrincipal THEN ceic.[Name]
				ELSE ISNULL(ceic_i18n.[Name], ceic.[Name])
			END AS [CertificationEntityInCharge_Name],
			@recourseId, s.lang,
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[Name]
				ELSE ISNULL(s_i18n.[Name], s.[Name])
			END AS [Name],
			s.[PhysicalPresence],s.[RepresentationThirdParty],s.[IsOnline],s.[OnlineStepURL],s.[IsOptional],s.[RequirementsPhysicalPresence],
			s.[HasCosts],s.[NoCostsReason],s.[IsPayMethodCash],s.[IsPayMethodCheck],s.[IsPayMethodCard],s.[IsPayMethodOther],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[PayMethodOtherText]
				ELSE ISNULL(s_i18n.[PayMethodOtherText], s.[PayMethodOtherText])
			END AS [PayMethodOtherText],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[CostsComments]
				ELSE ISNULL(s_i18n.[CostsComments], s.[CostsComments])
			END AS [CostsComments],
			s.[WaintingTimeInLineMin],s.[WaintingTimeInLineMax],s.[TimeSpentAtTheCounterMin],s.[TimeSpentAtTheCounterMax],s.[WaitingTimeUntilNextStepMin],s.[WaitingTimeUntilNextStepMax],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[TimeframeComments]
				ELSE ISNULL(s_i18n.[TimeframeComments], s.[TimeframeComments])
			END AS [TimeframeComments],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[LawsComments]
				ELSE ISNULL(s_i18n.[LawsComments], s.[LawsComments])
			END AS [LawsComments],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[AdditionalInfo]
				ELSE ISNULL(s_i18n.[AdditionalInfo], s.[AdditionalInfo])
			END AS [AdditionalInfo]
			,claw.[Id] as [Contact_Law_Id]
			,CASE
				WHEN claw.lang = @langPrincipal THEN claw.[Name]
				ELSE ISNULL(claw_i18n.[Name], claw.[Name])
			END AS [Contact_Law_Name]
			,CASE
				WHEN claw.lang = @langPrincipal THEN claw.[Description]
				ELSE ISNULL(claw_i18n.[Description], claw.[Description])
			END AS [Contact_Law_Description]
			,CASE 
				WHEN s.lang = @langPrincipal THEN s.[Contact_Articles]
				ELSE ISNULL(s_i18n.[Contact_Articles], s.[Contact_Articles])
			END AS [Contact_Articles]
			,tlaw.[Id] as [Timeframe_Law_Id]
			,CASE
				WHEN tlaw.lang = @langPrincipal THEN tlaw.[Name]
				ELSE ISNULL(tlaw_i18n.[Name], tlaw.[Name])
			END AS [Timeframe_Law_Name]
			,CASE
				WHEN tlaw.lang = @langPrincipal THEN tlaw.[Description]
				ELSE ISNULL(tlaw_i18n.[Description], tlaw.[Description])
			END AS [Timeframe_Law_Description]
			,CASE 
				WHEN s.lang = @langPrincipal THEN s.[Timeframe_Articles]
				ELSE ISNULL(s_i18n.[Timeframe_Articles], s.[Timeframe_Articles])
			END AS [Timeframe_Articles]
			,s.[Level_Id]
			,s.[NumberOfUsers]
			,CASE 
				WHEN s.lang = @langPrincipal THEN s.[Summary]
				ELSE ISNULL(s_i18n.[Summary], s.[Summary])
			END AS [Summary]
	FROM 
		(SELECT l.code as lang, s.* FROM [Admin_Step] s WITH(NOLOCK), SystemLanguage l) s
			LEFT JOIN Admin_Step_i18n s_i18n WITH(NOLOCK) ON s.[lang] = s_i18n.[lang] and s.[Id] = s_i18n.[Parent_Id]
			LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) claw 
				ON s.Contact_Law_Id = claw.[Id] AND s.lang = claw.lang
						LEFT JOIN [Law_i18n] claw_i18n WITH(NOLOCK) 
							ON claw.[Id] = claw_i18n.[Parent_Id] AND claw.lang = claw_i18n.lang
			LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) tlaw 
				ON s.Timeframe_Law_Id = tlaw.[Id] AND s.lang = tlaw.lang
						LEFT JOIN [Law_i18n] tlaw_i18n WITH(NOLOCK) 
							ON tlaw.[Id] = tlaw_i18n.[Parent_Id] AND tlaw.lang = tlaw_i18n.lang
			LEFT JOIN (SELECT l.code as lang, eic.* FROM SystemLanguage l, [dbo].[EntityInCharge] eic WITH(NOLOCK)) ceic
				ON s.CertificationEntityInCharge_Id = ceic.[Id] AND s.lang = ceic.lang
					LEFT JOIN [EntityInCharge_i18n] ceic_i18n WITH(NOLOCK)
						ON ceic.[Id] = ceic_i18n.[Parent_Id] AND ceic.lang = ceic_i18n.lang
	WHERE s.[IsRecourse] = 1 AND s.[Id] = @recourseId
	AND ISNULL(claw.deleted, 0) = 0
	AND ISNULL(tlaw.deleted, 0) = 0
	AND ISNULL(ceic.deleted, 0) = 0
	
	EXEC sp_take_snapshot_step @registryId, @objectiveId, @blockId, @recourseId	
		
				
	FETCH NEXT FROM recourse_cursor
	INTO @registryId, @objectiveId, @blockId, @stepId, @recourseOrder
END

CLOSE recourse_cursor
DEALLOCATE recourse_cursor

SET NOCOUNT OFF
END
GO

-- =============================================
-- Category 6: Major structural
-- Procedure: sp_update_snapshot_step
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_update_snapshot_step' AND type = 'P')
    DROP PROCEDURE [dbo].[sp_update_snapshot_step]
GO
CREATE PROCEDURE [dbo].[sp_update_snapshot_step]
(
	@stepId int,
	@date datetime
)
AS
BEGIN

SET NOCOUNT ON

DECLARE @langPrincipal varchar(2)
SET @langPrincipal = (SELECT TOP 1 code FROM SystemLanguage WHERE IsPrincipal = 1)

-- get all the registry for objectives where this step exists
DECLARE @registryId int, @objectiveId int, @blockId int, @stepOrder int, @stepIsParallele bit, @stepIsAlternative bit

-- get all the steps in the snapshot tables
DECLARE step_cursor CURSOR FOR 
	SELECT DISTINCT ss.registry_id, ss.objective_id, ss.block_id, ss.[order], ss.IsParallele, ss.IsAlternative
	FROM dbo.Snapshot_Step ss with(nolock)
	WHERE ss.id = @stepId AND ss.IsRecourse = 0
	AND ss.registry_id IN (SELECT sreg.id FROM Snapshot_Registry sreg with(nolock) WHERE sreg.IsCurrent = 1)
	AND ss.lang = @langPrincipal

OPEN step_cursor

FETCH NEXT FROM step_cursor
INTO @registryId, @objectiveId, @blockId, @stepOrder, @stepIsParallele, @stepIsAlternative
WHILE @@FETCH_STATUS = 0
BEGIN 
	
	/* 1. delete all from Snapshot_Step, 
					Snapshot_StepEntityInCharge, Snapshot_StepUnitInCharge, Snapshot_StepPersonInCharge,
					Snapshot_StepResult, Snapshot_StepRequirement, Snapshot_StepCost, Snapshot_StepLaw
					Snapshot_StepSectionVisibility,
					Snapshot_Object_Media 
	that are linked to the registry_Id and the @stepId of the current snapshot
	-- also delete one level further, get the recourses linked to the step adn delete also the dependencies of those recourses */
	
	-- delete dependencies
	DELETE FROM [dbo].[Snapshot_StepEntityInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepUnitInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepPersonInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepRegionalEntityInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepRegionalUnitInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepRegionalPersonInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))

	DELETE FROM [dbo].[Snapshot_StepRecourseEntityInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepRecourseUnitInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepRecoursePersonInCharge] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))

	DELETE FROM [dbo].[Snapshot_StepResult] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepRequirement] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepRequirementCost] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepCost] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepLaw] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_StepSectionVisibility] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	DELETE FROM [dbo].[Snapshot_Object_Media] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Step_Id] = @stepId OR [Step_Id] IN (SELECT [Id] FROM Snapshot_Step with(nolock) where IsRecourse = 1 and Step_Id = @stepId and [Registry_Id] = @registryId and [Objective_Id] = @objectiveId and [Block_Id] = @blockId))
	-- delete main object
	DELETE FROM [dbo].[Snapshot_Step] WHERE [Registry_Id] = @registryId AND [Objective_Id] = @objectiveId AND [Block_Id] = @blockId AND ([Id] = @stepId OR Step_Id = @stepId)


	/* 2. update the date in the snapshot registry to the current date for the current snapshot  */
	UPDATE [dbo].[Snapshot_Registry]
	SET [SnapshotDate] = @date
	WHERE [Id] = @registryId
	
	/*	3. for each Step in Admin_Block_Step add a new entry for each lang in 
			Snapshot_Step,
			Snapshot_StepEntityInCharge, Snapshot_StepUnitInCharge, Snapshot_StepPersonInCharge,
			Snapshot_StepResult, Snapshot_StepRequirement, Snapshot_StepCost, Snapshot_StepLaw
			Snapshot_StepSectionVisibility 
	*/	
	-- add Step
	INSERT INTO [dbo].[Snapshot_Step]([Registry_Id],[Objective_Id],[Block_Id]
		   ,[IsRecourse],[Step_Id]
		   ,[Order],[IsParallele],[IsAlternative]
		   ,[Certified], [CertificationDate], [CertificationUser], [CertificationEntityInCharge_Id]
		   ,[CertificationEntityInCharge_Name]
		   ,[Id],[Lang]
		   ,[Name]
		   ,[PhysicalPresence],[RepresentationThirdParty],[IsOnline],[OnlineType],[OnlineStepURL],[IsOptional],[RequirementsPhysicalPresence]
		   ,[HasCosts],[NoCostsReason],[IsPayMethodCash],[IsPayMethodCheck],[IsPayMethodCard],[IsPayMethodOther]
		   ,[PayMethodOtherText]
		   ,[CostsComments]
		   ,[WaintingTimeInLineMin],[WaintingTimeInLineMax],[TimeSpentAtTheCounterMin],[TimeSpentAtTheCounterMax],[WaitingTimeUntilNextStepMin],[WaitingTimeUntilNextStepMax]
		   ,[TimeframeComments]
		   ,[LawsComments]
		   ,[AdditionalInfo]
		   ,[Contact_Law_Id]
		   ,[Contact_Law_Name]
		   ,[Contact_Law_Description]
		   ,[Contact_Articles]
		   ,[Recourse_Law_Id]
		   ,[Recourse_Law_Name]
		   ,[Recourse_Law_Description]
		   ,[Recourse_Articles]
		   ,[Timeframe_Law_Id]
		   ,[Timeframe_Law_Name]
		   ,[Timeframe_Law_Description]
		   ,[Timeframe_Articles]
		   ,[IsInternal]
		   ,[SnapshotDate]
		   ,[Level_Id]
		   ,[NumberOfUsers]
		   ,[Summary])
	SELECT @registryId, @objectiveId, @blockId, 
			0, NULL, -- is no recourse, so the step_Id is NULL
			@stepOrder, @stepIsParallele, @stepIsAlternative,
			s.[Certified], s.[CertificationDate], s.[CertificationUser], s.[CertificationEntityInCharge_Id], 
			CASE 
				WHEN s.lang = @langPrincipal THEN ceic.[Name]
				ELSE ISNULL(ceic_i18n.[Name], ceic.[Name])
			END AS [CertificationEntityInCharge_Name], 
			@stepId, s.lang,
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[Name]
				ELSE ISNULL(s_i18n.[Name], s.[Name])
			END AS [Name],
			s.[PhysicalPresence],s.[RepresentationThirdParty],s.[IsOnline],s.[OnlineType],s.[OnlineStepURL],s.[IsOptional],s.[RequirementsPhysicalPresence],
			s.[HasCosts],s.[NoCostsReason],s.[IsPayMethodCash],s.[IsPayMethodCheck],s.[IsPayMethodCard],s.[IsPayMethodOther],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[PayMethodOtherText]
				ELSE ISNULL(s_i18n.[PayMethodOtherText], s.[PayMethodOtherText])
			END AS [PayMethodOtherText],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[CostsComments]
				ELSE ISNULL(s_i18n.[CostsComments], s.[CostsComments])
			END AS [CostsComments],
			s.[WaintingTimeInLineMin],s.[WaintingTimeInLineMax],s.[TimeSpentAtTheCounterMin],s.[TimeSpentAtTheCounterMax],s.[WaitingTimeUntilNextStepMin],s.[WaitingTimeUntilNextStepMax],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[TimeframeComments]
				ELSE ISNULL(s_i18n.[TimeframeComments], s.[TimeframeComments])
			END AS [TimeframeComments],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[LawsComments]
				ELSE ISNULL(s_i18n.[LawsComments], s.[LawsComments])
			END AS [LawsComments],
			CASE 
				WHEN s.lang = @langPrincipal THEN s.[AdditionalInfo]
				ELSE ISNULL(s_i18n.[AdditionalInfo], s.[AdditionalInfo])
			END AS [AdditionalInfo]
			,claw.[Id] as [Contact_Law_Id]
			,CASE
				WHEN claw.lang = @langPrincipal THEN claw.[Name]
				ELSE ISNULL(claw_i18n.[Name], claw.[Name])
			END AS [Contact_Law_Name]
			,CASE
				WHEN claw.lang = @langPrincipal THEN claw.[Description]
				ELSE ISNULL(claw_i18n.[Description], claw.[Description])
			END AS [Contact_Law_Description]
			,CASE 
				WHEN s.lang = @langPrincipal THEN s.[Contact_Articles]
				ELSE ISNULL(s_i18n.[Contact_Articles], s.[Contact_Articles])
			END AS [Contact_Articles]
			,rlaw.[Id] as [Recourse_Law_Id]
			,CASE
				WHEN rlaw.lang = @langPrincipal THEN rlaw.[Name]
				ELSE ISNULL(rlaw_i18n.[Name], rlaw.[Name])
			END AS [Recourse_Law_Name]
			,CASE
				WHEN rlaw.lang = @langPrincipal THEN rlaw.[Description]
				ELSE ISNULL(rlaw_i18n.[Description], rlaw.[Description])
			END AS [Recourse_Law_Description]
			,CASE 
				WHEN s.lang = @langPrincipal THEN s.[Recourse_Articles]
				ELSE ISNULL(s_i18n.[Recourse_Articles], s.[Recourse_Articles])
			END AS [Recourse_Articles]
			,tlaw.[Id] as [Timeframe_Law_Id]
			,CASE
				WHEN tlaw.lang = @langPrincipal THEN tlaw.[Name]
				ELSE ISNULL(tlaw_i18n.[Name], tlaw.[Name])
			END AS [Timeframe_Law_Name]
			,CASE
				WHEN tlaw.lang = @langPrincipal THEN tlaw.[Description]
				ELSE ISNULL(tlaw_i18n.[Description], tlaw.[Description])
			END AS [Timeframe_Law_Description]
			,CASE 
				WHEN s.lang = @langPrincipal THEN s.[Timeframe_Articles]
				ELSE ISNULL(s_i18n.[Timeframe_Articles], s.[Timeframe_Articles])
			END AS [Timeframe_Articles],
			s.IsInternal,
			GetDate()
			,s.[Level_Id]
			,s.[NumberOfUsers]
			,CASE 
				WHEN s.lang = @langPrincipal THEN s.[Summary]
				ELSE ISNULL(s_i18n.[Summary], s.[Summary])
			END AS [Summary]
	FROM 
		(SELECT l.code as lang, s.* FROM [Admin_Step] s WITH(NOLOCK), SystemLanguage l) s
			LEFT JOIN Admin_Step_i18n s_i18n WITH(NOLOCK) ON s.[lang] = s_i18n.[lang] and s.[Id] = s_i18n.[Parent_Id]
			LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) claw 
				ON s.Contact_Law_Id = claw.[Id] AND s.lang = claw.lang
						LEFT JOIN [Law_i18n] claw_i18n WITH(NOLOCK) 
							ON claw.[Id] = claw_i18n.[Parent_Id] AND claw.lang = claw_i18n.lang
			LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) rlaw 
				ON s.Recourse_Law_Id = rlaw.[Id] AND s.lang = rlaw.lang
						LEFT JOIN [Law_i18n] rlaw_i18n WITH(NOLOCK) 
							ON rlaw.[Id] = rlaw_i18n.[Parent_Id] AND rlaw.lang = rlaw_i18n.lang
			LEFT JOIN (SELECT l.code as lang, law.* FROM SystemLanguage l, [dbo].[Law] law WITH(NOLOCK)) tlaw 
				ON s.Timeframe_Law_Id = tlaw.[Id] AND s.lang = tlaw.lang
						LEFT JOIN [Law_i18n] tlaw_i18n WITH(NOLOCK) 
							ON tlaw.[Id] = tlaw_i18n.[Parent_Id] AND tlaw.lang = tlaw_i18n.lang
			LEFT JOIN (SELECT l.code as lang, eic.* FROM SystemLanguage l, [dbo].[EntityInCharge] eic WITH(NOLOCK)) ceic
				ON s.CertificationEntityInCharge_Id = ceic.[Id] AND s.lang = ceic.lang
					LEFT JOIN [EntityInCharge_i18n] ceic_i18n WITH(NOLOCK)
						ON ceic.[Id] = ceic_i18n.[Parent_Id] AND ceic.lang = ceic_i18n.lang
	WHERE s.[Id] = @stepId
	AND ISNULL(claw.deleted, 0) = 0
	AND ISNULL(rlaw.deleted, 0) = 0
	AND ISNULL(tlaw.deleted, 0) = 0
	AND ISNULL(ceic.deleted, 0) = 0
		
	EXEC sp_take_snapshot_step @registryId, @objectiveId, @blockId, @stepId	

	FETCH NEXT FROM step_cursor
	INTO @registryId, @objectiveId, @blockId, @stepOrder, @stepIsParallele, @stepIsAlternative
END

CLOSE step_cursor
DEALLOCATE step_cursor

SET NOCOUNT OFF
END
GO

-- =============================================
-- Verification
-- =============================================
PRINT '========================================='
PRINT 'Migration 050_update_stored_procedures completed successfully'
PRINT 'Updated 39 stored procedures'
PRINT '========================================='
GO
