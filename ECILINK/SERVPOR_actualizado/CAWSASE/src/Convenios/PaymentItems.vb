Public Class PaymentItems

    Private pnumeroLinea As Integer
    Public Property numeroLinea() As Integer
        Get
            Return pnumeroLinea
        End Get
        Set(ByVal value As Integer)
            pnumeroLinea = value
        End Set
    End Property

    Private psku As String
    Public Property sku() As String
        Get
            Return psku
        End Get
        Set(ByVal value As String)
            psku = value
        End Set
    End Property

    Private pdescripcion As String
    Public Property descripcion() As String
        Get
            Return pdescripcion
        End Get
        Set(ByVal value As String)
            pdescripcion = value
        End Set
    End Property

    Private pcantidad As Double
    Public Property cantidad() As Double
        Get
            Return pcantidad
        End Get
        Set(ByVal value As Double)
            pcantidad = value
        End Set
    End Property

    Private punidad As String
    Public Property unidad() As String
        Get
            Return punidad
        End Get
        Set(ByVal value As String)
            punidad = value
        End Set
    End Property

    Private ptipoMoneda As String
    Public Property tipoMoneda() As String
        Get
            Return ptipoMoneda
        End Get
        Set(ByVal value As String)
            ptipoMoneda = value
        End Set
    End Property

    Private pmonto As Double
    Public Property monto() As Double
        Get
            Return pmonto
        End Get
        Set(ByVal value As Double)
            pmonto = value
        End Set
    End Property




End Class
