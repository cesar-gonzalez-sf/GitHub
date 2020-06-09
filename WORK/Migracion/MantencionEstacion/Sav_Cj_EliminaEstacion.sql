ALTER PROCEDURE dbo.EstacionMantencion$EliminaEst_eli
----------------------------------------------------------------------------
-- Procedimiento: EstacionMantencion$EliminaEst_eli
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Elimina Estacion
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Elimina Estación, bASado en el Sav_Cj_EliminaEstacion 
----------------------------------------------------------------------------

  @Est		CHAR (50)
 ,@Error_Message NVARCHAR(4000) OUTPUT

AS
	SET NOCOUNT ON
	SET XACT_ABORT ON

	DELETE
		FROM SAV_CJ.dbo.SAV_CJ_Estaciones 	
			WHERE Estacion = @Est

IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END


