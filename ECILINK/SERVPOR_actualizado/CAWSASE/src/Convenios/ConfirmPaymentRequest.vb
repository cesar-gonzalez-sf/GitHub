Imports Newtonsoft.Json.Linq

Public Class ConfirmPaymentRequest


    Private pcodigo As Integer
    Public Property codigo() As Integer
        Get
            Return pcodigo
        End Get
        Set(ByVal value As Integer)
            pcodigo = value
        End Set
    End Property

    Private pmessage As String
    Public Property message() As String
        Get
            Return pmessage
        End Get
        Set(ByVal value As String)
            pmessage = value
        End Set
    End Property
End Class
