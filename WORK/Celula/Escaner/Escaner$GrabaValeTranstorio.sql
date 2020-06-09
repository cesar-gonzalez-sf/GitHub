ALTER PROCEDURE Escaner$GrabaValeTranstorio
----------------------------------------------------------------------------
-- Procedimiento: Escaner$GrabaValeTranstorio
-- Autor: Nicolas Uribe 
-- Fecha de Creacion: 29/12/2019 
-- Objetivo: Genera vale transitorio respecto a los productos ingresados 
-- Empresa: SF Ingenieria. 
----------------------------------------------------------------------------
 
	@vXmlProductos	AS VARCHAR(MAX),
	@vCod_Emp		AS VARCHAR(20),
	@vUsuario		AS VARCHAR(50),
	@vTipoDoc		AS VARCHAR(3), 
	@vCod_Entidad	AS VARCHAR(40),
	@vCod_Sucursal	AS VARCHAR(3),
	@vCod_Lista		AS VARCHAR(3),
	@vEstacion		AS VARCHAR(30),
    @Nro_Interno	AS INTEGER		OUTPUT, 
	@Error_Message  AS VARCHAR(400) OUTPUT

AS 
	BEGIN
		SET NOCOUNT ON
		SET Xact_Abort ON
	DECLARE @Hdoc		INT    
	DECLARE @Sucursal	CHAR(8)    
    
	EXEC SP_XML_PREPAREDOCUMENT @Hdoc OUTPUT, @vXmlProductos    
	IF @@ERROR <> 0    
	BEGIN
		RETURN  0    
	END    

	DECLARE	@Cod_Emp			CHAR(8),    
			@Cod_Tienda			CHAR(8), 
			@Cod_RegionVenta	VARCHAR(3),    
			@Fecha_Emision		DATETIME,    
			@Tipo_Documento		VARCHAR(3),    
			--@Nro_Interno		INT,    
			@Cod_Entidad		VARCHAR(13),    
			@Cod_Sucursal		VARCHAR(3),    
			@Total				INT,
			@Descuento          INT,    
			@FormaPago			INT,
            @VentaCalzada       CHAR(1),
			@Dimensionado       CHAR(1),
            @Nro_InternoP       INT,
            @Cod_Responsable    VARCHAR(40),
			@AreaTelefono       CHAR(2),
			@Telefono           CHAR(10), 
			@Celular            CHAR(10),
			@Mail               VARCHAR(50),
			@Estacion			VARCHAR(100),
			@Vendedor			VARCHAR(100),
			@ListaPrecio		VARCHAR(100)

	DECLARE @TotalCab     INT
	DECLARE @NetoCab      INT
	DECLARE @DescuentoCab INT
	DECLARE @Impuesto_IVA FLOAT
	DECLARE @IVACab       INT 

	--Busca IVA para calcular documento
    SELECT TOP 1 @Impuesto_IVA = ISNULL(IMPUESTO,19) FROM SAV.dbo.PAR_IMPUESTO (NOLOCK)
    
	SELECT	@Nro_Interno        = ISNULL(Nro_interno,0),
	        @Cod_Emp			= ISNULL(Cod_Emp,''),    
			@Cod_Tienda			= ISNULL(Cod_Tienda,''),    
			@Fecha_Emision		= ISNULL(Fecha_Emision,'19000101'),    
			@Tipo_Documento		= Tipo_Documento,    
			@Cod_Entidad		= ISNULL(Cod_Entidad,''),    
			@Cod_Sucursal		= ISNULL(Cod_Sucursal,''),    
			@Total				= Total, 
			@Descuento          = Descuento,   
			@FormaPago			= Cod_FormaPago,    
            @Cod_Responsable	= ISNULL(Cod_Responsable,''),
			@AreaTelefono       = ISNULL(AreaTelefono,'NULL'),
			@Telefono           = ISNULL(Telefono,'NULL'),
			@Celular            = ISNULL(Celular,'NULL'),
			@Mail               = ISNULL(Mail,'NULL'),
			@Estacion			= ISNULL(Estacion,'NULL'),			
			@ListaPrecio		= ISNULL(Cod_ListaPrecio,'NULL')
	FROM OPENXML (@hdoc, '/ValeTransitorio/Cabecera', 2)    
	WITH (	Nro_Interno     INT,
	        Cod_Emp			CHAR(8),    
			Cod_Tienda		CHAR(8),    
			Fecha_Emision	DATETIME,
            Cod_Responsable VARCHAR(40),     
			Tipo_Documento  VARCHAR(3),    
			Cod_Entidad		VARCHAR(13),    
			Cod_Sucursal	VARCHAR(3),    
			Total			INT,
			Descuento		INT,    
			Cod_FormaPago	INT,
			AreaTelefono    CHAR(2),
			Telefono        CHAR(10), 
			Celular         CHAR(10),
			Mail            VARCHAR(50),
			Estacion		VARCHAR(100),
			Cod_ListaPrecio VARCHAR(100)
		)
		

		--Busca Vendedor segun estacion y tienda
		SET @vendedor	= ISNULL((SELECT COD_VENDEDOR_AUTOSERVICIO FROM SAV_CJ.dbo.SAV_CJ_ESTACIONES WITH(NOLOCK) WHERE Estacion = @Estacion AND Cod_Emp =@Cod_Emp),'SAV')


		--Se actualiza plazo de venta si es credito 
		Declare @PlazoVtaCredito As Int
		
		
		Select Top 1 @PlazoVtaCredito = Pla.COD_PLAZOPAGO
		From SAV.dbo.CLI_CREDITO Cre With(NoLock) 
		Inner Join SAV.dbo.PAR_PLAZOPAGO Pla With(NoLock) 
		On Cre.PLAZO_PAGO = Pla.DIAS
		Where Cre.COD_ENTIDAD = @Cod_Entidad
		And Cre.COD_SUCURSAL =  @Cod_Sucursal


		Set @PlazoVtaCredito = IsNull(@PlazoVtaCredito, 0) 

	IF @@ERROR <> 0 
	BEGIN
		RETURN  0    
	END    
    
	IF @Cod_Emp = ''    
	BEGIN    
		RETURN  0    
	END    
    
	SET @Sucursal = dbo.zSav_Lib_SucursalParaConsultas(@Cod_Emp,GETDATE())    

	SELECT	@Cod_RegionVenta = Cod_RegionVenta    
	FROM	Sav_Tiendas WITH (NOLOCK)    
	WHERE	Cod_Tienda  = @Cod_Emp    

	DECLARE	@Visado_Nivel		INT,    
			@Visado_Estado		CHAR(1),    
			@Visado_Usuario		VARCHAR(20),    
			@Visado_Fecha		DATETIME    

	SET @Visado_Nivel   = 0    
	SET @Visado_Estado  = 'N'    
	SET @Visado_Usuario = ''    
	SET @Visado_Fecha   = ''   

	IF @Visado_Estado  = 'S'    
	BEGIN    
		SET @Visado_Fecha   = GETDATE()    
		SET @Visado_Usuario = 'SYSTEM'    
	END   
		
    --Verifica si es una venta con Dimensionado
	   SET @Dimensionado = 'N'

	   IF NOT EXISTS(SELECT 1 FROM SAV_VT.dbo.Sav_Vt_TraCab WITH(NOLOCK) WHERE Cod_Emp			= @Cod_Emp  
																		AND	  Nro_Interno		= @Nro_Interno  
																		AND	  Tipo_Documento	= @Tipo_Documento  )
		BEGIN 
				INSERT INTO SAV_VT.dbo.Sav_Vt_TraCab (    
						Cod_Emp,			Cod_Tienda,			Tipo_Documento,		Cod_Entidad,
						Cod_Sucursal,		Seq_Direccion,		Seq_Despacho,		Fecha_Emision,
						Fecha_Vencimiento,	Cod_Responsable,	Cod_Vendedor,		Cod_ListaPrecio,
						Neto,				Iva,				Total,				Descuento,
						Cod_Retirador,		Fecha_Despacho,		Orden_Compra,		Cod_FormaPago,
						Cod_PlazoPago,
						Cod_Recargo,
						Observaciones,		Presente,			Directo,			Flete,
						Estado,				Retroactivo,		Nro_Impreso,		Gen_Credito,
						FechaCreacion,		PedidoPalm,			DirDesFecDesHorDes,	Estado_Visado,		
						Fecha_Visado,		Usuario_Visado,		Nivel_Visado,		RC,					
						Cod_RegionVenta,	Tipo_Emision,       Mecanizado,			Venta_Calzada,      
						Devolucion,         Sucursal,           Promocion,          Dimensionado,
						EsVtaPersonal,      CorteExpress,       Nro_InternoP,      Tipo_DocumentoP
				)
				SELECT	Cod_Emp,			Cod_Tienda,			Tipo_Documento,		Cod_Entidad,
						Cod_Sucursal,		Seq_Direccion,		Seq_Despacho,		Fecha_Emision,
						Fecha_Vencimiento,  Cod_Responsable,	@vendedor,		Cod_ListaPrecio,
						Neto,				Iva,				Total,				Descuento,
						Cod_Retirador,		Fecha_Despacho,		Orden_Compra,		Cod_FormaPago,
						Case When @PlazoVtaCredito = 0 Then Cod_PlazoPago Else @PlazoVtaCredito End,
						CASE Cod_Recargo
							WHEN 0 THEN 1
							ELSE Cod_Recargo
						END,
						Observaciones,		Presente,	       Directo,			    Flete,
						Estado,				Retroactivo,	   '',				    'N',
						GETDATE(),			'ESPECIAL',	       ISNULL(DirDesFecDesHorDes,' '), @Visado_Estado,
						@Visado_Fecha,		@Visado_Usuario,   @Visado_Nivel,                  0,
						@Cod_RegionVenta,   Tipo_Emision,      Mecanizado,                     VentaCalzada,
						Devolucion,         ISNULL(Sucursal,@Sucursal),                        Promocion
					   ,@Dimensionado,     ISNULL(EsVtaPersonal,0),                            ISNULL(CorteExpress,'N'),
					    Nro_InternoP,      Tipo_DocumentoP
				FROM OPENXML (@hdoc, '/ValeTransitorio/Cabecera', 2)
						WITH (	Cod_Emp			CHAR(8),
							Cod_Tienda			CHAR(8),
							Tipo_Documento		CHAR(3),
							Cod_Entidad			VARCHAR(13),
							Cod_Sucursal		CHAR(3),
							Seq_Direccion		INT,
							Seq_Despacho		INT,
							Fecha_Emision		DATETIME,
							Fecha_Vencimiento	DATETIME,
							Cod_Responsable		CHAR(20),							
							Cod_ListaPrecio		CHAR(3),
							Neto				INT,
							Iva					INT,
							Total				INT,
							Descuento			INT,
							Cod_Retirador		INT,
							Fecha_Despacho		DATETIME,
							Orden_Compra		CHAR(150),
							Cod_FormaPago		INT,
							Cod_PlazoPago		INT,
							Cod_Recargo			INT,
							Observaciones		TEXT,
							Presente			CHAR(1),
							Directo				CHAR(1),
							Flete				CHAR(1),
							Estado				CHAR(1),
							Retroactivo			CHAR(1),
							DirDesFecDesHorDes	VARCHAR(250),
							Cod_RegionVenta		VARCHAR(3),
							Tipo_Emision		CHAR(10),
							Mecanizado          INT,
							VentaCalzada        CHAR(1),
							Devolucion          BIT,
							Sucursal			CHAR(8),
							Promocion           CHAR(1),
							EsVtaPersonal       BIT,
							CorteExpress        VARCHAR(3),
							Nro_InternoP        INT,
							Tipo_DocumentoP     CHAR(3)
							)    

					IF @@ERROR <> 0    
					BEGIN    
						ROLLBACK TRANSACTION    
						RETURN  0    
					END    

				 SET @Nro_Interno = @@Identity    
		END ELSE BEGIN

		
		    UPDATE SAV_VT.dbo.Sav_Vt_TraCab SET TOTAL = @Total, Descuento = @Descuento, Neto = (@Total / (1 + (@Impuesto_IVA / 100))), IVA = @Total - (@Total / (1 + (@Impuesto_IVA / 100)))
			WHERE Cod_Emp			= @Cod_Emp  
			AND	  Nro_Interno		= @Nro_Interno  
			AND	  Tipo_Documento	= @Tipo_Documento

		END

		
		DELETE FROM SAV_VT.dbo.Sav_Vt_TraDet WHERE Cod_Emp			= @Cod_Emp  
											AND	   Nro_Interno		= @Nro_Interno  
											AND	   Tipo_Documento	= @Tipo_Documento
        
		INSERT INTO SAV_VT.dbo.Sav_Vt_TraDet (
				Cod_Emp,			Cod_Tienda,			Nro_Interno,	      Tipo_Documento,
				Nro_Linea,			Cod_Bodega,			Cod_Producto,	    Cod_Rapido,
				Descripcion,		Observacion,	    Cod_Unimed,		          Seq_Unimed,
				Cantidad,			Precio_Costo,	    Precio_Lista,	          Precio_Unitario,
				SubTotal,			PorcentajeCv,	    MontoCv,		          PorcentajeDv,
				MontoDv,			Cod_Autorizador,    PorcentajeDg,	          MontoDg,
				Total,				PorcentajeDo,	    MontoDo,		          Cod_ListaPrecio,
				FechaLinea,			Presente,			Directo,		          Mecanizado,
				Tipo_Mecanizado,	Flete,				FechaDespacho,	          EstadoLinea,
				Tipo_DocumentoP,	Nro_InternoP,	    Nro_LineaP,		          Id_Linea,
				PesoProducto,		Dibujo,				CEIdentificador,          CETipoCond,
				CECosto,			CEDesc1,			CECod_Proveedor,          CECod_Sucursal,
				CEPlazo,			CEAcordadoCon,	    Danado,				      Sucursal,
				Tipo_Flete,			Cod_Cotizacion,     Venta_Calzada,            DiferenciaVC,
                ID_Pkg,             RolProducto,        PorcentajeDP,  			  MontoDP,
				PorcentajeDescEmb,  MontoDescEmb,       Precio_Real,              COD_ORI_VTA
		)

		SELECT	Cod_Emp,			Cod_Tienda,			@Nro_Interno,		 Tipo_Documento,
				Nro_Linea,			Cod_Bodega,			Cod_Producto         ,Cod_Rapido,
				Descripcion,		Observacion,		  Cod_Unimed,			  Seq_Unimed,
				Cantidad,			Precio_Costo,	    Precio_Lista,		  Precio_Unitario,
				SubTotal,			PorcentajeCv,	    MontoCv,			  POrcentajeDv,
				MontoDv,			Cod_Autorizador,    PorcentajeDg,		  MontoDg,
				Total,				PorcentajeDo,	    MontoDo,			  Cod_ListaPrecio,
				@Fecha_Emision,		Presente,			Directo,			  Mecanizado,
				Tipo_Mecanizado,	Flete,				Fecha_Despacho,		  'I',
				Tipo_DocumentoP,	Nro_InternoP,	    Nro_LineaP,			  NEWID(),
				Peso,				Dibujo,				Identificador,		  TipoCond,
				Costo,				Desc1,				Cod_Proveedor,		  Cod_Sucursal,
				Plazo,				Acordado_Con,	    Danado,				  ISNULL(Sucursal,@Sucursal),
				Tipo_Flete,			Cod_Cotizacion,     VentaCalzada,         REPLACE(DiferenciaVC,'',0),
                ID_Pkg,             RolProducto,        PorcentajeDP,  		  MontoDP, 
				PorcentajeDescEmb,  MontoDescEmb,       ISNULL(Precio_Real,Precio_Unitario),          ISNULL(COD_ORI_VTA,'')
		FROM OPENXML (@hdoc, '/ValeTransitorio/Detalle', 2)
		WITH (	Cod_Emp				CHAR(8),
				Cod_Tienda			CHAR(8),
				Tipo_Documento		CHAR(3),
				Nro_Linea			INT,
				Cod_Bodega			CHAR(3),
				Cod_Producto		VARCHAR(13),
				Cod_Rapido			INT,
				Descripcion			VARCHAR(150),
				Observacion			TEXT,
				Cod_Unimed			CHAR(10),
				Seq_Unimed			INT,
				Cantidad			DECIMAL(18,4),
				Precio_Costo		INT,
				Precio_Lista		INT,
				Precio_Unitario		INT,
				SubTotal			INT,
				PorcentajeCv		DECIMAL(18,4),
				MontoCv				INT,
				PorcentajeDv		DECIMAL(18,4),
				MontoDv				INT,
				Cod_Autorizador		CHAR(20),
				PorcentajeDg		DECIMAL(18,4),
				MontoDg				INT,
				Total				INT,
				PorcentajeDo		DECIMAL(18,4),
				MontoDo				INT,
				Cod_ListaPrecio		CHAR(3),
				Presente			CHAR(1),
				Directo				CHAR(1),
				Mecanizado			CHAR(1),
				Tipo_Mecanizado		CHAR(1),
				Flete				CHAR(1),
				Fecha_Despacho		DATETIME,
				Tipo_DocumentoP		CHAR(3),
				Nro_InternoP		INT,
				Nro_LineaP			INT,
				Peso				DECIMAL(18,4),
				Dibujo				CHAR(1),
				Identificador		INT,
				TipoCond			CHAR(1),
				Costo				INT,
				Desc1				DECIMAL(18,4),
				Cod_Proveedor		VARCHAR(13),
				Cod_Sucursal		VARCHAR(3),
				Plazo				INT,
				Acordado_Con		VARCHAR(50),
				Danado				CHAR(1),
				Sucursal			CHAR(8),
				Tipo_Flete			CHAR(1),
				Cod_Cotizacion		INT,
                VentaCalzada		VARCHAR(2),
				DiferenciaVC		DECIMAL(18,4),
                ID_Pkg				INT,  
				RolProducto			CHAR(2),
				PorcentajeDP		DECIMAL(18,4),
				MontoDP				INT ,
				PorcentajeDescEmb   DECIMAL(18,4),
				MontoDescEmb        INT,
				Precio_Real         INT,              
				COD_ORI_VTA         VARCHAR(3)
			)

		IF @@ERROR <> 0
		BEGIN
			RETURN  0    
		END    

		/***************************Graba Log***********************/
		
		
		 IF EXISTS(SELECT top 1 1
		 FROM OPENXML (@hdoc, '/ValeTransitorio/Log_CambioPrecio', 2)
		   WITH (
					 Estacion			varchar(40)
				   , Usuario			varchar(40)
				   , Autorizador		varchar(40)
				   , Observacion		varchar(100)
				   , Cod_Rapido			int
				   , Cod_Producto		varchar(13)
				   , Nuevo_Precio		int
				   , Precio_Lista		int
			   ))
		BEGIN


				INSERT INTO SAV_LOG.dbo.SAV_VT_LogCambioPrecio_ScanMulticaja
				   (Cod_Emp
				   ,Nro_Interno
				   ,Estacion
				   ,Usuario
				   ,Autorizador
				   ,Observacion
				   ,Cod_Rapido
				   ,Cod_Producto
				   ,Nuevo_Precio
				   ,FechaHora_Registro
				   ,Precio_Lista
				   )
   
				  SELECT 
					@Cod_Emp
				   ,@Nro_Interno
				   ,@estacion
				   ,Usuario
				   ,Autorizador
				   ,Observacion
				   ,Cod_Rapido 
				   ,Cod_Producto
				   ,Nuevo_Precio
				   ,GETDATE()
				   ,Precio_Lista

				  FROM OPENXML (@hdoc, '/ValeTransitorio/Log_CambioPrecio', 2)
				   WITH (
					 Estacion			varchar(40)
				   , Usuario			varchar(40)
				   , Autorizador		varchar(40)
				   , Observacion		varchar(100)
				   , Cod_Rapido			int
				   , Cod_Producto		varchar(13)
				   , Nuevo_Precio		int
				   , Precio_Lista		int
				   )
				   




		--SI ES BLV CON VENTA PERSONAL ACTUALIZA LOS VALORES Y ASIGNA DESCUENTOS
		IF EXISTS(SELECT 1 FROM SAV_VT.dbo.Sav_Vt_TraCab WITH(NOLOCK) WHERE Nro_Interno = @Nro_Interno AND Tipo_Documento = 'BLV' AND EsVtaPersonal = 1) 
		BEGIN

		            UPDATE SAV_VT.dbo.SAV_VT_TRADET  SET 
					 MontoDv      =  SubTotal - (cantidad * Precio_Real),
					 PorcentajeDv = ROUND((ROUND((SubTotal - (cantidad * Precio_Real)),0) / SubTotal),4),
					 Total        = (cantidad * Precio_Real),
					 MontoCv      =  0,
					 PorcentajeCv =  0,					 
					 MontoDg      =  0,
					 PorcentajeDg =  0, 
					 MontoDP      =  0,
					 PorcentajeDP =  0					
					WHERE Nro_Interno = @Nro_Interno  AND Precio_Real > 0  
				
						
					SELECT @TotalCab     = ISNULL(SUM(Total),0),
					       @DescuentoCab = ISNULL(SUM(MontoDv),0)					 
					FROM SAV_VT.dbo.SAV_VT_TRADET   (NOLOCK)
					WHERE Nro_Interno	 = @Nro_Interno
		            
					SET @NetoCab = (@TotalCab / (1 + (@Impuesto_IVA / 100)))
					SET @IVACab  =  @TotalCab - @NetoCab

					 UPDATE SAV_VT.dbo.SAV_VT_TRACAB 
					 SET Neto		   = @NetoCab 
						,Iva		   = @IVACab 
						,Total		   = @TotalCab  
						,Descuento     = @DescuentoCab
					 WHERE Nro_Interno = @Nro_Interno
	
		END

      
		UPDATE	SAV_VT.dbo.Sav_Vt_TraDet    
		SET	 Cod_Producto	= Prd.Cod_Producto
		FROM SAV_VT.dbo.Sav_Vt_TraDet	Det WITH(NOLOCK)    
		INNER JOIN Prd_DatosBasicos		Prd WITH(NOLOCK)
		ON		Det.Cod_Rapido	= Prd.Cod_Rapido
		WHERE	Nro_Interno		= @Nro_Interno

				   
		/***************************Envia Correo***********************/				   
		
		DECLARE @EMAIL						VARCHAR(500),            
				@EMensaje					VARCHAR (8000),                 
				@EStatus					INT,            
				@EArea						VARCHAR(100),	--- Identificará el área que está enviando el correo.            
				@EAttachments				VARCHAR(max),	--- archivos adjuntos            
				@ETipoMensaje				VARCHAR(20),	--- formato (TEXT, HTML)            
				@ECC_Oculto					VARCHAR(max),	--- copia oculta            
				@EReply_To					VARCHAR(max),	--- a quien se responde correo            
				@Eimportance				VARCHAR(6),		--- importancia del correo (LOW, NORMAL, HIGH)            
				@ESubject					VARCHAR (255),            
				@ECC						VARCHAR(80),         
				@EFecha						VARCHAR(8),
				
				--Datos del precio modificado
				@EUsuarioAutorizador		VARCHAR(100),
				@EsuarioVendedor			VARCHAR(100),
				@EPrecio_Lista				INT,
				@EPrecio_Nuevo				INT,
				@ECod_Rapido				VARCHAR(30),
				@ECod_Producto				VARCHAR(30),
				@EDescripcion				VARCHAR(200),
				@ENombre_Jefatura			VARCHAR(100)
		
		
		/**********SETEAMOS DATOS DEL CORREO************************/
		
	 	SELECT		@EUsuarioAutorizador = Autorizador,
					@EPrecio_Lista = Precio_Lista,
					@EPrecio_Nuevo = Nuevo_Precio,
					@ECod_Rapido = Cod_Rapido,
					@ECod_Producto = Cod_Producto
					
		FROM OPENXML (@hdoc, '/ValeTransitorio/Log_CambioPrecio', 2)
			WITH (	 Autorizador		VARCHAR(100)
				   , Precio_Lista		INT
				   , Nuevo_Precio		INT
				   , Cod_Rapido			INT
				   , Cod_Producto		VARCHAR(30)
				   )		
		
		SELECT @EDescripcion = DESC_LARGA FROM PRD_DATOSBASICOS WITH(NOLOCK) WHERE cod_rapido = @ECod_Rapido AND cod_Producto = @ECod_Producto		
		SELECT @EUsuarioAutorizador =RTRIM(LTRIM(APELLIDO_PAT))  + ' ' + RTRIM(LTRIM(APELLIDO_MAT)) + ' ' + RTRIM(LTRIM(NOMBRES)) FROM ecubas.dbo.EcuACCUSU WITH(NOLOCK)  WHERE USU_CODIGO =  @EUsuarioAutorizador
		SELECT @EsuarioVendedor = RTRIM(LTRIM(APELLIDO_PAT)) + ' ' + RTRIM(LTRIM(APELLIDO_MAT)) + ' ' + RTRIM(LTRIM(NOMBRES)) FROM ecubas.dbo.EcuACCUSU  WITH(NOLOCK) WHERE USU_CODIGO =  @vendedor

		SET @EMAIL  = 'ex.gsaez@imperial.cl'	
		SET @ECC	 = 'ex.gsaez@imperial.cl'
		SET @ESubject = 'Modificación entre Precio Caja y Precio Fleje'
		  
		SET @EMensaje = '  
		 
Sr(a):        
	Informamos a usted, se realizó una modificación de precio en  la caja ' + @Estacion + ' realizado por ' + ISNULL(@EsuarioVendedor,'SAV') + '. 
	El cual fue autorizado por ' +@EUsuarioAutorizador + ' , a continuación se detalla la información:

	Codigo del Producto(SKU) : ' + @ECod_Rapido + '
	Descripción del Producto : ' + @EDescripcion + '
	Lista de Precio : ' + @ListaPrecio + '
	Precio Lista : ' + CONVERT(varchar(100),@EPrecio_Lista) + '
	Nuevo Precio Asignado: ' + CONVERT(varchar(100),@EPrecio_Nuevo) + '

	Atentamente, 
	       
	Tesorería Central        
	Imperial   
								
	Correo Automático, no responder' 		
	
	
	/*SELECT @EMensaje ,	
			@EUsuarioAutorizador as 'usuAutoriza',
			@EPrecio_Lista as 'Precio lista',
			@EPrecio_Nuevo as 'Precio Nuevo' ,
			@ECod_Rapido as 'cod rapido',
			@ECod_Producto as 'cod_producto'	*/
							   
		  EXEC @EStatus = zSAV_LIB_EnviaMailEx1          
			   @Area = 'TESORERIA'           
			 , @From  = 'System@Imperial.cl'                
			 , @To  = @EMAIL          
			 , @CC  = @ECC          
			 , @Subject  =   @ESubject             
			 , @Mensaje  = @EMensaje          
			 , @TipoMensaje  = 'TEXT'  		
				  		  
		END
		IF @@ERROR <> 0
		BEGIN
			RETURN  0
		END
		   
	--SELECT @nro_Interno AS Nro_Interno    

IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END
END
