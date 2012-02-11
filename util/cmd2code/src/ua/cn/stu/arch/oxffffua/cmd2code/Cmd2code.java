package ua.cn.stu.arch.oxffffua.cmd2code;

import ua.cn.stu.arch.oxffffua.cmd2code.ui.MainJFrame;

/**
 *
 * @author alex
 */
public class Cmd2code {

    public static void main(String[] args) {
        java.awt.EventQueue.invokeLater(new Runnable() {

            @Override
            public void run() {
                new MainJFrame().setVisible(true);
            }
        });
    }
}
