USE [SAV]
GO
/****** Object:  StoredProcedure [dbo].[LEPTON$Obtiene_Tapacantos_Asociados]    Script Date: 17-05-2019 12:16:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  <Cesar Gonzalez-Rubio SF>    
-- Create date: <03/05/2019>    
-- Description: <Trae informacion requerida de la app, como Tapacantos Asociados>    
-- =============================================  
---------------------------------------------------------------------
 
ALTER PROCEDURE [dbo].[LEPTON$Obtiene_Tapacantos_Asociados]
(
	@COD_RAPIDO			INT		
)
AS
BEGIN
	BEGIN TRY
	SET NOCOUNT ON
    SELECT 
    	a.COD_RAPIDO AS SKU_TABLERO,
    	COD_ASOCIADO AS SKU_TAPACANTOS,
    	VALOR1,
    	db.DESC_LARGA AS DESCRIPCION,ISNULL(a.image_url + CONVERT(NVARCHAR(13),a.COD_ASOCIADO) + '.jpg','') AS IMAGEN,
		CASE WHEN ISNUMERIC(FT.DETALLE) = 1 THEN FT.DETALLE ELSE 0 END  AS MTS_TAPACANTO,
		FT.COD_UNIMED		  
			FROM SAV.dbo.SAV_Tapacantos_Asociados a
				INNER JOIN SAV.dbo.PRD_DATOSBASICOS db  WITH(NoLock) ON a.COD_ASOCIADO 		= db.COD_RAPIDO
	    		INNER JOIN SAV.dbo.PRD_FICHATECNICA FT  WITH(NoLock) ON db.COD_PRODUCTO 	= FT.COD_PRODUCTO
				INNER JOIN SAV.dbo.PAR_DATOSTECNICOS DT WITH(NoLock) ON FT.COD_DATOTECNICO 	= DT.COD_DATOTECNICO 
	    			WHERE a.COD_RAPIDO = @COD_RAPIDO and FT.COD_DATOTECNICO = 192			
						AND   a.ES_RS = 1;

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










