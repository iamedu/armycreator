#include <insts/smul.h>

@implementation SmulInstruction

-(Word)execute {
	Word Rm = get_bits(_instcode,0,4);
        Word Rd = get_bits(_instcode,16,4);
        Word Rs = get_bits(_instcode,8,4);
        Word SBZ = get_bits(_instcode,12,4);
        Word x = get_bits(_instcode,5,1);
        Word y = get_bits(_instcode,6,1);
        Word operand1,operand2;

        if(!cond(_core,_instcode))
		return 0;

        if(x == 0)
                operand1 = SignExtend(get_bits([_core readReg:Rm],0,16),16);
        else
                operand1 = SignExtend(get_bits([_core readReg:Rm],16,16),16);

        if(y == 0)
                operand2 = SignExtend(get_bits([_core readReg:Rs],0,16),16);
        else
                operand2 = SignExtend(get_bits([_core readReg:Rs],16,16),16);

        [_core writeReg:Rd value:(operand1 * operand2)];
	return 0;
}

+(UWord)bitmask {
	return 0x0ff0f090;
}

+(UWord)testmask {
	return 0x01600080;
}

@end

