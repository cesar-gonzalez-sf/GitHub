﻿'------------------------------------------------------------------------------
' <auto-generated>
'     Este código fue generado por una herramienta.
'     Versión de runtime:4.0.30319.42000
'
'     Los cambios en este archivo podrían causar un comportamiento incorrecto y se perderán si
'     se vuelve a generar el código.
' </auto-generated>
'------------------------------------------------------------------------------

Option Strict Off
Option Explicit On

Imports System
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Xml.Serialization

'
'Microsoft.VSDesigner generó automáticamente este código fuente, versión=4.0.30319.42000.
'
Namespace wsAvisoImpago
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.8.3752.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Web.Services.WebServiceBindingAttribute(Name:="wsAvisoImpagoSoap", [Namespace]:="http://tempuri.org/wsAvisoImpago/Service1")>  _
    Partial Public Class wsAvisoImpago
        Inherits System.Web.Services.Protocols.SoapHttpClientProtocol
        
        Private CallwsAvisoImpagoOperationCompleted As System.Threading.SendOrPostCallback
        
        Private useDefaultCredentialsSetExplicitly As Boolean
        
        '''<remarks/>
        Public Sub New()
            MyBase.New
            Me.Url = Global.SERVPOR.My.MySettings.Default.SRVPOL_wsAvisoImpago_wsAvisoImpago
            If (Me.IsLocalFileSystemWebService(Me.Url) = true) Then
                Me.UseDefaultCredentials = true
                Me.useDefaultCredentialsSetExplicitly = false
            Else
                Me.useDefaultCredentialsSetExplicitly = true
            End If
        End Sub
        
        Public Shadows Property Url() As String
            Get
                Return MyBase.Url
            End Get
            Set
                If (((Me.IsLocalFileSystemWebService(MyBase.Url) = true)  _
                            AndAlso (Me.useDefaultCredentialsSetExplicitly = false))  _
                            AndAlso (Me.IsLocalFileSystemWebService(value) = false)) Then
                    MyBase.UseDefaultCredentials = false
                End If
                MyBase.Url = value
            End Set
        End Property
        
        Public Shadows Property UseDefaultCredentials() As Boolean
            Get
                Return MyBase.UseDefaultCredentials
            End Get
            Set
                MyBase.UseDefaultCredentials = value
                Me.useDefaultCredentialsSetExplicitly = true
            End Set
        End Property
        
        '''<remarks/>
        Public Event CallwsAvisoImpagoCompleted As CallwsAvisoImpagoCompletedEventHandler
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://tempuri.org/wsAvisoImpago/Service1/wsAvisoImpago", RequestElementName:="wsAvisoImpago", RequestNamespace:="http://tempuri.org/wsAvisoImpago/Service1", ResponseElementName:="wsAvisoImpagoResponse", ResponseNamespace:="http://tempuri.org/wsAvisoImpago/Service1", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function CallwsAvisoImpago(ByVal nPoliza As Integer, ByVal sEmpresa As String, ByVal sUsuario As String, ByVal sContrasena As String, ByVal sRutSR As String, ByVal sNombreSR As String, ByVal sPaisSR As String, ByVal nCantDoctos As Integer, ByVal sNumDocto As String, ByVal sMoneda As String, ByVal nMonto As Double, ByVal sFecEmision As String, ByVal sFecVence As String, ByVal sObservacion As String) As <System.Xml.Serialization.XmlElementAttribute("wsAvisoImpagoResult")> clsAviso
            Dim results() As Object = Me.Invoke("CallwsAvisoImpago", New Object() {nPoliza, sEmpresa, sUsuario, sContrasena, sRutSR, sNombreSR, sPaisSR, nCantDoctos, sNumDocto, sMoneda, nMonto, sFecEmision, sFecVence, sObservacion})
            Return CType(results(0),clsAviso)
        End Function
        
        '''<remarks/>
        Public Overloads Sub CallwsAvisoImpagoAsync(ByVal nPoliza As Integer, ByVal sEmpresa As String, ByVal sUsuario As String, ByVal sContrasena As String, ByVal sRutSR As String, ByVal sNombreSR As String, ByVal sPaisSR As String, ByVal nCantDoctos As Integer, ByVal sNumDocto As String, ByVal sMoneda As String, ByVal nMonto As Double, ByVal sFecEmision As String, ByVal sFecVence As String, ByVal sObservacion As String)
            Me.CallwsAvisoImpagoAsync(nPoliza, sEmpresa, sUsuario, sContrasena, sRutSR, sNombreSR, sPaisSR, nCantDoctos, sNumDocto, sMoneda, nMonto, sFecEmision, sFecVence, sObservacion, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub CallwsAvisoImpagoAsync(ByVal nPoliza As Integer, ByVal sEmpresa As String, ByVal sUsuario As String, ByVal sContrasena As String, ByVal sRutSR As String, ByVal sNombreSR As String, ByVal sPaisSR As String, ByVal nCantDoctos As Integer, ByVal sNumDocto As String, ByVal sMoneda As String, ByVal nMonto As Double, ByVal sFecEmision As String, ByVal sFecVence As String, ByVal sObservacion As String, ByVal userState As Object)
            If (Me.CallwsAvisoImpagoOperationCompleted Is Nothing) Then
                Me.CallwsAvisoImpagoOperationCompleted = AddressOf Me.OnCallwsAvisoImpagoOperationCompleted
            End If
            Me.InvokeAsync("CallwsAvisoImpago", New Object() {nPoliza, sEmpresa, sUsuario, sContrasena, sRutSR, sNombreSR, sPaisSR, nCantDoctos, sNumDocto, sMoneda, nMonto, sFecEmision, sFecVence, sObservacion}, Me.CallwsAvisoImpagoOperationCompleted, userState)
        End Sub
        
        Private Sub OnCallwsAvisoImpagoOperationCompleted(ByVal arg As Object)
            If (Not (Me.CallwsAvisoImpagoCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent CallwsAvisoImpagoCompleted(Me, New CallwsAvisoImpagoCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
            End If
        End Sub
        
        '''<remarks/>
        Public Shadows Sub CancelAsync(ByVal userState As Object)
            MyBase.CancelAsync(userState)
        End Sub
        
        Private Function IsLocalFileSystemWebService(ByVal url As String) As Boolean
            If ((url Is Nothing)  _
                        OrElse (url Is String.Empty)) Then
                Return false
            End If
            Dim wsUri As System.Uri = New System.Uri(url)
            If ((wsUri.Port >= 1024)  _
                        AndAlso (String.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) = 0)) Then
                Return true
            End If
            Return false
        End Function
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.8.3752.0"),  _
     System.SerializableAttribute(),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://tempuri.org/wsAvisoImpago/Service1")>  _
    Partial Public Class clsAviso
        
        Private nPolizaField As Integer
        
        Private sUsuarioField As String
        
        Private sResultadoField As String
        
        Private dFechaSolField As String
        
        Private cAseguradoField As clsPersona
        
        Private cSujetoField As clsPersona
        
        '''<remarks/>
        Public Property nPoliza() As Integer
            Get
                Return Me.nPolizaField
            End Get
            Set
                Me.nPolizaField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sUsuario() As String
            Get
                Return Me.sUsuarioField
            End Get
            Set
                Me.sUsuarioField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sResultado() As String
            Get
                Return Me.sResultadoField
            End Get
            Set
                Me.sResultadoField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property dFechaSol() As String
            Get
                Return Me.dFechaSolField
            End Get
            Set
                Me.dFechaSolField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property cAsegurado() As clsPersona
            Get
                Return Me.cAseguradoField
            End Get
            Set
                Me.cAseguradoField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property cSujeto() As clsPersona
            Get
                Return Me.cSujetoField
            End Get
            Set
                Me.cSujetoField = value
            End Set
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.8.3752.0"),  _
     System.SerializableAttribute(),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://tempuri.org/wsAvisoImpago/Service1")>  _
    Partial Public Class clsPersona
        
        Private nCodigoField As Integer
        
        Private nRutField As Integer
        
        Private sDvField As String
        
        Private sTipoPersonaField As String
        
        Private sNombreField As String
        
        Private sDireccionField As String
        
        Private sCiudadField As String
        
        Private sPaisField As String
        
        '''<remarks/>
        Public Property nCodigo() As Integer
            Get
                Return Me.nCodigoField
            End Get
            Set
                Me.nCodigoField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property nRut() As Integer
            Get
                Return Me.nRutField
            End Get
            Set
                Me.nRutField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sDv() As String
            Get
                Return Me.sDvField
            End Get
            Set
                Me.sDvField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sTipoPersona() As String
            Get
                Return Me.sTipoPersonaField
            End Get
            Set
                Me.sTipoPersonaField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sNombre() As String
            Get
                Return Me.sNombreField
            End Get
            Set
                Me.sNombreField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sDireccion() As String
            Get
                Return Me.sDireccionField
            End Get
            Set
                Me.sDireccionField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sCiudad() As String
            Get
                Return Me.sCiudadField
            End Get
            Set
                Me.sCiudadField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sPais() As String
            Get
                Return Me.sPaisField
            End Get
            Set
                Me.sPaisField = value
            End Set
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.8.3752.0")>  _
    Public Delegate Sub CallwsAvisoImpagoCompletedEventHandler(ByVal sender As Object, ByVal e As CallwsAvisoImpagoCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.8.3752.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class CallwsAvisoImpagoCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As clsAviso
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),clsAviso)
            End Get
        End Property
    End Class
End Namespace