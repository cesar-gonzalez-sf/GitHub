Imports OBCOM.EcuLink
Imports System.IO

Module Common

    '++
    ' Retorna un string formateando un text con una lista de argumentos.
    '--
    Public Function Fmt(ByVal Text As String, ByVal ParamArray Args() As Object) As String

        Return String.Format(Text, Args)

    End Function

    '++
    ' Verifica que el nombre del Layout de un Mensaje sea el especificado.
    '--
    Public Sub CheckLayout(ByVal TranName As String, ByVal Message As Message, ByVal LayoutName As String)

        Dim Layout As Layout = Message.Layout

        If (Layout IsNot Nothing) AndAlso (Layout.Name = LayoutName) Then Exit Sub
        Throw New ApplicationException(Fmt("La transacción '{1}' requiere el layout '{2}'", TranName, LayoutName))

    End Sub

    '++
    ' Writes an XML string to the trace directory using the supplied name.
    '--
    Public Sub WriteXmlTrace(ByVal XmlText As String, ByVal XmlName As String)

        If (My.Settings.appTraceXML) Then
            Dim FilePath As String = My.Settings.appTraceDir
            Dim FileName As String = Now.ToString("yyyyMMdd'-'HHmmssfff")
            FilePath = Path.Combine(FilePath, FileName & "-" & XmlName & ".xml")
            Using Stream As New StreamWriter(FilePath)
                Call Stream.WriteLine(XmlText)
            End Using
        End If

    End Sub

End Module
