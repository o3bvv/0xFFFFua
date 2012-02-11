package ua.cn.stu.arch.oxffffua.cmd2code;

/**
 *
 * @author alex
 */
public enum CmdPrefix {

    BRA,
    JMPL,
    CALL,
    LD,
    SD,
    IN,
    OUT,
    DP,
    LI,
    RET;
    
    public static String getEncode(CmdPrefix prefix){
        switch (prefix){
            case BRA    : return "000";
            case JMPL   : return "001";
            case CALL   : return "010";
            case LD     :
            case SD     :
            case IN     :
            case OUT    : return "011";
            case DP     : return "100";
            case LI     : return "101";
            case RET    : return "110";
            default     : return "XXX";
        }
    }
}
