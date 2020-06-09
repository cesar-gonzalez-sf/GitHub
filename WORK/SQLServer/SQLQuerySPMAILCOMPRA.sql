
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER PROCEDURE [dbo].[zSAV_Mail_CompraAPP]
-------------------------------------------------------------------------      
-- Modificado por : C�sar Gonz�lez-Rubio   
-- Fecha		  : 11-06-2019      
-- Objetivo       : Genera Html con formato de envio de correos
------------------------------------------------------------------------- 
(
	 @NRO_DOCUMENTO_PADRE INT
)
AS
BEGIN        
        
 BEGIN TRY        

  DECLARE @Mensaje		VARCHAR(max)              
  DECLARE @tipoEntrega  VARCHAR(30) 
  DECLARE @NombreCli	VARCHAR(250)
  DECLARE @OrdenPedido  VARCHAR(50)
  DECLARE @NroInternoP  INT 
  DECLARE @FLETE		VARCHAR(50)  
  DECLARE @TipoDoc		VARCHAR(5) 
  DECLARE @Html			VARCHAR(MAX)
  DECLARE @GlsFecha		VARCHAR(50)
  DECLARE @From			VARCHAR(500) 
  DECLARE @Subject		VARCHAR(100)
  DECLARE @To			VARCHAR(200)
  DECLARE @CC			VARCHAR(500)                     
      
  SET @Html		  = ''                
  SET @GlsFecha   = 'Fecha de entrega'        
  SET @From		  = 'facturacion@imperial.cl'
           
               
    ------------------------------------------------------------------------------------------------------------------        
    --          Busqueda datos       
    ------------------------------------------------------------------------------------------------------------------        
         
        
     SELECT TOP 1         
          @OrdenPedido    = tra.Nro_Interno              
		, @TipoDoc		  = tra.Tipo_Documento                  
		, @NombreCli	  = Mae.Nombre      
		, @tipoEntrega    = CASE tra.Flete WHEN 'S' THEN 'Despacho' ELSE 'Entregado' END          		      		                                                  
		FROM sav_vt.dbo.sav_vt_TraCab tra WITH(NOLOCK)        
			INNER JOIN sav.dbo.Cli_Maestro Mae WITH(NOLOCK) ON  tra.Cod_Entidad  = Mae.Cod_Entidad  AND tra.Cod_Sucursal  = Mae.Cod_Sucursal                  
				WHERE tra.Nro_Interno = @NRO_DOCUMENTO_PADRE  
	               
        
    ------------------------------------------------------------------------------------------------------------------        
    --          Generacion Html        
    ------------------------------------------------------------------------------------------------------------------        
    SET @FLETE = 'El Despacho'   
    IF @tipoEntrega <> 'Despacho'        
    BEGIN        
		SET @FLETE = 'La Entrega'       
    END        
        
    SET @Subject		= 'Estamos preparando tu pedido � Imperial.cl'        
    SET @OrdenPedido	= IsNull(@OrdenPedido, '')             
	SET @NombreCli		= IsNull(@NombreCli, '') 
	SET @FLETE			= ISNULL(@FLETE,'')          
      
    SET @Html = '
	<!doctype html>
<html>

<head>
    <meta name="viewport" content="width=device-width" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Nuevo proyecto de compra</title>

    <style>
        /* -------------------------------------    GLOBAL RESETS     ------------------------------------- */
        /*All the styling goes here*/
        
        img {
            border: none;
            -ms-interpolation-mode: bicubic;
            max-width: 100%;
        }
        
        body {
            background-color: #f6f6f6;
            font-family: sans-serif;
            -webkit-font-smoothing: antialiased;
            font-size: 14px;
            line-height: 1.4;
            margin: 0;
            padding: 0;
            -ms-text-size-adjust: 100%;
            -webkit-text-size-adjust: 100%;
        }
        
        table {
            border-collapse: separate;
            mso-table-lspace: 0pt;
            mso-table-rspace: 0pt;
            width: 100%;
        }
        /* -------------------------------------       BODY & CONTAINER        ------------------------------------- */
        
        .body {
            background-color: #f6f6f6;
            width: 100%;
        }
        /* Set a max-width, and make it display as block so it will automatically stretch to that width, but will also shrink down on a phone or something */
        
        .container {
            display: block;
            margin: 0 auto !important;
            /* makes it centered */
            padding: 10px;
        }
        /* This should also be a block element, so that it will fill 100% of the .container */
        
        .content {
            box-sizing: border-box;
            display: block;
            margin: 0 auto;
            padding: 10px;
        }
        /* -------------------------------------  HEADER, FOOTER, MAIN   ------------------------------------- */
        
        .main {
            background: #ffffff;
            border-radius: 3px;
            width: 100%;
        }
        
        .wrapper {
            box-sizing: border-box;
            padding: 20px;
        }
        
        .footer {
            clear: both;
            background: white;
            width: 100%;
            padding: 0 20px;
        }
        
        .footer .footer-content {
            padding: 10px;
            background: #12507f;
        }
        
        .footer .footer-content .phone-contact {
            font-family: Roboto;
            font-size: 11px;
            font-weight: 500;
            font-style: normal;
            font-stretch: normal;
            line-height: normal;
            letter-spacing: 0.1px;
            color: white;
            padding-left: 10px;
            vertical-align: middle;
        }
        
        .footer .footer-content .phone-contact img {
            vertical-align: middle;
            margin: 0 5px;
        }
        
        .footer .footer-content .phone-contact .phone {
            font-family: Roboto;
            font-size: 16px;
            font-weight: bold;
            font-style: normal;
            font-stretch: normal;
            line-height: normal;
            letter-spacing: 0.2px;
        }

        .MAIL {
            background: #ffffff;
            border-radius: 3px;
            height: 20;
        }
        /* -------------------------------------     TYPOGRAPHY     ------------------------------------- */
        
        h1,
        h2,
        h3,
        h4 {
            color: #000000;
            font-family: sans-serif;
            font-weight: 400;
            line-height: 1.4;
            margin: 0;
            margin-bottom: 30px;
        }
        
        h1 {
            font-size: 35px;
            text-transform: capitalize;
        }
        
        p,
        ul,
        ol {
            font-family: sans-serif;
            font-size: 14px;
            font-weight: normal;
            margin: 0;
            margin-bottom: 15px;
        }
        
        p li,
        ul li,
        ol li {
            list-style-position: inside;
            margin-left: 5px;
        }
        
        a {
            color: #3498db;
            text-decoration: underline;
        }
        /* -------------------------------------   OTHER STYLES THAT MIGHT BE USEFUL   ------------------------------------- */
        
        .last {
            margin-bottom: 0;
        }
        
        .first {
            margin-top: 0;
        }
        
        .align-center,
        tr.align-center td {
            text-align: center;
        }
        
        .align-right {
            text-align: right;
        }
        
        .align-left {
            text-align: left;
        }
        
        .clear {
            clear: both;
        }
        
        .mt0 {
            margin-top: 0;
        }
        
        .mb0 {
            margin-bottom: 0;
        }
        
        .preheader {
            color: transparent;
            display: none;
            height: 0;
            max-height: 0;
            max-width: 0;
            opacity: 0;
            overflow: hidden;
            mso-hide: all;
            visibility: hidden;
            width: 0;
        }
        
        .powered-by a {
            text-decoration: none;
        }
        
        hr {
            border: 0;
            border-bottom: 1px solid #f6f6f6;
            margin: 20px 0;
        }
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
        
        @media all {
            .ExternalClass {
                width: 100%;
            }
            .ExternalClass,
            .ExternalClass p,
            .ExternalClass span,
            .ExternalClass font,
            .ExternalClass td,
            .ExternalClass div {
                line-height: 100%;
            }
            .apple-link a {
                color: inherit !important;
                font-family: inherit !important;
                font-size: inherit !important;
                font-weight: inherit !important;
                line-height: inherit !important;
                text-decoration: none !important;
            }
            .box-border {
                border: 1px solid #dfdddd;
            }
            .box-l-border {
                border-left: 1px solid #dfdddd;
            }
            .box-r-border {
                border-right: 1px solid #dfdddd;
            }
            .box-t-border {
                border-top: 1px solid #dfdddd;
            }
            .box-b-border,
            .box-b-border th,
            .box-b-border td {
                border-bottom: 1px solid #dfdddd;
            }
            .table-header th {
                font-size: 14px;
                color: #333336;
                font-weight: bold;
            }
            .table-rows-colors tbody tr:nth-child(even) {
                background: #f8f8f8;
            }
            .table-rows-colors tbody td {
                padding: 10px 0;
            }
            .mb-10 {
                margin-bottom: 10px;
            }
            .mt-10 {
                margin-top: 10px;
            }
            .ml-10 {
                margin-left: 10px;
            }
            .mr-10 {
                margin-right: 10px;
            }
            .pb-10 {
                padding-bottom: 10px;
            }
            .pt-10 {
                padding-top: 10px;
            }
            .pl-10 {
                padding-left: 10px;
            }
            .pr-10 {
                padding-right: 10px;
            }
            .p-0 {
                padding: 0;
            }
            .p-10 {
                padding: 10px;
            }
            .NumeroCodigo-title {
                color: #003c69;
                font-family: Roboto;
                font-size: 20px;
                font-weight: normal;
                font-style: normal;
                font-stretch: normal;
                line-height: normal;
                letter-spacing: 0.3px;
                margin-top: 20px;
                text-align: center;
            }
            .Cliente-title {
                color: #003c69;
                font-weight: 600;
            }
            .Pasos-title {
                color: #003c69;
                font-weight: 600;
            }
            .Pasos1-texto {
                margin-left: 30px;
            }
            .Pasos2-texto {
                margin-left: 30px;
            }
            .Pasos3-texto {
                margin-left: 30px;
            }
            .v-align-center {
                vertical-align: middle;
            }
            .v-align-center img {
                vertical-align: middle;
            }
        }
    </style>
</head>

<body class="">
    <table role="test" border="0" cellpadding="0" cellspacing="0" class="body">
        <td>&nbsp;</td>
        <td class="contaniner">
            <div class="content">
                <!-- START CENTERED WHITE CONTAINER -->
                <table role="test" class="main">
                    <!-- START MAIN CONTENT AREA -->
                    <tr>
                        <td class="wrapper">
                            <table role="test" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td><img src="http://soa-iis.imperial.cl/pictures/logo.jpg" alt="ImperialImage">
                                        <h2 class="NumeroCodigo-title">N� de Compra ' + @OrdenPedido + '</h2>
                                        <h3 class="Cliente-title">�Hola '+ @NombreCli +'!</h3>
                                        <p class="Informacion-title">Te informamos que tu pedido se encuentra en proceso de validaci�n.</p>
                                        <br><b>Pasos a Seguir:</b>
                                        <ol type="1">
                                            <li> Validaremos tu pedido.</li>
                                            <li> Recibir un correo electr�nico con tu boleta o factura y el detalle de la compra.</li>
                                            <li> Confirmar por correo cuando est� comprando esta lista para la '+ @FLETE +'.</li>
                                        </ol>
                                        <br>
                                        <p class="Seguimieinto-parrafo">Para hacer un seguimiento a tu compra, solo debes hacer clic en el "<a href="https://www.imperial.cl/tracking" target="Blank_"><font color = "blue"><u>Seguimiento de Pedidos</u></font></a>" digita el n�mero de documento (Boleta o Factura).</p>
                                        <p class="Dudas-parrafo">Si tienes una duda respecto a las condiciones de despacho, por favor revisa los "
                                            <a href="https://www.imperial.cl/t%C3%A9rminos-y-condiciones-informaci%C3%B3n-general/product/terminos_y_condiciones" target="Blank_">
                                                <font color="blue"><u>T�rminos y condiciones</u></font></a>". De cualquier inconveniente o retraso en la validaci�n de los datos o la emisi�n de la boleta, a trav�s de un correo electr�nico.</p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <!-- END MAIN CONTENT AREA -->
                    <!-- END CENTERED WHITE CONTAINER -->
                    <!-- START FOOTER -->
                    <table role="presentation" class="footer">
                        <tr>
                            <td align="center">
                                <p style="color: #003c69; font-weight: 600;">Descarga Nuestra APP</p>
                                <a style="text-decoration: none;" href="https://play.google.com/store/apps/details?id=cl.imperial.app&hl=es">
                                    <img style="vertical-align:middle" src="https://ci3.googleusercontent.com/proxy/A4cGq2mesKkJ1HQ1eOL54jbMzpKFUphXcRZQdENwdkN8wardKne12RcJmHPf5xpm6fYGhvbB5K-Z_V8UlhN2XR8DvRGM0e4m1rQSw1TcBC0HXiPaGQs_uP_8yAhCupU5wkH0HlCNQJOx1-BSsw=s0-d-e1-ft#http://main.cdn.wish.com/latest/img/mobile_download_page/banner_google_equal.png?v=62cb513" target="Blank_" width="100" height="30">
                                </a>
                                <a style="text-decoration: none;" href="https://apps.apple.com/cl/app/imperial-app/id1131355568">
                                    <img style="vertical-align:middle" src="https://ci4.googleusercontent.com/proxy/zWXDNvTkM_A4CG4us1M_9XGytK0-sLs_b2fKZ9SUXjrsrWhYhR0OSmFEUJgWJva2-fJXlN0SX_bX-gdZNQCQKjc8Ovb3AHXtcufH2mho62DUH-0a7NBhnohX87jJ3iAtKfLmvUU7bRD6bsut=s0-d-e1-ft#http://main.cdn.wish.com/latest/img/mobile_download_page/banner_apple_equal.png?v=61ed113" target="Blank_" width="100" height="30">
                                </a>
                                <br>
                                <br>
                                <table role="presentation" class="footer-content" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="phone-contact"> CALL CENTER <img height="20" src="https://soa-desa-iis.imperial.cl/optimizador-app/assets/images/phone.png" alt="phoneImage" /> <span class="phone">(562) 2399 700</span>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp; MAIL <img height="30" src="https://soa-desa-iis.imperial.cl/RsAppImperial/images/gmail.png  "><b class="MAIL">contacto@imperial.cl</b> </td>
                                        <td class="phone-contact align-right"> SIGUENOS EN
                                            <a style="text-decoration: none;" href="https://www.facebook.com/ImperialElEspecialista/">
                                                <img height="28" src="https://soa-desa-iis.imperial.cl/optimizador-app/assets/images/facebook.png" alt="facebookImage" />    
                                            </a>
                                            <a style="text-decoration: none;" href="https://instagram.com/imperial_cl?igshid=13yshbnwpb47w">
                                                 <img height="28" src="https://soa-desa-iis.imperial.cl/optimizador-app/assets/images/instagram.png" alt="instagramImage" />
                                            </a>
                                         </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <!-- END FOOTER -->
                </table>
            </div>
        </td>
    </table>
</body>

</html>
	'       
        
  ----------------------------------------------------------------------------------------------------------------------        
  ----------------------------------------------------------------------------------------------------------------------        
  ----------------------------------------------------------------------------------------------------------------------        
        
SET @Mensaje  = @Html  
  --Set @PatPdf  = IsNull(@PatPdf,'')        
        
  SELECT @@servername        
        
  IF @@servername Like '%APOLO%'         
  BEGIN        
   SET @To		= 'ex.sf.cgonzalez@imperial.cl'        
   SET @From	= 'ex.sf.cgonzalez@imperial.cl'     
  End        
        
  SET @CC = @From       
      
  If @@servername Like '%8KQACOLUMBIA%'         
  BEGIN        
   SET @CC = 'ex.sf.cgonzalez@imperial.cl'      
  END        
        
          
        
  EXEC zSAV_Lib_EnviaMailEx1        
       @Area			= 'VENTAWEB',         
       @To				= @To,        
       @From			= @From,          
       @CC				= @CC,            
       @Subject			= @Subject,          
       @Attachments		= '',--@fileName,           
       @Mensaje			= @Mensaje,        
       @TipoMensaje		= 'HTML',        
       @CC_Oculto		= '',        
       @Reply_To		= '',        
       @importance		= 'HIGH'           
    
 END TRY        
  BEGIN CATCH        
        
   INSERT INTO SAV_LOG.dbo.SAV_LOG_Errores        
     (        
       Objeto        
      ,Error        
      ,Descripcion        
      ,Linea        
     )        
    VALUES        
     (        
      ERROR_PROCEDURE()        
      ,ERROR_NUMBER()        
      ,ERROR_MESSAGE()        
      ,ERROR_LINE()        
     )                     
  
  RETURN        
    
  END CATCH        
               
  RETURN        
    
 END                
        
-----------   EJECUTAR   --------------------------------------------------------

--[dbo].[zSAV_Mail_CompraAPP] 19563073 

----------- ABRIR ---------

 --sp_helptext zSAV_Mail_CompraAPP
        
        
        
        
        
        
  
  
  