---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================    
-- Author:  <Cesar Gonzalez-Rubio SF>    
-- Create date: <03/05/2019>    
-- Description: <Trae informacion requerida de la app, como Tapacantos Asociados>    
-- =============================================  
---------------------------------------------------------------------
 
ALTER PROCEDURE LEPTON$Obtiene_Tapacantos_Asociados
(
	@COD_RAPIDO			INT		
)
AS
BEGIN
	BEGIN TRY
	SET NOCOUNT ON
		SELECT COD_RAPIDO,			 
			   COD_ASOCIADO, 
			   VALOR1
			   
		FROM SAV.dbo.SAV_Tapacantos_Asociados
	    	WHERE COD_RAPIDO = @COD_RAPIDO			
			AND   ES_RS = 1;

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








