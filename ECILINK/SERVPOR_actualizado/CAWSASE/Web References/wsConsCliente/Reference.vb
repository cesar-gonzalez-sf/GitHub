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
Namespace wsConsCliente
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.8.3752.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Web.Services.WebServiceBindingAttribute(Name:="wsConsClienteSoap", [Namespace]:="http://tempuri.org/wsConsCliente/Service1")>  _
    Partial Public Class wsConsCliente
        Inherits System.Web.Services.Protocols.SoapHttpClientProtocol
        
        Private wsConsultaClienteOperationCompleted As System.Threading.SendOrPostCallback
        
        Private useDefaultCredentialsSetExplicitly As Boolean
        
        '''<remarks/>
        Public Sub New()
            MyBase.New
            Me.Url = Global.SERVPOR.My.MySettings.Default.SRVPOL_wsConsCliente_wsConsCliente
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
        Public Event wsConsultaClienteCompleted As wsConsultaClienteCompletedEventHandler
        
        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("http://tempuri.org/wsConsCliente/Service1/wsConsultaCliente", RequestNamespace:="http://tempuri.org/wsConsCliente/Service1", ResponseNamespace:="http://tempuri.org/wsConsCliente/Service1", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)>  _
        Public Function wsConsultaCliente(ByVal nPoliza As Integer, ByVal sEmpresa As String, ByVal sUsuario As String, ByVal sContrasena As String, ByVal sRutSR As String, ByVal sNombreSR As String) As clsLinea
            Dim results() As Object = Me.Invoke("wsConsultaCliente", New Object() {nPoliza, sEmpresa, sUsuario, sContrasena, sRutSR, sNombreSR})
            Return CType(results(0),clsLinea)
        End Function
        
        '''<remarks/>
        Public Overloads Sub wsConsultaClienteAsync(ByVal nPoliza As Integer, ByVal sEmpresa As String, ByVal sUsuario As String, ByVal sContrasena As String, ByVal sRutSR As String, ByVal sNombreSR As String)
            Me.wsConsultaClienteAsync(nPoliza, sEmpresa, sUsuario, sContrasena, sRutSR, sNombreSR, Nothing)
        End Sub
        
        '''<remarks/>
        Public Overloads Sub wsConsultaClienteAsync(ByVal nPoliza As Integer, ByVal sEmpresa As String, ByVal sUsuario As String, ByVal sContrasena As String, ByVal sRutSR As String, ByVal sNombreSR As String, ByVal userState As Object)
            If (Me.wsConsultaClienteOperationCompleted Is Nothing) Then
                Me.wsConsultaClienteOperationCompleted = AddressOf Me.OnwsConsultaClienteOperationCompleted
            End If
            Me.InvokeAsync("wsConsultaCliente", New Object() {nPoliza, sEmpresa, sUsuario, sContrasena, sRutSR, sNombreSR}, Me.wsConsultaClienteOperationCompleted, userState)
        End Sub
        
        Private Sub OnwsConsultaClienteOperationCompleted(ByVal arg As Object)
            If (Not (Me.wsConsultaClienteCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg,System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent wsConsultaClienteCompleted(Me, New wsConsultaClienteCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
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
     System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://tempuri.org/wsConsCliente/Service1")>  _
    Partial Public Class clsLinea
        
        Private nPolizaField As Integer
        
        Private sUsuarioField As String
        
        Private sResultadoField As String
        
        Private dFechaSolField As String
        
        Private cAseguradoField As clsPersona
        
        Private cSujetoField As clsPersona
        
        Private cLineaNomCollectionField() As clsLineaNom
        
        Private cLineaInnField As clsLineaInn
        
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
        
        '''<remarks/>
        Public Property cLineaNomCollection() As clsLineaNom()
            Get
                Return Me.cLineaNomCollectionField
            End Get
            Set
                Me.cLineaNomCollectionField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property cLineaInn() As clsLineaInn
            Get
                Return Me.cLineaInnField
            End Get
            Set
                Me.cLineaInnField = value
            End Set
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.8.3752.0"),  _
     System.SerializableAttribute(),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://tempuri.org/wsConsCliente/Service1")>  _
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
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.8.3752.0"),  _
     System.SerializableAttribute(),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://tempuri.org/wsConsCliente/Service1")>  _
    Partial Public Class clsLineaInn
        
        Private sFechaConsField As String
        
        Private nEstadoField As Integer
        
        Private sDesEstadoField As String
        
        Private sCodigoField As String
        
        Private sFechaHastaField As String
        
        Private sCodigoAseField As String
        
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
        Public Property nEstado() As Integer
            Get
                Return Me.nEstadoField
            End Get
            Set
                Me.nEstadoField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sDesEstado() As String
            Get
                Return Me.sDesEstadoField
            End Get
            Set
                Me.sDesEstadoField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sCodigo() As String
            Get
                Return Me.sCodigoField
            End Get
            Set
                Me.sCodigoField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sFechaHasta() As String
            Get
                Return Me.sFechaHastaField
            End Get
            Set
                Me.sFechaHastaField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sCodigoAse() As String
            Get
                Return Me.sCodigoAseField
            End Get
            Set
                Me.sCodigoAseField = value
            End Set
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.8.3752.0"),  _
     System.SerializableAttribute(),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code"),  _
     System.Xml.Serialization.XmlTypeAttribute([Namespace]:="http://tempuri.org/wsConsCliente/Service1")>  _
    Partial Public Class clsLineaNom
        
        Private sVigDesdeField As String
        
        Private sVigHastaField As String
        
        Private sMatrizField As String
        
        Private sMonedaField As String
        
        Private nMontoSolicField As Integer
        
        Private nMontoField As Integer
        
        Private sEstadoField As String
        
        Private sCondicionVtaField As String
        
        Private sLineaNegField As String
        
        Private sPlazoField As String
        
        Private sObservacionField As String
        
        '''<remarks/>
        Public Property sVigDesde() As String
            Get
                Return Me.sVigDesdeField
            End Get
            Set
                Me.sVigDesdeField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sVigHasta() As String
            Get
                Return Me.sVigHastaField
            End Get
            Set
                Me.sVigHastaField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sMatriz() As String
            Get
                Return Me.sMatrizField
            End Get
            Set
                Me.sMatrizField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sMoneda() As String
            Get
                Return Me.sMonedaField
            End Get
            Set
                Me.sMonedaField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property nMontoSolic() As Integer
            Get
                Return Me.nMontoSolicField
            End Get
            Set
                Me.nMontoSolicField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property nMonto() As Integer
            Get
                Return Me.nMontoField
            End Get
            Set
                Me.nMontoField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sEstado() As String
            Get
                Return Me.sEstadoField
            End Get
            Set
                Me.sEstadoField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sCondicionVta() As String
            Get
                Return Me.sCondicionVtaField
            End Get
            Set
                Me.sCondicionVtaField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sLineaNeg() As String
            Get
                Return Me.sLineaNegField
            End Get
            Set
                Me.sLineaNegField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sPlazo() As String
            Get
                Return Me.sPlazoField
            End Get
            Set
                Me.sPlazoField = value
            End Set
        End Property
        
        '''<remarks/>
        Public Property sObservacion() As String
            Get
                Return Me.sObservacionField
            End Get
            Set
                Me.sObservacionField = value
            End Set
        End Property
    End Class
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.8.3752.0")>  _
    Public Delegate Sub wsConsultaClienteCompletedEventHandler(ByVal sender As Object, ByVal e As wsConsultaClienteCompletedEventArgs)
    
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "4.8.3752.0"),  _
     System.Diagnostics.DebuggerStepThroughAttribute(),  _
     System.ComponentModel.DesignerCategoryAttribute("code")>  _
    Partial Public Class wsConsultaClienteCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs
        
        Private results() As Object
        
        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub
        
        '''<remarks/>
        Public ReadOnly Property Result() As clsLinea
            Get
                Me.RaiseExceptionIfNecessary
                Return CType(Me.results(0),clsLinea)
            End Get
        End Property
    End Class
End Namespace
