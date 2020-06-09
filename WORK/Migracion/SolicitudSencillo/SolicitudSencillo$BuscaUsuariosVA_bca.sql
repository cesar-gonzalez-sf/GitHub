CREATE PROCEDURE dbo.SolicitudSencillo$BuscaUsuariosVA_bca
----------------------------------------------------------------------------
-- Procedimiento: SolicitudSencillo$BuscaUsuariosVA_bca
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Busca usuarios segun parametro y valor.
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Busca usuarios segun parametro y valor, basado en el SAV_LIB_BuscaUsuariosxValorAtributo 
----------------------------------------------------------------------------
	@VALOR			VARCHAR(50), 
	@PARAMETRO		CHAR(20),
    @Error_Message  NVARCHAR(4000) OUTPUT
AS
	BEGIN
		SET NOCOUNT ON
		SET Xact_Abort On

			-- #RESULTSET	solicitud solicitudes
        	--  #COLUMN   USU_CODIGO      		NVARCHAR   
			--  #COLUMN   USUARIO				NVARCHAR
			--  #COLUMN   EMAIL				NVARCHAR
			--  #COLUMN   RUT  		NVARCHAR
			-- #ENDRESULTSET

		SELECT
			CAST(Ltrim(Rtrim(ATU.USU_CODIGO))	AS NVARCHAR) AS USU_CODIGO,
			CAST(Ltrim(Rtrim(USU.USUARIO))		AS NVARCHAR) AS USUARIO, 
			CAST(Ltrim(Rtrim(USU.EMAIL))		AS NVARCHAR) AS EMAIL, 
			CAST(Ltrim(Rtrim(USU.RUT))			AS NVARCHAR) AS RUT
			FROM ECUBAS.dbo.EcuACCATU ATU WITH (NOLOCK)  
				INNER JOIN	ECUBAS.dbo.EcuACCATR ATR WITH (NOLOCK) ON  ATR.ATR_ID = ATU.ATR_ID  
				INNER JOIN	ECUBAS.dbo.EcuACCUSU USU WITH (NOLOCK) ON  ATU.USU_CODIGO = USU.USU_CODIGO
				WHERE ATU.ATU_VALOR LIKE '%'+@VALOR	AND ATR.ATR_CODIGO = @PARAMETRO
				order by USUARIO desc

	END

GRANT EXECUTE ON SAV.dbo.SAV_LIB_BuscaUsuariosxValorAtributo To SavSysUser

		IF @@Error <> 0
		BEGIN
			SELECT
			@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
			RETURN
		END

