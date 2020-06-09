--CREATE Procedure dbo.SAV_RegistroConvenio
-----------------------------------------------------------------------------------------------
-- Creado por  : Cesar Gonzalez SF        
-- Fecha       : 26-06-2019        
-- Objetivo    : Generar convenio con empresas para obener cupones de descuentos para compras
-----------------------------------------------------------------------------------------------

   DECLARE
	@RUT_PROVEEDOR		NVARCHAR(9)		= '0000021-3',
	@FECHA_CONVENIO		DATETIME		= GETDATE(),
	@FECHA_VIGENCIA		DATETIME		= GETDATE()+3,
	@ESTADO				NVARCHAR		= 'A'  --A=ACTIVO; I=INATIVO
	
	--AS  
	BEGIN 
		BEGIN TRY
			DECLARE @RUT VARCHAR(9)
			DECLARE @DV  VARCHAR(1) 
			DECLARE @COD_CONVENIO INT = O

			-- OBTENEMOS EL ULTIMO NUMERO DE CONVENIO INGRESADO PARA SUMARLE 1
			IF(SELECT COUNT(*) FROM SAV.dbo.EMPRESA_CONVENIO) > 0
				BEGIN
					SELECT @COD_CONVENIO = MAX(CODIGO_CONVENIO) FROM SAV.dbo.EMPRESA_CONVENIO
					SET	   @COD_CONVENIO = @COD_CONVENIO + 1					 
				END
			ELSE
				BEGIN
					SET @COD_CONVENIO = 1
				END
			-- REALIZAMOS LA SEPARCION DE RUT Y DIGITO VERIFICADOR DV
			IF (SELECT CHARINDEX('-',@RUT_PROVEEDOR)) > 0 
				BEGIN 
					SET @RUT = SUBSTRING(@RUT_PROVEEDOR,1,(CHARINDEX('-',@RUT_PROVEEDOR)-1))
					SET @DV  = SUBSTRING(@RUT_PROVEEDOR,CHARINDEX('-',@RUT_PROVEEDOR) + 1, LEN(@RUT_PROVEEDOR))
				END

			SET @RUT_PROVEEDOR = RIGHT('0000000000' + UPPER(LTRIM(RTRIM(@RUT))), 8)

			IF EXISTS(SELECT TOP 1 1 FROM SAV.dbo.PRO_MAESTRO WITH(NOLOCK) WHERE RUT_PROVEEDOR = @RUT_PROVEEDOR AND DV_PROVEEDOR = @DV)
				BEGIN
					INSERT SAV.dbo.EMPRESA_CONVENIO
					(
					 CODIGO_CONVENIO,
					 COD_PROVEEDOR,
					 COD_SUCURSAL,
					 NOMBRE_CONVENIO,
					 ESTADO,
					 FECHA_REGISTRO,
					 FECHA_CONVENIO,
					 FECHA_VIGENCIA,
					 USUARIO_REGISTRO
					)
					SELECT 
					CAST(@COD_CONVENIO AS NVARCHAR(5)),
					COD_PROVEEDOR,
					COD_SUCURSAL,
					NOMBRE,
					@ESTADO,
					GETDATE(),
					@FECHA_CONVENIO,
					@FECHA_VIGENCIA,
					'SYSTEM'
						FROM SAV.dbo.PRO_MAESTRO
							WHERE RUT_PROVEEDOR = @RUT_PROVEEDOR AND DV_PROVEEDOR = @DV 
				END
			ELSE
				BEGIN
					SELECT 0
				END
		END TRY
		BEGIN CATCH 

			--insert into SAV_LOG.dbo.SAV_LOG_Errores        
			--  (        
			--   Objeto        
			--   ,Error        
			--   ,Descripcion        
			--   ,Linea        
			--  )        
			-- values        
			--  (        
			--   ERROR_PROCEDURE()        
			--   ,ERROR_NUMBER()        
			--   ,ERROR_MESSAGE()        
			--   ,ERROR_LINE()        
			--  )   			      		
		END CATCH  
	END
			
		



