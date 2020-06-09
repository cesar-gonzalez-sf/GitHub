CREATE TABLE EMPRESAS (
		ID_EMPRESA		INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
		NOMBRE			NVARCHAR(150) NOT NULL,
		SUCURSAL		NVARCHAR(50) NOT NULL,
		RUT_EMPRESA		NVARCHAR(10) NOT NULL,
		DV_EMPRESA		NVARCHAR(1) NOT NULL,
		TELEFONO		NVARCHAR NOT NULL,
		DIRECCION		NVARCHAR(70) NOT NULL,
		FECHA_CREA		DATETIME NOT NULL,
		USUARIO_CREA	NVARCHAR(150) NOT NULL,
	);

CREATE TABLE EMPRESA_CONVENIO (
		ID_EMP_CONV		INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
		ID_EMPESA		INT NOT NULL,
		ID_TIPO_CONV	INT NOT NULL,
		ESTADO			NVARCHAR(50) NOT NULL,
		FECHA_CREA		DATETIME NOT NULL,
		USUARIO_CREA	NVARCHAR(150) NOT NULL, 
	);

CREATE TABLE CODIGO_CONVENIO (
		ID_CODIGO_CONV	INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
		ID_EMP_CONV		INT NOT NULL,
		CODIGO_CONV		NVARCHAR(150) NOT NULL,
		FECHA_REGISTRO	DATETIME NOT NULL,
		FECHA_VIGENCIA	DATETIME NOT NULL,
		FECHA_UTILIZADO	DATETIME NULL,
		ACTIVO			NVARCHAR(1) NOT NULL,
		USUARIO_CREA	NVARCHAR(150) NOT NULL,
	);

CREATE TABLE HISTORIAL (
		ID_HISTORIAL	INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
		ID_CODIGO_CONV	INT NOT NULL,
		OBSERVACION		NVARCHAR(200) NOT NULL,
		FECHA_REGISTRO	DATETIME NOT NULL,
		ORIGEN			NVARCHAR(150) NOT NULL,
	);

CREATE TABLE TIPO_CONVENIO (
		ID_TIPO_CONV	INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
		COD_TIPO		NVARCHAR(3) NOT NULL,
		DESCRIPCION		NVARCHAR(150) NOT NULL,
		VALOR			INT NOT NULL,
		USUARIO_CREA	NVARCHAR(150) NOT NULL,
		FECHA_REGISTRO	DATETIME NOT NULL,
	);

ALTER TABLE EMPRESAS		 ADD CONSTRAINT fk_EMPRESAS_EMPRESA_CONVENIO_1		  FOREIGN KEY (ID_EMPRESA)     REFERENCES EMPRESA_CONVENIO (ID_EMPESA);
ALTER TABLE EMPRESA_CONVENIO ADD CONSTRAINT fk_EMPRESA_CONVENIO_CODIGO_CONVENIO_1 FOREIGN KEY (ID_EMP_CONV)    REFERENCES CODIGO_CONVENIO (ID_EMP_CONV);
ALTER TABLE CODIGO_CONVENIO	 ADD CONSTRAINT fk_CODIGO_CONVENIO_HISTORIAL_1		  FOREIGN KEY (ID_CODIGO_CONV) REFERENCES HISTORIAL (ID_CODIGO_CONV);
ALTER TABLE TIPO_CONVENIO	 ADD CONSTRAINT fk_TIPO_CONVENIO_EMPRESA_CONVENIO_1	  FOREIGN KEY (ID_TIPO_CONV)   REFERENCES EMPRESA_CONVENIO (ID_TIPO_CONV);


;
