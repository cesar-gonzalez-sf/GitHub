<%@ Language="VBScript" CodePage="1252" EnableSessionState="False" %>
<%
'++
' File generated by OBCOM Record Wizard 5.1.120
'
' Copyright (c) OBCOM INGENIERIA S.A. (Chile). All rights reserved.
'
' All  rights to this product are owned by OBCOM INGENIERIA S.A. and may only be
' used under the terms of its associated license document.  You  may  NOT  copy,
' modify,  sublicense,  or  distribute this source file or portions of it unless
' previously authorized in writing by OBCOM INGENIERIA S.A. In any  event,  this
' notice and above copyright must always be included verbatim with this file.
'
' File Name:       VALDCTO_OBTIENEDCTO_S.asp
' Creation Date:   23-Jul-2019 11:59:33
' Source Database: ECUBAS at APOLO\QACOLUMBIA, User:SavSysUser
' Library Name:    VALDCTO_LAYOUTS
' Record Name:     VALDCTO_OBTIENEDCTO_S
' Last Edition:    23-Jul-2019 11:58:56, IMPERIAL@IMPERIALXP
' Description:     Layout de Salida para Validación de Desuentos por Convenio
'-+
' APLICADO_VALE:   Indica si se aplica descuento al Vale
' DESCUENTO:       Monto de Descuento Aplicado
' MESSAGE:         Mensaje de Respuesta
' NRO_INTERNO:     Nro Interno del Vale modificado
' TOTAL:           Total Original
' TOTAL_PAGAR:     Total a Pagar
' VALIDO:          Si el Cliente Posee el Convenio a Consultar
'--
    Response.Expires = -1
    Response.CacheControl = "no-cache"
    Response.AddHeader "Pragma", "no-cache"
    Response.ContentType = "text/plain; charset=iso-8859-1"
%>
VR:1.0:VALDCTO_OBTIENEDCTO_S:2019-07-23:11:59:33
N:1:APLICADO_VALE
N:4:DESCUENTO
X:500:MESSAGE
N:11:NRO_INTERNO
N:11:TOTAL
N:11:TOTAL_PAGAR
N:1:VALIDO
CS:539:VALDCTO_OBTIENEDCTO_S:OrL3a26BJ3O0enaxVI0gbs
