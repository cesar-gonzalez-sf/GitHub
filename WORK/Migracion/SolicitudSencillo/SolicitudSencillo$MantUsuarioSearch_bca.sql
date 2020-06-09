CREATE Procedure dbo.SolicitudSencillo$MantUsuarioSearch_bca
----------------------------------------------------------------------------
-- Procedimiento: SolicitudSencillo$BuscaUsuariosVA_bca
-- Autor: César González-Rubio
-- Fecha de Creacion: 11/06/2019 
-- Objetivo: Busca a un usuario por codigo de usuario ADAPI o por codigo vendedor SAV.
-- Empresa: SF Ingenieria. 
-- Descripción: Se normaliza procedimiento para DestokFX, Busca usuarios, bASado en el SAV_Lib_MantUsuarioSearch 
----------------------------------------------------------------------------

	@Cod_Vendedor   VARCHAR(40),
	@Cod_Usuario    VARCHAR(40),
    @Error_Message  NVARCHAR(4000) OUTPUT
AS
	BEGIN
		SET NOCOUNT ON
		SET Xact_Abort ON

			-- #RESULTSET	solicitud solicitudes
        	--  #COLUMN Cod_Usuario          NVARCHAR   
			--  #COLUMN Nombres              NVARCHAR
			--  #COLUMN Apellido_Pat         NVARCHAR
			--  #COLUMN Apellido_Mat         NVARCHAR
			--  #COLUMN USU_Estado           NVARCHAR
			--  #COLUMN Cod_Vendedor         NVARCHAR
			--  #COLUMN Cod_Alterno          NVARCHAR
			--  #COLUMN Cod_Cargo            NVARCHAR
			--  #COLUMN Color                NVARCHAR
			--  #COLUMN IMPPORTABLE          NVARCHAR
			--  #COLUMN IMPNOPORTABLE        NVARCHAR
			--  #COLUMN IMPPORTMADE          NVARCHAR
			--  #COLUMN IMPNOPOMADE          NVARCHAR
			--  #COLUMN Tienda               NVARCHAR
			--  #COLUMN Rut                	 NVARCHAR
			--  #COLUMN DescripcionCargo     NVARCHAR
			--  #COLUMN Email                NVARCHAR
			--  #COLUMN Empresa              NVARCHAR
			--  #COLUMN Bodega               NVARCHAR
			--  #COLUMN Fono1                NVARCHAR
			--  #COLUMN Fono2                NVARCHAR
			--  #COLUMN Ind_Retiro           NVARCHAR
			--  #COLUMN FechaRetiro          NVARCHAR
			--  #COLUMN FechaCumpleano       NVARCHAR
			--  #COLUMN Id_Cargo             NVARCHAR
			-- #ENDRESULTSET

			BEGIN TRY

				IF @Cod_Vendedor = '' And @Cod_Usuario = ''
				BEGIN
					SET @Error_Message = 'No se definio Ni codigo de usuario, Ni codigo de Vendedor'
					RETURN 
				END

				If @Cod_Usuario = ''
				BEGIN

					SELECT	-- Datos Generales	
						CAST(IsNull(U.Usu_Codigo, F.Usuario)	AS NVARCHAR) AS Cod_Usuario,												 
						CAST(IsNull(U.Nombres, F.Nombre)		AS NVARCHAR) AS Nombres, 
						CAST(IsNull(U.Apellido_Pat, F.Paterno)	AS NVARCHAR) AS Apellido_Pat, 
						CAST(IsNull(U.Apellido_Mat, F.Materno)	AS NVARCHAR) AS Apellido_Mat, 
						CAST(IsNull(U.USU_Estado, 'NH')			AS NVARCHAR) AS USU_Estado,				
							-- Datos SAV
						CAST(Ltrim(Rtrim(F.Cod_Funcionario))	AS NVARCHAR) AS Cod_Vendedor, 
						CAST(Ltrim(Rtrim(F.Alterno))			AS NVARCHAR) AS Cod_Alterno, 
						CAST(Ltrim(Rtrim(F.Cod_Cargo))			AS NVARCHAR) AS Cod_Cargo, 
						CAST(Ltrim(Rtrim(F.Color))				AS NVARCHAR) AS Color, 
						CAST(Ltrim(Rtrim(F.IMPPORTABLE))		AS NVARCHAR) AS IMPPORTABLE, 
						CAST(Ltrim(Rtrim(F.IMPNOPORTABLE))		AS NVARCHAR) AS IMPNOPORTABLE, 
						CAST(Ltrim(Rtrim(F.IMPPORTMADE))		AS NVARCHAR) AS IMPPORTMADE, 
						CAST(Ltrim(Rtrim(F.IMPNOPOMADE))		AS NVARCHAR) AS IMPNOPOMADE, 
						CAST(IsNull(F.Cod_Tienda, IsNull(U.Comuna, '')) AS NVARCHAR) AS Tienda,
							-- Datos Adapi
						CAST(IsNull(U.Rut, '')						AS NVARCHAR) AS Rut, 
						CAST(IsNull(U.Cargo, '')					AS NVARCHAR) AS DescripcionCargo, 
						CAST(IsNull(U.Email, '')					AS NVARCHAR) AS Email, 
						CAST(IsNull(U.Comuna, '')					AS NVARCHAR) AS Empresa, 
						CAST(IsNull(U.Ciudad, '')					AS NVARCHAR) AS Bodega, 
						CAST(IsNull(T.Anexo,IsNull(U.FONO1, ''))	AS NVARCHAR) AS Fono1, 
						CAST(IsNull(U.FONO2, '')					AS NVARCHAR) AS Fono2, 
						dbo.zSav_Rh_VigTrabBca(IsNull(U.Rut, ''))	AS Ind_Retiro, 
						CAST(IsNull(Convert(VARCHAR,T.FechaRetiro,103),'') AS NVARCHAR) AS FechaRetiro, 
						CAST(IsNull(Convert(VARCHAR,T.FechaCumpleano,103),'') AS NVARCHAR) AS FechaCumpleano, 
						CASE IsNumeric(LEFT(U.Cargo,5)) WHEN 1 THEN LEFT(U.Cargo,5) ELSE 0 END AS Id_Cargo 
						FROM Fun_Funcionarios F WITH(NOLOCK)
							LEFT JOIN EcuBAS..EcuAccUsu U WITH(NOLOCK) ON U.Usu_Codigo = F.Usuario COLLATE Modern_Spanish_CI_AI
							LEFT JOIN SAV_RRHH.dbo.SAV_RH_Usuario  T WITH(NoLock) ON U.Rut = T.RutDv COLLATE Modern_Spanish_CI_AI
							WHERE F.Cod_Funcionario = @Cod_Vendedor

					If @@RowCount = 0 Or @@Error <> 0
					BEGIN
						SET @Error_Message = 'No se encontraron datos para ese usuario [CodVend]'
						RETURN 0
					END

					SELECT Sucursal_Des, Grupo, Sucursal
						FROM SAV_UsuarioSucursal WITH(NOLOCK)
							WHERE Cod_Vendedor = @Cod_Vendedor

				END
				ELSE IF @Cod_Vendedor = ''
				BEGIN

					IF SubString(@Cod_Usuario, Len(@Cod_Usuario) - 1, 1) = '-'
					BEGIN
						SELECT TOP 1 @Cod_Usuario = Usu_Codigo 
							FROM EcuBAS..EcuAccUsu WITH(NOLOCK)
								WHERE Rut = @Cod_Usuario

						SET @Cod_Usuario = IsNull(@Cod_Usuario, '')

					END

					SELECT	-- Datos Generales
						CAST(Ltrim(Rtrim(U.Usu_Codigo))		AS NVARCHAR) AS Cod_Usuario,
						CAST(Ltrim(Rtrim(U.Nombres))		AS NVARCHAR) AS Nombres,
						CAST(Ltrim(Rtrim(U.Apellido_Pat))	AS NVARCHAR) AS Apellido_Pat,
						CAST(Ltrim(Rtrim(U.Apellido_Mat))	AS NVARCHAR) AS Apellido_Mat,
						CAST(Ltrim(Rtrim(U.USU_Estado))		AS NVARCHAR) AS USU_Estado,
							-- Datos SAV
						CAST(IsNull(F.Cod_Funcionario, '')  AS NVARCHAR) AS Cod_Vendedor,
						CAST(IsNull(F.Alterno, '')			AS NVARCHAR) AS Cod_Alterno,
						CAST(IsNull(F.Cod_Cargo, 0)			AS NVARCHAR) AS Cod_Cargo,
						CAST(IsNull(F.Color, '')			AS NVARCHAR) AS Color,
						CAST(IsNull(F.IMPPORTABLE, '')		AS NVARCHAR) AS IMPPORTABLE,
						CAST(IsNull(F.IMPNOPORTABLE, '')	AS NVARCHAR) AS IMPNOPORTABLE,
						CAST(IsNull(F.IMPPORTMADE, '')		AS NVARCHAR) AS IMPPORTMADE,
						CAST(IsNull(F.IMPNOPOMADE, '')		AS NVARCHAR) AS IMPNOPOMADE,
						CAST(IsNull(F.Cod_Tienda, U.Comuna) AS NVARCHAR) AS Tienda,
							-- Datos Adapi
						CAST(Ltrim(Rtrim(U.Rut))								AS NVARCHAR) AS Rut,
						CAST(Ltrim(Rtrim(U.Cargo))								AS NVARCHAR) AS DescripcionCargo,
						CAST(Ltrim(Rtrim(U.Email))								AS NVARCHAR) AS Email,
						CAST(Ltrim(Rtrim(U.Comuna))								AS NVARCHAR) AS Empresa,
						CAST(Ltrim(Rtrim(U.Ciudad))								AS NVARCHAR) AS Bodega,
						CAST(IsNull(T.Anexo,IsNull(U.FONO1, ''))				AS NVARCHAR) AS Fono1,
						CAST(IsNull(U.FONO2, '')								AS NVARCHAR) AS Fono2,
						dbo.zSav_Rh_VigTrabBca(IsNull(U.Rut, ''))				AS Ind_Retiro,
						CAST(IsNull(Convert(VARCHAR,T.FechaRetiro,103),'')		AS NVARCHAR) AS FechaRetiro,
						CAST(IsNull(Convert(VARCHAR,T.FechaCumpleano,103),'')	AS NVARCHAR) AS FechaCumpleano,
						CASE IsNumeric(LEFT(U.Cargo,5)) WHEN 1 THEN LEFT(U.Cargo,5) ELSE 0 END AS Id_Cargo
						FROM EcuBAS..EcuAccUsu U WITH(NoLock)
							LEFT JOIN Fun_Funcionarios F WITH(NoLock) ON F.Usuario COLLATE Modern_Spanish_CI_AI = U.Usu_Codigo
							LEFT JOIN SAV_RRHH.dbo.SAV_RH_Usuario T WITH(NoLock) ON U.Rut = T.RutDv COLLATE Modern_Spanish_CI_AI
							WHERE U.Usu_Codigo = @Cod_Usuario

					If @@RowCount = 0 Or @@Error <> 0

					SELECT Sucursal_Des, Grupo, Sucursal
						FROM SAV_UsuarioSucursal WITH(NOLOCK)
							WHERE Usuario = @Cod_Usuario

				END

			END TRY
		BEGIN CATCH

				IF @@Error <> 0
				BEGIN
					SELECT
					@Error_Message = 'Error en Update tabla SAV_CJ.dbo.SAV_CJ_Estaciones'
					RETURN
				END 

		END CATCH



	END









