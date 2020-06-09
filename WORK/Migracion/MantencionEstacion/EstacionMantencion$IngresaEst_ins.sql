ALTER PROCEDURE dbo.EstacionMantencion$IngresaEst_ins
----------------------------------------------------------------------------
-- Procedimiento: EstacionMantencion$IngresaEst_ins   --> PARAMETRO DE ENTRADA 'AAURORA','FERRE','aa','aa','aa','aa'
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Ingresa Estacion
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Ingresa Estación, bASado en el SAV_CJ_MantenedorEstaciones 
----------------------------------------------------------------------------
	 @Est			CHAR	(50)
	,@Emp			CHAR	(8)
	,@TipoEst		CHAR	(20)
	,@Desc			VARCHAR (150)
	,@SucRan		CHAR	(3)
	,@EstRan		CHAR	(2)
	,@Error_Message NVARCHAR(4000) OUTPUT

AS
	SET NOCOUNT ON
	SET XACT_ABORT ON

	BEGIN TRANSACTION

	DECLARE @INSERT AS CHAR(2)

IF EXISTS(SELECT * FROM SAV_CJ.dbo.Sav_Cj_Estaciones WITH(NoLock) WHERE Estacion = @Est )
	BEGIN
		SET	@INSERT = 'NO'

		UPDATE 	SAV_CJ.dbo.SAV_CJ_Estaciones	
		SET	Cod_Emp				= @Emp
			,TipoEstacion		= @TipoEst
			,Descripcion		= @Desc
			,Sucursal_Random	= @SucRan
			,Estacion_Random	= @EstRan
		WHERE Estacion	= @Est

		SELECT 	@INSERT AS Ins
	
		IF @@Error <> 0
		BEGIN 
			ROLLBACK TRANSACTION 
			RETURN 0
		END

		IF NOT EXISTS(SELECT * FROM SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos WITH(NoLock) WHERE Estacion = @Est and Cod_Emp = @Emp)
			BEGIN
				INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos (Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES (@Est,@Emp,'CHQ',1)
				IF @@Error <> 0
				BEGIN 
					ROLLBACK TRANSACTION 
					RETURN 0
				END
	
				INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos (Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES (@Est,@Emp,'EFE',1)
				IF @@Error <> 0
				BEGIN 
					ROLLBACK TRANSACTION 
					RETURN 0
				END
	
				INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos (Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES (@Est,@Emp,'NCV',1)
				IF @@Error <> 0
				BEGIN 
					ROLLBACK TRANSACTION 
					RETURN 0
				END
	
				INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos (Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES (@Est,@Emp,'PAV',1)
				IF @@Error <> 0
				BEGIN 
					ROLLBACK TRANSACTION 
					RETURN 0
				END
	
				INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos (Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES (@Est,@Emp,'TRJ',1)	
				IF @@Error <> 0
				BEGIN 
					ROLLBACK TRANSACTION 
					RETURN 0
				END

				INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos (Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES (@Est,@Emp,'EFC',1)	
				IF @@Error <> 0
				BEGIN 
					ROLLBACK TRANSACTION 
					RETURN 0
				END
			END 
		END
		ELSE
			BEGIN
				SET 	@INSERT = 'SI'
				INSERT INTO SAV_CJ.dbo.Sav_Cj_Estaciones ( Estacion,Cod_Emp,TipoEstacion,Descripcion,Sucursal_Random,Estacion_Random)
					VALUES ( @Est,@Emp,@TipoEst,@Desc,@SucRan,@EstRan)
	
				SELECT 	@INSERT AS Ins

				IF @@Error <> 0
				BEGIN 
					ROLLBACK TRANSACTION 
					RETURN 0
				END

				IF NOT EXISTS(SELECT * FROM SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos WITH(NoLock) WHERE Estacion = @Est and Cod_Emp = @Emp)
				BEGIN
	
					INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos	
							(Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES		(@Est,@Emp,'CHQ',1)
					IF @@Error <> 0
					BEGIN 
						ROLLBACK TRANSACTION 
						RETURN 0
					END
	
					INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos	
							(Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES		(@Est,@Emp,'EFE',1)
					IF @@Error <> 0
					BEGIN 
						ROLLBACK TRANSACTION 
						RETURN 0
					END
	
					INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos	
							(Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES		(@Est,@Emp,'NCV',1)
					IF @@Error <> 0
					BEGIN 
						ROLLBACK TRANSACTION 
						RETURN 0
					END
	
					INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos	
							(Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES		(@Est,@Emp,'PAV',1)
					IF @@Error <> 0
					BEGIN 
						ROLLBACK TRANSACTION 
						RETURN 0
					END
	
					INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos	
							(Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES		(@Est,@Emp,'TRJ',1)	
					IF @@Error <> 0
					BEGIN 
						ROLLBACK TRANSACTION 
						RETURN 0
					END

					INSERT INTO SAV_CJ.dbo.Sav_Cj_EstacionesCorrelativosPagos	
							(Estacion,Cod_Emp,Tipo,Correlativo)
					VALUES		(@Est,@Emp,'EFC',1)	
					IF @@Error <> 0
					BEGIN 
						ROLLBACK TRANSACTION 
						RETURN 0
					END

				END 

				SELECT 	@INSERT AS Ins
			END 

IF @@Error <> 0
BEGIN
	SELECT
	@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
	RETURN
END

COMMIT TRANSACTION
RETURN 1




