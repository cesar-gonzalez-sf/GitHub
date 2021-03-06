ALTER PROCEDURE [dbo].[ForArchivoPresenta] 
-----------------------------------------------------------------------------------------------
-- Creado por  : Cesar Gonzalez SF    '20191008'    
-- Fecha       : 08-11-2019        
-- Objetivo    : Generar Formato de Archivo de Presentación 
-----------------------------------------------------------------------------------------------

  @FECHA NVARCHAR(20)


AS
	BEGIN
		BEGIN TRY			 

			CREATE TABLE ##formatoarchivo(
				  ID INT IDENTITY(1, 1)
				, column1 NVARCHAR(MAX)
				, column2 NVARCHAR(30)
				, column3 NVARCHAR(80)
				, column4 NVARCHAR(20)
				, column5 NVARCHAR(300)
				, column6 NVARCHAR(30)
				, column7 NVARCHAR(50)
				, column8 NVARCHAR(80)
				, column9 NVARCHAR(MAX)
				)

			DECLARE @Patharchivos	AS NVARCHAR(max) = '\\8kvmshare\ControlFuentesImperial\00_Fuentes Desarrollo\Solicitudes Fuentes\Cesar Gonzalez\FormatoArchivo'
			DECLARE @Comando		AS VARCHAR(MAX)
			DECLARE @NOMBRE			AS VARCHAR(20)	 = (SELECT DISTINCT CONVERT(NVARCHAR,COMERCIO)+CONVERT(NVARCHAR,FECHA) FROM [8KDRPCOLUMBIA\REPLICACION].SAV_CJ.dbo.FALCMR3_JOURNAL WHERE FECHA = @FECHA)

			-- insertamos en tabla
			INSERT INTO ##formatoarchivo (column1, column2, column3, column4, column5, column6, column7, column8, column9) 
				SELECT TOP 1 '00'+CONVERT(NVARCHAR,FECHA)+'HEADER'+SPACE(4)+CONVERT(NVARCHAR,FECHA)+SPACE(698)+'.','','','','','','','',''
					FROM [8KDRPCOLUMBIA\REPLICACION].SAV_CJ.dbo.FALCMR3_JOURNAL  WHERE FECHA = @FECHA  ORDER BY ID

			INSERT INTO ##formatoarchivo (column1, column2, column3, column4, column5, column6, column7, column8, column9)
				SELECT 
					  '0015'+CONVERT(NVARCHAR,PAIS)+CONVERT(NVARCHAR,COMERCIO)
					, '0'+CONVERT(NVARCHAR,FUNCION)+'0'+CONVERT(NVARCHAR,ORIGEN)+CONVERT(NVARCHAR,FECHA)+RIGHT('000000' + CONVERT(NVARCHAR,HORA),6)+ RIGHT('0000' + CONVERT(NVARCHAR,SUCURSAL), 4)
					, RIGHT ('0000000000000000' + CONVERT(NVARCHAR,TERMINAL),16)+RIGHT ('00000000'+CONVERT(NVARCHAR,SECUENCIA),8)+RIGHT ('000000000000'+CONVERT(NVARCHAR,AUTPREVIA),12)+CONVERT(NVARCHAR,MODTRAN)+CONVERT(NVARCHAR,FECHA)+'01'+'0000'+'1'+'0'+RIGHT ('00000000'+CONVERT(NVARCHAR,COMERCIO),8)+CONVERT(NVARCHAR,FECHA)+'01'+RIGHT ('00000000'+CONVERT(NVARCHAR,SECUENCIA),8)
					, 'S'+PAN
					, '01'+RIGHT ('00000000000000000000' + CONVERT(NVARCHAR,NUMDOCID),20)+RIGHT ('000'+CONVERT(NVARCHAR,MONEDA),3)+'000000000'+RIGHT ('0'+CONVERT(NVARCHAR,MODPAGO),1)+RIGHT ('00'+CONVERT(NVARCHAR,PLAZO),2)+RIGHT('00000000000000000'+CONVERT(NVARCHAR,Floor(MONTO)*100),17)+'00000000000000000'+'00000000000000000'+'00000000000000000'+'00000000000000000'+RIGHT ('000'+CONVERT(NVARCHAR,CUOTAS),3)+RIGHT('00000000000'+CONVERT(NVARCHAR,Floor(MONTO)*100),11)+'00000000000'+'00000000000'+'0000000'+RIGHT('00000000000'+CONVERT(NVARCHAR,REPLACE(ABONO,'.','0')),11)+RIGHT ('0'+CONVERT(NVARCHAR,TIPDOCVTA),1)+RIGHT ('000000000000' + CONVERT(NVARCHAR,NUMDOCVTA),12)+RIGHT ('00000000' + CONVERT(NVARCHAR,CAJERO),8)+RIGHT ('00000000' + CONVERT(NVARCHAR,CONVENIO),8)+'0000000000000000000000000000000000000000'+RIGHT ('0000000000' + CONVERT(NVARCHAR,FECHA),10)+RIGHT ('000000' + CONVERT(NVARCHAR,HORA),6)+'0'
					,RIGHT ('0000' + CONVERT(NVARCHAR,PLAZA),4)+RIGHT ('00000000' + CONVERT(NVARCHAR,CHEQUE),8)+RIGHT ('0000' + CONVERT(NVARCHAR,BANCO),4)+RIGHT ('0000000000' + CONVERT(NVARCHAR,GIRADOR),10)
					,CONVERT(NVARCHAR,FECHA)+RIGHT ('000000000000' + CONVERT(NVARCHAR,AUTORIZACION),12)+RIGHT ('00000000' + CONVERT(NVARCHAR,NEG_FECHA),8)+RIGHT ('00000000' + CONVERT(NVARCHAR,NEG_CORREL),8)+'000000'
					,CONVERT(NVARCHAR,FECHA)+'000'+'00000000'+RIGHT ('0000000000000000' + CONVERT(NVARCHAR,TERMINAL),16)+CONVERT(NVARCHAR,FECHA)+RIGHT('0000' + CONVERT(NVARCHAR,SUCURSAL), 4)+RIGHT ('0000000000000000' + CONVERT(NVARCHAR,TERMINAL),16)+CONVERT(NVARCHAR,NUMDOCID)
					,'000'+'0000000000000'+'0000000000000'+'.'
						FROM [8KDRPCOLUMBIA\REPLICACION].SAV_CJ.dbo.FALCMR3_JOURNAL  WHERE FECHA = @FECHA  ORDER BY HORA

			INSERT INTO ##formatoarchivo (column1, column2, column3, column4, column5, column6, column7, column8, column9) 
				SELECT TOP 1 'TRAILER'+RIGHT('00000000'+CONVERT(NVARCHAR,COUNT(*)),8)+RIGHT('00000000000000000'+CONVERT(NVARCHAR,Floor(sum(MONTO)*100)),17)+SPACE(694)+'.','','','','','','','',''
					FROM   [8KDRPCOLUMBIA\REPLICACION].SAV_CJ.dbo.FALCMR3_JOURNAL  WHERE FECHA = @FECHA	

	--___________________________________________________________________GENERAMOS TXT A PARTIR DE LA TABLA TEMPORAL--___________________________________________________________________  
			Set @Comando='Exec Master..Xp_Cmdshell ''Bcp "SELECT column1+SPACE(7)+column2+SPACE(16)+column3+SPACE(5)+column4+SPACE(6)+column5+SPACE(101)+column6+SPACE(10)+column7+SPACE(2)+column8+SPACE(10)+column9 FROM ##formatoarchivo ORDER BY ID'     
			+ '" Queryout "' + @Patharchivos + '\'+@NOMBRE+'.sat" -c -T -t\t  -w '''   

			--EJECUTAMOS EXEC  
			EXEC(@Comando)   
			-- borramos tabla
			DROP TABLE ##formatoarchivo
			


		END TRY

	BEGIN CATCH		
		  INSERT INTO SAV_LOG.dbo.Sav_Log_Errores      
		  (Objeto,Error,Descripcion,Linea)      
		 VALUES      
		  ( ERROR_PROCEDURE(),ERROR_NUMBER(),ERROR_MESSAGE() ,ERROR_LINE()) 
		RETURN 0
	END CATCH
		RETURN 1
END

