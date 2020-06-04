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

    Private pchannel As Integer
    Public Property channel() As Integer
        Get
            Return pchannel
        End Get
        Set(ByVal value As Integer)
            pchannel = value
        End Set
    End Property

    Private pstoreId As Integer
    Public Property storeId() As Integer
        Get
            Return pstoreId
        End Get
        Set(ByVal value As Integer)
            pstoreId = value
        End Set
    End Property

    Private pterminalId As Integer
    Public Property terminalId() As Integer
        Get
            Return pterminalId
        End Get
        Set(ByVal value As Integer)
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
