
DECLARE @NRO_OPTMIZ_ID INT = 459
      
Begin        
        
 BEGIN TRY        

  DECLARE @Mensaje		VARCHAR(max)              
  DECLARE @Html			Varchar(MAX)
  DECLARE @GlsFecha		Varchar(50)
  DECLARE @From			VARCHAR(500) 
  DECLARE @Subject		VARCHAR(100)
  DECLARE @To			VARCHAR(200)
  DECLARE @CC			VARCHAR(500) 
  DECLARE @NOMBRE_CLI	VARCHAR(50)
  DECLARE @RUT_CLI		VARCHAR(50)
  DECLARE @EMAIL_CLI	VARCHAR(50)
  DECLARE @TELEFONO_CLI	VARCHAR(50)
  DECLARE @TABLERO_CLI	VARCHAR(50)
  DECLARE @ORDEN_PEDIDO VARCHAR(50)
  DECLARE @PLANO_CLI	VARCHAR(50)
  DECLARE @CANT_PLACAS	VARCHAR(50)
                      
      
  SET @Html  = ''                
  SET @GlsFecha   = 'Fecha de entrega'        
	Select @From = RTRIM(LTRIM(CP.Correo))
	From SAV.dbo.Par_CorreoPerfil CP WITH(NOLOCK)
	Where CP.Perfil = 'SYSTEM'	
           
               
    ------------------------------------------------------------------------------------------------------------------        
    --          Busqueda datos       
    ------------------------------------------------------------------------------------------------------------------        

	SELECT 
	  @ORDEN_PEDIDO	= DIM.OPTMIZ_ID
	, @RUT_CLI		= CLI.OPTMIZ_RUT
	, @NOMBRE_CLI	= CLI.OPTMIZ_NOMBRE
	, @EMAIL_CLI	= CLI.OPTMIZ_EMAIL
	, @TELEFONO_CLI	= CLI.OPTMIZ_TELEFONO
	, @TABLERO_CLI	= DAT.descripcion
	, @PLANO_CLI	= ISNULL(LEP.url_planos ,'')
	, @CANT_PLACAS	= ISNULL(LEP.cant_placas,'-')
	FROM SAV.dbo.LEPTON$DIMENSIONES_CAB DIM with(nolock)
	INNER JOIN SAV.dbo.LEPTON$CLIENTES CLI with(nolock) ON DIM.CLIENTE_OPTMIZ_ID = CLI.OPTMIZ_ID
	INNER JOIN SAV.dbo.LEPTON$PRODUCTOS_TEMP DAT with(nolock) ON DIM.OPTMIZ_SKU = DAT.COD_RAPIDO
	LEFT JOIN SAV_LEPTON.dbo.lepton_optimizaciones LEP with(nolock) ON DIM.OPTMIZ_ID = LEP.optimizacion_id
	WHERE DIM.OPTMIZ_ID = @NRO_OPTMIZ_ID
               
   


    SET @Subject	= 'Estamos preparando tu Optimización – Imperial.cl'        
    SET @ORDEN_PEDIDO	= ISNULL(@ORDEN_PEDIDO, '')             
	SET @NOMBRE_CLI	= ISNULL(@NOMBRE_CLI, '')       


	------------------------------------------------------------------------------------------------------------------        
    --          Busqueda datos a detalles de la optimizacion       
    ------------------------------------------------------------------------------------------------------------------ 

	 DECLARE @REF_PLA			INT
	 DECLARE @PIEZAS_PLA		INT
	 DECLARE @NOM_PIEZ_PLA		NVARCHAR(MAX)
	 DECLARE @LARGO_PLA			INT
	 DECLARE @ANCHO_PLA			INT
	 DECLARE @VETA_PLA			INT 
	 DECLARE @VETA_SUP_PLA		INT
	 DECLARE @VETA_INF_PLA		INT
	 DECLARE @VETA_IZQ_PLA		INT
	 DECLARE @VETA_DER_PLA		INT	


	 DECLARE @HTML2		NVARCHAR(MAX) = ''
	 DECLARE @Nro		INT = 0
	 
	-- Declaramos Cursor
	DECLARE InitCursor CURSOR FOR 
		SELECT OPTIMIZ_ID, OPTIMIZ_CANTIDAD, OPTIMIZ_NOMBRE_PIEZA, OPTIMIZ_LARGO, OPTIMIZ_ANCHO, OPTIMIZ_VETA, OPTIMIZ_T1, OPTIMIZ_T2, OPTIMIZ_T3, OPTIMIZ_T4 FROM SAV.dbo.LEPTON$DIMENSIONES_DETALLE WHERE DIMENSIONES_CAB_OPTIMIZ_ID = @NRO_OPTMIZ_ID
	OPEN InitCursor
		FETCH NEXT FROM InitCursor INTO @REF_PLA, @PIEZAS_PLA, @NOM_PIEZ_PLA, @LARGO_PLA, @ANCHO_PLA, @VETA_PLA, @VETA_SUP_PLA, @VETA_INF_PLA, @VETA_IZQ_PLA, @VETA_DER_PLA
		WHILE @@fetch_status = 0
		BEGIN
			SET @Nro = @Nro +1
			SET @HTML2 = @HTML2 +'<tr class="align-center">
				<td>'+ CAST(@Nro AS NVARCHAR(11))  +'</td>
				<td>'+ CAST(@PIEZAS_PLA  AS NVARCHAR(11)) +'</td>
				<td>'+ @NOM_PIEZ_PLA +'</td>
				<td>'+ CASE WHEN @ANCHO_PLA <= 0 THEN '-' ELSE CAST(@ANCHO_PLA AS NVARCHAR(11)) END  +' mm</td>
				<td>'+ CASE WHEN @LARGO_PLA <= 0 THEN '-' ELSE CAST(@LARGO_PLA AS NVARCHAR(11)) END  +' mm</td>				
				<td>'+ CASE WHEN @VETA_PLA = 1 THEN 'SI' ELSE '-' END  +'</td>
				<td>'+ CASE WHEN @VETA_SUP_PLA = 1 THEN 'SI' ELSE '-' END  +'</td>
				<td>'+ CASE WHEN @VETA_INF_PLA = 1 THEN 'SI' ELSE '-' END  +'</td>
				<td>'+ CASE WHEN @VETA_IZQ_PLA = 1 THEN 'SI' ELSE '-' END  +'</td>
				<td>'+ CASE WHEN @VETA_DER_PLA = 1 THEN 'SI' ELSE '-' END  +'</td>
			</tr>'
			FETCH NEXT FROM InitCursor INTO @REF_PLA, @PIEZAS_PLA, @NOM_PIEZ_PLA, @LARGO_PLA, @ANCHO_PLA, @VETA_PLA, @VETA_SUP_PLA, @VETA_INF_PLA, @VETA_IZQ_PLA, @VETA_DER_PLA
		END
	CLOSE InitCursor
	DEALLOCATE InitCursor

      
    SET @Html = '<!doctype html>
<html>

<head>
    <meta name="viewport" content="width=device-width" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Nuevo proyecto de optimización</title>
    <style>
        /* -------------------------------------              GLOBAL RESETS          ------------------------------------- */
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
        
        table td {
            font-family: sans-serif;
            font-size: 14px;
            vertical-align: top;
        }
        /* -------------------------------------              BODY & CONTAINER          ------------------------------------- */
        
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
        /* -------------------------------------              HEADER, FOOTER, MAIN          ------------------------------------- */
        
        .main {
            background: #ffffff;
            border-radius: 3px;
            width: 100%;
        }
        
        .wrapper {
            box-sizing: border-box;
            padding: 20px;
        }
        
        .content-block {
            padding-bottom: 10px;
            padding-top: 10px;
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
            color: #ffffff;
        }
        
        .MAIL {
            background: #ffffff;
            border-radius: 3px;
            height: 20;
        }
        /* -------------------------------------              TYPOGRAPHY          ------------------------------------- */
        
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
        /* -------------------------------------              OTHER STYLES THAT MIGHT BE USEFUL          ------------------------------------- */
        
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
        /* -------------------------------------              RESPONSIVE AND MOBILE FRIENDLY STYLES          ------------------------------------- */
        
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
        /* -------------------------------------              PRESERVE THESE STYLES IN THE HEAD          ------------------------------------- */
        
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
            .box-label {
                color: #003c69;
                font-weight: 600;
            }
            .panel-selected {
                margin-bottom: 0;
                color: #333336;
                text-align: left;
                font-weight: bold;
            }
            .new-optimization-title {
                color: #003c69;
                font-family: Roboto;
                font-size: 20px;
                font-weight: normal;
                font-style: normal;
                font-stretch: normal;
                line-height: normal;
                letter-spacing: 0.3px;
                margin-top: 20px;
            }
            .v-align-center {
                vertical-align: middle;
            }
            .v-align-center img {
                vertical-align: middle;
            }
                    .button {
            border-radius: 12px;
            background-color: #003c69;
            color: #ffffff;
            }
        }
    </style>
</head>

<body class="">
    <table role="presentation" border="0" cellpadding="0" cellspacing="0" class="body">
        <tr>
            <td>&nbsp;</td>
            <td class="container">
                <div class="content">
                    <!-- START CENTERED WHITE CONTAINER -->
                    <table role="presentation" class="main">
                        <!-- START MAIN CONTENT AREA -->
                        <tr>
                            <td class="wrapper">
                                <table role="presentation" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <img src="http://soa-iis.imperial.cl/pictures/logo.jpg" alt="ImperialImage">
                                            <h1 class="new-optimization-title">¡Hola '+ @NOMBRE_CLI +'!</h1>
                                            <p class="new-optimization-title">Este es el detalle de tu Optimización <b>N° ' + @ORDEN_PEDIDO + '</b>.
                                                <button class="button" >DESCARGAR PDF</button>
                                            </p>
                                            <p class="new-optimization-title"><b>'+ @NOMBRE_CLI +'</b> al momento de estar en tienda muestre el <b>N° de Optimización</b> al Vendedor.</p>
                                            <table role="presentation" class="box-border mb-10" border="0" cellpadding="0" cellspacing="0">
                                                <tbody>
                                                    <tr>
                                                        <td width="50%">
                                                            <table role="presentation" class="box-r-border p-10">
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <p class="box-label">Datos del cliente</p>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>'+ @NOMBRE_CLI +'</td>
                                                                    <td>'+ @EMAIL_CLI +'</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>RUT: '+ @RUT_CLI +'</td>
                                                                    <td>'+ @TELEFONO_CLI +'</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width="50%">
                                                            <table role="presentation" class="box-r-border p-10">
                                                                <tr>
                                                                    <td>
                                                                        <p class="box-label">Tablero seleccionado</p>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <h3 class="panel-selected">'+ @TABLERO_CLI +'</h3>
                                                                        <br>
                                                                        <p class="box-label">Cantidad de Tableros Optimizados: '+ @CANT_PLACAS +'</p>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <table role="presentation" class="box-border p-10">
                                                <tr>
                                                    <td>
                                                        <p class="box-label">Dimensiones de Piezas</p>
                                                        <table role="presentation" class="box-border table-rows-colors" border="0" cellpadding="5" cellspacing="0">
                                                            <thead>
                                                                <tr class="table-header">
                                                                    <th></th>
                                                                    <th></th>
                                                                    <th></th>
                                                                    <th></th>
                                                                    <th></th>
                                                                    <th></th>
                                                                    <th colspan="4" class="box-l-border">Tapacantos</th>
                                                                </tr>
                                                                <tr class="box-b-border table-header">
                                                                    <th>No.</th>
                                                                    <th>Cant. Piezas</th>
                                                                    <th>Nombre Pieza</th>
                                                                    <th>Largo</th>
                                                                    <th>Ancho</th>
                                                                    <th>Veta</th>
                                                                    <th class="v-align-center"> <img height="15" src="https://soa-desa-iis.imperial.cl/optimizador-app/assets/images/tapacantos/top.png" alt="tapacantosTop" /> Sup </th>
                                                                    <th class="box-l-border v-align-center"> <img height="15" src="https://soa-desa-iis.imperial.cl/optimizador-app/assets/images/tapacantos/bottom.png" alt="tapacantosBotton" /> Inf </th>
                                                                    <th class="v-align-center"> <img height="15" src="https://soa-desa-iis.imperial.cl/optimizador-app/assets/images/tapacantos/left.png" alt="tapacantosLeft" /> Izq </th>
                                                                    <th class="v-align-center"> <img height="15" src="https://soa-desa-iis.imperial.cl/optimizador-app/assets/images/tapacantos/right.png" alt="tapacantosRight" /> Der </th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                '+ @HTML2 +'
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <!-- END MAIN CONTENT AREA -->
                    </table>
                    <!-- END CENTERED WHITE CONTAINER -->
                    <!-- START FOOTER -->
                    <table role="presentation" class="footer">
                        <tr>
                            <td align="center">
                                <p style="color: #003c69; font-weight: 600;">Descarga Nuestra APP</p>
                                <a style="text-decoration: none;" href="https://play.google.com/store/apps/details?id=cl.imperial.app&hl=es">
                                    <img style="vertical-align:middle" src="https://ci3.googleusercontent.com/proxy/A4cGq2mesKkJ1HQ1eOL54jbMzpKFUphXcRZQdENwdkN8wardKne12RcJmHPf5xpm6fYGhvbB5K-Z_V8UlhN2XR8DvRGM0e4m1rQSw1TcBC0HXiPaGQs_uP_8yAhCupU5wkH0HlCNQJOx1-BSsw=s0-d-e1-ft#http://main.cdn.wish.com/latest/img/mobile_download_page/banner_google_equal.png?v=62cb513" class="CToWUd" width="100" height="30">
                                </a>
                                <a style="text-decoration: none;" href="https://apps.apple.com/cl/app/imperial-app/id1131355568">
                                    <img style="vertical-align:middle" src="https://ci4.googleusercontent.com/proxy/zWXDNvTkM_A4CG4us1M_9XGytK0-sLs_b2fKZ9SUXjrsrWhYhR0OSmFEUJgWJva2-fJXlN0SX_bX-gdZNQCQKjc8Ovb3AHXtcufH2mho62DUH-0a7NBhnohX87jJ3iAtKfLmvUU7bRD6bsut=s0-d-e1-ft#http://main.cdn.wish.com/latest/img/mobile_download_page/banner_apple_equal.png?v=61ed113" class="CToWUd" width="100" height="30">
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
                </div>
            </td>
            <td>&nbsp;</td>
        </tr>
    </table>
</body>

</html>'       
        
  ----------------------------------------------------------------------------------------------------------------------        
  ----------------------------------------------------------------------------------------------------------------------        
  ----------------------------------------------------------------------------------------------------------------------        
        
Set @Mensaje  = @Html  
  --Set @PatPdf  = IsNull(@PatPdf,'')  
  
    SELECT @@servername        
  
  If @@servername Like '%APOLO%'         
  Begin        
   set @To  = 'ex.sf.cgonzalez@imperial.cl'        
   set @From = 'ex.sf.cgonzalez@imperial.cl'     
  End        
        
  SET @CC = @From       
      
  If @@servername Like '%8KQACOLUMBIA%'         
  BEGIN        
   set @CC = 'ex.sf.cgonzalez@imperial.cl'      
  END   
     	

  Exec zSAV_Lib_EnviaMailEx1        
       @Area   = 'VENTAWEB',         
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
    
 END TRY        
  BEGIN CATCH        
        
  select       
      ERROR_PROCEDURE()        
      ,ERROR_NUMBER()        
      ,ERROR_MESSAGE()        
      ,ERROR_LINE()        
                     
  
  SELECT 0 
    
  END CATCH        
        
  SELECT 1    
    
 End 


