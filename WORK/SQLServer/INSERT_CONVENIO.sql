INSERT sav.dbo.EMPRESA_CONVENIO 
(
	CODIGO_CONVENIO,
	COD_PROVEEDOR,
	COD_SUCURSAL,
	NOMBRE_CONVENIO,
	ESTADO,
	FECHA_REGISTRO,
	FECHA_CONVENIO,
	USUARIO_REGISTRO
)
SELECT '009',COD_PROVEEDOR, COD_SUCURSAL, NOMBRE, 'ACTIVO', GETDATE(), GETDATE(),'SYSTEM'
	FROM sav.dbo.PRO_MAESTRO
		WHERE COD_PROVEEDOR = '00000031'


INSERT SAV.dbo.CUPON_CONVENIO 
(
	CODIGO_IMPRESO,
	CODIGO_CONVENIO,	
	FECHA_REGISTRO,
	FECHA_VIGENCIA,
	FECHA_UTILIZADO,
	ACTIVO,
	USUARIO_CREA
)
SELECT '00002',CODIGO_CONVENIO,GETDATE(),GETDATE(),GETDATE(),'1','SYSTEM'
	FROM EMPRESA_CONVENIO
		WHERE CODIGO_CONVENIO = '002'	

INSERT HISTORIAL_CONVENIO
(
	CODIGO_IMPRESO,
	OBSERVACION,
	FECHA_REGISTRO	
)
SELECT CODIGO_IMPRESO,'TEST',GETDATE()
	FROM CUPON_CONVENIO
		WHERE CODIGO_IMPRESO = '00008'
		

