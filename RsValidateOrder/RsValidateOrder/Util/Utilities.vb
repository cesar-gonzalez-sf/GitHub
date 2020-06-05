Public Class Utilities
    Private ReadOnly Property getFechaSistema() As String
        Get
            Return Date.Now.ToString
        End Get
    End Property
    Public Sub mpMensaje(ByVal vpTexto As String, ByVal vpTipo As EventLogEntryType, Optional ByVal vpEscritura As Boolean = False)
        Try
            If Not String.IsNullOrEmpty(vpTexto.Trim) Then
                If My.Settings.Log Then
                    Dim sw As New System.IO.StreamWriter(My.Settings.LogTrace, True)
                    sw.WriteLine(String.Format("{0,-15}", vpTipo.ToString) & ": - " & "[" & Me.getFechaSistema & "]: - " & vpTexto)
                    sw.Close()
                End If
            End If
        Catch ex As Exception
            System.Diagnostics.EventLog.WriteEntry(My.Settings.Log, "0013-" & ex.Message & " - " & vpTexto, EventLogEntryType.Error)
        End Try
    End Sub

End Class
