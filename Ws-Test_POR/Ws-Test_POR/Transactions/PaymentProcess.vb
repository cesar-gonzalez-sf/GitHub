Imports System.Net
Imports System.Web.Script.Serialization
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports RestSharp

Public Class PaymentProcess

    Public Function PGetPaymentInfoPOR(ByVal Req As PropertysPaymentInfoRequest, ByRef Res As PropertysPaymentInfoResponse, Optional metodo As Method = Method.POST) As Boolean
        Dim vBand As Boolean = False
        Try
            Dim client = New RestClient(My.Settings.getPaymentInfo)
            Dim request = New RestRequest()

            request.Method = Method.POST

            request.AddHeader("Content-Type", "application/json")
            request.AddHeader("x-ccasset-language", "es")

            Dim UploadObject As New JObject()

            UploadObject.Add("country", Req.country)
            UploadObject.Add("commerce", Req.commerce)
            UploadObject.Add("channel", Req.channel)
            UploadObject.Add("storeId", Req.storeId)
            UploadObject.Add("terminalId", Req.terminalId)
            UploadObject.Add("ordenVenta", Req.ordenVenta)

            Dim postdata As Byte() = System.Text.Encoding.UTF8.GetBytes(UploadObject.ToString)
            request.AddParameter("application/json", postdata, ParameterType.RequestBody)

            Dim response As IRestResponse = client.Execute(request)
            Dim content = response.Content

            Dim jsonObj As New JObject
            Dim deserializedJson As Object = JsonConvert.DeserializeObject(Of Object)(content)

            Dim s As New JavaScriptSerializer()

            Select Case response.StatusCode
                Case HttpStatusCode.OK

                    Res.items = New List(Of PaymentItems)
                    Res.idCliente = deserializedJson("idCliente")

                    Dim itemJson As New PaymentItems

                    Dim listItem As New List(Of PaymentItems)
                    For Each Row In deserializedJson("items")
                        itemJson = New PaymentItems
                        itemJson.monto = Row("monto")
                        itemJson.sku = Row("sku").ToString()

                        'listItem.Add(itemJson)
                        Res.items.Add(itemJson)
                    Next
                    Res.items = listItem

                    vBand = True
                Case Else
                    vBand = False
            End Select
        Catch ex As Exception
            Return vBand
        End Try
        Return vBand
    End Function

    Public Function PConfirmPaymentPOR(Req As ImperialGetConfirmPaymentResult, ByRef Res As ConfirmPaymentResponse, Optional metodo As Method = Method.POST) As Boolean
        Dim vBand As Boolean = False
        Dim Util As New Utilities

        Try
            Dim client = New RestClient(My.Settings.confirmPayment)
            Dim request = New RestRequest()

            request.Method = Method.POST

            request.AddHeader("Content-Type", "application/json")
            request.AddHeader("x-ccasset-language", "es")

            Dim UploadObject As New JObject()


            Dim UploadObjectS As New JObject
            Dim UploadArray As New JArray()

            UploadObject.Add("country", "CL")
            UploadObject.Add("commerce", "IMPERIAL")
            UploadObject.Add("channel", Req.Channel)
            UploadObject.Add("storeId", Req.Tienda)
            UploadObject.Add("terminalId", "01")
            UploadObject.Add("ordenVenta", Req.OrdenVenta)
            UploadObject.Add("tipoDocumento", Req.Documento)
            UploadObject.Add("numeroDocumento", Req.NroDocumento)
            UploadObject.Add("numeroDocTributario", Req.Nro_Impreso)
            UploadObject.Add("montoDoc", Req.Total)


            UploadObjectS.Add(UploadObject)
            For Each vP In Req.items
                UploadObject = New JObject()
                UploadObject.Add("numeroLinea", vP.numeroLinea)
                UploadObject.Add("sku", vP.sku)
                UploadObject.Add("descripcion", vP.descripcion)
                UploadObject.Add("cantidad", vP.cantidad)
                UploadObject.Add("unidad", vP.unidad)
                UploadObject.Add("tipoMoneda", vP.tipoMoneda)
                UploadObject.Add("monto", vP.monto)
                UploadArray.Add(UploadObject)
            Next
            UploadObjectS.Add("items", UploadArray)

            UploadArray = New JArray()
            For Each vP In Req.items
                UploadObject = New JObject()
                UploadObject.Add("tipo", Req.TipoDocumentoPago)
                UploadObject.Add("monto", Req.Monto)
                UploadArray.Add(UploadObject)
            Next
            UploadObjectS.Add("formasPago", UploadArray)

            Util.mpMensaje(UploadObjectS.ToString & "- JSON", EventLogEntryType.Information, True)


            Dim postdata As Byte() = System.Text.Encoding.UTF8.GetBytes(UploadObjectS.ToString)
            request.AddParameter("application/json", postdata, ParameterType.RequestBody)

            Dim response As IRestResponse = client.Execute(request)
            Dim content = response.Content

            Dim jsonObj As New JObject
            Dim deserializedJson As Object = JsonConvert.DeserializeObject(Of Object)(content)

            Dim s As New JavaScriptSerializer()

            Select Case response.StatusCode
                Case HttpStatusCode.OK
                    Res = s.Deserialize(Of ConfirmPaymentResponse)(content)
                    vBand = True
                Case Else
                    vBand = False
            End Select
        Catch ex As Exception
            Util.mpMensaje(ex.Message.ToString & "-" & ex.StackTrace.ToString & " Error envio registro de pago POR", EventLogEntryType.Information, True)
            Return vBand
        End Try
        Return vBand
    End Function

    Friend Function PGetPaymentInfoPOR(res As PropertysPaymentInfoRequest) As Boolean
        Throw New NotImplementedException()
    End Function
End Class

