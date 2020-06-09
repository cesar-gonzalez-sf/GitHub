ALTER PROCEDURE TipoDocumento$BuscaClienteRut_bca 
----------------------------------------------------------------------------
-- Procedimiento: CajaUnificada$BuscaClienteRut_bca' '7434004',''
-- Autor: César González-Rubio
-- Fecha de Creacion: 26/12/2019 
-- Objetivo: Busca Cliente en Base al Rut
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Busca Cliente en Base al Rut, basado en el SAV_CJ_BuscaClienteRut 
----------------------------------------------------------------------------

	@vRut_Cliente	As VARCHAR(13)
   ,@Error_Message NVARCHAR(4000) = '' OUTPUT

AS 
	BEGIN
		SET NOCOUNT ON
		SET Xact_Abort ON   10069017

			-- #RESULTSET	cliente clientes
			--   #COLUMN	COD_ENTIDAD 		NVARCHAR
			--   #COLUMN	ID_CLIENTE			NVARCHAR
			--   #COLUMN	COD_SUCURSAL 		NVARCHAR
			--   #COLUMN	RUT_CLIENTE			NVARCHAR
			--   #COLUMN	DV_CLIENTE			NVARCHAR
			--   #COLUMN	NOMBRE				NVARCHAR
			--   #COLUMN	PATERNO				NVARCHAR
			--   #COLUMN	MATERNO				NVARCHAR
			--   #COLUMN	CLIENTE				NVARCHAR
			--   #COLUMN	ESTADO				NVARCHAR
			--   #COLUMN	CLI_CATEGORIA		NVARCHAR
			--   #COLUMN	PLAZO				NVARCHAR
			--   #COLUMN	TIPOPERSONALIDAD	NVARCHAR
			--   #COLUMN	CREDITO				NVARCHAR
			--   #COLUMN	LISTA_PRECIO		NVARCHAR
			--   #COLUMN	ESTADO_CLIENTE		NVARCHAR
			--   #COLUMN	CRED_ABIERTO_DOC	NVARCHAR
			-- #ENDRESULTSET

		Set @Error_Message = ''

		SELECT TOP 1
			  CAST(Ltrim(Rtrim(Cm.COD_ENTIDAD))						AS NVARCHAR(30))		AS COD_ENTIDAD			  		
			, CAST(Ltrim(Rtrim(Cm.Id_Cliente))						AS NVARCHAR(500))		AS ID_CLIENTE
			, CAST(Ltrim(Rtrim(Cm.COD_SUCURSAL))					AS NVARCHAR(3))			AS COD_SUCURSAL
			, CAST(Ltrim(Rtrim(Cm.RUT_CLIENTE))						AS NVARCHAR(30))		AS RUT_CLIENTE
			, CAST(Ltrim(Rtrim(Cm.DV_CLIENTE))						AS NVARCHAR(1))			AS DV_CLIENTE
			, CAST(Ltrim(Rtrim(Cm.NOMBRE))							AS NVARCHAR(300))		AS NOMBRE
			, CAST(Ltrim(Rtrim(Cm.PATERNO))							AS NVARCHAR(300))		AS PATERNO 
			, CAST(Ltrim(Rtrim(Cm.MATERNO ))						AS NVARCHAR(300))		AS MATERNO 
			, CAST(Ltrim(Rtrim(Cm.CLIENTE ))						AS NVARCHAR(500))		AS CLIENTE 
			, CAST(Ltrim(Rtrim(Cm.ESTADO ))							AS NVARCHAR(1))			AS ESTADO
			, IsNull(CAST(Ltrim(Rtrim(Cm.CLI_CATEGORIA))			AS NVARCHAR(100)),'')	AS CLI_CATEGORIA
			, IsNull(CAST(Ltrim(Rtrim(Cp.PLAZO + 90))				AS NVARCHAR(50)),'0')	AS PLAZO
			, CAST(Ltrim(Rtrim(Cm.TIPOPERSONALIDAD ))				AS NVARCHAR(1))			AS TIPOPERSONALIDAD
			, CAST(LTRIM(RTRIM(Cm.CREDITO))							AS NVARCHAR(1))			AS CREDITO
			, CAST(LTRIM(RTRIM(asig.COD_LISTAPRECIO))				AS NVARCHAR(3))			AS LISTA_PRECIO
			, ESTADO_CLIENTE  = (CASE Ltrim(Rtrim(Cm.ESTADO)) 
									WHEN 'A' THEN 'ACTIVO' 
									WHEN 'B' THEN 'BLOQUEADO' 
									WHEN 'D' THEN 'BLOQUEO DESPACHO' 
									WHEN 'M' THEN 'BLQ. SIN MOV.' 
								END)            
			, CRED_ABIERTO_DOC = (CASE WHEN (cre.CRED_SINDOCUMENTOS > 0 AND (cre.CRED_CHEQUES - cre.CRED_SINDOCUMENTOS) = 0 ) THEN 'A' 
									   WHEN (cre.CRED_SINDOCUMENTOS = 0 AND  cre.CRED_CHEQUES > 0 ) THEN 'D'
									   WHEN (cre.CRED_SINDOCUMENTOS > 0 AND (cre.CRED_CHEQUES - cre.CRED_SINDOCUMENTOS) > 0 ) THEN 'T' ELSE 'N' 
							     END) 
				FROM SAV.dbo.CLI_MAESTRO Cm WITH(NOLOCK)
					LEFT OUTER JOIN SAV.dbo.CLI_Poliza Cp WITH(NOLOCK) ON Cp.COD_ENTIDAD = Cm.COD_ENTIDAD AND Cp.COD_SUCURSAL = Cm.COD_SUCURSAL
					LEFT OUTER JOIN SAV.dbo.PAR_POLIZAESTADOS Ppe WITH(NOLOCK) ON Ppe.Cod_Estado = Cp.COD_ESTADO AND Ppe.Nombre	Not Like '%IMPERIAL%'				
					LEFT JOIN SAV.dbo.CLI_ASIGNACION asig WITH(NOLOCK) ON asig.COD_ENTIDAD = cm.COD_ENTIDAD
					LEFT JOIN SAV.dbo.Cli_Credito Cre (NOLOCK) ON Cm.Cod_Entidad  = Cre.Cod_Entidad AND Cm.Cod_Sucursal = Cre.Cod_Sucursal
						WHERE Cm.RUT_CLIENTE = CONVERT(VARCHAR(13), @vRut_Cliente)
	END

IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END
