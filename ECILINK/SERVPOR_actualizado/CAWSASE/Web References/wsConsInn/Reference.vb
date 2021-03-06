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
Namespace wsConsInn
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.8.3752.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Web.Services.WebServiceBindingAttribute(Name:="ConsInnominadoSoap", [Namespace]:="http://localhost/Extranet/WebServices")>  _
    Partial Public Class ConsInnominado
        Inherits System.Web.Services.Protocols.SoapHttpClientProtocol
        
        Private wsConsInnOperationCompleted As System.Threading.SendOrPostCallback
        
        Private useDefaultCredentialsSetExplicitly As Boolean
        
        '''<remarks/>
        Public Sub New()
            MyBase.New
            Me.Url = Global.SERVPOR.My.MySettings.Default.SRVPOL_wsConsInn_ConsInnominado
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
        Public Event wsConsInnCompleted As wsConsInnCompletedEventHandler
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://localhost/Extranet/WebServices/wsConsInn", RequestNamespace:="http://localhost/Extranet/WebServices", ResponseNamespace:="http://localhost/Extranet/WebServices", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function wsConsInn(ByVal sLocal As String, ByVal nPoliza As Integer, ByVal sEmpresa As String, ByVal sUsuario As String, ByVal sContrasena As String, ByVal sRutSR As String, ByVal sNombreSR As String, ByVal sDireccionSR As String, ByVal sCiudadSR As String, ByVal sCodigo As String) As clsConsInn
            Dim results() As Object = Me.Invoke("wsConsInn", New Object() {sLocal, nPoliza, sEmpresa, sUsuario, sContrasena, sRutSR, sNombreSR, sDireccionSR, sCiudadSR, sCodigo})
            Return CType(results(0),clsConsInn)
        End Function
        
        '''<remarks/>
        Public Overloads Sub wsConsInnAsync(ByVal sLocal As String, ByVal nPoliza As Integer, ByVal sEmpresa As String, ByVal sUsuario As String, ByVal sContrasena As String, ByVal sRutSR As String, ByVal sNombreSR As String, ByVal sDireccionSR As String, ByVal sCiudadSR As String, ByVal sCodigo As String)
            Me.wsConsInnAsync(sLocal, nPoliza, sEmpresa, sUsuario, sContrasena, sRutSR, sNombreSR, sDireccionSR, sCiudadSR, sCodigo, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub wsConsInnAsync(ByVal sLocal As String, ByVal nPoliza As Integer, ByVal sEmpresa As String, ByVal sUsuario As String, ByVal sContrasena As String, ByVal sRutSR As String, ByVal sNombreSR As String, ByVal sDireccionSR As String, ByVal sCiudadSR As String, ByVal sCodigo As String, ByVal userState As Object)
            If (Me.wsConsInnOperationCompleted Is Nothing) Then
                Me.wsConsInnOperationCompleted = AddressOf Me.OnwsConsInnOperationCompleted
            End If
            Me.InvokeAsync("wsConsInn", New Object() {sLocal, nPoliza, sEmpresa, sUsuario, sContrasena, sRutSR, sNombreSR, sDireccionSR, sCiudadSR, sCodigo}, Me.wsConsInnOperationCompleted, userState)
        End Sub
        
        Private Sub OnwsConsInnOperationCompleted(ByVal arg As Object)
            If (Not (Me.wsConsInnCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent wsConsInnCompleted(Me, New wsConsInnCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
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
     System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://localhost/Extranet/WebServices")>  _
    Partial Public Class clsConsInn
        
        Private sFechaConsField As String
        
        Private sCodRespField As String
        
        Private sDesRespField As String
        
        '''<remarks/>
        Public Property sFechaCons() As String
            Get
                Return Me.sFechaConsField
            End Get
            Set
                Me.sFechaConsField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sCodResp() As String
            Get
                Return Me.sCodRespField
            End Get
            Set
                Me.sCodRespField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sDesResp() As String
            Get
                Return Me.sDesRespField
            End Get
            Set
                Me.sDesRespField = value
            End Set
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.8.3752.0")>  _
    Public Delegate Sub wsConsInnCompletedEventHandler(ByVal sender As Object, ByVal e As wsConsInnCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.8.3752.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class wsConsInnCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As clsConsInn
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),clsConsInn)
            End Get
        End Property
    End Class
End Namespace
