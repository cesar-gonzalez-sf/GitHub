ALTER PROCEDURE dbo.SolicitudSencillo$BuscaUltimoVoucher_bca 
----------------------------------------------------------------------------
-- Procedimiento: SolicitudSencillo$BuscaUltimoVoucher_bca 'RetiroCJ', 'MADERA','AMALDONADOR',''
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Trae ultimo envio de Solicitud Sencillo/Fondo Vuelto
-- Empresa: SF Ingenieria. 
-- DESCripción: Se normaliza procedimiento para DestokFX, Busca el ultimo voucher, basado en el SAV_TS_BuscaUltimoVoucher 
----------------------------------------------------------------------------

	 @Tipo_Tran		VARCHAR(20)
	,@Cod_Emp		CHAR(8)
	,@Usuario		CHAR(40)
	,@Error_Message NVARCHAR(4000) OUTPUT

AS 
	BEGIN
		SET NOCOUNT ON
		SET Xact_Abort On

		-- #RESULTSET	bandeja bandejas
			--   #COLUMN	Identificador 		NVARCHAR
			--   #COLUMN	Descripcion			NVARCHAR
			--   #COLUMN	ID_BandejaPos 		NVARCHAR
			--   #COLUMN	DesEstado			NVARCHAR
			--   #COLUMN	Estado				NVARCHAR
			-- #ENDRESULTSET

		IF @Tipo_Tran = ''
			BEGIN
				SET @Tipo_Tran = NULL
			END

		IF @Cod_Emp = ''
			BEGIN
				SET @Cod_Emp = NULL
			END

		IF @Usuario = ''
			BEGIN
				SET @Usuario = NULL
			END

		IF @Tipo_Tran = 'RetiroCJCierre'
			BEGIN
				SELECT TOP 1
						 CAST(Ltrim(Rtrim(ENV.Nro_Interno))		 AS NVARCHAR) AS Nro_Interno			
						,CAST(Ltrim(Rtrim(ENV.Nro_InternoPadre)) AS NVARCHAR) AS Nro_InternoPadre		   
						,CAST(Ltrim(Rtrim(ENV.Tipo_Transaccion)) AS NVARCHAR) AS Tipo_Transaccion		   
						,CAST(Ltrim(Rtrim(ENV.Cod_Emp))			 AS NVARCHAR) AS Cod_Emp		   
						,CAST(Ltrim(Rtrim(ENV.Fecha))			 AS NVARCHAR) AS Fecha		   
						,CAST(Ltrim(Rtrim(ENV.Monto_Efectivo))	 AS NVARCHAR) AS Monto_Efectivo	   
						,CAST(Ltrim(Rtrim(ENV.Monto_Documentos)) AS NVARCHAR) AS Monto_Documentos	   
						,CAST(Ltrim(Rtrim(ENV.Usuario))			 AS NVARCHAR) AS Usuario		   
						,CAST(Ltrim(Rtrim(ENV.Estacion))		 AS NVARCHAR) AS Estacion		   
						,CAST(Ltrim(Rtrim(ENV.Estado))			 AS NVARCHAR) AS Estado	   
						,CAST(Ltrim(Rtrim(ENV.Cod_UsuRecibe))	 AS NVARCHAR) AS Cod_UsuRecibe		   
						,CAST(Ltrim(Rtrim(ENV.Cierre))			 AS NVARCHAR) AS Cierre		   
					FROM SAV_CJ.dbo.SAV_TS_Envio ENV WITH (NOLOCK)
						WHERE ENV.Tipo_Transaccion = 'RetiroCJ' 
						  AND ENV.Cod_Emp = COALESCE(@Cod_Emp, ENV.Cod_Emp)	
						  AND ENV.Usuario = COALESCE(@Usuario, ENV.Usuario)	
						  AND ENV.Cierre = 'S'
							ORDER BY ENV.Nro_Interno DESC
			END
		ELSE 
			IF @Tipo_Tran = 'RetiroCJParcial'
				BEGIN
					SELECT TOP 1
							 CAST(Ltrim(Rtrim(ENV.Nro_Interno))		 AS NVARCHAR) AS Nro_Interno				
							,CAST(Ltrim(Rtrim(ENV.Nro_InternoPadre)) AS NVARCHAR) AS Nro_InternoPadre	
							,CAST(Ltrim(Rtrim(ENV.Tipo_Transaccion)) AS NVARCHAR) AS Tipo_Transaccion	
							,CAST(Ltrim(Rtrim(ENV.Cod_Emp))			 AS NVARCHAR) AS Cod_Emp	
							,CAST(Ltrim(Rtrim(ENV.Fecha))			 AS NVARCHAR) AS Fecha		
							,CAST(Ltrim(Rtrim(ENV.Monto_Efectivo))	 AS NVARCHAR) AS Monto_Efectivo	
							,CAST(Ltrim(Rtrim(ENV.Monto_Documentos)) AS NVARCHAR) AS Monto_Documentos	
							,CAST(Ltrim(Rtrim(ENV.Usuario))			 AS NVARCHAR) AS Usuario	
							,CAST(Ltrim(Rtrim(ENV.Estacion))		 AS NVARCHAR) AS Estacion		
							,CAST(Ltrim(Rtrim(ENV.Estado))			 AS NVARCHAR) AS Estado		
							,CAST(Ltrim(Rtrim(ENV.Cod_UsuRecibe))	 AS NVARCHAR) AS Cod_UsuRecibe	
							,CAST(Ltrim(Rtrim(ENV.Cierre))			 AS NVARCHAR) AS Cierre		
						FROM SAV_CJ.dbo.SAV_TS_Envio ENV WITH (NOLOCK)
							WHERE   ENV.Tipo_Transaccion = 'RetiroCJ' 
								AND ENV.Cod_Emp = COALESCE(@Cod_Emp, ENV.Cod_Emp)	
								AND ENV.Usuario = COALESCE(@Usuario, ENV.Usuario)	
								AND ENV.Cierre = 'N'
								ORDER BY ENV.Nro_Interno DESC
				END
		ELSE
			BEGIN		
				SELECT TOP 1
						 CAST(Ltrim(Rtrim(ENV.Nro_Interno))		 AS NVARCHAR) AS Nro_Interno			 
						,CAST(Ltrim(Rtrim(ENV.Nro_InternoPadre)) AS NVARCHAR) AS Nro_InternoPadre	
						,CAST(Ltrim(Rtrim(ENV.Tipo_Transaccion)) AS NVARCHAR) AS Tipo_Transaccion	
						,CAST(Ltrim(Rtrim(ENV.Cod_Emp))			 AS NVARCHAR) AS Cod_Emp							
						,CAST(Ltrim(Rtrim(ENV.Fecha))			 AS NVARCHAR) AS Fecha		
						,CAST(Ltrim(Rtrim(ENV.Monto_Efectivo))	 AS NVARCHAR) AS Monto_Efectivo	
						,CAST(Ltrim(Rtrim(ENV.Monto_Documentos)) AS NVARCHAR) AS Monto_Documentos	
						,CAST(Ltrim(Rtrim(ENV.Usuario))			 AS NVARCHAR) AS Usuario	
						,CAST(Ltrim(Rtrim(ENV.Estacion))		 AS NVARCHAR) AS Estacion	
						,CAST(Ltrim(Rtrim(ENV.Estado))			 AS NVARCHAR) AS Estado	
						,CAST(Ltrim(Rtrim(ENV.Cod_UsuRecibe))	 AS NVARCHAR) AS Cod_UsuRecibe	
						,CAST(Ltrim(Rtrim(ENV.Cierre))			 AS NVARCHAR) AS Cierre	
					FROM SAV_CJ.dbo.SAV_TS_Envio ENV WITH (NOLOCK)
						WHERE   ENV.Tipo_Transaccion = COALESCE(@Tipo_Tran, ENV.Tipo_Transaccion) 
							AND ENV.Cod_Emp = COALESCE(@Cod_Emp, ENV.Cod_Emp)	
							AND ENV.Usuario = COALESCE(@Usuario, ENV.Usuario)	
								ORDER BY	ENV.Nro_Interno DESC
			END			

	IF @@RowCount = 0
		RETURN 

	RETURN 
END

GRANT EXECUTE ON SAV.dbo.SAV_TS_BuscaUltimoVoucher To SavSysUser

IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END

