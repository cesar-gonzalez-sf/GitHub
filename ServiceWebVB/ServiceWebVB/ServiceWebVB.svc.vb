Imports System.IO
Imports System.Text
Imports System.Runtime.Serialization
Imports System.Runtime.Serialization.Json
Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json
Imports RestSharp
Imports System.Net
Imports System.Web
Imports System.ServiceModel.Web

Public Class ServicioWebVB
    Implements IServiceWebVB

    Public Function ValidateOrder()

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
    Public Function OptionsServiceWebVB() As InfMetodo Implements IServiceWebVB.OptionsServiceWebVB
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
