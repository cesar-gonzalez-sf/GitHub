--ALTER PROCEDURE [dbo].[SAV_AC_InsertarFoliosTributarios]       
--Autor   : FFC.                              
--Fecha   : 31-03-2016                              
--Descripción : inserta folios tributarios              
--[SAV_AC_InsertarFoliosTributarios] 'EX.FRANCISCO.FUENTES','<?xml version="1.0"?><AUTORIZACION><CAF version="1.0"><DA><RE>76821330-5</RE><RS>IMPERIAL S.A.</RS><TD>39</TD><RNG><D>13700001</D><H>14200000</H></RNG><FA>2015-08-11</FA><RSAPK><M>x0xxYw3qutuNE/CDNjFAVNtT1lQUMwqfE4i7K/yFVPA/Ts2vJ9yPOyrOOj282LKX+m6hwIrMJCZasGZgo+HOow==</M><E>Aw==</E></RSAPK><IDK>300</IDK></DA><FRMA algoritmo="SHA1withRSA">M/5L6KdodCNabGzzJzb2oAKY7XzvTpKAMYgrLXy7lr0BS2a4qqLx5z++8IrEZwZRtXmT1wWVXSeUsjJy3S9x/Q==</FRMA></CAF><RSASK>-----BEGIN RSA PRIVATE KEY-----MIIBOwIBAAJBAMdMcWMN6rrbjRPwgzYxQFTbU9ZUFDMKnxOIuyv8hVTwP07Nryfcjzsqzjo9vNiyl/puocCKzCQmWrBmYKPhzqMCAQMCQQCE3aDss/HR57NioFd5dirjPOKO4rgiBxS3sHzH/a44nvz5VohrBYhiZJJwqCnTsYx9M5JMN2nTtJw5XPQQDPrLAiEA5oA9OEBHjZSwxrU2OkCtlN+xCDPHfH/GBNfB9SudlfkCIQDdWI6qRwy1EuMr3AtD2nqwXvA+GnAw5tFrgpj9YDDAewIhAJmq03rVhQkNyy8jeXwrHmM/y1rNL6hVLq3lK/jHvmP7AiEAk5BfHC9dzgyXcpKyLTxRyun1frxKy0SLnQG7U5V11acCIQCQo4qGXZZyTRtMBh5Ncs5FSsFrdaLgpV5dfHv4kg3yOg==-----END RSA PRIVATE KEY-----</RSASK><RSAPUBK>-----BEGIN PUBLIC KEY-----MFowDQYJKoZIhvcNAQEBBQADSQAwRgJBAMdMcWMN6rrbjPwgzYxQFTbU9ZUFDMKnxOIuyv8hVTwP07Nryfcjzsqzjo9vNiyl/puocCKzCQmWrBmYKPhzqMCAQM=-----END PUBLIC KEY-----</RSAPUBK></AUTORIZACION>'           

--Autor   : FFC.                              
--Fecha   : 29-04-2016                              
--Descripción : Se agrega columna Activo a la tabla SAV_AC_FoliosTributarios
  DECLARE                         
	@USU_COD VARCHAR (40) = 'FACUNAA',      
	@XmlFolio varchar(max)= '  
<?xml version="1.0"?>
<AUTORIZACION>
    <CAF version="1.0">
        <DA>
            <RE>76821330-5</RE>
            <RS>IMPERIAL S.A.</RS>
            <TD>33</TD>
            <RNG>
                <D>10421</D>
                <H>10720</H>
            </RNG>
            <FA>2019-05-14</FA>
            <RSAPK>
                <M>y5RxWLd9oKO1OI+e31lolr7OQjC+P58qj2mQHk2Psi8NS0NMiMnNS0QciBOUuQfLdNO7aan9QKeXg2K4lpWh4Q==</M>
                <E>Aw==</E>
            </RSAPK>
            <IDK>100</IDK>
        </DA>
        <FRMA algoritmo="SHA1withRSA">P3pfgfK06zeRvzADFsIlN/BCtxgqD+Oyzbrs2r0MYOgxIHTvCIYF8OJqSpZu1Vl+AQZaLlp5SRBZhNW53Z9e+Q==</FRMA>
    </CAF>
    <RSASK>-----BEGIN RSA PRIVATE KEY-----
MIIBOgIBAAJBAMuUcVi3faCjtTiPnt9ZaJa+zkIwvj+fKo9pkB5Nj7IvDUtDTIjJ
zUtEHIgTlLkHy3TTu2mp/UCnl4NiuJaVoeECAQMCQQCHuEuQelPAbSN7CmnqO5sP
Kd7Wyyl/v3G08Qq+3l/MHixTn3UtXhx/sT6Zu4ca6cxkPxjoACK13ot1FhkQFWcr
AiEA+/Wfp/3XDu7IRqIHnmxfceJ5ee+5axbnFLQfm/6k6LkCIQDO2DR0xuWTnPH3
/3KrpEmm+/ucHfBeGPKxn6H2/9CeaQIhAKf5FRqpOgn0hYRsBRRIP6FBplFKe5y5
72Miv71UbfB7AiEAieV4TdnuYmihT/+hx8LbxKf9Er6gPrtMdmpr+f/gaZsCIDry
I5HATPHj2zcSkv7lVKUMJEXfC9BoOGqWwRp+OaZ5
-----END RSA PRIVATE KEY-----
</RSASK>
    <RSAPUBK>-----BEGIN PUBLIC KEY-----
MFowDQYJKoZIhvcNAQEBBQADSQAwRgJBAMuUcVi3faCjtTiPnt9ZaJa+zkIwvj+f
Ko9pkB5Nj7IvDUtDTIjJzUtEHIgTlLkHy3TTu2mp/UCnl4NiuJaVoeECAQM=
-----END PUBLIC KEY-----
</RSAPUBK>
</AUTORIZACION>
'      
               
                      
 --As                            
                            
 Begin                            
                            
 Begin Try                            
  Set NoCount On                              
                             
 Declare @TD int      
 Declare @D  int      
 Declare @H  int      
 Declare @FA date      
 Declare @MsgError  varchar(100)       
 Declare @li_CodError Int        
 Declare @li_iDoc  Int         
        
  create table #TD      
  (TD int )      
  create table #D      
  (D int )      
  create table #H      
  (H int )      
  create table #FA      
  (FA date )      
        
  /*Llenar Tipo Documento (TD)*/      
  Exec sp_xml_preparedocument @li_iDoc Output, @XmlFolio        
  Insert Into #TD ( TD )        
  Select TD        
  From OpenXML(@li_iDoc, '/AUTORIZACION/CAF/DA',2)        
   With ( TD    int  )        
  Exec sp_xml_removedocument @li_iDoc          
  set @TD = (select TD from #TD)      
        
  /*Llenar documento Desde (D)*/      
  Exec sp_xml_preparedocument @li_iDoc Output, @XmlFolio        
  Insert Into #D ( D )        
  Select D        
  From OpenXML(@li_iDoc, '/AUTORIZACION/CAF/DA/RNG',2)        
   With ( D    int  )        
  Exec sp_xml_removedocument @li_iDoc          
  set @D = (select D from #D)      
        
  /*Llenar documento Hasta (H)*/      
  Exec sp_xml_preparedocument @li_iDoc Output, @XmlFolio        
  Insert Into #H ( H )        
  Select H        
  From OpenXML(@li_iDoc, '/AUTORIZACION/CAF/DA/RNG',2)        
   With ( H    int  )        
  Exec sp_xml_removedocument @li_iDoc       
  set @H = (select H from #H)      
        
  /*Llenar Fecha Autorizacion (FA)*/      
  Exec sp_xml_preparedocument @li_iDoc Output, @XmlFolio        
  Insert Into #FA ( FA )        
  Select FA        
  From OpenXML(@li_iDoc, '/AUTORIZACION/CAF/DA',2)        
   With ( FA    date  )        
  Exec sp_xml_removedocument @li_iDoc          
  set @FA = (select isnull(FA,'1900-01-01') from #FA)      
         
  --select @TD,@D,@H,@FA      
        
  IF @TD = '' or @TD is null     
   begin      
    set @MsgError = 'Formato XML no válido - Falta tipo documento(TD)'      
    select @MsgError 'MsgError'    
   --return 2      
   SELECT 2
  end       
    
  IF @D = '' or @D is null   
   begin      
    set @MsgError = 'Formato XML no válido - Falta folio desde(D)'      
    select @MsgError 'MsgError'    
   --return 2      
   SELECT 2
  end    
    
   IF @H = '' or @H is null     
   begin      
    set @MsgError = 'Formato XML no válido - Falta folio hasta(H)'      
    select @MsgError 'MsgError'    
   --return 2      
   SELECT 2
  end    
    
   IF @FA = '1900-01-01' or @FA is null     
   begin      
    set @MsgError = 'Formato XML no válido - Falta fecha autorizada(FA)'      
    select @MsgError 'MsgError'    
   --return 2      
   SELECT 2
  end    
    
    IF @D >= @H     
   begin      
    set @MsgError = 'Formato XML no válido - Folios desde es mayor o igual que folios hasta'      
    select @MsgError 'MsgError'    
   --return 2      
   SELECT 2
  end    
    
     
  
        
  declare @TIPO_DOCUMENTO varchar(3)      
  set @TIPO_DOCUMENTO = (select top 1 TIPO_DOCUMENTO FROM SAV.dbo.PAR_TIPODOCUMENTO  with(Nolock) WHERE NUMERO_SII = @TD)      
    
    
  If @TIPO_DOCUMENTO = '' or @TIPO_DOCUMENTO is null  
  begin  
   set @MsgError = 'Tipo de documento no válido, TD = '+convert(varchar,@TD)      
    select @MsgError 'MsgError'    
   --return 2    
   SELECT 2
  end  
       
 declare @BuscaExistente varchar(1)      
       
 select top 1 '1' from SAV_AC.dbo.SAV_AC_FoliosTributarios with(Nolock) where tipodoc = @TIPO_DOCUMENTO and primer_f = @D and Ultimo_F = @H and Fecha_ven = @FA     
 if @@ROWCOUNT = 0    
 begin    
  set @BuscaExistente = '0'     
end    
else    
 begin    
  set @BuscaExistente = '1'    
end    
     
     
  IF @BuscaExistente = '1'      
   begin      
    set @MsgError = 'Este documento ya existe'      
    select @MsgError  'MsgError'        
   --return 2      
   SELECT 2
  end        
        
  INSERT INTO SAV_AC.dbo.SAV_AC_FoliosTributarios(TipoDoc,estado,F_autorizado,Primer_F,Ultimo_F,Emitidos,Disponibles,Estimado,Fecha_ven,usu_crea,fecha_crea,activo)      
  SELECT @TIPO_DOCUMENTO,'HA','',@D,@H,'','','',@FA,@USU_COD,GETDATE(),0       
         
           
                 
    End Try                            
    Begin Catch                            
   --  Insert Into SAV_LOG.dbo.Sav_Log_Errores                            
   --  (                       
   -- Objeto                            
   --, Error                            
   --, Descripcion                            
   --, Linea                            
   --  )                            
   --  Values                            
   --  (                             
   -- Error_Procedure()                             
   --, Error_Number()                            
   --, Error_Message()                            
   --, Error_Line()                            
   --  )  
   SELECT                                  
    Error_Procedure()                             
   , Error_Number()                            
   , Error_Message()                            
   , Error_Line()                            
     
    set @MsgError = 'Error de inserción, favor revisar formato de XML.  
					Si el error persiste contactarse con encargado.'      
    select @MsgError  'MsgError'                      
   --  Return 0                            
   SELECT 0
    End Catch                            
    --Return 1                            
	SELECT 1
                            
End                   
                  



