Imports System.IO
Imports System.Text
Imports System.Runtime.Serialization
Imports System.Runtime.Serialization.Json
Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json
Imports RestSharp
Imports System.Net


Public Class ServValidateOrder
    Implements IServicePOR

    Private Sub AgregaHeaderPorCORS()
        'Se agrega headers por CORS
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Methods", "POST")
        HttpContext.Current.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Accept")
    End Sub

    Function ServicePOR(ByVal mpGetInternalNumber As PropertysPaymentInfoRequest) As PropertysPaymentInfoResponse Implements IServicePOR.ServicePOR

        AgregaHeaderPorCORS()

        Dim Resp As New PropertysPaymentInfoResponse

        Dim Proceso As New PaymentProcess

        Dim ClsBd As New ClsProcesos

        Dim Result As Boolean

        Result = Proceso.PGetPaymentInfoPOR(mpGetInternalNumber, Resp)

        Dim ListSku As String
        ListSku = ""
        For Each item As PaymentItems In Resp.items
            ListSku = ListSku & ";" & item.sku & "," & item.monto
        Next

        Dim Nro_interno As String = ""

        Nro_interno = ClsBd.mpGetInternalNumber(mpGetInternalNumber.storeId, "124655757", ListSku, mpGetInternalNumber.ordenVenta)

        If Result Then
            Return Resp
        Else
            Resp.codResponse = 0
            Resp.descResponse = "No hubo respuesta"

            Return Resp
        End If

    End Function
End Class
