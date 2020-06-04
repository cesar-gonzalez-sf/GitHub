
Public MustInherit Class ProcedureCaller

    '++
    ' Returns Nothing if Value is DBNull. Otherwise it returns Value.
    '--
    ''' 
    Protected Overridable Function NullObject(ByVal Value As Object) As Object

        Return If(Convert.IsDBNull(Value), Nothing, Value)

    End Function

End Class