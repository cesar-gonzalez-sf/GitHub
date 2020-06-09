ALTER PROCEDURE dbo.EstacionMantencion$BuscaUsu_bca
----------------------------------------------------------------------------
-- Procedimiento: EstacionMantencion$BuscaUsu_bca
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Trae usuarios con la empresa relacionada
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Trae usuarios con la empresa relacionada, basado en el SAV_CJ_Usuarios_Traer
----------------------------------------------------------------------------


	 @USU_CODIGO	AS CHAR(40)
	,@Error_Message NVARCHAR(4000) OUTPUT

AS
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
		-- #RESULTSET	estacion estaciones
		--   #COLUMN	USU_CODIGO 		NVARCHAR
		--   #COLUMN	APELLIDO_PAT	NVARCHAR
		--   #COLUMN	APELLIDO_MAT 	NVARCHAR
		--   #COLUMN	NOMBRES			NVARCHAR
		--   #COLUMN	COMUNA			NVARCHAR
		--   #COLUMN	CIUDAD			NVARCHAR
		--   #COLUMN	PAIS			NVARCHAR
		-- #ENDRESULTSET

	SELECT
		CAST(Ltrim(Rtrim(USU_CODIGO))	AS NVARCHAR) AS USU_CODIGO
	   ,CAST(Ltrim(Rtrim(APELLIDO_PAT)) AS NVARCHAR) AS APELLIDO_PAT
	   ,CAST(Ltrim(Rtrim(APELLIDO_MAT)) AS NVARCHAR) AS APELLIDO_MAT
	   ,CAST(Ltrim(Rtrim(NOMBRES))		AS NVARCHAR) AS NOMBRES
	   ,CAST(Ltrim(Rtrim(COMUNA))		AS NVARCHAR) AS COMUNA
	   ,CAST(Ltrim(Rtrim(CIUDAD))		AS NVARCHAR) AS CIUDAD
	   ,CAST(Ltrim(Rtrim(PAIS))			AS NVARCHAR) AS PAIS
			FROM ECUBAS..EcuACCUSU WITH(NOLOCK)
				WHERE USU_CODIGO = @USU_CODIGO
		
IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END
RETURN 1




