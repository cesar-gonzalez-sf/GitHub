Imports OBCOM.EcuLink

Public Class ConfirmPayment : Inherits TransactionBase

    '++
    ' Construye un nueva instancia.
    '--
    Public Sub New(ByVal Server As AppServer)

        Call MyBase.New(Server)

    End Sub

    Public Overrides Sub ProcessTransaction(ByVal TranName As String, ByVal Request As Message)

        Dim vTipo_Documento As String
        Dim vNro_Impreso As String
        Dim vCodigo_Por As String


        Dim vRes As New PaymentProcess
        Dim Process As New ClsProcesos
        Dim Util As New Utilities
        Dim vMessage As String

        Try
            vMessage = "No se pudo registrar pago, favor dirigirse a meson de arriendo de herramientas para registro manual"

            Dim vCodigo As Integer
            vCodigo = 0

            'Verificamos que el layout del mensaje sea el correcto
            Call CheckLayout(TranName, Request, "SERVPOR_REGISTRAPAGO_E")

            vTipo_Documento = Request.GetString("TIPO_DOCUMENTO")
            vNro_Impreso = Request.GetString("NRO_IMPRESO")
            vCodigo_Por = Request.GetString("CODIGO_POR")


            'Se valida convenio de arriendo            
            Dim Input As New ConfirmPaymentInput
            Dim Res As New ConfirmPaymentResponse


            Input.tipo_documento = vTipo_Documento
            Input.nro_impreso = vNro_Impreso
            Input.codigo_por = vCodigo_Por

            Dim ImperialConfirmPaymentResult = Process.mpGetConfirmPayment(Input) '


            If Not ImperialConfirmPaymentResult Is Nothing Then
                If vRes.PConfirmPaymentPOR(ImperialConfirmPaymentResult, Res) Then
                    vMessage = ""
                    vCodigo = 1
                End If
            End If

            ''Create and initialize reply message
            Dim Reply As New Message()

            Reply.Layout = Server.GetLayout("SERVPOR_REGISTRAPAGO_S")
            Reply.InitFields()

            Reply.SetString("CODIGO", vCodigo)
            Reply.SetString("MESSAGE", vMessage)

            ''Send ACK reply message
            Server.SendAckReply(Reply)

        Catch ex As Exception
            Dim Reply As New Message()
            Reply.Layout = Server.GetLayout("SERVPOR_REGISTRAPAGO_S")
            Reply.InitFields()
            Reply.SetString("CODIGO", 0)
            vMessage = "No se pudo registrar pago, favor dirigirse a meson de arriendo de herramientas para registro manual"
            Reply.SetString("MESSAGE", vMessage)
            Util.mpMensaje(ex.Message.ToString & " Error Aplicacion de Servicio (Registra Pago)", EventLogEntryType.Information, True)
            Server.SendAckReply(Reply)
        End Try

    End Sub

End Class
