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

    Function ServicePOR() As Boolean Implements IServValidateOrder.ServicePOR


        Dim vRes As New PaymentProcess
        Dim Process As New ClsProcesos
        Dim Util As New Utilities
        Dim vMessage As String

        Try
            vMessage = "No se pudo registrar pago, favor dirigirse a meson de arriendo de herramientas para registro manual"

            Dim vCodigo As Integer
            vCodigo = 0


            'Se valida convenio de arriendo            
            Dim Input As New ConfirmPaymentInput
            Dim Res As New ConfirmPaymentResponse

            Input.tipo_documento = "BLV"
            Input.nro_impreso = "0000013488"
            Input.codigo_por = "21358000373"

            Dim ImperialConfirmPaymentResult = Process.mpGetConfirmPayment(Input) '


            If Not ImperialConfirmPaymentResult Is Nothing Then
                If vRes.PConfirmPaymentPOR(ImperialConfirmPaymentResult, Res) Then
                    vMessage = ""
                    vCodigo = 1
                End If
            End If



        Catch ex As Exception

        End Try

        Return True

    End Function
End Class
