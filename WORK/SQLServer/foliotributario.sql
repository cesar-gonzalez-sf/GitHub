SELECT * FROM SAV_AC.dbo.SAV_AC_FoliosTributarios 

DELETE FROM SAV_AC.dbo.SAV_AC_FoliosTributarios WHERE Primer_F = 401 

UPDATE SAV_AC.dbo.SAV_AC_FoliosTributarios SET Activo=1 WHERE Primer_F= 501

SELECT * FROM SAV.dbo.PAR_TIPODOCUMENTO	


 SELECT isnull(RUTA,'') as Ruta,*  
 FROM  PAR_PATHPROCESOS  with(nolock)

DELETE PAR_PATHPROCESOS WHERE SISTEMA='contabilidad' AND RUTA = 'C:\Task_Services\Tareas Programadas\FolioTributario'

UPDATE PAR_PATHPROCESOS SET RUTA='\\8kdsoracle\inetpub\FolioTributario' WHERE RUTA = 'C:\Task_Services\Tareas Programadas\FolioTributario'

SELECT * FROM PAR_PATHPROCESOS 	

Guarda los CAF descargados 
C:\Users\ex.sf.dvegas\Documents\ 

Guarda los CAF descargados en Compilador 
c:\Documents AND Settings\jvasquez\Mis Documents\

no se encontro el elemento en la coleccion que corresponde al nombre o el ordinal solicitado 

<env-entry-value>http://10.130.35.4:8080/WSImperial/folios</env-entry-value>

<env-entry-value>http://localhost:8080/DteBuscarFoliosSrv/imperial/foliosDte/buscar</env-entry-value>