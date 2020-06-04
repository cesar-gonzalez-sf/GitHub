Public Class ImperialGetConfirmPaymentResult
    Private pTipoDoumento As String
    Public Property TipoDocumento() As String
        Get
            Return pTipoDoumento
        End Get
        Set(ByVal value As String)
            pTipoDoumento = value
        End Set
    End Property

    Private pNro_Impreso As String
    Public Property Nro_Impreso() As String
        Get
            Return pNro_Impreso
        End Get
        Set(ByVal value As String)
            pNro_Impreso = value
        End Set
    End Property

    Private pTotal As String
    Public Property Total() As String
        Get
            Return pTotal
        End Get
        Set(ByVal value As String)
            pTotal = value
        End Set
    End Property

    Private pTipoDocumentoPago As String
    Public Property TipoDocumentoPago() As String
        Get
            Return pTipoDocumentoPago
        End Get
        Set(ByVal value As String)
            pTipoDocumentoPago = value
        End Set
    End Property

    Private pMonto As String
    Public Property Monto() As String
        Get
            Return pMonto
        End Get
        Set(ByVal value As String)
            pMonto = value
        End Set
    End Property

    Private pOrdenVenta As String
    Public Property OrdenVenta() As String
        Get
            Return pOrdenVenta
        End Get
        Set(ByVal value As String)
            pOrdenVenta = value
        End Set
    End Property

    Private pChannel As String
    Public Property Channel() As String
        Get
            Return pChannel
        End Get
        Set(ByVal value As String)
            pChannel = value
        End Set
    End Property

    Private pTienda As String
    Public Property Tienda() As String
        Get
            Return pTienda
        End Get
        Set(ByVal value As String)
            pTienda = value
        End Set
    End Property

    Private pNroContrato As String
    Public Property NroContrato() As String
        Get
            Return pNroContrato
        End Get
        Set(ByVal value As String)
            pNroContrato = value
        End Set
    End Property

    Private pNroDocumento As String
    Public Property NroDocumento() As String
        Get
            Return pNroDocumento
        End Get
        Set(ByVal value As String)
            pNroDocumento = value
        End Set
    End Property

    Private pDocumento As String
    Public Property Documento() As String
        Get
            Return pDocumento
        End Get
        Set(ByVal value As String)
            pDocumento = value
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
