Public Class ConfirmPaymentInput
    Private ptipo_documento As String
    Public Property tipo_documento() As String
        Get
            Return ptipo_documento
        End Get
        Set(ByVal value As String)
            ptipo_documento = value
        End Set
    End Property

    Private pnro_impreso As String
    Public Property nro_impreso() As String
        Get
            Return pnro_impreso
        End Get
        Set(ByVal value As String)
            pnro_impreso = value
        End Set
    End Property

    Private pcodigo_por As String
    Public Property codigo_por() As String
        Get
            Return pcodigo_por
        End Get
        Set(ByVal value As String)
            pcodigo_por = value
        End Set
    End Property
End Class
