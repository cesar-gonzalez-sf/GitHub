<ServiceContract()>
Public Interface IServValidateOrder

    <OperationContract()>
    <WebInvoke(UriTemplate:="ServicePOR",
               Method:="POST",
               RequestFormat:=WebMessageFormat.Json,
               ResponseFormat:=WebMessageFormat.Json,
               BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Function ServicePOR(ByVal RequestPOR As PropertysPaymentInfoRequest) As PropertysPaymentInfoResponse

End Interface
