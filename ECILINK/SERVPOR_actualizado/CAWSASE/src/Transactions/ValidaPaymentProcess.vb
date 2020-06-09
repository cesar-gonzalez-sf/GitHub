Imports OBCOM.EcuLink

Public Class ValidaPaymentProcess : Inherits TransactionBase
    '++
    ' Construye un nueva instancia.
    '--
    Public Sub New(ByVal Server As AppServer)

        Call MyBase.New(Server)

    End Sub


    '++
    ' Llamada cuando se recibe una transaccion ".......".
    '--
    Public Overrides Sub ProcessTransaction(ByVal TranName As String, ByVal Request As Message)

        Dim vCOUNTRY As String
        Dim vCommerce As String
        Dim vChannel As String
        Dim vStoreid As String
        Dim vTerminalid As String
        Dim vOrdenVenta As String

        Dim vRes As New PaymentProcess
        Dim Process As New ClsProcesos
        Dim Util As New Utilities

        Try
            Dim vMessage As String
            vMessage = ""

            'Verificamos que el layout del mensaje sea el correcto
            Call CheckLayout(TranName, Request, "SERVPOR_OBTIENEPAGO_E")

            vCOUNTRY = Request.GetString("COUNTRY")
            vCommerce = Request.GetString("COMMERCE")
            vChannel = Request.GetString("CHANNEL")
            vStoreid = Request.GetString("STOREID")
            vTerminalid = Request.GetString("TERMINALID")
            vOrdenVenta = Request.GetString("ORDENVENTA")

            'Se valida convenio de arriendo            
            Dim Req As New PropertysPaymentInfoRequest
            Dim Res As New PropertysPaymentInfoResponse

            Req.country = vCOUNTRY
            Req.commerce = vCommerce
            Req.channel = vChannel
            Req.storeId = vStoreid
            Req.ordenVenta = vOrdenVenta

            'Res.items = New List(Of PaymentItems)
            If Not vRes.PGetPaymentInfoPOR(Req, Res) Then
                vMessage = "Error en la Consulta"
            End If

            ''Create and initialize reply message
            Dim Reply As New Message()

            Reply.Layout = Server.GetLayout("SERVPOR_OBTIENEPAGO_S")
            Reply.InitFields()

            Dim ListSku As String
            ListSku = ""
            For Each item As PaymentItems In Res.items
                ListSku = ListSku & ";" & item.sku & "," & item.monto
            Next

            Dim InternalNumer As String
            InternalNumer = Process.mpGetInternalNumber(Req.storeId, Res.idCliente, ListSku, Req.ordenVenta) ' --> Nro_Interno

            Reply.SetString("INTERNALNUMBER", InternalNumer)
            Reply.SetString("MESSAGE", vMessage)

            ''Send ACK reply message
            Server.SendAckReply(Reply)

        Catch ex As Exception
            Dim Reply As New Message()
            Reply.Layout = Server.GetLayout("SERVPOR_OBTIENEPAGO_S")
            Reply.InitFields()
            Reply.SetString("INTERNALNUMBER", 0)
            Reply.SetString("MESSAGE", ex.Message.ToString)
            Util.mpMensaje(ex.Message.ToString & " Error Aplicacion de Servicio (Obtiene Pago)", EventLogEntryType.Information, True)
            Server.SendAckReply(Reply)
        End Try

    End Sub

End Class
