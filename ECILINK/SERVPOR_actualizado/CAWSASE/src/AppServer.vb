
Imports OBCOM.EcuLink

Public Class AppServer : Inherits ServerLink

    '++
    ' Construye un nueva instancia.
    '--
    Public Sub New()

        Call MyBase.New()

    End Sub

    '++
    ' Llamada cuando el servidor debe inicializarse o reinicializarse.
    '--
    Protected Overrides Sub ProcessInit(ByVal Initialize As Boolean)

        'Registramos las transacciones del servidor

        Call RegisterTransaction("wsConsultaPagoPOR" _
                , AddressOf New ValidaPaymentProcess(Me).ProcessTransaction)

        Call RegisterTransaction("wsRegistraPagoPOR" _
                , AddressOf New ConfirmPayment(Me).ProcessTransaction)

        'Listos para recibir transacciones
        Call ReleaseHold()

    End Sub

    '-----------------------------------------------------------------------
    '-- Transacciones ------------------------------------------------------
    '-----------------------------------------------------------------------

    '++
    ' Llamada justo despues de ejecutar una transaccion exitosa.
    '--
    Protected Overrides Sub CommitTransaction(ByVal TranName As String, ByVal Context As Object)

        'Verificamos que se retorno una respuesta
        If (Me.ReplyMissing) Then
            Throw New ApplicationException(Fmt("La transaccion {0} no retornó respuesta", TranName))
        End If

    End Sub

    '++
    ' Llamada justo despues de ejecutar una transaccion fallida.
    '--
    Protected Overrides Sub RollbackTransaction(ByVal TranName As String, ByVal Context As Object, ByVal Exception As Exception)

        'Grabamos mensaje de error de la transaccion
        My.Application.Log.WriteException(Exception, TraceEventType.Error, _
        Fmt("Durante el procesamiento de la transaccion {0}", TranName))

        '172.27.0.25,10102
        'file:///.\layouts\*.asp
        'Retornamos respuesta NAK al cliente
        Call SendNakReply(Exception.Message)

    End Sub

    '-----------------------------------------------------------------------
    '-- Procedimiento Principal --------------------------------------------
    '-----------------------------------------------------------------------

    Public Shared Function Main(ByVal Args() As String) As Integer

        Dim Server As AppServer

        Try
            'Obtenemos el nombre del servidor
            Dim ServerName As String = My.Settings.appServerName
            If (Args.Length > 0) Then ServerName = Args(0)

            'Iniciamos la ejecucion del servidor
            Server = New AppServer
            Call Server.Execute(ServerName, My.Settings.ecuIpPort, My.Settings.ecuLayoutsURL)

            Return 0
        Catch ex As Exception
            My.Application.Log.WriteException(ex)
            Return 1
        End Try

    End Function

End Class
