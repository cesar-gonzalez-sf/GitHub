ALTER PROCEDURE SolicitudSencillo$GrabaEnvioBan_ins
----------------------------------------------------------------------------
-- Procedimiento: SolicitudSencillo$GrabaEnvioBan_ins
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Graba envio de /Solicitud Sencillo/Fondo Vuelto/Retiro/
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Graba envio de Solicitud Sencillo/Fondo Vuelto/Retiro/, basado en el SAV_TS_GrabaEnvioBan 
----------------------------------------------------------------------------

	@Tipo_TRAN		VARCHAR(20),
	@Monto_Efe		NUMERIC(18,0),
	@Monto_Doc		NUMERIC(18,0),
	@Cod_Emp		Char(8),	
	@DetEfectivo	Text,
	@DetDoctos		Text,
	@Sencillo		Text,
	@USUARIO		VARCHAR(40),
	@ESTACION		VARCHAR(50),
	@Cod_UsuRecibe	VARCHAR(40),
	@Cierre			VARCHAR(1),
	@Tipo_Envio		VARCHAR(2)='',
	@Id_BandejaPos	Uniqueidentifier,
	@Error_Message NVARCHAR(4000) OUTPUT


AS
	SET NOCOUNT ON
	SET Xact_Abort On

		--  #RESULTSET	solicitud solicitudes
        --  #COLUMN   Nro_INTerno      	NVARCHAR   
		--  #COLUMN   FechaGrab			NVARCHAR
		-- #ENDRESULTSET

	BEGIN TRY

		BEGIN TRAN
			DECLARE 
				@Nro_INTerno		INT,
				@MensajeError		VARCHAR(150),
				@hdoc				INT,
				@Correlativo		INT,
				@Fecha				VARCHAR(10),
				@FechaGrab			DATETIME, 
				@Saldo				NUMERIC(18,0),
				@Nro_INTernoSal		INT
			
			SET @FechaGrab = GETDATE()

			IF @Tipo_TRAN = 'FVueltoTS'
			BEGIN
				SET @Saldo = 0

				SELECT TOP 1 
					@Saldo = saldo, 
					@Nro_INTernoSal = Nro_INTerno
						FROM SAV_CJ.dbo.SAV_TS_RecepcionFondoVueltoTRANsporte WITH(NoLock)
							WHERE Cod_Emp = @Cod_Emp ORDER BY Nro_INTerno Desc

				SET @Saldo = @Saldo - @Monto_Efe

				IF @Saldo < 0
				BEGIN				
					SET @MensajeError = 'El Monto que se asigna no está disponible'
					RETURN 
				END

				--ACTUALIZA ULTIMO SALDO DE LA TIENDA
				UPDATE SAV_CJ.dbo.SAV_TS_RecepcionFondoVueltoTRANsporte
					SET Saldo = @Saldo
						WHERE Nro_interno = @Nro_INTernoSal

				IF @@Error <> 0
				BEGIN				
					SET @MensajeError = 'Problemas al Grabar Nuevo Saldo'
					RETURN 
				END

			END

	-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			INSERT INTO SAV_CJ.dbo.SAV_TS_Envio
				   (Nro_INTernoPadre,	
					Tipo_TRANsaccion,	
					Usuario,		
					Estacion, 
					Cod_Emp,			
					Fecha,				
					Monto_Efectivo,	
					Monto_Documentos,
					Estado,				
					Cod_UsuRecibe,		
					Cierre,			
					Tipo_Envio,
					Id_BandejaPos)
				SELECT
					0,
					@Tipo_TRAN,			
					@USUARIO,		
					@ESTACION, 
					@Cod_Emp,			
					@FechaGrab,			
					@Monto_Efe,		
					@Monto_Doc,
					'E',				
					@Cod_UsuRecibe,		
					@Cierre,		
					@Tipo_Envio,
					@Id_BandejaPos
					IF @@Error <> 0
					BEGIN					
						SET @MensajeError = 'Problemas al ingresar Envio'
						RETURN 
					END

			SET @Nro_INTerno = @@identity

			--IF @Tipo_TRAN In ('SencilloCJ', 'SencilloTS')
			IF @Monto_Efe > 0
			BEGIN
				EXEC sp_xml_preparedocument @hdoc OUTPUT, @DetEfectivo

				INSERT INTO SAV_CJ.dbo.SAV_TS_Detalle_Efectivo
				   (Nro_INTerno,	
					Tipo_TRANsaccion,	
					Codigo_Den,		
					Cantidad_Den)								
						SELECT  
							@Nro_INTerno,	
							@Tipo_TRAN,			
							Codigo,		
							Cantidad
							FROM OPENXML(@hdoc, '/Datos/Detalle', 2)    
								With
								(Codigo int,
								 Cantidad int)

				IF @@Error <> 0
				BEGIN				
						SET @MensajeError = 'Problemas al ingresar detalle solicitud'
					RETURN 
				END
			END

			IF @Monto_Doc > 0
			BEGIN

				EXEC sp_xml_preparedocument @hdoc OUTPUT, @DetDoctos

				INSERT INTO SAV_CJ.dbo.SAV_TS_Detalle_Documentado
					(Nro_INTerno,	
					Tipo_TRANsaccion,	
					Tipo_Documento,		
					Id_Documento,
					Monto,			
					Fecha,				
					Numero,				
					Cuenta,
					Usuario,			
					Estacion)
					SELECT  
						@Nro_INTerno,	
						@Tipo_TRAN,			
						Tipo,				
						Id_Documento,
						Monto,			
						Getdate(),			
						Numero,				
						Cuenta,
						@USUARIO,			
						@ESTACION
						FROM OPENXML(@hdoc, '/Datos/Detalle', 2)    
							With
							   (Tipo			VARCHAR(4),
								Id_Documento	Uniqueidentifier,
								Monto			Bigint,
								Numero			VARCHAR(20),
								Cuenta			VARCHAR(50)	)

				IF @@Error <> 0
				BEGIN				
						SET @MensajeError = 'Problemas al ingresar detalle documentado'
					RETURN 
				END
			END

			IF @Tipo_TRAN = 'SencilloCJ'
			BEGIN
				-- ++++++++++++
				EXEC sp_xml_preparedocument @hdoc OUTPUT, @Sencillo

				INSERT INTO SAV_CJ.dbo.SAV_TS_Detalle_Efectivo
				   (Nro_INTerno,	
					Tipo_TRANsaccion,	
					Codigo_Den,		
					Cantidad_Den)
					SELECT  
						@Nro_INTerno,	
						'DetSencilloCJ',	
						CodigoSol,		
						CantidadSol		
						FROM OPENXML(@hdoc, '/Datos/Detalle', 2)    
							With
							   (CodigoSol int,
								CantidadSol int)

				IF @@Error <> 0
				BEGIN				
					SET @MensajeError = 'Problemas al ingresar sencillo solicitud CJ'
					RETURN 
				END
			END
			ELSE IF @Tipo_TRAN = 'SencilloTS' 
			BEGIN
				-- ++++++++++++
				EXEC sp_xml_preparedocument @hdoc OUTPUT, @Sencillo

				INSERT INTO SAV_CJ.dbo.SAV_TS_Detalle_Efectivo
					(Nro_INTerno,	
					Tipo_TRANsaccion,	
					Codigo_Den,		
					Cantidad_Den)
					SELECT  
						@Nro_INTerno,	
						'DetSencilloTS',	
						CodigoSol,	
						CantidadSol
						FROM OPENXML(@hdoc, '/Datos/Detalle', 2)    
							With
								(CodigoSol int,
								 CantidadSol int)

				IF @@Error <> 0
				BEGIN				
						SET @MensajeError = 'Problemas al ingresar sencillo solicitud TS'
					RETURN 
				END
			END

			IF @Tipo_TRAN = 'FVueltoTS'
			BEGIN
				UPDATE SAV_CJ.dbo.SAV_TS_BandejaPos 
					SET Estado = 'I'
						WHERE Id_BandejaPos = @Id_BandejaPos
				IF @@Error <> 0
				BEGIN				
					SET @MensajeError = 'Problemas al Actualizar Bandeja'
					RETURN 
				END
			END

			IF @Tipo_TRAN = 'RetiroCJ' And @Cierre = 'S'
			BEGIN
				UPDATE SAV_CJ.dbo.SAV_TS_BandejaPos 
					SET Estado = 'C'
						WHERE Id_BandejaPos = @Id_BandejaPos
				IF @@Error <> 0
				BEGIN				
					SET @MensajeError = 'Problemas al Actualizar Bandeja'
					RETURN 
				END 
			END

			SELECT
				CAST(Ltrim(Rtrim(@Nro_INTerno))	AS NVARCHAR) AS  Nro_INTerno,
				CAST(Ltrim(Rtrim(@FechaGrab))	AS NVARCHAR) AS  FechaGrab	
			
			IF @@Error <> 0
			BEGIN
				SELECT
				@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
				RETURN
			END

	END TRY
BEGIN CATCH

		IF @@Error <> 0
		BEGIN
			SELECT
			@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
			RETURN
		END 

END CATCH









