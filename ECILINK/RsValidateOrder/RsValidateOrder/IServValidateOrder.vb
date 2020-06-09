<ServiceContract()>
Public Interface IServValidateOrder

    <OperationContract()>
    <WebInvoke(UriTemplate:="ServicePOR",
               Method:="POST",
               RequestFormat:=WebMessageFormat.Json,
               ResponseFormat:=WebMessageFormat.Json,
               BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Function ServicePOR() As Boolean

End Interface
