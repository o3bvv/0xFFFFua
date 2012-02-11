package ua.cn.stu.arch.oxffffua.cmd2code;

/**
 *
 * @author alex
 */
public enum ConditionBRA {

    NOP,
    JMP,
    JE,
    JNE,
    JC,
    JNC,
    JA,
    JB;
    
    public static String getEncode(ConditionBRA condition){
        switch (condition){
            case NOP    : return "000";
            case JMP    : return "001";
            case JE     : return "010";
            case JNE    : return "011";
            case JC     : return "100";
            case JNC    : return "101";
            case JA     : return "110";
            case JB     : return "111";
            default     : return "XXX";
        }
    }
}
