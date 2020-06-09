ALTER PROCEDURE [dbo].[SAV_VT_CreaValeVtaPOR] 
--------------------------------------------------------------------------------
-- Retorna  la  lista  de los productos marcados con el SKU especificado, o cuya
-- descripcion larga contiene las palabras suministradas en DESCRIPCION_PROD.
--------------------------------------------------------------------------------
-- =============================================
-- Author:			<Cesar Gonzalez SF>
-- Modified Date:	<15/05/2020>
-- Description:		<Se crea vale de pago POR>
-- =============================================

    @TIENDA				AS NVARCHAR(50),
    @CLIENTE			AS NVARCHAR(50),
    @SKUS				AS NVARCHAR(250),
	@CONTRATO			AS NVARCHAR(100),
	@NRO_INTERNO		AS INTEGER OUTPUT
AS
BEGIN
   SET NOCOUNT, XACT_ABORT ON;

   DECLARE	
		@Cod_Emp			CHAR(8),
		@Cod_Entidad		VARCHAR(13),
		@Cod_Sucursal		VARCHAR(3),
		@Impuesto_IVA		FLOAT,
		@Cod_Bodega			VARCHAR(5),
		@Count				INT,
		@PrecioLista_Paso	INT,
		@SubTotal_Paso		INT

	-- DECLARACIÓN DE VARIABLES
	DECLARE
		@Cod_Tienda			CHAR(8),
		@Tipo_Documento		VARCHAR(3),	
		@Seq_Direccion		INT,
		@Seq_Despacho		INT,
		@Fecha_Emision		DATETIME,
		@Fecha_Vencimiento	DATETIME,
		@Cod_Responsable  	VARCHAR(40),
		@Cod_Vendedor   	VARCHAR(40),
		@Cod_ListaPrecio	Nvarchar(100),
		@Neto				INT,
		@Iva				INT,
		@Total				INT,
		@Descuento			INT,
		@Cod_Retirador		VARCHAR(100),
		@Fecha_Despacho		DATETIME,
		@Orden_Compra		VARCHAR(20),
		@Cod_FormaPago		INT,
		@Cod_PlazoPago		INT,
		@Cod_Recargo		INT,
		@Observaciones		VARCHAR(3000),
		@Presente			CHAR(1),
		@Directo			CHAR(1),
		@Flete				CHAR(1),
		@Estado				CHAR(1),
		@Retroactivo		CHAR(1),
		@Nro_Impreso		VARCHAR(10),
		@Gen_Credito		CHAR(1),
		@FechaCreacion		DATETIME,
		@PedidoPalm			VARCHAR(10),
		@DirDesFecDesHorDes	VARCHAR(250),
		@Visado_Estado		CHAR(1),
		@Visado_Fecha		DATETIME,
		@Visado_Usuario		VARCHAR(20),
		@Visado_Nivel		INT,
		@RC					BIT,
		@Cod_RegionVenta	VARCHAR(3), 	
		@Tipo_Emision		CHAR(10),
		@Mecanizado			INT,
		@Venta_Calzada		CHAR(1),
		@Devolucion			BIT,
		@Sucursal			VARCHAR(20),
		@Promocion			CHAR(1),
		@Dimensionado		CHAR(1),
		@EsVtaPersonal		BIT,
		@CorteExpress		VARCHAR(3),
		@Origen_TiendaWeb	VARCHAR(10)


	--INSERT DE ERRORES
	INSERT INTO SAV_LOG.DBO.SAV_LOG_ERRORES (OBJETO,ERROR,DESCRIPCION,LINEA) 
	VALUES ('PRUEBA POR',-100, 'SKU: ' + ISNULL(@SKUS, 'NULO') ,1) 
	INSERT INTO SAV_LOG.DBO.SAV_LOG_ERRORES (OBJETO,ERROR,DESCRIPCION,LINEA) 
	VALUES ('PRUEBA POR',-100, 'TIENDA: ' + ISNULL(@TIENDA, 'NULO') ,1) 
	INSERT INTO SAV_LOG.DBO.SAV_LOG_ERRORES (OBJETO,ERROR,DESCRIPCION,LINEA) 
	VALUES ('PRUEBA POR',-100, 'CLIENTE: ' + ISNULL(@CLIENTE, 'NULO') ,1) 
	INSERT INTO SAV_LOG.DBO.SAV_LOG_ERRORES (OBJETO,ERROR,DESCRIPCION,LINEA) 
	VALUES ('PRUEBA POR',-100, 'CONTRATO: ' + ISNULL(@CONTRATO, 'NULO') ,1) 

	--DECLARAMOS VARIABLES 
	DECLARE @MontoTotal AS INTEGER
	DECLARE @ItemsDet NVARCHAR(100) = ''

	--CREAMOS TABLA TEMPORAL DETALLE DE ITEMS
	CREATE TABLE #ItemsDetalle (cod_rapido INT, monto BIGINT, cantidad DECIMAL)

	--CREAMOS TABLA TEMPORAL DE ITEMS
	CREATE TABLE #Items (Item VARCHAR(100))

	--INSERT A TABLA TEMPORAL DE ITEMS 
	INSERT INTO #Items(Item)
	SELECT items FROM  DBO.Split(@SKUS,';')	

	--SE INICIALIZA CURSOR PARA OPTENER ITEMS SEPARADOS  
	DECLARE Items_Cursor CURSOR FOR 
	SELECT Item 
	FROM #Items
	OPEN Items_Cursor
	FETCH NEXT FROM Items_Cursor
	INTO @ItemsDet
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--INSERT A TABLA TEMPORAL PARA PODER TENER MONTO DE SKU
		INSERT INTO #ItemsDetalle (cod_rapido, monto, cantidad)
		SELECT 
			REPLACE(@ItemsDet, SUBSTRING(@ItemsDet, CHARINDEX(',', @ItemsDet), LEN(@ItemsDet)), ''),
			substring(@ItemsDet,  PATINDEX('%,%',@ItemsDet)+1,  PATINDEX('%,%',@ItemsDet)+30),
			1

		FETCH NEXT FROM Items_Cursor 
		INTO @ItemsDet
	END
	CLOSE Items_Cursor
	DEALLOCATE Items_Cursor

	SET @MontoTotal = (SELECT SUM(monto) FROM #ItemsDetalle)

	--BUSCA DATOS
	SELECT @Cod_Emp = COD_EMP FROM sav_empresas WITH (NOLOCK) WHERE POR_CODEMP_COD = @TIENDA
	
	SELECT	@Cod_Entidad = ISNULL(COD_ENTIDAD, ''), 
			@Cod_Sucursal = ISNULL(COD_SUCURSAL, '') 
	FROM sav.dbo.cli_maestro WITH (NOLOCK) 
	WHERE rut_cliente = LEFT(@CLIENTE, LEN(@CLIENTE) - 1) --@CLIENTE
	
	SELECT @Cod_Tienda = Descripcion FROM SAV_Tiendas WHERE Cod_Tienda = @Cod_Emp 

	--BUSCA VALOR DE IVA PARA CALCUALAR IMPUESTO          
    SELECT @Impuesto_IVA = ISNULL(IMPUESTO,19)           
		FROM SAV.dbo.PAR_IMPUESTO (NOLOCK)

	--ASIGNACION DE VALORES INICIALES A VARIABLES           
		SET @Cod_Emp = @Cod_Emp
		SET @Tipo_Documento   ='BLV'
		SET @Seq_Direccion   = 1
		SET @Seq_Despacho   = 1
		SET @Fecha_Emision   = GETDATE()
		SET @Fecha_Vencimiento  = DATEADD(DAY,2,@Fecha_Emision)
		SET @Cod_Responsable = 'VENDEDORPOR'
		SET @Cod_Vendedor = 'VENDEDORPOR'
		SET @Cod_ListaPrecio  = '01P'
		SET @Neto     = ROUND(@MontoTotal / (1+(@Impuesto_IVA/100)) ,0)
		SET @IVA     = @MontoTotal - @Neto
		SET @Total = @MontoTotal
		SET @Descuento    = 0
		SET @Cod_Retirador   = '0'
		SET @Fecha_Despacho   = GETDATE()
		SET @Orden_Compra   = ''
		SET @Cod_FormaPago   = 1
		SET @Cod_PlazoPago   = 1
		SET @Cod_Recargo   = 1
		SET @Observaciones   = 'Contrato Nº' + ISNULL(@CONTRATO,'0') 
		SET @Presente    = 'S'
		SET @Directo    = 'N'
		SET @Flete     = 'N'
		SET @Estado     = 'C'
		SET @Retroactivo   = 'N'
		SET @Nro_Impreso   = ''
		SET @Gen_Credito   = 'N'
		SET @FechaCreacion   = GETDATE()
		SET @PedidoPalm    = ''
		SET @DirDesFecDesHorDes  = ''
		SET @Visado_Estado   = 'S'
		SET @Visado_Fecha   = GETDATE()
		SET @Visado_Usuario   = 'SYSTEM'
		SET @Visado_Nivel   = 0
		SET @RC      = 0
		SET @Cod_RegionVenta = ( SELECT Cod_RegionVenta FROM SAV.dbo.Sav_Tiendas WITH (NOLOCK) WHERE Cod_Tienda  = @Cod_Emp)
		SET @Tipo_Emision   = 'Retail'
		SET @Mecanizado    = 0
		SET @Venta_Calzada   = 'N'
		SET @Devolucion    = 0
		SET @Sucursal = dbo.zSav_Lib_SucursalParaConsultas(@Cod_Emp,GETDATE())
		SET @Promocion    = 'N'
		SET @Dimensionado   = 'N'
		SET @EsVtaPersonal   = 0
		SET @CorteExpress   = 'N'
		SET @Origen_TiendaWeb = @Cod_Emp

		 -- Crea cabecera de la cotizacion          
	  INSERT INTO SAV_VT.dbo.Sav_Vt_TraCab (              
		Cod_Emp, Cod_Tienda, Tipo_Documento, Cod_Entidad, Cod_Sucursal,
		Seq_Direccion, Seq_Despacho, Fecha_Emision, Fecha_Vencimiento, Cod_Responsable, 
		Cod_Vendedor, Cod_ListaPrecio, Neto, Iva, Total, 
		Descuento, Cod_Retirador, Fecha_Despacho, Orden_Compra, Cod_FormaPago, 
		Cod_PlazoPago, Cod_Recargo, Observaciones, Presente, Directo, 
		Flete, Estado, Retroactivo, Nro_Impreso, Gen_Credito,
		FechaCreacion, PedidoPalm, DirDesFecDesHorDes, Estado_Visado, Fecha_Visado,
		Usuario_Visado, Nivel_Visado, RC, Cod_RegionVenta, Tipo_Emision, 
		Mecanizado, Venta_Calzada, Devolucion, Sucursal, Promocion, 
		Dimensionado, EsVtaPersonal, CorteExpress, Origen_TiendaWeb		
	   )
	  SELECT           
		@Cod_Emp, @Cod_Tienda, @Tipo_Documento, @Cod_Entidad, @Cod_Sucursal,
		@Seq_Direccion, @Seq_Despacho, @Fecha_Emision, @Fecha_Vencimiento, @Cod_Responsable,
		@Cod_Vendedor, @Cod_ListaPrecio, @Neto, @Iva, @Total,
		@Descuento, @Cod_Retirador, @Fecha_Despacho, @Orden_Compra, @Cod_FormaPago,
		@Cod_PlazoPago, @Cod_Recargo, @Observaciones, @Presente, @Directo,
		@Flete, @Estado, @Retroactivo, @Nro_Impreso, @Gen_Credito,
		@FechaCreacion, @PedidoPalm, @DirDesFecDesHorDes, @Visado_Estado, @Visado_Fecha,
		@Visado_Usuario, @Visado_Nivel, case when @Flete = 'S' then 0 else @RC end,
		@Cod_RegionVenta, @Tipo_Emision, @Mecanizado, @Venta_Calzada, @Devolucion,
		@Sucursal, @Promocion, @Dimensionado, @EsVtaPersonal, @CorteExpress, @Origen_TiendaWeb
		

		SET @NRO_INTERNO = @@IDENTITY

		CREATE TABLE #Detalle(codRapido	INT, cantidad INT, _precio INT, _preciolinea INT, Line INT,)
		INSERT INTO #Detalle(codRapido,	cantidad, _precio)
				SELECT cod_rapido, cantidad, monto FROM #ItemsDetalle 

		--Se Busca Bodega principal de la tienda          
       SET @Cod_Bodega = ISNULL((SELECT TOP 1 Cod_Bodega FROM SAV.DBO.PAR_BODEGAS (NOLOCK) WHERE Cod_Emp = @Cod_Emp AND Bod_Principal = 'S'),'B05')          
          
		-- Tabla Temporal del detalle de la cotizacion           
		CREATE TABLE #SAV_VT_TRADet_Paso(          
		Cod_Emp                   	char(8)           	NOT NULL,          
   		Nro_Interno               	int       	NOT NULL,          
		Tipo_Documento            	char(4)           	NOT NULL,
		Nro_Linea                 	int               	NOT NULL,          
		Cod_Bodega                	varchar(4)        	NOT NULL,
		Cod_Producto              	varchar(13)       	NOT NULL,          
		Cod_Rapido                	int               	NOT NULL,          
		Descripcion               	varchar(150)      	NOT NULL,          
		Observacion               	text              	NOT NULL DEFAULT (''),          
		Cod_Unimed                	varchar(10)       	NOT NULL,          
		Seq_Unimed                	int               	NOT NULL,          
		Cantidad                  	DECIMAL(18, 4)    	NOT NULL,          
		Precio_Costo              	int               	NOT NULL DEFAULT ((0)),
		Precio_Lista				int					NOT NULL DEFAULT ((0)),       
		Precio_Unitario				int					NOT NULL DEFAULT ((0)),
		SubTotal					int					NOT NULL DEFAULT ((0)),
		PorcentajeCv				DECIMAL(18, 4)		NOT NULL DEFAULT ((0)),
		MontoCv						int					NOT NULL DEFAULT ((0)),
		PorcentajeDv				DECIMAL(18, 4)		NOT NULL DEFAULT ((0)),
		MontoDv						int					NOT NULL DEFAULT ((0)),
		Total						int					NOT NULL DEFAULT ((0)),
		PorcentajeDo				DECIMAL(18, 4)		NOT NULL  DEFAULT ((0)),          
		MontoDo						int					NOT NULL  DEFAULT ((0)),  
		Cod_Autorizador           	char(20)          	NOT NULL, 
		PorcentajeDg				DECIMAL(18, 4)		NOT NULL  DEFAULT ((0)),          
		MontoDg						int					NOT NULL  DEFAULT ((0)), 
		Cod_ListaPrecio           	varchar(10)       	NOT NULL,          
		FechaLinea                	datetime          	NOT NULL,          
		Presente                  	char(1)           	NOT NULL,          
		Directo                   	char(1)           	NOT NULL,          
		Mecanizado                	char(1)           	NOT NULL,          
		Tipo_Mecanizado           	char(1)           	NOT NULL DEFAULT ('N'),          
		Flete                     	char(1)           	NOT NULL,          
		FechaDespacho             	datetime          	NOT NULL,          
		EstadoLinea               	char(1)           	NOT NULL,          
		Tipo_DocumentoP           	char(4)           	NOT NULL,          
		Nro_InternoP              	int               	NOT NULL,          
		Nro_LineaP                	int               	NOT NULL,          
		Id_Linea                  	uniqueidentifier  	NULL DEFAULT (newid()),          
		PesoProducto              	DECIMAL(18, 8)    	NOT NULL DEFAULT ((0)),          
		Dibujo                    	char(1)           	NULL DEFAULT ('N'),          
		CEIdentificador           	int               	NULL DEFAULT ((0)),          
		CETipoCond                	char(1)           	NULL DEFAULT ('D'),          
		CECosto                   	int               	NULL DEFAULT ((0)),          
		CEDesc1                   	DECIMAL(18, 8)    	NULL DEFAULT ((0)),          
		CECod_Proveedor           	varchar(13)       	NULL DEFAULT (''),          
		CECod_Sucursal            	varchar(3)        	NULL DEFAULT (''),          
		CEPlazo                   	int               	NULL DEFAULT ((0)),          
		CEAcordadoCon             	varchar(50)       	NULL DEFAULT (''),          
		Cod_Tienda                	char(8)           	NULL DEFAULT (''),          
		Danado                    	char(1)           	NULL DEFAULT ('N'),          
		Sucursal                  	char(8)           	NULL DEFAULT (''),          
		Tipo_Flete 	char(1)           	NULL DEFAULT ('N'),          
		Cod_Cotizacion            	int               	NULL DEFAULT ((0)),          
		Venta_Calzada             	varchar(1)        	NOT NULL DEFAULT (''),          
		DiferenciaVC              	DECIMAL(18, 4)    	NOT NULL DEFAULT ((0)),          
		ID_Pkg                    	int               	NOT NULL DEFAULT ((0)),          
		RolProducto               	char(2)           	NOT NULL DEFAULT (''),          
		PorcentajeDP 				DECIMAL(18, 4)    	NOT NULL DEFAULT ((0)),          
		MontoDP   					int               	NOT NULL DEFAULT ((0)),
		PorcentajeDescEmb			DECIMAL(18, 4)		NULL DEFAULT ((0)),
		MontoDescEmb				int					NULL DEFAULT ((0)),
		Precio_Real					int					NULL DEFAULT ((0)), 
		COD_ORI_VTA               	varchar(3)        	NULL DEFAULT (''),
		priceInfo                 	VARCHAR(MAX)     	DEFAULT(0),          
		cantidadEmbalaje          	INT               	DEFAULT(0),
		DescuentoEmbalaje         	DECIMAL(18, 4),
		OPT							INT					NULL default 0
		)

		-- Carga tabla de paso con datos de los productos (optimizados y no optimizados)
		INSERT INTO  #SAV_VT_TRADet_Paso(          
			Cod_Emp, Nro_Interno, Tipo_Documento, Nro_Linea, Cod_Bodega,     
			Cod_Producto, Cod_Rapido, Descripcion, Observacion, Cod_Unimed, 
			Seq_Unimed, Cantidad, Precio_Costo, Cod_ListaPrecio, SubTotal,  
			Total, Cod_Autorizador, 
			FechaLinea, Presente, Directo, Mecanizado, Tipo_Mecanizado, 
			Flete, FechaDespacho, EstadoLinea, Tipo_DocumentoP, Nro_InternoP,  
			Nro_LineaP, Id_Linea, PesoProducto, Dibujo, CEIdentificador,          
			CETipoCond, CECosto, CEDesc1, CECod_Proveedor, CECod_Sucursal,    
			CEPlazo, CEAcordadoCon, Cod_Tienda, Danado, Sucursal,     
			Tipo_Flete, Cod_Cotizacion, Venta_Calzada, DiferenciaVC, ID_Pkg,    
			RolProducto, PorcentajeDP, MontoDP, COD_ORI_VTA, priceInfo,          
			cantidadEmbalaje, DescuentoEmbalaje             
		)
		SELECT 
			@Cod_Emp, @Nro_Interno, @Tipo_Documento,
			ROW_NUMBER() OVER (ORDER BY eco.CodRapido ) AS 'Nro_Linea',
			@Cod_Bodega, prd.Cod_Producto, eco.CodRapido, 'N', '' Observaciones,       
			uni.Cod_unimed, uni.Seq_Unimed, eco.Cantidad, (vta.Costo + vta.MontoRecargo) as Costo,
			vta.PrecioBruto,eco._precio, eco._precio, 
			@Cod_Vendedor, @FechaCreacion, @Presente, @Directo,          
			'N', 'N' Tipo_Mecanizado, @Flete, @Fecha_Despacho, 'I' EstadoLinea,      
			'' Tipo_DocumentoP, 0 Nro_InternoP, 0 Nro_LineaP, NEWID() Id_Linea, prd.Peso,         
			'N' Dibujo, 0 CEIdentificador, '' CETipoCond, 0 CECosto, 0 CEDesc1,       
			'' CECod_Proveedor, '' CECod_Sucursal, 0 CEPlazo, '' CEAcordadoCon, 0,
			'N' Danado, @Sucursal, 'N' Tipo_Flete, 0 Cod_Cotizacion, 'N' Venta_Calzada,          
			0 DiferenciaVC, 0 ID_Pkg, '' RolProducto, 0 PorcentajeDP, 0 MontoDP,     
			'VW' COD_ORI_VTA, CAST('max' as VARCHAR(MAX)), prd.CANTIDADEMBALAJE, vta.DescuentoEmbalaje               
		FROM #Detalle eco          
		INNER JOIN SAV.DBO.PRD_DATOSBASICOS prd (NOLOCK) ON prd.Cod_Rapido = eco.CodRapido          
		INNER JOIN SAV.DBO.PRD_UNIDADMEDIDA uni (NOLOCK) ON uni.Cod_Producto = prd.Cod_Producto AND uni.seq_unimed = 0
		INNER JOIN SAV_VT.dbo.SAV_LP_Ventas vta (NOLOCK) ON vta.Cod_Producto = prd.Cod_Producto AND 
															vta.Cod_RegionIngreso = '013' AND 
															vta.Cod_RegionVenta = @Cod_RegionVenta AND 
															vta.SEQ_UNIMED = uni.Seq_unimed  AND 
															vta.Cod_Lista = @Cod_ListaPrecio 	
														
		 		
		 --Crea detalle de la Cotizacion          
		INSERT INTO SAV_VT.dbo.Sav_Vt_TraDet (          
			Cod_Emp,   Cod_Tienda,    Nro_Interno,   Tipo_Documento,          
			Nro_Linea,   Cod_Bodega,    Cod_Producto,   Cod_Rapido,          
			Descripcion,  Observacion,      Cod_Unimed,      Seq_Unimed,          
			Cantidad,   Precio_Costo,      Precio_Lista,   Precio_Unitario,          
			SubTotal,   PorcentajeCv,      MontoCv,    PorcentajeDv,          
			MontoDv,   Cod_Autorizador,     PorcentajeDg,   MontoDg,          
			Total,    PorcentajeDo,      MontoDo,    Cod_ListaPrecio,          
			FechaLinea,   Presente,    Directo,    Mecanizado,          
			Tipo_Mecanizado, Flete,     FechaDespacho,   EstadoLinea,          
			Tipo_DocumentoP, Nro_InternoP,      Nro_LineaP,      Id_Linea,          
			PesoProducto,  Dibujo,     CEIdentificador,       CETipoCond,          
			CECosto,   CEDesc1,    CECod_Proveedor,       CECod_Sucursal,          
			CEPlazo,   CEAcordadoCon,      Danado,    Sucursal,          
			Tipo_Flete,   Cod_Cotizacion,      Venta_Calzada,   DiferenciaVC,          
			ID_Pkg,             RolProducto,         PorcentajeDP,    MontoDP,          
			PorcentajeDescEmb,  MontoDescEmb,        Precio_Real,   COD_ORI_VTA, ID_OPTIMIZACION   
			)          
			SELECT           
			Cod_Emp,   Cod_Tienda,   Nro_Interno,   Tipo_Documento,          
			Nro_Linea,   Cod_Bodega,   Cod_Producto,   Cod_Rapido,          
			Descripcion,  Observacion,     Cod_Unimed,    Seq_Unimed,          
			Cantidad,   Precio_Costo,     Cod_ListaPrecio,   Precio_Unitario,          
			SubTotal,   PorcentajeCv,     MontoCv,    PorcentajeDv,          
			MontoDv,   Cod_Autorizador,    PorcentajeDg,   MontoDg,          
			Total,    PorcentajeDo,     MontoDo,    Cod_ListaPrecio,          
			FechaLinea,   Presente,   Directo,    Mecanizado,          
			Tipo_Mecanizado, Flete,    FechaDespacho,   EstadoLinea,          
			Tipo_DocumentoP, Nro_InternoP,     Nro_LineaP,    Id_Linea,          
			PesoProducto,  Dibujo,    CEIdentificador,        CETipoCond,          
			CECosto,   CEDesc1,   CECod_Proveedor,  CECod_Sucursal,          
			CEPlazo,   CEAcordadoCon,     Danado,     Sucursal,          
			Tipo_Flete,   Cod_Cotizacion,     Venta_Calzada,          DiferenciaVC,    
			ID_Pkg,    RolProducto,        PorcentajeDP,     MontoDP,          
			PorcentajeDescEmb,  MontoDescEmb, Precio_Real,   COD_ORI_VTA, OPT             
			FROM #SAV_VT_TRADet_Paso 
          
	   SELECT @NRO_INTERNO

	   DROP TABLE #ItemsDetalle
	   DROP TABLE #Items
	   DROP TABLE #SAV_VT_TRADet_Paso
	   DROP TABLE #Detalle	   
	   
	RETURN;
END;
