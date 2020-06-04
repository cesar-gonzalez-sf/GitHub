Imports System.ServiceModel

<ServiceContract()>
Public Interface IServiceWeb

    'Validación de Orden
    <OperationContract()>
    <WebInvoke(UriTemplate:="ServiceWeb",
               Method:="POST",
               RequestFormat:=WebMessageFormat.Json,
               ResponseFormat:=WebMessageFormat.Json,
               BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Function ValidateOrder(

                          ) As Respuesta

    <WebInvoke(UriTemplate:="ValidateOrder",
       Method:="OPTIONS",
       ResponseFormat:=WebMessageFormat.Json)>
    Function OptionsValidateOrder() As InfMetodo

End Interface
