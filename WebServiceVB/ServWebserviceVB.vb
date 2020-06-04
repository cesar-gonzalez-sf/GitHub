Imports System.IO
Imports System.Text
Imports System.Runtime.Serialization
Imports System.Runtime.Serialization.Json
Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json
Imports RestSharp
Imports System.Net


Public Class ServValidateOrder
    Implements IServWebServiceVB

    Public Function ValidateOrder(
        ByVal PONumber As String,
        ByVal amount As String,
        ByVal orderId As String,
        ByVal profile As Profile,
        ByVal transactionId As String,
        ByVal transactionTimestamp As String,
        ByVal organizationId As String,
        ByVal referenceNumber As String,
        ByVal paymentMethod As String,
        ByVal transactionType As String,
        ByVal currencyCode As String,
        ByVal gatewayId As String,
        ByVal organizationName As String,
        ByVal customProperties As CustomProperties,
        ByVal profileDetails As ProfileDetails,
        ByVal gatewaySettings As GatewaySettings,
        ByVal siteId As String,
        ByVal siteURL As String) As Respuesta Implements IServWebServiceVB.ValidateOrder

        Dim Resp As New Respuesta

        Dim Result As New SavCiOraValidaOrdenBcaResult
        'Se deja registro de inicio de proceso de carga en tabla de log
        Dim NombreProceso As String = "RsValidateOrder"
        Dim Status As Integer = 0 'Se inicia proceso
        Dim Valores As String = "Orden: " & orderId
        Dim DescError As String = "Iniciando proceso"
        Dim RequestText As String = ""
        Dim RespuestaText As String = ""
        Dim Log As New SavCiOraRegLogResult

        RequestText = ConvJsonS(Resp, Resp.GetType)

        Log = reglog(NombreProceso, Status, Valores, DescError)

        Try
            'Se agrega headers por CORS
            AgregaHeaderPorCORS()

            If AutenticacionValida() Then
                Dim CodRet As Integer = 0
                Dim TipoEmi As String = ""

                Result = SavCiOraValidaOrdenBcaCaller.Execute(My.Settings.ConnectionString, orderId)
                CodRet = CInt(Result.ReturnValue)
                TipoEmi = Result.TipoEmision

                If (CodRet = 1) Then
                    If (TipoEmi = "Retail") Then
                        For Each Orden As SavCiOraValidaOrdenBcaOrden In Result.Orden
                            Resp.merchantTransactionTimestamp = customProperties._timestamp
                            Resp.currencyCode = currencyCode
                            Resp.transactionId = transactionId
                            Resp.PONumber = PONumber
                            Resp.referenceNumber = referenceNumber
                            Resp.organizationId = organizationId
                            Resp.amount = amount
                            Resp.transactionType = transactionType
                            Resp.siteId = siteId
                            Dim auth As New AuthorizationResponse
                            With auth
                                .hostTransactionId = ""
                                .responseCode = Orden.Responsecode
                                .responseReason = Orden.Responsereason
                                .responseDescription = ""
                                .merchantTransactionId = transactionTimestamp
                            End With
                            Resp.authorizationResponse = auth
                            Dim Custom As New AdditionalProperties
                            With Custom
                                ._method = customProperties._method
                                ._token = customProperties._token
                                ._id = customProperties._id
                                ._url = customProperties._url
                            End With
                            Resp.additionalProperties = Custom
                            Dim vVariable As String()
                            Dim vValor(3) As String
                            vValor(0) = "_method"
                            vValor(1) = "_token"
                            vValor(2) = "_id"
                            vValor(3) = "_url"
                            vVariable = vValor
                            Resp.customPaymentProperties = vVariable
                            Resp.transactionTimestamp = transactionTimestamp
                            Resp.paymentMethod = paymentMethod
                            Resp.orderId = orderId
                            Resp.gatewayId = gatewayId
                        Next
                        Return Resp
                    ElseIf (TipoEmi = "Mayorista") Then
                        For Each Orden As SavCiOraValidaOrdenBcaOrden In Result.Orden
                            Resp.amount = amount
                            Resp.orderId = orderId
                            Dim auth As New AuthorizationResponse
                            With auth
                                .responseReason = "1001"
                                .merchantTransactionId = transactionTimestamp
                                .hostTransactionId = transactionId
                                .responseDescription = ""
                                .responseCode = Orden.Responsecode
                                If (Orden.Responsecode = "1000") Then
                                    .hostResponse = "host-success"
                                Else
                                    .hostResponse = "host-decline"
                                End If
                                .token = "token-success"
                            End With
                            Resp.authorizationResponse = auth
                            Resp.transactionId = transactionId
                            Resp.transactionTimestamp = transactionTimestamp
                            Dim vVariable As String()
                            Dim vValor(3) As String
                            vValor(0) = "_method"
                            vValor(1) = "_token"
                            vValor(2) = "_id"
                            vValor(3) = "_url"
                            vVariable = vValor
                            Resp.customPaymentProperties = vVariable
                            Resp.referenceNumber = referenceNumber
                            Resp.paymentMethod = paymentMethod
                            Dim itemslinks As New List(Of Links)
                            Dim extitemslinks As New Links
                            With extitemslinks
                                extitemslinks.rel = "self"
                                extitemslinks.href = siteURL
                            End With
                            itemslinks.Add(extitemslinks)
                            Resp.links = itemslinks
                            Dim Custom As New AdditionalProperties
                            With Custom
                                ._method = customProperties._method
                                ._token = customProperties._token
                                ._id = customProperties._id
                                ._url = customProperties._url
                            End With
                            Resp.additionalProperties = Custom
                            Resp.currencyCode = currencyCode
                            Resp.gatewayId = gatewayId
                            Resp.merchantTransactionTimestamp = customProperties._timestamp

                            If (Orden.Responsecode = "1000") Then
                                Resp.transactionType = "AUTHORIZE"
                            Else
                                Resp.transactionType = "AUTHORIZE_DECLINE"
                            End If
                            Resp.PONumber = ""
                            Resp.siteId = siteId
                            Resp.organizationId = organizationId

                        Next

                        RespuestaText = ConvJsonS(Resp, Resp.GetType)

                        Log = reglog(NombreProceso, Status, Valores, RespuestaText)

                        Return Resp
                        'ElseIf (TipoEmi = "N") Then
                        '    Resp.authorizationResponse.responseCode = "9000"
                        '    Resp.authorizationResponse.responseReason = "decline"
                        '    Return Resp
                    End If
                Else
                    'Se deja registro de término de proceso de carga en tabla de log
                    Status = 0 'Se finaliza proceso
                    Valores = ""
                    DescError = "Proceso sin resultados"
                    Log = reglog(NombreProceso, Status, Valores, DescError)
                    'Se envía código de respuesta
                    Trace.TraceInformation("Proceso sin resultados")
                    Resp.authorizationResponse.responseCode = "9000"
                    Resp.authorizationResponse.responseReason = "decline"
                    WebOperationContext.Current.OutgoingResponse.StatusCode = System.Net.HttpStatusCode.ExpectationFailed
                End If
            Else
                'Se deja registro de término de proceso de carga en tabla de log
                Status = 0 'Se finaliza proceso
                Valores = ""
                DescError = "Error de autenticación"
                Log = reglog(NombreProceso, Status, Valores, DescError)
                'Se envía código de respuesta
                Resp.authorizationResponse.responseCode = "9000"
                Resp.authorizationResponse.responseReason = "decline"
                WebOperationContext.Current.OutgoingResponse.StatusCode = System.Net.HttpStatusCode.Unauthorized
            End If
            Return Resp
        Catch ex As Exception
            'Se deja registro de término de proceso de carga en tabla de log
            Status = -1 'Se finaliza proceso
            Valores = ""
            DescError = ex.Message
            Log = reglog(NombreProceso, Status, Valores, DescError)
            'Se deja registro en archivo de trace
            Trace.TraceError("Error: " & ex.Message)
            Resp.authorizationResponse.responseCode = "9000"
            Resp.authorizationResponse.responseReason = "decline"
            WebOperationContext.Current.OutgoingResponse.StatusCode = Net.HttpStatusCode.InternalServerError
            Return Resp
        End Try
    End Function

    Private Sub AgregaHeaderPorCORS()
        'Se agrega headers por CORS
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", My.Settings.AccessControlAllowOrigin)
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Methods", "POST")
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Accept")
        HttpContext.Current.Response.AddHeader("Access-Control-Max-Age", My.Settings.AccessControlMaxAge)
    End Sub

    Private Function AutenticacionValida() As Boolean

        Dim Estado As Boolean = True
        Dim AuthHeader As String = HttpContext.Current.Request.Headers.Item("Authorization")

        If Not IsNothing(AuthHeader) Then
            'Basic YWRtaW46RUt4aWxFQi9sdWZ3VWRoeWdtc3E5NEVSNkljPQ==
            If (Left(AuthHeader, 5) = "Basic") Then
                Dim Auth As String = Mid(AuthHeader, 7, Len(AuthHeader))
                Dim Authorization As String = Encoding.Default.GetString(Convert.FromBase64String(Auth))
                'Dim txt As String = Encoding.UTF8.GetString(requestBytes)
                Dim tokens() As String = Authorization.Split(CType(":", Char()))
                Dim username As String = tokens(0)
                Dim password As String = tokens(1)

                'Se valida usuario y credencial
                Dim RespAuth As Integer = AutenticarUsuario(username, password)
                If (RespAuth = 1) Then Estado = True
            End If
        End If
        Return Estado
    End Function

    'Se entrega información del metodo POST
    Public Function OptionsValidateOrder() As InfMetodo Implements IServWebServiceVB.OptionsValidateOrder
        'Se agrega headers por CORS
        AgregaHeaderPorCORS()

        Dim OrderID As Information = New Information
        OrderID.Codigo = "OrderId"
        OrderID.Descripcion = "Id de la cotizacion"
        OrderID.Tipo = "String"
        OrderID.Requerido = True
        Dim Parametros As New List(Of Information)
        Parametros.Add(OrderID)
        Dim Inf As InfMetodo = New InfMetodo()
        Inf.Metodo = "POST"
        Inf.Metodo_Descripcion = "Recibe información para validar una orden. Ver " & My.Settings.OraclePayURL
        Inf.Parametros = Parametros
        Inf.RequestFormat = "application/json"
        Inf.ResponseFormat = "application/json"
        Return Inf
    End Function

    Function ConvJsonS(ByVal ObjectJson As Object, ByVal ObjectType As Type) As String
        Dim JS As String = ""
        Try
            Dim StreamO As MemoryStream = New MemoryStream()
            Dim OSer As DataContractJsonSerializer = New DataContractJsonSerializer(ObjectType)
            OSer.WriteObject(StreamO, ObjectJson)
            StreamO.Position = 0
            Dim srO As StreamReader = New StreamReader(StreamO)
            JS = srO.ReadToEnd()
            Return JS
        Catch ex As Exception
            Throw ex
            Return JS
        End Try
    End Function
End Class
