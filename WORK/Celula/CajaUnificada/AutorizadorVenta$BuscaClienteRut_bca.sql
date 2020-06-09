CREATE PROCEDURE AutorizadorVenta$BuscaClienteRut_bca 
----------------------------------------------------------------------------
-- Procedimiento: AutorizadorVenta$BuscaClienteRut_bca   '7434004', '07434004', '001', ''
-- Autor: César González-Rubio
-- Fecha de Creacion: 26/02/2020 
-- Objetivo: Busca Cliente en Base al Rut
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Busca Cliente en Base al Rut, basado en el SAV_CJ_BuscaClienteRut 
----------------------------------------------------------------------------

	@RUT_CLIENTE	As VARCHAR(13),
	@COD_ENTIDAD	VARCHAR(13),
	@COD_SUCURSAL	VARCHAR(3),
	@VALIDO			VARCHAR(1) = '' OUTPUT,
    @Error_Message NVARCHAR(4000) = '' OUTPUT

AS 
	BEGIN
		SET NOCOUNT ON
		SET Xact_Abort ON

			-- #RESULTSET	cliente clientes
			--   #COLUMN	RUT_CLIENTE		NVARCHAR
			--   #COLUMN	DV_CLIENTE		NVARCHAR
			--   #COLUMN	COD_ENTIDAD 	NVARCHAR
			--   #COLUMN	COD_SUCURSAL	NVARCHAR
			--   #COLUMN	CLIENTE			rNVARCHAR
			-- #ENDRESULTSET

		Set @Error_Message = ''
		SET @VALIDO = 'N'

		SELECT TOP 1
			  CAST(Ltrim(Rtrim(RUT_CLIENTE))	AS NVARCHAR(30))		AS RUT_CLIENTE
			, CAST(Ltrim(Rtrim(DV_CLIENTE))		AS NVARCHAR(1))			AS DV_CLIENTE
			, CAST(Ltrim(Rtrim(COD_ENTIDAD))	AS NVARCHAR(500))		AS COD_ENTIDAD
			, CAST(Ltrim(Rtrim(COD_SUCURSAL))	AS NVARCHAR(3))			AS COD_SUCURSAL
			, CAST(Ltrim(Rtrim(CLIENTE))		AS NVARCHAR(30))		AS RUT_CLIENTE			           
				FROM SAV.dbo.CLI_MAESTRO WITH(NOLOCK)				
						WHERE RUT_CLIENTE = CONVERT(VARCHAR(13), @Rut_Cliente)
	END

	IF EXISTS (SELECT TOP 1 1 FROM SAV.DBO.CLI_MAESTRO WITH(NOLOCK)
				WHERE RUT_CLIENTE = CONVERT(VARCHAR(13), @Rut_Cliente)
				AND COD_ENTIDAD = @COD_ENTIDAD
				AND COD_SUCURSAL = @COD_SUCURSAL)
	BEGIN
		SET @VALIDO = 'S'
	END

IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END