
*
A4      �?      �?!      �?)      �?0�
PRO_MAESTRO  " * 2G
COD_PROVEEDORnVARCHAR0: B R Z b p�� � � � � � � � � 2D
COD_SUCURSALnVARCHAR0: B R Z b �� � � � � � � � � J/
 PRO_MAESTROCOD_PROVEEDOR" (���������0 8 X���������`h� � � � � � ����������������������������������������� � � � � � � � � � � � � ����������� � � � � ����������� � � � � � � �
EMPRESA_CONVENIO  " * 2G
CODIGO_CONVENIOnVARCHAR0: B R Z b �� � � � � � � � � 2B
COD_PROVEEDORint0: B R Z b p�� � � � � � � � � 2D
COD_SUCURSALnVARCHAR0: B R Z b �� � � � � � � � � 2H
NOMBRE_CONVENIOnVARCHAR�0: B R Z b �� � � � � � � � � 2>
ESTADOnVARCHAR20: B R Z b �� � � � � � � � � 2F
FECHA_REGISTROdatetime0: B R Z b �� � � � � � � � � 2D
FECHA_CONVENIOdatetime0: B R Z b �� � � � � � � � � 2I
USUARIO_REGISTROnVARCHAR�0: B R Z b �� � � � � � � � � J6
 EMPRESA_CONVENIOCODIGO_CONVENIO" (���������0 8 X���������`h� � � � � � ����������������������������������������� � � � � � � � � � � � � ����������� � � � � ����������� � � � � � � �
CUPON_CONVENIO  " * 2F
CODIGO_IMPRESOnVARCHAR0: B R Z b �� � � � � � � � � 2G
CODIGO_CONVENIOnVARCHAR0: B R Z b �� � � � � � � � � 2D
CORRELATIVO_CUPONint0: B R Z b p�� � � � � � � � � 2C
COD_ORI_VTAnVARCHAR0: B R Z b �� � � � � � � � � 2F
FECHA_REGISTROdatetime0: B R Z b �� � � � � � � � � 2F
FECHA_VIGENCIAdatetime0: B R Z b �� � � � � � � � � 2E
FECHA_UTILIZADOdatetime: B R Z b �� � � � � � � � � 2>
ACTIVOnVARCHAR0: B R Z b �� � � � � � � � � 2E
USUARIO_CREAnVARCHAR�0: B R Z b �� � � � � � � � � 2D
VALOR_DESCUENTOdecimal0: B R Z b �� � � � � � � � � 2?
TIPO_DESCUENTOint0: B R Z b �� � � � � � � � � 2;

PORCENTAJEbit0: B R Z b �� � � � � � � � � J3
 CUPON_CONVENIOCODIGO_IMPRESO" (���������0 8 X���������`h� � � � � � ����������������������������������������� � � � � � � � � � � � � ����������� � � � � ����������� � � � � � � �
	HISTORIAL  " * 2A
ID_HISTORIALint0: B R Z b p�� � � � � � � � � 2A
CODIGO_IMPRESOint0: B R Z b �� � � � � � � � � 2D
OBSERVACIONnVARCHAR�0: B R Z b �� � � � � � � � � 2F
FECHA_REGISTROdatetime0: B R Z b �� � � � � � � � � 2?
ORIGENnVARCHAR�0: B R Z b �� � � � � � � � � J,
 	HISTORIALID_HISTORIAL" (���������0 8 X���������`h� � � � � � ����������������������������������������� � � � � � � � � � � � � ����������� � � � � ����������� � � � � � � �
CONVENIO  " * 2@
ID_CONVENIOint0: B R Z b p�� � � � � � � � � 2@
COD_TIPOnVARCHAR0: B R Z b �� � � � � � � � � 2D
DESCRIPCIONnVARCHAR�0: B R Z b �� � � � � � � � � 28
VALORint0: B R Z b �� � � � � � � � � 2E
USUARIO_CREAnVARCHAR�0: B R Z b �� � � � � � � � � 2F
FECHA_REGISTROdatetime0: B R Z b �� � � � � � � � � J*
 CONVENIOID_CONVENIO" (���������0 8 X���������`h� � � � � � ����������������������������������������� � � � � � � � � � � � � ����������� � � � � ����������� � � � � � � �
TIPO_DESCUENTO  " * 2D
ID_TIPO_DESCUENTOint0: B R Z b p�� � � � � � � � � 2;

PORCENTAJEbit0: B R Z b �� � � � � � � � � J6
 TIPO_DESCUENTOID_TIPO_DESCUENTO" (���������0 8 X���������`h� � � � � � ����������������������������������������� � � � � � � � � � � � � ����������� � � � � ����������� � � � � � � n
fk_EMPRESA_CONVENIO_CONVENIO_1EMPRESA_CONVENIOCODIGO_CONVENIO"CONVENIO*ID_CONVENIO0 8 X` h r z � � j
fk_CONVENIO_COPON_CONVENIO_1CONVENIOID_CONVENIO"CUPON_CONVENIO*CODIGO_CONVENIO0 8 X` h r z � � ~
$fk_EMPRESA_CONVENIO_COPON_CONVENIO_1EMPRESA_CONVENIOCODIGO_CONVENIO"CUPON_CONVENIO*CODIGO_CONVENIO0 8 X` h r z � � |
"fk_TIPO_DESCUENTO_COPON_CONVENIO_1TIPO_DESCUENTOID_TIPO_DESCUENTO"CUPON_CONVENIO*VALOR_DESCUENTO0 8 X` h r z � � t
!fk_PRO_MAESTRO_EMPRESA_CONVENIO_1PRO_MAESTROCOD_PROVEEDOR"EMPRESA_CONVENIO*COD_PROVEEDOR0 8 X` h r z � � n
fk_CUPON_CONVENIO_HISTORIAL_1CUPON_CONVENIOCODIGO_IMPRESO"	HISTORIAL*CODIGO_IMPRESO0 8 X` h r z � � "�
	Diagram 1(0:A
?
PRO_MAESTRO� �(Z2$	�������?pppppp�?�?!      �?8 :G
E
EMPRESA_CONVENIO�F �(�2$	�������?pppppp�?�?!      �?8 :E
C
CUPON_CONVENIO� �(�2$	�������?pppppp�?�?!      �?8 :@
>
	HISTORIAL�d �(�2$	�������?pppppp�?�?!      �?8 : : : J�
$fk_EMPRESA_CONVENIO_COPON_CONVENIO_1����$	�������?�������?�������?!      �? *EMPRESA_CONVENIO2CODIGO_CONVENIO:CUPON_CONVENIOBCODIGO_CONVENIOXbK��� *Arial Unicode MS0:$	�������?�������?�������?!      �?@ H P J�
!fk_PRO_MAESTRO_EMPRESA_CONVENIO_1����$	�������?�������?�������?!      �? *PRO_MAESTRO2COD_PROVEEDOR:EMPRESA_CONVENIOBCOD_PROVEEDORXbK��� *Arial Unicode MS0:$	�������?�������?�������?!      �?@ H P J�
fk_CUPON_CONVENIO_HISTORIAL_1����$	�������?�������?�������?!      �? *CUPON_CONVENIO2CODIGO_IMPRESO:	HISTORIALBCODIGO_IMPRESOXbK��� *Arial Unicode MS0:$	�������?�������?�������?!      �?@ H P RArial Unicode MSX` h p �( 0@hJ)
view_1" * 2 : B H P X ` h r x � � � PX��` h 