ALTER PROCEDURE dbo.CajaUnificada$Vale_Get
--------------------------------------------------------------------------------
-- Retorna propiedades de Vale Transitorio indexado por NRO_INTERNO.
--------------------------------------------------------------------------------
    @USER_CODE                  AS NVARCHAR(40),    -- Nombre usuario login
    @PROFILE_CODE               AS DECIMAL(7),      -- Perfil usuario login
    @STATION_NAME               AS NVARCHAR(16),    -- Nombre estación trabajo
    ----------------------------------------------------------------------------
    @NRO_INTERNO                AS INTEGER,
	@COD_EMP	                AS NVARCHAR(10),
    ----------------------------------------------------------------------------
    @NOMBRE_CLIENTE             AS NVARCHAR(40)     OUTPUT,
    @FECHA_EMISION              AS DATETIME         OUTPUT,
    @DESCUENTO                  AS INTEGER          OUTPUT,
    @MONTO                      AS INTEGER          OUTPUT,
    @TIPO_DOCUMENTO	            AS NVARCHAR(3)     	OUTPUT
	----------------------------------------------------------------------------
AS
BEGIN
    -- No Count + Trx Rollback
    SET NOCOUNT, XACT_ABORT ON; 


	DECLARE @FECHA_HOY AS VARCHAR(8)
	SET @FECHA_HOY = CONVERT(VARCHAR,GETDATE(),112)
	SELECT @FECHA_HOY

	--Validacion de vale 
	IF EXISTS(
		SELECT TOP 1 1 
		FROM SAV_VT.dbo.SAV_VT_TraCab With(NoLock)
		WHERE Fecha_Emision Between @FECHA_HOY + ' 00:00' AND Fecha_Emision + ' 23:59'
		AND Cod_emp = @COD_EMP
		--AND Estado = '' (DISPONIBLE PARA PAGO) 
	)BEGIN 
		RAISERROR('Vale no disponible para pago', 16, 4);
        RETURN;
	END 


	SELECT 
           @TIPO_DOCUMENTO          = Tra.Tipo_Documento,
           @FECHA_EMISION           = Tra.Fecha_Emision,
           @NOMBRE_CLIENTE			= ISNULL(Cli.Cliente, ''),
           @MONTO                   = Tra.Total,   
		   @DESCUENTO               = Tra.Descuento 
    FROM    SAV_VT.dbo.SAV_VT_TraCab Tra
    INNER JOIN SAV.dbo.PAR_FormaPago Pag
        ON Pag.Cod_FormaPago        = Tra.Cod_FormaPago
    INNER JOIN SAV.dbo.PAR_PlazoPago Pla
        ON Pla.Cod_PlazoPago        = Tra.Cod_PlazoPago
    LEFT JOIN SAV.dbo.FUN_Funcionarios Fun
        ON Fun.Cod_Funcionario      = Tra.Cod_Vendedor
    LEFT JOIN SAV.dbo.Cli_Maestro Cli
        ON Cli.Cod_Entidad          = Tra.Cod_Entidad
        AND Cli.Cod_Sucursal        = Tra.Cod_Sucursal
    WHERE Tra.Cod_Emp               = @COD_EMP
    AND Tra.Nro_Interno             = @NRO_INTERNO
    AND Tra.Tipo_Documento          = Tra.Tipo_Documento;


END;
