Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports System.ServiceModel.Web

' Para permitir que se llame a este servicio web desde un script, usando ASP.NET AJAX, quite la marca de comentario de la línea siguiente.
<System.Web.Script.Services.ScriptService()>
<System.Web.Services.WebService(Namespace:="http://tempuri.org/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class ws_test_por
    Inherits System.Web.Services.WebService

    <WebMethod()>
    Public Function HelloWorld() As String
        Return "Hola a todos"
    End Function

    <WebMethod()>
    <WebInvoke(UriTemplate:="ServicioPOR",
                Method:="POST",
                RequestFormat:=WebMessageFormat.Json,
                ResponseFormat:=WebMessageFormat.Json,
                BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Public Function ServicioPOR(ByVal RequestPOR As PropertysPaymentInfoRequest) As PropertysPaymentInfoResponse

    End Function

End Class