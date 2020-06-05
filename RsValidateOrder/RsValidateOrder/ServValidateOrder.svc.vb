Imports System.IO
Imports System.Text
Imports System.Runtime.Serialization
Imports System.Runtime.Serialization.Json
Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json
Imports RestSharp
Imports System.Net


Public Class ServValidateOrder
    Implements IServValidateOrder

    Private Sub AgregaHeaderPorCORS()
        'Se agrega headers por CORS
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", My.Settings.AccessControlAllowOrigin)
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Methods", "POST")
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Accept")
        HttpContext.Current.Response.AddHeader("Access-Control-Max-Age", My.Settings.AccessControlMaxAge)
    End Sub

    Function ServicePOR(ByVal RequestPOR As PropertysPaymentInfoRequest) As PropertysPaymentInfoResponse Implements IServValidateOrder.ServicePOR

        AgregaHeaderPorCORS()

        Dim Resp As New PropertysPaymentInfoResponse

        Dim Proceso As New PaymentProcess

        Dim ClsBd As New ClsProcesos

        Dim Result As Boolean

        Result = Proceso.PGetPaymentInfoPOR(RequestPOR, Resp)

        Dim ListSku As String
        ListSku = ""
        For Each item As PaymentItems In Resp.items
            ListSku = ListSku & ";" & item.sku & "," & item.monto
        Next

        Dim Nro_interno As String = ""

        Nro_interno = ClsBd.mpGetInternalNumber(RequestPOR.storeId, "124655757", ListSku, RequestPOR.ordenVenta)

        If Result Then
            Return Resp
        Else
            Resp.codResponse = 0
            Resp.descResponse = "No hubo respuesta"

            Return Resp
        End If

    End Function
End Class
