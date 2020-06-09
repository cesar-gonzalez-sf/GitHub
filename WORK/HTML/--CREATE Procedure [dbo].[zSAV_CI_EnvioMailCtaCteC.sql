--CREATE Procedure [dbo].[zSAV_CI_EnvioMailCtaCteCartolaPDF]
-------------------------------------------------------------------------  
-- Creado por  : Edgardo Gomez SF  
-- Fecha       : 23-04-2019  
-- Objetivo    : Genera Html y adjunta el pdf de la Cartola de Cuenta Corriente de clientes deudores  
-------------------------------------------------------------------------  
--(  
  declare @COD_ENTIDAD NVARCHAR(10) = '03868515'
  declare @COD_SUCURSAL NVARCHAR(3) = '001'
  declare @RUT_CLIENTE NVARCHAR(15) = '3868515-5'
--)  
--As  
Begin  
  
 BEGIN TRY  
  
 --Variables de Email  
  Declare @Mensaje   VARCHAR(max)  
  Declare @Subject   VARCHAR(100)  
  Declare @To     VARCHAR(200)  
  Declare @From    VARCHAR(500)  
  Declare @CC     VARCHAR(500)  
  Declare @fileName  Varchar(8000) 
  Declare @PatPdf   Varchar(8000)  
  Declare @Existe   int  
  Declare @HtmlCuerpo  Varchar(max)
  Declare @To_EmailCob Varchar(200)
  Declare @To_EmailCom Varchar(200)
  Declare @To_EmailDat Varchar(200)
  Declare @To_EmailFac Varchar(200)
  Declare @RutaImg Varchar(500)
    
 --Cuerpo Correo  
  Declare @Cliente    Varchar(250)  
  
  Set @HtmlCuerpo  = ''  
  Set @From    = 'credito@imperial.cl'  

  set @fileName = @RUT_CLIENTE + '.PDF'  
  
  select @PatPdf = ruta  
  from  sav.dbo.PAR_PATHPROCESOS with(nolock)  
  where sistema = 'CREDITO'  
  and CODIGO  = 'ENVIO_CARTOLA'  

  select @RutaImg = ruta 
  from sav.dbo.par_pathprocesos with(nolock)
  where sistema = 'CREDITO'
  and codigo = 'CORREO_IMG'
  
  --select @fileName = @PatPdf +'\'+ @fileName  
  
  --set @fileName = '\\apolo\TEST\PDFCartola\84439900-6.PDF'  
  
  EXEC Master.dbo.xp_fileexist @fileName , @Existe OUT  
  
  IF @Existe = 0  
  begin  
   --Return 0
   select 0
  end  
  
  ------------------------------------------------------------------------------------------------------------------  
  ------------------------------------------------------------------------------------------------------------------  
  ------------------------------------------------------------------------------------------------------------------  
  
  ------------------------------------------------------------------------------------------------------------------          
  --          Busqueda de nombre del cliente para incluir en html del cuerpo del mensaje          
  ------------------------------------------------------------------------------------------------------------------          
  
     Select top 1  
          @Cliente     = Mae.Cliente --Nombre del cliente
, @To_EmailDat = Mae.mail --Correo de "Datos Informacion"
, @To_EmailFac = Mae.CorreoFacturacion  --Correo de Facturacion
     From sav.dbo.Cli_Maestro Mae with(nolock) 
Where Mae.Cod_Entidad = @COD_ENTIDAD
And Mae.Cod_Sucursal = @COD_SUCURSAL

select top 1 
@To_EmailCob = mail --Correo de cobranza
from SAV.DBO.CLI_CONTACTOS with(nolock)
where cod_entidad = @COD_ENTIDAD
and cod_sucursal = @COD_SUCURSAL 
and cod_tipocontacto = 3 --Contacto de cobranza
and mail <> ''
order by cod_tipocontacto asc

select top 1 
@To_EmailCom = mail --Correo de Comercial
from SAV.DBO.CLI_CONTACTOS with(nolock)
where cod_entidad = @COD_ENTIDAD
and cod_sucursal = @COD_SUCURSAL 
and cod_tipocontacto = 17 --Contacto de comercial
and mail <> ''
order by cod_tipocontacto asc
 
    ------------------------------------------------------------------------------------------------------------------          
    --          Generacion Html          
    ------------------------------------------------------------------------------------------------------------------          
  
    Set @Subject   = 'Cartola Cuenta Corriente – Imperial.cl'  
Set @Cliente   = IsNull(@Cliente, '')
    Set @To_EmailDat   = IsNull(@To_EmailDat, '')
Set @To_EmailFac   = IsNull(@To_EmailFac, '')
Set @To_EmailCob   = IsNull(@To_EmailCob, '')
Set @To_EmailCom   = IsNull(@To_EmailCom, '')

    Set @HtmlCuerpo = '<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Email Imperial</title>
	<link rel="stylesheet" type="text/css" href="">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

	<style type="text/css">
		img {
			width: 45%;
			height: auto;
			margin: auto;
			display: block;
			background-repeat: no-repeat;			
		}
		p {
			width: 100%;
			height: auto;
			margin: auto;
			display: block;
		}
		.title {
			width: 45%;			
			margin: auto;
			display: block;
			padding: 0 5% 0 5%;
			box-sizing: border-box;	
			color: #5a6066;
			font-size: 18.5px;	
			font-size: 1vw;		
		}
		.portalcredito {
			position: relative;
		}
		.img2 {			
			width: 45%;
			height: auto;
			margin: auto;
			display: block;	
			background-color: red;										
		}
		.extra {
			margin: auto;
			display: block;
			width: 45%;
			height: auto;
			background-color: #465761; 			
		}
		.img4 {			
			width: 80%;
		}
		.img5 {
			width: 80%;
		}
		.img6 {
			width: 80%;
		}
		.rrss {
			margin: auto;
			display: block;
			width: 30%;
			height: auto;
			text-align: center;			
		}
		.img7 {
			width: 110%;					
		}
		.img8 {
			width: 110%;
		}
		.img9 {
			width: 110%;
		}
		.visita {
			margin: auto;
			display: block;
			width: 45%;
			height: auto;
			text-align: center;			 
		}
		.urlimprial {
			text-decoration: none;
			color: #5a6066;			
		}
		.footer {
			width: auto;
			min-width: auto;
			max-width: auto;
		}
		.textfooter {
			width: 45%;
			color: #5a6066;
			font-size: 14px;
			text-align: center;
			border-top: 1px 
			solid #aaa;
			padding-top: 10px;
			margin: auto;
			line-height: 1.25em;
			font-size: 0.8vw;
		}
		.cartola {
			text-decoration: none;
			color: #5a6066;
			font-weight: bold;
		}

	</style>
</head>
<body>
	<div> 
		<img src="https://soa-desa-iis.imperial.cl/pictures/Cartola/top2.png">
	</div>
	<!-- Saludo cliente y cartola --->	
	<div class="title">
		<p style="margin: 0 0 5px;">Estimado(a):</p>
		<p style="margin: 0;">Adjunto encontrarás tu Cartola de Cuenta Corriente.</p>
	</div>
	<div>
		<!-- img portalcredito --->
			<a target="_blank" href="https://portalcredito.imperial.cl/webcenter/portal/system/portalLogin">
				<img class="img2" src="https://soa-desa-iis.imperial.cl/pictures/Cartola/portalCredito2.png" alt="Ingresa a portalcredito.imperial.cl">				
			</a>							
	</div>
	 <!-- venta --->
	 <table border="0" cellpadding="2" class="extra">
	 	<tr>
	 		<td colspan="2">
			 	<a target="_blank" href="tel:+56223997000">
		 			<img class="img4" src="http://www.landingimperial.cl/descargas/mailing/20190516_cartola/img/venta-telefono.png" alt="Venta telefónica">
			 	</a>
	 		</td>
	 		<td>
			 	<a target="_blank" href="https://www.imperial.cl/nuestras-tiendas/product/tiendas">
	 				<img class="img5" src="http://www.landingimperial.cl/descargas/mailing/20190516_cartola/img/venta-retirotienda.png" alt="Retiro en tienda">
		 		</a>
	 		</td>
	 		<td>
			 	<a target="_blank" href="https://www.imperial.cl/">
		 			<img class="img6" src="http://www.landingimperial.cl/descargas/mailing/20190516_cartola/img/venta-compraonline.png" alt="Compra online">
			 	</a>
	 		</td>
	 	</tr>
	 </table>
	 <table border="0" cellpadding="2" class="rrss">
	 	<tr>
	 		<td>
	 			<th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th><th></th>
	 		</td>	 		
 			<td>
				<a target="_blank" href="https://www.facebook.com/ImperialElEspecialista/">
					<img class="img7" src="http://www.landingimperial.cl/descargas/mailing/20190516_cartola/img/ico-fb.png" alt="Facebook Imperial">
				</a>
 			</td>
 			<td>
 				<a target="_blank" href="https://www.instagram.com/imperial_cl/">
					<img class="img8" src="http://www.landingimperial.cl/descargas/mailing/20190516_cartola/img/ico-insta.png" alt="Instagram Imperial">
				</a>
 			</td>		 		
	 		<td>
	 			<a target="_blank" href="tel:+56223997000">
					<img class="img9" src="http://www.landingimperial.cl/descargas/mailing/20190516_cartola/img/ico-phone.png" alt="Teléfono Imperial">
				</a>				
	 		</td> 			 			 		
	 	</tr>
	 </table>
	<div class="visita">
		<a class="urlimprial" target="_blank" href="https://www.imperial.cl/">Visítanos en <b>imperial.cl</b></a>
	</div>	
	<div class="footer">
		<p class="textfooter">
			La información publicada en el estado de cuenta corriente Imperial S.A, podría sufrir variaciones. Cualquier consulta no dudes en dirigirte a la tienda más cercana o contactar a tu ejecutiva de cobranza.
			<br>
			En el caso que hayas recibido este correo por error, 
			<br>
			agradeceremos redirigirlo a 
			<a class="cartola" href="mailto:cartolactacte@imperial.cl">cartolactacte@imperial.cl</a>
		</p>
	</div>		
</body>
</html>'          
          
  ----------------------------------------------------------------------------------------------------------------------  
  ----------------------------------------------------------------------------------------------------------------------  
  ----------------------------------------------------------------------------------------------------------------------  
  
  Set @Mensaje = @HtmlCuerpo  
  
  Set @PatPdf  = IsNull(@PatPdf,'')  

  Set @To = @To_EmailCob

If (@To = '')
Begin
Set @To = @To_EmailCom
End

If (@To = '')
Begin
Set @To = @To_EmailDat
End

If (@To = '')
Begin
Set @To = @To_EmailFac
End
  
  SELECT @@servername  
  
  If @@servername Like '%APOLO%'  
  Begin  
   set @To  = 'ex.sf.egomez@imperial.cl;ex.sf.cgonzalez@imperial.cl;rubio_2990@hotmail.com'  
   set @From = 'ex.sf.egomez@imperial.cl;ex.sf.cgonzalez@imperial.cl;rubio_2990@hotmail.com'  
  End  
     --ext_soletic@imperial.cl
  SET @CC = @From  
  
  If @@servername Like '%8KQACOLUMBIA%'  
  BEGIN  
   set @CC = 'ex.sf.egomez@imperial.cl;egomez.mrcomanda@gmail.com'  
  END  
  
  Exec zSAV_Lib_EnviaMailEx1  
       @Area   = 'CREDITO',  
       @To    = @To,  
       @From   = @From,  
       @CC    = @CC,  
       @Subject  = @Subject,  
       @Attachments = '',--@fileName,  
       @Mensaje  = @Mensaje,  
       @TipoMensaje = 'HTML',  
       @CC_Oculto  = '',  
       @Reply_To  = '',  
       @importance  = 'HIGH'  
  
   update  SAV.dbo.SAV_VT_CtaCteCartolaCorreo  
   set  fecha_envio = getdate(),  
     estado  = 'E',  
     PATH_PDF = @fileName  
   where COD_ENTIDAD  = @COD_ENTIDAD  
     and COD_SUCURSAL = @COD_SUCURSAL  
  
 END TRY  
  BEGIN CATCH  
          
   --insert into SAV_LOG.dbo.SAV_LOG_Errores  
   --  (  
   --   Objeto  
   --   ,Error  
 --,Descripcion  
   --   ,Linea  
   --  )  
   -- values  
   --  (  
   --   ERROR_PROCEDURE()  
   --   ,ERROR_NUMBER()  
   --   ,ERROR_MESSAGE()  
   --   ,ERROR_LINE()  
   --  )  

  select
      ERROR_PROCEDURE()  
      ,ERROR_NUMBER()  
      ,ERROR_MESSAGE()  
      ,ERROR_LINE()   

 --Return 0  
 select 0
  
  END CATCH  
  
  --commit transaction  
 --Return 1  
 select 1
  
 End

