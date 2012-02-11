package ua.cn.stu.arch.oxffffua.cmd2code;

/**
 *
 * @author alex
 */
public enum CmdDP {

    ADD,
    ADDC,
    SUB,
    SUBC,
    MUL,
    DIV,
    NEG,
    AND,
    OR,
    XOR,
    TEST,
    CMP,
    SL0,
    SL1,
    SR0,
    SR1,
    SLC,
    SRC,
    SLX,
    SRX,
    RL,
    RR,
    CPY;
    
    public static String getEncode(CmdDP cmd){
        switch (cmd){            
            case ADD    : return "00000";
            case NEG    : return "00010";
            case XOR    : return "00011";
            case AND    : return "00100";
            case TEST   : return "00101";
            case CPY    : return "00111";
            case SUB    : return "01000";
            case CMP    : return "01001";
            case MUL    : return "01010";
            case DIV    : return "01011";
            case OR     : return "01100";
            case RL     : return "10000";
            case ADDC   : return "10001";
            case SL0    : return "10100";
            case SR0    : return "10101";
            case SLX    : return "10110";
            case SLC    : return "10111";
            case RR     : return "11000";
            case SUBC   : return "11001";
            case SL1    : return "11100";
            case SR1    : return "11101";
            case SRX    : return "11110";
            case SRC    : return "11111";
            default     : return "XXXXX";
        }
    }
}
