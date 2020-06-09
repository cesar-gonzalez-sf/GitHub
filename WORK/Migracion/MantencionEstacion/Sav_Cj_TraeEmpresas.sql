ALTER PROCEDURE dbo.EstacionMantencion$BuscaEmp_bca
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Procedimiento: EstacionMantencion$BuscaEmp_bca
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Busca Empresa
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Busca Empresa, basado en el [Sav_Cj_TraeEmpresas] 

@Error_Message NVARCHAR(4000) OUTPUT

AS
	SET NOCOUNT ON
	SET XACT_ABORT ON

	SELECT COD_EMP,NOM_EMP
		FROM SAV.dbo.SAV_EMPRESAS WITH(NoLock) 
			WHERE CON_GRAL = 'S'

	RETURN 

	IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END


