ALTER PROCEDURE dbo.CajaUnificada$Registra_Pago
--------------------------------------------------------------------------------
-- Registra datos de Transacción CashDro realizado en TOTEM de AutoCaja.
--------------------------------------------------------------------------------
    @WSS_USER_CODE              AS NVARCHAR(40),    -- Nombre usuario login
    @WSS_PROFILE_CODE           AS INTEGER,         -- Perfil usuario login
    @WSS_STATION_CODE           AS NVARCHAR(16),    -- Nombre estación trabajo
    ----------------------------------------------------------------------------
    @NRO_INTERNO                AS INTEGER,
    ----------------------------------------------------------------------------
    @DTE_TIPO_DOCUMENTO         AS NVARCHAR(3)      OUTPUT,
    @DTE_FECHA_HORA_EMISION     AS DATETIME         OUTPUT,
    @DTE_FOLIO                  AS NVARCHAR(10)     OUTPUT,
    @DTE_OBSERVACIONES          AS NVARCHAR(1024)   OUTPUT,
    @EMISOR_RUT                 AS NVARCHAR(13)     OUTPUT,
    @EMISOR_DV                  AS NVARCHAR(1)      OUTPUT,
    @EMISOR_RAZON_SOCIAL        AS NVARCHAR(50)     OUTPUT,
    @EMISOR_GIRO                AS NVARCHAR(1024)   OUTPUT,
    @EMISOR_DIRECCION_MATRIZ    AS NVARCHAR(200)    OUTPUT,
    @EMISOR_DIRECCION_SUCURSAL  AS NVARCHAR(200)    OUTPUT,
    @EMISOR_VENDEDOR            AS NVARCHAR(100)    OUTPUT,
    @CLIENTE_RAZON_SOCIAL       AS NVARCHAR(150)    OUTPUT,
    @CLIENTE_RUT                AS NVARCHAR(13)     OUTPUT,
    @CLIENTE_DV                 AS NVARCHAR(1)      OUTPUT,
    @CLIENTE_DIRECCION          AS NVARCHAR(200)    OUTPUT,
    @CLIENTE_COMUNA             AS NVARCHAR(50)     OUTPUT,
    @CLIENTE_CIUDAD             AS NVARCHAR(50)     OUTPUT,
    @CLIENTE_ORDEN_COMPRA       AS NVARCHAR(50)     OUTPUT,
    @CLIENTE_CONDICIONES        AS NVARCHAr(100)    OUTPUT,
    @TOTAL_NETO                 AS INTEGER          OUTPUT,
    @IVA                        AS INTEGER          OUTPUT,
    @TOTAL                      AS INTEGER          OUTPUT
    ----------------------------------------------------------------------------
AS
BEGIN
    -- No Count + Trx Rollback
    SET NOCOUNT, XACT_ABORT ON;

    DECLARE
		@STATUS						AS INTEGER,
		@MONTO                      AS DECIMAL(16,2),        
		@TBK_CUOTAS					AS INTEGER,
		@COD_TARJETA				AS NVARCHAR(3),
		@COD_ENTIDAD				AS NVARCHAR(13),
		@COD_SUCURSAL				AS NVARCHAR(3),
		@VPAGOS						AS NVARCHAR(MAX),
		@VVALES						AS NVARCHAR(MAX),
        @NRO_INTERNO_DOC_TRIBUTARIO AS INTEGER,
        @NRO_INTERNO_DTE            AS INTEGER,
        @ERROR_OUTPUT               AS NVARCHAR(500),
		@REQST_TIME			        DATETIME,
		@REPLY_TIME			        DATETIME,
		@COMERCIO			        NVARCHAR(12),
		@FECHA				        DECIMAL(8),
		@HORA				        DECIMAL(6),
		@SUCURSAL			        DECIMAL(4),
		@TERMINAL			        DECIMAL(4),
		@CAJERO				        DECIMAL(8)        
     
	IF (ISNULL(@WSS_USER_CODE, '') = '') BEGIN
        RAISERROR('NO SE DEFINE @WSS_USER_CODE', 16, 1);
        RETURN;
    END;

    IF (ISNULL(@WSS_STATION_CODE, '') = '') BEGIN
        RAISERROR('NO SE DEFINE @WSS_STATION_CODE', 16, 2);
        RETURN;
    END;

	IF (ISNULL(@NRO_INTERNO, 0) = 0) BEGIN
        RAISERROR('NO SE DEFINE @NRO_INTERNO', 16, 16);
        RETURN;
    END;

	DECLARE @COD_EMP AS VARCHAR(10)

	SELECT @COD_EMP = ISNULL(ATU_VALOR,'') 
	FROM ECUBAS.dbo.ECUACCATR E
        INNER JOIN ECUBAS.dbo.ECUACCATU U ON U.ATR_ID = E.ATR_ID
    WHERE
        E.ATR_CODIGO = 'PARCAJ02'
    AND U.USU_CODIGO = @WSS_USER_CODE;

	IF (LEN(ISNULL(@COD_EMP, '')) = 0) BEGIN
        RAISERROR('NO SE DEFINE @COD_EMP', 16, 16);
        RETURN;
    END;


	-- SEGUNDO, LEEMOS INFORMACION DESDE EL VALE TRANSITORIO
	SELECT
		@COD_ENTIDAD    = ISNULL(COD_ENTIDAD, ''),
		@COD_SUCURSAL   = ISNULL(COD_SUCURSAL, ''),
        @MONTO          = TOTAL
	FROM
		SAV_VT.dbo.SAV_VT_TRACab WITH(NOLOCK)
	WHERE
		Nro_Interno = @NRO_INTERNO

    IF (@@ROWCOUNT <= 0) BEGIN
        RAISERROR('ERROR, NO SE ENCONTRO EL VALE TRANSITORIO', 16, 17);
        RETURN;
    END;        

    CREATE TABLE #TMP_PAGOS (
        Tipo                    NVARCHAR(3),
        Monto                   INTEGER,
        Cod_Tarjeta             NVARCHAR(3),
        Nro_Tarjeta             NVARCHAR(20),
        Cuotas                  INTEGER,
        Autorizacion            NVARCHAR(30),
        Id_Documento            UNIQUEIDENTIFIER,
        RutCliente              NVARCHAR(10),
        Tipo_Pago               INTEGER,
        CodConvenio             NVARCHAR(20)    DEFAULT '',
        MontoAbono              INTEGER		    DEFAULT 0,
        NumCheque               NVARCHAR(12)	DEFAULT '',
        CtaCte                  NVARCHAR(11)    DEFAULT '',
        Banco                   NVARCHAR(3)	    DEFAULT '',
        Sucursal                NVARCHAR(4)	    DEFAULT '',
        Plaza					NVARCHAR(2)	    DEFAULT '',
        CodEntidad              NVARCHAR(13)    DEFAULT '',
        CodSucursal             NVARCHAR(3)	    DEFAULT '',
        Nivel                   INTEGER
    );	  

    INSERT INTO #TMP_PAGOS (
        Tipo,				Monto,              Cod_Tarjeta,
        Nro_Tarjeta,		Cuotas,             Autorizacion,
        Id_Documento,		Nivel,              Tipo_Pago,
        RutCliente,			CodEntidad,			CodSucursal
    ) VALUES (
        'EFE',				@MONTO,			    '',
        '',					0,					'',
        NEWID(),			4,					0,
        @COD_ENTIDAD,		@COD_ENTIDAD,		@COD_SUCURSAL
    );

	SET @VPAGOS  = '';
    SET @VPAGOS = (SELECT * FROM #TMP_PAGOS AS Detalle FOR XML AUTO, ROOT ('FormasPago'), ELEMENTS);

	SET @VVALES = '';
    SET @VVALES = '<ValesTransitorios><Detalle><Nro_Interno>' + CONVERT(NVARCHAR(20), @NRO_INTERNO) + '</Nro_Interno></Detalle></ValesTransitorios>';

	DECLARE @ID_BANDEJAPOS AS UNIQUEIDENTIFIER
	SELECT
        @ID_BANDEJAPOS	= B.ID_BANDEJAPOS
    FROM
        SAV_CJ.dbo.SAV_TS_BANDEJAPOS B
    WHERE
        B.USUARIO_CAJERO = @WSS_USER_CODE
    AND B.COD_EMP =	@COD_EMP
	AND B.ESTADO = 'U' -- Estado en Uso 
	-- Verificamos que el usuario tenga asignado el valor
    IF (@@ROWCOUNT <= 0) BEGIN
        RAISERROR('Usuario sin bandeja activa', 16, 3);
        RETURN;
    END;

	--INSERTAMOS EL EFECTIVO 
	INSERT INTO SAV_CJ.DBO.SAV_CJ_EFECTIVO_CASHDRO (ID_TRANCASH, ID_BANDEJA, ID_EFECTIVO, MONTO_EFECTIVO, USUARIO_REGISTRO, FECHA_REGISTRO)
	SELECT NEWID(), @ID_BANDEJAPOS, ID_DOCUMENTO, MONTO, @WSS_USER_CODE, GETDATE()
	FROM #TMP_PAGOS

    --EXEC @STATUS = SAV.dbo.SAV_VT_TA$Pago_Paquete_Elec_CMR 
    EXEC @STATUS = SAV.dbo.SAV_CJ_PagoPaqueteElecCMRBanAjuEx2
	@VPAGOS,    --VPAGOS
    @VVALES,    --VVALES
    '',         --VPROMOCIONES
    @WSS_USER_CODE, --VUSUARIO
    @WSS_USER_CODE, --VESTACION
    @COD_EMP,   --VSUCURSAL
    '',         --VVUELTO
    @COD_EMP,   --VCOD_EMP
	@ID_BANDEJAPOS;   --VCOD_EMP
    
    IF (@STATUS <> 1) BEGIN
        RAISERROR('ERROR AL GENERAR DOCUMENTO', 16, 19);
        RETURN;
    END;
	
	IF EXISTS (
		SELECT TOP 1 1 
		FROM SAV_VT.dbo.SAV_VT_BLVDET BCAB WITH(NOLOCK)
		WHERE NRO_INTERNOP = @NRO_INTERNO
	)BEGIN
		SET @DTE_TIPO_DOCUMENTO  = 'BLV'

		SELECT TOP 1 @NRO_INTERNO_DTE = NRO_INTERNO
		FROM SAV_VT.dbo.SAV_VT_BLVDET WITH(NOLOCK)
		WHERE NRO_INTERNOP = @NRO_INTERNO
    END

	IF EXISTS (
		SELECT TOP 1 1 
		FROM SAV_VT.dbo.SAV_VT_FCVDET FCAB WITH(NOLOCK)
		WHERE NRO_INTERNOP = @NRO_INTERNO
	)BEGIN
		SET @DTE_TIPO_DOCUMENTO  = 'FCV'

		SELECT TOP 1 @NRO_INTERNO_DTE = NRO_INTERNO
		FROM SAV_VT.dbo.SAV_VT_FCVDET WITH(NOLOCK)
		WHERE NRO_INTERNOP = @NRO_INTERNO
    END

	IF @DTE_TIPO_DOCUMENTO  = 'FCV'
	BEGIN 
		SELECT
			@DTE_FECHA_HORA_EMISION			= B.Fecha_Emision,
			@DTE_FOLIO						= B.NRO_IMPRESO,
			@DTE_OBSERVACIONES				= B.Observaciones,
			@EMISOR_RUT						= '76821330',
			@EMISOR_DV						= '5',
			@EMISOR_RAZON_SOCIAL			= 'IMPERIAL S.A.',
			@EMISOR_GIRO					= 'Comercialización de materiales de construcción, pinturas elaboración de maderas por mayor y menor.',
			@EMISOR_DIRECCION_MATRIZ		= 'Santa Rosa 7876, La Granja, Santiago',
			@EMISOR_DIRECCION_SUCURSAL		= LTRIM(RTRIM(ISNULL(S.COD_SUC, ''))) + ' - ' + LTRIM(RTRIM(ISNULL(S.DIRECCION, ''))),
			@EMISOR_VENDEDOR				= LTRIM(RTRIM(B.Cod_Vendedor)) + ' - ' + LTRIM(RTRIM(ISNULL(F.FUNCIONARIO, ''))),
			@CLIENTE_RAZON_SOCIAL			= C.CLIENTE,
			@CLIENTE_RUT					= C.RUT_CLIENTE,
			@CLIENTE_DV						= C.DV_CLIENTE,
			@CLIENTE_DIRECCION				= D.DIRECCIONCOMPLETA,
			@CLIENTE_COMUNA					= CO.DESCRIPCION,
			@CLIENTE_CIUDAD					= CI.DESCRIPCION,
			@CLIENTE_ORDEN_COMPRA			= '',
			@CLIENTE_CONDICIONES			= '',
			@TOTAL_NETO						= B.NETO,
			@IVA							= B.IVA,
			@TOTAL							= B.TOTAL
		FROM
			SAV_VT.dbo.SAV_VT_FCVCAB B WITH(NOLOCK)
			LEFT JOIN SAV.dbo.FUN_FUNCIONARIOS F WITH(NOLOCK) ON F.COD_FUNCIONARIO = B.Cod_Vendedor
			LEFT JOIN SAV.dbo.PAR_SUCURSALES S WITH(NOLOCK) ON S.COD_SUC = B.Cod_Emp
			LEFT JOIN SAV.dbo.CLI_MAESTRO C WITH(NOLOCK) ON C.COD_ENTIDAD = B.COD_ENTIDAD AND C.COD_SUCURSAL = B.COD_SUCURSAL
			LEFT JOIN SAV.dbo.CLI_DIRECCIONES D WITH(NOLOCK) ON D.COD_ENTIDAD = B.COD_ENTIDAD AND D.COD_SUCURSAL = B.COD_SUCURSAL AND D.SEQ_DIRECCION = B.SEQ_DIRECCION
			LEFT JOIN SAV.dbo.PAR_COMUNAS CO WITH(NOLOCK) ON CO.COD_CIUDAD = D.COD_CIUDAD AND CO.COD_COMUNA = D.COD_COMUNA AND CO.COD_PAIS = D.COD_PAIS
			LEFT JOIN SAV.dbo.PAR_CIUDADES CI WITH(NOLOCK) ON CI.COD_CIUDAD = D.COD_CIUDAD AND CI.COD_PAIS = D.COD_PAIS
		WHERE
			B.NRO_INTERNO = @NRO_INTERNO_DTE;
	END

	IF @DTE_TIPO_DOCUMENTO  = 'BLV'
	BEGIN 
		SELECT
			@DTE_FECHA_HORA_EMISION			= B.Fecha_Emision,
			@DTE_FOLIO						= B.NRO_IMPRESO,
			@DTE_OBSERVACIONES				= B.Observaciones,
			@EMISOR_RUT						= '76821330',
			@EMISOR_DV						= '5',
			@EMISOR_RAZON_SOCIAL			= 'IMPERIAL S.A.',
			@EMISOR_GIRO					= 'Comercialización de materiales de construcción, pinturas elaboración de maderas por mayor y menor.',
			@EMISOR_DIRECCION_MATRIZ		= 'Santa Rosa 7876, La Granja, Santiago',
			@EMISOR_DIRECCION_SUCURSAL		= LTRIM(RTRIM(ISNULL(S.COD_SUC, ''))) + ' - ' + LTRIM(RTRIM(ISNULL(S.DIRECCION, ''))),
			@EMISOR_VENDEDOR				= LTRIM(RTRIM(B.Cod_Vendedor)) + ' - ' + LTRIM(RTRIM(ISNULL(F.FUNCIONARIO, ''))),
			@CLIENTE_RAZON_SOCIAL			= C.CLIENTE,
			@CLIENTE_RUT					= C.RUT_CLIENTE,
			@CLIENTE_DV						= C.DV_CLIENTE,
			@CLIENTE_DIRECCION				= D.DIRECCIONCOMPLETA,
			@CLIENTE_COMUNA					= CO.DESCRIPCION,
			@CLIENTE_CIUDAD					= CI.DESCRIPCION,
			@CLIENTE_ORDEN_COMPRA			= '',
			@CLIENTE_CONDICIONES			= '', 
			@TOTAL_NETO						= B.NETO,
			@IVA							= B.IVA,
			@TOTAL							= B.TOTAL
		FROM
			SAV_VT.dbo.SAV_VT_BLVCAB B WITH(NOLOCK)
			LEFT JOIN SAV.dbo.FUN_FUNCIONARIOS F WITH(NOLOCK) ON F.COD_FUNCIONARIO = B.Cod_Vendedor
			LEFT JOIN SAV.dbo.PAR_SUCURSALES S WITH(NOLOCK) ON S.COD_SUC = B.Cod_Emp
			LEFT JOIN SAV.dbo.CLI_MAESTRO C WITH(NOLOCK) ON C.COD_ENTIDAD = B.COD_ENTIDAD AND C.COD_SUCURSAL = B.COD_SUCURSAL
			LEFT JOIN SAV.dbo.CLI_DIRECCIONES D WITH(NOLOCK) ON D.COD_ENTIDAD = B.COD_ENTIDAD AND D.COD_SUCURSAL = B.COD_SUCURSAL AND D.SEQ_DIRECCION = B.SEQ_DIRECCION
			LEFT JOIN SAV.dbo.PAR_COMUNAS CO WITH(NOLOCK) ON CO.COD_CIUDAD = D.COD_CIUDAD AND CO.COD_COMUNA = D.COD_COMUNA AND CO.COD_PAIS = D.COD_PAIS
			LEFT JOIN SAV.dbo.PAR_CIUDADES CI WITH(NOLOCK) ON CI.COD_CIUDAD = D.COD_CIUDAD AND CI.COD_PAIS = D.COD_PAIS
		WHERE
			B.NRO_INTERNO = @NRO_INTERNO_DTE;
	END

    -- #ResultSet DETALLE DETALLES
    --   #Column  COD_RAPIDO                     INTEGER
    --   #Column  DESCRIPCION                    NVARCHAR
    --   #Column  CANTIDAD                       DECIMAL
	--   #Column  UNIDAD_MEDIDA                  NVARCHAR
    --   #Column  PRECIO_UNITARIO                INTEGER
    --   #Column  TOTAL                          DECIMAL
 -- #EndResultSet
	IF @DTE_TIPO_DOCUMENTO  = 'BLV'
	BEGIN 
		SELECT
			COD_RAPIDO					= B.Cod_Rapido,
			DESCRIPCION					= B.Descripcion,
			CANTIDAD					= B.Cantidad,
			UNIDAD_MEDIDA				= B.COD_UNIMED,
			PRECIO_UNITARIO				= B.PRECIO_UNITARIO,
			TOTAL						= B.TOTAL              
		FROM
			SAV_VT.dbo.SAV_VT_BLVDet B WITH(NOLOCK)
		WHERE
			B.NRO_INTERNO = @NRO_INTERNO_DTE;
	END
	IF @DTE_TIPO_DOCUMENTO  = 'FCV'
	BEGIN 
		SELECT
			COD_RAPIDO					= B.Cod_Rapido,
			DESCRIPCION					= B.Descripcion,
			CANTIDAD					= B.Cantidad,
			UNIDAD_MEDIDA				= B.COD_UNIMED,
			PRECIO_UNITARIO				= B.PRECIO_UNITARIO,
			TOTAL						= B.TOTAL              
		FROM
			SAV_VT.dbo.SAV_VT_FCVDet B WITH(NOLOCK)
		WHERE
			B.NRO_INTERNO = @NRO_INTERNO_DTE;
	END
END;
