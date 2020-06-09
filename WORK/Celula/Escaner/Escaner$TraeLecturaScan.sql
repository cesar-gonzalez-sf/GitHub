CREATE PROCEDURE Escaner$TraeLecturaScan 
----------------------------------------------------------------------------
-- Procedimiento: Escaner$TraeLecturaScan'  VALTR = '0031432973','VALTR','01P','N',''   EAN13 = '7805502102695','EAN13','01P','N',''
-- Autor: Nicolas Uribe 
-- Fecha de Creacion: 29/12/2019 
-- Objetivo: Traer dato de codigo scaneado
-- Empresa: SF Ingenieria. 
----------------------------------------------------------------------------

	@vCodigo		AS VARCHAR(20),
	@vTipo			AS VARCHAR(5),
	@vCod_lista		AS VARCHAR(3), 
	@vCod_Emp		AS VARCHAR(20),
    @Error_Message	NVARCHAR(4000)  OUTPUT

AS 
	BEGIN
		SET NOCOUNT ON
		SET Xact_Abort ON

		-- #RESULTSET	producto productos
		--   #COLUMN	COD_RAPIDO 			NVARCHAR
		--   #COLUMN	COD_PRODUCTO		NVARCHAR
		--   #COLUMN	DESCRIPCION 		NVARCHAR
		--   #COLUMN	PRECIO_BRUTO		NVARCHAR
		--   #COLUMN	DESCUENTO			NVARCHAR
		--   #COLUMN	CANTIDAD_EMBALAJE	NVARCHAR
		--   #COLUMN	COD_UNIMED			NVARCHAR
		--   #COLUMN	CANTIDAD			NVARCHAR
		--   #COLUMN	TIPO				NVARCHAR
		-- #ENDRESULTSET

		set @Error_Message = '';
		DECLARE @Margen				DECIMAL(18,4)
		DECLARE @Cod_RegionIngreso	CHAR(3) 
		DECLARE @Cod_RegionVenta	CHAR(3)
		DECLARE	@PorcentajeCv		DECIMAL(9,4)
		DECLARE @DiferenciaNew 		DECIMAL(9,4)
		DECLARE	@PrecioOriginalNew	INTEGER
		DECLARE @PrecioRecargoNew	INTEGER
		DECLARE @Cod_Producto13     VARCHAR(14)
		DECLARE @Cod_Producto       VARCHAR(20)
		DECLARE @CantDun14			INTEGER

		Set @CantDun14 = 1 

		CREATE TABLE #PRODUCTO (COD_RAPIDO			INTEGER,
								COD_PRODUCTO		VARCHAR(20),
								DESCRIPCION			VARCHAR(200),
								PRECIO_BRUTO		INTEGER,
								DESCUENTO			INTEGER,
								CANTIDAD_EMBALAJE	INTEGER,
								COD_UNIMED			VARCHAR(10),
								CANTIDAD			INTEGER,
								TIPO				VARCHAR(1))

		/******************************************************** Busca Datos del Producto******************************************/

		 -- Valida si es codigo rapido o codigo EAN13

		IF @vTipo = 'VALTR'
		BEGIN 
			INSERT INTO	#PRODUCTO (COD_RAPIDO, COD_PRODUCTO, DESCRIPCION, PRECIO_BRUTO, DESCUENTO, CANTIDAD_EMBALAJE, COD_UNIMED, CANTIDAD, TIPO)
				SELECT NRO_INTERNO, 'VALE TRANSTORIO', 'VALE TRANSITORIO', TOTAL, DESCUENTO,  0, 'VT', 1, 'V'
					FROM	SAV_VT.DBO.SAV_VT_TRACAB WITH(NOLOCK)
						WHERE	NRO_INTERNO = CONVERT(INT, @vCodigo)

			SELECT 
				  CAST(Ltrim(Rtrim(COD_RAPIDO))			AS NVARCHAR) AS COD_RAPIDO
				, CAST(Ltrim(Rtrim(COD_PRODUCTO))		AS NVARCHAR) AS COD_PRODUCTO
				, CAST(Ltrim(Rtrim(DESCRIPCION))		AS NVARCHAR) AS DESCRIPCION
				, CAST(Ltrim(Rtrim(PRECIO_BRUTO))		AS NVARCHAR) AS PRECIO_BRUTO
				, CAST(Ltrim(Rtrim(CANTIDAD_EMBALAJE))	AS NVARCHAR) AS CANTIDAD_EMBALAJE
				, CAST(Ltrim(Rtrim(COD_UNIMED))			AS NVARCHAR) AS COD_UNIMED
				, CAST(Ltrim(Rtrim(CANTIDAD))			AS NVARCHAR) AS CANTIDAD
				, CAST(LTRIM(RTRIM(TIPO))				AS NVARCHAR) AS TIPO
				, CAST(LTRIM(RTRIM(DESCUENTO))			AS NVARCHAR) AS DESCUENTO
					FROM #PRODUCTO

			RETURN
		END 
   		ELSE IF @vTipo ='EAN13' 
		BEGIN     
			SET @Cod_Producto13 = RIGHT('0000000000000' + @vCodigo,13)     
			SET @Cod_Producto = ISNULL((SELECT TOP 1 cod_producto FROM SAV.DBO.PRD_PROVEEDORESEAN WITH(NOLOCK) WHERE Codigo_Ean = @vCodigo),'')

			IF @Cod_Producto = ''
			BEGIN
				SET @Cod_Producto = ISNULL((SELECT TOP 1 cod_producto FROM SAV.DBO.PRD_PROVEEDORESEAN WITH(NOLOCK) WHERE Codigo_Ean = @Cod_Producto13),'')
			END	
		END ELSE IF @vTipo = 'CODRP'
		BEGIN
 			SET @Cod_Producto = ISNULL((SELECT TOP 1 cod_producto FROM SAV.DBO.PRD_DATOSBASICOS WITH(NOLOCK) where Cod_Rapido = @vCodigo),'')
		
		END ELSE IF @vTipo = 'DUN14'
		BEGIN
			SET @CantDun14 = ISNULL((SELECT TOP 1 Embalaje FROM SAV.dbo.PRD_DATOSEMPAQUE WITH(NOLOCK) where DUN14 = @vCodigo),1)	
			SET @Cod_Producto = ISNULL((SELECT TOP 1 cod_producto FROM SAV.dbo.PRD_DATOSEMPAQUE WITH(NOLOCK) where DUN14 = @vCodigo),'')   		
		END

		Set @Error_Message = ''

		INSERT INTO #PRODUCTO (COD_PRODUCTO, COD_RAPIDO, DESCRIPCION, PRECIO_BRUTO, DESCUENTO, CANTIDAD_EMBALAJE, COD_UNIMED, CANTIDAD, TIPO)
			SELECT	TOP 1
				Prd.Cod_Producto,          
				Prd.Cod_Rapido,          
				Prd.Desc_Larga, 
				0 , 0, 
				Prd.CantidadEmbalaje,        
				Un.COD_UNIMED, 
				1 * @CantDun14, 'P'
				FROM SAV.DBO.Prd_DatosBasicos		Prd WITH(NOLOCK)
					INNER JOIN SAV.DBO.PRD_UNIDADMEDIDA Un  WITH(NOLOCK) ON UN.COD_PRODUCTO = Prd.COD_PRODUCTO AND UN.ACTIVO = 'S'  
						WHERE Prd.Cod_Producto   = @Cod_Producto 

		-- ACTUALIZACION DE PRECIOS SEGUN LISTA

		DECLARE @COD_REGIONVTA AS VARCHAR(5) 
		SELECT @COD_REGIONVTA = COD_REGIONVENTA FROM SAV.DBO.SAV_EMPRESAS WITH(NOLOCK) 
		WHERE COD_EMP = @vCod_Emp

		UPDATE PROD
		SET PROD.PRECIO_BRUTO = LP.PRECIOBRUTO
		FROM #PRODUCTO PROD
		INNER JOIN  SAV_VT.DBO.SAV_LP_VENTAS LP 
		ON LP.Cod_Producto = PROD.COD_PRODUCTO
		AND LP.Cod_Lista = '01P'
		AND LP.Cod_RegionVenta = '013'

		SELECT 
			  CAST(Ltrim(Rtrim(COD_RAPIDO))			AS NVARCHAR) AS COD_RAPIDO
			, CAST(Ltrim(Rtrim(COD_PRODUCTO))		AS NVARCHAR) AS COD_PRODUCTO
			, CAST(Ltrim(Rtrim(DESCRIPCION))		AS NVARCHAR) AS DESCRIPCION
			, CAST(Ltrim(Rtrim(PRECIO_BRUTO))		AS NVARCHAR) AS PRECIO_BRUTO
			, CAST(Ltrim(Rtrim(CANTIDAD_EMBALAJE))	AS NVARCHAR) AS CANTIDAD_EMBALAJE
			, CAST(Ltrim(Rtrim(COD_UNIMED))			AS NVARCHAR) AS COD_UNIMED
			, CAST(Ltrim(Rtrim(CANTIDAD))			AS NVARCHAR) AS CANTIDAD
			, CAST(LTRIM(RTRIM(TIPO))				AS NVARCHAR) AS TIPO
			, CAST(LTRIM(RTRIM(DESCUENTO))			AS NVARCHAR) AS DESCUENTO
			FROM #PRODUCTO

		RETURN 

	END

IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END
