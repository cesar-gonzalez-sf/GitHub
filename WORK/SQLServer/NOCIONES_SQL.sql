Nociones de SQL

////////////////////// Cada cláusula SQL está relacionada o responde a una pregunta de construcción //////////////////////////

SELECT: 	¿Qué datos nos piden?
FROM: 	  ¿Dónde están los datos?
WHERE: 	  ¿Qué requisitos deben cumplir los registros?
GROUP BY: 	¿Como deben agruparse los datos?
HAVING: 	¿Qué requisitos deben cumplir los cálculos de totalización?
ORDER BY:	¿Por qué columnas debe ordenarse el resultado?
Formado de un consulta
  select 	CAMPO_S1, ... , CAMPO_SN
  from 	TABLA_1, ... , TABLA_N
  where 	CONDICIONES_WHERE
  group by 	CAMPO_G1, ... , CAMPO_GN
  having 	CONDICIONES_HAVING
  order by 	CAMPO_O1, ... , CAMPO_ON

<-------------- En general una consulta SQL simple tendrá la siguiente forma: -------->

CÓDIGO: 
SELECT SELECCIONAR TODO CAMPOS(separados por comas)
 FROM TABLA
  WHERE CONDICIÓN

<------------ Insertar varios datos específicos a una tabla ---------------->

INSERT INTO EMPLEADOS
  (NOMBRE,APELLIDOS,F_NACIMIENTO,SEXO,CARGO,SALARIO)
VALUES    	
    ('Carlos','Jimenez Clarin','1985-05-03','H','Mozo','1500'),
    ('Elena','Rubio Cuesta','1978-09-25','M','Secretaria','1300'),
    ('Jose','Calvo Sisman','1990-11-12','H','Mozo','1400'),
    ('Margarita','Rodrigez Garces','1992-05-16','M','Secretaria','1325.5');

<------------ Consular datos comprendido entre un valor y otro --------------->

SELECT NOMBRE,APELLIDOS,F_NACIMIENTO,SALARIO 
  from EMPLEADOS 
    where SALARIO between 1350 and 1450

<-------------- Reinicio de campo Identity de una tabla  -------------------->

DBCC CHECKIDENT (TABLA, RESEED,0)

<------------------ Eliminara datos de una tabla ------------------->

DELETE FROM TABLA

<----------- Para saber la información general de la tabla en SQL SERVER ---------->
				
 EXEC sp_help 'tu tabla'

<--------- Eliminar calve Foranea fk ----------------->
  
ALTER TABLE Empleado DROP CONSTRAINT FK_Empl; 



