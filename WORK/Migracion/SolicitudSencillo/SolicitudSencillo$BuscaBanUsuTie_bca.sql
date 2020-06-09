CREATE PROCEDURE SolicitudSencillo$BuscaBanUsuTie_bca 
----------------------------------------------------------------------------
-- Procedimiento: SolicitudSencillo$BuscaBanUsuTie_bca 'CONCE', 'CAJEROAPP'
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Buscar Bandejas de Valores Asociadas al Cajero dentro de la tienda
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Busca bandeja asociada a cajero, basado en el SAV_TS_BuscaBanUsuTie 
----------------------------------------------------------------------------

	@Cod_Emp	VARCHAR(8)
   ,@Cajero		VARCHAR(20)
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

		SELECT
			   CAST(Ltrim(Rtrim(ID_BandejaPos))		AS NVARCHAR) AS ID_BandejaPos
			  ,CAST(Ltrim(Rtrim(Identificador))		AS NVARCHAR) AS Identificador 
			  ,CAST(Ltrim(Rtrim(Descripcion))		AS NVARCHAR) AS Descripcion  
			  ,CAST(Ltrim(Rtrim(Cod_Emp))			AS NVARCHAR) AS Cod_Emp  
			  ,CAST(Ltrim(Rtrim(Estado))			AS NVARCHAR) AS Estado  
			  ,CAST(Ltrim(Rtrim(Fecha_Creacion))	AS NVARCHAR) AS Fecha_Creacion  
			  ,CAST(Ltrim(Rtrim(Usuario_Creacion))	AS NVARCHAR) AS Usuario_Creacion   
			  ,CAST(Ltrim(Rtrim(Usuario_Cajero))	AS NVARCHAR) AS Usuario_Cajero 
			  ,CASE WHEN CAST(Ltrim(Rtrim(Estado)) AS NVARCHAR) = 'S' THEN 'Sin ASignar'
					WHEN CAST(Ltrim(Rtrim(Estado)) AS NVARCHAR) = 'A' THEN 'ASignada'
					WHEN CAST(Ltrim(Rtrim(Estado)) AS NVARCHAR) = 'U' THEN 'En Uso'
					WHEN CAST(Ltrim(Rtrim(Estado)) AS NVARCHAR) = 'I' THEN 'Iniciada'
					WHEN CAST(Ltrim(Rtrim(Estado)) AS NVARCHAR) = 'C' THEN 'Cerrada'
				ELSE '' END AS DesEstado,
				IsNull(CAST(Ltrim(Rtrim(UrlMonedero))	   AS NVARCHAR),'')	AS UrlMonedero,
				IsNull(CAST(Ltrim(Rtrim(UsuarioMonedero))  AS NVARCHAR),'')	AS UsuarioMonedero, 
				IsNull(CAST(Ltrim(Rtrim(PasswordMonedero)) AS NVARCHAR),'') AS PasswordMonedero
		FROM SAV_CJ.dbo.SAV_TS_BandejaPos WITH(NOLOCK)
			WHERE Cod_Emp = @Cod_Emp AND Usuario_Cajero	= @Cajero   

	END

IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END