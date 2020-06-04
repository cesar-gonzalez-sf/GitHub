Imports System.Data
Imports System.Data.SqlClient

Public Class ClsProcesos

    Private vStrCnn As String = My.Settings.sqlConnection

    Private ReadOnly Property getFechaSistema() As String
        Get
            Return Date.Now.ToString
        End Get
    End Property

    Public Function mfHora(ByVal vpHora As DateTime) As Long
        'si fecha1 es mayor entonces retorna -n
        'si fecha1 = fecha2 entonces retorna 0
        'si fecha1 es menor entonces retorna n
        Return DateDiff(DateInterval.Minute, Date.Now, vpHora)

        'Return (Date.Now.Hour.Equals(vpHora.Hour) And Date.Now.Minute.Equals(vpHora.Minute))

    End Function

    Public Function mpGetInternalNumber(ByVal vTienda As String, ByVal vCliente As String, ByVal vSkus As String, ByVal vContrato As String) As String
        Dim vNumber As String
        Dim Util As New Utilities
        Try
            vNumber = ""
            Using Connection As New SqlConnection(vStrCnn)
                Connection.Open()
                Using Command As SqlCommand = Connection.CreateCommand()

                    Command.CommandText = "dbo.SAV_VT_CreaValeVtaPOR"
                    Command.CommandType = CommandType.StoredProcedure

                    '0: Return parameter "RETURN_VALUE" int
                    Dim Parameter As SqlParameter = Command.Parameters.Add("NRO_INTERNO", SqlDbType.Int)
                    Parameter.Direction = ParameterDirection.Output

                    '1: Input parameter "ADAPI_USER_NAME" varchar(40)
                    Parameter = Command.Parameters.Add("TIENDA", SqlDbType.NVarChar, 50)
                    Parameter.Direction = ParameterDirection.Input
                    Parameter.Value = vTienda

                    '2: Input parameter "ADAPI_USER_CODE" varchar(7)
                    Parameter = Command.Parameters.Add("CLIENTE", SqlDbType.NVarChar, 50)
                    Parameter.Direction = ParameterDirection.Input
                    If String.IsNullOrEmpty(vCliente) Then
                        vCliente = ""
                    End If
                    Parameter.Value = vCliente

                    '3: Input parameter "ADAPI_TERM_NAME" varchar(16)
                    Parameter = Command.Parameters.Add("SKUS", SqlDbType.NVarChar, 250)
                    Parameter.Direction = ParameterDirection.Input
                    Parameter.Value = vSkus

                    '3: Input parameter "ADAPI_TERM_NAME" varchar(16)
                    Parameter = Command.Parameters.Add("CONTRATO", SqlDbType.NVarChar, 100)
                    Parameter.Direction = ParameterDirection.Input
                    Parameter.Value = vContrato

                    Using Reader As SqlDataReader = Command.ExecuteReader()
                        If (Reader IsNot Nothing) AndAlso (Reader.FieldCount > 0) Then
                            Do
                            Loop While (Reader.NextResult())
                        End If
                    End Using

                    'Obtain procedure output parameter values
                    vNumber = Command.Parameters("NRO_INTERNO").Value.ToString
                End Using
            End Using
        Catch ex As Exception
            vNumber = ex.Message.ToString
            Util.mpMensaje(ex.Message.ToString & " Error consulta BD", EventLogEntryType.Information, True)
        End Try

        Return vNumber

    End Function

    Public Function mpGetConfirmPayment(ByVal Input As ConfirmPaymentInput) As ImperialGetConfirmPaymentResult
        Dim Util As New Utilities
        Dim ImperialConfirmPaymentResult As New ImperialGetConfirmPaymentResult
        Try
            Using Connection As New SqlConnection(vStrCnn)
                Connection.Open()
                Using Command As SqlCommand = Connection.CreateCommand()

                    Command.CommandText = "dbo.SAV_VT_ValidaValeVtaPOR"
                    Command.CommandType = CommandType.StoredProcedure

                    Dim Parameter As SqlParameter
                    '1: Input parameter "ADAPI_USER_NAME" varchar(40)
                    Parameter = Command.Parameters.Add("TIPO_DOCUMENTO", SqlDbType.NVarChar, 3)
                    Parameter.Direction = ParameterDirection.Input
                    Parameter.Value = Input.tipo_documento

                    '2: Input parameter "ADAPI_USER_CODE" varchar(7)
                    Parameter = Command.Parameters.Add("NRO_IMPRESO", SqlDbType.NVarChar, 10)
                    Parameter.Direction = ParameterDirection.Input
                    Parameter.Value = Input.nro_impreso

                    '3: Input parameter "ADAPI_TERM_NAME" varchar(16)
                    Parameter = Command.Parameters.Add("CODIGO_POR", SqlDbType.NVarChar, 10)
                    Parameter.Direction = ParameterDirection.Input
                    Parameter.Value = Input.codigo_por

                    Using vDr As SqlDataReader = Command.ExecuteReader()

                        If vDr.HasRows Then
                            While vDr.Read
                                ImperialConfirmPaymentResult.TipoDocumento = vDr("TIPO_DOCUMENTO")
                                ImperialConfirmPaymentResult.Nro_Impreso = vDr("NRO_IMPRESO")
                                ImperialConfirmPaymentResult.Total = vDr("TOTAL")
                            End While

                            ImperialConfirmPaymentResult.items = New List(Of PaymentItems)
                            Dim Items As New PaymentItems
                            vDr.NextResult()
                            If vDr.HasRows Then
                                While vDr.Read
                                    Items.numeroLinea = vDr("NRO_LINEA")
                                    Items.sku = vDr("COD_RAPIDO")
                                    Items.descripcion = vDr("DESCRIPCION")
                                    Items.cantidad = vDr("CANTIDAD")
                                    Items.unidad = vDr("UNIDAD")
                                    Items.tipoMoneda = vDr("TIPO_MONEDA")
                                    Items.monto = vDr("TOTAL")
                                    ImperialConfirmPaymentResult.items.Add(Items)
                                End While
                            End If
                            vDr.NextResult()
                            If vDr.HasRows Then
                                While vDr.Read
                                    ImperialConfirmPaymentResult.TipoDocumentoPago = vDr("TIPO_DOCUMENTO_PAGO")
                                    ImperialConfirmPaymentResult.Monto = vDr("MONTO")
                                End While
                            End If
                            vDr.NextResult()
                            If vDr.HasRows Then
                                While vDr.Read
                                    ImperialConfirmPaymentResult.OrdenVenta = vDr("ORDEN_VENTA")
                                    ImperialConfirmPaymentResult.Documento = vDr("DOCUMENTO")
                                    ImperialConfirmPaymentResult.NroDocumento = vDr("NRO_DOCUMENTO")
                                    ImperialConfirmPaymentResult.Channel = vDr("CHANNEL")
                                    ImperialConfirmPaymentResult.Tienda = vDr("TIENDA")
                                    ImperialConfirmPaymentResult.NroContrato = vDr("NRO_CONTRATO")
                                End While
                            End If
                        End If
                    End Using
                End Using
            End Using
            Return ImperialConfirmPaymentResult
        Catch ex As Exception
            Util.mpMensaje(ex.Message.ToString & "-" & ex.StackTrace.ToString & " [mpGetConfirmPayment] Error consulta BD", EventLogEntryType.Information, True)
            Return Nothing
        End Try
    End Function

End Class