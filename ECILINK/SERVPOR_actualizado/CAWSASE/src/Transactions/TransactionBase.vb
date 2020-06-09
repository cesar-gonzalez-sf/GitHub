Imports OBCOM.EcuLink

Public MustInherit Class TransactionBase
    '++
    ' Declaraciones de variables heredables
    '--
    Protected ReadOnly Server As AppServer

    '++
    ' Construye un nueva instancia.
    '--
    Public Sub New(ByVal Server As AppServer)

        Me.Server = Server

    End Sub

    '++
    ' Todas las transacciones deben implementar (Overrides) este metodo.
    '--
    Public MustOverride Sub ProcessTransaction(ByVal TranName As String, ByVal Message As Message)
End Class
