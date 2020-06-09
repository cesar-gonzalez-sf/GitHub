ALTER PROCEDURE dbo.CajaUnificada$Startup
--------------------------------------------------------------------------------
-- Retorna las propiedades iniciales de ejecución de una caja unificada autoservicio
--------------------------------------------------------------------------------
    @USER_CODE                  AS NVARCHAR(40),    -- Nombre usuario login
    @PROFILE_CODE               AS DECIMAL(7),      -- Perfil usuario login
    @STATION_NAME               AS NVARCHAR(16)     -- Nombre estación trabajo
    ----------------------------------------------------------------------------
AS
BEGIN
    -- No Count + Trx Rollback
    SET NOCOUNT, XACT_ABORT ON;

	-- Verificamos que se suministró código de Usuario
    IF (LEN(ISNULL(@USER_CODE, '')) = 0) BEGIN
        RAISERROR('No se especifica usuario', 16, 1);
        RETURN;
    END;
    
    -- Verificamos que se suministró nombre de estación
    IF (LEN(ISNULL(@STATION_NAME, '')) = 0) BEGIN
        RAISERROR('No se especifica nombre de estación', 16, 2);
        RETURN;
    END;    

	DECLARE @PAR_PARAMETROS_CAJA TABLE(
        ID_PARAMETRO        INTEGER IDENTITY(1,1),
        NOMBRE_PARAMETRO    VARCHAR(50),
        VALOR_PARAMETRO     VARCHAR(50)
    );

	DECLARE @COD_EMP AS VARCHAR(10)
	SELECT @COD_EMP = ISNULL(ATU_VALOR,'') 
	FROM ECUBAS.dbo.ECUACCATR E
        INNER JOIN ECUBAS.dbo.ECUACCATU U ON U.ATR_ID = E.ATR_ID
    WHERE
        E.ATR_CODIGO = 'PARCAJ02'
    AND U.USU_CODIGO = @USER_CODE;

	INSERT INTO @PAR_PARAMETROS_CAJA (NOMBRE_PARAMETRO, VALOR_PARAMETRO)
    SELECT
        'COD_EMP', U.ATU_VALOR
    FROM
        ECUBAS.dbo.ECUACCATR E
        INNER JOIN ECUBAS.dbo.ECUACCATU U ON U.ATR_ID = E.ATR_ID
    WHERE
        E.ATR_CODIGO = 'PARCAJ02'
    AND U.USU_CODIGO = @USER_CODE;
	-- Verificamos que el usuario tenga asignado el valor
    IF (@@ROWCOUNT <= 0) BEGIN
        RAISERROR('Usuario sin sucursal definida', 16, 3);
        RETURN;
    END;

	INSERT INTO @PAR_PARAMETROS_CAJA (NOMBRE_PARAMETRO, VALOR_PARAMETRO)
    SELECT
        'ID_BANDEJA', B.Id_BandejaPos
    FROM
        SAV_CJ.dbo.SAV_TS_BANDEJAPOS B
    WHERE
        B.USUARIO_CAJERO = @USER_CODE
    AND B.COD_EMP =	@COD_EMP
	AND B.ESTADO = 'U' -- Estado en Uso 
	-- Verificamos que el usuario tenga asignado el valor
    IF (@@ROWCOUNT <= 0) BEGIN
        RAISERROR('Usuario sin bandeja activa', 16, 3);
        RETURN;
    END;

	INSERT INTO @PAR_PARAMETROS_CAJA (NOMBRE_PARAMETRO, VALOR_PARAMETRO)
    SELECT
        'NOMBRE_BANDEJA', B.Identificador + ' ' + B.Descripcion
    FROM
        SAV_CJ.dbo.SAV_TS_BANDEJAPOS B
    WHERE
        B.USUARIO_CAJERO = @USER_CODE
    AND B.COD_EMP =	@COD_EMP
	AND B.ESTADO = 'U' -- Estado en Uso 
	-- Verificamos que el usuario tenga asignado el valor
    IF (@@ROWCOUNT <= 0) BEGIN
        RAISERROR('Usuario sin bandeja activa', 16, 3);
        RETURN;
    END;
    
	-- #ResultSet PROPIEDAD PROPIEDADES
    --   #Column  NOMBRE    NVARCHAR
    --   #Column  VALOR     NVARCHAR
    -- #EndResultSet
	SELECT
        NOMBRE  = NOMBRE_PARAMETRO,
        VALOR   = VALOR_PARAMETRO
    FROM
        @PAR_PARAMETROS_CAJA
    ORDER BY ID_PARAMETRO;


	--SELECT ''   AS NOMBRE,
 --          ''   AS VALOR
 --   WHERE 0 = 1;
END;
