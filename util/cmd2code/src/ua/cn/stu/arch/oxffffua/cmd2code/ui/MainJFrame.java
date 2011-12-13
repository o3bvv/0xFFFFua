package ua.cn.stu.arch.oxffffua.cmd2code.ui;

import java.awt.*;
import java.text.*;
import java.util.logging.*;
import javax.swing.*;
import ua.cn.stu.arch.oxffffua.cmd2code.*;

/**
 *
 * @author alex
 */
public class MainJFrame extends javax.swing.JFrame {

    private CmdPrefix cmdPrefix = CmdPrefix.BRA;
    private ConditionBRA conditionBRA = ConditionBRA.NOP;
    private CmdDP cmdDP = CmdDP.ADD;
    private DecimalFormat binAddrFormatter = new DecimalFormat("00000");
    private Color enabledColor = Color.RED;
    private Color disabledColor = Color.LIGHT_GRAY;
    private StringBuilder cmdBuilder;

    public MainJFrame() {
        initComponents();
        setLookAndFeel();
        setPositionCentered();
        setComboboxesModels();
        onPrefixSelect();
        lb_prefix.setForeground(enabledColor);
    }

    private void setLookAndFeel() {
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(MainJFrame.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(MainJFrame.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(MainJFrame.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(MainJFrame.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
    }

    private void setPositionCentered() {
        Toolkit kit = Toolkit.getDefaultToolkit();
        Dimension screenSize = kit.getScreenSize();
        int screenHeight = screenSize.height;
        int screenWidth = screenSize.width;
        this.setLocation(
                screenWidth / 2 - this.getWidth() / 2,
                screenHeight / 2 - this.getHeight() / 2);
    }

    private void setComboboxesModels() {
        cmb_prefix.setModel(new DefaultComboBoxModel(CmdPrefix.values()));
        cmb_condition.setModel(new DefaultComboBoxModel(ConditionBRA.values()));
        cmb_dp_oper.setModel(new DefaultComboBoxModel(CmdDP.values()));
        setRegistersComboboxesModels();
        setPortComboboxeModel();
    }

    private void setRegistersComboboxesModels() {
        int registersCnt = 32;
        String[] registersNumbers = new String[registersCnt];
        for (int i = 0; i < registersCnt; i++) {
            registersNumbers[i] = Integer.toString(i);
        }
        cmb_reg_b.setModel(new DefaultComboBoxModel(registersNumbers));
        cmb_reg_c.setModel(new DefaultComboBoxModel(registersNumbers));
        cmb_reg_d.setModel(new DefaultComboBoxModel(registersNumbers));
    }

    private void setPortComboboxeModel() {
        int portsCnt = 32;
        String[] portsNumbers = new String[portsCnt];
        for (int i = 0; i < portsCnt; i++) {
            portsNumbers[i] = Integer.toString(i);
        }
        DefaultComboBoxModel portsNumbersModel = new DefaultComboBoxModel(portsNumbers);
        cmb_port.setModel(portsNumbersModel);
    }

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jSplitPane1 = new javax.swing.JSplitPane();
        jPanel1 = new javax.swing.JPanel();
        cmb_prefix = new javax.swing.JComboBox();
        lb_prefix = new javax.swing.JLabel();
        lb_condition = new javax.swing.JLabel();
        cmb_condition = new javax.swing.JComboBox();
        lb_offset = new javax.swing.JLabel();
        fld_offset = new javax.swing.JFormattedTextField();
        fld_address = new javax.swing.JFormattedTextField();
        lb_address = new javax.swing.JLabel();
        lb_dp_oper = new javax.swing.JLabel();
        cmb_dp_oper = new javax.swing.JComboBox();
        lb_reg_b = new javax.swing.JLabel();
        cmb_reg_b = new javax.swing.JComboBox();
        cmb_reg_c = new javax.swing.JComboBox();
        lb_reg_c = new javax.swing.JLabel();
        cmb_reg_d = new javax.swing.JComboBox();
        lb_reg_d = new javax.swing.JLabel();
        cmb_port = new javax.swing.JComboBox();
        lb_port = new javax.swing.JLabel();
        btn_add = new javax.swing.JButton();
        lb_data = new javax.swing.JLabel();
        fld_data = new javax.swing.JFormattedTextField();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        area_result = new javax.swing.JTextArea();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("cmd2code");
        getContentPane().setLayout(new javax.swing.BoxLayout(getContentPane(), javax.swing.BoxLayout.LINE_AXIS));

        jSplitPane1.setDividerLocation(130);
        jSplitPane1.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);

        cmb_prefix.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cmb_prefixItemStateChanged(evt);
            }
        });

        lb_prefix.setText("Prefix:");

        lb_condition.setText("Cond:");

        cmb_condition.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cmb_conditionItemStateChanged(evt);
            }
        });

        lb_offset.setText("Offset:");

        fld_offset.setColumns(10);
        fld_offset.setFormatterFactory(new javax.swing.text.DefaultFormatterFactory(new javax.swing.text.NumberFormatter(new java.text.DecimalFormat("0000000000"))));
        fld_offset.setText("0000000000");

        fld_address.setColumns(11);
        fld_address.setFormatterFactory(new javax.swing.text.DefaultFormatterFactory(new javax.swing.text.NumberFormatter(new java.text.DecimalFormat("00000000000"))));
        fld_address.setText("00000000000");

        lb_address.setText("Address:");

        lb_dp_oper.setText("DP oper:");

        cmb_dp_oper.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cmb_dp_operItemStateChanged(evt);
            }
        });

        lb_reg_b.setText("REG B:");

        lb_reg_c.setText("REG C:");

        lb_reg_d.setText("REG D:");

        lb_port.setText("PORT:");

        btn_add.setText("Add code");
        btn_add.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_addActionPerformed(evt);
            }
        });

        lb_data.setText("Data:");

        fld_data.setColumns(16);
        fld_data.setFormatterFactory(new javax.swing.text.DefaultFormatterFactory(new javax.swing.text.NumberFormatter(new java.text.DecimalFormat("0000000000000000"))));
        fld_data.setText("0000000000000000");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(cmb_prefix, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(lb_prefix))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(lb_condition)
                    .addComponent(cmb_condition, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(lb_dp_oper)
                    .addComponent(cmb_dp_oper, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(cmb_reg_b, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(lb_reg_b))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(cmb_reg_c, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(lb_reg_c)))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(cmb_reg_d, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(lb_reg_d))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(cmb_port, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(lb_port))))
                .addGap(18, 18, 18)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(lb_address)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(fld_address, javax.swing.GroupLayout.PREFERRED_SIZE, 99, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(lb_offset)
                            .addComponent(fld_offset, javax.swing.GroupLayout.PREFERRED_SIZE, 99, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(lb_data)
                            .addComponent(btn_add)
                            .addComponent(fld_data, javax.swing.GroupLayout.DEFAULT_SIZE, 135, Short.MAX_VALUE))))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(lb_reg_b)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(cmb_reg_b, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(lb_reg_c)
                                    .addComponent(lb_offset)
                                    .addComponent(lb_data))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(cmb_reg_c, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(fld_offset, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(fld_data, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(lb_reg_d)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(cmb_reg_d, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(lb_port)
                                    .addComponent(lb_address))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(cmb_port, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(fld_address, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(btn_add)))))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(lb_prefix)
                            .addComponent(lb_condition))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(cmb_prefix, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(cmb_condition, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(8, 8, 8)
                        .addComponent(lb_dp_oper)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(cmb_dp_oper, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jSplitPane1.setTopComponent(jPanel1);

        area_result.setColumns(20);
        area_result.setRows(5);
        jScrollPane1.setViewportView(area_result);

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 518, Short.MAX_VALUE)
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 105, Short.MAX_VALUE)
        );

        jSplitPane1.setRightComponent(jPanel2);

        getContentPane().add(jSplitPane1);

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void cmb_prefixItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cmb_prefixItemStateChanged
        onPrefixSelect();
    }//GEN-LAST:event_cmb_prefixItemStateChanged

    private void onPrefixSelect() {
        cmdPrefix = CmdPrefix.valueOf(cmb_prefix.getSelectedItem().toString());
        switch (cmdPrefix) {
            case BRA:
                onPrefix_BRA_Select();
                break;

            case JMPL:
            case CALL:
                onPrefix_JMPL_CALL_Select();
                break;
            case LD:
                onPrefix_LD_Select();
                break;
            case SD:
                onPrefix_SD_Select();
                break;
            case IN:
                onPrefix_IN_Select();
                break;
            case OUT:
                onPrefix_OUT_Select();
                break;
            case DP:
                onPrefix_DP_Select();
                break;
            case LI:
                onPrefix_LI_Select();
                break;
            case RET:
                onPrefix_RET_Select();
                break;
        }
    }

    private void onPrefix_BRA_Select() {
        cmb_condition.setEnabled(true);
        fld_offset.setEnabled(true);

        cmb_dp_oper.setEnabled(false);
        cmb_reg_b.setEnabled(false);
        cmb_reg_c.setEnabled(false);
        cmb_reg_d.setEnabled(false);
        cmb_port.setEnabled(false);
        fld_address.setEnabled(false);
        fld_data.setEnabled(false);

        lb_condition.setForeground(enabledColor);
        lb_offset.setForeground(enabledColor);

        lb_address.setForeground(disabledColor);
        lb_dp_oper.setForeground(disabledColor);
        lb_reg_b.setForeground(disabledColor);
        lb_reg_c.setForeground(disabledColor);
        lb_reg_d.setForeground(disabledColor);
        lb_port.setForeground(disabledColor);
        lb_data.setForeground(disabledColor);
    }

    private void onPrefix_JMPL_CALL_Select() {
        fld_address.setEnabled(true);

        cmb_condition.setEnabled(false);
        fld_offset.setEnabled(false);
        cmb_dp_oper.setEnabled(false);
        cmb_reg_b.setEnabled(false);
        cmb_reg_c.setEnabled(false);
        cmb_reg_d.setEnabled(false);
        cmb_port.setEnabled(false);
        fld_data.setEnabled(false);

        lb_address.setForeground(enabledColor);

        lb_condition.setForeground(disabledColor);
        lb_offset.setForeground(disabledColor);
        lb_dp_oper.setForeground(disabledColor);
        lb_reg_b.setForeground(disabledColor);
        lb_reg_c.setForeground(disabledColor);
        lb_reg_d.setForeground(disabledColor);
        lb_port.setForeground(disabledColor);
        lb_data.setForeground(disabledColor);
    }

    private void onPrefix_LD_Select() {
        cmb_reg_b.setEnabled(true);
        cmb_reg_c.setEnabled(true);

        fld_address.setEnabled(false);
        cmb_condition.setEnabled(false);
        fld_offset.setEnabled(false);
        cmb_dp_oper.setEnabled(false);
        cmb_port.setEnabled(false);
        cmb_reg_d.setEnabled(false);
        fld_data.setEnabled(false);

        lb_reg_b.setForeground(enabledColor);
        lb_reg_c.setForeground(enabledColor);

        lb_address.setForeground(disabledColor);
        lb_condition.setForeground(disabledColor);
        lb_offset.setForeground(disabledColor);
        lb_dp_oper.setForeground(disabledColor);
        lb_port.setForeground(disabledColor);
        lb_reg_d.setForeground(disabledColor);
        lb_data.setForeground(disabledColor);
    }

    private void onPrefix_SD_Select() {
        cmb_reg_d.setEnabled(true);
        cmb_reg_c.setEnabled(true);

        fld_address.setEnabled(false);
        cmb_condition.setEnabled(false);
        fld_offset.setEnabled(false);
        cmb_dp_oper.setEnabled(false);
        cmb_port.setEnabled(false);
        cmb_reg_b.setEnabled(false);
        fld_data.setEnabled(false);

        lb_reg_d.setForeground(enabledColor);
        lb_reg_c.setForeground(enabledColor);

        lb_address.setForeground(disabledColor);
        lb_condition.setForeground(disabledColor);
        lb_offset.setForeground(disabledColor);
        lb_dp_oper.setForeground(disabledColor);
        lb_port.setForeground(disabledColor);
        lb_reg_b.setForeground(disabledColor);
        lb_data.setForeground(disabledColor);
    }

    private void onPrefix_IN_Select() {
        cmb_reg_b.setEnabled(true);
        cmb_port.setEnabled(true);

        fld_address.setEnabled(false);
        cmb_condition.setEnabled(false);
        fld_offset.setEnabled(false);
        cmb_dp_oper.setEnabled(false);
        cmb_reg_c.setEnabled(false);
        cmb_reg_d.setEnabled(false);
        fld_data.setEnabled(false);

        lb_reg_b.setForeground(enabledColor);
        lb_port.setForeground(enabledColor);

        lb_address.setForeground(disabledColor);
        lb_condition.setForeground(disabledColor);
        lb_offset.setForeground(disabledColor);
        lb_dp_oper.setForeground(disabledColor);
        lb_reg_c.setForeground(disabledColor);
        lb_reg_d.setForeground(disabledColor);
        lb_data.setForeground(disabledColor);
    }

    private void onPrefix_OUT_Select() {
        cmb_reg_d.setEnabled(true);
        cmb_port.setEnabled(true);

        fld_address.setEnabled(false);
        cmb_condition.setEnabled(false);
        fld_offset.setEnabled(false);
        cmb_dp_oper.setEnabled(false);
        cmb_reg_c.setEnabled(false);
        cmb_reg_b.setEnabled(false);
        fld_data.setEnabled(false);

        lb_reg_d.setForeground(enabledColor);
        lb_port.setForeground(enabledColor);

        lb_address.setForeground(disabledColor);
        lb_condition.setForeground(disabledColor);
        lb_offset.setForeground(disabledColor);
        lb_dp_oper.setForeground(disabledColor);
        lb_reg_c.setForeground(disabledColor);
        lb_reg_b.setForeground(disabledColor);
        lb_data.setForeground(disabledColor);
    }

    private void onPrefix_DP_Select() {
        cmb_dp_oper.setEnabled(true);
        cmb_reg_b.setEnabled(true);
        cmb_reg_c.setEnabled(true);
        cmb_reg_d.setEnabled(true);

        cmb_port.setEnabled(false);
        fld_address.setEnabled(false);
        cmb_condition.setEnabled(false);
        fld_offset.setEnabled(false);
        fld_data.setEnabled(false);

        lb_dp_oper.setForeground(enabledColor);
        lb_reg_b.setForeground(enabledColor);
        lb_reg_c.setForeground(enabledColor);
        lb_reg_d.setForeground(enabledColor);

        lb_port.setForeground(disabledColor);
        lb_address.setForeground(disabledColor);
        lb_condition.setForeground(disabledColor);
        lb_offset.setForeground(disabledColor);
        lb_data.setForeground(disabledColor);
        
        onDPselect();
    }

    private void onPrefix_LI_Select() {
        cmb_reg_b.setEnabled(true);
        fld_data.setEnabled(true);

        cmb_port.setEnabled(false);
        fld_address.setEnabled(false);
        cmb_condition.setEnabled(false);
        fld_offset.setEnabled(false);
        cmb_dp_oper.setEnabled(false);
        cmb_reg_c.setEnabled(false);
        cmb_reg_d.setEnabled(false);

        lb_reg_b.setForeground(enabledColor);
        lb_data.setForeground(enabledColor);

        lb_port.setForeground(disabledColor);
        lb_address.setForeground(disabledColor);
        lb_condition.setForeground(disabledColor);
        lb_offset.setForeground(disabledColor);
        lb_dp_oper.setForeground(disabledColor);
        lb_reg_c.setForeground(disabledColor);
        lb_reg_d.setForeground(disabledColor);
    }

    private void onPrefix_RET_Select() {
        cmb_reg_b.setEnabled(false);
        fld_data.setEnabled(false);
        cmb_port.setEnabled(false);
        fld_address.setEnabled(false);
        cmb_condition.setEnabled(false);
        fld_offset.setEnabled(false);
        cmb_dp_oper.setEnabled(false);
        cmb_reg_c.setEnabled(false);
        cmb_reg_d.setEnabled(false);

        lb_reg_b.setForeground(disabledColor);
        lb_data.setForeground(disabledColor);
        lb_port.setForeground(disabledColor);
        lb_address.setForeground(disabledColor);
        lb_condition.setForeground(disabledColor);
        lb_offset.setForeground(disabledColor);
        lb_dp_oper.setForeground(disabledColor);
        lb_reg_c.setForeground(disabledColor);
        lb_reg_d.setForeground(disabledColor);
    }

    private void btn_addActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_addActionPerformed
        try {
            cmdBuilder = new StringBuilder();
            cmdBuilder.append(CmdPrefix.getEncode(cmdPrefix));

            switch (cmdPrefix) {
                case BRA:
                    build_BRA();
                    break;
                case JMPL:
                case CALL:
                    build_JMPL_CALL();
                    break;
                case LD:
                    build_LD();
                    break;
                case SD:
                    build_SD();
                    break;
                case IN:
                    build_IN();
                    break;
                case OUT:
                    build_OUT();
                    break;
                case DP:
                    build_DP();
                    break;
                case LI:
                    build_LI();
                    break;
                case RET:
                    build_RET();
                    break;
            }

            cmdBuilder.append('\n');
            area_result.setText(area_result.getText() + cmdBuilder.toString());
        } catch (ParseException ex) {
            Logger.getLogger(MainJFrame.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_btn_addActionPerformed

    private void build_BRA() throws ParseException {
        cmdBuilder.append(ConditionBRA.getEncode(conditionBRA));
        cmdBuilder.append(fld_offset.getFormatter().valueToString(fld_offset.getValue()));
    }

    private void build_JMPL_CALL() throws ParseException {
        cmdBuilder.append("00");
        cmdBuilder.append(fld_address.getFormatter().valueToString(fld_address.getValue()));
    }
    
    private void build_LD(){
        cmdBuilder.append("000");
        cmdBuilder.append(comboValueToBinString(cmb_reg_b));
        cmdBuilder.append(comboValueToBinString(cmb_reg_c));
    }
    
    private void build_SD(){
        cmdBuilder.append("010");
        cmdBuilder.append("00000");
        cmdBuilder.append(comboValueToBinString(cmb_reg_c));
        cmdBuilder.append(" ");
        cmdBuilder.append("00000000000");
        cmdBuilder.append(comboValueToBinString(cmb_reg_d));
    }
    
    private void build_IN(){
        cmdBuilder.append("100");
        cmdBuilder.append(comboValueToBinString(cmb_reg_b));
        cmdBuilder.append("00000");
        cmdBuilder.append(" ");
        cmdBuilder.append("000000");
        cmdBuilder.append(comboValueToBinString(cmb_port));
        cmdBuilder.append("00000");
    }
    
    private void build_OUT(){
        cmdBuilder.append("110");
        cmdBuilder.append("00000");
        cmdBuilder.append("00000");
        cmdBuilder.append(" ");
        cmdBuilder.append("000000");
        cmdBuilder.append(comboValueToBinString(cmb_port));
        cmdBuilder.append(comboValueToBinString(cmb_reg_d));
    }
    
    private void build_DP(){
        cmdBuilder.append("000");
        cmdBuilder.append(comboValueToBinString(cmb_reg_b));
        cmdBuilder.append(comboValueToBinString(cmb_reg_c));
        cmdBuilder.append(" ");
        cmdBuilder.append(CmdDP.getEncode(cmdDP));
        cmdBuilder.append("0");
        cmdBuilder.append("00000");
        
        if (cmdDP.equals(CmdDP.CPY)){
            cmdBuilder.append("00000");
        } else {
            cmdBuilder.append(comboValueToBinString(cmb_reg_d));
        }
    }
    
    private void build_LI() throws ParseException{
        cmdBuilder.append("000");
        cmdBuilder.append(comboValueToBinString(cmb_reg_b));
        cmdBuilder.append("00000");
        cmdBuilder.append(" ");
        cmdBuilder.append(fld_data.getFormatter().valueToString(fld_data.getValue()));
    }
    
    private void build_RET(){
        cmdBuilder.append("000");
        cmdBuilder.append("00000");
        cmdBuilder.append("00000");
    }
    
    private String comboValueToBinString(JComboBox box){
        int iValue = Integer.parseInt(box.getSelectedItem().toString());
        String sBinValue = Integer.toBinaryString(iValue);
        return binAddrFormatter.format(Integer.parseInt(sBinValue)).toString();        
    }
    
    private void cmb_conditionItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cmb_conditionItemStateChanged
        conditionBRA = ConditionBRA.valueOf(cmb_condition.getSelectedItem().toString());
    }//GEN-LAST:event_cmb_conditionItemStateChanged

    private void onDPselect(){
        cmdDP = CmdDP.valueOf(cmb_dp_oper.getSelectedItem().toString());
        
        if (cmdDP.equals(CmdDP.CPY)){
            lb_reg_d.setForeground(disabledColor);
            cmb_reg_d.setEnabled(false);
        } else {
            lb_reg_d.setForeground(enabledColor);
            cmb_reg_d.setEnabled(true);
        }
    }
    
    private void cmb_dp_operItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cmb_dp_operItemStateChanged
        onDPselect();                        
    }//GEN-LAST:event_cmb_dp_operItemStateChanged
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTextArea area_result;
    private javax.swing.JButton btn_add;
    private javax.swing.JComboBox cmb_condition;
    private javax.swing.JComboBox cmb_dp_oper;
    private javax.swing.JComboBox cmb_port;
    private javax.swing.JComboBox cmb_prefix;
    private javax.swing.JComboBox cmb_reg_b;
    private javax.swing.JComboBox cmb_reg_c;
    private javax.swing.JComboBox cmb_reg_d;
    private javax.swing.JFormattedTextField fld_address;
    private javax.swing.JFormattedTextField fld_data;
    private javax.swing.JFormattedTextField fld_offset;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JSplitPane jSplitPane1;
    private javax.swing.JLabel lb_address;
    private javax.swing.JLabel lb_condition;
    private javax.swing.JLabel lb_data;
    private javax.swing.JLabel lb_dp_oper;
    private javax.swing.JLabel lb_offset;
    private javax.swing.JLabel lb_port;
    private javax.swing.JLabel lb_prefix;
    private javax.swing.JLabel lb_reg_b;
    private javax.swing.JLabel lb_reg_c;
    private javax.swing.JLabel lb_reg_d;
    // End of variables declaration//GEN-END:variables
}
