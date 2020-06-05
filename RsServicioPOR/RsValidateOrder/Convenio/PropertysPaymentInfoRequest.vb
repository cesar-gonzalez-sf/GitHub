Public Class PropertysPaymentInfoRequest

    Private pcountry As String
    Public Property country() As String
        Get
            Return pcountry
        End Get
        Set(ByVal value As String)
            pcountry = value
        End Set
    End Property

    Private pcommerce As String
    Public Property commerce() As String
        Get
            Return pcommerce
        End Get
        Set(ByVal value As String)
            pcommerce = value
        End Set
    End Property

    Private pchannel As String
    Public Property channel() As String
        Get
            Return pchannel
        End Get
        Set(ByVal value As String)
            pchannel = value
        End Set
    End Property

    Private pstoreId As String
    Public Property storeId() As String
        Get
            Return pstoreId
        End Get
        Set(ByVal value As String)
            pstoreId = value
        End Set
    End Property

    Private pterminalId As String
    Public Property terminalId() As String
        Get
            Return pterminalId
        End Get
        Set(ByVal value As String)
            pterminalId = value
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
End Class
