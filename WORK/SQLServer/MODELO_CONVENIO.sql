CREATE TABLE EMPRESA_CONVENIO (
		CODIGO_CONVENIO 	NVARCHAR(3)  		NOT NULL  PRIMARY KEY,
		COD_PROVEEDOR 		INT				 	NOT NULL  IDENTITY (1,1),
		COD_SUCURSAL 		NVARCHAR(3)  		NOT NULL,
		NOMBRE_CONVENIO		NVARCHAR(150) 		NOT NULL,
		ESTADO 				NVARCHAR(50) 		NOT NULL,
		FECHA_REGISTRO 		DATETIME	  		NOT NULL,
		FECHA_CONVENIO 		DATETIME 			NOT NULL,
		FECHA_VIGENCIA 		DATETIME			NOT NULL,
		USUARIO_REGISTRO 	NVARCHAR(150) 		NOT NULL,
		NUMEROS_CUPONES				
);

CREATE TABLE CUPON_CONVENIO (
		CODIGO_IMPRESO 		NVARCHAR(11) 		NOT NULL PRIMARY KEY,
		CODIGO_CONVENIO 	NVARCHAR(3) 		NOT NULL,
		CORRELATIVO_CUPON 	INT					NOT NULL IDENTITY (1,1),
		COD_ORI_VTA 		NVARCHAR(3) 		NOT NULL,
		FECHA_REGISTRO 		DATETIME	 		NOT NULL,
		FECHA_VIGENCIA 		DATETIME			NOT NULL,
		FECHA_UTILIZADO 	DATETIME			NULL,
		ACTIVO 				NVARCHAR(1) 		NOT NULL,
		USUARIO_CREA 		NVARCHAR(150) 		NOT NULL,
		VALOR_DESCUENTO		DECIMAL 			NOT NULL,
		TIPO_DESCUENTO 		INT 				NOT NULL,
		PORCENTAJE  		BIT					NOT NULL,		
);

CREATE TABLE HISTORIAL (
		ID_HISTORIAL 		INT 				NOT NULL IDENTITY (1,1) PRIMARY KEY,
		CODIGO_IMPRESO 		INT					NOT NULL,
		OBSERVACION 		NVARCHAR(200) 		NOT NULL,
		FECHA_REGISTRO 		DATETIME	 		NOT NULL,
		ORIGEN 				NVARCHAR(150) 		NOT NULL,
);


ALTER TABLE PRO_MAESTRO 	 	ADD	CONSTRAINT  FOREIGN KEY (COD_PROVEEDOR) 	REFERENCES EMPRESA_CONVENIO (COD_PROVEEDOR);
ALTER TABLE EMPRESA_CONVENIO    ADD	CONSTRAINT  FOREIGN KEY (CODIGO_CONVENIO)  	REFERENCES CUPON_CONVENIO 	(CODIGO_CONVENIO);
ALTER TABLE CUPON_CONVENIO 		ADD	CONSTRAINT  FOREIGN KEY (CODIGO_IMPRESO) 	REFERENCES HISTORIAL 		(CODIGO_IMPRESO);
;
