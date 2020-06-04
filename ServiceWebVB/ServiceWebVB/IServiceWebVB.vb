Imports System.ServiceModel
Imports System.ServiceModel.Web
Imports Microsoft.SqlServer.Management.Smo.Broker

<ServiceContract()>
Public Interface IServiceWebVB

    'Validación de Orden
    <OperationContract()>
    <WebInvoke(UriTemplate:="ServicePOR",
               Method:="POST",
               RequestFormat:=WebMessageFormat.Json,
               ResponseFormat:=WebMessageFormat.Json,
               BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Function ServicePOR(ByVal RequestPOR As PropertysPaymentInfoRequest) As PropertysPaymentInfoResponse

    Function ServicePOR(ByVal ConfirmPOR As ImperialGetConfirmPaymentResult) As ConfirmPaymentResponse

    <WebInvoke(UriTemplate:="ServiceWebVB",
       Method:="OPTIONS",
       ResponseFormat:=WebMessageFormat.Json)>
    Function OptionsServiceWebVB() As InfMetodo

End Interface

