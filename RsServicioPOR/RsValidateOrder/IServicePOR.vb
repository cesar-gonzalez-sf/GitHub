<ServiceContract()>
Public Interface IServicePOR

    <OperationContract()>
    <WebInvoke(UriTemplate:="ServicePOR",
               Method:="POST",
               RequestFormat:=WebMessageFormat.Json,
               ResponseFormat:=WebMessageFormat.Json,
               BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Function ServicePOR(ByVal mpGetInternalNumber As PropertysPaymentInfoRequest) As PropertysPaymentInfoResponse

End Interface
