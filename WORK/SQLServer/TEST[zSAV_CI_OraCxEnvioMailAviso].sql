--ALTER Procedure [dbo].[zSAV_CI_OraCxEnvioMailAviso]
-- Modificado por	: Manuel Aguillon Reyes
-- Fecha			: 23-01-2018
-- Objetivo			: Ubica un pck en una location
-- M.A 20180209		: Se modifica envió de correo a nuevo formato solicitado por el area de venta
-- M.A 20180616
--(
--	  @NRO_DOCUMENTO_PADRE INT,
--	  @TIPO_DOCUMENTO_PADRE VARCHAR(3)
--)
DECLARE 
	  @NRO_DOCUMENTO_PADRE INT = 7540705,
	  @TIPO_DOCUMENTO_PADRE VARCHAR(3) = 'BLV'
	--As
	Begin
	BEGIN TRY

		declare 
				@Mensaje	VARCHAR(max),
				@Subject	VARCHAR(50),
				@CLIENTE	VARCHAR(50),
				@TIPO_DOCUMENTO		varchar(3),
				@Nro_Impreso		VARCHAR(10),
				@COD_RAPIDO	INT,
				@DESC_LARGA  VARCHAR(200),
				@Cantidad	DECIMAL(18,4),
				@To VARCHAR(200),
				@From VARCHAR(500),
				@CC	  VARCHAR(500),
				@IMG_1 VARCHAR(500),
				@IMG_2 VARCHAR(500),
				@IMG_3 VARCHAR(500),
				@COD_EMP VARCHAR(20),
				@COD_ENTIDAD VARCHAR(10),
				@COD_SUCURSAL VARCHAR(3),
				@Tienda		  VARCHAR(750),
				@RutaImg Varchar(500)


		--select @NRO_DOCUMENTO_PADRE = NRO_DOCUMENTO_PADRE,
		--	   @TIPO_DOCUMENTO_PADRE = TIPO_DOCUMENTO_PADRE,
		--	   @COD_EMP = COD_EMP
		--from sav.dbo.sav_ci_picking  with(nolock)
		--where nro_picking = @NROPICKING
		  select @RutaImg = ruta 
  from sav.dbo.par_pathprocesos with(nolock)
  where sistema = 'VENTA_WEB'
  and codigo = 'CORREO_VW_ORACLE' 


		if	@TIPO_DOCUMENTO_PADRE not in ('BLV','FCV')
		begin
			--return 0 
			SELECT 0
		end 		

		if @TIPO_DOCUMENTO_PADRE = 'BLV'
		begin
			select @Nro_Impreso = nro_impreso,
				   @COD_ENTIDAD = Cod_Entidad,
				   @COD_SUCURSAL= COD_SUCURSAL,
				   @COD_EMP		= COD_EMP
			from sav_vt.dbo.sav_vt_blvcab with(nolock)
			where Tipo_Documento = @TIPO_DOCUMENTO_PADRE
			and	  Nro_Interno	 = @NRO_DOCUMENTO_PADRE
		end 
		if @TIPO_DOCUMENTO_PADRE = 'FCV'
		begin
			select @Nro_Impreso = nro_impreso,
				   @COD_ENTIDAD = Cod_Entidad,
				   @COD_SUCURSAL= COD_SUCURSAL,
				   @COD_EMP		= COD_EMP
			from sav_vt.dbo.sav_vt_FCVcab with(nolock)
			where Tipo_Documento = @TIPO_DOCUMENTO_PADRE
			and	  Nro_Interno	 = @NRO_DOCUMENTO_PADRE
		end 

		select @CLIENTE = nombre,
			   @To  = MailWeb
		from sav.dbo.CLI_MAESTRO with(nolock)
		where COD_ENTIDAD = @COD_ENTIDAD
		and	  COD_SUCURSAL = @COD_SUCURSAL

		selecT @Tienda = RAZONSOCIAL_SII +','+ DIRECCION
		from sav.dbo.sav_empresas with(nolock)
		where cod_emp = @COD_EMP

			
		select @IMG_1 =  ruta
		from sav.dbo.PAR_PATHPROCESOS with(nolock) 
		where SISTEMA  ='VENTA_WEB'
			and CODIGO = 'CORREO_VW_01'


		select @IMG_2 =  ruta
		from sav.dbo.PAR_PATHPROCESOS with(nolock) 
		where SISTEMA  ='VENTA_WEB'
			and CODIGO = 'CORREO_VW_02'


		select @IMG_3 =  ruta
		from sav.dbo.PAR_PATHPROCESOS with(nolock) 
		where SISTEMA  ='VENTA_WEB'
			and CODIGO = 'CORREO_VW_03'

		SET @To = 'EX.SF.CGONZALEZ@IMPERIAL.CL'

		

		if isnull(@TO,'') = '' 
		begin
			--return 0
			SELECT 0
		end 


		Set @From = 'system@imperial.cl'--'ventas-web@imperial.cl'
		Set @Subject = 'Tus productos están listos para retirar - Imperial'
		set @Mensaje = '<html>

<head>
    <meta name="viewport" content="width=device-width" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Envia correo al asignar locación picking tienda</title>

    <style>
        /* -------------------------------------   RESPONSIVE AND MOBILE FRIENDLY STYLES  ------------------------------------- */
        
        @media only screen and (max-width: 620px) {
            table[class=body] h1 {
                font-size: 28px !important;
                margin-bottom: 10px !important;
                border-collapse: collapse;
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
        p.retirar {            
            text-align: left;
            margin-left: 180px;
            font-weight: normal;            
        }
        u.retirarnoticia {            
            text-align: left;
            margin-left: 180px;
            font-weight: normal; 
            color: #003c69;           
        }
        table.grilla {
            border: 1;
            width: 1000px;
        }
        tr.campo {
            background-color: #273746 ;
            height: 30px;
        }
        td.sku {
            border: 1px solid #dddddd;
            text-align: center;
            padding: 8px;
            width: 20px; 
            color: #FFFFFF;
        }
        td.producto {
            border: 1px solid #dddddd;
            text-align: center;
            padding: 8px;
            width: 80px; 
            color: #FFFFFF;
        }
        td.cantidad {
            border: 1px solid #dddddd;
            text-align: center;
            padding: 8px;
            width: 20px; 
            color: #FFFFFF;
        }
        p.Descarga {
            color: #003c69; 
            font-weight: 600;
        }
        a.App {
            text-decoration: none;
        }
        img.google {
            vertical-align:middle;  
            margin-top: -15px;
        }                
    </style>
</head>

<body>
    <center>
        <IMG src="'+@RutaImg+'header.jpg" width="80%" HEIGHT=120>
    </center>
    <br>
    <font color="#003c69" face="Helvetica">            
        <H2>
            <center>' + @CLIENTE +'</center>
        </H2>
    </font>    
    <div>
        <u class="retirarnoticia"><b>¡Ya puedes venir a retirar tus productos!</b></u>        
    </div>
    <div>
        <p class="retirar">Informamos que su pedido <b>'+@TIPO_DOCUMENTO_PADRE+' N° ' + @Nro_Impreso + '.</p>        
    </div>    
    <div>
        <p class="retirar">Se encuentra disponible para retiro, en '+@Tienda+'.</p>
        <p class="retirar">Horarios de atención: Lunes a Viernes de 8:15 a 18:45 horas y Sábados de 8:30 a 14:00 horas.</p>
    </div>
    <br>   
    <table>
        <tr>
            <td>
                <table role="presentation">                     
                    <tr>                            
                        <p class="retirar">Acude a la zona demarcada como <u><b>compra en internet y retira en tienda</b></u> para solicitar tu pedido.</p>
                        <p class="retirar">Para retirar la compra es necesario presentar, según corresponda:</p>                   
                    </tr>
                </table>                    
            </td>   
        </tr>
    </table>
    <center>
        <IMG src="'+@RutaImg+'footer.jpg" width=80% HEIGHT=300>
        <td align="center">
            <p class="Descarga">Descarga Nuestra APP</p>
            <a class="App" href="https://play.google.com/store/apps/details?id=cl.imperial.app&hl=es">
                <img class="google" src="https://soa-desa-iis.imperial.cl/Pictures/footer_app2.jpg" target="Blank_" width="100" height="30">
            </a>
            <a class="App" href="https://apps.apple.com/cl/app/imperial-app/id1131355568">
                <img style="vertical-align:middle; margin-top: -15px" src="https://soa-desa-iis.imperial.cl/Pictures/footer_app.jpg" target="Blank_" width="100" height="30">
            </a>
        </td>
    </center>
    <br>
    <table width="100%" border="2" align="center" cellspacing="0" style="width: 80%">
        <tr>
            <td>
                <font SIZE=2>
                    <center>      
                        Este mensaje ha sido generado automáticamante por nuestros sistemas, favor no responder a este email      
                    </center>
                </font>
            </td>
        </tr>
    </table>
</body>

</html>'

		--<FONT SIZE=6>A</font>	
	--select @Mensaje,@IMG_3,@IMG_1,@IMG_2,@TIPO_DOCUMENTO_PADRE,@Nro_Impreso,@Tienda,@From,@TO,@Subject
	

	Exec zSAV_Lib_EnviaMailEx1
			@Area			= '', 
			@To				= @To,    
			@From			= @From,  
			@CC				= '',   
			@Subject		= @Subject,  
			@Attachments	= '',   
			@Mensaje		= @Mensaje,
			@TipoMensaje	= 'HTML',
			@CC_Oculto		= '',
			@Reply_To		= '',
			@importance		= 'HIGH'


	--Return 1
	SELECT 1

	END TRY
		BEGIN CATCH

			--insert into SAV_LOG.dbo.SAV_LOG_Errores
			--		(
			--			Objeto
			--			,Error
			--			,Descripcion
			--			,Linea
			--		)
			--	values
			--		(
			--			ERROR_PROCEDURE()
			--			,ERROR_NUMBER()
			--			,ERROR_MESSAGE()
			--			,ERROR_LINE()
			--		)

			--	RETURN 0

			SELECT
						ERROR_PROCEDURE()
						,ERROR_NUMBER()
						,ERROR_MESSAGE()
						,ERROR_LINE()
				
				SELECT 0

		END CATCH

		--commit transaction
		--return 1
		SELECT 1

	End











