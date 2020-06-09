/*
 * Copyright (c) IMPERIAL S.A. All rights reserved.
 *
 * All  rights  to  this product are owned by IMPERIAL S.A. and may only be used
 * under the terms of its associated license document. You may NOT copy, modify,
 * sublicense,  or  distribute  this  source  file  or  portions  of  it  unless
 * previously  authorized  in writing by IMPERIAL S.A. In any event, this notice
 * and above copyright must always be included verbatim with this file.
 */

package cl.imperial.asignacioncontratotoken;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;

/**
 * @author ex.sf.cgonzalez
 */
public class Historico
{
    private final StringProperty NRO_CONTRATO;
    private final StringProperty DEVICE_ID;
    private final StringProperty COD_ACTIVACION;
    private final StringProperty FECHA_REG_ACTIVACION;
    private final StringProperty USUARIO_CODIGO_ACT;
    private final StringProperty FECHA_REG_DESACTIVACION;
    private final StringProperty USUARIO_CODIGO_DESA;
    private final StringProperty FECHA_REGISTRO;

    public Historico()
    {

        NRO_CONTRATO                    =   new SimpleStringProperty    (this, "NRO_CONTRATO"   , null);
        DEVICE_ID                       =   new SimpleStringProperty    (this, "DEVICE_ID"   , null);
        COD_ACTIVACION                  =   new SimpleStringProperty    (this, "COD_ACTIVACION"   , null);
        FECHA_REG_ACTIVACION            =   new SimpleStringProperty    (this, "FECHA_REG_ACTIVACION"   , null);
        USUARIO_CODIGO_ACT              =   new SimpleStringProperty    (this, "USUARIO_CODIGO_ACT"   , null);
        FECHA_REG_DESACTIVACION         =   new SimpleStringProperty    (this, "FECHA_REG_DESACTIVACION"   , null);
        USUARIO_CODIGO_DESA             =   new SimpleStringProperty    (this, "USUARIO_CODIGO_DESA"   , null);
        FECHA_REGISTRO                  =   new SimpleStringProperty    (this, "FECHA_REGISTRO"   , null);
    }




    //Numero de Contrato
    public final StringProperty NRO_CONTRATOProperty()
    {
        return NRO_CONTRATO;
    }

    public final String getNRO_CONTRATO()
    {
        return NRO_CONTRATOProperty().get();
    }

    public final void setContrato(final String value)
    {
        NRO_CONTRATOProperty().set(value);
    }

    //Divice ID
    public final StringProperty DEVICE_IDProperty()
    {
        return DEVICE_ID;
    }

    public final String getDEVICE_ID()
    {
        return DEVICE_IDProperty().get();
    }

    public final void setDevice(final String value)
    {
        DEVICE_IDProperty().set(value);
    }

    //Codigo de Activacion
    public final StringProperty COD_ACTIVACIONProperty()
    {
        return COD_ACTIVACION;
    }

    public final String getCod_actvvacion()
    {
        return COD_ACTIVACIONProperty().get();
    }

    public final void setCOD_ACTIVACION(final String value)
    {
        COD_ACTIVACIONProperty().set(value);
    }

    //Fecha Registro Activacion
    public final StringProperty FECHA_REG_ACTIVACIONProperty()
    {
        return FECHA_REG_ACTIVACION;
    }

    public final String getFECHA_REG_ACTIVACION()
    {
        return FECHA_REG_ACTIVACIONProperty().get();
    }

    public final void setFECHA_REG_ACTIVACION(final String value)
    {
        FECHA_REG_ACTIVACIONProperty().set(value);
    }

    //Usuario Codigo ActivO
    public final StringProperty USUARIO_CODIGO_ACTProperty()
    {
        return USUARIO_CODIGO_ACT;
    }

    public final String getUSUARIO_CODIGO_ACT()
    {
        return USUARIO_CODIGO_ACTProperty().get();
    }

    public final void setUSUARIO_CODIGO_ACT(final String value)
    {
        USUARIO_CODIGO_ACTProperty().set(value);
    }

    //Fecha Registro Desactivacion
    public final StringProperty FECHA_REG_DESACTIVACIONProperty()
    {
        return FECHA_REG_DESACTIVACION;
    }

    public final String getFECHA_REG_DESACTIVACION()
    {
        return FECHA_REG_DESACTIVACIONProperty().get();
    }

    public final void setFECHA_REG_DESACTIVACIO(final String value)
    {
        FECHA_REG_DESACTIVACIONProperty().set(value);
    }

    //Cidigo Usuario
    public final StringProperty USUARIO_CODIGO_DESAProperty()
    {
        return USUARIO_CODIGO_DESA;
    }

    public final String getCodigo_Usuario()
    {
        return USUARIO_CODIGO_DESAProperty().get();
    }

    public final void setUSUARIO_CODIGO_DESA(final String value)
    {
        USUARIO_CODIGO_DESAProperty().set(value);
    }

    //Fecha Registro
    public final StringProperty FECHA_REGISTROProperty()
    {
        return FECHA_REGISTRO;
    }

    public final String getFECHA_REGISTRO()
    {
        return FECHA_REGISTROProperty().get();
    }

    public final void setFECHA_REGISTRO(final String value)
    {
        FECHA_REGISTROProperty().set(value);
    }



}
