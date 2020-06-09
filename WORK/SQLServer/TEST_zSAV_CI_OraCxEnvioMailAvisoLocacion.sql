--ALTER Procedure [dbo].[zSAV_CI_OraCxEnvioMailAvisoLocacion]
-- Modificado por	: Manuel Aguillon Reyes
-- Fecha			: 20180508
-- Objetivo			: envia correo al asignar locación picking tienda.
DECLARE
	  @NRO_PICKING INT = 1951486
	
	Begin
	BEGIN TRY

		declare 
				@Mensaje				VARCHAR(max),
				@Subject				VARCHAR(50),
				@CLIENTE				VARCHAR(50),
				@TIPO_DOCUMENTO			varchar(3),
				@Nro_Impreso			VARCHAR(10),
				@COD_RAPIDO				INT,
				@DESC_LARGA				VARCHAR(200),
				@Cantidad				DECIMAL(18,4),
				@To						VARCHAR(200),
				@From					VARCHAR(500),
				@CC						VARCHAR(500),
				@IMG_1					VARCHAR(500),
				@IMG_2					VARCHAR(500),
				@IMG_3					VARCHAR(500),
				@COD_EMP				VARCHAR(20),
				@COD_ENTIDAD			VARCHAR(10),
				@COD_SUCURSAL			VARCHAR(3),
				@Tienda					VARCHAR(750),
				@TIPO_DOCUMENTO_PADRE	VARCHAR(3),
				@NRO_DOCUMENTO_PADRE	INT,
				@PRODUCTOS				VARCHAR(500)
				


		set @PRODUCTOS = ''

		select @NRO_DOCUMENTO_PADRE = NRO_DOCUMENTO_PADRE,
			   @TIPO_DOCUMENTO_PADRE = TIPO_DOCUMENTO_PADRE
		from sav.dbo.sav_ci_picking  with(nolock)
		where nro_picking = @NRO_PICKING
		
		if	@TIPO_DOCUMENTO_PADRE not in ('BLV','FCV')
		begin		
			--return 0 
			select 0
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


		if isnull(@TO,'') = '' 
		begin		
			--return 0
			SELECT 0
		end 


		Set @From = 'system@imperial.cl'--'ventas-web@imperial.cl'
		Set @Subject = 'Tus productos están listos para retirar - Imperial'
		set @Mensaje = ''
		Set @Mensaje = '<html><head></head><body><u><b><H3><CENTER>¡Ya puedes venir a retirar tus productos!</CENTER></H3></b></u><br><br>'				
		Set @Mensaje = @Mensaje + 'Informamos que su pedido  ' + @TIPO_DOCUMENTO_PADRE + '<b> N° ' + @Nro_Impreso + '</b>, Se encuentra disponible para retiro, en <u>'+@Tienda+'</u>.<br><br>Horarios de atención: Lunes a Viernes de 8:15 a 18:45 horas y Sábados de 8:30 a 14:00 horas.<br/>'
		Select @PRODUCTOS = @PRODUCTOS + '<tr><td>' + Cast(ba.Cod_Rapido as Varchar) + '</td><td>' + ba.desc_larga + '</td><td>' + Cast(cast(pdet.cantidad as Int) as Varchar)  + '</td></tr>' 
        From sav.dbo.sav_ci_picking pcab with(nolock)
        Inner Join Sav.dbo.SAV_CI_Picking_Detalle pdet  with(nolock)
           On pcab.nro_picking  = pdet.NRO_PICKING
		inner join sav.dbo.PRD_DATOSBASICOS ba with(nolock)
			on ba.cod_producto = pdet.cod_producto
         where pcab.nro_picking     = @NRO_PICKING

        Set @PRODUCTOS = '<center><Table border=1><tr><td>Sku</td><td>Producto</td><td>Cantidad</td></tr>' + @PRODUCTOS + '</Table></center>'		
		set @mensaje = @Mensaje + '<br>'  +@PRODUCTOS + '<br>'		
		Set @Mensaje = @Mensaje + 'Acude a la zona demarcada como <u><b>compra en internet y retira en tienda</b></u> para solicitar tu pedido.<br/><br/>'
		Set @Mensaje = @Mensaje + '<b>Para retirar la compra es necesario presentar, según corresponda:</b><br><br>'		
		SET @Mensaje = @Mensaje + '<center><IMG align="CENTER" src="'+@IMG_1+'" WIDTH=600 HEIGHT=200></center><br><br><br>'		
		SET @Mensaje = @Mensaje + '<center><IMG align="CENTER" src="'+@IMG_2+'" WIDTH=600 HEIGHT=200></center><br>'		
		Set @Mensaje = @Mensaje + 'Atte.<br>'		
		Set @Mensaje = @Mensaje + 'Aréa de Despacho Imperial<br><br>'
		Set @Mensaje = @Mensaje + '<table width="100%" border="2" align="CENTER"><tr><FONT SIZE=2><CENTER>Este mensaje ha sido generado automaticamante por nuestros sistemas favor no responder a este email</CENTER></font></tr></table><br><br><br>'
		set @Mensaje = @Mensaje + '<center><IMG  src="'+@IMG_3+'" width="100%" HEIGHT=120></center> '		
		Set @Mensaje = @Mensaje + '</body></html>'
				
		--<FONT SIZE=6>A</font>	
	--select @Mensaje,@IMG_3,@IMG_1,@IMG_2,@TIPO_DOCUMENTO_PADRE,@Nro_Impreso,@Tienda,@From,@TO,@Subject
	
	SET @To = 'EX.SF.CGONZALEZ@IMPERIAL.CL'
	

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

				SELECT
						ERROR_PROCEDURE()
						,ERROR_NUMBER()
						,ERROR_MESSAGE()
						,ERROR_LINE()
					
					SELECT 0

		END CATCH

		--commit transaction
		SELECT 1

	End












