ALTER PROCEDURE dbo.SolicitudSencillo$TraeSolicitudCJ_bca 
----------------------------------------------------------------------------
-- Procedimiento: SolicitudSencillo$TraeSolicitudCJ_bca 20944, ''
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Trae envio de Solicitud Sencillo
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Trae envio de Solicitud Sencillo, basado en el SAV_TS_TraeSolicitudCJ 
----------------------------------------------------------------------------

	 @Nro_INTerno INT
	,@Error_Message NVARCHAR(4000) OUTPUT

AS
	BEGIN
		SET NOCOUNT ON
		SET Xact_Abort On

			-- #RESULTSET	solicitud solicitudes
        	--  #COLUMN   Nro_INTerno      	NVARCHAR   
			--  #COLUMN   Nro_INTernoPadre  NVARCHAR
			--  #COLUMN   Tipo_Transaccion  NVARCHAR
			--  #COLUMN   Cod_Emp  			NVARCHAR
			--  #COLUMN   Fecha   			NVARCHAR
			--  #COLUMN   Monto_Efectivo 	NVARCHAR
			--  #COLUMN   Monto_Documentos 	NVARCHAR
			--  #COLUMN   Usuario 			NVARCHAR
			--  #COLUMN   Estacion			NVARCHAR
			--  #COLUMN   Estado			NVARCHAR
			--  #COLUMN   Cod_UsuRecibe		NVARCHAR
			--  #COLUMN   Cierre			NVARCHAR
			--  #COLUMN   Nom_Emp			NVARCHAR
			--  #COLUMN   Codigo_Den		NVARCHAR
			--  #COLUMN   Cantidad_Den		NVARCHAR
			--  #COLUMN   Tipo_Documento	NVARCHAR
			--  #COLUMN   Id_Documento		NVARCHAR
			--  #COLUMN   Monto				NVARCHAR
			--  #COLUMN   Numero			NVARCHAR
			--  #COLUMN   Cuenta			NVARCHAR
			--  #COLUMN   SaldoCMR			NVARCHAR
			-- #ENDRESULTSET

			DECLARE @Cod_Emp	VARCHAR(8)
			    SET @Cod_Emp	= ''

		SELECT	@Cod_Emp = ENV.Cod_Emp
 			FROM SAV_CJ.dbo.SAV_TS_Envio ENV WITH(NoLock)
				WHERE ENV.Nro_INTerno = @Nro_INTerno

		SELECT 
			CAST(Ltrim(Rtrim(ENV.Nro_INTerno))		AS NVARCHAR) AS  Nro_INTerno
		   ,CAST(Ltrim(Rtrim(ENV.Nro_INTernoPadre)) AS NVARCHAR) AS  Nro_INTernoPadre 
		   ,CAST(Ltrim(Rtrim(ENV.Tipo_Transaccion)) AS NVARCHAR) AS  Tipo_Transaccion 
		   ,CAST(Ltrim(Rtrim(ENV.Cod_Emp))			AS NVARCHAR) AS  Cod_Emp  
		   ,CAST(Ltrim(Rtrim(ENV.Fecha))			AS NVARCHAR) AS  Fecha   
		   ,CAST(Ltrim(Rtrim(ENV.Monto_Efectivo))	AS NVARCHAR) AS  Monto_Efectivo 
		   ,CAST(Ltrim(Rtrim(ENV.Monto_Documentos)) AS NVARCHAR) AS  Monto_Documentos 
		   ,CAST(Ltrim(Rtrim(ENV.Usuario))			AS NVARCHAR) AS  Usuario 
		   ,CAST(Ltrim(Rtrim(ENV.Estacion))			AS NVARCHAR) AS  Estacion
		   ,CAST(Ltrim(Rtrim(ENV.Estado))			AS NVARCHAR) AS  Estado
		   ,CAST(Ltrim(Rtrim(ENV.Cod_UsuRecibe))	AS NVARCHAR) AS  Cod_UsuRecibe
		   ,CAST(Ltrim(Rtrim(ENV.Cierre))			AS NVARCHAR) AS  Cierre
		   ,Nom_Emp = IsNull(SUC.RAZONSOCIAL_SII,''), ENV.Tipo_Envio
 				FROM SAV_CJ.dbo.SAV_TS_Envio ENV WITH(NoLock)
					LEFT JOIN SAV.dbo.SAV_Empresas SUC On ENV.Cod_Emp = SUC.Cod_Emp
						WHERE ENV.Nro_INTerno = @Nro_INTerno

		IF @@RowCount = 0
			RETURN 

		SELECT
			 CAST(Ltrim(Rtrim(Nro_INTerno))		 AS NVARCHAR) AS  Nro_INTerno 
			,CAST(Ltrim(Rtrim(Tipo_Transaccion)) AS NVARCHAR) AS  Tipo_Transaccion  
			,CAST(Ltrim(Rtrim(Codigo_Den))		 AS NVARCHAR) AS  Codigo_Den   
			,CAST(Ltrim(Rtrim(Cantidad_Den))	 AS NVARCHAR) AS  Cantidad_Den
				FROM SAV_CJ.dbo.SAV_TS_Detalle_Efectivo WITH(NoLock)
					WHERE Nro_INTerno = @Nro_INTerno ORDER BY Tipo_Transaccion, Codigo_Den

		SELECT
			 CAST(Ltrim(Rtrim(Nro_INTerno))						AS NVARCHAR) AS  Nro_INTerno 
			,CAST(Ltrim(Rtrim(Tipo_Transaccion))				AS NVARCHAR) AS  Tipo_Transaccion  
			,CAST(Ltrim(Rtrim(REPLACE( Tipo_Documento,'-',''))) AS NVARCHAR)  AS Tipo_Documento
			,CAST(Ltrim(Rtrim(Id_Documento))					AS NVARCHAR) AS  Id_Documento 
			,CAST(Ltrim(Rtrim(Monto))							AS NVARCHAR) AS  Monto
			,CAST(Ltrim(Rtrim(Numero))							AS NVARCHAR) AS  Numero 
			,CAST(Ltrim(Rtrim(Cuenta))							AS NVARCHAR) AS  Cuenta 
				FROM SAV_CJ.dbo.SAV_TS_Detalle_Documentado WITH(NoLock)
					WHERE Nro_INTerno = @Nro_INTerno ORDER BY Tipo_Documento, Monto

		SELECT
			CAST(Ltrim(Rtrim(SaldoCMR)) AS NVARCHAR) AS  SaldoCMR  
				FROM SAV_CJ.dbo.SAV_TS_RecepcionFondoVueltoTransporte WITH(NoLock)
					WHERE cod_emp = @Cod_Emp 
					  AND nro_interno = (SELECT MAX(nro_interno) 
											FROM SAV_CJ.dbo.SAV_TS_RecepcionFondoVueltoTransporte 
												WHERE cod_emp = @Cod_Emp)
		RETURN 
	END

GRANT EXECUTE ON SAV.dbo.SAV_TS_TraeSolicitudCJ To SavSysUser

IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END



