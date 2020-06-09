CREATE PROCEDURE dbo.SolicitudSencillo$TraeDenMon_bca 
----------------------------------------------------------------------------
-- Procedimiento: SolicitudSencillo$TraeDenMon_bca
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Trae detalle Denominaciones de dinero
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Trae detalle Denominaciones de dinero, basado en el SAV_TS_TraeDenMon 
----------------------------------------------------------------------------
	@Estado		   VARCHAR(1) = ''			-- Vacio trae todos, '1' Vigentes, '0' No vigentes.
   ,@Error_Message NVARCHAR(4000) OUTPUT
AS 
	SET NOCOUNT ON
	SET Xact_Abort On

			-- #RESULTSET	solicitud solicitudes
        	--  #COLUMN   CODIGO  NVARCHAR   
			--  #COLUMN   GLOSA   NVARCHAR
			--  #COLUMN   VALOR   NVARCHAR
			--  #COLUMN   ESTADO  NVARCHAR
			-- #ENDRESULTSET

	BEGIN  
		SELECT	
			CAST(Ltrim(Rtrim(CODIGO)) AS NVARCHAR) AS CODIGO, 
			CAST(Ltrim(Rtrim(GLOSA))  AS NVARCHAR) AS GLOSA, 
			CAST(Ltrim(Rtrim(VALOR))  AS NVARCHAR) AS VALOR, 
			CAST(Ltrim(Rtrim(ESTADO)) AS NVARCHAR) AS ESTADO
			FROM SAV_CJ.dbo.SAV_TS_DenMon WITH(NoLock) 
				WHERE ESTADO = (CASE	WHEN @Estado = '' THEN ESTADO ELSE @Estado END ) ORDER BY VALOR
	  
		IF @@RowCount = 0  
			RETURN 
	END

GRANT EXECUTE ON SAV.dbo.SAV_TS_TraeDenMon To SavSysUser

IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END


