CREATE Procedure dbo.SolicitudSencillo$BuscaEmpresaXEstacion_bca
----------------------------------------------------------------------------
-- Procedimiento: SolicitudSencillo$TraeDenMon_bca
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Se agrega a salida los campos Bodega y ListaVenta
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Se agrega a salida los campos Bodega y ListaVenta, basado en el SAV_CJ_BuscaEmpresaXEstacion 
----------------------------------------------------------------------------
	@Estacion	AS CHAR(50)
    ,@Error_Message NVARCHAR(4000) OUTPUT
AS
	BEGIN
		SET NOCOUNT ON
		SET Xact_Abort On

			-- #RESULTSET	solicitud solicitudes
        	--  #COLUMN   Estacion      		NVARCHAR   
			--  #COLUMN   Cod_Emp				NVARCHAR
			--  #COLUMN   NOM_EMP				NVARCHAR
			--  #COLUMN   TipoEstacion  		NVARCHAR
			--  #COLUMN   Descripcion   		NVARCHAR
			--  #COLUMN   BODEGA 				NVARCHAR
			--  #COLUMN   LISTAVENTA 			NVARCHAR
			--  #COLUMN   Cod_Region 			NVARCHAR
			--  #COLUMN   RAZONSOCIAL_SII		NVARCHAR
			--  #COLUMN   AjusteSencillo		NVARCHAR
			--  #COLUMN   TipoFac_EcoRetiro		NVARCHAR
			--  #COLUMN   TipoFac_EcoDespacho	NVARCHAR
			-- #ENDRESULTSET

		SELECT 
			CAST(Ltrim(Rtrim(Sce.Estacion))				AS NVARCHAR) AS Estacion,
			CAST(Ltrim(Rtrim(Sce.Cod_Emp))				AS NVARCHAR) AS Cod_Emp,
			CAST(Ltrim(Rtrim(Se.NOM_EMP))				AS NVARCHAR) AS NOM_EMP,
			CAST(Ltrim(Rtrim(Sce.TipoEstacion))			AS NVARCHAR) AS TipoEstacion,
			CAST(Ltrim(Rtrim(Sce.Descripcion))			AS NVARCHAR) AS Descripcion,
			CAST(Ltrim(Rtrim(Se.BODEGA))				AS NVARCHAR) AS BODEGA,
			CAST(Ltrim(Rtrim(Se.LISTAVENTA))			AS NVARCHAR) AS LISTAVENTA,
			CAST(Ltrim(Rtrim(Se.Cod_Region))			AS NVARCHAR) AS Cod_Region,		
			CAST(Ltrim(Rtrim(Se.RAZONSOCIAL_SII))		AS NVARCHAR) AS RAZONSOCIAL_SII,	
			CAST(Ltrim(Rtrim(Se.AjusteSencillo))		AS NVARCHAR) AS AjusteSencillo,
			CAST(Ltrim(Rtrim(Se.TipoFac_EcoRetiro))		AS NVARCHAR) AS TipoFac_EcoRetiro,
			CAST(Ltrim(Rtrim(Se.TipoFac_EcoDespacho))	AS NVARCHAR) AS TipoFac_EcoDespacho
			FROM SAV_CJ.dbo.SAV_CJ_Estaciones Sce WITH(NOLOCK)
				Inner Join SAV.dbo.SAV_EMPRESAS Se WITH(NOLOCK) ON Se.COD_EMP = Sce.Cod_Emp
				WHERE Sce.Estacion	= @Estacion
				  AND Se.Estado		= 'HA'


		IF @@Error <> 0
		BEGIN
			SELECT
			@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
			RETURN
		END
	END





