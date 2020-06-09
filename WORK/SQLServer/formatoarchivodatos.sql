SELECT  -- Header fields --------------
            PAIS,
            COMERCIO,
            FUNCION,
            ORIGEN,
            FECHA,
            HORA,
            SUCURSAL,
            TERMINAL,
            SECUENCIA,
            AUTPREVIA,
            MODTRAN,
            -- Request/Reply fields -------
            PAN,
            TIPDOCID,
            NUMDOCID,
            MONEDA,
            CAMBIO,
            MODPAGO,
            PLAZO,
            MONTO,
            CUOTAS,
            -- Request fields -------------
            ABONO,
            TIPDOCVTA,
            NUMDOCVTA,
            CAJERO,
            CONVENIO,
            PRODUCTO,
            PLAZA,
            CHEQUE,
            BANCO,
            GIRADOR,
            FECCON,
            -- Reply fields ---------------
            REPLY_TIME,
            RESPUESTA,
            MOTIVO,
            AUTORIZACION,
            VALOR,
            -- Negativos fields -----------
            NEG_FECHA,
            NEG_CORREL,
            -- Event fields ---------------
            ID,
            EVENT_KEY
    FROM  SAV_CJ.dbo.FALCMR3_JOURNAL
    WHERE FECHA = '20191008'
    ORDER BY HORA
