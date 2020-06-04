Public Class PropertysPaymentInfoResponse

    Private pcodResponse As Integer
    Public Property codResponse() As Integer
        Get
            Return pcodResponse
        End Get
        Set(ByVal value As Integer)
            pcodResponse = value
        End Set
    End Property

    Private pdescResponse As String
    Public Property descResponse() As String
        Get
            Return pdescResponse
        End Get
        Set(ByVal value As String)
            pdescResponse = value
        End Set
    End Property

    Private pordenVenta As String
    Public Property ordenVenta() As String
        Get
            Return pordenVenta
        End Get
        Set(ByVal value As String)
            pordenVenta = value
        End Set
    End Property

    Private ptipoDocumento As String
    Public Property tipoDocumento() As String
        Get
            Return ptipoDocumento
        End Get
        Set(ByVal value As String)
            ptipoDocumento = value
        End Set
    End Property

    Private ptipoIdCliente As String
    Public Property tipoIdCliente() As String
        Get
            Return ptipoIdCliente
        End Get
        Set(ByVal value As String)
            ptipoIdCliente = value
        End Set
    End Property

    Private pidCliente As String
    Public Property idCliente() As String
        Get
            Return pidCliente
        End Get
        Set(ByVal value As String)
            pidCliente = value
        End Set
    End Property

    Private pitems As List(Of PaymentItems)
    Public Property items() As List(Of PaymentItems)
        Get
            Return pitems
        End Get
        Set(ByVal value As List(Of PaymentItems))
            pitems = value
        End Set
    End Property


End Class