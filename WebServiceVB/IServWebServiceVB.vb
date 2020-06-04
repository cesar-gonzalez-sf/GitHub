<ServiceContract()>
Public Interface IServWebServiceVB

    'Validación de Orden
    <OperationContract()>
    <WebInvoke(UriTemplate:="ValidateOrder",
               Method:="POST",
               RequestFormat:=WebMessageFormat.Json,
               ResponseFormat:=WebMessageFormat.Json,
               BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Function ValidateOrder(
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
        ByVal siteURL As String) As Respuesta

    <WebInvoke(UriTemplate:="ValidateOrder",
       Method:="OPTIONS",
       ResponseFormat:=WebMessageFormat.Json)>
    Function OptionsValidateOrder() As InfMetodo

End Interface
