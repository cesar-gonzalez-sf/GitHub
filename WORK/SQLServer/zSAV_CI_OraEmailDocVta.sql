ALTER Procedure [dbo].[zSAV_CI_OraEmailDocVta]
-------------------------------------------------------------------------      
-- Modificado por : Cristian Armijo      
-- Fecha   : 22-10-2018      
-- Objetivo   : Genera Html con formato de envio de correos      
-- Modificado: Jorge Arroyo - 31-10-2018: se regulariza asunto y se agrega comuna al envio de mail      
-- Modificado: Jorge Arroyo - 12-11-2018: Se elimina correo de copia (envia dos correo al mismo destinatario)..    
-- Modificado: Edgardo Gomez SF - 05-04-2019: Se Modifica el diseño del cuerpo, se agregan imagenes de productos y datos adicionales del cliente
-- Modificado: Edgardo Gomez SF - 25-06-2019: Se Mejoran los diseños de correo.
-- Modificado: Edgardo Gomez SF - 26-06-2019: Se parametrizan las rutas de las imagenes en la tabla pathprocesos
-- Modificado: Edgardo Gomez SF - 13-08-2019: Se modifica la obtencion de datos del html dependiendo del tipo de entrega y se corrige la fecha de entrega
-- Modificado: Edgardo Gomez SF - 20/08/2019: Se modifica la fecha comprometida de los productos
-- Modificado: Cesar Gonzalez SF - 22/08/2019: Se reemplaza imagen de HEADER y FOOTER del HTML 
-------------------------------------------------------------------------      
(      
     @NRO_DOCUMENTO_PADRE INT 
   , @TIPO_DOCUMENTO_PADRE VARCHAR(3) 
   , @Nro_Impreso   VARCHAR(10) 
)      
As   
Begin      
      
 BEGIN TRY      
      
  Declare @Mensaje   VARCHAR(max)      
  Declare @Subject   VARCHAR(100)      
  Declare @TIPO_DOCUMENTO  varchar(3)        
  Declare @To     VARCHAR(200)      
  Declare @From    VARCHAR(500)      
  Declare @CC     VARCHAR(500)       
  Declare @COD_EMP   VARCHAR(20)        
  Declare @Tienda    VARCHAR(750)         
  Declare @fileName  Varchar(8000)      
  Declare @PatPdf   Varchar(8000)       
  Declare @Existe   int      
  Declare @HtmlDelivery  Varchar(max)      
  Declare @HtmlCollect  Varchar(max)         
  Declare @OrdenPedido  Varchar(50)      
  --Declare @TipoDoc   Varchar(5)         
  Declare @Cliente   Varchar(250)      
  Declare @tipoEntrega  Varchar(30)      
  Declare @FechaEntrega  Varchar(20)       
  Declare @EmailCli   Varchar(100)      
  Declare @DireccionEntrega Varchar(300)      
  --Declare @ReferenciaEntrega Varchar(300)      
  Declare @ObservacionEntrega Varchar(300)      
  --Declare @MetodoPago   Varchar(50)      
  --Declare @Telefono   Varchar(50)      
  Declare @Productos   Varchar(Max)      
  Declare @GlsDocVta   Varchar(20)         
  Declare @NroInternoVale  Int          
  Declare @GlsFecha   Varchar(50)          
  Declare @NroInternoP  Int        
  Declare @NombreCli  Varchar(250)    
  Declare @FechaPago  Varchar(20)    
  Declare @SubTotal   Varchar(100)    
  Declare @Despacho   Varchar(100)    
  Declare @Descuento  Varchar(100)    
  Declare @Total      Varchar(100)    
  Declare @Cant_art   Varchar(20)
  Declare @DireccionTienda Varchar(300)
  Declare @RutaImg Varchar(500)
  Declare @RC Int
    
  Set @HtmlDelivery  = ''      
  Set @HtmlCollect  = ''      
  Set @GlsFecha   = 'Fecha de entrega'      
  Set @From    = 'facturacion@imperial.cl;ecommerce@imperial.cl'      
      
  set @fileName = @TIPO_DOCUMENTO_PADRE + @NRO_IMPRESO + '.PDF'      
      
  select @PatPdf = ruta       
  from  sav.dbo.PAR_PATHPROCESOS with(nolock)       
  where sistema = 'OPERACIONES'      
    and CODIGO  = 'ORACX_IMP'      

  select @RutaImg = ruta 
  from sav.dbo.par_pathprocesos with(nolock)
  where sistema = 'VENTA_WEB'
  and codigo = 'CORREO_VW_ORACLE'
      
  select @fileName = @PatPdf +'\'+ @fileName      
        
  --set @fileName = '\\8kvmshare\ControlFuentesImperial\00_Fuentes Desarrollo\FuentesControlesADAPI\Proyectos .Net 2\Portal Web\Nueva carpeta\BLV0016200180.PDF'      
  --set @fileName = '\\apolo\TEST\Generacion Html\Resultados\BLV0014282741.PDF'    
    
  EXEC Master.dbo.xp_fileexist @fileName , @Existe OUT      

  IF @Existe = 0      
  begin      
   Return 0    
  end  
     
  if @TIPO_DOCUMENTO_PADRE not in ('BLV','FCV')      
  begin      
    Return 0     
  end       
      
  Set @GlsDocVta = @TIPO_DOCUMENTO_PADRE      
      
  If @TIPO_DOCUMENTO_PADRE = 'FCV'      
  Begin      
   Set @GlsDocVta = 'Factura'  
   select @RC = RC
   From sav_vt.dbo.sav_vt_FcvCab with(nolock)
   where nro_interno = @NRO_DOCUMENTO_PADRE  
  End      
      
  If @TIPO_DOCUMENTO_PADRE = 'BLV'      
  Begin      
   Set @GlsDocVta = 'Boleta'    
   select @RC = RC
   From sav_vt.dbo.sav_vt_BlvCab with(nolock)
   where nro_interno = @NRO_DOCUMENTO_PADRE  
  End      
 
  ----------------------------------------------------------------------------------------------------------------------     
  ----------------------------------------------------------------------------------------------------------------------      
  ----------------------------------------------------------------------------------------------------------------------      
        
    ------------------------------------------------------------------------------------------------------------------      
    --          Busqueda datos de FCV      
    ------------------------------------------------------------------------------------------------------------------      
    if @TIPO_DOCUMENTO_PADRE = 'FCV'      
    begin      
      
     Set @Productos = ''      
    
   if @RC = 0  
   begin
     Select TOP 1       
         @OrdenPedido    = Fcab.Orden_Compra      
      --, @TipoDoc     = Fcab.Tipo_Documento      
      , @Nro_Impreso    = Fcab.Nro_Impreso      
      , @Cliente     = Mae.Cliente      
      , @NombreCli   = Mae.Nombre    
      , @tipoEntrega    = Case FCab.Flete When 'S' Then 'Despacho' Else 'Retiro en tienda' End         
      , @EmailCli     = Mae.MailWeb      
      , @DireccionEntrega   = Dir.DireccionCompleta + ', ' + ISNULL(com.DESCRIPCION,'')      
      --, @ReferenciaEntrega  = Dir.Referencia      
      , @ObservacionEntrega  = FCab.Observaciones      
      --, @MetodoPago    = ''      
      --, @Telefono     = Mae.Celular      
      , @To      = Mae.MailWeb      
      , @NroInternoVale   = FCab.Nro_InternoP    
     , @Cod_emp   = Fcab.Cod_emp     
     , @FechaPago = Convert(varchar,Fcab.Fecha_Registro,103)    
     , @Total = Convert(varchar,Fcab.Total)    
     From sav_vt.dbo.sav_vt_FcvCab Fcab with(nolock)      
     Inner Join sav.dbo.Cli_Maestro Mae with(nolock)      
      On  FCab.Cod_Entidad  = Mae.Cod_Entidad      
      And FCab.Cod_Sucursal  = Mae.Cod_Sucursal      
     Inner Join Sav.dbo.Cli_Direcciones Dir With(NoLock)      
      On Dir.Cod_Entidad  = Mae.Cod_Entidad      
      And Dir.Cod_Sucursal = Mae.Cod_Sucursal      
      And Dir.Seq_Direccion = FCab.Seq_Despacho      
     inner join Sav.dbo.PAR_COMUNAS com With(NoLock) on      
     com.COD_COMUNA = Dir.COD_COMUNA      
     where Fcab.Nro_Interno      = @NRO_DOCUMENTO_PADRE  
   end  
   else
   begin
       Select TOP 1       
      @OrdenPedido    = Fcab.Orden_Compra      
      --, @TipoDoc     = Fcab.Tipo_Documento      
      , @Nro_Impreso    = Fcab.Nro_Impreso      
      , @Cliente     = Mae.Cliente      
      , @NombreCli   = Mae.Nombre    
      , @tipoEntrega    = Case FCab.Flete When 'S' Then 'Despacho' Else 'Retiro en tienda' End         
      , @EmailCli     = Mae.MailWeb      
      --, @DireccionEntrega   = Dir.DireccionCompleta + ', ' + ISNULL(com.DESCRIPCION,'')      
      --, @ReferenciaEntrega  = Dir.Referencia      
      , @ObservacionEntrega  = FCab.Observaciones      
      --, @MetodoPago    = ''      
      --, @Telefono     = Mae.Celular      
      , @To      = Mae.MailWeb      
      , @NroInternoVale   = FCab.Nro_InternoP    
        , @Cod_emp   = Fcab.Cod_emp     
        , @FechaPago = Convert(varchar,Fcab.Fecha_Registro,103)    
        , @Total = Convert(varchar,Fcab.Total)    
     From sav_vt.dbo.sav_vt_FcvCab Fcab with(nolock)      
     Inner Join sav.dbo.Cli_Maestro Mae with(nolock)    
      On  FCab.Cod_Entidad  = Mae.Cod_Entidad      
      And FCab.Cod_Sucursal  = Mae.Cod_Sucursal      
     Inner Join Sav.dbo.Cli_Direcciones Dir With(NoLock)      
      On Dir.Cod_Entidad  = Mae.Cod_Entidad      
      And Dir.Cod_Sucursal = Mae.Cod_Sucursal      
    --  And Dir.Seq_Direccion = FCab.Seq_Despacho      
     --inner join Sav.dbo.PAR_COMUNAS com With(NoLock) on      
     --com.COD_COMUNA = Dir.COD_COMUNA      
     where Fcab.Nro_Interno      = @NRO_DOCUMENTO_PADRE  
   end  
      
  If not exists (Select top 1 1 from Sav_vt.dbo.sav_vt_FcvDetDesp where Nro_Interno = @NRO_DOCUMENTO_PADRE)
  begin
    --Select @Productos = @Productos + '<tr><td>' + Cast(dat.Cod_Rapido as Varchar) + '</td><td>' + dat.DESC_PUBLICA + '</td><td><CENTER>' + Cast(cast(age.Cantidad as Int) as Varchar)  + '</CENTER></td>' + '</tr>'         
    Select @Productos = @Productos + '<p><tr><td><b><img src="'+case IsNull(dat.url_Imagen_Principal,'0') when '0' then 'https://www.imperial.cl/img/no-image.jpg' else dat.url_Imagen_Principal+'&height=87&width=87'end+'" align="left" width=87 height=87><br><br>' + dat.DESC_PUBLICA + '</b><br><br>&nbsp;&nbsp;&nbsp;&nbsp;Fecha Comprometida    ' + Convert(varchar,Age.FechaDespacho,103) + '</td><td>$' + replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, age.Precio_Lista),1),'.00',''),',','.') + '</td><td>' + Cast(cast(age.Cantidad as Int) as Varchar)  + '</td><td>$'+ replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, age.Total),1),'.00',''),',','.') + '</td>' + '</tr></p>'    
    From sav_vt.dbo.sav_vt_FcvDet Age with(nolock)      
    Inner Join Sav.dbo.Prd_DatosBasicos dat with(nolock)      
    On Age.Cod_Producto = dat.Cod_Producto  
    where Age.Nro_Interno      = @NRO_DOCUMENTO_PADRE     
    And Age.Cod_Producto  <> 'FLETE00000'      
  end
  else
  begin
    Select @Productos = @Productos + '<p><tr><td><b><img src="'+case IsNull(dat.url_Imagen_Principal,'0') when '0' then 'https://www.imperial.cl/img/no-image.jpg' else dat.url_Imagen_Principal+'&height=87&width=87'end+'" align="left" width=87 height=87><br><br>' + dat.DESC_PUBLICA + '</b><br><br>&nbsp;&nbsp;&nbsp;&nbsp;Fecha Comprometida    ' + case when Convert(varchar,desp.FechaDespacho,103) = '' then Convert(varchar,Age.FechaDespacho,103) else Convert(varchar,desp.FechaDespacho,103) end + '</td><td>$' + replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, age.Precio_Lista),1),'.00',''),',','.') + '</td><td>' + Cast(cast(age.Cantidad as Int) as Varchar)  + '</td><td>$'+ replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, age.Total),1),'.00',''),',','.') + '</td>' + '</tr></p>'    
    From sav_vt.dbo.sav_vt_FcvDet Age with(nolock)      
    Inner Join Sav.dbo.Prd_DatosBasicos dat with(nolock)    
    On Age.Cod_Producto = dat.Cod_Producto  
    inner Join sav_vt.dbo.sav_vt_FcvDetDesp desp with(nolock)
    on Age.nro_interno = desp.nro_interno
    and Age.Cod_Producto = desp.Cod_Producto
    where Age.Nro_Interno      = @NRO_DOCUMENTO_PADRE    
    And Age.Cod_Producto  <> 'FLETE00000'    
  end
    
  select @Cant_art = count(*)    
  From sav_vt.dbo.sav_vt_FcvDet Age with(nolock)         
  where Age.Nro_Interno      = @NRO_DOCUMENTO_PADRE    
  And Age.Cod_Producto  <> 'FLETE00000'    
    
  Select @SubTotal = Sum(Age.Total)      
  From sav_vt.dbo.Sav_VT_FcvDet Age With(NoLock)      
  Where Age.Nro_Interno = @NRO_DOCUMENTO_PADRE      
  And Age.Cod_Producto  <> 'FLETE00000'    
    
  --Select @Despacho = Sum(total)      
  --From sav_vt.dbo.Sav_VT_FcvDet Age With(NoLock)      
  --Where Age.Nro_Interno = @NRO_DOCUMENTO_PADRE      
  --And Age.Cod_Producto  = 'FLETE00000'   
    
  --select @Descuento = Sum(Age.MontoDescEmb)    
  --From sav_vt.dbo.sav_vt_FcvDet Age with(nolock)        
  --where Age.Nro_Interno      = @NRO_DOCUMENTO_PADRE    
    
  --selecT @Tienda = RAZONSOCIAL_SII +','+ DIRECCION      
  selecT @Tienda = Nombre_Web
  ,@DireccionTienda = DIRECCION      
     from sav.dbo.sav_empresas with(nolock)      
     where cod_emp = @COD_EMP  
    
  --   Select @NroInternoP = Age.Nro_InternoP       
  --   From sav_vt.dbo.sav_vt_FcvDet Age with(nolock)       
  --   where Age.Nro_Interno      = @NRO_DOCUMENTO_PADRE      
       
  --   Select @MetodoPago = Case cod_tarjeta      
  --          When '004' Then 'Tarjeta de Crédito'      
  --          Else 'Tarjeta de Débito'      
  --         End      
  --   From Sav.dbo.SAV_CJ_Transaccion_TarjetaVw With(NoLock)      
  --   Where Nro_InternoVale = @NroInternoP      
       
     Select @FechaEntrega    = Convert(varchar,min(FCab.FechaDespacho),103)    
   --Select @FechaEntrega    = datename(weekday,FCab.FechaDespacho)+' '+Convert(varchar,FCab.FechaDespacho,103)    
     From sav_vt.dbo.sav_vt_FcvDetDesp Fcab with(nolock)      
     where Fcab.Nro_Interno      = @NRO_DOCUMENTO_PADRE     
      
    end       
      
    ------------------------------------------------------------------------------------------------------------------      
    --          Busqueda datos de BLV      
    ------------------------------------------------------------------------------------------------------------------      
      
    if @TIPO_DOCUMENTO_PADRE = 'BLV'      
    begin      
      
     Set @Productos = ''      
     
   if @RC = 0 
   begin 
     Select top 1       
      @OrdenPedido    = Fcab.Orden_Compra      
      --, @TipoDoc     = Fcab.Tipo_Documento     
      , @Nro_Impreso    = Fcab.Nro_Impreso      
      , @Cliente     = Mae.Cliente      
      , @NombreCli   = Mae.Nombre    
      , @tipoEntrega    = Case FCab.Flete When 'S' Then 'Despacho' Else 'Retiro en tienda' End        
      , @EmailCli     = Mae.MailWeb      
      , @DireccionEntrega   = Dir.DireccionCompleta + ', ' + ISNULL(com.DESCRIPCION,'')      
      --, @ReferenciaEntrega  = Dir.Referencia      
      , @ObservacionEntrega  = FCab.Observaciones      
      --, @MetodoPago    = ''      
      --, @Telefono     = Mae.Celular      
      , @To      = Mae.MailWeb      
      , @NroInternoVale   = FCab.Nro_InternoP     
      , @Cod_emp   = Fcab.Cod_emp    
      , @FechaPago = Convert(varchar,Fcab.Fecha_Registro,103)    
      , @Total = Convert(varchar,Fcab.Total)    
     From sav_vt.dbo.sav_vt_BlvCab Fcab with(nolock)      
     Inner Join sav.dbo.Cli_Maestro Mae with(nolock)      
      On  FCab.Cod_Entidad  = Mae.Cod_Entidad      
      And FCab.Cod_Sucursal  = Mae.Cod_Sucursal      
     Inner Join Sav.dbo.Cli_Direcciones Dir With(NoLock)      
      On Dir.Cod_Entidad  = Mae.Cod_Entidad      
      And Dir.Cod_Sucursal = Mae.Cod_Sucursal      
      And Dir.Seq_Direccion = FCab.Seq_Despacho      
      inner join Sav.dbo.PAR_COMUNAS com With(NoLock) on      
      com.COD_COMUNA = Dir.COD_COMUNA 
     where Fcab.Nro_Interno      = @NRO_DOCUMENTO_PADRE                                                                                                                                             
  end
  else
  begin
    Select top 1       
      @OrdenPedido    = Fcab.Orden_Compra      
      --, @TipoDoc     = Fcab.Tipo_Documento      
      , @Nro_Impreso    = Fcab.Nro_Impreso      
      , @Cliente     = Mae.Cliente      
      , @NombreCli   = Mae.Nombre    
      , @tipoEntrega    = Case FCab.Flete When 'S' Then 'Despacho' Else 'Retiro en tienda' End        
      , @EmailCli     = Mae.MailWeb      
      --, @DireccionEntrega   = Dir.DireccionCompleta + ', ' + ISNULL(com.DESCRIPCION,'')      
      --, @ReferenciaEntrega  = Dir.Referencia      
      , @ObservacionEntrega  = FCab.Observaciones      
      --, @MetodoPago    = ''      
      --, @Telefono     = Mae.Celular      
      , @To      = Mae.MailWeb      
      , @NroInternoVale   = FCab.Nro_InternoP     
      , @Cod_emp   = Fcab.Cod_emp    
      , @FechaPago = Convert(varchar,Fcab.Fecha_Registro,103)    
      , @Total = Convert(varchar,Fcab.Total)    
     From sav_vt.dbo.sav_vt_BlvCab Fcab with(nolock)      
     Inner Join sav.dbo.Cli_Maestro Mae with(nolock)      
      On  FCab.Cod_Entidad  = Mae.Cod_Entidad      
      And FCab.Cod_Sucursal  = Mae.Cod_Sucursal      
     Inner Join Sav.dbo.Cli_Direcciones Dir With(NoLock)      
      On Dir.Cod_Entidad  = Mae.Cod_Entidad      
      And Dir.Cod_Sucursal = Mae.Cod_Sucursal      
      --And Dir.Seq_Direccion = FCab.Seq_Despacho      
      --inner join Sav.dbo.PAR_COMUNAS com With(NoLock) on      
      --com.COD_COMUNA = Dir.COD_COMUNA 
     where Fcab.Nro_Interno      = @NRO_DOCUMENTO_PADRE   
  end      

  If not exists (Select top 1 1 from Sav_vt.dbo.sav_vt_BlvDetDesp where Nro_Interno = @NRO_DOCUMENTO_PADRE)
  begin
    --Select @Productos = @Productos + '<tr><td>' + Cast(dat.Cod_Rapido as Varchar) + '</td><td>' + dat.DESC_PUBLICA + '</td><td><CENTER>' + Cast(cast(age.Cantidad as Int) as Varchar)  + '</CENTER></td>' + '</tr>'       
    Select @Productos = @Productos + '<p><tr><td><b><img src="'+case IsNull(dat.url_Imagen_Principal,'0') when '0' then 'https://www.imperial.cl/img/no-image.jpg' else dat.url_Imagen_Principal+'&height=87&width=87'end+'" align="left" width=87 height=87><br><br>' + dat.DESC_PUBLICA + '</b><br><br>&nbsp;&nbsp;&nbsp;&nbsp;Fecha Comprometida    ' + Convert(varchar,Age.FechaDespacho,103) + '</td><td>$' + replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, age.Precio_Lista),1),'.00',''),',','.') + '</td><td>' + Cast(cast(age.Cantidad as Int) as Varchar)  + '</td><td>$'+ replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, age.Total),1),'.00',''),',','.') + '</td>' + '</tr></p>'    
    From sav_vt.dbo.sav_vt_BlvDet Age with(nolock)      
    Inner Join Sav.dbo.Prd_DatosBasicos dat with(nolock)    
    On Age.Cod_Producto = dat.Cod_Producto      
    where Age.Nro_Interno      = @NRO_DOCUMENTO_PADRE    
    And Age.Cod_Producto  <> 'FLETE00000'      
  end
  else
  begin
    Select @Productos = @Productos + '<p><tr><td><b><img src="'+ case IsNull(dat.url_Imagen_Principal,'0') when '0' then 'https://www.imperial.cl/img/no-image.jpg' else dat.url_Imagen_Principal+'&height=87&width=87'end+'" align="left" width=87 height=87><br><br>' + dat.DESC_PUBLICA + '</b><br><br>&nbsp;&nbsp;&nbsp;&nbsp;Fecha Comprometida    ' + case when Convert(varchar,desp.FechaDespacho,103) = '' then Convert(varchar,Age.FechaDespacho,103) else Convert(varchar,desp.FechaDespacho,103) end + '</td><td>$' + replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, age.Precio_Lista),1),'.00',''),',','.') + '</td><td>' + Cast(cast(age.Cantidad as Int) as Varchar)  + '</td><td>$'+ replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, age.Total),1),'.00',''),',','.') + '</td>' + '</tr></p>'    
    From sav_vt.dbo.sav_vt_BlvDet Age with(nolock)      
    Inner Join Sav.dbo.Prd_DatosBasicos dat with(nolock)    
    On Age.Cod_Producto = dat.Cod_Producto  
    inner Join sav_vt.dbo.sav_vt_BlvDetDesp desp with(nolock)
    on Age.nro_interno = desp.nro_interno
    and Age.Cod_Producto = desp.Cod_Producto
    where Age.Nro_Interno      = @NRO_DOCUMENTO_PADRE    
    And Age.Cod_Producto  <> 'FLETE00000'
  end

    
  select @Cant_art = count(*)    
  From sav_vt.dbo.sav_vt_BlvDet Age with(nolock)         
  where Age.Nro_Interno      = @NRO_DOCUMENTO_PADRE    
  And Age.Cod_Producto  <> 'FLETE00000'    
      
  Select @SubTotal = Sum(Age.Total)      
  From sav_vt.dbo.Sav_VT_BlvDet Age With(NoLock)      
  Where Age.Nro_Interno = @NRO_DOCUMENTO_PADRE      
  And Age.Cod_Producto  <> 'FLETE00000'    
    
  --Select @Despacho = Sum(total)      
  --From sav_vt.dbo.Sav_VT_BlvDet Age With(NoLock)      
  --Where Age.Nro_Interno = @NRO_DOCUMENTO_PADRE      
  --And Age.Cod_Producto  = 'FLETE00000'    
    
  --select @Descuento = Sum(Age.MontoDescEmb)    
  --From sav_vt.dbo.sav_vt_BlvDet Age with(nolock)        
  --where Age.Nro_Interno      = @NRO_DOCUMENTO_PADRE    
    
  --selecT @Tienda = RAZONSOCIAL_SII +','+ DIRECCION      
  selecT @Tienda = Nombre_Web
  ,@DireccionTienda = DIRECCION      
     from sav.dbo.sav_empresas with(nolock)      
     where cod_emp = @COD_EMP    
    
  --   Select @NroInternoP = Age.Nro_InternoP       
  --   From sav_vt.dbo.sav_vt_BlvDet Age with(nolock)       
  --   where Age.Nro_Interno      = @NRO_DOCUMENTO_PADRE      
       
  --   Select @MetodoPago = Case cod_tarjeta      
  --          When '004' Then 'Tarjeta de Crédito'      
  --          Else 'Tarjeta de Débito'      
  --         End      
  --   From Sav.dbo.SAV_CJ_Transaccion_TarjetaVw With(NoLock)      
  --   Where Nro_InternoVale = @NroInternoP      
       
     Select @FechaEntrega    = Convert(varchar,min(FCab.FechaDespacho),103)    
   --Select @FechaEntrega    = datename(weekday,FCab.FechaDespacho)+' '+Convert(varchar,FCab.FechaDespacho,103)    
     From sav_vt.dbo.sav_vt_BlvDetDesp Fcab with(nolock)      
     where Fcab.Nro_Interno      = @NRO_DOCUMENTO_PADRE    
       
    end       
      
    ------------------------------------------------------------------------------------------------------------------      
    --          Generacion Html      
    ------------------------------------------------------------------------------------------------------------------      
      
    If @tipoEntrega <> 'Despacho'      
    Begin      
     Set @GlsFecha  = ''           
    End      
      
    Set @Subject   = 'Estamos preparando tu pedido – Imperial.cl'      
    Set @OrdenPedido  = IsNull(@OrdenPedido, '')      
    --Set @TipoDoc   = IsNull(@TipoDoc, '')      
    Set @Nro_Impreso  = IsNull(@Nro_Impreso, '')      
    Set @Cliente   = IsNull(@Cliente, '')      
    Set @tipoEntrega  = IsNull(@tipoEntrega, '')      
    Set @FechaEntrega  = IsNull(@FechaEntrega, '')      
    Set @EmailCli   = IsNull(@EmailCli, '')      
    Set @DireccionEntrega = IsNull(@DireccionEntrega, '')      
    --Set @ReferenciaEntrega = IsNull(@ReferenciaEntrega, '')      
    Set @ObservacionEntrega = IsNull(@ObservacionEntrega, '')      
    --Set @MetodoPago   = IsNull(@MetodoPago, '')      
    --Set @Telefono   = IsNull(@Telefono, '')      
    Set @Productos   = IsNull(@Productos, '')    
  Set @NombreCli   = IsNull(@NombreCli, '')    
  --Set @fechaPago  = IsNull(@fechaPago, '')      
  Set @Cant_art   = IsNull(@Cant_art, '0')      
  Set @SubTotal   = IsNull(@SubTotal, '0')    
  Set @Despacho   = IsNull(@Despacho, '0')    
  Set @Descuento  = IsNull(@Descuento, '0')    
  Set @Total      = IsNull(@Total,cast(@SubTotal as int)+cast(@Despacho as int))    
  Set @Tienda     = IsNull(@Tienda, @COD_EMP)
  Set @DireccionTienda = IsNull(@DireccionTienda,'')    
  Set @GlsDocVta   = IsNull(@GlsDocVta, '')  
  Set @SubTotal = replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, @SubTotal),1),'.00',''),',','.')    
  Set @Despacho = replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, @Despacho),1),'.00',''),',','.')    
  Set @Descuento = replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, @Descuento),1),'.00',''),',','.')    
  Set @Total = replace(REPLACE(CONVERT(VARCHAR,CONVERT(Money, @Total),1),'.00',''),',','.')  
    
    Set @HtmlDelivery = '<html>
    <head>
        <style>
      
       /* -------------------------------------   RESPONSIVE AND MOBILE FRIENDLY STYLES  ------------------------------------- */

      @media only screen and (max-width: 620px) {
        table[class=body] h1 {
          font-size: 28px !important;
          margin-bottom: 10px !important;
        }
        table[class=body] p,
        table[class=body] ul,
        table[class=body] ol,
        table[class=body] td,
        table[class=body] span,
        table[class=body] a {
            font-size: 16px !important;
        }
        table[class=body] .wrapper,
        table[class=body] .article {
          padding: 10px !important;
        }
        table[class=body] .content {
          padding: 0 !important;
        }
        table[class=body] .container {
          padding: 0 !important;
          width: 100% !important;
        }
        table[class=body] .main {
          border-left-width: 0 !important;
          border-radius: 0 !important;
          border-right-width: 0 !important;
        }
        table[class=body] .btn table {
          width: 100% !important;
        }
        table[class=body] .btn a {
          width: 100% !important;
        }
        table[class=body] .img-responsive {
          height: auto !important;
          max-width: 100% !important;
          width: auto !important;
        }
      }
  /* -------------------------------------    PRESERVE THESE STYLES IN THE HEAD    ------------------------------------- */
      
      .img {
        float: left;
      }
      .Pasos-title {
        color: #000000;
        font-weight: normal;
        font-weight: bold;
      }
    </style>
    </head>
    <body>
        <center>
            <IMG src="'+@RutaImg+'header.jpg" width="60%" HEIGHT=150>
        </center>
        <br>
        <font color ="#003c69" face="Helvetica">
            <H2>
                <CENTER>Estamos preparando tu pedido</CENTER>
            </H2>
        </font>
        <font color ="#003c69">
            <u>
                <H4>
                    <CENTER>' + @OrdenPedido + '</CENTER>
                </H4>
            </u>
        </font>
        <center>
            <p>
            <img src="'+@RutaImg+'123.jpg" align="left">
            <p style="margin: 5 50" align="justify">
            Validaremos tu pedido.         
            <br>
            <br>
            Recibirás un mail con tu boleta o factura y el detalle de la compra.
            </b>
            <br>
            <br>
            Confirmaremos por mail cuando tu compra este lista para la entrega.  
            </p>
        </center>        
        </p>
        <br>
        <br>' + @NombreCli +':
        <br>
        <br>
        <div class="Pasos-title">¡Tenemos una Buena Noticia!</div>
        <br>
        <div>
            Tu pedido está siendo preparado para ser despachado a ' + @DireccionEntrega + '.
        </div>
        <br>
        <div>
            A partir del dia ' + @FechaEntrega + ' segun el detalle de tus productos, entre las 08:30-18:30 hrs.
        </div>
        <br>
        <CENTER>
            <Table border=0 width=1000  cellspacing="0" >
                <tr bgcolor=#273746 height="30">
                    <td width=120>
                        <font color="#FFFFFF">
                            <b>Productos</b>
                        </font>
                    </td>
                    <td width=80>
                        <font color="#FFFFFF">
                            <b>Precio Unitario</b>
                        </font>
                    </td>
                <td width=80>
                    <font color="#FFFFFF">
                        <b>Cantidad</b>
                    </font>
                </td>
                <td width=80>
                    <font color="#FFFFFF">
                        <b>Precio</b>
                    </font>
                </td>
                </tr>    
                    ' + @Productos + '  
            </Table>
            </CENTER>
            <br/>
            <br/>
            <table border =0 align="RIGHT">
                <tr>
                    <td width=230 height=15>Subtotal ('+@Cant_art+' artículos)</td>
                    <td width=150> $' +@SubTotal + '</td>
                </tr>
                <tr>
                    <td width=230 height=15>
                        <b>Total a Pagar (IVA Incluido)</b>
                    </td>
                    <td width=150>
                        <b> $' + @Total + '</b>
                    </td>
                </tr>
            </table>
            <br>
            <br>
            <br>
            <br>
            <CENTER>
                <Table border=0 width=1000  cellspacing="0" >
                    <tr bgcolor=#273746 height="30">
                        <td width=120>
                            <font color="#FFFFFF">
                                <b>Detalle de Retiro</b>
                            </font>
                        </td>
                    </tr>
                </table>
            </CENTER>
            <br>
            <center>
                <table border=0 width=1000  cellspacing="0" >
                    <tr height="30">
                        <td width=60>Nombre del cliente</td>
                        <td width=180> ' + @Cliente + '</td>
                    </tr>
                    <tr>
                        <td width=60>Nombre quien recibe</td>
                        <td width=180> ' + @Cliente + '</td>
                    </tr>
                </table>
            </center>
            <br>
            <br>
            </CENTER>
            </font>
                </td>
                    </tr>
                        </table>
                            <center>
                                <IMG  src="'+@RutaImg+'footer.jpg" width="60%" HEIGHT=320>
                            </center>
                        <table width="100%" border="2" align="CENTER" cellspacing="0" style="width: 60%">
                            <tr>
                                <td>
                                    <FONT SIZE=2>
                                        <CENTER>      
                                            Este mensaje ha sido generado automáticamante por nuestros sistemas, favor no responder a este email      
                                        </CENTER>
                                    </font>
                                </td>
                            </tr>
                        </table>
                    </body>
                </html>'      
      
     Set @HtmlCollect = '    <html>      
        <head>
            <style>
            
             /* -------------------------------------   RESPONSIVE AND MOBILE FRIENDLY STYLES  ------------------------------------- */
        
      @media only screen and (max-width: 620px) {
            table[class=body] h1 {
                font-size: 28px !important;
                margin-bottom: 10px !important;
            }
            table[class=body] p,
            table[class=body] ul,
            table[class=body] ol,
            table[class=body] td,
            table[class=body] span,
            table[class=body] a {
                font-size: 16px !important;
            }
            table[class=body] .wrapper,
            table[class=body] .article {
                padding: 10px !important;
            }
            table[class=body] .content {
                padding: 0 !important;
            }
            table[class=body] .container {
                padding: 0 !important;
                width: 100% !important;
            }
            table[class=body] .main {
                border-left-width: 0 !important;
                border-radius: 0 !important;
                border-right-width: 0 !important;
            }
            table[class=body] .btn table {
                width: 100% !important;
            }
      table[class=body] .btn a {
                width: 100% !important;
            }
            table[class=body] .img-responsive {
                height: auto !important;
                max-width: 100% !important;
                width: auto !important;
            }
        }
        /* -------------------------------------    PRESERVE THESE STYLES IN THE HEAD    ------------------------------------- */
            
                .img {
                float: left;
                }
                .Pasos-title {
                color: #000000;
                font-weight: normal;
      font-weight: bold;
                }
            </style>
        </head>      
        <body>      
         <center>      
          <IMG src="'+@RutaImg+'header.jpg" width="60%" HEIGHT=150>      
         </center>      
         <br>         
         <font color ="#000000" face="Helvetica"><H2><CENTER>¡Estamos preparando tu pedido!</CENTER></H2></font>      
         <font color ="#000000"><H4><CENTER>' + @OrdenPedido + '</CENTER></H4></font>    
         
         <p> 
            <img src="'+@RutaImg+'123.png" align="left"><p style="margin: 5 50" align="justify">
            Validaremos tu pedido. 
            <br><br>
            Recibirás un mail con tu boleta o factura y el detalle de la compra.</b>      
            <br><br>
            Confirmaremos por mail cuando tu compra este lista para la entrega.  
         </p> 
        </p>
        

         <br>
         <br><b>' + @NombreCli +':</b><br> 
         <br>
         <div class="Pasos-title">¡Tenemos una Buena Noticia!</div>
         <br>
         <div>Tu pedido está siendo preparado para ser retirado en Tienda ' + @Tienda + ' ubicada en ' + @DireccionTienda + '.</div>
         <br>
     <div>A partir del dia ' + @FechaEntrega + ' segun el detalle de tus productos, de Lu-Vi 08:30-18:30 hrs Sábados 09:00-14:00 hrs.</div>
     <br>
         <div>Podrás hacerlo con el número de Boleta/Factura <b>'+ @Nro_impreso + '</b> o tu carnet de identidad.</div>
         <br>    
    <CENTER>  
           <Table border=0 width=1000  cellspacing="0" >      
            <tr bgcolor=#273746 height="30">      
             <td width=120><font color="#FFFFFF"><b>Productos</b></font></td>      
             <td width=80><font color="#FFFFFF"><b>Precio Unitario</b></font></td>      
             <td width=80><font color="#FFFFFF"><b>Cantidad</b></font></td>      
             <td width=80><font color="#FFFFFF"><b>Precio</b></font></td>      
            </tr>    
           ' + @Productos + '       
           </Table>  
    </CENTER>      
          <br/><br/>    
    <table border =0 align="RIGHT">      
           <tr>      
            <td width=230 height=15>Subtotal ('+@Cant_art+' artículos)</td>     
            <td width=150> $' +@SubTotal + '</td>     
           </tr>    
           <tr>      
            <td width=230 height=15><b>Total a Pagar (IVA Incluido)</b></td>     
            <td width=150><b> $' + @Total + '</b></td>     
           </tr>    
          </table>
          <br><br><br><br>
          <CENTER>
           <Table border=0 width=1000  cellspacing="0" >      
            <tr bgcolor=#273746 height="30">      
             <td width=120><font color="#FFFFFF"><b>Detalle de Retiro</b></font></td>    
            </tr>      
         </table> 
         </CENTER>
         <br>     
         <center>
          <table border=0 width=1000  cellspacing="0" >      
           <tr height="30">      
            <td width=60>Nombre del cliente</td>     
            <td width=180> ' + @Cliente + '</td>     
           </tr>    
          <tr>    
            <td width=60>Nombre quien retira</td>     
            <td width=180> ' + @Cliente + '</td>    
          </tr>    
          </table> 
          </center>
      <br><br>     
              </CENTER>      
             </font>      
            </td></tr>      
           </table>      
    <center>      
             <IMG  src="'+@RutaImg+'footer.jpg" width="60%" HEIGHT=320>    
            </center>
            <table width="100%" border="2" align="CENTER" cellspacing="0" style="width: 60%">      
            <tr><td>      
             <FONT SIZE=2>      
              <CENTER>      
               Este mensaje ha sido generado automáticamante por nuestros sistemas, favor no responder a este email      
              </CENTER>      
             </font>      
            </td></tr>      
           </table>  
        </body>      
       </html>'      
      
        
  ----------------------------------------------------------------------------------------------------------------------      
  ----------------------------------------------------------------------------------------------------------------------      
  ----------------------------------------------------------------------------------------------------------------------      
      
  If @tipoEntrega = 'Despacho'      
  Begin      
   Set @Mensaje  = @HtmlDelivery      
  End      
  Else      
  Begin      
   Set @Mensaje  = @HtmlCollect      
  End      
      
  Set @PatPdf  = IsNull(@PatPdf,'')      
      
  SELECT @@servername      
      
  If @@servername Like '%APOLO%'       
  Begin      
   set @To  = 'jorge.arroyo@imperial.cl;ecommerce@imperial.cl;ex.sf.egomez@imperial.cl'      
   set @From = 'jorge.arroyo@imperial.cl;ex.sf.egomez@imperial.cl'     
  End      
      
  SET @CC = @From     
    
  If @@servername Like '%8KQACOLUMBIA%'       
  BEGIN      
   set @CC = 'jorge.arroyo@imperial.cl;ecommerce@imperial.cl;ex.sf.egomez@imperial.cl'        
  END      
      
  Exec zSAV_Lib_EnviaMailEx1      
       @Area   = 'VENTAWEB',       
       @To    = @To,      
       @From   = @From,        
       @CC    = @CC,          
       @Subject  = @Subject,        
       @Attachments = @fileName,         
       @Mensaje  = @Mensaje,      
       @TipoMensaje = 'HTML',      
       @CC_Oculto  = '',      
       @Reply_To  = '',      
       @importance  = 'HIGH'      
      
   update  Sav.dbo.Sav_VT_VwDocumentoCorreo      
   set  fecha_envio = getdate(),      
     estado  = 'E',      
     PATH_PDF = @fileName      
   where nro_interno =   @NRO_DOCUMENTO_PADRE      
     and tipo_documento = @TIPO_DOCUMENTO_PADRE      
      
 END TRY      
  BEGIN CATCH      
   insert into SAV_LOG.dbo.SAV_LOG_Errores      
     (      
      Objeto      
      ,Error      
      ,Descripcion      
      ,Linea      
     )      
    values      
     (      
      ERROR_PROCEDURE()      
      ,ERROR_NUMBER()      
      ,ERROR_MESSAGE()      
      ,ERROR_LINE()      
     )             
   
  Return 0      
  
  END CATCH      
      
  --commit transaction      
  Return 1      
  
 End



