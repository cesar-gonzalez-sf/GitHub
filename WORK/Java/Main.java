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

import cl.obcom.desktopfx.core.DesktopTask;
import cl.obcom.desktopfx.jfx.Dialog;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.ToggleGroup;
import javafx.scene.input.KeyCode;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;
import javafx.scene.layout.VBox;

/**
 * @author ex.sf.cgonzalez
 */
public final class Main extends VBox
{

    Label lblLabel = new Label();
    public TextField txtRut = new TextField();
    public TextField txtName = new TextField();
    public TextField txtMail = new TextField();
    public TextField txtTlf = new TextField();
    public TextField txtNContr = new TextField();
    public Button aceptarButton = new Button("Aceptar");
    public Button cerrarButton = new Button(" Cerrar ");
    public ToggleGroup ToggleGroup = new ToggleGroup();
    public RadioButton radioFun = new RadioButton();
    public RadioButton radioCliente = new RadioButton();
    public CheckBox checkBoxClave = new CheckBox("Activar Clave");

    public Main(final DesktopTask task)
        throws Exception
    {
        // Inicializamos VBox Properties
        setPadding(new Insets(0, 0, 0, 0));
        setPrefHeight(600);
        setPrefWidth(660);
        setSpacing(0);

        /// Crearmos RadioBotton para verificar rol

        final HBox cajaHBox = new HBox();
        {
            /// Inicializamos caja1HBox
            cajaHBox.setSpacing(100);
            cajaHBox.setPrefHeight(100);
            cajaHBox.setPrefWidth(600);
            cajaHBox.setPadding(new Insets(10, 10, 10, 170));

            final RadioButton radioFun = new RadioButton("Funcionario");
            radioFun.setToggleGroup(ToggleGroup);
            final RadioButton radioCliente = new RadioButton("Cliente");
            radioCliente.setToggleGroup(ToggleGroup);
            // rb2.setSelected(true);
            cajaHBox.getChildren().addAll(radioFun, radioCliente);
        }

        /// Creamos el VBox de informacion de Cliente Caja 1
        final HBox caja1HBox = new HBox();
        {
            /// Inicializamos caja1HBox
            caja1HBox.setSpacing(0);
            caja1HBox.setPrefHeight(110);
            caja1HBox.setPrefWidth(600);
            caja1HBox.setPadding(new Insets(0, 0, 0, 20));
            caja1HBox.setStyle("-fx-background-color: #f5f5f5;");

            //// Creamos caja_1VBox
            final VBox caja_1VBox = new VBox();
            {
                //// Inicializadmos caja_1VBox
                caja_1VBox.setPrefHeight(200);
                caja_1VBox.setPrefWidth(350);
                caja_1VBox.setSpacing(10);
                caja_1VBox.setPadding(new Insets(10, 10, 10, 20));

                lblLabel = new Label("Rut");
                txtRut.setMaxWidth(200);
                txtRut.setOnKeyPressed(e -> actionPerformed(txtRut.getText(), e));
                caja_1VBox.getChildren().addAll(lblLabel, txtRut);

                lblLabel = new Label("Nombre");
                txtName.setMaxWidth(260);
                caja_1VBox.getChildren().addAll(lblLabel, txtName);

            }

            //// Creamos caja_2VBox
            final VBox caja_2VBox = new VBox();
            {
                //// Inicializadmos caja_2VBox
                caja_2VBox.setPrefHeight(200);
                caja_2VBox.setPrefWidth(350);
                caja_2VBox.setSpacing(10);
                caja_2VBox.setPadding(new Insets(10, 10, 10, 20));

                lblLabel = new Label("Mail");
                txtMail.setMaxWidth(260);
                caja_2VBox.getChildren().addAll(lblLabel, txtMail);

                lblLabel = new Label("Telefono");
                txtTlf.setMaxWidth(260);
                caja_2VBox.getChildren().addAll(lblLabel, txtTlf);
            }
            caja1HBox.getChildren().addAll(caja_1VBox, caja_2VBox);

        }

        /// Creamos el VBox de informacion de Cliente Caja 2
        final HBox caja2HBox = new HBox();
        {
            /// Inicializamos caja2HBox
            caja2HBox.setPrefHeight(100);
            caja2HBox.setPrefWidth(600);

            //// Creamos caja_2VBox
            final VBox caja_2VBox = new VBox();
            {
                //// Inicializadmos caja_2VBox
                caja_2VBox.setPrefHeight(200);
                caja_2VBox.setPrefWidth(660);
                caja2HBox.getChildren().add(caja_2VBox);

                ///// Creamos caja_2_1HBox
                final HBox caja_2_1HBox = new HBox();
                {
                    ///// Inicializadmos caja_2_1HBox
                    caja_2_1HBox.setPrefHeight(100);
                    caja_2_1HBox.setPrefWidth(600);

                    ////// Creamos caja_2_1_1VBox
                    final VBox caja_2_1_1VBox = new VBox();
                    {
                        ////// Inicializadmos caja_2_1_1VBox
                        caja_2_1_1VBox.setSpacing(10);
                        caja_2_1_1VBox.setPrefHeight(100);
                        caja_2_1_1VBox.setPrefWidth(300);
                        caja_2_1_1VBox.setPadding(new Insets(10, 10, 10, 40));

                        lblLabel = new Label("N° Contrato");
                        txtNContr.setMaxWidth(260);
                        caja_2_1_1VBox.getChildren().addAll(lblLabel, txtNContr);
                    }

                    ////// Creamos caja_2_1_2VBox
                    final VBox caja_2_1_2VBox = new VBox();
                    {
                        ////// Inicializamosm caja_2_1_2VBox
                        caja_2_1_2VBox.setSpacing(10);
                        caja_2_1_2VBox.setPrefHeight(100);
                        caja_2_1_2VBox.setPrefWidth(300);
                        caja_2_1_2VBox.setPadding(new Insets(37, 10, 10, 60));
                        caja_2_1_2VBox.getChildren().add(checkBoxClave);
                    }
                    caja_2VBox.getChildren().add(caja_2_1HBox);
                    caja_2_1HBox.getChildren().addAll(caja_2_1_1VBox, caja_2_1_2VBox);
                }

                /// Creamos el HBox de los Button Aceptar y Cerrar
                final HBox buttonsHBox = new HBox();
                {
                    // Inicializamos buttonsHBox
                    buttonsHBox.setSpacing(20);
                    buttonsHBox.setAlignment(Pos.CENTER);
                    buttonsHBox.setPrefHeight(100);
                    buttonsHBox.setPrefWidth(700);
                    buttonsHBox.setPadding(new Insets(10, 50, 10, 10));
                    buttonsHBox.setStyle("-fx-background-color: #f5f5f5;");

                    // Creamos e inicializamos aceptarButton
                    aceptarButton.setOnAction(null);
                    buttonsHBox.getChildren().add(aceptarButton);

                    // Creamos e inicializamos cerrarButton
                    cerrarButton.setOnAction(null);
                    buttonsHBox.getChildren().add(cerrarButton);
                    caja_2VBox.getChildren().add(buttonsHBox);
                }
            }
        }

        /// Creamos el HBox Grilla
        final HBox caja3HBox = new HBox();
        {
            /// Inicializamos caja3HBox
            caja3HBox.setPrefHeight(200);
            caja3HBox.setStyle("-fx-background-color: #f5f5f5;");

            final VBox HDVBox = new VBox();
            {
                //// Inicializamos HDBox
                HDVBox.setSpacing(10);
                HDVBox.setPrefHeight(200);
                HDVBox.setPrefWidth(660);

                //// Creamos el Label HDText
                lblLabel = new Label("Historico de Dispositivos");
                lblLabel.setStyle("-fx-background-color: #ffffff; -fx-font-weight:bold;");
                lblLabel.setPrefWidth(660);
                lblLabel.setPadding(new Insets(0, 0, 0, 240));

                ////bcreate and initialize HistoricoDispositivos_Table
                final TableView<Historico> HistoricoDispositivos_Table = new TableView<>();

                //// Inicializamos tabla HistoricoDispositivos_Table
                HistoricoDispositivos_Table.setEditable(true);
                VBox.setVgrow(HistoricoDispositivos_Table, Priority.ALWAYS);

                //// Create and initialize "selectedCol" column
                final TableColumn<Historico, String> ContratoCol = new TableColumn<>("Contrato");
                {
                    ContratoCol.setCellValueFactory(f -> f.getValue().NRO_CONTRATOProperty());
                }
                final TableColumn<Historico, String> DeviceCol = new TableColumn<>("Dispositivo");
                {
                    DeviceCol.setCellValueFactory(f -> f.getValue().DEVICE_IDProperty());
                }
                final TableColumn<Historico, String> Cod_activacionCol = new TableColumn<>("Codigo");
                {
                    Cod_activacionCol.setCellValueFactory(f -> f.getValue().COD_ACTIVACIONProperty());
                }
                final TableColumn<Historico, String> Fecha_ActivacionCol = new TableColumn<>("FechaActiva");
                {
                    Fecha_ActivacionCol.setCellValueFactory(f -> f.getValue().FECHA_REG_ACTIVACIONProperty());
                }
                final TableColumn<Historico, String> Usuario_ActivaCol = new TableColumn<>("UsuarioActivo");
                {
                    Usuario_ActivaCol.setCellValueFactory(f -> f.getValue().USUARIO_CODIGO_ACTProperty());
                }
                final TableColumn<Historico, String> Fecha_DesactivaCol = new TableColumn<>("FechaDesactiva");
                {
                    Fecha_DesactivaCol.setCellValueFactory(f -> f.getValue().FECHA_REG_DESACTIVACIONProperty());
                }
                final TableColumn<Historico, String> Usuario_DesactivoCol = new TableColumn<>("UsuarioDesactivo");
                {
                    Usuario_DesactivoCol.setPrefWidth(100);
                    Usuario_DesactivoCol.setCellValueFactory(f -> f.getValue().USUARIO_CODIGO_DESAProperty());
                }
                final TableColumn<Historico, String> Fecha_RegistroCol = new TableColumn<>("FechaRegistro");
                {
                    Fecha_RegistroCol.setCellValueFactory(f -> f.getValue().USUARIO_CODIGO_DESAProperty());
                }
                HistoricoDispositivos_Table.getColumns().addAll(ContratoCol, DeviceCol, Cod_activacionCol, Fecha_ActivacionCol, Usuario_ActivaCol, Fecha_DesactivaCol, Usuario_DesactivoCol, Fecha_RegistroCol);

                HistoricoDispositivos_Table.setStyle(" -fx-font-weight:bold; -fx-font-size: 10px;");
                HistoricoDispositivos_Table.setMinHeight(270);
                HDVBox.getChildren().addAll(lblLabel, HistoricoDispositivos_Table);
            }
            caja3HBox.getChildren().add(HDVBox);
        }
        getChildren().addAll(cajaHBox, caja1HBox, caja2HBox, caja3HBox);

    }

    //--------------------------------------------------------------------------
    //-- Event Handler Methods -------------------------------------------------
    //--------------------------------------------------------------------------
    //----- Action para validar un Rut -----------------------------------------

    public void actionPerformed(final String Rut, final javafx.scene.input.KeyEvent e)
    {
        if (e.getCode() == KeyCode.ENTER || e.getCode() == KeyCode.TAB || e.getCode() == null) {
            try {

                final boolean vValidate = clsUtilitarios.validarRut(Rut);

                if (vValidate == true) {

                    final String vDV = Rut.substring(Rut.length() - 1);
                    final String vRutSinDV = Rut.substring(0, (Rut.length() - 1));
                    Dialog.showMessage(this, "Rut Valido " + vRutSinDV + " " + vDV);
                } else {
                    Dialog.showMessage(this, "Rut Invalido.");
                }

            } catch (final Throwable thrown) {
                Dialog.showError(this, thrown);
            }
        }
    }

}
