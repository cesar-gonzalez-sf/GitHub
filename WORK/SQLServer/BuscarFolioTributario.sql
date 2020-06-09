--Text
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--CREATE PROCEDURE [dbo].[SAV_AC_FoliosTributarios]   
----Autor   : FFC.                            
----Fecha   : 29-03-2016                            
----Descripción : Llena grilla de control Folio tributario            
----              [SAV_AC_FoliosTributarios] '3','2016'           

----Autor   : FFC.                            
----Fecha   : 29-04-2016                            
----Descripción : Se agrega validación de las filas que esten con estado activo (Activo = 1)                       
 
 DECLARE
 @mes int,    
 @anio int    
             

SET @mes  = 2
SET @anio = 2012                    
 --As                          
                          
 --Begin                                                    
 --Begin Try                          
 -- Set NoCount On     

  create table #Principal    
   ( TipoDoc varchar(3),    
   estado varchar(2),  
   F_autorizado varchar(10),    
   Primer_F varchar(10),    
   Ultimo_F varchar(10),    
   Emitidos int,    
   Disponibles int,    
   Estimado  numeric (11,3),    
   Fecha_ven date,    
   usu_crea varchar(40),    
   fecha_crea datetime    
   )    
  
insert into #Principal  
SELECT
  TipoDoc
  ,estado
  ,F_autorizado
  ,Primer_F
  ,Ultimo_F
  ,Emitidos
  ,Disponibles
  ,Estimado
  ,Fecha_ven
  ,usu_crea
  ,fecha_crea
FROM SAV_AC.dbo.SAV_AC_FoliosTributarios WITH (NOLOCK)
WHERE estado = 'HA'
AND activo = 1
  
-- Declaracion de variables para el cursor  
 DECLARE  @TipoDoc varchar(3),    
    @estado varchar(2),  
    @F_autorizado varchar(10),    
    @Primer_F varchar(10),    
    @Ultimo_F varchar(10),    
    @Emitidos int,    
    @Disponibles int ,    
    @Estimado numeric (11,3),    
    @Fecha_ven date,    
    @usu_crea varchar(40),    
    @fecha_crea datetime    
  
  
 -- Declaración del cursor  
  
 DECLARE FoliosTrib CURSOR FOR  
  SELECT
    TipoDoc
    ,F_autorizado
    ,Primer_F
    ,Ultimo_F
    ,Fecha_ven
    ,usu_crea
    ,fecha_crea
  FROM #Principal   
    
 -- Apertura del cursor  
 OPEN FoliosTrib  
 -- Lectura de la primera fila del cursor  
 FETCH NEXT FROM FoliosTrib INTO  @TipoDoc,@F_autorizado, @Primer_F, @Ultimo_F, @Fecha_ven,@usu_crea,@fecha_crea  
   
 WHILE (@@FETCH_STATUS = 0 )  
  BEGIN  
    
  /*FCE 33 Factura Electrónica*/   
  if @TipoDoc = 'FCE'  
  begin  
  SET @F_autorizado = ISNULL((SELECT
      MAX(Nro_Impreso)
    FROM sav_vt.dbo.SAV_VT_FCVCab WITH (NOLOCK)
    WHERE Tipo_Documento = 'FCV'
    AND Electronica = 'S'
    AND YEAR(Fecha_Emision) = @anio
    AND MONTH(Fecha_Emision) = @mes
    AND CONVERT(INT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)
  , '')  

  SET @Emitidos = (SELECT
      COUNT(Nro_Impreso)
    FROM sav_vt.dbo.SAV_VT_FCVCab WITH (NOLOCK)
    WHERE Tipo_Documento = 'FCV'
    AND Electronica = 'S'
    AND CONVERT(INT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)  

  SET @Disponibles = ((CONVERT(INT, @Ultimo_F) - CONVERT(INT, @Primer_F)) - CONVERT(INT, @Emitidos))
  SET @Estimado = (CASE
    WHEN @Emitidos IS NULL THEN 0
    WHEN @Emitidos = 0 THEN 0
    ELSE @Disponibles / @Emitidos
  END)  

   -- Lectura de la siguiente fila del cursor  
  UPDATE #Principal
  SET F_autorizado = @F_autorizado
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = @Estimado
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
     
   if @Disponibles = 0   
    begin  
  UPDATE SAV_AC.dbo.SAV_AC_FoliosTributarios
  SET F_autorizado = @F_autorizado
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = @Estimado
    ,estado = 'NH'
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
      
  DELETE FROM #Principal
  WHERE Primer_F = @Primer_F
    AND Ultimo_F = @Ultimo_F
    AND TipoDoc = @TipoDoc  
   end  
  end  
    
   /*FEE 34 Factura No Afecta o Exenta Electrónica*/    
  if @TipoDoc = 'FEE'  
  begin  
  SET @F_autorizado = ISNULL((SELECT
      MAX(Nro_Impreso)
    FROM sav_vt.dbo.SAV_VT_FCVCab
    WHERE Tipo_Documento = 'FEX'
    AND Electronica = 'S'
    AND YEAR(Fecha_Emision) = @anio
    AND MONTH(Fecha_Emision) = @mes
    AND CONVERT(INT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)
  , '')  

  SET @Emitidos = (SELECT
      COUNT(Nro_Impreso)
    FROM sav_vt.dbo.SAV_VT_FCVCab WITH (NOLOCK)
    WHERE Tipo_Documento = 'FEX'
    AND Electronica = 'S'
    AND CONVERT(INT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)  

  SET @Disponibles = ((CONVERT(INT, @Ultimo_F) - CONVERT(INT, @Primer_F)) - CONVERT(INT, @Emitidos))

  SET @Estimado = (CASE
    WHEN @Emitidos IS NULL THEN 0
    WHEN @Emitidos = 0 THEN 0
    ELSE @Disponibles / @Emitidos
  END)  
   -- Lectura de la siguiente fila del cursor  
  UPDATE #Principal
  SET F_autorizado = @F_autorizado
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = @Estimado
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
     
   if @Disponibles = 0   
    begin  
  UPDATE SAV_AC.dbo.SAV_AC_FoliosTributarios
  SET F_autorizado = @F_autorizado
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = @Estimado
    ,estado = 'NH'
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
      
  DELETE FROM #Principal
  WHERE Primer_F = @Primer_F
    AND Ultimo_F = @Ultimo_F
    AND TipoDoc = @TipoDoc  
   end  
  end  
    
  /*BLV 39 Total operaciones del mes, con boleta electrónica*/  
  if @TipoDoc = 'BLV'  
  begin  
  SET @F_autorizado = ISNULL((SELECT
      MAX(Nro_Impreso)
    FROM sav_vt.dbo.SAV_VT_BLVCab WITH (NOLOCK)
    WHERE Electronica = 'S'
    AND YEAR(Fecha_Emision) = @anio
    AND MONTH(Fecha_Emision) = @mes
    AND CONVERT(INT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)
  , '')  

  SET @Emitidos = (SELECT
      COUNT(Nro_Impreso)
    FROM sav_vt.dbo.SAV_VT_BLVCab WITH (NOLOCK)
    WHERE Electronica = 'S'
    AND CONVERT(INT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)

  SET @Disponibles = ((CONVERT(INT, @Ultimo_F) - CONVERT(INT, @Primer_F)) - CONVERT(INT, @Emitidos))

  SET @Estimado = (CASE
    WHEN @Emitidos IS NULL THEN 0
    WHEN @Emitidos = 0 THEN 0
    ELSE @Disponibles / @Emitidos
  END)  
   -- Lectura de la siguiente fila del cursor  
  UPDATE #Principal
  SET F_autorizado = @F_autorizado
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = @Estimado
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
     
   if @Disponibles = 0   
    begin  
  UPDATE SAV_AC.dbo.SAV_AC_FoliosTributarios
  SET F_autorizado = @F_autorizado
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = @Estimado
    ,estado = 'NH'
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
      
  DELETE FROM #Principal
  WHERE Primer_F = @Primer_F
    AND Ultimo_F = @Ultimo_F
    AND TipoDoc = @TipoDoc  
   end  
  end  
    
   /*NCE 61 Nota de Crédito Electrónica*/    
  if @TipoDoc = 'NCE'  
  begin  
  SET @F_autorizado = ISNULL((SELECT
      MAX(Nro_Impreso)
    FROM sav_vt.dbo.SAV_VT_NCVCab WITH (NOLOCK)
    WHERE Electronica = 'S'
    AND YEAR(Fecha_Emision) = @anio
    AND MONTH(Fecha_Emision) = @mes
    AND CONVERT(INT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)
  , '')  
  SET @Emitidos = (SELECT
      COUNT(Nro_Impreso)
    FROM sav_vt.dbo.SAV_VT_NCVCab WITH (NOLOCK)
    WHERE Electronica = 'S'
    AND CONVERT(INT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)

  SET @Disponibles = ((CONVERT(INT, @Ultimo_F) - CONVERT(INT, @Primer_F)) - CONVERT(INT, @Emitidos))

  SET @Estimado = (CASE
    WHEN @Emitidos IS NULL THEN 0
    WHEN @Emitidos = 0 THEN 0
    ELSE CONVERT(NUMERIC(10, 1), @Disponibles) / CONVERT(NUMERIC(10, 1), @Emitidos)
  END)  
   -- Lectura de la siguiente fila del cursor  
  UPDATE #Principal
  SET F_autorizado = @F_autorizado
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = @Estimado
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
     
   if @Disponibles = 0  
    begin  
  UPDATE SAV_AC.dbo.SAV_AC_FoliosTributarios
  SET F_autorizado = @F_autorizado
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = @Estimado
    ,estado = 'NH'
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
      
  DELETE FROM #Principal
  WHERE Primer_F = @Primer_F
    AND Ultimo_F = @Ultimo_F
    AND TipoDoc = @TipoDoc  
   end  
  end  
    
    
  /*NDB 56 Nota de Débito Electrónica*/    
  if @TipoDoc = 'NDB'  
  begin  
  SET @F_autorizado = ISNULL((SELECT
      MAX(Nro_Impreso)
    FROM sav_vt.dbo.SAV_VT_NDBCab WITH (NOLOCK)
    WHERE Electronica = 'S'
    AND YEAR(Fecha_Emision) = @anio
    AND MONTH(Fecha_Emision) = @mes
    AND CONVERT(INT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)
  , '')  

  SET @Emitidos = (SELECT
      COUNT(Nro_Impreso)
    FROM sav_vt.dbo.SAV_VT_NDBCab WITH (NOLOCK)
    WHERE Electronica = 'S'
    AND CONVERT(INT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)

  SET @Disponibles = ((CONVERT(INT, @Ultimo_F) - CONVERT(INT, @Primer_F)) - CONVERT(INT, @Emitidos))

  SET @Estimado = (CASE
    WHEN @Emitidos IS NULL THEN 0
    WHEN @Emitidos = 0 THEN 0
    ELSE @Disponibles / @Emitidos
  END)  
   -- Lectura de la siguiente fila del cursor  
  UPDATE #Principal
  SET F_autorizado = @F_autorizado
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = @Estimado
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
     
   if @Disponibles = 0   
    begin  
  UPDATE SAV_AC.dbo.SAV_AC_FoliosTributarios
  SET F_autorizado = @F_autorizado
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = @Estimado
    ,estado = 'NH'
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
      
  DELETE FROM #Principal
  WHERE Primer_F = @Primer_F
    AND Ultimo_F = @Ultimo_F
    AND TipoDoc = @TipoDoc  
   end  
  end  
    
  /*GDV 52 Guía de Despacho Electrónica*/   
  if @TipoDoc = 'GDV'  
  begin  
  SET @F_autorizado = ISNULL((SELECT
      MAX(Nro_Impreso)
    FROM sav.dbo.SAV_CI_GDVCab WITH (NOLOCK)
    WHERE Electronica = 'S'
    AND ISNUMERIC(NRO_IMPRESO) = 1
    AND YEAR(FECHA_CREACION) = @anio
    AND MONTH(FECHA_CREACION) = @mes
    AND CONVERT(INT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)
  , '')
    
  SET @Emitidos = (SELECT
      COUNT(Nro_Impreso)
    FROM sav.dbo.SAV_CI_GDVCab WITH (NOLOCK)
    WHERE Electronica = 'S'
    AND ISNUMERIC(NRO_IMPRESO) = 1
    AND CONVERT(BIGINT, nro_impreso) BETWEEN @Primer_F AND @Ultimo_F)

  SET @Disponibles = ((CONVERT(INT, @Ultimo_F) - CONVERT(INT, @Primer_F)) - CONVERT(INT, @Emitidos))

  SET @Estimado = (CASE
    WHEN @Emitidos IS NULL THEN 0
    WHEN @Emitidos = 0 THEN 0
    ELSE @Disponibles / @Emitidos
  END)  
   -- Lectura de la siguiente fila del cursor  
  UPDATE #Principal
  SET F_autorizado = @F_autorizado
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = @Estimado
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
     
   if @Disponibles = 0   
    begin  
  UPDATE SAV_AC.dbo.SAV_AC_FoliosTributarios
  SET F_autorizado = @Ultimo_F
    ,Emitidos = @Emitidos
    ,Disponibles = @Disponibles
    ,Estimado = 0
    ,estado = 'NH'
  WHERE Primer_F = @Primer_F
  AND Ultimo_F = @Ultimo_F
  AND TipoDoc = @TipoDoc  
      
  DELETE FROM #Principal
  WHERE Primer_F = @Primer_F
    AND Ultimo_F = @Ultimo_F
    AND TipoDoc = @TipoDoc  
   end  
  end  
  
  
FETCH next from  FoliosTrib INTO  @TipoDoc, @F_autorizado,@Primer_F, @Ultimo_F, @Fecha_ven,@usu_crea,@fecha_crea  
 END  
  
 -- Cierre del cursor  
 CLOSE FoliosTrib  
 -- Liberar los recursos  
 DEALLOCATE FoliosTrib  
     
     
SELECT
  TipoDoc
  ,estado
  ,F_autorizado
  ,Primer_F
  ,Ultimo_F
  ,Emitidos
  ,Disponibles
  ,Estimado
  ,Fecha_ven
  ,usu_crea
  ,fecha_crea
FROM #Principal  
union   
SELECT
  ISNULL(TipoDoc, '') AS TipoDoc
  ,estado
  ,ISNULL(F_autorizado, '') AS F_autorizado
  ,Primer_F
  ,Ultimo_F
  ,ISNULL(Emitidos, '') AS Emitidos
  ,ISNULL(Disponibles, '') AS Disponibles
  ,ISNULL(Estimado, '') AS Estimado
  ,Fecha_ven
  ,usu_crea
  ,fecha_crea
FROM SAV_AC.dbo.SAV_AC_FoliosTributarios WITH (NOLOCK)
WHERE estado = 'NH'
AND activo = 1
     
drop table #Principal   
   
-- End Try                          
-- Begin Catch                          
--     Insert Into SAV_LOG.dbo.Sav_Log_Errores                          
--     (                     
--    Objeto                          
--   , Error                          
--   , Descripcion                          
--   , Linea                          
--     )                          
--     Values                          
--     (            
--    Error_Procedure()                           
--   , Error_Number()                          
--   , Error_Message()                          
--   , Error_Line()                          
--     )                           
--     Return 0                          
--  End Catch                          
--  Return 1                 
--End                 
                
                
      



