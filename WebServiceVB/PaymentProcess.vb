Imports System.Net
Imports System.Web.Script.Serialization
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports RestSharp
Imports ApiRest

Public Class PaymentProcess

    Public Function PGetPaymentInfoPOR(ByVal Req As PropertysPaymentInfoRequest, ByRef Res As PropertysPaymentInfoResponse, Optional metodo As Method = Method.GET) As Boolean
        Dim vBand As Boolean = False
        Try
            Dim client = New RestClient("https://api-sodimac-pgs.buffetcloud.io")
            Dim request = New RestRequest()
            request.Resource = "/pgs-dte-testing/api/imp/payments/getPaymentInfo"

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
                    Res = s.Deserialize(Of PropertysPaymentInfoResponse)(content)
                    vBand = True
                Case Else
                    vBand = False
            End Select
        Catch ex As Exception
            Return vBand
        End Try
        Return vBand
    End Function

End Class
