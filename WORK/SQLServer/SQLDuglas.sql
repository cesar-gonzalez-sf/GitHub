Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================    
-- Author:  <Douglas Vegas SF>    
-- Create date: <07/02/2019>    
-- Description: <Trae informacion requerida de la app, como comunas o ciudades, giros>    
-- =============================================  
---------------------------------------------------------------------
-- =============================================    
-- Author:  <Douglas Vegas SF>    
-- modified date: <22/02/2019>    
-- Description: <se agrega giros>    
-- =============================================  
---------------------------------------------------------------------
-- =============================================    
-- Author:  <Douglas Vegas SF>    
-- modified date: <22/04/2019>    
-- Description: <se agrega Tipos de direcciones>    
-- =============================================  
CREATE PROCEDURE SAV$APP_GETINFO
(
	@PRM01			NVARCHAR(20),
	@PRM02			NVARCHAR(20)
		
)
AS
BEGIN
	BEGIN TRY
	SET NOCOUNT ON
		IF (@PRM01 = 'COMUNAS') BEGIN
		SELECT	  COD_COMUNA AS CODIGO
				, RTRIM(LTRIM(DESCRIPCION)) AS DESCRIPCION
		FROM SAV.dbo.PAR_COMUNAS With(nolock)
		WHERE COD_PAIS = 'CHI'
			AND COD_CIUDAD = @PRM02
		RETURN
		END


		IF (@PRM01 = 'REGION') BEGIN
			SELECT  COD_CIUDAD AS CODIGO
				  , RTRIM(LTRIM(DESCRIPCION)) AS DESCRIPCION
			FROM SAV.dbo.PAR_CIUDADES With(nolock)
			WHERE COD_PAIS = 'CHI'		
			RETURN
		END

		IF (@PRM01 = 'GIROS') BEGIN
			SELECT  COD_GIRO AS CODIGO,
					DESCRIPCION AS DESCRIPCION 
			FROM SAV.dbo.PAR_GIROS WITH(NOLOCK)
			ORDER BY DESCRIPCION
			RETURN
		END
		
		IF (@PRM01 = 'TIPODIRECCION') BEGIN
			SELECT  COD_TIPODIRECCION AS CODIGO,
					DESCRIPCION AS DESCRIPCION 
			FROM SAV.dbo.PAR_TIPODIRECCION WITH(NOLOCK)
			WHERE COD_TIPODIRECCION IN (1,5)
			ORDER BY DESCRIPCION
			RETURN
		END
	


	END TRY
	BEGIN CATCH
	 INSERT INTO SAV_LOG.dbo.Sav_Log_Errores    
    (    
      Objeto,     
      Error,     
      Descripcion,     
      Linea    
    )    
	VALUES    
    (  Error_Procedure(),     
      Error_Number(),     
      Error_Message(),     
      Error_Line()    
    )     
	
	RETURN   
	END CATCH
	RETURN
END








