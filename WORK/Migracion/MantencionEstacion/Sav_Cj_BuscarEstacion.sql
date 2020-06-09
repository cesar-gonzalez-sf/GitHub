ALTER PROCEDURE dbo.EstacionMantencion$BuscaEst_bca
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Procedimiento: EstacionMantencion$BuscaEst_bca
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Busca Estacion
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Busca Estación, basado en el Sav_Cj_BuscarEstacion 
----------------------------------------------------------------------------

 @Est as Char (50)
,@Error_Message Nvarchar(4000) OUTPUT

AS
	SET NOCOUNT ON
	Set Xact_Abort On

		-- #RESULTSET	estacion estaciones
		--   #COLUMN	Estacion 			NVARCHAR
		--   #COLUMN	Cod_Emp				NVARCHAR
		--   #COLUMN	TipoEstacion 		NVARCHAR
		--   #COLUMN	Descripcion			NVARCHAR
		--   #COLUMN	Sucursal_Random		NVARCHAR
		--   #COLUMN	Estacion_Random		NVARCHAR
		-- #ENDRESULTSET

	SELECT Estacion,Cod_Emp,TipoEstacion,Descripcion,Sucursal_Random,Estacion_Random
		FROM SAV_CJ.dbo.SAV_CJ_Estaciones WITH(NoLock)
			WHERE Estacion	Like ltrim(rtrim(@Est))

IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END













